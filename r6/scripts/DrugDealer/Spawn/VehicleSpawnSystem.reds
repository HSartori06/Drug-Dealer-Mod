module DrugDealer.Spawn

import DrugDealer.Settings.{Constants}
import NightlyNow.Utils.{IsPlayerInDialogOrCutscene, FlipCoin}

// -----------------------------------------------------------------------------
// VehicleSpawnSystem - DrugDealer
// -----------------------------------------------------------------------------
public class VehicleSpawnSystem extends ScriptableSystem {
    private let waveTags: array<CName>;
    // Better use counter than random, see bugs with Phoenicia's reinfs
    private let waveCounter: Int32;

    public static func Get() -> ref<VehicleSpawnSystem> = GameInstance
        .GetScriptableSystemsContainer(GetGameInstance())
        .Get(n"DrugDealer.Spawn.VehicleSpawnSystem") as VehicleSpawnSystem;

    // Splits vehicleIds into pairs and spawns each with configured delay
    public func SpawnVehicleWave(vehicleIds: array<TweakDBID>) {
        if IsPlayerInDialogOrCutscene() {
            // Player is in dialog or cutscene, do not spawn
            return;
        }

        ArrayClear(this.waveTags);
        let count = ArraySize(vehicleIds);
        let i = 0;
        let waveIndex = 0;
        while i < count {
            // Slice up to 2 vehicles per sub-wave
            let chunk: array<TweakDBID>;
            ArrayPush(chunk, vehicleIds[i]);
            if i + 1 < count {
                ArrayPush(chunk, vehicleIds[i + 1]);
            }

            if waveIndex == 0 {
                // First pair spawns immediately
                this.SpawnVehicleWaveInternal(chunk);
            } else {
                // Subsequent pairs spawn after delay
                let delaySystem = GameInstance.GetDelaySystem(GetGameInstance());
                let callback = new VehicleWaveSpawnCallback();
                callback.vehicleIds = chunk;
                delaySystem
                    .DelayCallback(
                        callback,
                        Cast<Float>(waveIndex) * Constants.VehicleWaveDelayInSeconds(),
                        false
                    );
            }

            i += 2;
            waveIndex += 1;
        }
    }

    public func SpawnVehicleWaveInternal(vehicleIds: array<TweakDBID>) {
        this.waveCounter += 1;
        let uniqueId = s"DrugDealer_vehicle_spawn_\(this.waveCounter)";
        let tag = StringToName(uniqueId);
        ArrayPush(this.waveTags, tag);

        let nodeType = new questDynamicVehicleSpawn_NodeType();
        nodeType.VehicleData = vehicleIds;
        nodeType.waveTag = tag;
        nodeType.distanceRange = Vector2(
            Constants.VehicleSpawnMinDistanceInMeters(),
            Constants.VehicleSpawnMaxDistanceInMeters()
        );

        // Randomized spawn direction
        nodeType.spawnDirectionPreference = FlipCoin() ? questSpawnDirectionPreference.Behind : questSpawnDirectionPreference.InFront;

        let node = new questDynamicSpawnSystemNodeDefinition();
        node.id = Cast<Uint16>(0);
        node.type = nodeType;

        let questSystem = GameInstance.GetQuestsSystem(GetGameInstance());
        questSystem.ExecuteNode(node);
    }

    // Despawn all sub-waves
    public func DespawnVehicleWave() {
        let questSystem = GameInstance.GetQuestsSystem(GetGameInstance());
        for tag in this.waveTags {
            let nodeType = new questDynamicVehicleDespawn_NodeType();
            nodeType.waveTag = tag;
            nodeType.ImmediateDespawn = true;

            let node = new questDynamicSpawnSystemNodeDefinition();
            node.id = Cast<Uint16>(0);
            node.type = nodeType;

            questSystem.ExecuteNode(node);
        }
        ArrayClear(this.waveTags);
    }
}

