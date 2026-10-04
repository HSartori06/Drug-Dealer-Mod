module DrugDealer.Crackhouse

import DrugDealer.Map.{DrugDealerMappinData, DrugDealerMappinType}
import DrugDealer.Settings.SettingsSystem
import DrugDealer.State.{TurfLocation}

// -----------------------------------------------------------------------------
// CrackhouseLocations - Drug Dealer
// -----------------------------------------------------------------------------
public struct CrackhouseLocation {
    public let turfLocation: TurfLocation;
    public let location: Vector4;
}

public func CrackhouseLocations() -> array<CrackhouseLocation> = [
    /* Watson 1 */ CrackhouseLocation(TurfLocation.Watson, Vector4(-1913.6251, 2402.6077, 18.229347, 1.0)),
    /* Watson 2 */ CrackhouseLocation(TurfLocation.Watson, Vector4(-1429.2283, 2138.5903, 18.20256, 1.0)),
    /* Santo Domingo 1 */ CrackhouseLocation(TurfLocation.SantoDomingo, Vector4(126.51878, -580.9856, 8.156242, 1.0)),
    /* Santo Domingo 2 */ CrackhouseLocation(TurfLocation.SantoDomingo, Vector4(-489.0046, -1320.2174, 6.9252167, 1.0)),
    /* Santo Domingo 3 */ CrackhouseLocation(TurfLocation.SantoDomingo, Vector4(-401.81226, -1898.9664, 7.4747314, 1.0)),
    /* Badlands 1 */ CrackhouseLocation(TurfLocation.Badlands, Vector4(2519.9956, -31.43306, 81.192154, 1.0)),
    /* Badlands 2 */ CrackhouseLocation(TurfLocation.Badlands, Vector4(1476.4156, -1403.6041, 51.26744, 1.0)),
    /* Westbrook 1 */ CrackhouseLocation(TurfLocation.Westbrook, Vector4(-223.99794, -193.37048, 2.046524, 1.0)),
    /* Westbrook 2 */ CrackhouseLocation(TurfLocation.Westbrook, Vector4(-351.5957, 199.65002, 24.094383, 1.0)),
    /* Westbrook 3 */ CrackhouseLocation(TurfLocation.Westbrook, Vector4(-361.24234, 257.52652, 32.14779, 1.0)),
    /* Westbrook 4 */ CrackhouseLocation(TurfLocation.Westbrook, Vector4(-347.8343, 1385.1223, 42.18331, 1.0)),
    /* Heywood 1 */ CrackhouseLocation(TurfLocation.Heywood, Vector4(-2245.9543, -453.40997, 7.4268265, 1.0)),
    /* Heywood 2 */ CrackhouseLocation(TurfLocation.Heywood, Vector4(-2283.9644, -908.6139, 8.695297, 1.0)),
    /* Heywood 3 */ CrackhouseLocation(TurfLocation.Heywood, Vector4(-2451.372, -1012.522, 7.965378, 1.0)),
    /* Heywood 4 */ CrackhouseLocation(TurfLocation.Heywood, Vector4(-1580.103, -1348.9852, 50.112045, 1.0)),
    /* Heywood 5 */ CrackhouseLocation(TurfLocation.Heywood, Vector4(-851.1018, -644.56323, 8.323227, 1.0)),
    /* Heywood 6 */ CrackhouseLocation(TurfLocation.Heywood, Vector4(-818.63196, -135.94624, 7.5038834, 1.0)),
    /* Pacifica 1 */ CrackhouseLocation(TurfLocation.Pacifica, Vector4(-2599.5308, -2516.3696, 27.0, 1.0)),
    /* Pacifica 2 */ CrackhouseLocation(TurfLocation.Pacifica, Vector4(-2566.5874, -2452.303, 31.0, 1.0)),
    /* Pacifica 3 */ CrackhouseLocation(TurfLocation.Pacifica, Vector4(-2060.9624, -2158.2227, 18.928009, 1.0)),
    /* Pacifica 4 */ CrackhouseLocation(TurfLocation.Pacifica, Vector4(-1769.5505, -1866.2253, 50.10559, 1.0))
];

@wrapMethod(PlayerPuppet)
protected cb func OnGameAttached() -> Bool {
    wrappedMethod();

    let systemRequestsHandler: ref<inkISystemRequestsHandler> = GameInstance.GetSystemRequestsHandler();
    if IsDefined(systemRequestsHandler) && systemRequestsHandler.IsPreGame() {
        // Prevents firing up in MM
        return true;
    }

    // Register crackhouse pins
    let mappinSystem = GameInstance.GetMappinSystem(GetGameInstance());
    let settingsSystem = SettingsSystem.Get();
    if !IsDefined(settingsSystem) {
        return true;
    }
    for crackhouseLocation in CrackhouseLocations() {
        let mappinData = MappinData();
        mappinData.mappinType = t"Mappins.DefaultStaticMappin";
        mappinData.variant = gamedataMappinVariant.GetUpVariant;
        mappinData.active = !settingsSystem.enableImmersiveMode;
        mappinData.visibleThroughWalls = false;
        let scriptData = new DrugDealerMappinData();
        scriptData.mappinType = DrugDealerMappinType.Crackhouse;
        scriptData.displayName = GetLocalizedTextByKey(n"DD.Mappin.Crackhouse");
        mappinData.scriptData = scriptData;
        mappinSystem.RegisterMappin(mappinData, crackhouseLocation.location);
    }
}

