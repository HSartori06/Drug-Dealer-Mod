module DrugDealer.Crackhouse

import NightlyNow.Transaction.{ItemStock, GetItemsByTags, RemoveItems, AddMoney}
import DrugDealer.Market.{MarketSystem}
import NightlyNow.Notification.{NotificationSystem, NotificationStyle}
import DrugDealer.Sound.{SoundSystem}
import DrugDealer.State.{PlayerStateSystem, TurfControlSystem, Turf, TurfLocation, TurfControl}
import DrugDealer.Settings.{SettingsSystem, Constants}
import NightlyNow.Utils.{SkipTime, IsNight, IsCorpo}
import DrugDealer.Tutorial.DrugDealerTutorialSystem

// -----------------------------------------------------------------------------
// CrackhouseSelling - Drug Dealer
// -----------------------------------------------------------------------------
public class CrackhouseSellingSystem extends ScriptableSystem {
    public static func Get() -> ref<CrackhouseSellingSystem> {
        return GameInstance
            .GetScriptableSystemsContainer(GetGameInstance())
            .Get(n"DrugDealer.Crackhouse.CrackhouseSellingSystem") as CrackhouseSellingSystem;
    }

    // Sell available products at the crackhouse
    public func SellProduct(crackhouseLocation: CrackhouseLocation, opt partialDistribution: Bool) {
        let settings = SettingsSystem.Get();
        if !IsDefined(settings) {
            return;
        }
        let soundSystem = SoundSystem.Get();
        if !IsDefined(soundSystem) {
            return;
        }
        let notificationSystem = NotificationSystem.Get();
        if !IsDefined(notificationSystem) {
            return;
        }

        // Distributed items
        let itemStock = GetItemsByTags([n"DrugDealerDrug"]);
        if partialDistribution {
            // Partial inventory sales
            itemStock.ReduceQuantitiesByPercent(settings.distributionCrackhousePercent);
        }
        let totalQuantity = itemStock.TotalQuantity();

        if totalQuantity == 0 {
            // Nothing to sell
            SkipTime(0);
            notificationSystem
                .ShowNotification(
                    GetLocalizedTextByKey(n"DD.Crackhouse.NoDrugsToSell"),
                    NotificationStyle.Penalty,
                    1.0
                );

            soundSystem.PlayDrugDealFailed();
            return;
        }

        // Sell all drugs
        RemoveItems(itemStock.itemIds, itemStock.quantity);

        // 10m per sale session
        SkipTime(60 * 10);

        // Get market rates
        let marketSystem = MarketSystem.Get();
        if !IsDefined(marketSystem) {
            return;
        }
        let priceTotal = marketSystem.PriceBulk(itemStock.itemIds, itemStock.quantity);

        // Apply sales modifier
        priceTotal = Cast<Int32>(
            Cast<Float>(priceTotal) * this.CalculateSalesModifier(crackhouseLocation)
        );

        // Add funds
        AddMoney(priceTotal);

        // Award score
        let playerStateSystem = PlayerStateSystem.Get();
        if !IsDefined(playerStateSystem) {
            return;
        }
        playerStateSystem.ScoreSellingToCrackhouse(totalQuantity);

        // Award turf control
        let turfControlSystem = TurfControlSystem.Get();
        if !IsDefined(turfControlSystem) {
            return;
        }
        turfControlSystem.AwardTurfControlByMoney(crackhouseLocation.turfLocation, priceTotal);

        // Partial distribution msg
        let partialDistributionMsg = StrReplace(
            GetLocalizedTextByKey(n"DD.Crackhouse.SoldDrugsPartially"),
            "{0}",
            s"\(totalQuantity)"
        );

        // Display notification
        notificationSystem
            .ShowNotification(
                partialDistribution ? partialDistributionMsg : GetLocalizedTextByKey(n"DD.Crackhouse.SoldDrugs"),
                NotificationStyle.Reward,
                1.0,
                TurfControlSystem.GetLocalizationForTurfControlGainByMoney(priceTotal, settings)
            );

        // Play sound
        soundSystem.PlayCrackhouseSold();
        soundSystem.VoiceCrackhouse(1.2);

        // Play tutorial
        let tutorialSystem = DrugDealerTutorialSystem.Get();
        if !IsDefined(tutorialSystem) {
            return;
        }
        tutorialSystem.PlayRank();
    }

    private func CalculateSalesModifier(crackhouseLocation: CrackhouseLocation) -> Float {
        let salesModifier: Float = 1.0;
        if IsNight() {
            // Night sales bonus
            salesModifier += Constants.AdditiveNightSalesBonus();
        }

        if IsCorpo() {
            // Corpo sales bonus
            salesModifier += Constants.CorpoAdditiveSalesBonus();
        }

        let turfControlSystem = TurfControlSystem.Get();
        if !IsDefined(turfControlSystem) {
            return 0.0;
        }
        let turf = turfControlSystem.GetTurf(crackhouseLocation.turfLocation);

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
}

