module DrugDealer.Lab

import NightlyNow.Transaction.{HasItems, RemoveItems, AddItem}
import NightlyNow.Utils.{SkipTime, PassProbabilityCheck, IsNomad}
import NightlyNow.Notification.{NotificationSystem, NotificationStyle}
import DrugDealer.Sound.{SoundSystem}
import DrugDealer.Settings.{SettingsSystem, Constants}
import DrugDealer.State.{PlayerStateSystem, TurfControlSystem, Turf, TurfLocation, TurfControl}
import DrugDealer.Organization.{Organization, RollAmbushOrganization}
import DrugDealer.Job.{JobSchedulerSystem, RollVehicleWave}
import DrugDealer.Spawn.VehicleSpawnSystem
import DrugDealer.Tutorial.DrugDealerTutorialSystem

@if(ModuleExists("DarkFuture.Needs"))
import DarkFuture.Needs.{DFNerveSystem, DFChangeNeedValueProps}

@if(ModuleExists("FleshAndChrome"))
import FleshAndChrome.FACSystem

// -----------------------------------------------------------------------------
// LabCooking - Drug Dealer
// -----------------------------------------------------------------------------
public class LabCookingSystem extends ScriptableSystem {
    // Global lab cooldown after ambush
    private persistent let disabledUntilSeconds: Int32;
    // Lazy eval
    private let cookbookSystem: wref<CookbookSystem>;

    public static func Get() -> ref<LabCookingSystem> {
        return GameInstance
            .GetScriptableSystemsContainer(GetGameInstance())
            .Get(n"DrugDealer.Lab.LabCookingSystem") as LabCookingSystem;
    }

    // Lazy eval
    private func GetCookbookSystem() -> wref<CookbookSystem> {
        if !IsDefined(this.cookbookSystem) {
            this.cookbookSystem = CookbookSystem.Get();
        }
        return this.cookbookSystem;
    }

    public func OpenCookbook() {
        let cookbookSystem = this.GetCookbookSystem();
        if IsDefined(cookbookSystem) {
            cookbookSystem.OpenCookbook();
        }
    }

