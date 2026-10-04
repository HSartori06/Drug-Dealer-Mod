module DrugDealer.State

import NightlyNow.Utils.GetCurrentTopLevelDistrict

// -----------------------------------------------------------------------------
// Turf - DrugDealer
// -----------------------------------------------------------------------------
// Turf location enum
public enum TurfLocation {
    None = 0,
    Watson = 1,
    SantoDomingo = 2,
    Badlands = 3,
    Westbrook = 4,
    Heywood = 5,
    Pacifica = 6,
}

// Get turf player is currently at
public func GetCurrentTurf() -> TurfLocation {
    let currentTopDistrict = GetCurrentTopLevelDistrict();

    if !IsDefined(currentTopDistrict) {
        // Could not detect player's current district
        return TurfLocation.None;
    }

    let districtType = currentTopDistrict.Type();
    if Equals(districtType, gamedataDistrict.Watson) {
        // Watson
        return TurfLocation.Watson;
    }
    if Equals(districtType, gamedataDistrict.Westbrook) {
        // Westbrook
        return TurfLocation.Westbrook;
    }
    if Equals(districtType, gamedataDistrict.SantoDomingo) {
        // Santo Domingo
        return TurfLocation.SantoDomingo;
    }
    if Equals(districtType, gamedataDistrict.Heywood) {
        // Heywood
        return TurfLocation.Heywood;
    }
    if Equals(districtType, gamedataDistrict.Badlands) {
        // Badlands
        return TurfLocation.Badlands;
    }
    if Equals(districtType, gamedataDistrict.Pacifica) {
        // Pacifica
        return TurfLocation.Pacifica;
    }

    // Unsupported district
    return TurfLocation.None;
}

// Returns array of turfs adjacent to input turf (Badlands excluded, that's just a wilderness)
public func GetAdjacentTurfs(turfLocation: TurfLocation) -> array<TurfLocation> {
    if Equals(turfLocation, TurfLocation.Watson) {
        // Watson
        return [TurfLocation.Westbrook];
    }

    if Equals(turfLocation, TurfLocation.Westbrook) {
        // Westbrook
        return [TurfLocation.Watson, TurfLocation.Heywood, TurfLocation.SantoDomingo];
    }

    if Equals(turfLocation, TurfLocation.SantoDomingo) {
        // Santo Domingo
        return [TurfLocation.Westbrook, TurfLocation.Heywood, TurfLocation.Pacifica];
    }

    if Equals(turfLocation, TurfLocation.Heywood) {
        // Heywood
        return [TurfLocation.Westbrook, TurfLocation.SantoDomingo, TurfLocation.Pacifica];
    }

    if Equals(turfLocation, TurfLocation.Pacifica) {
        // Pacifica
        return [TurfLocation.Heywood, TurfLocation.SantoDomingo];
    }

    return [];
}

