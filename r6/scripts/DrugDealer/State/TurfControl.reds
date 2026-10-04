module DrugDealer.State

import DrugDealer.Settings.{Constants, SettingsSystem}
import DrugDealer.State.{PlayerStateSystem}
import DrugDealer.Map.{DrugDealerMappinData, DrugDealerMappinType}
import DrugDealer.Job.JobSchedulerSystem
import DrugDealer.Job.Raid.{ConvertToRaidLocation, RaidLocation, RoamingRaidJob}
import DrugDealer.Translation.{TranslateTurfLocation, TranslateTurfControl}

// -----------------------------------------------------------------------------
// TurfControl - DrugDealer
// -----------------------------------------------------------------------------
public enum TurfControl {
    Surrendered = 0,
    Constested = 1,
    Controlled = 2,
}

public class Turf {
    public persistent let location: TurfLocation;
    public persistent let mapLocation: Vector4;
    public persistent let control: TurfControl = TurfControl.Surrendered;
    public persistent let controlValue: Int32;
    // Hours accumulated toward next point of decay
    public persistent let decayHoursAccumulated: Int32;
    // Last ingame timestamp (total seconds) when decay was checked
    public persistent let lastDecayTimeSeconds: Int32;

    public static func Create(location: TurfLocation, mapLocation: Vector4) -> ref<Turf> {
        let turf = new Turf();
        turf.location = location;
        turf.mapLocation = mapLocation;
        return turf;
    }

    public func IsSurrendered() -> Bool = Equals(this.control, TurfControl.Surrendered);

    public func IsContested() -> Bool = Equals(this.control, TurfControl.Constested);

    public func IsControlled() -> Bool = Equals(this.control, TurfControl.Controlled);

    public func GetMappinType() -> DrugDealerMappinType {
        if Equals(this.control, TurfControl.Controlled) {
            return DrugDealerMappinType.TurfControlled;
        }
        if Equals(this.control, TurfControl.Constested) {
            return DrugDealerMappinType.TurfContested;
        }
        return DrugDealerMappinType.TurfSurrendered;
    }

    public func GetMappinLocalization() -> String = TranslateTurfLocation(this.location) + " " + TranslateTurfControl(this.control);
}

// Delayed callback for periodic turf decay
public class TurfDecayCallback extends DelayCallback {
    public let system: wref<TurfControlSystem>;

    public func Call() {
        if IsDefined(this.system) {
            this.system.OnDecayTick();
        }
    }
}

// Delayed callback for periodic roaming raid scheduling
public class RoamingRaidCallback extends DelayCallback {
    public let system: wref<TurfControlSystem>;

    public func Call() {
        if IsDefined(this.system) {
            this.system.OnRoamingRaidTick();
        }
    }
}

public class TurfControlSystem extends ScriptableSystem {
    private persistent let turfs: array<ref<Turf>>;
    private let decayDelayId: DelayID;
    private let isDecayRunning: Bool;
    private let roamingRaidDelayId: DelayID;
    private let isRoamingRaidRunning: Bool;
    private let registeredMappins: array<NewMappinID>;
    // Lazy eval
    private let settings: wref<SettingsSystem>;

    public static func Get() -> ref<TurfControlSystem> {
        return GameInstance
            .GetScriptableSystemsContainer(GetGameInstance())
            .Get(n"DrugDealer.State.TurfControlSystem") as TurfControlSystem;
    }

    // Lazy eval
    private func GetSettings() -> wref<SettingsSystem> {
        if !IsDefined(this.settings) {
            this.settings = SettingsSystem.Get();
        }
        return this.settings;
    }

    public static func GetLocalizationForTurfControlGainByMoney(money: Int32, settings: wref<SettingsSystem>) -> String {
        if money >= settings.TurfControlMoneyMajorGainThreshold() {
            return GetLocalizedTextByKey(n"DD.Turf.Control.MajorGain");
        } else if money >= settings.TurfControlMoneyModerateGainThreshold() {
            return GetLocalizedTextByKey(n"DD.Turf.Control.ModerateGain");
        } else if money >= settings.TurfControlSingleGainPerMoney() {
            return GetLocalizedTextByKey(n"DD.Turf.Control.MinorGain");
        }
        // Sale was too low to gain any control
        return "";
    }

    public static func GetLocalizationForTurfControlGainByBodies(bodyCount: Int32) -> String {
        let turfControlGainLocalization: CName = n"DD.Turf.Control.MinorGain";
        if bodyCount >= Constants.TurfControlBodiesMajorGainThreshold() {
            turfControlGainLocalization = n"DD.Turf.Control.MajorGain";
        } else if bodyCount >= Constants.TurfControlBodiesModerateGainThreshold() {
            turfControlGainLocalization = n"DD.Turf.Control.ModerateGain";
        }
        return GetLocalizedTextByKey(turfControlGainLocalization);
    }

