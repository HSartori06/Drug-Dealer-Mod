module DrugDealer.Map

// -----------------------------------------------------------------------------
// MappinData - Drug Dealer
// -----------------------------------------------------------------------------
public enum DrugDealerMappinType {
    DrugLaboratory = 0,
    Raid = 1,
    Fiend = 2,
    Stash = 3,
    Crackhouse = 4,
    BigDrugDeal = 5,
    TurfSurrendered = 6,
    TurfContested = 7,
    TurfControlled = 8,
    RoamingRaid = 9,
    Pushers = 10,
    Brothel = 11,
    NightMarket = 12,
}

// Shared script data for all Drug Dealer mappins
public class DrugDealerMappinData extends MappinScriptData {
    public let mappinType: DrugDealerMappinType;
    public let displayName: String;

    public func GetResource() -> ResRef {
        switch this.mappinType {
            case DrugDealerMappinType.DrugLaboratory:
                return r"pins\\drug_dealer_pin_laboratory.inkatlas";
            case DrugDealerMappinType.Raid:
                return r"pins\\drug_dealer_pin_raid.inkatlas";
            case DrugDealerMappinType.Fiend:
                return r"pins\\drug_dealer_pin_fiend.inkatlas";
            case DrugDealerMappinType.Stash:
                return r"pins\\drug_dealer_pin_stash.inkatlas";
            case DrugDealerMappinType.Crackhouse:
                return r"pins\\drug_dealer_pin_crackhouse.inkatlas";
            case DrugDealerMappinType.BigDrugDeal:
                return r"pins\\drug_dealer_pin_drugdeal.inkatlas";
            case DrugDealerMappinType.TurfSurrendered:
                return r"pins\\drug_dealer_pin_turfsurrendered.inkatlas";
            case DrugDealerMappinType.TurfContested:
                return r"pins\\drug_dealer_pin_turfcontested.inkatlas";
            case DrugDealerMappinType.TurfControlled:
                return r"pins\\drug_dealer_pin_turfcontrolled.inkatlas";
            case DrugDealerMappinType.RoamingRaid:
                return r"pins\\drug_dealer_pin_roamingraid.inkatlas";
            case DrugDealerMappinType.Pushers:
                return r"pins\\drug_dealer_pin_pushers.inkatlas";
            case DrugDealerMappinType.Brothel:
                return r"pins\\drug_dealer_pin_brothel.inkatlas";
            case DrugDealerMappinType.NightMarket:
                return r"pins\\drug_dealer_pin_nightmarket.inkatlas";
        }
        // Default
        return r"pins\\drug_dealer_pin_laboratory.inkatlas";
    }
}

