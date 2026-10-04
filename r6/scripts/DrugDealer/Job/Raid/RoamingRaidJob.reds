module DrugDealer.Job.Raid

import DrugDealer.Job.*
import DrugDealer.Spawn.EntitySpawnSystem
import DrugDealer.Spawn.VehicleSpawnSystem
import DrugDealer.Organization.*
import NightlyNow.Notification.{NotificationSystem, NotificationStyle}
import DrugDealer.State.{PlayerStateSystem, TurfControlSystem, TurfLocation}
import DrugDealer.Settings.Constants
import DrugDealer.Sound.{SoundSystem}
import DrugDealer.Map.{DrugDealerMappinData, DrugDealerMappinType}
import NightlyNow.Utils.LocationWithOrientation
import NightlyNow.Utils.{PassProbabilityCheck}

// -----------------------------------------------------------------------------
// RoamingRaidJob - Drug Dealer
// -----------------------------------------------------------------------------
public class RoamingRaidJob extends Job {
    private persistent let raidLocation: RaidLocation;
    private let spawnCount: Int32;
    private let deadCount: Int32;
    private let raidPreset: ref<RaidPreset>;
    private let locationWithOrientation: ref<LocationWithOrientation>;
    private let vehicleWaveSpawnChecked: Bool;
    private let killedOrDefeatedNpcs: array<EntityID>;
    private let deathTrackingLock: RWLock;

    public static func Create(opt params: array<Variant>) -> ref<RoamingRaidJob> {
        let job = new RoamingRaidJob();
        job.Init(params);
        return job;
    }

    // params[0] = location: RaidLocation
    public func Init(opt params: array<Variant>) {
        super.Init(params);
        this.type = JobType.RoamingRaid;
        // Persist raid location from params
        if ArraySize(params) > 0 {
            this.raidLocation = FromVariant<RaidLocation>(params[0]);
        } else {
            this.raidLocation = RaidLocation.Watson;
        }
    }

    // Unique tag linking spawned entities to this job
    public func GetJobTag() -> CName = StringToName("DrugDealer.RoamingRaid." + ToString(this.hashId));

    // One of the spawned NPCs got attacked by the player
    public func OnEntityAttacked() {
        if this.vehicleWaveSpawnChecked {
            return;
        }

        let playerStateSystem = PlayerStateSystem.Get();
        if !IsDefined(playerStateSystem) {
            return;
        }
        let highNotoriety = playerStateSystem.RollHighNotoriety();
        if !PassProbabilityCheck(highNotoriety) {
            // Notoriety rolled false
            this.vehicleWaveSpawnChecked = true;
            return;
        }

        // Vehicle wave spawn for high notoriety
        if !IsDefined(this.raidPreset) {
            this.vehicleWaveSpawnChecked = true;
            return;
        }

        let vehicleWaveSpawnCount = playerStateSystem.RollVehicleWaveSpawnCount();
        let waveIds = RollVehicleWave(this.raidPreset.organization, vehicleWaveSpawnCount);
        let vehicleSpawnSystem = VehicleSpawnSystem.Get();
        if !IsDefined(vehicleSpawnSystem) {
            return;
        }
        vehicleSpawnSystem.SpawnVehicleWave(waveIds);
        this.vehicleWaveSpawnChecked = true;
    }

    // Called by EntitySpawnSystem when a tagged NPC dies
    public func OnEntityDied(opt entityId: EntityID) {
        RWLock.Acquire(this.deathTrackingLock);
        if ArrayContains(this.killedOrDefeatedNpcs, entityId) {
            // Already accounted for
            RWLock.Release(this.deathTrackingLock);
            return;
        }

        this.deadCount += 1;
        ArrayPush(this.killedOrDefeatedNpcs, entityId);
        let isLastSpawnDown = this.deadCount == this.spawnCount;
        RWLock.Release(this.deathTrackingLock);

        if isLastSpawnDown {
            this.Complete();
        }
    }

    // Expiration time in ingame hours
    public func GetExpirationHours() -> Int32 = Constants.RoamingRaidExpirationInHours();

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

        this.locationWithOrientation = RaidLocations.GetRaidLocation(this.raidLocation);
        this.raidPreset = RaidPresets.GetRaidPreset(this.raidLocation);

        // Reset death tracking for fresh spawns
        this.deadCount = 0;
        this.spawnCount = ArraySize(this.raidPreset.characters);

        // Whether enemy drug dealers are aware of player's presence
        let playerStateSystem = PlayerStateSystem.Get();
        if !IsDefined(playerStateSystem) {
            return;
        }
        let notoriety = playerStateSystem.RollNotoriety();

        let spawnSystem = EntitySpawnSystem.Get();
        if !IsDefined(spawnSystem) {
            return;
        }
        spawnSystem
            .RequestSpawn(
                this.raidPreset.characters,
                this.locationWithOrientation.location,
                this.locationWithOrientation.orientation,
                [this.GetJobTag()],
                PassProbabilityCheck(notoriety)
            );

        // Pin it on the map
        let ddMappin = new DrugDealerMappinData();
        ddMappin.mappinType = DrugDealerMappinType.RoamingRaid;
        ddMappin.displayName = GetLocalizedTextByKey(n"DD.Mappin.RoamingRaid");
        super.RegisterMappin(this.locationWithOrientation.location, ddMappin);
    }

    public func Complete() {
        super.Complete();
        super.UnregisterMappin();

        // Award score
        let playerStateSystem = PlayerStateSystem.Get();
        if !IsDefined(playerStateSystem) {
            return;
        }
        playerStateSystem.ScoreRaid();

        // Award turf control
        let turfLocation = ConvertToTurfLocation(this.raidLocation);
        let turfControlSystem = TurfControlSystem.Get();
        if !IsDefined(turfControlSystem) {
            return;
        }
        turfControlSystem.AwardTurfControlByBodies(turfLocation, this.deadCount);

        // Show notification
        let notificationSystem = NotificationSystem.Get();
        if !IsDefined(notificationSystem) {
            return;
        }
        notificationSystem
            .ShowNotification(
                GetLocalizedTextByKey(n"DD.RoamingRaid.Successful"),
                NotificationStyle.Reward,
                0.0,
                TurfControlSystem.GetLocalizationForTurfControlGainByBodies(this.deadCount)
            );

        // Play sound
        let soundSystem = SoundSystem.Get();
        if !IsDefined(soundSystem) {
            return;
        }
        soundSystem.PlayRaidCompleted();
        soundSystem.VoiceRaid(1.2);
    }

    public func Fail() {
        // Since this is a roaming content, no failed notification is desired
        super.Fail();
        super.UnregisterMappin();
    }

    public func RefreshMappin() {
        super.UnregisterMappin();
        let ddMappin = new DrugDealerMappinData();
        ddMappin.mappinType = DrugDealerMappinType.RoamingRaid;
        ddMappin.displayName = GetLocalizedTextByKey(n"DD.Mappin.RoamingRaid");
        super.RegisterMappin(this.locationWithOrientation.location, ddMappin);
    }
}

