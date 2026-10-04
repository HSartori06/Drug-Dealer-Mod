module DrugDealer.Spawn

import DrugDealer.Job.*
import DrugDealer.Job.Stash.StashSystem

// -----------------------------------------------------------------------------
// EntitySpawnSystem - DrugDealer
// -----------------------------------------------------------------------------
// Handles async entity spawning via DynamicEntitySystem from Codeware
public class EntitySpawnSystem extends ScriptableSystem {
    private let entitySystem: ref<DynamicEntitySystem>;

    public static func Get() -> ref<EntitySpawnSystem> {
        return GameInstance
            .GetScriptableSystemsContainer(GetGameInstance())
            .Get(n"DrugDealer.Spawn.EntitySpawnSystem") as EntitySpawnSystem;
    }

    public func OnAttach() {
        this.entitySystem = GameInstance.GetDynamicEntitySystem();
        // Register spawn handler
        this
            .entitySystem
            .RegisterListener(n"DrugDealer.EntitySpawn", this, n"OnEntityEvent");
    }

    public func RequestSpawn(
        entityIds: array<TweakDBID>,
        position: Vector4,
        orientation: Quaternion,
        opt tags: array<CName>,
        opt combat: Bool
    ) {
        if !IsDefined(this.entitySystem) {
            return;
        }

        let count = ArraySize(entityIds);
        // Careful here as the NPCs might spawn into walls and such
        let distance = ClampF(Cast<Float>(count) * 0.3, 2.0, 3.0);
        // Make a formation based on NPC count
        let positions = MakeFormation(position, count, distance);

        let i = 0;
        for entityId in entityIds {
            let spawnPos = positions[i];
            i += 1;

            let entitySpec = new DynamicEntitySpec();
            entitySpec.recordID = entityId;
            entitySpec.appearanceName = n"default";
            entitySpec.position = spawnPos;

            if count > 1 {
                // Slightly randomize orientation for multi spawns so it looks more natural
                entitySpec.orientation = this.RandomizeOrientation(orientation);
            } else {
                entitySpec.orientation = orientation;
            }

            entitySpec.persistState = false;
            entitySpec.persistSpawn = false;
            entitySpec.spawnInView = true;
            entitySpec.active = true;
            ArrayPush(entitySpec.tags, n"DrugDealer.EntitySpawn");
            // Append caller provided tags
            for tag in tags {
                ArrayPush(entitySpec.tags, tag);
            }
            if combat {
                // Combat requested, assign tag and check later in cb
                ArrayPush(entitySpec.tags, n"DrugDealer.Hostile");
            }

            this.entitySystem.CreateEntity(entitySpec);
        }
    }

    public func RequestContainer(
        templatePath: ResRef,
        appearanceName: CName,
        position: Vector4,
        orientation: Quaternion,
        opt tags: array<CName>
    ) {
        if !IsDefined(this.entitySystem) {
            return;
        }

        let entitySpec = new DynamicEntitySpec();
        entitySpec.templatePath = templatePath;
        // n"default" never works here
        entitySpec.appearanceName = appearanceName;
        entitySpec.position = position;
        entitySpec.orientation = orientation;
        entitySpec.persistState = false;
        entitySpec.persistSpawn = false;
        entitySpec.spawnInView = true;
        entitySpec.active = true;
        ArrayPush(entitySpec.tags, n"DrugDealer.EntitySpawn");
        ArrayPush(entitySpec.tags, n"DrugDealer.Stash");

        // Append provided tags
        for tag in tags {
            ArrayPush(entitySpec.tags, tag);
        }

        this.entitySystem.CreateEntity(entitySpec);
    }

    // Despawn a managed entity
    public func DespawnEntity(entityId: EntityID) {
        if IsDefined(this.entitySystem) {
            this.entitySystem.DeleteEntity(entityId);
        }
    }

