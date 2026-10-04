module DrugDealer.Job.SellDrugs

import DrugDealer.Job.*
import DrugDealer.Spawn.EntitySpawnSystem
import NightlyNow.Utils.{SkipTime, ProximityDetector, ApplyHeat, PassProbabilityCheck, IsNight, IsCorpo}
import DrugDealer.State.{PlayerStateSystem, TurfControlSystem, Turf, TurfLocation}
import DrugDealer.Settings.{Constants, IsMainAction}
import NightlyNow.Notification.{NotificationSystem, SideNotification, SideNotificationStyle}

// -----------------------------------------------------------------------------
// Interaction - Drug Dealer
// -----------------------------------------------------------------------------
public class DDProximityCheckCallback extends DelayCallback {
    public let controller: wref<NPCInteractionController>;

    public func Call() {
        if IsDefined(this.controller) {
            this.controller.OnProximityCheck();
        }
    }
}

public class NPCInteractionController extends ScriptableSystem {
    private let trackedNPC: wref<NPCPuppet>;
    private let proximityDetector: ref<ProximityDetector>;
    private let wasNearBefore: Bool;
    // NPC that triggered an NCPD bust, excluded from proximity re-registration
    private let underCoverCop: EntityID;

    public static func Get() -> ref<NPCInteractionController> {
        return GameInstance
            .GetScriptableSystemsContainer(GetGameInstance())
            .Get(n"DrugDealer.Job.SellDrugs.NPCInteractionController") as NPCInteractionController;
    }

    // Store buyer NPC reference and begin proximity polling
    public func RegisterNPC(npc: ref<NPCPuppet>) {
        if Equals(this.underCoverCop, npc.GetEntityID()) {
            return;
        }
        let mainInteractionTitle = GetLocalizedTextByKey(n"DD.SellDrugs.InteractionTitle");
        let interactionActions = Constants.InputRegisteredActions();

        this.trackedNPC = npc;
        this.proximityDetector = ProximityDetector.Create(mainInteractionTitle, interactionActions[0], 0.1, true, 3.0);
        this.QueueCheck();
    }

    // Remove interaction and clear tracking state
    public func UnregisterNPC() {
        this.proximityDetector.HideInteraction();
        this.proximityDetector.CancelProximityCheck();
        this.trackedNPC = null;
    }

    // Handle sell interaction
    public func OnSellDrugsInteraction(npc: ref<NPCPuppet>) {
        SkipTime(300);
        // Find the relevant job
        let jobSchedulerSystem = JobSchedulerSystem.Get();
        if !IsDefined(jobSchedulerSystem) {
            return;
        }
        let sellDrugsJob = jobSchedulerSystem.FindActiveJobByType(JobType.SellDrugs) as SellDrugsJob;

        if !IsDefined(sellDrugsJob) || !IsDefined(npc) {
            // Safe guards
            return;
        }

        // NCPD roll check (high society is excluded)
        let playerStateSystem = PlayerStateSystem.Get();
        if !IsDefined(playerStateSystem) {
            return;
        }
        if !sellDrugsJob.highSociety && PassProbabilityCheck(playerStateSystem.RollNcpdNotoriety()) {
            // Prevent re-registration via proximity events
            this.underCoverCop = npc.GetEntityID();
            // Unregister proximity check and interactions
            this.UnregisterNPC();
            // Make NPC flee, civilians have no combat ai
            this.MakeNpcFlee(npc);
            // Apply heat
            let heatToApply = playerStateSystem.GetNcpdHeat();
            ApplyHeat(heatToApply);
            // Fail the job
            sellDrugsJob.FailWithNcpdDrugBust();
            return;
        }

        let spawnSystem = EntitySpawnSystem.Get();
        if !IsDefined(spawnSystem) {
            return;
        }
        spawnSystem.DespawnEntity(npc.GetEntityID());
        this.UnregisterNPC();

        if IsDefined(sellDrugsJob) {
            sellDrugsJob.Resolve();
        }
    }

    // Check if player is within range of the tracked buyer NPC
    public func OnProximityCheck() {
        if !IsDefined(this.trackedNPC) {
            this.proximityDetector.HideInteraction();
            return;
        }
        let isNear = this
            .proximityDetector
            .IsPlayerNearPosition(this.trackedNPC.GetWorldPosition());

        // Side notification
        let notificationSystem = NotificationSystem.Get();
        if !IsDefined(notificationSystem) {
            return;
        }
        if !this.wasNearBefore && isNear {
            notificationSystem.ShowSideNotification(this.GetSideNotification());
        } else if this.wasNearBefore && !isNear {
            notificationSystem.HideSideNotification();
        }

        this.proximityDetector.UpdateProximity(isNear);
        this.wasNearBefore = isNear;
        this.QueueCheck();
    }

    public func IsInteractionShown() -> Bool = this.proximityDetector.IsInteractionShown();

    public func GetTrackedNPC() -> wref<NPCPuppet> = this.trackedNPC;

