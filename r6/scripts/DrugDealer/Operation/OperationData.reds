module DrugDealer.Operation

import Codeware.UI.ThemeColors
import DrugDealer.Map.{DrugDealerMappinData, DrugDealerMappinType}
import DrugDealer.Settings.{Constants, SettingsSystem, Colors}
import DrugDealer.State.TurfLocation
import DrugDealer.Translation.*
import DrugDealer.Organization.Organization
import DrugDealer.Market.MarketSystem
import NightlyNow.Transaction.{ItemStock, DecreaseQuantityOfRandomItemResult}
import NightlyNow.Notification.{SideNotification, SideNotificationStyle}
import NightlyNow.Utils.{IsCorpo}

// -----------------------------------------------------------------------------
// OperationData - Drug Dealer
// -----------------------------------------------------------------------------
public enum OperationType {
    Pushers = 0,
    Brothel = 1,
}

public enum OperationStatus {
    Inactive = 0,
    Active = 1,
}

// Returns when operation executes
public struct OperationResult {
    public let turfLocation: TurfLocation;
    public let type: OperationType;
    public let consumedProducts: Int32;
    // Cut already factored in
    public let totalIncome: Int32;
    // How much operation took for itself
    public let cut: Int32;
}

// Street operations connected to their turf, available after conquering a turf
public class Operation {
    public persistent let turfLocation: TurfLocation;
    public persistent let location: Vector4;
    public persistent let node: CName;
    public persistent let type: OperationType;
    public persistent let status: OperationStatus;
    public persistent let itemStock: ref<ItemStock>;
    public persistent let organization: Organization;
    public persistent let mappinId: NewMappinID;

    public static func Create(
        turfLocation: TurfLocation,
        location: Vector4,
        node: CName,
        type: OperationType,
        organization: Organization
    ) -> ref<Operation> {
        let operation = new Operation();
        operation.turfLocation = turfLocation;
        operation.location = location;
        operation.node = node;
        operation.type = type;
        operation.itemStock = new ItemStock();
        operation.organization = organization;
        return operation;
    }

    // Executes operation consume logic
    public func Execute(marketSystem: ref<MarketSystem>, settings: wref<SettingsSystem>) -> OperationResult {
        if !IsDefined(marketSystem) || !IsDefined(settings) {
            return OperationResult(this.turfLocation, OperationType.Pushers, 0, 0, 0);
        }

        if this.IsPushers() && this.itemStock.TotalQuantity() <= 0 {
            // Empty
            return OperationResult(this.turfLocation, OperationType.Pushers, 0, 0, 0);
        }

        let consumedProducts = 0;
        let totalIncome = 0;
        let suppliedWithJoytoysKiss = this.IsSuppliedWithJoytoysKiss();
        let productsToConsume = RandRange(
            Constants.OperationMinProductsConsumed(),
            Constants.OperationMaxProductsConsumed() + 1
        );
        let i = 0;

        while i < productsToConsume {
            let result = this.itemStock.DecreaseQuantityOfRandomItem(1);
            if !result.decreased {
                // Nothing to take anymore
                break;
            }

            consumedProducts += 1;
            // We using direct sales here
            totalIncome += marketSystem.PriceItem(result.decreasedItemId, true);
            i += 1;
        }

        if this.IsBrothel() {
            // Brothels earn passive income boosted by Joytoy's kiss
            totalIncome = RandRange(
                settings.OperationBrothelMinRevenue(),
                settings.OperationBrothelMaxRevenue() + 1
            ) * (suppliedWithJoytoysKiss ? 1 + consumedProducts : 1);
        }

        if IsCorpo() {
            // Corpo bonus
            totalIncome = RoundF((1.0 + Constants.CorpoAdditiveSalesBonus()) * Cast<Float>(totalIncome));
        }

        let cut = CeilF(Cast<Float>(totalIncome) * settings.OperationProfitCut());
        totalIncome -= cut;

        return OperationResult(this.turfLocation, this.type, consumedProducts, totalIncome, cut);
    }

    public func IsAtFullCapacity() -> Bool = this.itemStock.TotalQuantity() >= Constants.OperationMaxCapacity();

    public func GetMappinType() -> DrugDealerMappinType {
        if this.IsBrothel() {
            return DrugDealerMappinType.Brothel;
        }
        return DrugDealerMappinType.Pushers;
    }

