module DrugDealer.Lab

import DrugDealer.Research.{ResearchSystem}
import NightlyNow.Transaction.{GetItemCount}

// -----------------------------------------------------------------------------
// Cookbook - Drug Dealer
// -----------------------------------------------------------------------------
public class CookbookSystem extends ScriptableSystem {
    // Lazy eval
    private let labInteractionController: wref<LabInteractionController>;
    // Lazy eval
    private let researchSystem: wref<ResearchSystem>;

    public static func Get() -> ref<CookbookSystem> {
        return GameInstance
            .GetScriptableSystemsContainer(GetGameInstance())
            .Get(n"DrugDealer.Lab.CookbookSystem") as CookbookSystem;
    }

    // Lazy eval
    private func GetLabInteractionController() -> wref<LabInteractionController> {
        if !IsDefined(this.labInteractionController) {
            this.labInteractionController = LabInteractionController.Get();
        }
        return this.labInteractionController;
    }

    // Lazy eval
    private func GetResearchSystem() -> wref<ResearchSystem> {
        if !IsDefined(this.researchSystem) {
            this.researchSystem = ResearchSystem.Get();
        }
        return this.researchSystem;
    }

    // What we cookin' today
    public func OpenCookbook() {
        let cookbookShard = new NotifyShardRead();
        cookbookShard.title = "Cookbook";

        cookbookShard.text = this.GetIntroduction() + "\n\n" + this.GetBody() + "\n\n" + GetLocalizedTextByKey(n"DD.Cookbook.End");

        GameInstance.GetUISystem(GetGameInstance()).QueueEvent(cookbookShard);
    }

    private func GetIntroduction() -> String {
        let researchSystem = this.GetResearchSystem();
        if !IsDefined(researchSystem) {
            return "";
        }

        let researchedDrugs = researchSystem.GetResearchedDrugs();

        let researchedCount = ArraySize(researchedDrugs);
        if researchedCount == 1 {
            return GetLocalizedTextByKey(n"DD.Cookbook.IntroSingular");
        }
        return StrReplace(
            GetLocalizedTextByKey(n"DD.Cookbook.IntroPlural"),
            "{0}",
            ToString(researchedCount)
        );
    }

    private func GetBody() -> String {
        let researchSystem = this.GetResearchSystem();
        let segments: array<String> = [];
        for recipe in GetLabRecipes() {
            if researchSystem.IsDrugResearched(recipe.product) {
                ArrayPush(segments, this.GetProductSegment(recipe));
            }
        }
        return this.Join(segments, "\n\n");
    }

    private func GetProductSegment(recipe: ref<LabRecipe>) -> String {
        let cookableDoses = this.GetCookableDoses(recipe);
        let productLine = StrReplace(
            GetLocalizedTextByKey(n"DD.Cookbook.Product"),
            "{0}",
            this.GetLocalizedItemName(recipe.product)
        );
        productLine = StrReplace(productLine, "{1}", this.GetCookStatus(cookableDoses));

        let lines: array<String> = [productLine];
        let materialIndex = 0;
        for material in recipe.materials {
            ArrayPush(
                lines,
                this.GetLocalizedItemName(material)
                    + " ("
                    + ToString(GetItemCount(material))
                    + "/"
                    + ToString(recipe.quantity[materialIndex])
                    + ")"
            );
            materialIndex += 1;
        }
        ArrayPush(
            lines,
            StrReplace(
                GetLocalizedTextByKey(n"DD.Cookbook.Note"),
                "{0}",
                this.GetProductNote(recipe.product)
            )
        );
        return this.Join(lines, "\n");
    }

