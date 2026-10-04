module DrugDealer.Job

import DrugDealer.Job.Raid.*
import DrugDealer.Job.SellDrugs.*
import DrugDealer.Job.Stash.{StashJob, StashSystem}
import DrugDealer.Settings.{Constants, SettingsSystem}
import DrugDealer.State.{PlayerStateSystem, DrugDealerRank}

// Delay callback for periodic stale job purge
public class StaleJobPurgeCallback extends DelayCallback {
    public let scheduler: wref<JobSchedulerSystem>;

    public func Call() {
        if IsDefined(this.scheduler) {
            this.scheduler.OnStaleJobPurge();
        }
    }
}

// -----------------------------------------------------------------------------
// JobSchedulerSystem - DrugDealer
// -----------------------------------------------------------------------------
public class JobSchedulerSystem extends ScriptableSystem {
    // Persistent vars
    public persistent let jobs: array<ref<Job>>;
    // Ingame timestamp of last scheduled job (total seconds)
    private persistent let lastJobScheduledAtSeconds: Int32;
    // Random cooldown duration in seconds (1-24 hours), persisted to prevent cheating by loading previous save
    private persistent let jobCooldownSeconds: Int32;
    // Stale job purge polling
    private let isPurgeRunning: Bool;
    private let purgeDelayId: DelayID;
    private let purgeInterval: Float = 10.0;

    public static func Get() -> ref<JobSchedulerSystem> {
        return GameInstance
            .GetScriptableSystemsContainer(GetGameInstance())
            .Get(n"DrugDealer.Job.JobSchedulerSystem") as JobSchedulerSystem;
    }

    public func OnAttach() {
    }

    // Called when player spawns into the world
    private func OnPlayerAttach(request: ref<PlayerAttachRequest>) {
        this.PurgeStaleJobs();
        this.ResumeActiveJobs();
        this.StartPurgePolling();
    }

    // Start periodic stale job purge
    public func StartPurgePolling() {
        if this.isPurgeRunning {
            return;
        }
        this.isPurgeRunning = true;
        this.QueuePurge();
    }

    // Stop periodic stale job purge
    public func StopPurgePolling() {
        this.isPurgeRunning = false;
        let delaySystem = GameInstance.GetDelaySystem(GetGameInstance());
        delaySystem.CancelDelay(this.purgeDelayId);
    }

    // Periodic purge check
    public func OnStaleJobPurge() {
        this.PurgeStaleJobs();
        this.QueuePurge();
    }

    private func QueuePurge() {
        let staleJobPurgeCallback = new StaleJobPurgeCallback();
        staleJobPurgeCallback.scheduler = this;
        let delaySystem = GameInstance.GetDelaySystem(GetGameInstance());
        this.purgeDelayId = delaySystem.DelayCallback(staleJobPurgeCallback, this.purgeInterval, false);
    }

    // Check if no active job of this type is already scheduled
    public func CanScheduleJob(jobType: JobType) -> Bool {
        for job in this.jobs {
            if Equals(job.type, jobType) && job.IsActive() {
                return false;
            }
        }
        return true;
    }

    // Roll a new random cooldown
    private func RollJobCooldown() {
        let cooldown = RandRange(Constants.JobCooldownMinInSeconds(), Constants.JobCooldownMaxInSeconds());
        // Higher rank means shorter cooldown (rank 0: x1.0, rank 9: x0.1, rank 10+ no cooldown)
        let playerStateSystem = PlayerStateSystem.Get();
        if !IsDefined(playerStateSystem) {
            return;
        }
        let rank = EnumInt(playerStateSystem.GetRank());
        if rank > 10 {
            // Zero cooldown for rank 10+
            rank = 10;
        }
        let rankMultiplier = 1.0 - Cast<Float>(rank) * 0.1;
        this.jobCooldownSeconds = Cast<Int32>(Cast<Float>(cooldown) * rankMultiplier);
    }

    // Check if the random cooldown has elapsed since last scheduled job
    public func HasJobCooldownElapsed() -> Bool {
        if this.lastJobScheduledAtSeconds == 0 {
            return true;
        }

        let gameTime = GetGameInstance().GetGameTime();
        return gameTime.seconds - this.lastJobScheduledAtSeconds >= this.jobCooldownSeconds;
    }

    public func ResetJobCooldown() {
        this.lastJobScheduledAtSeconds = 0;
    }