    // Cook all possible products from available materials
    public func PrepareProduct(labLocation: LabLocation) {
        let soundSystem = SoundSystem.Get();
        if !IsDefined(soundSystem) {
            return;
        }
        let notificationSystem = NotificationSystem.Get();
        if !IsDefined(notificationSystem) {
            return;
        }
        let playerStateSystem = PlayerStateSystem.Get();
        if !IsDefined(playerStateSystem) {
            return;
        }
        let gameInstance = GetGameInstance();

        // Check if labs are disabled after ambush
        let gameTime = gameInstance.GetGameTime();
        if gameTime.seconds < this.disabledUntilSeconds {
            // Skip zero time just for the effect alone
            SkipTime(0);
            notificationSystem
                .ShowNotification(
                    GetLocalizedTextByKey(n"DD.Lab.Disabled"),
                    NotificationStyle.Disabled,
                    1.0
                );
            return;
        }

        let preparedProducts = 0;
        let score = 0;
        let hadHighYield = false;
        let hadNomadBonus = false;

        // Roll ambush before crafting
        let isAmbushed = false;
        let maxProductsPerSession = Constants.LabMaxProductsPerSession();
        if this.DidAmbushOccurred(labLocation) {
            isAmbushed = true;
            maxProductsPerSession = RandRange(1, 4);
        }

        for recipe in this.GetRecipesForCookingSession(labLocation) {
            // This var is important for Nomad lifepath bonus below
            let recipeCookedCount = 0;
            // Keep crafting while player has enough materials
            while preparedProducts
                < maxProductsPerSession
                && HasItems(recipe.materials, recipe.quantity) {
                RemoveItems(recipe.materials, recipe.quantity);
                if Equals(recipe.category, labLocation.specializedEquipment) {
                    // Specialized equipment doubles yield
                    AddItem(recipe.product, Constants.LabHighYieldMultiplier());
                    hadHighYield = true;
                    preparedProducts += Constants.LabHighYieldMultiplier();
                    recipeCookedCount += Constants.LabHighYieldMultiplier();
                    score += recipe.score * Constants.LabHighYieldMultiplier();
                } else {
                    AddItem(recipe.product, 1);
                    preparedProducts += 1;
                    recipeCookedCount += 1;
                    score += recipe.score;
                }
            }

            if IsNomad() && recipeCookedCount >= Constants.NomadExtraDoseFactor() {
                // Nomad extra dose per each factor cooked up, of the same type
                let nomadCookingBonusCount = recipeCookedCount / Constants.NomadExtraDoseFactor();

                AddItem(recipe.product, nomadCookingBonusCount);
                preparedProducts += nomadCookingBonusCount;
                score += recipe.score * nomadCookingBonusCount;

                hadNomadBonus = true;
            }
        }

        if preparedProducts == 0 {
            // Not enough material
            SkipTime(0);
            notificationSystem
                .ShowNotification(
                    GetLocalizedTextByKey(n"DD.Lab.NotEnoughMaterial"),
                    NotificationStyle.Penalty,
                    1.0
                );
            soundSystem.PlayDrugDealFailed();
            return;
        }

        // Ambush interrupts cooking
        if isAmbushed {
            SkipTime(Constants.LabCookingTimePerDoseInMinutes() * preparedProducts);

            // Award score
            playerStateSystem.AwardScore(score);

            let waveIds = RollVehicleWave(RollAmbushOrganization(), playerStateSystem.RollVehicleWaveSpawnCount());
            let vehicleSpawnSystem = VehicleSpawnSystem.Get();
            if !IsDefined(vehicleSpawnSystem) {
                return;
            }
            vehicleSpawnSystem.SpawnVehicleWave(waveIds);

            // Disable cooking as V can't focus after ambush
            let ambushTime = gameInstance.GetGameTime();
            this.disabledUntilSeconds = ambushTime.seconds + Constants.LabDisableDurationInSeconds();

            // Ambush subtext
            let ambushSubText = StrReplace(
                GetLocalizedTextByKey(n"DD.Lab.Ambush.Subtext"),
                "{0}",
                s"\(preparedProducts)"
            );

            // Ambush notification
            notificationSystem
                .ShowNotification(
                    GetLocalizedTextByKey(n"DD.Lab.Ambush"),
                    NotificationStyle.Ambush,
                    1.0,
                    ambushSubText
                );

            // Reset job cooldown as a reward for cooking product
            let jobSchedulerSystem = JobSchedulerSystem.Get();
            if !IsDefined(jobSchedulerSystem) {
                return;
            }
            jobSchedulerSystem.ResetJobCooldown();

            // Nerve & stamina penalty still apply during ambush
            ReduceNerveFromCooking(preparedProducts);
            ReduceStaminaFromCooking(preparedProducts);

            // Play sound
            soundSystem.PlayLabAmbush();
            soundSystem.VoiceAmbush(3.0);
            return;
        }

        // 5 minutes per product
        SkipTime(300 * preparedProducts);
        let msg = preparedProducts == 1 ? GetLocalizedTextByKey(n"DD.Lab.PreparedSingular") : StrReplace(
            GetLocalizedTextByKey(n"DD.Lab.PreparedPlural"),
            "{0}",
            ToString(preparedProducts)
        );

        // Award score
        playerStateSystem.AwardScore(score);

        // Resolve notification subtext based on the result of the cooking process
        let subText = "";
        if hadHighYield && hadNomadBonus {
            subText = GetLocalizedTextByKey(n"DD.Lab.HighYieldWithNomadBonus");
        } else if hadHighYield {
            subText = GetLocalizedTextByKey(n"DD.Lab.HighYield");
        } else if hadNomadBonus {
            subText = GetLocalizedTextByKey(n"DD.Lab.NomadBonus");
        }

        // Display notification
        notificationSystem.ShowNotification(msg, NotificationStyle.Product, 1.0, subText);

        // Reset job cooldown as a reward for cooking product
        let jobSchedulerSystem = JobSchedulerSystem.Get();
        if !IsDefined(jobSchedulerSystem) {
            return;
        }
        jobSchedulerSystem.ResetJobCooldown();

        // Dark Future Nerve loss
        ReduceNerveFromCooking(preparedProducts);

        // Flesh & Chrome stamina loss
        ReduceStaminaFromCooking(preparedProducts);

        // Play sound
        soundSystem.PlayProductPrepared();

        // Play tutorial
        let tutorialSystem = DrugDealerTutorialSystem.Get();
        if !IsDefined(tutorialSystem) {
            return;
        }
        tutorialSystem.PlayLab();
    }