    public func GetEstimatedDailyIncome(marketSystem: wref<MarketSystem>, settings: wref<SettingsSystem>) -> Int32 {
        if !IsDefined(marketSystem) || !IsDefined(settings) || !this.IsActive() {
            return 0;
        }

        if this.IsBrothel() {
            // Brothels earn passive income boosted by Joytoy's kiss
            let brothelRevenue = (settings.OperationBrothelMinRevenue() + settings.OperationBrothelMaxRevenue()) / 2;
            let boostedBrothelRevenue = brothelRevenue
                * (this.IsSuppliedWithJoytoysKiss() ? Constants.OperationBrothelEstimateRevenueMultiplier() : 1);
            if IsCorpo() {
                // Corpo bonus
                return RoundF(
                    (1.0 + Constants.CorpoAdditiveSalesBonus()) * Cast<Float>(boostedBrothelRevenue)
                );
            }
            return boostedBrothelRevenue;
        }

        // Estimate is based on just averages
        let averagePrice = marketSystem.EstimateBulk(this.itemStock.itemIds, this.itemStock.quantity) / this.itemStock.TotalQuantity();
        let averageProductConsumed = (Constants.OperationMinProductsConsumed() + Constants.OperationMaxProductsConsumed()) / 2;
        let finalEstimate = averagePrice * averageProductConsumed;
        if IsCorpo() {
            // Corpo bonus
            return RoundF((1.0 + Constants.CorpoAdditiveSalesBonus()) * Cast<Float>(finalEstimate));
        }
        return finalEstimate;
    }

    public func GetSupplyInPercents() -> Int32 {
        let totalQuantity = this.itemStock.TotalQuantity();
        if totalQuantity <= 0 {
            // Empty
            return 0;
        }

        return RoundF(
            Cast<Float>(this.itemStock.TotalQuantity()) / Cast<Float>(Constants.OperationMaxCapacity()) * 100.0
        );
    }

    public func GetSupplyColor() -> HDRColor {
        let supply = this.GetSupplyInPercents();
        if supply <= 0 {
            return Colors.Gray();
        }
        if supply <= 24 {
            return ThemeColors.RedOxide();
        }
        if supply <= 49 {
            return ThemeColors.Dandelion();
        }
        if supply <= 74 {
            return ThemeColors.PureWhite();
        }

        return ThemeColors.LightGreen();
    }

    public func GetMappinLocalization() -> String = s"\(TranslateOperationType(this.type)) \(TranslateOrganization(this.organization))";

    public func GetTurfLocalization() -> String = TranslateTurfLocation(this.turfLocation);

    public func GetTypeLocalization() -> String = TranslateOperationType(this.type);

    public func GetTypeColor() -> HDRColor = this.IsPushers() ? Colors.DarkMagenta() : Colors.PastelPink();

    public func GetStatusLocalization() -> String = TranslateOperationStatus(this.status);

    public func GetStatusColor() -> HDRColor = this.IsActive() ? ThemeColors.LightGreen() : Colors.Gray();

    public func GetDailyIncomeColor() -> HDRColor {
        if this.IsBrothel() {
            return this.IsActive() ? ThemeColors.LightGreen() : Colors.Gray();
        }
        return this.IsActive() && this.itemStock.TotalQuantity() > 0 ? ThemeColors.LightGreen() : Colors.Gray();
    }

    public func GetOrganizationLocalization() -> String = TranslateOrganization(this.organization);

    public func GetTurfLocationColor() -> HDRColor {
        switch this.turfLocation {
            case TurfLocation.Watson:
                return Colors.DarkRed();
            case TurfLocation.SantoDomingo:
                return Colors.PurpleBlue();
            case TurfLocation.Badlands:
                return Colors.SandyYellow();
            case TurfLocation.Westbrook:
                return Colors.Orange();
            case TurfLocation.Heywood:
                return Colors.LightGreen();
            case TurfLocation.Pacifica:
                return Colors.Purple();
            default:
                return Colors.Gray();
        }
    }

    public func GetSupplyIndicationLocalization() -> String {
        let supply = this.GetSupplyInPercents();
        let supplyIndication = n"DD.Operation.Supply.Full";

        if supply <= 0 {
            supplyIndication = n"DD.Operation.Supply.Empty";
        } else if supply <= 24 {
            supplyIndication = n"DD.Operation.Supply.Low";
        } else if supply <= 59 {
            supplyIndication = n"DD.Operation.Supply.Medium";
        } else if supply <= 99 {
            supplyIndication = n"DD.Operation.Supply.High";
        }

        return GetLocalizedTextByKey(supplyIndication);
    }

    public func GetSupplySidenotificationStyle() -> SideNotificationStyle {
        let supply = this.GetSupplyInPercents();

        if supply <= 0 {
            return SideNotificationStyle.Danger;
        }
        if supply <= 24 {
            return SideNotificationStyle.Warning;
        }
        if supply <= 59 {
            return SideNotificationStyle.Partial;
        }
        if supply <= 99 {
            return SideNotificationStyle.Positive;
        }

        return SideNotificationStyle.Information;
    }

    public func IsSuppliedWithJoytoysKiss() -> Bool = this.itemStock.GetItemQuantity(t"DrugDealer.Drug.JoytoysKiss") > 0;

    public func IsActive() -> Bool = Equals(OperationStatus.Active, this.status);

    public func IsPushers() -> Bool = Equals(OperationType.Pushers, this.type);

    public func IsBrothel() -> Bool = Equals(OperationType.Brothel, this.type);
}

