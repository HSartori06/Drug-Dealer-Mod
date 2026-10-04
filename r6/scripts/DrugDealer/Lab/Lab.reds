module DrugDealer.Lab

import NightlyNow.Utils.{ProximityDetector, IsNomad}
import NightlyNow.Notification.{NotificationSystem, SideNotification, SideNotificationStyle}
import DrugDealer.Translation.TranslateDrugCategory
import DrugDealer.State.{PlayerStateSystem, TurfControlSystem, Turf, TurfLocation, TurfControl}
import DrugDealer.Settings.{Constants, IsMainAction, IsSecondaryAction}

// -----------------------------------------------------------------------------
// Lab - Drug Dealer
// -----------------------------------------------------------------------------
// Delay callback for periodic proximity checks
public class LabProximityCheckCallback extends DelayCallback {
    public let controller: wref<LabInteractionController>;

    public func Call() {
        if IsDefined(this.controller) {
            this.controller.OnProximityCheck();
        }
    }
}

// Checks player proximity to lab locations and shows interaction
public class LabInteractionController extends ScriptableSystem {
    private let proximityDetector: ref<ProximityDetector>;
    private let player: wref<GameObject>;
    private let isRunning: Bool;
    private let wasNearBefore: Bool;
    private let nearLabLocation: LabLocation;
    // Lazy eval
    private let notificationSystem: wref<NotificationSystem>;

    public static func Get() -> ref<LabInteractionController> {
        return GameInstance
            .GetScriptableSystemsContainer(GetGameInstance())
            .Get(n"DrugDealer.Lab.LabInteractionController") as LabInteractionController;
    }

    // Lazy eval
    private func GetNotificationSystem() -> wref<NotificationSystem> {
        if !IsDefined(this.notificationSystem) {
            this.notificationSystem = NotificationSystem.Get();
        }
        return this.notificationSystem;
    }

    // Start polling for player proximity
    public func Start() {
        if this.isRunning {
            // Polling already active
            return;
        }
        this.isRunning = true;
        this.player = GetPlayer(GetGameInstance());

        // Interaction titles
        let mainInteractionTitle = GetLocalizedTextByKey(n"DD.Lab.MainInteractionTitle");
        let secondaryInteractionTitle = GetLocalizedTextByKey(n"DD.Lab.SecondaryInteractionTitle");
        let interactionActions = Constants.InputRegisteredActions();

        this.proximityDetector = ProximityDetector
            .Create(
                [mainInteractionTitle, secondaryInteractionTitle],
                [interactionActions[0], interactionActions[1]],
                0.25,
                true
            );
        this.QueueProximityCheck();
    }

    // Stop polling and hide interaction
    public func Stop() {
        this.isRunning = false;
        this.proximityDetector.HideInteraction();
        this.proximityDetector.CancelProximityCheck();
    }

    // Periodic check - show/hide interaction based on proximity
    public func OnProximityCheck() {
        if !IsDefined(this.player) {
            // Lost ref to player, refresh
            this.player = GetPlayer(GetGameInstance());
        }

        // This runs 4x per second at most so perf-wise it's fine
        let playerPos = this.player.GetWorldPosition();
        this.nearLabLocation = LabLocation(TurfLocation.None, Vector4(0, 0, 0, 0), 0.0, DrugCategory.None);
        for labLocation in LabLocations() {
            if Vector4.Distance(playerPos, labLocation.location) <= labLocation.proximityRadius {
                this.nearLabLocation = labLocation;
                break;
            }
        }
        // Lab location is a struct
        let isNear = this.nearLabLocation.proximityRadius > 0.0;

        // Side notification
        let notificationSystem = this.GetNotificationSystem();
        if !IsDefined(notificationSystem) {
            return;
        }
        if !this.wasNearBefore && isNear {
            // Show side notifications
            this.ShowSideNotification();
        } else if this.wasNearBefore && !isNear {
            // Hide side notifications
            this.HideSideNotification();
        }

        this.proximityDetector.UpdateProximity(isNear);
        this.wasNearBefore = isNear;
        this.QueueProximityCheck();
    }

    public func ShowSideNotification() {
        let notificationSystem = this.GetNotificationSystem();
        if !IsDefined(notificationSystem) {
            return;
        }
        if this.nearLabLocation.proximityRadius > 0.0 {
            notificationSystem
                .ShowSideNotification(this.GetSideNotification(this.nearLabLocation), true);
        }
    }

