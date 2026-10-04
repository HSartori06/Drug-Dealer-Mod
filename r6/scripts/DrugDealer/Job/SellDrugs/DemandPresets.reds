module DrugDealer.Job.SellDrugs

import DrugDealer.State.{PlayerStateSystem, DrugDealerRank}
import DrugDealer.Research.ResearchSystem
import DrugDealer.Market.{MarketSystem}
import DrugDealer.Settings.Constants

// -----------------------------------------------------------------------------
// DemandPresets - Drug Dealer
// -----------------------------------------------------------------------------
public class DrugDemand {
    public persistent let drugs: array<TweakDBID>;
    public persistent let quantity: array<Int32>;
    public persistent let worth: Int32;

    // Demand to string to be used in messages, e.g. "2x Y-99"
    public func ToString() -> String {
        let result = "";
        let i = 0;
        while i < ArraySize(this.drugs) {
            if i > 0 {
                result += ", ";
            }
            let name = GetLocalizedTextByKey(DrugDemand.GetLocKey(this.drugs[i]));
            result += ToString(this.quantity[i]) + "x " + name;
            i += 1;
        }
        return result;
    }

    // Map drug TweakDBID to localization key
    private static func GetLocKey(drug: TweakDBID) -> CName {
        if Equals(drug, t"DrugDealer.Drug.Y99") {
            return n"DD.Drug.Y99";
        }
        if Equals(drug, t"DrugDealer.Drug.JoytoysKiss") {
            return n"DD.Drug.JoytoysKiss";
        }
        if Equals(drug, t"DrugDealer.Drug.NeonGlow") {
            return n"DD.Drug.NeonGlow";
        }
        if Equals(drug, t"DrugDealer.Drug.SandstormV2") {
            return n"DD.Drug.SandstormV2";
        }
        if Equals(drug, t"DrugDealer.Drug.BeastOut") {
            return n"DD.Drug.BeastOut";
        }
        if Equals(drug, t"DrugDealer.Drug.Pixie") {
            return n"DD.Drug.Pixie";
        }
        if Equals(drug, t"DrugDealer.Drug.VoidGaze") {
            return n"DD.Drug.VoidGaze";
        }
        if Equals(drug, t"DrugDealer.Drug.GridKing") {
            return n"DD.Drug.GridKing";
        }
        if Equals(drug, t"DrugDealer.Drug.ThreeMoons") {
            return n"DD.Drug.ThreeMoons";
        }
        if Equals(drug, t"DrugDealer.Drug.EmperorsEyes") {
            return n"DD.Drug.EmperorsEyes";
        }
        return n"";
    }
}

// This is to be expanded as more drugs are added
public abstract class DemandPresets {
    // Create demand from researched drugs with chance for multi-drug deals
    public static func GetDrugDemandPreset(opt highSocietyDemand: Bool) -> ref<DrugDemand> {
        // Required systems
        let marketSystem = MarketSystem.Get();
        if !IsDefined(marketSystem) {
            return null;
        }
        let playerStateSystem = PlayerStateSystem.Get();
        if !IsDefined(playerStateSystem) {
            return null;
        }
        let researchSystem = ResearchSystem.Get();
        if !IsDefined(researchSystem) {
            return null;
        }

        let rank = EnumInt(playerStateSystem.GetRank());
        // Either premium grade or street grade drugs
        let eligibleDrugPool = highSocietyDemand ? researchSystem.GetResearchedPremiumDrugs() : researchSystem.GetResearchedStreetDrugs();
        let demand = new DrugDemand();
        let totalWorth = 0;

        // Pick first drug randomly
        let idx = RandRange(0, ArraySize(eligibleDrugPool));
        let quantity = DemandPresets.GenerateQuantity(highSocietyDemand, rank);
        ArrayPush(demand.drugs, eligibleDrugPool[idx]);
        ArrayPush(demand.quantity, quantity);
        totalWorth += quantity * marketSystem.PriceItem(eligibleDrugPool[idx], true);
        ArrayErase(eligibleDrugPool, idx);

        // 50% chance for a second drug
        if ArraySize(eligibleDrugPool) > 0 && RandRange(0, 100) < 50 {
            idx = RandRange(0, ArraySize(eligibleDrugPool));
            quantity = DemandPresets.GenerateQuantity(highSocietyDemand, rank);
            ArrayPush(demand.drugs, eligibleDrugPool[idx]);
            ArrayPush(demand.quantity, quantity);
            totalWorth += quantity * marketSystem.PriceItem(eligibleDrugPool[idx], true);
            ArrayErase(eligibleDrugPool, idx);

            // 10% chance for a third drug
            if ArraySize(eligibleDrugPool) > 0 && RandRange(0, 100) < 10 {
                idx = RandRange(0, ArraySize(eligibleDrugPool));
                quantity = DemandPresets.GenerateQuantity(highSocietyDemand, rank);
                ArrayPush(demand.drugs, eligibleDrugPool[idx]);
                ArrayPush(demand.quantity, quantity);
                totalWorth
                    += quantity * marketSystem.PriceItem(eligibleDrugPool[idx], true);
            }
        }

        demand.worth = totalWorth;
        return demand;
    }

    private static func GenerateQuantity(highSocietyDemand: Bool, rank: Int32) -> Int32 {
        return highSocietyDemand ? DemandPresets.GeneratePremiumGradeQuantity() : DemandPresets.GenerateStreetGradeQuantity(rank);
    }

    private static func GenerateStreetGradeQuantity(rank: Int32) -> Int32 {
        return 1 + RandRange(0, (rank + 2));
    }

    private static func GeneratePremiumGradeQuantity() -> Int32 {
        let quantity = RandRange(
            Constants.BigDrugDealHighSocietyMinQuantity(),
            Constants.BigDrugDealHighSocietyMaxQuantity()
        );
        // Rounded to nearest tens so it looks professional, smart trick
        return (quantity + 5) / 10 * 10;
    }
}