public func GetOperationStructure() -> array<ref<Operation>> = [
    /* Watson */ Operation
        .Create(
            TurfLocation.Watson,
            Vector4(-1319.4097, 2232.5103, 15.7690735, 1.0),
            n"$/#drugdealer/watson/pushers1",
            OperationType.Pushers,
            Organization.Scavengers
        ),
    Operation
        .Create(
            TurfLocation.Watson,
            Vector4(-1436.9773, 2955.2783, 7.118004, 1.0),
            n"$/#drugdealer/watson/pushers2",
            OperationType.Pushers,
            Organization.Maelstrom
        ),
    Operation
        .Create(
            TurfLocation.Watson,
            Vector4(-535.38416, 2375.7336, 54.982384, 1.0),
            n"$/#drugdealer/watson/pushers3",
            OperationType.Pushers,
            Organization.Animals
        ),
    Operation
        .Create(
            TurfLocation.Watson,
            Vector4(-1519.2968, 2197.9705, 22.19754, 1.0),
            n"$/#drugdealer/watson/brothel1",
            OperationType.Brothel,
            Organization.Prostitutes
        ),
    /* Santo Domingo */ Operation
        .Create(
            TurfLocation.SantoDomingo,
            Vector4(105.67403, -1951.8901, 4.655731, 1.0),
            n"$/#drugdealer/santodomingo/pushers1",
            OperationType.Pushers,
            Organization.SixthStreet
        ),
    Operation
        .Create(
            TurfLocation.SantoDomingo,
            Vector4(988.90564, -1091.496, 28.242462, 1.0),
            n"$/#drugdealer/santodomingo/pushers2",
            OperationType.Pushers,
            Organization.Valentinos
        ),
    Operation
        .Create(
            TurfLocation.SantoDomingo,
            Vector4(934.69617, -903.53705, 31.044022, 1.0),
            n"$/#drugdealer/santodomingo/brothel1",
            OperationType.Brothel,
            Organization.Prostitutes
        ),
    /* Badlands */ Operation
        .Create(
            TurfLocation.Badlands,
            Vector4(1211.116, -450.2743, 35.116135, 1.0),
            n"$/#drugdealer/badlands/pushers1",
            OperationType.Pushers,
            Organization.Wraiths
        ),
    Operation
        .Create(
            TurfLocation.Badlands,
            Vector4(1665.1396, -785.0161, 53.84133, 1.0),
            n"$/#drugdealer/badlands/brothel1",
            OperationType.Brothel,
            Organization.Prostitutes
        ),
    /* Westbrook */ Operation
        .Create(
            TurfLocation.Westbrook,
            Vector4(-319.54303, 1395.6965, 43.034622, 1.0),
            n"$/#drugdealer/westbrook/pushers1",
            OperationType.Pushers,
            Organization.Moxes
        ),
    Operation
        .Create(
            TurfLocation.Westbrook,
            Vector4(-664.74384, 941.64014, 19.90857, 1.0),
            n"$/#drugdealer/westbrook/pushers2",
            OperationType.Pushers,
            Organization.TygerClaws
        ),
    Operation
        .Create(
            TurfLocation.Westbrook,
            Vector4(-564.943, 341.5024, 23.11267, 1.0),
            n"$/#drugdealer/westbrook/brothel1",
            OperationType.Brothel,
            Organization.Moxes
        ),
    /* Heywood */ Operation
        .Create(
            TurfLocation.Heywood,
            Vector4(-1138.7456, -1045.707, 13.184639, 1.0),
            n"$/#drugdealer/heywood/pushers1",
            OperationType.Pushers,
            Organization.Valentinos
        ),
    Operation
        .Create(
            TurfLocation.Heywood,
            Vector4(-2437.308, -964.5036, 7.9048767, 1.0),
            n"$/#drugdealer/heywood/pushers2",
            OperationType.Pushers,
            Organization.SixthStreet
        ),
    Operation
        .Create(
            TurfLocation.Heywood,
            Vector4(-2373.7817, -946.58466, 8.193665, 1.0),
            n"$/#drugdealer/heywood/brothel1",
            OperationType.Brothel,
            Organization.Prostitutes
        ),
    /* Pacifica */ Operation
        .Create(
            TurfLocation.Pacifica,
            Vector4(-2817.0483, -2447.9429, 16.092949, 1.0),
            n"$/#drugdealer/pacifica/pushers1",
            OperationType.Pushers,
            Organization.VoodooBoys
        ),
    Operation
        .Create(
            TurfLocation.Pacifica,
            Vector4(-2129.1904, -2058.903, 15.622063, 1.0),
            n"$/#drugdealer/pacifica/pushers2",
            OperationType.Pushers,
            Organization.Animals
        ),
    Operation
        .Create(
            TurfLocation.Pacifica,
            Vector4(-2550.801, -2486.3445, 23.0, 1.0),
            n"$/#drugdealer/pacifica/brothel1",
            OperationType.Brothel,
            Organization.Prostitutes
        )
];

