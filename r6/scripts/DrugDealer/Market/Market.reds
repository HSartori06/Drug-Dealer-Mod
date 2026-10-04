module DrugDealer.Market

import DrugDealer.Settings.SettingsSystem

// -----------------------------------------------------------------------------
// Market - Drug Dealer
// -----------------------------------------------------------------------------
public class MarketSystem extends ScriptableSystem {
    // Lazy eval
    private let settingsSystem: wref<SettingsSystem>;

    public static func Get() -> ref<MarketSystem> {
        return GameInstance
            .GetScriptableSystemsContainer(GetGameInstance())
            .Get(n"DrugDealer.Market.MarketSystem") as MarketSystem;
    }

    // Lazy eval
    private func GetSettingsSystem() -> wref<SettingsSystem> {
        if !IsDefined(this.settingsSystem) {
            this.settingsSystem = SettingsSystem.Get();
        }
        return this.settingsSystem;
    }

    // Get price for a single unit of a drug
    public func PriceItem(item: TweakDBID, opt directSale: Bool) -> Int32 {
        let price = 0.0;

        if Equals(item, t"DrugDealer.Drug.Y99") {
            price = RandRangeF(600.0, 900.0);
        } else if Equals(item, t"DrugDealer.Drug.JoytoysKiss") {
            price = RandRangeF(1200.0, 1500.0);
        } else if Equals(item, t"DrugDealer.Drug.NeonGlow") {
            price = RandRangeF(500.0, 800.0);
        } else if Equals(item, t"DrugDealer.Drug.SandstormV2") {
            price = RandRangeF(1600.0, 1950.0);
        } else if Equals(item, t"DrugDealer.Drug.BeastOut") {
            price = RandRangeF(2500.0, 3200.0);
        } else if Equals(item, t"DrugDealer.Drug.Pixie") {
            price = RandRangeF(5000.0, 6000.0);
        } else if Equals(item, t"DrugDealer.Drug.VoidGaze") {
            price = RandRangeF(7500.0, 9500.0);
        } else if Equals(item, t"DrugDealer.Drug.GridKing") {
            price = RandRangeF(12000.0, 15000.0);
        } else if Equals(item, t"DrugDealer.Drug.ThreeMoons") {
            price = RandRangeF(30000.0, 40000.0);
        } else if Equals(item, t"DrugDealer.Drug.EmperorsEyes") {
            price = RandRangeF(100000.0, 150000.0);
        }

        if !directSale && price > 0.0 {
            price = price * RandRangeF(0.3, 0.6);
        }

        // Apply drug price multiplier
        let settingsSystem = this.GetSettingsSystem();
        if IsDefined(settingsSystem) {
            price *= settingsSystem.revenueMultiplier;
        }

        return CeilF(price);
    }

    // Used in street operations report
    public func EstimateItem(item: TweakDBID) -> Int32 {
        let price = 0.0;
        
        if Equals(item, t"DrugDealer.Drug.Y99") {
            price = 750.0;
        } else if Equals(item, t"DrugDealer.Drug.JoytoysKiss") {
            price = 1350.0;
        } else if Equals(item, t"DrugDealer.Drug.NeonGlow") {
            price = 650.0;
        } else if Equals(item, t"DrugDealer.Drug.SandstormV2") {
            price = 1775.0;
        } else if Equals(item, t"DrugDealer.Drug.BeastOut") {
            price = 2850.0;
        } else if Equals(item, t"DrugDealer.Drug.Pixie") {
            price = 5500.0;
        } else if Equals(item, t"DrugDealer.Drug.VoidGaze") {
            price = 8500.0;
        } else if Equals(item, t"DrugDealer.Drug.GridKing") {
            price = 13500.0;
        } else if Equals(item, t"DrugDealer.Drug.ThreeMoons") {
            price = 35000.0;
        } else if Equals(item, t"DrugDealer.Drug.EmperorsEyes") {
            price = 125000.0;
        }

        // Apply revenue multiplier
        let settingsSystem = this.GetSettingsSystem();
        if IsDefined(settingsSystem) {
            price *= settingsSystem.revenueMultiplier;
        }

        return CeilF(price);
    }

    // Get total price for bulk items
    public func PriceBulk(items: array<TweakDBID>, quantities: array<Int32>, opt directSale: Bool) -> Int32 {
        let total = 0;
        let i = 0;
        while i < ArraySize(items) {
            total += this.PriceItem(items[i], directSale) * quantities[i];
            i += 1;
        }
        return total;
    }

    public func EstimateBulk(items: array<TweakDBID>, quantities: array<Int32>) -> Int32 {
        let total = 0;
        let i = 0;
        while i < ArraySize(items) {
            total += this.EstimateItem(items[i]) * quantities[i];
            i += 1;
        }
        return total;
    }    
}

