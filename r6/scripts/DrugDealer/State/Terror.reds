module DrugDealer.State

import NightlyNow.Notification.{NotificationSystem, NotificationStyle}
import NightlyNow.Utils.{IsPlayerInDialogOrCutscene, IsPlayerInPhotoMode}
import DrugDealer.Settings.{SettingsSystem, Constants}
import DrugDealer.Translation.TranslateTurfLocation
import DrugDealer.Sound.SoundSystem
import DrugDealer.Tutorial.DrugDealerTutorialSystem

// -----------------------------------------------------------------------------
// Terror - DrugDealer
// -----------------------------------------------------------------------------
// Delayed callback for periodic terror tick
public class TerrorTickCallback extends DelayCallback {
    public let system: wref<TerrorSystem>;

    public func Call() {
        if IsDefined(this.system) {
            this.system.OnTerrorTick();
        }
    }
}

// Delayed callback for resuming polling after the bar held at full terror
public class TerrorResumePollingCallback extends DelayCallback {
    public let system: wref<TerrorSystem>;

    public func Call() {
        if IsDefined(this.system) {
            this.system.StartTickPolling();
        }
    }
}

public class TerrorSystem extends ScriptableSystem {
    private persistent let terrorValue: Float;
    private let tickDelayId: DelayID;
    private let isTickRunning: Bool;
    private let terrorBarVisible: Bool;

    public static func Get() -> ref<TerrorSystem> {
        return GameInstance
            .GetScriptableSystemsContainer(GetGameInstance())
            .Get(n"DrugDealer.State.TerrorSystem") as TerrorSystem;
    }

    // Currently used by Informative Healthbar by Scream81
    public func GetTerrorValue() -> Float = this.terrorValue;

    // Currently used by Informative Healthbar by Scream81
    public func IsTerrorBarVisible() -> Bool = this.terrorBarVisible;

    public func StartTickPolling() {
        if this.isTickRunning {
            return;
        }
        this.isTickRunning = true;
        this.QueueTerrorTick();
    }

    public func StopTickPolling() {
        this.isTickRunning = false;
        let delaySystem = GameInstance.GetDelaySystem(GetGameInstance());
        delaySystem.CancelDelay(this.tickDelayId);
    }

    private func QueueTerrorTick() {
        let callback = new TerrorTickCallback();
        callback.system = this;
        let delaySystem = GameInstance.GetDelaySystem(GetGameInstance());
        this.tickDelayId = delaySystem.DelayCallback(callback, Constants.TerrorUpdateInSeconds(), false);
    }

    public func OnTerrorTick() {
        this.ModifyTerrorValue(-1.0);

        if this.isTickRunning {
            this.QueueTerrorTick();
        }
    }

    // Range is 0-100 to adhere to the progress bar percents
    public func ModifyTerrorValue(value: Float, opt turfCheck: Bool) {
        if turfCheck && Equals(GetCurrentTurf(), TurfLocation.None) {
            // Player causing terror on unsupported turf
            return;
        }

        this.terrorValue += value;
        this.terrorValue = ClampF(this.terrorValue, 0.0, 100.0);

        if this.terrorValue >= Constants.TerrorBarVisibleFrom() && !this.terrorBarVisible {
            this.terrorBarVisible = true;
        }

        if IsPlayerInDialogOrCutscene() || IsPlayerInPhotoMode() {
            // Automatically hide the bar in dialog/cutscenes or PM
            this.terrorBarVisible = false;
        }

        if this.terrorValue == 0.0 {
            this.ResetProgress();
        }

        let notificationSystem = NotificationSystem.Get();
        if !IsDefined(notificationSystem) {
            return;
        }

        if !this.terrorBarVisible {
            // Terror progress bar not visible
            notificationSystem.HideProgressBar();
            return;
        }

        // Display progress bar
        notificationSystem
            .ShowProgressBar(
                this.terrorValue,
                GetLocalizedTextByKey(n"DD.Turf.Terror"),
                NotificationStyle.Penalty
            );

        if this.terrorValue == 100.0 {
            // When full terror is reached, hold the bar there for a while
            this.StopTickPolling();
            this.ResetProgress();

            let terrorizedTurf = GetCurrentTurf();
            if !Equals(terrorizedTurf, TurfLocation.None) {
                // Award terror turf control
                let turfControlSystem = TurfControlSystem.Get();
                if !IsDefined(turfControlSystem) {
                    return;
                }
                turfControlSystem.AwardTurfControlByTerror(terrorizedTurf);

                // Play audio
                let soundSystem = SoundSystem.Get();
                if !IsDefined(soundSystem) {
                    return;
                }
                soundSystem.PlayTerror();
                soundSystem.VoiceTerror(1.2);

                // Display notification
                notificationSystem
                    .ShowNotification(
                        s"\(TranslateTurfLocation(terrorizedTurf)) \(GetLocalizedTextByKey(n"DD.Turf.Terrorized"))",
                        NotificationStyle.Reward,
                        0.5,
                        TurfControlSystem.GetLocalizationForTurfControlGainByTerror()
                    );

                // Play tutorial
                let tutorialSystem = DrugDealerTutorialSystem.Get();
                if !IsDefined(tutorialSystem) {
                    return;
                }
                tutorialSystem.PlayTerror();
            }

            let resumeCallback = new TerrorResumePollingCallback();
            resumeCallback.system = this;
            GameInstance
                .GetDelaySystem(GetGameInstance())
                .DelayCallback(resumeCallback, 2.9, false);
        }
    }

