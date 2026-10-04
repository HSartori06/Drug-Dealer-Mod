module DrugDealer.Job.SellDrugs

import DrugDealer.Job.*
import DrugDealer.Spawn.EntitySpawnSystem
import NightlyNow.Notification.{NotificationSystem, NotificationStyle}
import DrugDealer.State.{PlayerStateSystem, TurfControlSystem, Turf, TurfLocation, TurfControl}
import NightlyNow.Utils.{IsNight, LocationWithOrientation, IsCorpo}
import NightlyNow.Transaction.{HasItems, RemoveItems, AddMoney}
import DrugDealer.Market.{MarketSystem}
import DrugDealer.Sound.{SoundSystem}
import DrugDealer.Map.{DrugDealerMappinData, DrugDealerMappinType}
import DrugDealer.Settings.{Constants, SettingsSystem}
import DrugDealer.Tutorial.DrugDealerTutorialSystem

// -----------------------------------------------------------------------------
// SellDrugs - Drug Dealer
// -----------------------------------------------------------------------------
public class SellDrugsJob extends Job {
    // Big drug deal for High society flag
    public persistent let highSociety: Bool;
    // Private vars
    private persistent let buyerLocation: BuyerLocation;
    private persistent let drugDemand: ref<DrugDemand>;
    private let locationWithOrientation: ref<LocationWithOrientation>;

    public static func Create(opt params: array<Variant>) -> ref<SellDrugsJob> {
        let job = new SellDrugsJob();
        job.Init(params);
        return job;
    }

    // params[0] = buyerLocation: BuyerLocation
    // params[1] = drugDemand: DrugDemand
    // params[2] = highSociety: Bool
    public func Init(opt params: array<Variant>) {
        super.Init(params);
        this.type = JobType.SellDrugs;
        // Persist buyer location from params
        if ArraySize(params) > 0 {
            this.buyerLocation = FromVariant<BuyerLocation>(params[0]);
            this.drugDemand = FromVariant<ref<DrugDemand>>(params[1]);
            this.highSociety = FromVariant<Bool>(params[2]);
        } else {
            this.buyerLocation = BuyerLocation.Watson;
            this.drugDemand = DemandPresets.GetDrugDemandPreset();
        }
    }

    public func GetBuyerLocation() -> BuyerLocation = this.buyerLocation;

    public func GetDrugDemand() -> ref<DrugDemand> = this.drugDemand;

    // Unique tag linking spawned entities to this job
    public func GetJobTag() -> CName = StringToName("DrugDealer.SellDrugs." + ToString(this.hashId));

    // Called by EntitySpawnSystem when a tagged NPC dies
    public func OnEntityDied(opt entityId: EntityID) {
        // Buyer dies before deal comes through
        this.Fail();
    }

    // Despawn all managed entities
    public func Purge() {
        let spawnSystem = EntitySpawnSystem.Get();
        if !IsDefined(spawnSystem) {
            return;
        }
        let entitySystem = GameInstance.GetDynamicEntitySystem();
        for id in entitySystem.GetTaggedIDs(this.GetJobTag()) {
            spawnSystem.DespawnEntity(id);
        }
    }

    public func Execute() {
        super.Execute();

        this.locationWithOrientation = BuyerLocations.GetBuyerLocation(this.buyerLocation);
        let buyerPreset = BuyerPresets.GetBuyerPreset(this.buyerLocation);

        let spawnSystem = EntitySpawnSystem.Get();
        if !IsDefined(spawnSystem) {
            return;
        }
        spawnSystem
            .RequestSpawn(
                buyerPreset,
                this.locationWithOrientation.location,
                this.locationWithOrientation.orientation,
                [this.GetJobTag(), n"DrugDealer.Buyer"]
            );

        // Pin it on the map
        let ddMappin = new DrugDealerMappinData();
        ddMappin.mappinType = this.GetMappin();
        ddMappin.displayName = GetLocalizedTextByKey(this.GetMappinLoc());
        super.RegisterMappin(this.locationWithOrientation.location, ddMappin, true);
    }