    private cb func OnEntityEvent(event: ref<DynamicEntityEvent>) {
        if !IsDefined(this.entitySystem) {
            return;
        }

        let entityId = event.GetEntityID();
        switch event.GetEventType() {
            case DynamicEntityEventType.Spawned:
                // Trigger combat if hostile-tagged
                if this.entitySystem.IsTagged(entityId, n"DrugDealer.Hostile") {
                    let puppet = this.entitySystem.GetEntity(entityId) as NPCPuppet;
                    if IsDefined(puppet) {
                        let player = GetPlayer(GetGameInstance());
                        StimBroadcasterComponent
                            .SendStimDirectly(player, gamedataStimType.CombatHit, puppet);
                    }
                }

                if this.entitySystem.IsTagged(entityId, n"DrugDealer.Stash") {
                    // Fill the stash with loot upon spawn
                    let stashSystem = StashSystem.Get();
                    if !IsDefined(stashSystem) {
                        return;
                    }
                    stashSystem.FillStashWithLoot(entityId);
                }

                break;
        }
    }

    // Notify parent job on first player attack against a spawned NPC
    public func HandleEntityAttacked(puppet: ref<NPCPuppet>) {
        let entityId = puppet.GetEntityID();
        if !IsDefined(this.entitySystem) {
            return;
        }
        if !this.entitySystem.IsManaged(entityId) {
            return;
        }
        if !this.entitySystem.IsTagged(entityId, n"DrugDealer.EntitySpawn") {
            return;
        }

        let jobSchedulerSystem = JobSchedulerSystem.Get();
        if !IsDefined(jobSchedulerSystem) {
            return;
        }

        let job = jobSchedulerSystem.FindActiveJobByEntityId(entityId, this.entitySystem);
        if IsDefined(job) {
            // Notify the job
            job.OnEntityAttacked();
        }
    }

    // Check if a dead NPC belongs to a raid job and notify it
    public func HandleEntityDeath(entityId: EntityID) {
        if !IsDefined(this.entitySystem) {
            return;
        }
        if !this.entitySystem.IsManaged(entityId) {
            // Not managed by dynamic entity system
            return;
        }
        if !this.entitySystem.IsTagged(entityId, n"DrugDealer.EntitySpawn") {
            // Not a DD spawn
            return;
        }
        // Find matching raid job by checking entity tags
        let jobSchedulerSystem = JobSchedulerSystem.Get();
        if !IsDefined(jobSchedulerSystem) {
            return;
        }
        let job = jobSchedulerSystem.FindActiveJobByEntityId(entityId, this.entitySystem);
        if IsDefined(job) {
            job.OnEntityDied(entityId);
        }
    }

    // Apply random yaw offset up to +-25 degrees, so they look a bit more natural
    private func RandomizeOrientation(base: Quaternion) -> Quaternion {
        let baseEuler = Quaternion.ToEulerAngles(base);
        let offset = RandRangeF(-25.0, 25.0);
        baseEuler.Yaw += offset;
        return EulerAngles.ToQuat(baseEuler);
    }
}

// Track defeats for resolving job kill count
@wrapMethod(ScriptedPuppet)
protected cb func OnDefeated(evt: ref<DefeatedEvent>) -> Bool {
    let entitySpawnSystem = EntitySpawnSystem.Get();
    if IsDefined(entitySpawnSystem) {
        entitySpawnSystem.HandleEntityDeath(this.GetEntityID());
    }
    return wrappedMethod(evt);
}

// Track deaths for resolving job kill count
@wrapMethod(NPCPuppet)
protected cb func OnDeath(evt: ref<gameDeathEvent>) -> Bool {
    let entitySpawnSystem = EntitySpawnSystem.Get();
    if IsDefined(entitySpawnSystem) {
        entitySpawnSystem.HandleEntityDeath(this.GetEntityID());
    }
    return wrappedMethod(evt);
}

// Track any player attack on NPCs spawned by DD
@addField(ScriptedPuppet)
public let ddAttackedByPlayer: Bool;

@wrapMethod(ScriptedPuppet)
protected cb func OnDamageReceived(evt: ref<gameDamageReceivedEvent>) -> Bool {
    // This remains perf friendly as only the first registered attack is processed further
    let npc = this as NPCPuppet;
    if IsDefined(npc) && !npc.ddAttackedByPlayer {
        this.ddAttackedByPlayer = true;
        if IsDefined(evt.hitEvent) && IsDefined(evt.hitEvent.attackData) {
            let instigator = evt.hitEvent.attackData.GetInstigator();
            if IsDefined(instigator) && instigator.IsPlayer() {
                let entitySpawnSystem = EntitySpawnSystem.Get();
                if IsDefined(entitySpawnSystem) {
                    entitySpawnSystem.HandleEntityAttacked(npc);
                }
            }
        }
    }
    return wrappedMethod(evt);
}

