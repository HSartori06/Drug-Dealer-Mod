module DrugDealer.NightMarket

import DrugDealer.Map.{DrugDealerMappinData, DrugDealerMappinType}
import NightlyNow.Transaction.DeductMoney
import DrugDealer.Market.{MarketSystem}
import NightlyNow.Notification.{NotificationSystem, NotificationStyle, SideNotification}
import DrugDealer.Sound.{SoundSystem}
import DrugDealer.State.{PlayerStateSystem, TurfLocation, DrugDealerRank}
import DrugDealer.Settings.{SettingsSystem, Constants}
import NightlyNow.Utils.{SkipTime, IsNight, IsNomad}
import DrugDealer.Tutorial.DrugDealerTutorialSystem
import DrugDealer.Organization.Organization

// Delayed callback for periodic night market logic
public class NightMarketLogicCallback extends DelayCallback {
    public let system: wref<NightMarketSystem>;

    public func Call() {
        if IsDefined(this.system) {
            this.system.OnNightMarketLogicTick();
        }
    }
}

// -----------------------------------------------------------------------------
// NightMarketSystem - Drug Dealer
// -----------------------------------------------------------------------------
public class NightMarketSystem extends ScriptableSystem {
    private persistent let nightMarketLocations: array<ref<NightMarketLocation>>;
    private persistent let nightMarketActive: Bool;
    private persistent let nightMarketLastActiveTimestamp: Int32;
    private let nightMarketLogicDelayId: DelayID;
    private let isNightMarketLogicRunning: Bool;
    // Lazy eval
    private let playerStateSystem: wref<PlayerStateSystem>;
    private let settingsSystem: wref<SettingsSystem>;

    public static func Get() -> wref<NightMarketSystem> {
        return GameInstance
            .GetScriptableSystemsContainer(GetGameInstance())
            .Get(n"DrugDealer.NightMarket.NightMarketSystem") as NightMarketSystem;
    }

    // Lazy eval
    private func GetPlayerStateSystem() -> wref<PlayerStateSystem> {
        if !IsDefined(this.playerStateSystem) {
            this.playerStateSystem = PlayerStateSystem.Get();
        }
        return this.playerStateSystem;
    }

    // Lazy eval
    private func GetSettingsSystem() -> wref<SettingsSystem> {
        if !IsDefined(this.settingsSystem) {
            this.settingsSystem = SettingsSystem.Get();
        }
        return this.settingsSystem;
    }

    public func InitNightMarketLocations() {
        // TODO possible migration v7+
        if ArraySize(this.nightMarketLocations) >= 1 {
            return;
        }

        this.nightMarketLocations = [
            NightMarketLocation
                .Create(
                    TurfLocation.Badlands,
                    Organization.Aldecaldos,
                    Vector4(2771.2173, -71.881546, 78.14868, 1.0),
                    n"$/#drugdealer/badlands/nightmarket1",
                    RandRange(
                        Constants.NightMarketMinCrates(),
                        Constants.NightMarketMaxCrates() + 1
                    )
                )
        ];
    }

    public func GetEligibleNightMarketLocations() -> array<ref<NightMarketLocation>> {
        let playerStateSystem = this.GetPlayerStateSystem();
        if !IsDefined(playerStateSystem)
            || !this.nightMarketActive
            || EnumInt(playerStateSystem.GetRank()) < Constants.NightMarketMinRank()
            || !IsNight() {
            // Too low rank or not night
            return [];
        }
        return this.nightMarketLocations;
    }