    // Complete if player has the demanded drugs and it's not a drug bust, otherwise fail
    public func Resolve() {
        if HasItems(this.drugDemand.drugs, this.drugDemand.quantity) {
            // Full demand met
            RemoveItems(this.drugDemand.drugs, this.drugDemand.quantity);
            let moneyEarned = Cast<Int32>(Cast<Float>(this.drugDemand.worth) * this.CalculateSalesModifier());
            AddMoney(moneyEarned);

            // Award turf control
            this.AwardTurfControl(moneyEarned);

            // Job fully completed
            this.Complete(moneyEarned);
            return;
        }

        // Check for partial demand, at least 1 unit of any demanded drug
        let player = GetPlayer(GetGameInstance());
        let transactionSystem = GameInstance.GetTransactionSystem(player.GetGame());
        let deliveredDrugs: array<TweakDBID>;
        let deliveredQty: array<Int32>;
        let i = 0;

        while i < ArraySize(this.drugDemand.drugs) {
            let owned = transactionSystem
                .GetItemQuantity(player, ItemID.FromTDBID(this.drugDemand.drugs[i]));
            let drugQuantity = Min(owned, this.drugDemand.quantity[i]);
            if drugQuantity > 0 {
                ArrayPush(deliveredDrugs, this.drugDemand.drugs[i]);
                ArrayPush(deliveredQty, drugQuantity);
            }
            i += 1;
        }

        if !this.highSociety && ArraySize(deliveredDrugs) > 0 {
            // Partial demand met. Price based on what was actually delivered.
            let marketSystem = MarketSystem.Get();
            if !IsDefined(marketSystem) {
                return;
            }
            let partialWorth = marketSystem.PriceBulk(deliveredDrugs, deliveredQty, true);
            RemoveItems(deliveredDrugs, deliveredQty);
            let moneyEarned = Cast<Int32>(Cast<Float>(partialWorth) * this.CalculateSalesModifier(true));
            AddMoney(moneyEarned);

            // Award turf control
            this.AwardTurfControl(moneyEarned);

            // Partial completion
            this.CompletePartial(moneyEarned);
        } else {
            // No drugs sold
            this.Fail();
        }
    }

    public func Complete(moneyEarned: Int32) {
        super.Complete();
        super.UnregisterMappin();
        
        let settings = SettingsSystem.Get();
        if !IsDefined(settings) {
            return;
        }
        let notificationSystem = NotificationSystem.Get();
        if !IsDefined(notificationSystem) {
            return;
        }
        notificationSystem.HideSideNotification();
        let npcInteractionController = NPCInteractionController.Get();
        if !IsDefined(npcInteractionController) {
            return;
        }
        npcInteractionController.UnregisterNPC();
        let playerStateSystem = PlayerStateSystem.Get();
        if !IsDefined(playerStateSystem) {
            return;
        }
        playerStateSystem.ScoreDrugDeal();

        // Show notification
        notificationSystem
            .ShowNotification(
                GetLocalizedTextByKey(n"DD.SellDrugs.Successful"),
                NotificationStyle.Reward,
                1.0,
                TurfControlSystem
                    .GetLocalizationForTurfControlGainByMoney(moneyEarned, settings)
            );

        // Play sound
        let soundSystem = SoundSystem.Get();
        if !IsDefined(soundSystem) {
            return;
        }
        if this.highSociety {
            soundSystem.PlayBigDrugDealCompleted();
        } else {
            // Fiend
            soundSystem.PlayDrugDealCompleted();
            soundSystem.VoiceDealWithFiend(1.2);
        }

        // Play tutorial
        let tutorialSystem = DrugDealerTutorialSystem.Get();
        if !IsDefined(tutorialSystem) {
            return;
        }
        tutorialSystem.PlayFiend();
    }

    public func CompletePartial(moneyEarned: Int32) {
        super.Complete();
        super.UnregisterMappin();

        let settings = SettingsSystem.Get();
        if !IsDefined(settings) {
            return;
        }
        let notificationSystem = NotificationSystem.Get();
        if !IsDefined(notificationSystem) {
            return;
        }
        notificationSystem.HideSideNotification();
        let npcInteractionController = NPCInteractionController.Get();
        if !IsDefined(npcInteractionController) {
            return;
        }
        npcInteractionController.UnregisterNPC();

        // Add score
        let playerStateSystem = PlayerStateSystem.Get();
        if !IsDefined(playerStateSystem) {
            return;
        }
        playerStateSystem.ScorePartialDrugDeal();

        // Show partial completion notification
        notificationSystem
            .ShowNotification(
                GetLocalizedTextByKey(n"DD.SellDrugs.PartiallySuccessful"),
                NotificationStyle.PartialReward,
                1.0,
                TurfControlSystem.GetLocalizationForTurfControlGainByMoney(moneyEarned, settings)
            );

        // Play sound
        let soundSystem = SoundSystem.Get();
        if !IsDefined(soundSystem) {
            return;
        }
        soundSystem.PlayPartialDrugDealCompleted();
        soundSystem.VoiceDealWithFiend(1.2);

        // Play tutorial
        let tutorialSystem = DrugDealerTutorialSystem.Get();
        if !IsDefined(tutorialSystem) {
            return;
        }
        tutorialSystem.PlayFiend();
    }

