module DrugDealer.Research

import DrugDealer.State.{PlayerStateSystem, DrugDealerRank}
import DrugDealer.Lab.{LabRecipe, GetLabRecipes}

// -----------------------------------------------------------------------------
// ResearchSystem - Drug Dealer
// -----------------------------------------------------------------------------
public class ResearchSystem extends ScriptableSystem {
    private persistent let researchedDrugs: array<TweakDBID>;

    public static func Get() -> ref<ResearchSystem> {
        return GameInstance
            .GetScriptableSystemsContainer(GetGameInstance())
            .Get(n"DrugDealer.Research.ResearchSystem") as ResearchSystem;
    }

    public func GetResearchedStreetDrugs() -> array<TweakDBID> = this
        .IncludeOnlyTheseDrugs(
            [
                t"DrugDealer.Drug.Y99",
                t"DrugDealer.Drug.JoytoysKiss",
                t"DrugDealer.Drug.NeonGlow",
                t"DrugDealer.Drug.SandstormV2",
                t"DrugDealer.Drug.BeastOut",
                t"DrugDealer.Drug.Pixie",
                t"DrugDealer.Drug.VoidGaze",
                t"DrugDealer.Drug.GridKing"
            ]
        );

    public func GetResearchedPremiumDrugs() -> array<TweakDBID> = this
        .IncludeOnlyTheseDrugs([t"DrugDealer.Drug.ThreeMoons", t"DrugDealer.Drug.EmperorsEyes"]);

    public func AnyPremiumDrugResearched() -> Bool {
        let researchedPremiumDrugs = this.GetResearchedPremiumDrugs();
        return ArraySize(researchedPremiumDrugs) > 0;
    }

    // Returns researched drugs from input collection only
    private func IncludeOnlyTheseDrugs(drugCollection: array<TweakDBID>) -> array<TweakDBID> {
        let returnDrugs: array<TweakDBID> = [];
        for drug in drugCollection {
            if ArrayContains(this.researchedDrugs, drug) {
                ArrayPush(returnDrugs, drug);
            }
        }
        return returnDrugs;
    }

    public func GetResearchedDrugs() -> array<TweakDBID> = this.researchedDrugs;

    // Adds drug to researched list if not already present
    public func Research(drugId: TweakDBID, scoreMultiplier: Int32) {
        if !ArrayContains(this.researchedDrugs, drugId) {
            ArrayPush(this.researchedDrugs, drugId);
            let playerStateSystem = PlayerStateSystem.Get();
            if !IsDefined(playerStateSystem) {
                return;
            }
            playerStateSystem.ScoreResearch(scoreMultiplier);
        }
    }

    // Sets canDrop to true for each researched drug's materials
    public func EnableResearchedLoot() {
        let recipes = GetLabRecipes();

        for recipe in recipes {
            if ArrayContains(this.researchedDrugs, recipe.product) {
                for material in recipe.materials {
                    TweakDBManager.SetFlat(material + t".canDrop", true);
                    TweakDBManager.UpdateRecord(material);
                }
            }
        }
    }

    // Checks if drug has been researched
    public func IsDrugResearched(drugId: TweakDBID) -> Bool = ArrayContains(this.researchedDrugs, drugId);

    // Returns first unresearched preset matching player rank
    public func GetAvailableResearch() -> ref<ResearchPreset> {
        let playerStateSystem = PlayerStateSystem.Get();
        if !IsDefined(playerStateSystem) {
            return null;
        }
        let playerRank = playerStateSystem.GetRank();
        for preset in ResearchPresets.GetResearchPresets() {
            if !ArrayContains(this.researchedDrugs, preset.itemId) && EnumInt(preset.availableFromRank) <= EnumInt(playerRank) {
                return preset;
            }
        }
        return null;
    }
}

// Y-99 is researched by default
@wrapMethod(PlayerPuppet)
protected cb func OnGameAttached() -> Bool {
    wrappedMethod();

    let systemRequestsHandler: ref<inkISystemRequestsHandler> = GameInstance.GetSystemRequestsHandler();
    if IsDefined(systemRequestsHandler) && systemRequestsHandler.IsPreGame() {
        // Prevents firing up in MM
        return true;
    }

    let researchSystem = ResearchSystem.Get();
    if !IsDefined(researchSystem) {
        return true;
    }

    // Add base drug that is always available
    researchSystem.Research(t"DrugDealer.Drug.Y99", 0);

    // Enable loot drops for researched drug materials
    researchSystem.EnableResearchedLoot();
}