    public static func GetLocalizationForTurfControlGainByTerror() -> String = GetLocalizedTextByKey(n"DD.Turf.Control.EnormousGain");

    public func GetTurf(turfLocation: TurfLocation) -> wref<Turf> {
        for turf in this.turfs {
            if Equals(turf.location, turfLocation) {
                return turf;
            }
        }
        return null;
    }

    public func AwardTurfControlByMoney(turfLocation: TurfLocation, money: Int32) -> Int32 {
        let settings = SettingsSystem.Get();
        if money <= 0 || !IsDefined(settings) {
            // Invalid argument/ no ss
            return 0;
        }

        let turfControlValueToAdd = money / settings.TurfControlSingleGainPerMoney();
        this.AddTurfControl(turfLocation, turfControlValueToAdd);
        return turfControlValueToAdd;
    }

    public func AwardTurfControlByBodies(turfLocation: TurfLocation, bodyCount: Int32) {
        let settings = this.GetSettings();
        if bodyCount <= 0 || !IsDefined(settings) {
            // Invalid argument
            return;
        }

        let turfControlValueToAdd = settings.TurfControlGainPerBody() * bodyCount;
        this.AddTurfControl(turfLocation, turfControlValueToAdd);
    }

    public func AwardTurfControlByTerror(turfLocation: TurfLocation) {
        let settings = this.GetSettings();
        if !IsDefined(settings) {
            return;
        }
        this.AddTurfControl(turfLocation, settings.TurfControlGainPerTerror());
    }

    private func AddTurfControl(turfLocation: TurfLocation, controlValueToAdd: Int32) {
        for turf in this.turfs {
            if Equals(turf.location, turfLocation) {
                let newControlValue = turf.controlValue + controlValueToAdd;
                if newControlValue > 100 {
                    turf.controlValue = 100;
                } else if newControlValue < 0 {
                    turf.controlValue = 0;
                } else {
                    turf.controlValue = newControlValue;
                }

                // Reset decay
                let gameTime = GetGameInstance().GetGameTime();
                turf.lastDecayTimeSeconds = gameTime.seconds;
                turf.decayHoursAccumulated = 0;
            }
        }
    }

    public func Init() {
        if ArraySize(this.turfs) > 0 {
            if !IsDefined(this.GetTurf(TurfLocation.Heywood)) {
                // Inject Heywood for pre v5 saves
                ArrayPush(
                    this.turfs,
                    Turf.Create(TurfLocation.Heywood, Vector4(-916.47186, 389.90512, -0.8690033, 1.0))
                );
            }
            if !IsDefined(this.GetTurf(TurfLocation.Pacifica)) {
                // Inject Pacifica for pre v6 saves
                ArrayPush(
                    this.turfs,
                    Turf
                        .Create(TurfLocation.Pacifica, Vector4(-3100.0, -2170.5164, 15.80545, 1.0))
                );
            }
            return;
        }

        this.turfs = [
            Turf.Create(TurfLocation.Watson, Vector4(-500.8686, 3223.5332, 14.870964, 1.0)),
            Turf.Create(TurfLocation.SantoDomingo, Vector4(949.4873, -800.2032, 34.14041, 1.0)),
            Turf.Create(TurfLocation.Badlands, Vector4(2699.2097, 659.77014, 95.284195, 1.0)),
            Turf.Create(TurfLocation.Westbrook, Vector4(534.33575, 1378.1927, 224.60452, 1.0)),
            Turf.Create(TurfLocation.Heywood, Vector4(-916.47186, 389.90512, -0.8690033, 1.0)),
            Turf.Create(TurfLocation.Pacifica, Vector4(-3400.0, -2170.5164, 15.80545, 1.0))
        ];
    }

    public func StartDecayPolling() {
        if this.isDecayRunning {
            return;
        }
        this.isDecayRunning = true;
        let gameTime = GetGameInstance().GetGameTime();
        let gameTimeSeconds = gameTime.seconds;
        for turf in this.turfs {
            if turf.lastDecayTimeSeconds == 0 && turf.controlValue > 0 {
                turf.lastDecayTimeSeconds = gameTimeSeconds;
            }
        }
        this.QueueDecayTick();
    }

    public func StopDecayPolling() {
        this.isDecayRunning = false;
        let delaySystem = GameInstance.GetDelaySystem(GetGameInstance());
        delaySystem.CancelDelay(this.decayDelayId);
    }