// Delayed callback for vehicle wave spawns
public class VehicleWaveSpawnCallback extends DelayCallback {
    public let vehicleIds: array<TweakDBID>;

    public func Call() {
        let vehicleSpawnSystem = VehicleSpawnSystem.Get();
        if !IsDefined(vehicleSpawnSystem) {
            return;
        }
        vehicleSpawnSystem.SpawnVehicleWaveInternal(this.vehicleIds);
    }
}

// For friendlies in vehicles, this sets the attitude towards player.
// Yaml base attitude cannot be used for this as the vehicle wave makes them always hostile.
// Attitude application also have to be delayed some time after spawn.
@wrapMethod(NPCPuppet)
protected cb func OnPostInitialize(evt: ref<entPostInitializeEvent>) -> Bool {
    let result = wrappedMethod(evt);
    if NPCManager.HasTag(this.GetRecordID(), n"DrugDealerPlayerAlly") {
        // Delay attitude fix so the vehicle chase system finishes init first
        let delaySystem = GameInstance.GetDelaySystem(GetGameInstance());
        let callback = new PlayerGoonCallback();
        callback.npcPuppet = this;
        // The delay is kinda whatever here, 3.5s should be fine
        delaySystem
            .DelayCallback(callback, Constants.PlayerAllyAttitudeDelayInSeconds(), false);
    }
    return result;
}

public class PlayerGoonCallback extends DelayCallback {
    public let npcPuppet: wref<NPCPuppet>;

    public func Call() {
        if !IsDefined(this.npcPuppet) {
            // Should never happen
            return;
        }

        let gameInstance = GetGameInstance();
        let player = GetPlayer(gameInstance);
        if !IsDefined(player) {
            return;
        }

        let npcAttitudeAgent = this.npcPuppet.GetAttitudeAgent();
        let playerAttitudeAgent = player.GetAttitudeAgent();
        if !IsDefined(npcAttitudeAgent) || !IsDefined(playerAttitudeAgent) {
            return;
        }

        // Set attitudes
        npcAttitudeAgent.SetAttitudeGroup(playerAttitudeAgent.GetAttitudeGroup());
        npcAttitudeAgent.SetAttitudeTowards(playerAttitudeAgent, EAIAttitude.AIA_Friendly);
        playerAttitudeAgent.SetAttitudeTowards(npcAttitudeAgent, EAIAttitude.AIA_Friendly);

        // Issue commands
        let aiControllerComponent: ref<AIHumanComponent> = this.npcPuppet.GetAIControllerComponent();
        if !IsDefined(aiControllerComponent) {
            return;
        }

        // Get vehicle, since we don't know the id at this point, gotta read it from npc
        let vehicleObject: wref<VehicleObject>;
        VehicleComponent.GetVehicle(gameInstance, this.npcPuppet, vehicleObject);

        if IsDefined(vehicleObject) {
            // Unmount only if in vehicle
            let unmountData: ref<MountEventData> = new MountEventData();
            unmountData.mountParentEntityId = vehicleObject.GetEntityID();
            unmountData.isInstant = false;
            unmountData.ignoreHLS = false;
            unmountData.removePitchRollRotationOnDismount = false;

            let unmountCommand: ref<AIUnmountCommand> = new AIUnmountCommand();
            unmountCommand.mountData = unmountData;
            aiControllerComponent.SendCommand(unmountCommand);
        }

        // Follow
        let followTargetCommand = new AIFollowTargetCommand();
        followTargetCommand.matchSpeed = true;
        followTargetCommand.stopWhenDestinationReached = false;
        followTargetCommand.teleport = false;
        followTargetCommand.target = player;
        followTargetCommand.desiredDistance = 5.0;
        followTargetCommand.tolerance = 2.5;
        followTargetCommand.lookAtTarget = player;

        aiControllerComponent.SendCommand(followTargetCommand);
    }
}