    // Sell available products at the nightmarket
    public func BuyCrate(nightMarketInteractionController: wref<NightMarketInteractionController>) {
        if !IsDefined(nightMarketInteractionController) {
            return;
        }
        // Get the night market player interacts with
        let nightMarketLocation = nightMarketInteractionController.GetNearNightMarketLocation();

        if !IsDefined(nightMarketLocation) {
            return;
        }
        let settings = this.GetSettingsSystem();
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

        if nightMarketLocation.crates == 0 {
            // Nothing to sell
            SkipTime(0);
            notificationSystem
                .ShowNotification(
                    GetLocalizedTextByKey(n"DD.NightMarket.Depleted"),
                    NotificationStyle.Penalty,
                    1.0
                );

            soundSystem.PlayDrugDealFailed();
            return;
        }

        // Deduct money
        if !DeductMoney(settings.NightMarketCratePrice()) {
            // Broke ass player
            SkipTime(0);
            notificationSystem
                .ShowNotification(
                    GetLocalizedTextByKey(n"DD.NightMarket.NotEnoughMoney"),
                    NotificationStyle.Penalty,
                    1.0
                );

            soundSystem.PlayDrugDealFailed();
            return;
        }

        // Consume crate
        nightMarketLocation.ConsumeCrate();

        // 5m transaction
        SkipTime(60 * 5);

        // Open crate
        OpenCrate();

        // Display notification
        notificationSystem
            .ShowNotification(
                GetLocalizedTextByKey(n"DD.NightMarket.CrateBought"),
                NotificationStyle.Reward,
                1.0,
                IsNomad() ? GetLocalizedTextByKey(n"DD.NightMarket.NomadExtraVolume") : ""
            );

        // Play sound
        soundSystem.PlayNightMarket();

        // Play tutorial
        let tutorialSystem = DrugDealerTutorialSystem.Get();
        if !IsDefined(tutorialSystem) {
            return;
        }
        tutorialSystem.PlayNightMarket();

        // Refresh the possible stale sidenotifs in the proximity controller
        notificationSystem
            .ShowSideNotification(
                nightMarketInteractionController.GetSideNotification(nightMarketLocation)
            );
    }

    public func RegisterMappins() {
        let settingsSystem = this.GetSettingsSystem();
        if !IsDefined(settingsSystem) {
            return;
        }

        let mappinSystem = GameInstance.GetMappinSystem(GetGameInstance());
        let eligibleNightMarketLocations = this.GetEligibleNightMarketLocations();

        // Unregister previous mappins
        for nightMarketLocation in this.nightMarketLocations {
            if !ArrayContains(eligibleNightMarketLocations, nightMarketLocation) {
                // Unregister mappings only for those not eligible, otherwise navigation bugs out
                mappinSystem.UnregisterMappin(nightMarketLocation.mappinId);
                nightMarketLocation.mappinId = NewMappinID(0ul);
            }
        }

        for nightMarketLocation in eligibleNightMarketLocations {
            if nightMarketLocation.mappinId.value == 0ul {
                let location = nightMarketLocation.location;
                let mappinData = MappinData();
                mappinData.mappinType = t"Mappins.DefaultStaticMappin";
                mappinData.variant = gamedataMappinVariant.GetUpVariant;
                mappinData.active = !settingsSystem.enableImmersiveMode;
                mappinData.visibleThroughWalls = false;
                let scriptData = new DrugDealerMappinData();
                scriptData.mappinType = nightMarketLocation.GetMappinType();
                scriptData.displayName = nightMarketLocation.GetMappinLocalization();
                mappinData.scriptData = scriptData;
                let mappinId = mappinSystem.RegisterMappin(mappinData, location);
                nightMarketLocation.mappinId = mappinId;
            }
        }
    }

    public func ToggleNightMarkets(toggle: Bool) {
        let worldStateSystem = GameInstance.GetWorldStateSystem();

        // Some mods (Fenix rebirth) may derank player, toggle off must be always allowed
        let nightMarketLocations = toggle ? this.GetEligibleNightMarketLocations() : this.nightMarketLocations;

        for nightMarketLocation in nightMarketLocations {
            worldStateSystem
                .ToggleVariant(
                    ToNodeRef(NameToString(nightMarketLocation.node)),
                    n"active",
                    toggle
                );

            // Extra spawns more crates for beefed up markets as an indication
            worldStateSystem
                .ToggleVariant(
                    ToNodeRef(NameToString(nightMarketLocation.node)),
                    n"extra",
                    toggle && nightMarketLocation.IsExtraSupplied()
                );
        }
    }