    private func GetProductNote(productId: TweakDBID) -> String {
        switch productId {
            case t"DrugDealer.Drug.Y99":
                return GetLocalizedTextByKey(n"DD.Drug.Y99.Note");
            case t"DrugDealer.Drug.JoytoysKiss":
                return GetLocalizedTextByKey(n"DD.Drug.JoytoysKiss.Note");
            case t"DrugDealer.Drug.NeonGlow":
                return GetLocalizedTextByKey(n"DD.Drug.NeonGlow.Note");
            case t"DrugDealer.Drug.SandstormV2":
                return GetLocalizedTextByKey(n"DD.Drug.SandstormV2.Note");
            case t"DrugDealer.Drug.BeastOut":
                return GetLocalizedTextByKey(n"DD.Drug.BeastOut.Note");
            case t"DrugDealer.Drug.Pixie":
                return GetLocalizedTextByKey(n"DD.Drug.Pixie.Note");
            case t"DrugDealer.Drug.VoidGaze":
                return GetLocalizedTextByKey(n"DD.Drug.VoidGaze.Note");
            case t"DrugDealer.Drug.GridKing":
                return GetLocalizedTextByKey(n"DD.Drug.GridKing.Note");
            case t"DrugDealer.Drug.ThreeMoons":
                return GetLocalizedTextByKey(n"DD.Drug.ThreeMoons.Note");
            case t"DrugDealer.Drug.EmperorsEyes":
                return GetLocalizedTextByKey(n"DD.Drug.EmperorsEyes.Note");
            default:
                return "";
        }
    }

    private func GetCookableDoses(recipe: ref<LabRecipe>) -> Int32 {
        let cookableDoses = -1;
        let materialIndex = 0;
        for material in recipe.materials {
            let possibleDoses = GetItemCount(material) / recipe.quantity[materialIndex];
            if cookableDoses < 0 || possibleDoses < cookableDoses {
                cookableDoses = possibleDoses;
            }
            materialIndex += 1;
        }
        return cookableDoses < 0 ? 0 : cookableDoses;
    }

    private func GetCookStatus(cookableDoses: Int32) -> String {
        if cookableDoses <= 0 {
            return GetLocalizedTextByKey(n"DD.Cookbook.CantCook");
        }
        if cookableDoses == 1 {
            return GetLocalizedTextByKey(n"DD.Cookbook.SingleDose");
        }
        return StrReplace(
            GetLocalizedTextByKey(n"DD.Cookbook.MultipleDoses"),
            "{0}",
            ToString(cookableDoses)
        );
    }

    private func GetLocalizedItemName(itemId: TweakDBID) -> String = GetLocalizedTextByKey(TweakDBInterface.GetItemRecord(itemId).DisplayName());

    private func Join(parts: array<String>, separator: String) -> String {
        let result = "";
        let partIndex = 0;
        for part in parts {
            if partIndex > 0 {
                result += separator;
            }
            result += part;
            partIndex += 1;
        }
        return result;
    }

    public func ShowSideNotification() {
        let labInteractionController = this.GetLabInteractionController();
        if IsDefined(labInteractionController) {
            labInteractionController.ShowSideNotification();
        }
    }

    public func HideSideNotification() {
        let labInteractionController = this.GetLabInteractionController();
        if IsDefined(labInteractionController) {
            labInteractionController.HideSideNotification();
        }
    }
}

// We catching events here for proper behaviour of them side notifs,. otherwise they get displayed behind the cookbook shard
@wrapMethod(PopupsManager)
protected cb func OnShardRead(evt: ref<NotifyShardRead>) -> Bool {
    let result = wrappedMethod(evt);
    if !Equals(GetLocalizedTextByKey(n"DD.Cookbook.Title"), evt.title) {
        // Not the cookbook shard
        return result;
    }

    if true {
        let cookbookSystem = CookbookSystem.Get();
        if IsDefined(cookbookSystem) {
            cookbookSystem.HideSideNotification();
        }
    }

    return result;
}

// Logs when a shard reader popup closes
@wrapMethod(PopupsManager)
protected cb func OnShardReadClosed(data: ref<inkGameNotificationData>) -> Bool {
    let result = wrappedMethod(data);
    let shardData = data as ShardReadPopupData;

    if !IsDefined(shardData) || !Equals(GetLocalizedTextByKey(n"DD.Cookbook.Title"), shardData.title) {
        // Not the cookbook shard
        return result;
    }

    if true {
        let cookbookSystem = CookbookSystem.Get();
        if IsDefined(cookbookSystem) {
            cookbookSystem.ShowSideNotification();
        }
    }

    return result;
}

