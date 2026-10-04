module DrugDealer.Sound

import DrugDealer.Settings.SettingsSystem

@if(ModuleExists("AudioXL"))
import AudioXL.*

// -----------------------------------------------------------------------------
// Sound - Drug Dealer
// -----------------------------------------------------------------------------
public final class SoundSystem extends ScriptableSystem {
    public static func Get() -> ref<SoundSystem> {
        return GameInstance
            .GetScriptableSystemsContainer(GetGameInstance())
            .Get(n"DrugDealer.Sound.SoundSystem") as SoundSystem;
    }

    public func PlayDrugDealCompleted() {
        this.PlaySound(n"dd_drug_deal_w");
    }

    public func PlayDrugDealFailed() {
        this.PlaySound(n"dd_drug_deal_l");
    }

    public func PlayPartialDrugDealCompleted() {
        this.PlaySound(n"dd_partial_drug_deal");
    }

    public func PlayBigDrugDealCompleted() {
        this.PlaySound(n"dd_big_drug_deal_w");
    }

    public func PlayLabAmbush() {
        this.PlaySound(n"dd_lab_ambush");
    }

    public func PlayNcpdDrugBust() {
        this.PlaySound(n"dd_ncpd_drug_bust");
    }

    public func PlayRaidCompleted() {
        this.PlaySound(n"dd_raid_w");
    }

    public func PlayProductPrepared() {
        this.PlaySound(n"dd_product_prepared");
    }

    public func PlayCrackhouseSold() {
        this.PlaySound(n"dd_crackhouse_w");
    }

    public func PlayTerror() {
        this.PlaySound(n"dd_terror");
    }

    public func PlaySupply() {
        this.PlaySound(n"dd_supply");
    }

    public func PlayAssassination() {
        this.PlaySound(n"dd_assassination");
    }

    public func PlayNightMarket() {
        this.PlaySound(n"dd_nightmarket");
    }

    public func VoiceAmbush(delayInSeconds: Float) {
        this.PlayDelayedVoice(n"dd_voice_ambush", delayInSeconds);
    }

    public func VoiceCrackhouse(delayInSeconds: Float) {
        this.PlayDelayedVoice(n"dd_voice_crackhouse", delayInSeconds);
    }

    public func VoiceFailedDeal(delayInSeconds: Float) {
        this.PlayDelayedVoice(n"dd_voice_failed_deal", delayInSeconds);
    }

    public func VoiceDealWithFiend(delayInSeconds: Float) {
        this.PlayDelayedVoice(n"dd_voice_deal_with_fiend", delayInSeconds);
    }

    public func VoiceRaid(delayInSeconds: Float) {
        this.PlayDelayedVoice(n"dd_voice_raid", delayInSeconds);
    }

    public func VoiceDrugBust(delayInSeconds: Float) {
        this.PlayDelayedVoice(n"dd_voice_drug_bust", delayInSeconds);
    }

    public func VoiceTerror(delayInSeconds: Float) {
        this.PlayDelayedVoice(n"dd_voice_terror", delayInSeconds);
    }

    public func VoiceSupply(delayInSeconds: Float) {
        this.PlayDelayedVoice(n"dd_voice_supply", delayInSeconds);
    }

    public func VoiceAssassination(delayInSeconds: Float) {
        this.PlayDelayedVoice(n"dd_voice_assassination", delayInSeconds);
    }

    // This plays a custom sound (or not if AudioXL by goddess DV is missing)
    private func PlaySound(sound: CName) {
        PlayCustomSound(sound);
    }

    private func PlayDelayedVoice(sound: CName, delayInSeconds: Float) {
        let settingsSystem = SettingsSystem.Get();
        if !IsDefined(settingsSystem) {
            return;
        }
        if !settingsSystem.enableVComments {
            // Voices not enabled
            return;
        }
        let voiceCallback = new VoiceDelayCallback();
        voiceCallback.sound = sound;
        GameInstance
            .GetDelaySystem(GetGameInstance())
            .DelayCallback(voiceCallback, delayInSeconds, false);
    }
}

public class VoiceDelayCallback extends DelayCallback {
    public let sound: CName;

    public func Call() {
        PlayCustomVoiceLine(this.sound);
    }
}

@if(ModuleExists("AudioXL"))
public func PlayCustomSound(sound: CName) {
    GameInstance.GetAudioSystem(GetGameInstance()).Play(sound);
}

@if(!ModuleExists("AudioXL"))
public func PlayCustomSound(sound: CName) {}

@if(ModuleExists("AudioXL"))
public func PlayCustomVoiceLine(sound: CName) {
    let gameInstance = GetGameInstance();
    AudioXLAPI.PlayLine(sound, GetPlayer(gameInstance).GetEntityID(), n"V");
}

@if(!ModuleExists("AudioXL"))
public func PlayCustomVoiceLine(sound: CName) {}
