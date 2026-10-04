module DrugDealer.Integration

import DrugDealer.State.{DrugDealerRank, PlayerStateSystem}
import DrugDealer.Settings.{Constants, SettingsSystem}

// -----------------------------------------------------------------------------
// Street Sense Integration - Drug Dealer
// -----------------------------------------------------------------------------
@if(ModuleExists("StreetSense"))
public func ApplyFear() {
    let applyFearCallback = new ApplyFearCallback();
    GameInstance
        .GetDelaySystem(GetGameInstance())
        .DelayCallback(applyFearCallback, Constants.IntegrationApplyDelayInSeconds(), false);
}

@if(ModuleExists("StreetSense"))
public class ApplyFearCallback extends DelayCallback {
    public func Call() {
        let playerStateSystem = PlayerStateSystem.Get();
        if !IsDefined(playerStateSystem) {
            return;
        }

        let player = GetPlayer(GetGameInstance());
        if !IsDefined(player) {
            return;
        }

        let rank = Cast<Float>(EnumInt(playerStateSystem.GetRank()));
        if rank < Constants.IntegrationStreetSenseFearMinRank() {
            // Rank too low
            return;
        }

        let fearValue = ClampF(rank / 10.0, 0.0, 1.0);
        player.UNR_SetExternalFear(n"DrugDealer", fearValue);
    }
}

@if(!ModuleExists("StreetSense"))
public func ApplyFear() {
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
    if IsDefined(settings) && settings.enableStreetSenseFear {
        ApplyFear();
    }
}

