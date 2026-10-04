module DrugDealer.Tutorial

import DrugDealer.Settings.{Constants, SettingsSystem}
import NightlyNow.Tutorial.{Tutorial, TutorialSystem}
import NightlyNow.Utils.IsPlayerInDialogOrCutscene

// -----------------------------------------------------------------------------
// Tutorial - DrugDealer
// -----------------------------------------------------------------------------
public class DrugDealerTutorialSystem extends TutorialSystem {
    // Active tutorial callback id
    public let tutorialDelayId: DelayID;

    public static func Get() -> ref<DrugDealerTutorialSystem> {
        return GameInstance
            .GetScriptableSystemsContainer(GetGameInstance())
            .Get(n"DrugDealer.Tutorial.DrugDealerTutorialSystem") as DrugDealerTutorialSystem;
    }

    // Tutorial list
    public func GetTutorials() -> array<Tutorial> = [
        Tutorial(
            n"DD.Tutorial.V6",
            n"DD.Tutorial.V6.Content",
            t"Tutorial.drug_dealer_tutorial_v6"
        ),
        Tutorial(
            n"DD.Tutorial.V5",
            n"DD.Tutorial.V5.Content",
            t"Tutorial.drug_dealer_tutorial_v5"
        ),
        Tutorial(
            n"DD.Tutorial.V4",
            n"DD.Tutorial.V4.Content",
            t"Tutorial.drug_dealer_tutorial_v4"
        ),
        Tutorial(
            n"DD.Tutorial.Introduction",
            n"DD.Tutorial.Introduction.Content",
            t"Tutorial.drug_dealer_tutorial_introduction"
        ),
        Tutorial(
            n"DD.Tutorial.Fiend",
            n"DD.Tutorial.Fiend.Content",
            t"Tutorial.drug_dealer_tutorial_fiend"
        ),
        Tutorial(
            n"DD.Tutorial.Lab",
            n"DD.Tutorial.Lab.Content",
            t"Tutorial.drug_dealer_tutorial_lab"
        ),
        Tutorial(
            n"DD.Tutorial.Raid",
            n"DD.Tutorial.Raid.Content",
            t"Tutorial.drug_dealer_tutorial_raid"
        ),
        Tutorial(
            n"DD.Tutorial.Rank",
            n"DD.Tutorial.Rank.Content",
            t"Tutorial.drug_dealer_tutorial_rank"
        ),
        Tutorial(
            n"DD.Tutorial.Terror",
            n"DD.Tutorial.Terror.Content",
            t"Tutorial.drug_dealer_tutorial_terror"
        ),
        Tutorial(
            n"DD.Tutorial.Pushers",
            n"DD.Tutorial.Pushers.Content",
            t"Tutorial.drug_dealer_tutorial_pushers"
        ),
        Tutorial(
            n"DD.Tutorial.Brothels",
            n"DD.Tutorial.Brothels.Content",
            t"Tutorial.drug_dealer_tutorial_brothels"
        ),
        Tutorial(
            n"DD.Tutorial.NightMarket",
            n"DD.Tutorial.NightMarket.Content",
            t"Tutorial.drug_dealer_tutorial_nightmarket"
        )
    ];

    // Gate tutorials behind the settings, some are forced ignoring this setting
    public func AreTutorialsEnabled() -> Bool {
        let settingsSystem = SettingsSystem.Get();
        if !IsDefined(settingsSystem) {
            return false;
        }
        return settingsSystem.enableTutorials;
    }

    public func PlayV6() {
        this.PlayTutorial(n"DD.Tutorial.V6");
    }

    public func PlayV5() {
        this.PlayTutorial(n"DD.Tutorial.V5");
    }

    public func PlayV4() {
        this.PlayTutorial(n"DD.Tutorial.V4");
    }

    public func PlayIntroduction() {
        this.PlayTutorial(n"DD.Tutorial.Introduction");
    }

    public func PlayFiend() {
        this.PlayTutorial(n"DD.Tutorial.Fiend");
    }

    public func PlayLab() {
        this.PlayTutorial(n"DD.Tutorial.Lab");
    }

    public func PlayRaid() {
        this.PlayTutorial(n"DD.Tutorial.Raid");
    }

    public func PlayRank() {
        this.PlayTutorial(n"DD.Tutorial.Rank");
    }

    public func PlayTerror() {
        this.PlayTutorial(n"DD.Tutorial.Terror");
    }

    public func PlayPushers() {
        this.PlayTutorial(n"DD.Tutorial.Pushers");
    }

    public func PlayBrothels() {
        this.PlayTutorial(n"DD.Tutorial.Brothels");
    }

    public func PlayNightMarket() {
        this.PlayTutorial(n"DD.Tutorial.NightMarket");
    }
}

// Fires the welcome tutorial popup after a delay
public class WelcomeTutorialCallback extends DelayCallback {
    public func Call() {
        let tutorialSystem = DrugDealerTutorialSystem.Get();
        if !IsDefined(tutorialSystem) {
            return;
        }

        // Play introduction (TODO this is gonna get replaced with miniquest)
        tutorialSystem.PlayIntroduction();

        // TODO miniquest, only one can play here. Play what's new
        // tutorialSystem.PlayV6();

        // Call it again in 30s loop (player could be busy, in menu, wherever), no perf impact at all 
        tutorialSystem.tutorialDelayId = GameInstance
            .GetDelaySystem(GetGameInstance())
            .DelayCallback(this, Constants.TutorialLoopInSeconds(), false);
    }
}

@wrapMethod(PlayerPuppet)
protected cb func OnGameAttached() -> Bool {
    let wrappedResult = wrappedMethod();

    let systemRequestsHandler: ref<inkISystemRequestsHandler> = GameInstance.GetSystemRequestsHandler();
    if IsDefined(systemRequestsHandler) && systemRequestsHandler.IsPreGame() {
        // Prevents firing up in MM
        return true;
    }

    let tutorialSystem = DrugDealerTutorialSystem.Get();
    if !IsDefined(tutorialSystem) {
        return wrappedResult;
    }

    // Show welcome tutorials after a short delay
    let welcomeTutorialCallback = new WelcomeTutorialCallback();
    tutorialSystem.tutorialDelayId = GameInstance
        .GetDelaySystem(this.GetGame())
        .DelayCallback(welcomeTutorialCallback, Constants.TutorialLoopInSeconds(), false);

    return wrappedResult;
}

// Nuke the ongoing tutorial loop
@wrapMethod(PlayerPuppet)
protected cb func OnDetach() -> Bool {
    let wrappedResult = wrappedMethod();

    let tutorialSystem = DrugDealerTutorialSystem.Get();
    if !IsDefined(tutorialSystem) {
        return wrappedResult;
    }

    let delaySystem = GameInstance.GetDelaySystem(GetGameInstance());
    delaySystem.CancelDelay(tutorialSystem.tutorialDelayId);

    return wrappedResult;
}