    private func GetRecipesForCookingSession(
        labLocation: LabLocation
    ) -> array<ref<LabRecipe>> {
        // This is to be returned as default or when no specialized equipment cooking can be done, in case the setting is on
        let allRecipes = GetLabRecipes();

        let settings = SettingsSystem.Get();
        if !IsDefined(settings) || !settings.matchingEquipmentCookingEnabled {
            return allRecipes;
        }

        let matchingRecipes: array<ref<LabRecipe>> = [];
        for recipe in allRecipes {
            if Equals(recipe.category, labLocation.specializedEquipment)
                && HasItems(recipe.materials, recipe.quantity) {
                ArrayPush(matchingRecipes, recipe);
            }
        }

        if ArraySize(matchingRecipes) == 0 {
            return allRecipes;
        }
        return matchingRecipes;
    }

    // Play tutorial
    private func DidAmbushOccurred(labLocation: LabLocation) -> Bool {
        let playerStateSystem = PlayerStateSystem.Get();
        if !IsDefined(playerStateSystem) {
            return false;
        }

        if !playerStateSystem.IsAmbushAllowed() {
            // Ambush now allowed (rank too low)
            return false;
        }

        let turfControlSystem = TurfControlSystem.Get();
        if !IsDefined(turfControlSystem) {
            return false;
        }
        let turf = turfControlSystem.GetTurf(labLocation.turfLocation);

        // Contested turfs do not modify ambush chance
        let ambushChanceModifier = 0;
        if IsDefined(turf) {
            if turf.IsControlled() {
                // Controlled turf, no ambush
                return false;
            }
            if turf.IsSurrendered() {
                // Surrendered turf ambush malus
                ambushChanceModifier = Constants.AdditiveTurfControlSurrenderedAmbushChanceModifier();
            }
        }

        let ambushChance = playerStateSystem.RollAmbushNotoriety() + ambushChanceModifier;
        return PassProbabilityCheck(ambushChance);
    }
}

// Reduce Nerve when cooking, scaled by products prepared
@if(ModuleExists("DarkFuture.Needs"))
private func ReduceNerveFromCooking(preparedProducts: Int32) {
    let settings = SettingsSystem.Get();
    if !IsDefined(settings) {
        return;
    }

    let nerveLossValue = settings.cookingNerveLoss * Cast<Float>(preparedProducts);
    let finalNerveLoss = ClampF(nerveLossValue, 0.0, settings.cookingNerveLossMaximum);

    let nerveSystem = DFNerveSystem.Get();
    if IsDefined(nerveSystem) {
        nerveSystem.ChangeNeedValue(-finalNerveLoss);
    }
}

@if(!ModuleExists("DarkFuture.Needs"))
private func ReduceNerveFromCooking(preparedProducts: Int32) {
}

// Reduce stamina when cooking, scaled by products prepared
@if(ModuleExists("FleshAndChrome"))
private func ReduceStaminaFromCooking(preparedProducts: Int32) {
    let player = GetPlayer(GetGameInstance());
    let settings = SettingsSystem.Get();
    if !IsDefined(settings) {
        return;
    }

    let staminaLossValue = settings.cookingStaminaLoss * Cast<Float>(preparedProducts);
    let finalStaminaLoss = ClampF(staminaLossValue, 0.0, settings.cookingStaminaLossMaximum);

    let facSystem: ref<FACSystem> = GameInstance
        .GetScriptableSystemsContainer(GetGameInstance())
        .Get(n"FleshAndChrome.FACSystem") as FACSystem;
    if IsDefined(facSystem) {
        facSystem.ApplyInstantCost(player, finalStaminaLoss);
    }
}

@if(!ModuleExists("FleshAndChrome"))
private func ReduceStaminaFromCooking(preparedProducts: Int32) {
}

