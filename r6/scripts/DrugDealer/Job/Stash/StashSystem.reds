module DrugDealer.Job.Stash

import DrugDealer.Research.ResearchSystem
import DrugDealer.Settings.SettingsSystem

// -----------------------------------------------------------------------------
// StashSystem - Drug Dealer
// -----------------------------------------------------------------------------
public class StashSystem extends ScriptableSystem {
    // Timestamp of the last stash spawned
    private persistent let lastStashTimestamp: Int32;

    public static func Get() -> ref<StashSystem> {
        return GameInstance
            .GetScriptableSystemsContainer(GetGameInstance())
            .Get(n"DrugDealer.Job.Stash.StashSystem") as StashSystem;
    }

    // Check if enough in-game time has passed to spawn a new stash
    public func CanSpawnStash() -> Bool {
        // DD settings
        let settings = SettingsSystem.Get();
        if !IsDefined(settings) {
            return false;
        }
        if !settings.stashTipsEnabled {
            // Shanice's stash tips disabled
            return false;
        }

        if this.lastStashTimestamp == 0 {
            // Called for the first time, skip
            this.MarkSpawnStashTime();
            return false;
        }

        let gameTime = GetGameInstance().GetGameTime();
        let currentTimestamp = gameTime.seconds;
        if currentTimestamp >= this.lastStashTimestamp + settings.StashAvailableInSeconds() {
            // Enough in-game time has passed
            this.MarkSpawnStashTime();
            return true;
        }
        // Not yet time
        return false;
    }

    public func FillStashWithLoot(entityId: EntityID) {
        let delaySystem = GameInstance.GetDelaySystem(GetGameInstance());
        delaySystem.DelayCallback(FillStashWithLootCallback.Create(entityId), 3.0, false);
    }

    // Record current game time as last stash spawn attempt
    private func MarkSpawnStashTime() {
        let gameTime = GetGameInstance().GetGameTime();
        this.lastStashTimestamp = gameTime.seconds;
    }
}

// Deferred callback to populate stash after entity fully resolves
public class FillStashWithLootCallback extends DelayCallback {
    let entityId: EntityID;

    public static func Create(entityId: EntityID) -> ref<FillStashWithLootCallback> {
        let callback = new FillStashWithLootCallback();
        callback.entityId = entityId;
        return callback;
    }

