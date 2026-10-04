module DrugDealer.Integration

import DrugDealer.State.{DrugDealerRank, PlayerStateSystem}
import DrugDealer.Settings.{Constants, SettingsSystem}

@if(ModuleExists("ThinBlueLine"))
import ThinBlueLine.ThinBlueLineSystem

// -----------------------------------------------------------------------------
// Thin Blue Line Integration - Drug Dealer
// -----------------------------------------------------------------------------
@if(ModuleExists("ThinBlueLine"))
public func ApplyKnownTarget() {
    let applyKnownTargetCallback = new ApplyKnownTargetCallback();
    GameInstance
        .GetDelaySystem(GetGameInstance())
        .DelayCallback(applyKnownTargetCallback, Constants.IntegrationApplyDelayInSeconds(), false);
}

@if(ModuleExists("ThinBlueLine"))
public class ApplyKnownTargetCallback extends DelayCallback {
    public func Call() {
        let playerStateSystem = PlayerStateSystem.Get();
        if !IsDefined(playerStateSystem) {
            return;
        }

        let rank = Cast<Float>(EnumInt(playerStateSystem.GetRank()));
        let knownTargetValue = ClampF(rank / 10.0, 0.0, 1.0);
        let thinBlueLineSystem = ThinBlueLineSystem.Get();
        if IsDefined(thinBlueLineSystem) {
            thinBlueLineSystem.SetKnownTarget(n"DrugDealer", knownTargetValue);
        }
    }
}

@if(!ModuleExists("ThinBlueLine"))
public func ApplyKnownTarget() {
}

@wrapMethod(PlayerPuppet)
protected cb func OnGameAttached() -> Bool {
    wrappedMethod();

    let systemRequestsHandler: ref<inkISystemRequestsHandler> = GameInstance.GetSystemRequestsHandler();
    if IsDefined(systemRequestsHandler) && systemRequestsHandler.IsPreGame() {
        // Prevent firing in MM
        return true;
    }

    let settings = SettingsSystem.Get();
    if IsDefined(settings) && settings.enableThinBlueLineKnownTarget {
        ApplyKnownTarget();
    }
}

