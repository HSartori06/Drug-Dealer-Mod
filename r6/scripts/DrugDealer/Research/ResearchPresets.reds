module DrugDealer.Research

import DrugDealer.State.{DrugDealerRank}

// -----------------------------------------------------------------------------
// ResearchPresets - Drug Dealer
// -----------------------------------------------------------------------------
public class ResearchPreset {
    public let itemId: TweakDBID;
    public let research: CName;
    public let researchDone: CName;
    public let cost: Int32;
    public let availableFromRank: DrugDealerRank;

    public static func Create(
        itemId: TweakDBID,
        research: CName,
        researchDone: CName,
        cost: Int32,
        availableFromRank: DrugDealerRank
    ) -> ref<ResearchPreset> {
        let item = new ResearchPreset();
        item.itemId = itemId;
        item.research = research;
        item.researchDone = researchDone;
        item.cost = cost;
        item.availableFromRank = availableFromRank;
        return item;
    }
}

public abstract class ResearchPresets {
    public static func GetResearchPresets() -> array<ref<ResearchPreset>> = [
        ResearchPreset
            .Create(
                t"DrugDealer.Drug.JoytoysKiss",
                n"DD.Drug.JoytoysKiss.Research",
                n"DD.Drug.JoytoysKiss.Research.Done",
                7500,
                DrugDealerRank.CornerBoy
            ),
        ResearchPreset
            .Create(
                t"DrugDealer.Drug.NeonGlow",
                n"DD.Drug.NeonGlow.Research",
                n"DD.Drug.NeonGlow.Research.Done",
                9000,
                DrugDealerRank.CornerBoy
            ),
        ResearchPreset
            .Create(
                t"DrugDealer.Drug.SandstormV2",
                n"DD.Drug.SandstormV2.Research",
                n"DD.Drug.SandstormV2.Research.Done",
                12000,
                DrugDealerRank.Slinger
            ),
        ResearchPreset
            .Create(
                t"DrugDealer.Drug.BeastOut",
                n"DD.Drug.BeastOut.Research",
                n"DD.Drug.BeastOut.Research.Done",
                20000,
                DrugDealerRank.StreetDealer
            ),
        ResearchPreset
            .Create(
                t"DrugDealer.Drug.Pixie",
                n"DD.Drug.Pixie.Research",
                n"DD.Drug.Pixie.Research.Done",
                30000,
                DrugDealerRank.Lieutenant
            ),
        ResearchPreset
            .Create(
                t"DrugDealer.Drug.VoidGaze",
                n"DD.Drug.VoidGaze.Research",
                n"DD.Drug.VoidGaze.Research.Done",
                45000,
                DrugDealerRank.Supplier
            ),
        ResearchPreset
            .Create(
                t"DrugDealer.Drug.GridKing",
                n"DD.Drug.GridKing.Research",
                n"DD.Drug.GridKing.Research.Done",
                70000,
                DrugDealerRank.Underboss
            ),
        ResearchPreset
            .Create(
                t"DrugDealer.Drug.ThreeMoons",
                n"DD.Drug.ThreeMoons.Research",
                n"DD.Drug.ThreeMoons.Research.Done",
                100000,
                DrugDealerRank.DrugLord
            ),
        ResearchPreset
            .Create(
                t"DrugDealer.Drug.EmperorsEyes",
                n"DD.Drug.EmperorsEyes.Research",
                n"DD.Drug.EmperorsEyes.Research.Done",
                200000,
                DrugDealerRank.Kingpin
            )
    ];
}

