module DrugDealer.Operation

import NightlyNow.Transaction.{ItemStock, GetItemsByTags, RemoveItems, AddMoney}
import DrugDealer.Market.{MarketSystem}
import NightlyNow.Notification.{NotificationSystem, NotificationStyle, SideNotification, SideNotificationStyle}
import DrugDealer.Sound.{SoundSystem}
import DrugDealer.State.{PlayerStateSystem, TurfControlSystem, Turf, TurfLocation, TurfControl}
import DrugDealer.Settings.{SettingsSystem, Constants}
import NightlyNow.Utils.{PassProbabilityCheck, SkipTime, IsNight, IsStreetKid}
import DrugDealer.Map.{DrugDealerMappinData, DrugDealerMappinType}
import DrugDealer.Tutorial.DrugDealerTutorialSystem
import DrugDealer.Organization.{Organization, RollAssassinationOrganization}
import DrugDealer.Job.{RollVehicleWave}
import DrugDealer.Spawn.VehicleSpawnSystem

// Delayed callback for periodic street operation logic
public class OperationLogicCallback extends DelayCallback {
    public let system: wref<OperationSystem>;

    public func Call() {
        if IsDefined(this.system) {
            this.system.OnOperationLogicTick();
        }
    }
}

// -----------------------------------------------------------------------------
// OperationSelling - Drug Dealer
// -----------------------------------------------------------------------------
public class OperationSystem extends ScriptableSystem {
    // Persistent operation
    private persistent let operations: array<ref<Operation>>;
    // Persistent operation results
    private persistent let operationResults: array<OperationResult>;
    // Persistent operation last execution time in seconds
    private persistent let lastOperationExecutionTimeInSeconds: Int32;
    private let operationLogicDelayId: DelayID;
    private let isOperationLogicRunning: Bool;
    // Lazy eval
    private let settingsSystem: wref<SettingsSystem>;
    private let marketSystem: wref<MarketSystem>;
    private let turfControlSystem: wref<TurfControlSystem>;
    private let playerStateSystem: wref<PlayerStateSystem>;

    public static func Get() -> ref<OperationSystem> {
        return GameInstance
            .GetScriptableSystemsContainer(GetGameInstance())
            .Get(n"DrugDealer.Operation.OperationSystem") as OperationSystem;
    }

    // Lazy eval
    private func GetSettings() -> wref<SettingsSystem> {
        if !IsDefined(this.settingsSystem) {
            this.settingsSystem = SettingsSystem.Get();
        }
        return this.settingsSystem;
    }

    // Lazy eval
    private func GetMarketSystem() -> wref<MarketSystem> {
        if !IsDefined(this.marketSystem) {
            this.marketSystem = MarketSystem.Get();
        }
        return this.marketSystem;
    }

    // Lazy eval
    private func GetTurfControlSystem() -> wref<TurfControlSystem> {
        if !IsDefined(this.turfControlSystem) {
            this.turfControlSystem = TurfControlSystem.Get();
        }
        return this.turfControlSystem;
    }

    // Lazy eval
    private func GetPlayerStateSystem() -> wref<PlayerStateSystem> {
        if !IsDefined(this.playerStateSystem) {
            this.playerStateSystem = PlayerStateSystem.Get();
        }
        return this.playerStateSystem;
    }

    // Returns all street operations
    public func GetOperations() -> array<ref<Operation>> = this.operations;

    // Returns eligible (by turf control state) street operations
    public func GetEligibleOperations() -> array<ref<Operation>> {
        let turfControlSystem = this.GetTurfControlSystem();
        if !IsDefined(turfControlSystem) {
            return [];
        }

        let eligibleOperations: array<ref<Operation>> = [];
        for operation in this.operations {
            let turf = turfControlSystem.GetTurf(operation.turfLocation);
            if IsDefined(turf) && turf.IsControlled() {
                ArrayPush(eligibleOperations, operation);
            }
        }

        return eligibleOperations;
    }

    // Returns all pending operation results
    public func GetPendingOperationResults() -> array<OperationResult> = this.operationResults;

    // This fires inside the Shanice's loop cause of the report functionality
    public func CashOutPlayer() {
        let totalIncome = 0;

        for operationResult in this.operationResults {
            totalIncome += operationResult.totalIncome;
        }

        if totalIncome > 0 {
            // Cash out the player, cuts already factored in
            AddMoney(totalIncome);
        }
    }

    public func ClearPeandingOperationResults() {
        // Clear all the pending results
        ArrayClear(this.operationResults);
    }

