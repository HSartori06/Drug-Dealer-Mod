module DrugDealer.Crackhouse

import NightlyNow.Utils.ProximityDetector
import NightlyNow.Notification.{NotificationSystem, SideNotification, SideNotificationStyle}
import DrugDealer.State.{TurfControlSystem, Turf, TurfLocation, TurfControl}
import DrugDealer.Settings.{Constants, SettingsSystem, IsMainAction, IsSecondaryAction}
import NightlyNow.Utils.{IsNight, IsCorpo}

// -----------------------------------------------------------------------------
// Crackhouse - Drug Dealer
// -----------------------------------------------------------------------------
// Delay callback for periodic proximity checks
public class CrackhouseCheckCallback extends DelayCallback {
    public let controller: wref<CrackhouseInteractionController>;

    public func Call() {
        if IsDefined(this.controller) {
            this.controller.OnProximityCheck();
        }
    }
}

// Checks player proximity to crackhouse locations and shows interaction
public class CrackhouseInteractionController extends ScriptableSystem {
    private let proximityDetector: ref<ProximityDetector>;
    private let isRunning: Bool;
    private let wasNearBefore: Bool;
    private let nearCrackhouseLocation: CrackhouseLocation;

    public static func Get() -> ref<CrackhouseInteractionController> {
        return GameInstance
            .GetScriptableSystemsContainer(GetGameInstance())
            .Get(n"DrugDealer.Crackhouse.CrackhouseInteractionController") as CrackhouseInteractionController;
    }

    // Start polling for player proximity
    public func Start() {
        if this.isRunning {
            return;
        }
        let settings = SettingsSystem.Get();
        if !IsDefined(settings) {
            return;
        }
        this.isRunning = true;

        // Interaction titles
        let mainInteractionTitle = StrReplace(
            GetLocalizedTextByKey(n"DD.Crackhouse.MainInteractionTitle"),
            "{0}",
            s"\(Cast<Int32>(settings.distributionCrackhousePercent))"
        );
        let secondaryInteractionTitle = GetLocalizedTextByKey(n"DD.Crackhouse.SecondaryInteractionTitle");
        let interactionActions = Constants.InputRegisteredActions();

        this.proximityDetector = ProximityDetector
            .Create(
                [mainInteractionTitle, secondaryInteractionTitle],
                [interactionActions[0], interactionActions[1]],
                0.25,
                true,
                2.5
            );
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
        // Since structs are not nullable :(
        this.nearCrackhouseLocation = CrackhouseLocation(TurfLocation.None, Vector4(0, 0, 0, 0));

        for crackhouseLocation in CrackhouseLocations() {
            if this
                .proximityDetector
                .IsPlayerNearPosition(crackhouseLocation.location) {
                this.nearCrackhouseLocation = crackhouseLocation;
                break;
            }
        }

        // Crackhouse is a struct
        let isNear = this.nearCrackhouseLocation.location.W > 0.0;

        // Side notification
        let notificationSystem = NotificationSystem.Get();
        if !IsDefined(notificationSystem) {
            return;
        }
        if !this.wasNearBefore && isNear {
            // Show side notifications
            notificationSystem
                .ShowSideNotification(this.GetSideNotification(this.nearCrackhouseLocation), true);
        } else if this.wasNearBefore && !isNear {
            // Hide side notifications
            notificationSystem.HideSideNotification();
        }

        this.proximityDetector.UpdateProximity(isNear);
        this.wasNearBefore = isNear;
        this.QueueCheck();
    }

    public func IsInteractionShown() -> Bool = this.proximityDetector.IsInteractionShown();

    public func GetNearCrackhouseLocation() -> CrackhouseLocation = this.nearCrackhouseLocation;

    private func QueueCheck() {
        let crackhouseCheckCallback = new CrackhouseCheckCallback();
        crackhouseCheckCallback.controller = this;
        this.proximityDetector.QueueProximityCheck(crackhouseCheckCallback);
    }

    private func GetSideNotification(crackhouseLocation: CrackhouseLocation) -> SideNotification {
        let texts: array<String>;
        let styles: array<SideNotificationStyle>;

        let turfControlSystem = TurfControlSystem.Get();
        if !IsDefined(turfControlSystem) {
            return SideNotification([], []);
        }
        let turf = turfControlSystem.GetTurf(crackhouseLocation.turfLocation);

        if IsDefined(turf) {
            if turf.IsControlled() {
                // Drug monopoly for controlled turf
                ArrayPush(texts, GetLocalizedTextByKey(n"DD.Turf.Controlled.Sales"));
                ArrayPush(styles, SideNotificationStyle.Positive);
            }
            if turf.IsSurrendered() {
                // Sales malus for surrendered turf
                ArrayPush(texts, GetLocalizedTextByKey(n"DD.Turf.Surrendered.Sales"));
                ArrayPush(styles, SideNotificationStyle.Warning);
            }
        }

        if IsNight() {
            // Night sales bonus
            ArrayPush(texts, GetLocalizedTextByKey(n"DD.SellDrugs.NightBonus"));
            ArrayPush(styles, SideNotificationStyle.Positive);
        }

        if IsCorpo() {
            // Corpo sales bonus
            ArrayPush(texts, GetLocalizedTextByKey(n"DD.Lifepath.Corpo"));
            ArrayPush(styles, SideNotificationStyle.Positive);
        }

        return SideNotification(texts, styles);
    }
}

// -- Input listener -----------------------------------------------------------
// Listens for DDInteractionAction button hold on the crackhouse prompt
public class CrackhouseInputListener {
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
        let ctrl = CrackhouseInteractionController.Get();
        if !IsDefined(ctrl) || !ctrl.IsInteractionShown() {
            return false;
        }

        let crackhouseSellingSystem = CrackhouseSellingSystem.Get();
        if !IsDefined(crackhouseSellingSystem) {
            return false;
        }

        if IsMainAction(action) {
            // Sell partial inventory
            crackhouseSellingSystem.SellProduct(ctrl.GetNearCrackhouseLocation(), true);
        }

        if IsSecondaryAction(action) {
            // Sell full inv
            crackhouseSellingSystem.SellProduct(ctrl.GetNearCrackhouseLocation());
        }
        return true;
    }
}

// Register crackhouse input listener
@addField(PlayerPuppet)
private let crackhouseInputListener: ref<CrackhouseInputListener>;

@wrapMethod(PlayerPuppet)
protected cb func OnGameAttached() -> Bool {
    wrappedMethod();

    let systemRequestsHandler: ref<inkISystemRequestsHandler> = GameInstance.GetSystemRequestsHandler();
    if IsDefined(systemRequestsHandler) && systemRequestsHandler.IsPreGame() {
        // Prevents firing up in MM
        return true;
    }

    this.crackhouseInputListener = new CrackhouseInputListener();
    this.crackhouseInputListener.gameInstance = GetGameInstance();
    this.RegisterInputListener(this.crackhouseInputListener);

    // Start proximity checks
    let crackhouseInteractionController = CrackhouseInteractionController.Get();
    if !IsDefined(crackhouseInteractionController) {
        return true;
    }
    crackhouseInteractionController.Start();
}

@wrapMethod(PlayerPuppet)
protected cb func OnDetach() -> Bool {
    wrappedMethod();

    if !IsDefined(this.crackhouseInputListener) {
        return true;
    }

    this.UnregisterInputListener(this.crackhouseInputListener);
    this.crackhouseInputListener = null;

    // End proximity checks
    let crackhouseInteractionController = CrackhouseInteractionController.Get();
    if !IsDefined(crackhouseInteractionController) {
        return true;
    }
    crackhouseInteractionController.Stop();
}