    private func ResetProgress() {
        this.terrorValue = 0.0;
        this.terrorBarVisible = false;
    }
}

@wrapMethod(PlayerPuppet)
protected cb func OnGameAttached() -> Bool {
    wrappedMethod();

    let systemRequestsHandler: ref<inkISystemRequestsHandler> = GameInstance.GetSystemRequestsHandler();
    if IsDefined(systemRequestsHandler) && systemRequestsHandler.IsPreGame() {
        return true;
    }

    let terrorSystem = TerrorSystem.Get();
    if !IsDefined(terrorSystem) {
        return true;
    }

    terrorSystem.StartTickPolling();
}

@wrapMethod(PlayerPuppet)
protected cb func OnDetach() -> Bool {
    wrappedMethod();

    let terrorSystem = TerrorSystem.Get();
    if !IsDefined(terrorSystem) {
        return true;
    }

    terrorSystem.StopTickPolling();
}

// Add terror on defeat, kill
public func AddTerrorOnNpcEvent(npc: ref<NPCPuppet>) {
    let settingsSystem = SettingsSystem.Get();
    if !IsDefined(settingsSystem) {
        return;
    }
    if !settingsSystem.terrorEnabled {
        // Terror disabled
        return;
    }

    if IsDefined(npc.m_myKiller) && !npc.m_myKiller.IsPlayerControlled() {
        // Player wasn't the attacker
        return;
    }

    let executed = npc.GetPS().GetWasIncapacitated() && ScriptedPuppet.IsAlive(npc) && !npc.m_shouldBeDefeated;
    if executed {
        // Executions don't count, that made it too easy before
        return;
    }

    // Modify terror & rerender UI
    let terrorSystem = TerrorSystem.Get();
    if !IsDefined(terrorSystem) {
        return;
    }
    terrorSystem.ModifyTerrorValue(settingsSystem.TerrorValuePerKill(), true);
}

// Track kills for terror
@wrapMethod(NPCPuppet)
protected cb func OnDeath(evt: ref<gameDeathEvent>) -> Bool {
    AddTerrorOnNpcEvent(this);
    return wrappedMethod(evt);
}

// Track defeats for terror
@wrapMethod(ScriptedPuppet)
protected cb func OnDefeated(evt: ref<DefeatedEvent>) -> Bool {
    let npc = this as NPCPuppet;
    if IsDefined(npc) {
        AddTerrorOnNpcEvent(npc);
    }
    return wrappedMethod(evt);
}

// Track vehicle explosions
@wrapMethod(VehicleComponent)
protected cb func OnDeath(evt: ref<gameDeathEvent>) -> Bool {
    let result = wrappedMethod(evt);
    let settingsSystem = SettingsSystem.Get();
    if !IsDefined(settingsSystem) {
        return result;
    }
    if !settingsSystem.terrorEnabled {
        // Terror disabled
        return result;
    }

    if IsDefined(evt) && IsDefined(evt.instigator) && evt.instigator.IsPlayer() {
        // Modify terror & rerender UI
        let terrorSystem = TerrorSystem.Get();
        if !IsDefined(terrorSystem) {
            return result;
        }
        terrorSystem.ModifyTerrorValue(settingsSystem.TerrorValuePerVehicleExplosion(), true);
    }

    return result;
}

