module DrugDealer.Operation

import NightlyNow.Utils.ProximityDetector
import NightlyNow.Notification.{NotificationSystem, SideNotification, SideNotificationStyle}
import DrugDealer.State.{PlayerStateSystem, TurfControlSystem, Turf, TurfLocation, TurfControl}
import NightlyNow.Utils.{IsNight, IsStreetKid}
import DrugDealer.Settings.{Constants, SettingsSystem, IsMainAction, IsSecondaryAction}

// -----------------------------------------------------------------------------
// Operation - Drug Dealer
// -----------------------------------------------------------------------------
// Delay callback for periodic proximity checks
public class OperationCheckCallback extends DelayCallback {
    public let controller: wref<OperationInteractionController>;

    public func Call() {
        if IsDefined(this.controller) {
            this.controller.OnProximityCheck();
        }
    }
}

// Checks player proximity to operation locations and shows interaction
public class OperationInteractionController extends ScriptableSystem {
    private let proximityDetector: ref<ProximityDetector>;
    private let isRunning: Bool;
    private let wasNearBefore: Bool;
    public let nearOperation: wref<Operation>;
    // Lazy eval
    private let operationSystem: wref<OperationSystem>;

    public static func Get() -> ref<OperationInteractionController> {
        return GameInstance
            .GetScriptableSystemsContainer(GetGameInstance())
            .Get(n"DrugDealer.Operation.OperationInteractionController") as OperationInteractionController;
    }

    // Lazy eval
    public func GetOperationSystem() -> wref<OperationSystem> {
        if !IsDefined(this.operationSystem) {
            this.operationSystem = OperationSystem.Get();
        }
        return this.operationSystem;
    }

    // Start polling for player proximity
    public func Start() {
        if this.isRunning {
            return;
        }
        this.isRunning = true;
        let settings = SettingsSystem.Get();
        if !IsDefined(settings) {
            return;
        }

        // Interaction titles
        let mainInteractionTitle = StrReplace(
            GetLocalizedTextByKey(n"DD.Operation.MainInteractionTitle"),
            "{0}",
            s"\(Cast<Int32>(settings.distributionStreetOperationPercent))"
        );
        let secondaryInteractionTitle = GetLocalizedTextByKey(n"DD.Operation.SecondaryInteractionTitle");
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
        this.nearOperation = null;

        let operationSystem = this.GetOperationSystem();
        let operations: array<ref<Operation>> = IsDefined(operationSystem) ? operationSystem.GetEligibleOperations() : [];

        for operation in operations {
            if this.proximityDetector.IsPlayerNearPosition(operation.location) {
                this.nearOperation = operation;
                break;
            }
        }

        // Operation is a struct
        let isNear = IsDefined(this.nearOperation);

        // Side notification
        let notificationSystem = NotificationSystem.Get();
        if !IsDefined(notificationSystem) {
            return;
        }
        if !this.wasNearBefore && isNear {
            // Show side notifications
            notificationSystem
                .ShowSideNotification(this.GetSideNotification(this.nearOperation), true);
        } else if this.wasNearBefore && !isNear {
            // Hide side notifications
            notificationSystem.HideSideNotification();
        }

        this.proximityDetector.UpdateProximity(isNear);
        this.wasNearBefore = isNear;
        this.QueueCheck();
    }

    public func IsInteractionShown() -> Bool = this.proximityDetector.IsInteractionShown();

    public func GetNearOperation() -> wref<Operation> = this.nearOperation;

    private func QueueCheck() {
        let operationCheckCallback = new OperationCheckCallback();
        operationCheckCallback.controller = this;
        this.proximityDetector.QueueProximityCheck(operationCheckCallback);
    }

    public func GetSideNotification(operation: wref<Operation>) -> SideNotification {
        if !IsDefined(operation) {
            // Should never happen
            return SideNotification([], []);
        }

        let texts: array<String>;
        let styles: array<SideNotificationStyle>;

        // Operation supply
        ArrayPush(texts, operation.GetSupplyIndicationLocalization());
        ArrayPush(styles, operation.GetSupplySidenotificationStyle());

        if IsStreetKid() {
            // Street kid, double the supply bonus
            ArrayPush(texts, GetLocalizedTextByKey(n"DD.Lifepath.StreetKid"));
            ArrayPush(styles, SideNotificationStyle.Positive);
        }

        if !operation.IsAtFullCapacity() {
            // Assassination never display at full capacity
            let turfControlSystem = TurfControlSystem.Get();
            if !IsDefined(turfControlSystem) {
                // Should never happen
                return SideNotification([], []);
            }

            let enemyTurfCount = turfControlSystem.GetEnemyTurfCount();
            let assassinationMsg = StrReplace(
                GetLocalizedTextByKey(n"DD.Operation.Assassination.Sidenotification"),
                "{0}",
                s"\(enemyTurfCount)"
            );
            ArrayPush(texts, assassinationMsg);
            ArrayPush(
                styles,
                enemyTurfCount > 2 ? SideNotificationStyle.Danger : SideNotificationStyle.Warning
            );
        }

        return SideNotification(texts, styles);
    }
}

// -- Input listener -----------------------------------------------------------
// Listens for DDInteractionAction button hold on the operation prompt
public class OperationInputListener {
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
        let ctrl = OperationInteractionController.Get();
        if !IsDefined(ctrl) || !ctrl.IsInteractionShown() {
            return false;
        }

        // Perform operation action (supply brother/supply pushers)
        let operationSystem = ctrl.GetOperationSystem();
        if !IsDefined(operationSystem) || !IsDefined(ctrl.nearOperation) {
            // Not defined
            return false;
        }

        if IsMainAction(action) {
            // Supply partially
            operationSystem.Supply(ctrl, true);
        }

        if IsSecondaryAction(action) {
            // Supply
            operationSystem.Supply(ctrl);
        }
    }
}

// Register operation input listener
@addField(PlayerPuppet)
private let operationInputListener: ref<OperationInputListener>;

@wrapMethod(PlayerPuppet)
protected cb func OnGameAttached() -> Bool {
    wrappedMethod();

    let systemRequestsHandler: ref<inkISystemRequestsHandler> = GameInstance.GetSystemRequestsHandler();
    if IsDefined(systemRequestsHandler) && systemRequestsHandler.IsPreGame() {
        // Prevents firing up in MM
        return true;
    }

    this.operationInputListener = new OperationInputListener();
    this.operationInputListener.gameInstance = GetGameInstance();
    this.RegisterInputListener(this.operationInputListener);

    // Start proximity checks
    let operationInteractionController = OperationInteractionController.Get();
    if !IsDefined(operationInteractionController) {
        return true;
    }
    operationInteractionController.Start();
}

@wrapMethod(PlayerPuppet)
protected cb func OnDetach() -> Bool {
    wrappedMethod();

    if !IsDefined(this.operationInputListener) {
        return true;
    }

    this.UnregisterInputListener(this.operationInputListener);
    this.operationInputListener = null;

    // End proximity checks
    let operationInteractionController = OperationInteractionController.Get();
    if !IsDefined(operationInteractionController) {
        return true;
    }
    operationInteractionController.Stop();
}

