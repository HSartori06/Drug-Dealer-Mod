module DrugDealer.Job

import DrugDealer.Organization.{Organization}
import DrugDealer.State.{TurfControlSystem, TurfLocation}

// -----------------------------------------------------------------------------
// VehiclePresets - Drug Dealer
// -----------------------------------------------------------------------------
// Picks vehicleCount random vehicle records for a given organization
public func RollVehicleWave(org: Organization, vehicleCount: Int32) -> array<TweakDBID> {
    let basePath = GetVehicleBasePath(org);
    let vehicles: array<TweakDBID>;
    let i = 0;
    while i < vehicleCount {
        let index = RandRange(1, 21);
        let id = TDBID.Create(basePath + "." + IntToString(index));
        ArrayPush(vehicles, id);
        i += 1;
    }
    return vehicles;
}

public func RollFriendlyVehicleWave(turfLocation: TurfLocation) -> array<TweakDBID> {
    if Equals(turfLocation, TurfLocation.None) {
        // Unsupported turf location
        return [];
    }

    // Always 2 rides to choose from
    let index = RandRange(1, 3);
    let turfControlSystem = TurfControlSystem.Get();
    if !IsDefined(turfControlSystem) {
        return [];
    }
    let turfWithReinforcements = turfControlSystem.GetEligibleReinforcementTurf(turfLocation);

    if Equals(turfWithReinforcements, TurfLocation.None) {
        // No reinforcements available
        return [];
    }

    return [
        TDBID
            .Create(s"DrugDealer.Vehicle.Player.\(turfWithReinforcements).\(index)")
    ];
}

// Maps organization to its vehicle tweakdb base path
private func GetVehicleBasePath(org: Organization) -> String {
    switch org {
        case Organization.Animals:
            return "DrugDealer.Vehicle.Animals";
        case Organization.Maelstrom:
            return "DrugDealer.Vehicle.Maelstrom";
        case Organization.Scavengers:
            return "DrugDealer.Vehicle.Scavengers";
        case Organization.SixthStreet:
            return "DrugDealer.Vehicle.SixthStreet";
        case Organization.Valentinos:
            return "DrugDealer.Vehicle.Valentinos";
        case Organization.Wraiths:
            return "DrugDealer.Vehicle.Wraiths";
        case Organization.Moxes:
            return "DrugDealer.Vehicle.Moxes";
        case Organization.TygerClaws:
            return "DrugDealer.Vehicle.TygerClaws";
        case Organization.VoodooBoys:
            return "DrugDealer.Vehicle.VoodooBoys";
        default:
            return "DrugDealer.Vehicle.Animals";
    }
}