    public func Fail() {
        super.Fail();
        let npcInteractionController = NPCInteractionController.Get();
        if !IsDefined(npcInteractionController) {
            return;
        }
        npcInteractionController.UnregisterNPC();
        let notificationSystem = NotificationSystem.Get();
        if !IsDefined(notificationSystem) {
            return;
        }
        notificationSystem.HideSideNotification();
        super.UnregisterMappin();

        // Show notification
        notificationSystem
            .ShowNotification(
                GetLocalizedTextByKey(n"DD.SellDrugs.Failed"),
                NotificationStyle.Penalty,
                1.0
            );

        // Play sound
        let soundSystem = SoundSystem.Get();
        if !IsDefined(soundSystem) {
            return;
        }
        soundSystem.PlayDrugDealFailed();
        soundSystem.VoiceFailedDeal(1.2);

        // Play tutorial
        let tutorialSystem = DrugDealerTutorialSystem.Get();
        if !IsDefined(tutorialSystem) {
            return;
        }
        tutorialSystem.PlayFiend();
    }

    public func RefreshMappin() {
        super.UnregisterMappin();
        let ddMappin = new DrugDealerMappinData();
        ddMappin.mappinType = this.GetMappin();
        ddMappin.displayName = GetLocalizedTextByKey(this.GetMappinLoc());
        super.RegisterMappin(this.locationWithOrientation.location, ddMappin, true);
    }

    // NCPD drug bust
    public func FailWithNcpdDrugBust() {
        super.Fail();
        let npcInteractionController = NPCInteractionController.Get();
        if !IsDefined(npcInteractionController) {
            return;
        }
        npcInteractionController.UnregisterNPC();
        super.UnregisterMappin();

        // Notification system
        let notificationSystem = NotificationSystem.Get();
        if !IsDefined(notificationSystem) {
            return;
        }

        // Show notification
        notificationSystem
            .ShowNotification(
                GetLocalizedTextByKey(n"DD.SellDrugs.FailedWithNcpdDrugBust"),
                NotificationStyle.Ncpd,
                1.0
            );

        // Hide the side notifs to prevent sticky notfis for fleeing fiend
        notificationSystem.HideSideNotification();

        // Play sound
        let soundSystem = SoundSystem.Get();
        if !IsDefined(soundSystem) {
            return;
        }
        soundSystem.PlayNcpdDrugBust();
        soundSystem.VoiceDrugBust(1.2);
    }

    private func CalculateSalesModifier(opt partialSale: Bool) -> Float {
        let salesModifier: Float = 1.0;

        if partialSale {
            // Partial sale, apply additive malus
            salesModifier += Constants.AdditivePartialSalesMalus();
        }

        if !this.highSociety && IsNight() {
            // Night sales bonus only for street fiends
            salesModifier += Constants.AdditiveNightSalesBonus();
        }

        if this.highSociety {
            // Positive modifier when selling to high society
            salesModifier += Constants.BigDrugDealHighSocietySalesModifier();
        }

        if IsCorpo() {
            // Corpo sales bonus
            salesModifier += Constants.CorpoAdditiveSalesBonus();
        }

        let turfControlSystem = TurfControlSystem.Get();
        if !IsDefined(turfControlSystem) {
            return 0.0;
        }
        let turfLocation = ConvertToTurfLocation(this.buyerLocation);
        let turf = turfControlSystem.GetTurf(turfLocation);

        if IsDefined(turf) {
            if turf.IsControlled() {
                // Drug monopoly for controlled turf
                salesModifier += Constants.AdditiveTurfControlSalesModifier();
            }
            if turf.IsSurrendered() {
                // Sales malus for surrendered turf
                salesModifier -= Constants.AdditiveTurfControlSalesModifier();
            }
        }
        return salesModifier;
    }

    private func AwardTurfControl(moneyEarned: Int32) {
        // Award turf control
        let turfLocation = ConvertToTurfLocation(this.buyerLocation);
        let turfControlSystem = TurfControlSystem.Get();
        if !IsDefined(turfControlSystem) {
            return;
        }
        turfControlSystem.AwardTurfControlByMoney(turfLocation, moneyEarned);
    }

    private func GetMappin() -> DrugDealerMappinType = this.highSociety ? DrugDealerMappinType.BigDrugDeal : DrugDealerMappinType.Fiend;

    private func GetMappinLoc() -> CName = this.highSociety ? n"DD.Mappin.HighSociety" : n"DD.Mappin.Fiend";
}

