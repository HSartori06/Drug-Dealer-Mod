module DrugDealer.Lab

import DrugDealer.Map.{DrugDealerMappinData, DrugDealerMappinType}
import DrugDealer.Settings.SettingsSystem
import DrugDealer.State.{TurfLocation}
import DrugDealer.Translation.TranslateDrugCategory

// -----------------------------------------------------------------------------
// LabLocations - Drug Dealer
// -----------------------------------------------------------------------------
// Pairs a world position with a per lab detection proximityRadius
public struct LabLocation {
    let turfLocation: TurfLocation;
    let location: Vector4;
    let proximityRadius: Float;
    let specializedEquipment: DrugCategory;
}

public func LabLocations() -> array<LabLocation> {
    let labLocations = [
        /* Watson Northside compound */ LabLocation(
            TurfLocation.Watson,
            Vector4(-1511.1562, 2182.027, 18.206032, 1.0),
            1.5,
            DrugCategory.Stimulants
        ),
        /* Watson outdoor lab under the bridge */ LabLocation(
            TurfLocation.Watson,
            Vector4(-1019.01764, 2681.1836, 23.230003, 1.0),
            2.5,
            DrugCategory.Depressants
        ),
        /* Watson alternative stim lab when Regina fucks me over */ LabLocation(
            TurfLocation.Watson,
            Vector4(-615.6574, 2614.8918, 53.78, 1.0),
            1.0,
            DrugCategory.Stimulants
        ),
        /* Santo Domingo 1 */ LabLocation(
            TurfLocation.SantoDomingo,
            Vector4(-324.8383, -1646.3445, 7.810066, 1.0),
            2.5,
            DrugCategory.Psychedelics
        ),
        /* Badlands RV */ LabLocation(
            TurfLocation.Badlands,
            Vector4(3449.4902, -1125.8821, 101.88655, 1.0),
            2.3,
            DrugCategory.Dissociatives
        ),
        /* Westbrook 1 */ LabLocation(
            TurfLocation.Westbrook,
            Vector4(-271.00928, 1452.3224, 42.1, 1.0),
            1.2,
            DrugCategory.Empathogens
        ),
        /* Heywood 1 */ LabLocation(
            TurfLocation.Heywood,
            Vector4(-1171.7756, -1092.9213, 12.841637, 1.0),
            1.2,
            DrugCategory.Depressants
        ),
        /* Pacifica 1 */ LabLocation(
            TurfLocation.Pacifica,
            Vector4(-2780.8901, -2485.274, 29.900002, 1.0),
            1.2,
            DrugCategory.Deliriants
        )
    ];

    // Santo Domingo Grocery store by LiquidBronze
    let santoDomingoGroceryStoreLab = GetSantoDomingoGroceryStoreLab();
    if santoDomingoGroceryStoreLab.proximityRadius > 0.0 {
        ArrayPush(labLocations, santoDomingoGroceryStoreLab);
    }

    return labLocations;
}

@wrapMethod(PlayerPuppet)
protected cb func OnGameAttached() -> Bool {
    wrappedMethod();

    let systemRequestsHandler: ref<inkISystemRequestsHandler> = GameInstance.GetSystemRequestsHandler();
    if IsDefined(systemRequestsHandler) && systemRequestsHandler.IsPreGame() {
        // Prevents firing up in MM
        return true;
    }

    // Register lab pins
    let mappinSystem = GameInstance.GetMappinSystem(GetGameInstance());
    let settingsSystem = SettingsSystem.Get();
    if !IsDefined(settingsSystem) {
        return true;
    }
    for lab in LabLocations() {
        let location = lab.location;
        let mappinData = MappinData();
        mappinData.mappinType = t"Mappins.DefaultStaticMappin";
        mappinData.variant = gamedataMappinVariant.GetUpVariant;
        mappinData.active = !settingsSystem.enableImmersiveMode;
        mappinData.visibleThroughWalls = false;
        let scriptData = new DrugDealerMappinData();
        scriptData.mappinType = DrugDealerMappinType.DrugLaboratory;
        // We also displaying specialization here
        let labDisplayName = s"\(GetLocalizedTextByKey(n"DD.Mappin.DrugLaboratory")) \(TranslateDrugCategory(lab.specializedEquipment))";
        scriptData.displayName = labDisplayName;
        mappinData.scriptData = scriptData;
        mappinSystem.RegisterMappin(mappinData, location);
    }
}

//---------------- Custom labs segment ----------------
@if(ModuleExists("DrugDealer.Lab.GroceryStore"))
private func GetSantoDomingoGroceryStoreLab() -> LabLocation = LabLocation(
    TurfLocation.SantoDomingo,
    Vector4(127.36586, -1798.8032, -10.097549, 1.0),
    2.0,
    DrugCategory.Deliriants
);

@if(!ModuleExists("DrugDealer.Lab.GroceryStore"))
private func GetSantoDomingoGroceryStoreLab() -> LabLocation = LabLocation(TurfLocation.SantoDomingo, Vector4(0.0, 0.0, 0.0, 0.0), 0.0, DrugCategory.None);