    // Initialization of persistable street operations
    public func InitOperations() {
        if ArraySize(this.operations) >= 18 {
            // 18 is v6 operation count
            return;
        }

        // TODO v7+ migrate new operations here!!!
        ArrayClear(this.operations);
        this.operations = GetOperationStructure();
    }

    public func ToggleOperations() {
        let worldStateSystem = GameInstance.GetWorldStateSystem();

        let eligibleOperations = this.GetEligibleOperations();
        for operation in this.operations {
            // Should operation be eligible, toggle it on, otherwise off
            let toggle = ArrayContains(eligibleOperations, operation);
            operation.status = toggle ? OperationStatus.Active : OperationStatus.Inactive;
            worldStateSystem
                .ToggleVariant(ToNodeRef(NameToString(operation.node)), n"active", toggle);
        }
    }

    // Is called in OperationProximity as a supply action
    public func Supply(
        operationInteractionController: ref<OperationInteractionController>,
        opt partialDistribution: Bool
    ) {
        let operation = operationInteractionController.nearOperation;
        if !IsDefined(operation) {
            // No operation defined, this is the nearOperation from OperationProximity
            return;
        }
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
        let playerStateSystem = this.GetPlayerStateSystem();
        if !IsDefined(playerStateSystem) {
            return;
        }
        let turfControlSystem = this.GetTurfControlSystem();
        if !IsDefined(turfControlSystem) {
            return;
        }

        // Pushers require street grade product, brothel Joytoy's kiss only
        let itemStock: ref<ItemStock>;
        if Equals(operation.type, OperationType.Pushers) && settings.reserveJoytoysKissForBrothel {
            // Pushers with Joytoy's kiss exclusion
            itemStock = GetItemsByTags([n"DrugDealerStreetGradeDrugNoJK"]);
        } else if Equals(operation.type, OperationType.Pushers) {
            // Pushers
            itemStock = GetItemsByTags([n"DrugDealerStreetGradeDrug"]);
        } else {
            // Brothel
            itemStock = GetItemsByTags([n"DrugDealerJoytoysKiss"]);
        }

        // Distributed items
        if partialDistribution {
            // Supply partially
            itemStock
                .ReduceQuantitiesByPercent(settings.distributionStreetOperationPercent);
        }
        let totalQuantity = itemStock.TotalQuantity();

        if totalQuantity <= 0 {
            // Fail notification
            let msg = Equals(operation.type, OperationType.Pushers) ? n"DD.Operation.Supply.NoProduct" : n"DD.Operation.Supply.NoJoytoysKiss";
            SkipTime(0);
            notificationSystem
                .ShowNotification(GetLocalizedTextByKey(msg), NotificationStyle.Penalty, 1.0);

            // Play sound
            soundSystem.PlayDrugDealFailed();
            return;
        }

        if operation.IsAtFullCapacity() {
            // Full capacity notification
            SkipTime(0);
            notificationSystem
                .ShowNotification(
                    GetLocalizedTextByKey(n"DD.Operation.Supply.AtFullCapacity"),
                    NotificationStyle.Disabled,
                    1.0
                );

            // Play sound
            soundSystem.PlayDrugDealFailed();
            return;
        }

        // Supply logic
        let transferredProductCount = this.TransferProductToOperation(operation, itemStock);

        let targetedForAssassination = PassProbabilityCheck(
            playerStateSystem.RollAssassinationRisk(turfControlSystem.GetEnemyTurfCount())
        );

        SkipTime(Constants.OperationSupplyTimeInSeconds());
        if targetedForAssassination {
            // Assassination attempt
            let waveIds = RollVehicleWave(
                RollAssassinationOrganization(),
                playerStateSystem.RollVehicleWaveSpawnCount() * Constants.OperationAssassinationVehicleWaveMultiplier()
            );

            let vehicleSpawnSystem = VehicleSpawnSystem.Get();
            if !IsDefined(vehicleSpawnSystem) {
                return;
            }
            vehicleSpawnSystem.SpawnVehicleWave(waveIds);

            // Assassination notification
            let assassinationSubtext = StrReplace(
                GetLocalizedTextByKey(n"DD.Operation.Assassination.Subtext"),
                "{0}",
                s"\(transferredProductCount)"
            );
            notificationSystem
                .ShowNotification(
                    GetLocalizedTextByKey(n"DD.Operation.Assassination"),
                    NotificationStyle.Ambush,
                    1.0,
                    assassinationSubtext
                );

            // Play sound
            soundSystem.PlayAssassination();
            soundSystem.VoiceAssassination(1.2);
        } else {
            // Supply notification
            let supplyMsg = StrReplace(
                GetLocalizedTextByKey(n"DD.Operation.Supply.Completed"),
                "{0}",
                s"\(operation.GetTypeLocalization())"
            );
            supplyMsg = StrReplace(supplyMsg, "{1}", s"\(transferredProductCount)");
            notificationSystem.ShowNotification(supplyMsg, NotificationStyle.Reward, 1.0);

            // Play sound
            soundSystem.PlaySupply();
            soundSystem.VoiceSupply(1.2);

            // Play tutorial
            let tutorialSystem = DrugDealerTutorialSystem.Get();
            if !IsDefined(tutorialSystem) {
                return;
            }
            if operation.IsPushers() {
                tutorialSystem.PlayPushers();
            }
            if operation.IsBrothel() {
                tutorialSystem.PlayBrothels();
            }
        }

        // Award score for supply
        playerStateSystem.AwardScore(transferredProductCount);

        // Refresh the possible stale sidenotifs in the proximity controller
        notificationSystem
            .ShowSideNotification(operationInteractionController.GetSideNotification(operation));
    }

