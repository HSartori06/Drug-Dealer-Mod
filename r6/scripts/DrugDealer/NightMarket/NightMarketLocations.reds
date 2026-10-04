module DrugDealer.NightMarket

import DrugDealer.Settings.Constants
import DrugDealer.Map.{DrugDealerMappinData, DrugDealerMappinType}
import DrugDealer.State.TurfLocation
import DrugDealer.Organization.Organization
import DrugDealer.Translation.TranslateOrganization
import NightlyNow.Notification.{SideNotification, SideNotificationStyle}

// -----------------------------------------------------------------------------
// NightMarketLocations - Drug Dealer
// -----------------------------------------------------------------------------
public class NightMarketLocation {
    public persistent let turfLocation: TurfLocation;
    public persistent let organization: Organization;
    public persistent let location: Vector4;
    public persistent let node: CName;
    // How many crates player can buy per spawn period
    public persistent let crates: Int32;
    public persistent let mappinId: NewMappinID;

    public static func Create(
        turfLocation: TurfLocation,
        organization: Organization,
        location: Vector4,
        node: CName,
        crates: Int32
    ) -> ref<NightMarketLocation> {
        let nightMarketLocation = new NightMarketLocation();
        nightMarketLocation.turfLocation = turfLocation;
        nightMarketLocation.organization = organization;
        nightMarketLocation.location = location;
        nightMarketLocation.node = node;
        nightMarketLocation.crates = crates;
        return nightMarketLocation;
    }

    public func GetSupplyIndicationLocalization() -> String {
        let supplyIndication = n"DD.NightMarket.Supply.Full";

        if this.crates <= 0 {
            supplyIndication = n"DD.NightMarket.Supply.Empty";
        } else if this.crates <= 10 {
            supplyIndication = n"DD.NightMarket.Supply.Low";
        } else if this.crates <= 20 {
            supplyIndication = n"DD.NightMarket.Supply.Medium";
        } else if this.crates <= 25 {
            supplyIndication = n"DD.NightMarket.Supply.High";
        }

        return GetLocalizedTextByKey(supplyIndication);
    }

    public func GetSupplySidenotificationStyle() -> SideNotificationStyle {
        if this.crates <= 0 {
            return SideNotificationStyle.Danger;
        }
        if this.crates <= 10 {
            return SideNotificationStyle.Warning;
        }
        if this.crates <= 20 {
            return SideNotificationStyle.Partial;
        }
        if this.crates <= 25 {
            return SideNotificationStyle.Positive;
        }

        return SideNotificationStyle.Information;
    }

    public func GetMappinType() -> DrugDealerMappinType = DrugDealerMappinType.NightMarket;

    public func GetMappinLocalization() -> String = s"\(GetLocalizedTextByKey(n"DD.Mappin.NightMarket")) \(TranslateOrganization(this.organization))";

    public func Replenish() {
        this.crates = RandRange(Constants.NightMarketMinCrates(), Constants.NightMarketMaxCrates() + 1);
    }

    public func IsExtraSupplied() -> Bool = this.crates >= Constants.NightMarketExtraThreshold();

    public func ConsumeCrate() {
        if this.crates > 0 {
            this.crates -= 1;
        }
    }
}

