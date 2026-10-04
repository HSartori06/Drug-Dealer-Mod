module DrugDealer.Settings

// -----------------------------------------------------------------------------
// Input - Drug Dealer
// -----------------------------------------------------------------------------
public func IsMainAction(action: ListenerAction) -> Bool {
    let registeredActions = Constants.InputRegisteredActions();
    return Equals(ListenerAction.GetName(action), registeredActions[0])
        && Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_HOLD_COMPLETE);
}

public func IsSecondaryAction(action: ListenerAction) -> Bool {
    let registeredActions = Constants.InputRegisteredActions();
    return Equals(ListenerAction.GetName(action), registeredActions[1])
        && Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_HOLD_COMPLETE);
}