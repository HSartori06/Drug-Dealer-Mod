module DrugDealer.Job

import DrugDealer.Map.{DrugDealerMappinData}
import DrugDealer.Settings.{Constants, SettingsSystem}
import DrugDealer.Map.OpenMap

// -----------------------------------------------------------------------------
// Job - DrugDealer
// -----------------------------------------------------------------------------
public enum JobType {
    Stash = 0,
    Raid = 1,
    SellDrugs = 2,
    RoamingRaid = 3,
}

public enum JobState {
    Scheduled = 0,
    Active = 1,
    Completed = 2,
    Failed = 3,
}

public abstract class Job {
    public persistent let hashId: Int32;
    public persistent let type: JobType;
    public persistent let state: JobState = JobState.Scheduled;
    // Ingame timestamp when this job was registered (total seconds)
    private persistent let registeredAtSeconds: Int32;
    // Init params
    private let params: array<Variant>;
    // Job map pin + tracking
    private let mappinId: NewMappinID;
    // Coordinates of the job's map marker (used to center the map on navigation)
    private let mappinPosition: Vector4;

    // Is to be implemented by job impl (supports variable params)
    public func Init(opt params: array<Variant>) {
        this.hashId = RandRange(0, 2147483647);
        this.params = params;
        let gameTime = GetGameInstance().GetGameTime();
        this.registeredAtSeconds = gameTime.seconds;
    }

    // Is to be implemented by job impl
    public func Execute() {
        this.state = JobState.Active;
    }

    // Is to be implemented by job impl
    public func Complete() {
        this.state = JobState.Completed;
    }

    // Is to be implemented by job impl
    public func Fail() {
        this.state = JobState.Failed;
    }

    // Is to be implemented by job impl (used for despaw, etc.)
    public func Purge() {
    }

    // Check if job is active
    public func IsActive() -> Bool {
        return Equals(this.state, JobState.Active);
    }

    // Check if enough ingame hours have passed since registration
    public func HasCooldownElapsed(hours: Int32) -> Bool {
        let gameTime = GetGameInstance().GetGameTime();
        let now = gameTime.seconds;
        return now - this.registeredAtSeconds >= hours * 3600;
    }

    // Is called from EntitySpawnSystem on first player attack
    public func OnEntityAttacked() {
    }

    // Is called from EntitySpawnSystem on spawned NPC(s) death
    public func OnEntityDied(opt entityId: EntityID) {
    }

    // Expiration time in ingame hours (override in subclasses)
    public func GetExpirationHours() -> Int32 = Constants.JobExpirationInHours();

    // Job tag used to uniquely identify this job
    public func GetJobTag() -> CName = StringToName("DrugDealer.Job." + ToString(this.hashId));

    // Place job marker on the map
    public func RegisterMappin(
        position: Vector4,
        drugDealerMappinData: ref<DrugDealerMappinData>,
        opt tracking: Bool
    ) {
        // Immersive mode settings affects wheter the icon is active
        let settingsSystem = SettingsSystem.Get();
        if !IsDefined(settingsSystem) {
            return;
        }
        let immersiveMode = settingsSystem.enableImmersiveMode;

        // Non-tracking mappin
        let mappinData = MappinData();
        mappinData.mappinType = t"Mappins.DefaultStaticMappin";
        mappinData.variant = gamedataMappinVariant.GetUpVariant;
        mappinData.active = !immersiveMode;
        mappinData.visibleThroughWalls = false;
        mappinData.scriptData = drugDealerMappinData;

        let mappinSystem = GameInstance.GetMappinSystem(GetGameInstance());
        this.mappinId = mappinSystem.RegisterMappin(mappinData, position);
        this.mappinPosition = position;

        if tracking {
            // TODO tracking, resolved by map centering for the time being as the white one sucked
            return;
        }
    }

    // Remove job marker from the map
    public func UnregisterMappin() {
        let mappinSystem = GameInstance.GetMappinSystem(GetGameInstance());
        mappinSystem.UnregisterMappin(this.mappinId);
    }

    // Coordinates of this job's map marker
    public func GetMappinPosition() -> Vector4 = this.mappinPosition;

    // To be implemented by job impl with location data
    public func RefreshMappin() {
    }

    // Handles job navigation with map autoopen
    public func Navigate() {
        let settings = SettingsSystem.Get();
        if !IsDefined(settings) {
            return;
        }

        let navigateJobCallback = NavigateJobCallback.Create(this);
        GameInstance
            .GetDelaySystem(GetGameInstance())
            .DelayCallback(
                navigateJobCallback,
                settings.enhancedNavigationMapAutoOpenDelay,
                false
            );
    }
}

private class NavigateJobCallback extends DelayCallback {
    private let job: wref<Job>;

    public func Call() {
        if !IsDefined(this.job) {
            return;
        }

        // We delay refreshing here cause the in-game navigation system is buggy as fuck
        this.job.RefreshMappin();

        let settings = SettingsSystem.Get();
        if !IsDefined(settings) {
            return;
        }

        if settings.enableEnhancedNavigation {
            OpenMap(this.job.GetMappinPosition());
        }
    }

    public static func Create(job: wref<Job>) -> ref<NavigateJobCallback> {
        let navigateJobCallback = new NavigateJobCallback();
        navigateJobCallback.job = job;
        return navigateJobCallback;
    }
}

