module DrugDealer.Map

// -----------------------------------------------------------------------------
// MappinUtils - Drug Dealer
// -----------------------------------------------------------------------------
// Open map centered at the given coordinates if not opened yet or player in menu
public func OpenMap(position: Vector4) {
    let gameInstance = GetGameInstance();
    let uiSystemBlackboard = GameInstance.GetBlackboardSystem(gameInstance).Get(GetAllBlackboardDefs().UI_System);
    if uiSystemBlackboard.GetBool(GetAllBlackboardDefs().UI_System.IsInMenu) {
        return;
    }

    // Carry the target coordinates into the world map menu so it centers on them
    let mapMenuUserData = new MapMenuUserData();
    mapMenuUserData.drugDealerCenterRequested = true;
    mapMenuUserData.drugDealerCenterPosition = position;

    let startHubMenuEvent = new StartHubMenuEvent();
    startHubMenuEvent.SetStartMenu(n"world_map", n"", mapMenuUserData);
    GameInstance.GetUISystem(gameInstance).QueueEvent(startHubMenuEvent);
}

// Coordinates
@addField(MapMenuUserData)
public let drugDealerCenterRequested: Bool;

@addField(MapMenuUserData)
public let drugDealerCenterPosition: Vector4;

// Center the world map at the requested coordinates once it opens
@wrapMethod(WorldMapMenuGameController)
protected cb func OnMapNavigationDelay(evt: ref<MapNavigationDelay>) -> Bool {
    let userData = this.m_initMappinFocus;
    if IsDefined(userData) && userData.drugDealerCenterRequested {
        this
            .GetEntityPreview()
            .MoveTo(Cast<Vector3>(userData.drugDealerCenterPosition));
        return true;
    }
    return wrappedMethod(evt);
}