    // Transfers the good stuff
    private func TransferProductToOperation(operation: wref<Operation>, itemStock: ref<ItemStock>) -> Int32 {
        let suppliedItemIds: array<TweakDBID>;
        let suppliedQuantities: array<Int32>;

        // Street Kid double the supply bonus, makes the logic quite a bit harder
        let supplyMultiplier = IsStreetKid() ? Constants.StreetKidSupplyMultiplier() : 1;
        let transferredProductCount = 0;
        let i = 0;
        while i < ArraySize(itemStock.itemIds) {
            let remainingCapacity = Constants.OperationMaxCapacity() - operation.itemStock.TotalQuantity();
            if remainingCapacity <= 0 {
                // Full capacity reached
                break;
            }

            let productId = itemStock.itemIds[i];
            let playerQuantity = itemStock.quantity[i];

            // Whole units that fit
            let multipliedUnits = Min(playerQuantity, remainingCapacity / supplyMultiplier);
            let quantityToTransfer = multipliedUnits * supplyMultiplier;
            let quantityFromPlayer = multipliedUnits;

            // Leftover
            let leftoverCapacity = remainingCapacity - quantityToTransfer;
            let playerRemainder = playerQuantity - quantityFromPlayer;
            if leftoverCapacity > 0 && playerRemainder > 0 {
                let topOff = Min(leftoverCapacity, playerRemainder);
                quantityToTransfer += topOff;
                quantityFromPlayer += topOff;
            }

            // Try to detect the matching record
            let existingIndex = -1;
            let j = 0;
            while j < ArraySize(operation.itemStock.itemIds) {
                if Equals(operation.itemStock.itemIds[j], productId) {
                    existingIndex = j;
                    break;
                }
                j += 1;
            }
            if existingIndex >= 0 {
                // Product already exists
                operation.itemStock.quantity[existingIndex] += quantityToTransfer;
            } else {
                // Product not there yet, create record with its quantity
                ArrayPush(operation.itemStock.itemIds, productId);
                ArrayPush(operation.itemStock.quantity, quantityToTransfer);
            }

            // Track what to remove from the player and how much the operation gained
            ArrayPush(suppliedItemIds, productId);
            ArrayPush(suppliedQuantities, quantityFromPlayer);
            transferredProductCount += quantityToTransfer;

            i += 1;
        }

        // Remove the transferred products from the player
        RemoveItems(suppliedItemIds, suppliedQuantities);

        return transferredProductCount;
    }

