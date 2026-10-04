module DrugDealer.Lab

// -----------------------------------------------------------------------------
// LabRecipes - Drug Dealer
// -----------------------------------------------------------------------------
public enum DrugCategory {
    None = 0,
    Deliriants = 1,
    Depressants = 2,
    Dissociatives = 3,
    Empathogens = 4,
    Psychedelics = 5,
    Stimulants = 6,
}

public class LabRecipe {
    public let product: TweakDBID;
    public let category: DrugCategory;
    public let materials: array<TweakDBID>;
    public let quantity: array<Int32>;
    public let score: Int32 = 1;

    public static func Create(
        product: TweakDBID,
        category: DrugCategory,
        materials: array<TweakDBID>,
        quantity: array<Int32>,
        score: Int32
    ) -> ref<LabRecipe> {
        let labRecipe = new LabRecipe();
        labRecipe.product = product;
        labRecipe.category = category;
        labRecipe.materials = materials;
        labRecipe.quantity = quantity;
        labRecipe.score = score;
        return labRecipe;
    }
}

public func GetLabRecipes() -> array<ref<LabRecipe>> = [
    /* Y-99 */ LabRecipe
        .Create(
            t"DrugDealer.Drug.Y99",
            DrugCategory.Stimulants,
            [t"DrugDealer.Drug.Y99.Material.1", t"DrugDealer.Drug.Y99.Material.2"],
            [2, 4],
            2
        ),
    /* Joytoy's Kiss */ LabRecipe
        .Create(
            t"DrugDealer.Drug.JoytoysKiss",
            DrugCategory.Empathogens,
            [
                t"DrugDealer.Drug.JoytoysKiss.Material.1",
                t"DrugDealer.Drug.JoytoysKiss.Material.2"
            ],
            [2, 2],
            4
        ),
    /* NeonGlow */ LabRecipe
        .Create(
            t"DrugDealer.Drug.NeonGlow",
            DrugCategory.Depressants,
            [
                t"DrugDealer.Drug.NeonGlow.Material.1",
                t"DrugDealer.Drug.NeonGlow.Material.2"
            ],
            [1, 1],
            1
        ),
    /* Sandstorm V2 */ LabRecipe
        .Create(
            t"DrugDealer.Drug.SandstormV2",
            DrugCategory.Deliriants,
            [
                t"DrugDealer.Drug.SandstormV2.Material.1",
                t"DrugDealer.Drug.SandstormV2.Material.2",
                t"DrugDealer.Drug.SandstormV2.Material.3"
            ],
            [4, 2, 2],
            6
        ),
    /* BeastOut */ LabRecipe
        .Create(
            t"DrugDealer.Drug.BeastOut",
            DrugCategory.Stimulants,
            [
                t"DrugDealer.Drug.BeastOut.Material.1",
                t"DrugDealer.Drug.BeastOut.Material.2",
                t"DrugDealer.Drug.BeastOut.Material.3"
            ],
            [3, 1, 1],
            8
        ),
    /* Pixie */ LabRecipe
        .Create(
            t"DrugDealer.Drug.Pixie",
            DrugCategory.Psychedelics,
            [
                t"DrugDealer.Drug.Pixie.Material.1",
                t"DrugDealer.Drug.Pixie.Material.2",
                t"DrugDealer.Drug.Pixie.Material.3"
            ],
            [3, 2, 1],
            10
        ),
    /* VoidGaze */ LabRecipe
        .Create(
            t"DrugDealer.Drug.VoidGaze",
            DrugCategory.Dissociatives,
            [
                t"DrugDealer.Drug.VoidGaze.Material.1",
                t"DrugDealer.Drug.VoidGaze.Material.2",
                t"DrugDealer.Drug.VoidGaze.Material.3"
            ],
            [5, 3, 3],
            14
        ),
    /* GridKing */ LabRecipe
        .Create(
            t"DrugDealer.Drug.GridKing",
            DrugCategory.Deliriants,
            [
                t"DrugDealer.Drug.GridKing.Material.1",
                t"DrugDealer.Drug.GridKing.Material.2",
                t"DrugDealer.Drug.GridKing.Material.3"
            ],
            [4, 4, 4],
            25
        ),
    /* ThreeMoons */ LabRecipe
        .Create(
            t"DrugDealer.Drug.ThreeMoons",
            DrugCategory.Depressants,
            [
                t"DrugDealer.Drug.ThreeMoons.Material.1",
                t"DrugDealer.Drug.ThreeMoons.Material.2"
            ],
            [10, 10],
            75
        ),
    /* Emperor's Eyes */ LabRecipe
        .Create(
            t"DrugDealer.Drug.EmperorsEyes",
            DrugCategory.Psychedelics,
            [
                t"DrugDealer.Drug.EmperorsEyes.Material.1",
                t"DrugDealer.Drug.EmperorsEyes.Material.2",
                t"DrugDealer.Drug.EmperorsEyes.Material.3"
            ],
            [5, 5, 3],
            200
        )
];

