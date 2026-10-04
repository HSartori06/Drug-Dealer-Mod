module DrugDealer.Job.Stash

import DrugDealer.Job.*
import DrugDealer.Spawn.EntitySpawnSystem
import NightlyNow.Utils.LocationWithOrientation
import NightlyNow.Notification.{NotificationSystem, NotificationStyle}
import DrugDealer.Sound.{SoundSystem}
import DrugDealer.Map.{DrugDealerMappinData, DrugDealerMappinType}
import DrugDealer.Settings.Constants

// -----------------------------------------------------------------------------
// StashJob - Drug Dealer
// -----------------------------------------------------------------------------
public class StashJob extends Job {
    private persistent let stashLocation: StashLocation;
    private let locationWithOrientation: ref<LocationWithOrientation>;

    public static func Create(opt params: array<Variant>) -> ref<StashJob> {
        let job = new StashJob();
        job.Init(params);
        return job;
    }

    // params[0] = location: StashLocation
    public func Init(opt params: array<Variant>) {
        super.Init(params);
        this.type = JobType.Stash;
        if ArraySize(params) > 0 {
            this.stashLocation = FromVariant<StashLocation>(params[0]);
        } else {
            this.stashLocation = StashLocation.Watson;
        }
    }

    // Unique tag linking spawned entities to this job
    public func GetJobTag() -> CName = StringToName("DrugDealer.Stash." + ToString(this.hashId));

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

    // 24 hours
    public func GetExpirationHours() -> Int32 = Constants.StashExpirationInHours();

    public func Execute() {
        super.Execute();

        this.locationWithOrientation = StashLocations.RollStashLocation(this.stashLocation);

        // Spawn stash
        let spawnSystem = EntitySpawnSystem.Get();
        if !IsDefined(spawnSystem) {
            return;
        }
        spawnSystem
            .RequestContainer(
                r"base\\gameplay\\loot\\containers\\ow_containers\\bag.ent",
                n"bag_b",
                this.locationWithOrientation.location,
                this.locationWithOrientation.orientation,
                [this.GetJobTag()]
            );

        // Pin it on the map
        let ddMappin = new DrugDealerMappinData();
        ddMappin.mappinType = DrugDealerMappinType.Stash;
        ddMappin.displayName = GetLocalizedTextByKey(n"DD.Mappin.Stash");
        super.RegisterMappin(this.locationWithOrientation.location, ddMappin, true);
    }

    public func Complete() {
        super.Complete();
        super.UnregisterMappin();
    }

    public func Fail() {
        super.Fail();
        super.UnregisterMappin();
    }

    public func RefreshMappin() {
        super.UnregisterMappin();
        let ddMappin = new DrugDealerMappinData();
        ddMappin.mappinType = DrugDealerMappinType.Stash;
        ddMappin.displayName = GetLocalizedTextByKey(n"DD.Mappin.Stash");
        super.RegisterMappin(this.locationWithOrientation.location, ddMappin, true);
    }
}

// This we need to detect whether the shash has been looted to prevent save scumming aka reactivating shashes on load
@wrapMethod(gameLootContainerBase)
protected cb func OnItemRemoveddEvent(evt: ref<ItemBeingRemovedEvent>) -> Bool {
    let entityId = this.GetEntityID();
    let entitySystem = GameInstance.GetDynamicEntitySystem();
    if entitySystem.IsManaged(entityId)
        && entitySystem.IsTagged(entityId, n"DrugDealer.Stash") {
        let jobSchedulerSystem = JobSchedulerSystem.Get();
        if IsDefined(jobSchedulerSystem) {
            let stashJob = jobSchedulerSystem
                .FindActiveJobByEntityId(entityId, entitySystem);
            if IsDefined(stashJob) {
                stashJob.Complete();
            }
        }
    }
    return wrappedMethod(evt);
}