    // Update anything data related to street operations
    public func ExecuteOperations() {
        // Settings
        let settings = this.GetSettings();
        if !IsDefined(settings) {
            return;
        }
        // Market system
        let marketSystem = this.GetMarketSystem();
        if !IsDefined(marketSystem) {
            return;
        }
        // Turf control
        let turfControlSystem = this.GetTurfControlSystem();
        if !IsDefined(turfControlSystem) {
            return;
        }
        // Player state
        let playerStateSystem = this.GetPlayerStateSystem();
        if !IsDefined(playerStateSystem) {
            return;
        }

        // Get timestamp since the start of save
        let gameTime = GetGameInstance().GetGameTime();
        let gameTimeSeconds = gameTime.seconds;

        if this.lastOperationExecutionTimeInSeconds <= 0 {
            this.lastOperationExecutionTimeInSeconds = gameTime.seconds;
        }

        // This says how many execution runs we need to process as player may speedrun via waiting
        // or be running some sort of bs time mods.
        let numberOfExecutionRuns = (1 + gameTimeSeconds - this.lastOperationExecutionTimeInSeconds) / Constants.OperationExecutionScheduleInSeconds();

        let i = 0;
        while i < numberOfExecutionRuns {
            for operation in this.GetEligibleOperations() {
                let operationResult = operation.Execute(marketSystem, settings);

                let didConsume = operationResult.consumedProducts > 0;
                let isPassiveBrothel = operationResult.consumedProducts == 0 && Equals(operationResult.type, OperationType.Brothel);
                if didConsume || isPassiveBrothel {
                    // Awards per each running operation (any consumed product)
                    // Crime points
                    playerStateSystem.AwardScore(Constants.OperationRunningCrimePointsAward());
                    // Turf control gain based on revenue with multiplier
                    let revenue = (operationResult.totalIncome + operationResult.cut) * Constants.OperationRunningRevenueMultiplier();
                    turfControlSystem
                        .AwardTurfControlByMoney(operationResult.turfLocation, revenue);

                    // Add to processed results
                    ArrayPush(this.operationResults, operationResult);
                }
            }
            i += 1;
            // Update timestamp
            this.lastOperationExecutionTimeInSeconds = gameTime.seconds;
        }
    }

    public func RegisterMappins() {
        let settingsSystem = SettingsSystem.Get();
        if !IsDefined(settingsSystem) {
            return;
        }

        let mappinSystem = GameInstance.GetMappinSystem(GetGameInstance());

        let eligibleOperations = this.GetEligibleOperations();
        // Unregister previous mappins
        for operation in this.operations {
            // Unregister mappings only for those not eligible, otherwise navigation bugs out
            if !ArrayContains(eligibleOperations, operation) {
                mappinSystem.UnregisterMappin(operation.mappinId);
                operation.mappinId = NewMappinID(0ul);
            }
        }

        for operation in eligibleOperations {
            if operation.mappinId.value == 0ul {
                let location = operation.location;
                let mappinData = MappinData();
                mappinData.mappinType = t"Mappins.DefaultStaticMappin";
                mappinData.variant = gamedataMappinVariant.GetUpVariant;
                mappinData.active = !settingsSystem.enableImmersiveMode;
                mappinData.visibleThroughWalls = false;
                let scriptData = new DrugDealerMappinData();
                scriptData.mappinType = operation.GetMappinType();
                scriptData.displayName = operation.GetMappinLocalization();
                mappinData.scriptData = scriptData;
                let mappinId = mappinSystem.RegisterMappin(mappinData, location);
                operation.mappinId = mappinId;
            }
        }
    }

    public func StartOperationLogicPolling() {
        if this.isOperationLogicRunning {
            return;
        }
        this.isOperationLogicRunning = true;
        this.QueueOperationLogicTick();
    }

    public func StopOperationLogicPolling() {
        this.isOperationLogicRunning = false;
        let delaySystem = GameInstance.GetDelaySystem(GetGameInstance());
        delaySystem.CancelDelay(this.operationLogicDelayId);
    }

    private func QueueOperationLogicTick() {
        let callback = new OperationLogicCallback();
        callback.system = this;
        let delaySystem = GameInstance.GetDelaySystem(GetGameInstance());
        this.operationLogicDelayId = delaySystem.DelayCallback(callback, Constants.OperationLogicTickInSeconds(), false);
    }

    public func OnOperationLogicTick() {
        // Toggle operations
        this.ToggleOperations();

        // Update mappins
        this.RegisterMappins();

        // Execute operations
        this.ExecuteOperations();

        if this.isOperationLogicRunning {
            this.QueueOperationLogicTick();
        }
    }
}

@wrapMethod(PlayerPuppet)
protected cb func OnGameAttached() -> Bool {
    wrappedMethod();

    let systemRequestsHandler: ref<inkISystemRequestsHandler> = GameInstance.GetSystemRequestsHandler();
    if IsDefined(systemRequestsHandler) && systemRequestsHandler.IsPreGame() {
        return true;
    }

    let operationSystem = OperationSystem.Get();
    if !IsDefined(operationSystem) {
        return true;
    }

    // Init operations
    operationSystem.InitOperations();
    // Register mappins
    operationSystem.RegisterMappins();
    // Toggle operations
    operationSystem.ToggleOperations();
    // Start operation logic polling
    operationSystem.StartOperationLogicPolling();
}

// Stop operation logic polling when player detaches
@wrapMethod(PlayerPuppet)
protected cb func OnDetach() -> Bool {
    wrappedMethod();

    let operationSystem = OperationSystem.Get();
    if !IsDefined(operationSystem) {
        return true;
    }

    operationSystem.StopOperationLogicPolling();
}