    public func Call() {
        let stash = GameInstance.FindEntityByID(GetGameInstance(), this.entityId) as GameObject;
        if !IsDefined(stash) {
            // Stash not spawned, should never happen
            return;
        }
        let transactionSystem = GameInstance.GetTransactionSystem(GetGameInstance());
        let researchSystem = ResearchSystem.Get();
        if !IsDefined(researchSystem) {
            return;
        }

        transactionSystem
            .GiveItem(stash, ItemID.FromTDBID(t"DrugDealer.Drug.Y99"), RandRange(3, 10));
        transactionSystem
            .GiveItem(
                stash,
                ItemID.FromTDBID(t"DrugDealer.Drug.Y99.Material.1"),
                RandRange(10, 15)
            );
        transactionSystem
            .GiveItem(
                stash,
                ItemID.FromTDBID(t"DrugDealer.Drug.Y99.Material.2"),
                RandRange(20, 30)
            );

        if researchSystem.IsDrugResearched(t"DrugDealer.Drug.JoytoysKiss") {
            // Joytoy's Kiss researched
            transactionSystem
                .GiveItem(
                    stash,
                    ItemID.FromTDBID(t"DrugDealer.Drug.JoytoysKiss"),
                    RandRange(3, 7)
                );
            transactionSystem
                .GiveItem(
                    stash,
                    ItemID.FromTDBID(t"DrugDealer.Drug.JoytoysKiss.Material.1"),
                    RandRange(5, 10)
                );
            transactionSystem
                .GiveItem(
                    stash,
                    ItemID.FromTDBID(t"DrugDealer.Drug.JoytoysKiss.Material.2"),
                    RandRange(10, 20)
                );
        }

        if researchSystem.IsDrugResearched(t"DrugDealer.Drug.NeonGlow") {
            // NeonGlow researched
            transactionSystem
                .GiveItem(
                    stash,
                    ItemID.FromTDBID(t"DrugDealer.Drug.NeonGlow"),
                    RandRange(10, 20)
                );
            transactionSystem
                .GiveItem(
                    stash,
                    ItemID.FromTDBID(t"DrugDealer.Drug.NeonGlow.Material.1"),
                    RandRange(20, 40)
                );
            transactionSystem
                .GiveItem(
                    stash,
                    ItemID.FromTDBID(t"DrugDealer.Drug.NeonGlow.Material.2"),
                    RandRange(20, 40)
                );
        }

        if researchSystem.IsDrugResearched(t"DrugDealer.Drug.SandstormV2") {
            // Sandstorm V2 researched
            transactionSystem
                .GiveItem(
                    stash,
                    ItemID.FromTDBID(t"DrugDealer.Drug.SandstormV2"),
                    RandRange(3, 7)
                );
            transactionSystem
                .GiveItem(
                    stash,
                    ItemID.FromTDBID(t"DrugDealer.Drug.SandstormV2.Material.1"),
                    RandRange(10, 20)
                );
            transactionSystem
                .GiveItem(
                    stash,
                    ItemID.FromTDBID(t"DrugDealer.Drug.SandstormV2.Material.2"),
                    RandRange(6, 12)
                );
            transactionSystem
                .GiveItem(
                    stash,
                    ItemID.FromTDBID(t"DrugDealer.Drug.SandstormV2.Material.3"),
                    RandRange(6, 12)
                );
        }

        if researchSystem.IsDrugResearched(t"DrugDealer.Drug.BeastOut") {
            // Beast Out researched
            transactionSystem
                .GiveItem(
                    stash,
                    ItemID.FromTDBID(t"DrugDealer.Drug.BeastOut"),
                    RandRange(2, 5)
                );
            transactionSystem
                .GiveItem(
                    stash,
                    ItemID.FromTDBID(t"DrugDealer.Drug.BeastOut.Material.1"),
                    RandRange(10, 20)
                );
            transactionSystem
                .GiveItem(
                    stash,
                    ItemID.FromTDBID(t"DrugDealer.Drug.BeastOut.Material.2"),
                    RandRange(6, 12)
                );
            transactionSystem
                .GiveItem(
                    stash,
                    ItemID.FromTDBID(t"DrugDealer.Drug.BeastOut.Material.3"),
                    RandRange(6, 12)
                );
        }

        if researchSystem.IsDrugResearched(t"DrugDealer.Drug.Pixie") {
            // Pixie researched
            transactionSystem
                .GiveItem(
                    stash,
                    ItemID.FromTDBID(t"DrugDealer.Drug.Pixie"),
                    RandRange(2, 5)
                );
            transactionSystem
                .GiveItem(
                    stash,
                    ItemID.FromTDBID(t"DrugDealer.Drug.Pixie.Material.1"),
                    RandRange(10, 20)
                );
            transactionSystem
                .GiveItem(
                    stash,
                    ItemID.FromTDBID(t"DrugDealer.Drug.Pixie.Material.2"),
                    RandRange(6, 12)
                );
            transactionSystem
                .GiveItem(
                    stash,
                    ItemID.FromTDBID(t"DrugDealer.Drug.Pixie.Material.3"),
                    RandRange(6, 12)
                );
        }

        if researchSystem.IsDrugResearched(t"DrugDealer.Drug.VoidGaze") {
            // VoidGaze researched
            transactionSystem
                .GiveItem(
                    stash,
                    ItemID.FromTDBID(t"DrugDealer.Drug.VoidGaze"),
                    RandRange(2, 5)
                );
            transactionSystem
                .GiveItem(
                    stash,
                    ItemID.FromTDBID(t"DrugDealer.Drug.VoidGaze.Material.1"),
                    RandRange(10, 20)
                );
            transactionSystem
                .GiveItem(
                    stash,
                    ItemID.FromTDBID(t"DrugDealer.Drug.VoidGaze.Material.2"),
                    RandRange(6, 12)
                );
            transactionSystem
                .GiveItem(
                    stash,
                    ItemID.FromTDBID(t"DrugDealer.Drug.VoidGaze.Material.3"),
                    RandRange(6, 12)
                );
        }

        if researchSystem.IsDrugResearched(t"DrugDealer.Drug.GridKing") {
            // GridKing researched
            transactionSystem
                .GiveItem(
                    stash,
                    ItemID.FromTDBID(t"DrugDealer.Drug.GridKing"),
                    RandRange(2, 5)
                );
            transactionSystem
                .GiveItem(
                    stash,
                    ItemID.FromTDBID(t"DrugDealer.Drug.GridKing.Material.1"),
                    RandRange(8, 14)
                );
            transactionSystem
                .GiveItem(
                    stash,
                    ItemID.FromTDBID(t"DrugDealer.Drug.GridKing.Material.2"),
                    RandRange(8, 14)
                );
            transactionSystem
                .GiveItem(
                    stash,
                    ItemID.FromTDBID(t"DrugDealer.Drug.GridKing.Material.3"),
                    RandRange(8, 14)
                );
        }

        if researchSystem.IsDrugResearched(t"DrugDealer.Drug.ThreeMoons") {
            // ThreeMoons researched, materials only
            transactionSystem
                .GiveItem(
                    stash,
                    ItemID.FromTDBID(t"DrugDealer.Drug.ThreeMoons.Material.1"),
                    RandRange(0, 2)
                );
            transactionSystem
                .GiveItem(
                    stash,
                    ItemID.FromTDBID(t"DrugDealer.Drug.ThreeMoons.Material.2"),
                    RandRange(0, 2)
                );
        }

        if researchSystem.IsDrugResearched(t"DrugDealer.Drug.EmperorsEyes") {
            // Emperor's Eyes researched, materials only
            transactionSystem
                .GiveItem(
                    stash,
                    ItemID.FromTDBID(t"DrugDealer.Drug.EmperorsEyes.Material.1"),
                    RandRange(0, 2)
                );
            transactionSystem
                .GiveItem(
                    stash,
                    ItemID.FromTDBID(t"DrugDealer.Drug.EmperorsEyes.Material.2"),
                    RandRange(0, 2)
                );
            transactionSystem
                .GiveItem(
                    stash,
                    ItemID.FromTDBID(t"DrugDealer.Drug.EmperorsEyes.Material.3"),
                    RandRange(0, 1)
                );
        }
    }
}