    private func QueueDecayTick() {
        let callback = new TurfDecayCallback();
        callback.system = this;
        let delaySystem = GameInstance.GetDelaySystem(GetGameInstance());
        this.decayDelayId = delaySystem.DelayCallback(callback, Constants.TurfControlDecayTickInSeconds(), false);
    }

    // Core decay logic processes elapsed ingame hours since last check
    public func OnDecayTick() {
        let gameTime = GetGameInstance().GetGameTime();
        let gameTimeSeconds = gameTime.seconds;

        for turf in this.turfs {
            if turf.controlValue > 0 && turf.lastDecayTimeSeconds == 0 {
                // Ignore first decay tick
                turf.lastDecayTimeSeconds = gameTimeSeconds;
            } else if turf.controlValue > 0 {
                let elapsedSeconds = gameTimeSeconds - turf.lastDecayTimeSeconds;
                let elapsedHours = elapsedSeconds / 3600;
                let hoursProcessed = 0;

                // Process each hour to handle state transitions
                while hoursProcessed < elapsedHours && turf.controlValue > 0 {
                    turf.decayHoursAccumulated += 1;
                    let hoursPerPoint = this.GetEffectiveHoursPerPoint(turf.controlValue);
                    if turf.decayHoursAccumulated >= hoursPerPoint {
                        turf.controlValue -= 1;
                        turf.decayHoursAccumulated = 0;
                    }
                    hoursProcessed += 1;
                }

                turf.lastDecayTimeSeconds += hoursProcessed * 3600;
                this.UpdateTurfControlState(turf);
            }
        }

        if this.isDecayRunning {
            // Update mappins
            this.RegisterMappins();
            // Queue next tick
            this.QueueDecayTick();
        }
    }

    public func StartRoamingRaidPolling() {
        if this.isRoamingRaidRunning {
            return;
        }
        this.isRoamingRaidRunning = true;
        this.QueueRoamingRaidTick();
    }

    public func StopRoamingRaidPolling() {
        this.isRoamingRaidRunning = false;
        let delaySystem = GameInstance.GetDelaySystem(GetGameInstance());
        delaySystem.CancelDelay(this.roamingRaidDelayId);
    }

    private func QueueRoamingRaidTick() {
        let callback = new RoamingRaidCallback();
        callback.system = this;
        let delaySystem = GameInstance.GetDelaySystem(GetGameInstance());
        let randomizedSpawnDelay = RandRangeF(Constants.RoamingRaidTickMinInSeconds(), Constants.RoamingRaidTickMaxInSeconds() + 1.0);
        this.roamingRaidDelayId = delaySystem.DelayCallback(callback, randomizedSpawnDelay, false);
    }

    public func OnRoamingRaidTick() {
        this.AddRoamingRaids();
        if this.isRoamingRaidRunning {
            this.QueueRoamingRaidTick();
        }
    }

    // TODO make rank have a slight effect on decay
    private func GetEffectiveHoursPerPoint(controlValue: Int32) -> Int32 = this.GetHoursPerPointForValue(controlValue);

    // Returns base ingame hours per 1 point of decay
    private func GetHoursPerPointForValue(controlValue: Int32) -> Int32 {
        if controlValue >= Constants.TurfControlControlledValue() {
            return Constants.TurfControlControlledDecay();
        }
        if controlValue >= Constants.TurfControlContestedValue() {
            return Constants.TurfControlContestedDecay();
        }
        return Constants.TurfControlSurrenderedDecay();
    }

    public func GetControlledTurfCount() -> Int32 {
        let count = 0;
        for turf in this.turfs {
            if turf.IsControlled() {
                count += 1;
            }
        }
        return count;
    }

    public func GetEnemyTurfCount() -> Int32 = ArraySize(this.turfs) - this.GetControlledTurfCount();

    public func RollEnemyTurfLocation() -> TurfLocation {
        let enemyTurfLocations: array<TurfLocation>;
        for turf in this.turfs {
            if !turf.IsControlled() {
                ArrayPush(enemyTurfLocations, turf.location);
            }
        }
        if ArraySize(enemyTurfLocations) == 0 {
            // All turfs controlled
            return TurfLocation.None;
        }
        return enemyTurfLocations[RandRange(0, ArraySize(enemyTurfLocations))];
    }