    public func RestoreNightMarkets() {
        this.ToggleNightMarkets(this.nightMarketActive);
    }

    public func StartNightMarketLogicPolling() {
        if this.isNightMarketLogicRunning {
            return;
        }
        this.isNightMarketLogicRunning = true;
        this.QueueNightMarketLogicTick();
    }

    public func StopNightMarketLogicPolling() {
        this.isNightMarketLogicRunning = false;
        let delaySystem = GameInstance.GetDelaySystem(GetGameInstance());
        delaySystem.CancelDelay(this.nightMarketLogicDelayId);
    }

    private func QueueNightMarketLogicTick() {
        let callback = new NightMarketLogicCallback();
        callback.system = this;
        let delaySystem = GameInstance.GetDelaySystem(GetGameInstance());
        this.nightMarketLogicDelayId = delaySystem.DelayCallback(callback, Constants.NightMarketLogicTickInSeconds(), false);
    }

    public func OnNightMarketLogicTick() {
        // Update active/inactive state based on the cycle
        this.UpdateNightMarketState();

        if this.isNightMarketLogicRunning {
            this.QueueNightMarketLogicTick();
        }
    }

    private func UpdateNightMarketState() {
        let gameTime = GetGameInstance().GetGameTime();
        let now = gameTime.seconds;
        let activeDurationSeconds = Constants.NightMarketActiveDurationInDays() * 86400;
        let cyclePeriodSeconds = (Constants.NightMarketActiveDurationInDays() + Constants.NightMarketOffDurationInDays()) * 86400;

        if this.nightMarketLastActiveTimestamp <= 0 {
            // First, start in past to prevent bs behaviour on the very first run
            this.nightMarketLastActiveTimestamp = now - activeDurationSeconds - 1;
        }

        let elapsed = now - this.nightMarketLastActiveTimestamp;
        let desiredActive: Bool;
        if elapsed >= cyclePeriodSeconds {
            // Night market's new cycle
            this.nightMarketLastActiveTimestamp = now;
            desiredActive = true;
        } else {
            desiredActive = elapsed < activeDurationSeconds;
        }

        // Toggle on value change only
        if !Equals(desiredActive, this.nightMarketActive) {
            this.nightMarketActive = desiredActive;
            this.ToggleNightMarkets(desiredActive);
            if desiredActive {
                // Also replenish on new cycle
                this.ReplenishNightMarkets();
            }
        }

        if !this.nightMarketActive || !IsNight() {
            // Toggle off when not night
            this.ToggleNightMarkets(false);
        }

        // Update map
        this.RegisterMappins();
    }

    private func ReplenishNightMarkets() {
        for nightMarketLocation in this.nightMarketLocations {
            nightMarketLocation.Replenish();
        }
    }
}

@wrapMethod(PlayerPuppet)
protected cb func OnGameAttached() -> Bool {
    wrappedMethod();

    let systemRequestsHandler: ref<inkISystemRequestsHandler> = GameInstance.GetSystemRequestsHandler();
    if IsDefined(systemRequestsHandler) && systemRequestsHandler.IsPreGame() {
        // Prevents firing up in MM
        return true;
    }

    let nightMarketSystem = NightMarketSystem.Get();
    if !IsDefined(nightMarketSystem) {
        return true;
    }

    // Init night market locations
    nightMarketSystem.InitNightMarketLocations();

    // Register mappins
    nightMarketSystem.RegisterMappins();

    // Gotta restore on load since toggles happen on lifecycle's shifts only
    nightMarketSystem.RestoreNightMarkets();

    // Start night market logic polling
    nightMarketSystem.StartNightMarketLogicPolling();
}

// Stop night market logic polling when player detaches
@wrapMethod(PlayerPuppet)
protected cb func OnDetach() -> Bool {
    wrappedMethod();

    let nightMarketSystem = NightMarketSystem.Get();
    if !IsDefined(nightMarketSystem) {
        return true;
    }

    nightMarketSystem.StopNightMarketLogicPolling();
}

