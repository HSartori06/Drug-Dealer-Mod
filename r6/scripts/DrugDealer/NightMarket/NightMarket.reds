module DrugDealer.NightMarket

import DrugDealer.Settings.{Constants, SettingsSystem, IsMainAction}
import NightlyNow.Utils.ProximityDetector
import NightlyNow.Notification.{NotificationSystem, SideNotification, SideNotificationStyle}
import NightlyNow.Utils.{IsNomad}

// -----------------------------------------------------------------------------
// NightMarket - Drug Dealer
// -----------------------------------------------------------------------------
// Delay callback for periodic proximity checks
public class NightMarketCheckCallback extends DelayCallback {
    public let controller: wref<NightMarketInteractionController>;

    public func Call() {
        if IsDefined(this.controller) {
            this.controller.OnProximityCheck();
        }
    }
}

// Checks player proximity to nightmarket locations and shows interaction
public class NightMarketInteractionController extends ScriptableSystem {
    private let proximityDetector: ref<ProximityDetector>;
    private let isRunning: Bool;
    private let wasNearBefore: Bool;
    private let nearNightMarketLocation: wref<NightMarketLocation>;
    // Lazy eval
    private let settingsSystem: wref<SettingsSystem>;

    public static func Get() -> ref<NightMarketInteractionController> {
        return GameInstance
            .GetScriptableSystemsContainer(GetGameInstance())
            .Get(n"DrugDealer.NightMarket.NightMarketInteractionController") as NightMarketInteractionController;
    }

    // Lazy eval
    private func GetSettingsSystem() -> wref<SettingsSystem> {
        if !IsDefined(this.settingsSystem) {
            this.settingsSystem = SettingsSystem.Get();
        }
        return this.settingsSystem;
    }

    // Start polling for player proximity
    public func Start() {
        if this.isRunning {
            return;
        }
        this.isRunning = true;

        let mainInteractionTitle = GetLocalizedTextByKey(n"DD.NightMarket.InteractionTitle");
        let interactionActions = Constants.InputRegisteredActions();

        this.proximityDetector = ProximityDetector.Create(mainInteractionTitle, interactionActions[0], 0.25, true, 2.5);
        this.QueueCheck();
    }

    // Stop polling and hide interaction
    public func Stop() {
        this.isRunning = false;
        this.proximityDetector.HideInteraction();
        this.proximityDetector.CancelProximityCheck();
    }

    // Periodic check - show/hide interaction based on proximity
    public func OnProximityCheck() {
        this.nearNightMarketLocation = null;

        let nightMarketSystem = NightMarketSystem.Get();
        if !IsDefined(nightMarketSystem) {
            return;
        }
        for nightMarketLocation in nightMarketSystem.GetEligibleNightMarketLocations() {
            if this
                .proximityDetector
                .IsPlayerNearPosition(nightMarketLocation.location) {
                this.nearNightMarketLocation = nightMarketLocation;
                break;
            }
        }

        let isNear = IsDefined(this.nearNightMarketLocation);

        // Side notification
        let notificationSystem = NotificationSystem.Get();
        if !IsDefined(notificationSystem) {
            return;
        }
        if !this.wasNearBefore && isNear {
            // Show side notifications
            notificationSystem
                .ShowSideNotification(this.GetSideNotification(this.nearNightMarketLocation));
        } else if this.wasNearBefore && !isNear {
            // Hide side notifications
            notificationSystem.HideSideNotification();
        }

        this.proximityDetector.UpdateProximity(isNear);
        this.wasNearBefore = isNear;
        this.QueueCheck();
    }

    public func IsInteractionShown() -> Bool = this.proximityDetector.IsInteractionShown();

    public func GetNearNightMarketLocation() -> wref<NightMarketLocation> = this.nearNightMarketLocation;

    private func QueueCheck() {
        let nightMarketCheckCallback = new NightMarketCheckCallback();
        nightMarketCheckCallback.controller = this;
        this.proximityDetector.QueueProximityCheck(nightMarketCheckCallback);
    }

    public func GetSideNotification(nightMarketLocation: wref<NightMarketLocation>) -> SideNotification {
        if !IsDefined(nightMarketLocation) {
            return SideNotification([], []);
        }

        let settings = this.GetSettingsSystem();
        if !IsDefined(settings) {
            return SideNotification([], []);
        }

        let texts: array<String>;
        let styles: array<SideNotificationStyle>;

        // Price of a crate
        let cratePriceMsg = StrReplace(
            GetLocalizedTextByKey(n"DD.NightMarket.PriceOfCrate"),
            "{0}",
            s"\(settings.NightMarketCratePrice())"
        );
        ArrayPush(texts, cratePriceMsg);
        ArrayPush(styles, SideNotificationStyle.Information);

        // Supply side notifs
        ArrayPush(texts, nightMarketLocation.GetSupplyIndicationLocalization());
        ArrayPush(styles, nightMarketLocation.GetSupplySidenotificationStyle());

        if IsNomad() {
            // Nomad extra volume bonus
            ArrayPush(texts, GetLocalizedTextByKey(n"DD.NightMarket.NomadExtraVolume"));
            ArrayPush(styles, SideNotificationStyle.Warning);
        }

        return SideNotification(texts, styles);
    }
}

// -- Input listener -----------------------------------------------------------
// Listens for DDInteractionAction button hold on the nightmarket prompt
public class NightMarketInputListener {
    public let gameInstance: GameInstance;

    protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
        let actionName = ListenerAction.GetName(action);
        let registeredActionNames = Constants.InputRegisteredActions();

        if !ArrayContains(registeredActionNames, actionName) {
            return false;
        }
        if !Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_HOLD_COMPLETE) {
            return false;
        }
        let nightMarketInteractionController = NightMarketInteractionController.Get();
        if !IsDefined(nightMarketInteractionController) || !nightMarketInteractionController.IsInteractionShown() {
            return false;
        }

        if IsMainAction(action) {
            // Main action buy crate
            let nightMarketSystem = NightMarketSystem.Get();
            if !IsDefined(nightMarketSystem) {
                return false;
            }
            nightMarketSystem.BuyCrate(nightMarketInteractionController);
        }
    }
}

// Register nightmarket input listener
@addField(PlayerPuppet)
private let nightMarketInputListener: ref<NightMarketInputListener>;

@wrapMethod(PlayerPuppet)
protected cb func OnGameAttached() -> Bool {
    wrappedMethod();

    let systemRequestsHandler: ref<inkISystemRequestsHandler> = GameInstance.GetSystemRequestsHandler();
    if IsDefined(systemRequestsHandler) && systemRequestsHandler.IsPreGame() {
        // Prevents firing up in MM
        return true;
    }

    this.nightMarketInputListener = new NightMarketInputListener();
    this.nightMarketInputListener.gameInstance = GetGameInstance();
    this.RegisterInputListener(this.nightMarketInputListener);

    // Start proximity checks
    let nightMarketInteractionController = NightMarketInteractionController.Get();
    if !IsDefined(nightMarketInteractionController) {
        return true;
    }
    nightMarketInteractionController.Start();
}

@wrapMethod(PlayerPuppet)
protected cb func OnDetach() -> Bool {
    wrappedMethod();

    if !IsDefined(this.nightMarketInputListener) {
        return true;
    }

    this.UnregisterInputListener(this.nightMarketInputListener);
    this.nightMarketInputListener = null;

    // End proximity checks
    let nightMarketInteractionController = NightMarketInteractionController.Get();
    if !IsDefined(nightMarketInteractionController) {
        return true;
    }
    nightMarketInteractionController.Stop();
}

