module DrugDealer.NightMarket

import NightlyNow.Transaction.AddItem
import NightlyNow.Utils.IsNomad
import DrugDealer.Research.ResearchSystem
import DrugDealer.Settings.Constants

// -----------------------------------------------------------------------------
// Crate - Drug Dealer
// -----------------------------------------------------------------------------
public func OpenCrate() {
    let researchSystem = ResearchSystem.Get();
    if !IsDefined(researchSystem) {
        return;
    }

    // Y-99 mats
    AddCrateMaterial(t"DrugDealer.Drug.Y99.Material.1", 5, 11);
    AddCrateMaterial(t"DrugDealer.Drug.Y99.Material.2", 10, 15);

    if researchSystem.IsDrugResearched(t"DrugDealer.Drug.JoytoysKiss") {
        // Joytoy's kiss researched
        AddCrateMaterial(t"DrugDealer.Drug.JoytoysKiss.Material.1", 5, 11);
        AddCrateMaterial(t"DrugDealer.Drug.JoytoysKiss.Material.2", 10, 15);
    }

    if researchSystem.IsDrugResearched(t"DrugDealer.Drug.NeonGlow") {
        // NeonGlow researched
        AddCrateMaterial(t"DrugDealer.Drug.NeonGlow.Material.1", 10, 20);
        AddCrateMaterial(t"DrugDealer.Drug.NeonGlow.Material.2", 10, 20);
    }

    if researchSystem.IsDrugResearched(t"DrugDealer.Drug.SandstormV2") {
        // SandstormV2 researched
        AddCrateMaterial(t"DrugDealer.Drug.SandstormV2.Material.1", 5, 10);
        AddCrateMaterial(t"DrugDealer.Drug.SandstormV2.Material.2", 3, 6);
        AddCrateMaterial(t"DrugDealer.Drug.SandstormV2.Material.3", 3, 6);
    }

    if researchSystem.IsDrugResearched(t"DrugDealer.Drug.BeastOut") {
        // BeastOut researched
        AddCrateMaterial(t"DrugDealer.Drug.BeastOut.Material.1", 5, 10);
        AddCrateMaterial(t"DrugDealer.Drug.BeastOut.Material.2", 3, 6);
        AddCrateMaterial(t"DrugDealer.Drug.BeastOut.Material.3", 3, 6);
    }

    if researchSystem.IsDrugResearched(t"DrugDealer.Drug.Pixie") {
        // Pixie researched
        AddCrateMaterial(t"DrugDealer.Drug.Pixie.Material.1", 5, 10);
        AddCrateMaterial(t"DrugDealer.Drug.Pixie.Material.2", 3, 6);
        AddCrateMaterial(t"DrugDealer.Drug.Pixie.Material.3", 3, 6);
    }

    if researchSystem.IsDrugResearched(t"DrugDealer.Drug.VoidGaze") {
        // VoidGaze researched
        AddCrateMaterial(t"DrugDealer.Drug.VoidGaze.Material.1", 5, 10);
        AddCrateMaterial(t"DrugDealer.Drug.VoidGaze.Material.2", 3, 6);
        AddCrateMaterial(t"DrugDealer.Drug.VoidGaze.Material.3", 3, 6);
    }

    if researchSystem.IsDrugResearched(t"DrugDealer.Drug.GridKing") {
        // GridKing researched
        AddCrateMaterial(t"DrugDealer.Drug.GridKing.Material.1", 4, 7);
        AddCrateMaterial(t"DrugDealer.Drug.GridKing.Material.2", 4, 7);
        AddCrateMaterial(t"DrugDealer.Drug.GridKing.Material.3", 4, 7);
    }

    if researchSystem.IsDrugResearched(t"DrugDealer.Drug.ThreeMoons") {
        // 3Moons researched
        AddCrateMaterial(t"DrugDealer.Drug.ThreeMoons.Material.1", 2, 5);
        AddCrateMaterial(t"DrugDealer.Drug.ThreeMoons.Material.2", 2, 5);
    }

    if researchSystem.IsDrugResearched(t"DrugDealer.Drug.EmperorsEyes") {
        // Emperor's eyes researched
        AddCrateMaterial(t"DrugDealer.Drug.EmperorsEyes.Material.1", 1, 3);
        AddCrateMaterial(t"DrugDealer.Drug.EmperorsEyes.Material.2", 1, 3);
        AddCrateMaterial(t"DrugDealer.Drug.EmperorsEyes.Material.3", 1, 3);
    }
}

public func AddCrateMaterial(itemId: TweakDBID, minAmount: Int32, maxAmount: Int32) {
    let scaledMin = minAmount;
    let scaledMax = maxAmount;
    let isNomad = IsNomad();
    if isNomad {
        // Nomad extra volume bonus, rounded up
        let multiplier = Constants.NomadNightMarketExtraVolume();
        scaledMin = CeilF(Cast<Float>(minAmount) * multiplier);
        scaledMax = CeilF(Cast<Float>(maxAmount) * multiplier);
    }
    AddItem(itemId, RandRange(scaledMin, scaledMax + 1));
}