    public func HideSideNotification() {
        let notificationSystem = this.GetNotificationSystem();
        if !IsDefined(notificationSystem) {
            return;
        }
        notificationSystem.HideSideNotification();
    }

    public func IsInteractionShown() -> Bool = this.proximityDetector.IsInteractionShown();

    public func GetNearLabLocation() -> LabLocation = this.nearLabLocation;

    private func QueueProximityCheck() {
        let labProximityCheckCallback = new LabProximityCheckCallback();
        labProximityCheckCallback.controller = this;
        this.proximityDetector.QueueProximityCheck(labProximityCheckCallback);
    }

    private func GetSideNotification(labLocation: LabLocation) -> SideNotification {
        let texts: array<String>;
        let styles: array<SideNotificationStyle>;

        let turfControlSystem = TurfControlSystem.Get();
        if !IsDefined(turfControlSystem) {
            return SideNotification([], []);
        }
        let turf = turfControlSystem.GetTurf(labLocation.turfLocation);

        let playerStateSystem = PlayerStateSystem.Get();
        if !IsDefined(playerStateSystem) {
            return SideNotification([], []);
        }
        let ambushAllowed = playerStateSystem.IsAmbushAllowed();

        // Ambush notification
        if IsDefined(turf) {
            if turf.IsControlled() || !ambushAllowed {
                // No risk of ambush
                ArrayPush(texts, GetLocalizedTextByKey(n"DD.Turf.Controlled.Ambush"));
                ArrayPush(styles, SideNotificationStyle.Positive);
            }
            if turf.IsContested() && ambushAllowed {
                // Risk of ambush
                ArrayPush(texts, GetLocalizedTextByKey(n"DD.Turf.Constested.Ambush"));
                ArrayPush(styles, SideNotificationStyle.Warning);
            }
            if turf.IsSurrendered() && ambushAllowed {
                // High risk of ambush
                ArrayPush(texts, GetLocalizedTextByKey(n"DD.Turf.Surrendered.Ambush"));
                ArrayPush(styles, SideNotificationStyle.Warning);
            }
        }

        // Lab equipment
        ArrayPush(
            texts,
            GetLocalizedTextByKey(n"DD.Lab.SpecializedIn") + " " + TranslateDrugCategory(labLocation.specializedEquipment)
        );
        ArrayPush(styles, SideNotificationStyle.Drug);

        if IsNomad() {
            // Nomad cooking bonus
            ArrayPush(texts, GetLocalizedTextByKey(n"DD.Lifepath.Nomad"));
            ArrayPush(styles, SideNotificationStyle.Positive);
        }

        return SideNotification(texts, styles);
    }
}

// -- Input listener -----------------------------------------------------------
// Listens for DDInteractionAction button hold on the prepare product prompt
public class LabInputListener {
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
        let ctrl = LabInteractionController.Get();
        if !IsDefined(ctrl) || !ctrl.IsInteractionShown() {
            return false;
        }
        let labCookingSystem = LabCookingSystem.Get();
        if !IsDefined(labCookingSystem) {
            return false;
        }

        if IsMainAction(action) {
            // Open cookbook
            labCookingSystem.OpenCookbook();
        }

        if IsSecondaryAction(action) {
            // Cook up product
            labCookingSystem.PrepareProduct(ctrl.GetNearLabLocation());
        }
    }
}

// Register lab input listener
@addField(PlayerPuppet)
private let labInputListener: ref<LabInputListener>;

@wrapMethod(PlayerPuppet)
protected cb func OnGameAttached() -> Bool {
    wrappedMethod();

    let systemRequestsHandler: ref<inkISystemRequestsHandler> = GameInstance.GetSystemRequestsHandler();
    if IsDefined(systemRequestsHandler) && systemRequestsHandler.IsPreGame() {
        // Prevents firing up in MM
        return true;
    }

    this.labInputListener = new LabInputListener();
    this.labInputListener.gameInstance = GetGameInstance();
    this.RegisterInputListener(this.labInputListener);

    // Start proximity checks
    let labInteractionController = LabInteractionController.Get();
    if !IsDefined(labInteractionController) {
        return true;
    }
    labInteractionController.Start();
}

@wrapMethod(PlayerPuppet)
protected cb func OnDetach() -> Bool {
    wrappedMethod();

    if !IsDefined(this.labInputListener) {
        return true;
    }

    this.UnregisterInputListener(this.labInputListener);
    this.labInputListener = null;

    // Stop proximity checks
    let labInteractionController = LabInteractionController.Get();
    if !IsDefined(labInteractionController) {
        return true;
    }
    labInteractionController.Stop();
}