    public func ScheduleRaidJob(opt params: array<Variant>) -> ref<RaidJob> {
        let raidJob = RaidJob.Create(params);
        ArrayPush(this.jobs, raidJob);
        let gameTime = GetGameInstance().GetGameTime();
        this.lastJobScheduledAtSeconds = gameTime.seconds;
        this.RollJobCooldown();
        return raidJob;
    }

    public func ScheduleRoamingRaidJob(opt params: array<Variant>) -> ref<RoamingRaidJob> {
        let settings = SettingsSystem.Get();
        if !IsDefined(settings) {
            return null;
        }

        // Only this roaming raids can be active at time
        let activeRoamingRaids = this.FindActiveJobsByType(JobType.RoamingRaid);
        if ArraySize(activeRoamingRaids) >= settings.RoamingRaidMaxActive() {
            return null;
        }

        let roamingRaidJob = RoamingRaidJob.Create(params);
        ArrayPush(this.jobs, roamingRaidJob);
        return roamingRaidJob;
    }

    public func ScheduleSellDrugsJob(opt params: array<Variant>) -> ref<SellDrugsJob> {
        let job = SellDrugsJob.Create(params);
        ArrayPush(this.jobs, job);
        let gameTime = GetGameInstance().GetGameTime();
        this.lastJobScheduledAtSeconds = gameTime.seconds;
        this.RollJobCooldown();
        return job;
    }

    // Schedule a stash job (independent - does not affect cooldown)
    public func ScheduleStashJob(opt params: array<Variant>) -> ref<StashJob> {
        let stashSystem = StashSystem.Get();
        if !IsDefined(stashSystem) {
            return null;
        }
        if !stashSystem.CanSpawnStash() {
            // New stash can't spawn yet
            return null;
        }

        let job = StashJob.Create(params);
        ArrayPush(this.jobs, job);
        return job;
    }

    // Re-execute active jobs (e.g. after loading a save)
    public func ResumeActiveJobs() {
        for job in this.jobs {
            if job.IsActive() {
                job.Execute();
            }
        }
    }

    // Fail and remove jobs that have been active for more than configured ingame hour
    public func PurgeStaleJobs() {
        let keptJobs: array<ref<Job>>;
        for job in this.jobs {
            let cooldownElapsed = job.HasCooldownElapsed(job.GetExpirationHours());
            if cooldownElapsed && job.IsActive() {
                // Job is active and is to fail
                job.Fail();
                job.Purge();
            } else if !cooldownElapsed {
                // Motherfucking Redscript not supporting continue, srsly
                ArrayPush(keptJobs, job);
            }
        }
        this.jobs = keptJobs;
    }

    public func PurgeJobsByState(state: JobState) {
        let keptJobs: array<ref<Job>>;
        for job in this.jobs {
            if !Equals(job.state, state) {
                ArrayPush(keptJobs, job);
            }
        }
        // Assign new array ref
        this.jobs = keptJobs;
    }

    // Find an active job by type
    public func FindActiveJobByType(jobType: JobType) -> ref<Job> {
        for job in this.jobs {
            if Equals(job.type, jobType) && job.IsActive() {
                return job;
            }
        }
        return null;
    }

    // Find all active jobs by type
    public func FindActiveJobsByType(jobType: JobType) -> array<ref<Job>> {
        let activeJobs: array<ref<Job>>;
        for job in this.jobs {
            if Equals(job.type, jobType) && job.IsActive() {
                ArrayPush(activeJobs, job);
            }
        }
        return activeJobs;
    }

    // Find an active job that owns this entity
    public func FindActiveJobByEntityId(entityId: EntityID, entitySystem: ref<DynamicEntitySystem>) -> ref<Job> {
        for job in this.jobs {
            if job.IsActive() && entitySystem.IsTagged(entityId, job.GetJobTag()) {
                return job;
            }
        }
        return null;
    }

    // Find any active job by type
    public func FindActiveJob() -> ref<Job> {
        let excludedJobTypes = [JobType.Stash, JobType.RoamingRaid];
        for job in this.jobs {
            if job.IsActive() && !ArrayContains(excludedJobTypes, job.type) {
                return job;
            }
        }
        return null;
    }

    public func PurgeAllJobs() {
        ArrayClear(this.jobs);
    }
}

// Stop purge polling when player detaches
@wrapMethod(PlayerPuppet)
protected cb func OnDetach() -> Bool {
    wrappedMethod();
    let jobSchedulerSystem = JobSchedulerSystem.Get();
    if !IsDefined(jobSchedulerSystem) {
        return true;
    }
    jobSchedulerSystem.StopPurgePolling();
}

