module DrugDealer.Organization

import DrugDealer.State.{TurfControlSystem, TurfLocation}

// -----------------------------------------------------------------------------
// Organization - Drug Dealer
// -----------------------------------------------------------------------------
public enum Organization {
    Maelstrom = 0,
    TygerClaws = 1,
    Valentinos = 2,
    SixthStreet = 3,
    VoodooBoys = 4,
    Animals = 5,
    Scavengers = 6,
    Wraiths = 7,
    Moxes = 8,
    Aldecaldos = 9,
    BarghestMilitia = 10,
    Ncpd = 11,
    Prostitutes = 12,
}

// Returns a random gang organization (excludes Ncpd)
public func RollOrganization() -> Organization = IntEnum<Organization>(RandRange(0, 11));

// Returns a random organization eligible for lab ambush
public func RollAmbushOrganization() -> Organization {
    let pool = [
        Organization.Maelstrom,
        Organization.Valentinos,
        Organization.SixthStreet,
        Organization.Animals,
        Organization.Scavengers,
        Organization.Wraiths,
        Organization.Moxes,
        Organization.TygerClaws,
        Organization.VoodooBoys
    ];
    return pool[RandRange(0, ArraySize(pool))];
}

// Roll assassination organization based on turf
public func RollAssassinationOrganization() -> Organization {
    let turfControlSystem = TurfControlSystem.Get();
    if !IsDefined(turfControlSystem) {
        return Organization.Scavengers;
    }

    let turfLocation = turfControlSystem.RollEnemyTurfLocation();
    if Equals(turfLocation, TurfLocation.None) {
        // Send in the scavs as a fallback
        return Organization.Scavengers;
    }

    let eligibleOrganizations: array<Organization>;

    switch turfLocation {
        case TurfLocation.Watson:
            eligibleOrganizations = [
                Organization.Maelstrom,
                Organization.Scavengers,
                Organization.Animals
            ];
            break;
        case TurfLocation.SantoDomingo:
            eligibleOrganizations = [Organization.SixthStreet, Organization.Valentinos];
            break;
        case TurfLocation.Badlands:
            eligibleOrganizations = [Organization.Wraiths];
            break;
        case TurfLocation.Westbrook:
            eligibleOrganizations = [Organization.Moxes, Organization.TygerClaws];
            break;
        case TurfLocation.Heywood:
            eligibleOrganizations = [Organization.Valentinos, Organization.SixthStreet];
            break;
        case TurfLocation.Pacifica:
            eligibleOrganizations = [Organization.VoodooBoys, Organization.Animals];
            break;
        default:
            eligibleOrganizations = [
                Organization.Maelstrom,
                Organization.Scavengers,
                Organization.Animals
            ];
            break;
    }
    return eligibleOrganizations[RandRange(0, ArraySize(eligibleOrganizations))];
}