    private func GetSideNotification() -> SideNotification {
        let texts: array<String>;
        let styles: array<SideNotificationStyle>;

        // Get buyer location from active sell drugs job
        let jobSchedulerSystem = JobSchedulerSystem.Get();
        if !IsDefined(jobSchedulerSystem) {
            return SideNotification([], []);
        }
        let sellDrugsJob = jobSchedulerSystem.FindActiveJobByType(JobType.SellDrugs) as SellDrugsJob;
        if !IsDefined(sellDrugsJob) {
            return SideNotification([], []);
        }

        let turfLocation = ConvertToTurfLocation(sellDrugsJob.GetBuyerLocation());
        let turfControlSystem = TurfControlSystem.Get();
        if !IsDefined(turfControlSystem) {
            return SideNotification([], []);
        }
        let turf = turfControlSystem.GetTurf(turfLocation);

        if IsDefined(turf) {
            if turf.IsControlled() {
                // Drug monopoly for controlled turf
                ArrayPush(texts, GetLocalizedTextByKey(n"DD.Turf.Controlled.Sales"));
                ArrayPush(styles, SideNotificationStyle.Positive);
            }
            if turf.IsSurrendered() {
                // Sales malus for surrendered turf
                ArrayPush(texts, GetLocalizedTextByKey(n"DD.Turf.Surrendered.Sales"));
                ArrayPush(styles, SideNotificationStyle.Warning);
            }
        }

        if !sellDrugsJob.highSociety && IsNight() {
            // Night sales bonus for street fiends only
            ArrayPush(texts, GetLocalizedTextByKey(n"DD.SellDrugs.NightBonus"));
            ArrayPush(styles, SideNotificationStyle.Positive);
        }

        if sellDrugsJob.highSociety {
            // Night sales bonus for street fiends only
            ArrayPush(texts, GetLocalizedTextByKey(n"DD.SellDrugs.HighSocietyBonus"));
            ArrayPush(styles, SideNotificationStyle.Positive);
        }

        if IsCorpo() {
            // Corpo sales bonus
            ArrayPush(texts, GetLocalizedTextByKey(n"DD.Lifepath.Corpo"));
            ArrayPush(styles, SideNotificationStyle.Positive);
        }

        return SideNotification(texts, styles);
    }

    private func QueueCheck() {
        let cb = new DDProximityCheckCallback();
        cb.controller = this;
        this.proximityDetector.QueueProximityCheck(cb);
    }

    private func MakeNpcFlee(npc: ref<NPCPuppet>) {
        let player = GetPlayer(GetGameInstance());
        StimBroadcasterComponent.SendStimDirectly(player, gamedataStimType.CombatHit, npc);
    }
}

// Register buyer NPC when player gets near it
@wrapMethod(ReactionManagerComponent)
protected cb func OnPlayerProximityStartEvent(evt: ref<PlayerProximityStartEvent>) -> Bool {
    let npc = this.GetOwnerPuppet() as NPCPuppet;
    if IsDefined(npc) && npc.HasTag(n"DrugDealer.Buyer") {
        let ctrl = NPCInteractionController.Get();
        if IsDefined(ctrl) {
            ctrl.RegisterNPC(npc);
        }
    }
    return wrappedMethod(evt);
}

// Listens for DDInteractionAction button hold on the sell drugs prompt
public class DDInputListener {
    public let gameInstance: GameInstance;

    protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
        let actionName = ListenerAction.GetName(action);
        let registeredActionNames = Constants.InputRegisteredActions();

        if !ArrayContains(registeredActionNames, actionName) {
            return false;
        }
        if !Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_HOLD_COMPLETE) {
            return false;
        }
        let ctrl = NPCInteractionController.Get();
        if !IsDefined(ctrl) || !ctrl.IsInteractionShown() {
            return false;
        }

        if IsMainAction(action) {
            // Main action sell drugs
            let npc = ctrl.GetTrackedNPC();
            if IsDefined(npc) {
                ctrl.OnSellDrugsInteraction(npc);
            }
        }
    }
}

// PlayerPuppet hooks
@addField(PlayerPuppet)
private let ddInputListener: ref<DDInputListener>;

// Register input listener when player spawns
@wrapMethod(PlayerPuppet)
protected cb func OnGameAttached() -> Bool {
    wrappedMethod();

    let systemRequestsHandler: ref<inkISystemRequestsHandler> = GameInstance.GetSystemRequestsHandler();
    if IsDefined(systemRequestsHandler) && systemRequestsHandler.IsPreGame() {
        // Prevents firing up in MM
        return true;
    }

    this.ddInputListener = new DDInputListener();
    this.ddInputListener.gameInstance = this.GetGame();
    this.RegisterInputListener(this.ddInputListener);
}

// Unregister input listener on detach
@wrapMethod(PlayerPuppet)
protected cb func OnDetach() -> Bool {
    wrappedMethod();

    if !IsDefined(this.ddInputListener) {
        return false;
    }

    this.UnregisterInputListener(this.ddInputListener);
    this.ddInputListener = null;
}