    // Update turf control state and enforce MaxControlledTurfs() limit
    private func UpdateTurfControlState(turf: ref<Turf>) {
        let playerStateSystem = PlayerStateSystem.Get();
        if !IsDefined(playerStateSystem) {
            return;
        }
        let maxTurfsControlledByPlayer = playerStateSystem.MaxControlledTurfs();

        if turf.controlValue >= Constants.TurfControlControlledValue() {
            if turf.IsControlled() || this.GetControlledTurfCount() < maxTurfsControlledByPlayer {
                turf.control = TurfControl.Controlled;
            } else {
                // Max controlled turfs reached hence we cap at contested
                turf.controlValue = Constants.TurfControlControlledValue() - 1;
                turf.control = TurfControl.Constested;
            }
        } else if turf.controlValue >= Constants.TurfControlContestedValue() {
            turf.control = TurfControl.Constested;
        } else {
            turf.control = TurfControl.Surrendered;
        }
    }

    public func RegisterMappins() {
        let mappinSystem = GameInstance.GetMappinSystem(GetGameInstance());

        // Unregister previous mappins
        for mappinId in this.registeredMappins {
            mappinSystem.UnregisterMappin(mappinId);
        }
        ArrayClear(this.registeredMappins);

        for turf in this.turfs {
            let location = turf.mapLocation;
            let mappinData = MappinData();
            mappinData.mappinType = t"Mappins.DefaultStaticMappin";
            mappinData.variant = gamedataMappinVariant.GetUpVariant;
            mappinData.active = false;
            mappinData.visibleThroughWalls = false;
            let scriptData = new DrugDealerMappinData();
            scriptData.mappinType = turf.GetMappinType();
            scriptData.displayName = turf.GetMappinLocalization();
            mappinData.scriptData = scriptData;
            let mappinId = mappinSystem.RegisterMappin(mappinData, location);
            ArrayPush(this.registeredMappins, mappinId);
        }
    }

    private func GetEligibleRoamingRaidTurf() -> TurfLocation {
        let currentTurfLocation = GetCurrentTurf();
        let currentTurf = this.GetTurf(currentTurfLocation);
        if IsDefined(currentTurf) && !currentTurf.IsControlled() {
            // Current turf is not controlled, eligible for roaming raid
            return currentTurfLocation;
        }

        for adjacentTurfLocation in GetAdjacentTurfs(currentTurfLocation) {
            let adjacentTurf = this.GetTurf(adjacentTurfLocation);
            if IsDefined(adjacentTurf) && !adjacentTurf.IsControlled() {
                // First non-controlled adjacent turf
                return adjacentTurfLocation;
            }
        }

        return TurfLocation.None;
    }

    // Gets turf to send reinfs from (take first if more eligible)
    public func GetEligibleReinforcementTurf(assaultedTurfLocation: TurfLocation) -> TurfLocation {
        for adjacentTurfLocation in GetAdjacentTurfs(assaultedTurfLocation) {
            let adjacentTurf = this.GetTurf(adjacentTurfLocation);
            if IsDefined(adjacentTurf) && adjacentTurf.IsControlled() {
                // First controlled adjacent turf
                return adjacentTurfLocation;
            }
        }

        return TurfLocation.None;
    }

    // Add roaming raids related to turf control
    private func AddRoamingRaids() {
        let settings = this.GetSettings();
        if !IsDefined(settings) {
            return;
        }

        let roamingRaidTurf = this.GetEligibleRoamingRaidTurf();

        if Equals(roamingRaidTurf, TurfLocation.None) {
            // Non-eligible location
            return;
        }

        // Convert to raid location
        let raidLocation = ConvertToRaidLocation(roamingRaidTurf);

        let jobSchedulerSystem = JobSchedulerSystem.Get();
        if !IsDefined(jobSchedulerSystem) {
            return;
        }
        let params: array<Variant> = [ToVariant(raidLocation)];

        let i = 0;
        while i <= settings.RoamingRaidMaxActive() {
            // Attempt to schedule roaming raid job
            let roamingRaidJob = jobSchedulerSystem.ScheduleRoamingRaidJob(params);
            if IsDefined(roamingRaidJob) {
                roamingRaidJob.Execute();
            } else {
                break;
            }
            i += 1;
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

    let turfControlSystem = TurfControlSystem.Get();
    if !IsDefined(turfControlSystem) {
        return true;
    }

    // Init turfs
    turfControlSystem.Init();
    // Put them on the map
    turfControlSystem.RegisterMappins();
    // Start decay polling
    turfControlSystem.StartDecayPolling();
    // Start roaming raid polling
    turfControlSystem.StartRoamingRaidPolling();
}

// Stop decay polling when player detaches
@wrapMethod(PlayerPuppet)
protected cb func OnDetach() -> Bool {
    wrappedMethod();

    let turfControlSystem = TurfControlSystem.Get();
    if !IsDefined(turfControlSystem) {
        return true;
    }

    turfControlSystem.StopDecayPolling();
    turfControlSystem.StopRoamingRaidPolling();
}

