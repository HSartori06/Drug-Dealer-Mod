module DrugDealer.Settings

// -----------------------------------------------------------------------------
// Enums
// -----------------------------------------------------------------------------
public enum Difficulty {
    VeryEasy = 0,
    Easy = 1,
    Normal = 2,
    Hard = 3,
    VeryHard = 4
}

public enum RankProgression {
    Normal = 0,
    Slow = 1,
    VerySlow = 2,
    Realistic = 3,
}

// -----------------------------------------------------------------------------
// Settings - Drug Dealer
// -----------------------------------------------------------------------------
@if(ModuleExists("ModSettingsModule"))
public func RegisterSettingsListener(listener: ref<IScriptable>) {
    ModSettings.RegisterListenerToClass(listener);
    ModSettings.RegisterListenerToModifications(listener);
}

@if(ModuleExists("ModSettingsModule"))
public func UnregisterSettingsListener(listener: ref<IScriptable>) {
    ModSettings.UnregisterListenerToClass(listener);
    ModSettings.UnregisterListenerToModifications(listener);
}

public final class SettingsSystem extends ScriptableSystem {
    func OnAttach() {
        RegisterSettingsListener(this);
    }

    func OnDetach() {
        UnregisterSettingsListener(this);
    }

    public static func Get() -> ref<SettingsSystem> {
        return GameInstance
            .GetScriptableSystemsContainer(GetGameInstance())
            .Get(n"DrugDealer.Settings.SettingsSystem") as SettingsSystem;
    }

    // Turf
    
    public func TurfControlMoneyModerateGainThreshold() -> Int32 = RoundF(this.revenueMultiplier * 10000.0);
    public func TurfControlMoneyMajorGainThreshold() -> Int32 = RoundF(this.revenueMultiplier * 20000.0);
    // Hoes
    public func OperationBrothelMinRevenue() -> Int32 = RoundF(this.revenueMultiplier * 1000.0);
    public func OperationBrothelMaxRevenue() -> Int32 = RoundF(this.revenueMultiplier * 5000.0);

    // ### Difficulty affected settings ###

    // Maximum active roaming raids
    public func RoamingRaidMaxActive() -> Int32 {
        switch this.difficulty {
            case Difficulty.VeryEasy:
                return 2;
            case Difficulty.Easy:
                return 2;
            case Difficulty.Normal:
                return 2;
            case Difficulty.Hard:
                return 3;
            case Difficulty.VeryHard:
                return 4;
        }
        return 2;
    };  

    // How much turf control is gained per volume sold/money earned
    public func TurfControlSingleGainPerMoney() -> Int32 {
        let value = 1000.0;
        switch this.difficulty {
            case Difficulty.VeryEasy:
                value = 500.0;
                break;
            case Difficulty.Easy:
                value = 750.0;
                break;
            case Difficulty.Normal:
                value = 1000.0;
                break;
            case Difficulty.Hard:
                value = 2000.0;
                break;
            case Difficulty.VeryHard:
                value = 3000.0;
                break;
        }
        return RoundF(this.revenueMultiplier * value);
    };

    // This much control is gained per dropped body
    public func TurfControlGainPerBody() -> Int32 {
        switch this.difficulty {
            case Difficulty.VeryEasy:
                return 4;
            case Difficulty.Easy:
                return 3;
            case Difficulty.Normal:
                return 3;
            case Difficulty.Hard:
                return 2;
            case Difficulty.VeryHard:
                return 1;
        }
        return 3;
    };

    // How much terror players gains for dropping a body
    public func TerrorValuePerKill() -> Float {
        switch this.difficulty {
            case Difficulty.VeryEasy:
                return 6.0;
            case Difficulty.Easy:
                return 6.0;
            case Difficulty.Normal:
                return 5.0;
            case Difficulty.Hard:
                return 3.0;
            case Difficulty.VeryHard:
                return 2.0;
        }
        return 5.0;
    }; 

    // How much terror players gains for exploding a vehicle
    public func TerrorValuePerVehicleExplosion() -> Float {
        switch this.difficulty {
            case Difficulty.VeryEasy:
                return 10.0;
            case Difficulty.Easy:
                return 9.0;
            case Difficulty.Normal:
                return 8.0;
            case Difficulty.Hard:
                return 6.0;
            case Difficulty.VeryHard:
                return 4.0;
        }
        return 8.0;
    }; 

    // This much control is gained per terror
    public func TurfControlGainPerTerror() -> Int32 {
        switch this.difficulty {
            case Difficulty.VeryEasy:
                return 60;
            case Difficulty.Easy:
                return 55;
            case Difficulty.Normal:
                return 50;
            case Difficulty.Hard:
                return 45;
            case Difficulty.VeryHard:
                return 40;
        }
        return 50;
    };

    // Time before a new stash becomes available, scales with difficulty
    public func StashAvailableInSeconds() -> Int32 {
        switch this.difficulty {
            case Difficulty.VeryEasy:
                return 86400 * 2;
            case Difficulty.Easy:
                return 86400 * 3;
            case Difficulty.Normal:
                return 86400 * 4;
            case Difficulty.Hard:
                return 86400 * 5;
            case Difficulty.VeryHard:
                return 86400 * 6;
        }
        return 86400 * 4;
    };

    // Operation cuts
    public func OperationProfitCut() -> Float {
        switch this.difficulty {
            case Difficulty.VeryEasy:
                return 0.01;
            case Difficulty.Easy:
                return 0.05;
            case Difficulty.Normal:
                return 0.1;
            case Difficulty.Hard:
                return 0.2;
            case Difficulty.VeryHard:
                return 0.3;
        }
        return 0.1;
    };

    public func NightMarketCratePrice() -> Int32 = Cast<Int32>(Constants.NightMarketCratePrice() * this.revenueMultiplier);

    // Difficulty
    @runtimeProperty("ModSettings.mod", "DD.Settings.System.Name")
    @runtimeProperty("ModSettings.category", "DD.Settings.DrugDealer")
    @runtimeProperty("ModSettings.category.order", "0")
    @runtimeProperty("ModSettings.displayName", "DD.Settings.DrugDealer.Difficulty")
    @runtimeProperty("ModSettings.description", "DD.Settings.DrugDealer.Difficulty.Description")
    @runtimeProperty("ModSettings.displayValues.VeryEasy", "DD.Settings.Difficulty.VeryEasy")
    @runtimeProperty("ModSettings.displayValues.Easy", "DD.Settings.Difficulty.Easy")
    @runtimeProperty("ModSettings.displayValues.Normal", "DD.Settings.Difficulty.Normal")
    @runtimeProperty("ModSettings.displayValues.Hard", "DD.Settings.Difficulty.Hard")
    @runtimeProperty("ModSettings.displayValues.VeryHard", "DD.Settings.Difficulty.VeryHard")
    public let difficulty: Difficulty = Difficulty.Normal;

    // Rank progression speed
    @runtimeProperty("ModSettings.mod", "DD.Settings.System.Name")
    @runtimeProperty("ModSettings.category", "DD.Settings.DrugDealer")
    @runtimeProperty("ModSettings.category.order", "0")
    @runtimeProperty("ModSettings.displayName", "DD.Settings.DrugDealer.RankProgression")
    @runtimeProperty("ModSettings.description", "DD.Settings.DrugDealer.RankProgression.Description")
    @runtimeProperty("ModSettings.displayValues.Normal", "DD.Settings.RankProgression.Normal")
    @runtimeProperty("ModSettings.displayValues.Slow", "DD.Settings.RankProgression.Slow")
    @runtimeProperty("ModSettings.displayValues.VerySlow", "DD.Settings.RankProgression.VerySlow")
    @runtimeProperty("ModSettings.displayValues.Realistic", "DD.Settings.RankProgression.Realistic")
    public let rankProgression: RankProgression = RankProgression.Normal;

    // Revenue multiplier
    @runtimeProperty("ModSettings.mod", "DD.Settings.System.Name")
    @runtimeProperty("ModSettings.category", "DD.Settings.DrugDealer")
    @runtimeProperty("ModSettings.category.order", "0")
    @runtimeProperty("ModSettings.displayName", "DD.Settings.DrugDealer.RevenueMultiplier")
    @runtimeProperty("ModSettings.description", "DD.Settings.DrugDealer.RevenueMultiplier.Description")
    @runtimeProperty("ModSettings.step", "0.1")
    @runtimeProperty("ModSettings.min", "0.1")
    @runtimeProperty("ModSettings.max", "20.0")
    public let revenueMultiplier: Float = 1.0;

    // Shanice's shash tips
    @runtimeProperty("ModSettings.mod", "DD.Settings.System.Name")
    @runtimeProperty("ModSettings.category", "DD.Settings.DrugDealer")
    @runtimeProperty("ModSettings.category.order", "0")
    @runtimeProperty("ModSettings.displayName", "DD.Settings.DrugDealer.StashTips")
    @runtimeProperty("ModSettings.description", "DD.Settings.DrugDealer.StashTips.Description")
    public let stashTipsEnabled: Bool = true;

    // Shanice's financial report
    @runtimeProperty("ModSettings.mod", "DD.Settings.System.Name")
    @runtimeProperty("ModSettings.category", "DD.Settings.DrugDealer")
    @runtimeProperty("ModSettings.category.order", "0")
    @runtimeProperty("ModSettings.displayName", "DD.Settings.DrugDealer.FinancialReport")
    @runtimeProperty("ModSettings.description", "DD.Settings.DrugDealer.FinancialReport.Description")
    public let financialReportEnabled: Bool = true;

    // Terror
    @runtimeProperty("ModSettings.mod", "DD.Settings.System.Name")
    @runtimeProperty("ModSettings.category", "DD.Settings.DrugDealer")
    @runtimeProperty("ModSettings.category.order", "0")
    @runtimeProperty("ModSettings.displayName", "DD.Settings.DrugDealer.Terror")
    @runtimeProperty("ModSettings.description", "DD.Settings.DrugDealer.Terror.Description")
    public let terrorEnabled: Bool = true;

    // Reserve Joytoy's kiss for brothels
    @runtimeProperty("ModSettings.mod", "DD.Settings.System.Name")
    @runtimeProperty("ModSettings.category", "DD.Settings.DrugDealer")
    @runtimeProperty("ModSettings.category.order", "0")
    @runtimeProperty("ModSettings.displayName", "DD.Settings.DrugDealer.ReserveJoytoysKissForBrothel")
    @runtimeProperty("ModSettings.description", "DD.Settings.DrugDealer.ReserveJoytoysKissForBrothel.Description")
    public let reserveJoytoysKissForBrothel: Bool = false;

    // Prioritize matching equipment cooking
    @runtimeProperty("ModSettings.mod", "DD.Settings.System.Name")
    @runtimeProperty("ModSettings.category", "DD.Settings.DrugDealer")
    @runtimeProperty("ModSettings.category.order", "0")
    @runtimeProperty("ModSettings.displayName", "DD.Settings.DrugDealer.MatchingEquipmentCooking")
    @runtimeProperty("ModSettings.description", "DD.Settings.DrugDealer.MatchingEquipmentCooking.Description")
    public let matchingEquipmentCookingEnabled: Bool = false;

    // Distribution crackhouses
    @runtimeProperty("ModSettings.mod", "DD.Settings.System.Name")
    @runtimeProperty("ModSettings.category", "DD.Settings.Distribution")
    @runtimeProperty("ModSettings.category.order", "5")
    @runtimeProperty("ModSettings.displayName", "DD.Settings.Miscellaneous.DistributionCrackhousePercent")
    @runtimeProperty("ModSettings.description", "DD.Settings.Miscellaneous.DistributionCrackhousePercent.Description")
    @runtimeProperty("ModSettings.dependency", "enableEnhancedNavigation")
    @runtimeProperty("ModSettings.step", "5.0")
    @runtimeProperty("ModSettings.min", "10.0")
    @runtimeProperty("ModSettings.max", "95.0")
    public let distributionCrackhousePercent: Float = 25.0;

    // Distribution street operations
    @runtimeProperty("ModSettings.mod", "DD.Settings.System.Name")
    @runtimeProperty("ModSettings.category", "DD.Settings.Distribution")
    @runtimeProperty("ModSettings.category.order", "5")
    @runtimeProperty("ModSettings.displayName", "DD.Settings.Miscellaneous.DistributionStreetOperationPercent")
    @runtimeProperty("ModSettings.description", "DD.Settings.Miscellaneous.DistributionStreetOperationPercent.Description")
    @runtimeProperty("ModSettings.dependency", "enableEnhancedNavigation")
    @runtimeProperty("ModSettings.step", "5.0")
    @runtimeProperty("ModSettings.min", "10.0")
    @runtimeProperty("ModSettings.max", "95.0")
    public let distributionStreetOperationPercent: Float = 25.0;       

    // Enable tutorials
    @runtimeProperty("ModSettings.mod", "DD.Settings.System.Name")
    @runtimeProperty("ModSettings.category", "DD.Settings.Miscellaneous")
    @runtimeProperty("ModSettings.category.order", "10")
    @runtimeProperty("ModSettings.displayName", "DD.Settings.Miscellaneous.EnableTutorials")
    @runtimeProperty("ModSettings.description", "DD.Settings.Miscellaneous.EnableTutorials.Description")
    public let enableTutorials: Bool = true;

    // Enable enhanced navigation
    @runtimeProperty("ModSettings.mod", "DD.Settings.System.Name")
    @runtimeProperty("ModSettings.category", "DD.Settings.Miscellaneous")
    @runtimeProperty("ModSettings.category.order", "10")
    @runtimeProperty("ModSettings.displayName", "DD.Settings.Miscellaneous.EnableEnhancedNavigation")
    @runtimeProperty("ModSettings.description", "DD.Settings.Miscellaneous.EnableEnhancedNavigation.Description")
    public let enableEnhancedNavigation: Bool = true;

    // Enhanced navigation map open delay
    @runtimeProperty("ModSettings.mod", "DD.Settings.System.Name")
    @runtimeProperty("ModSettings.category", "DD.Settings.Miscellaneous")
    @runtimeProperty("ModSettings.category.order", "10")
    @runtimeProperty("ModSettings.displayName", "DD.Settings.Miscellaneous.EnhancedNavigationMapAutoOpenDelay")
    @runtimeProperty("ModSettings.description", "DD.Settings.Miscellaneous.EnhancedNavigationMapAutoOpenDelay.Description")
    @runtimeProperty("ModSettings.dependency", "enableEnhancedNavigation")
    @runtimeProperty("ModSettings.step", "0.5")
    @runtimeProperty("ModSettings.min", "3.0")
    @runtimeProperty("ModSettings.max", "8.0")
    public let enhancedNavigationMapAutoOpenDelay: Float = 4.0;    

    // Enable V's comments
    @runtimeProperty("ModSettings.mod", "DD.Settings.System.Name")
    @runtimeProperty("ModSettings.category", "DD.Settings.Miscellaneous")
    @runtimeProperty("ModSettings.category.order", "10")
    @runtimeProperty("ModSettings.displayName", "DD.Settings.Miscellaneous.EnableVComments")
    @runtimeProperty("ModSettings.description", "DD.Settings.Miscellaneous.EnableVComments.Description")
    public let enableVComments: Bool = true;

    // Enable immersive mode
    @runtimeProperty("ModSettings.mod", "DD.Settings.System.Name")
    @runtimeProperty("ModSettings.category", "DD.Settings.Miscellaneous")
    @runtimeProperty("ModSettings.category.order", "10")
    @runtimeProperty("ModSettings.displayName", "DD.Settings.Miscellaneous.EnableImmersiveMode")
    @runtimeProperty("ModSettings.description", "DD.Settings.Miscellaneous.EnableImmersiveMode.Description")
    public let enableImmersiveMode: Bool = false;

    // Pin Yukmouth to the top of the contact list
    @runtimeProperty("ModSettings.mod", "DD.Settings.System.Name")
    @runtimeProperty("ModSettings.category", "DD.Settings.Miscellaneous")
    @runtimeProperty("ModSettings.category.order", "10")
    @runtimeProperty("ModSettings.displayName", "DD.Settings.Miscellaneous.YukmouthPinned")
    @runtimeProperty("ModSettings.description", "DD.Settings.Miscellaneous.YukmouthPinned.Description")
    public let yukmouthPinned: Bool = false;

    // Street operations button y offset
    @runtimeProperty("ModSettings.mod", "DD.Settings.System.Name")
    @runtimeProperty("ModSettings.category", "DD.Settings.Miscellaneous")
    @runtimeProperty("ModSettings.category.order", "10")
    @runtimeProperty("ModSettings.displayName", "DD.Settings.Miscellaneous.OperationUiYOffset")
    @runtimeProperty("ModSettings.description", "DD.Settings.Miscellaneous.OperationUiYOffset.Description")
    @runtimeProperty("ModSettings.step", "1")
    @runtimeProperty("ModSettings.min", "-510")
    @runtimeProperty("ModSettings.max", "680")
    public let operationUiYOffset: Float = 0.0;

    // Enable dev mode (keep this commented out)
    // @runtimeProperty("ModSettings.mod", "DD.Settings.System.Name")
    // @runtimeProperty("ModSettings.category", "DD.Settings.Miscellaneous")
    // @runtimeProperty("ModSettings.category.order", "10")
    // @runtimeProperty("ModSettings.displayName", "DD.Settings.Miscellaneous.EnableDevMode")
    // @runtimeProperty("ModSettings.description", "DD.Settings.Miscellaneous.EnableDevMode.Description")
    public let enableDevMode: Bool = false;

    // Street Sense - Enable fear effect based on crime rank
    @runtimeProperty("ModSettings.mod", "DD.Settings.System.Name")
    @runtimeProperty("ModSettings.category", "DD.Settings.StreetSense")
    @runtimeProperty("ModSettings.category.order", "20")
    @runtimeProperty("ModSettings.displayName", "DD.Settings.StreetSense.EnableFear")
    @runtimeProperty("ModSettings.description", "DD.Settings.StreetSense.EnableFear.Description")
    public let enableStreetSenseFear: Bool = true;

    // Thin Blue Line - Enable known target based on crime rank
    @runtimeProperty("ModSettings.mod", "DD.Settings.System.Name")
    @runtimeProperty("ModSettings.category", "DD.Settings.ThinBlueLine")
    @runtimeProperty("ModSettings.category.order", "30")
    @runtimeProperty("ModSettings.displayName", "DD.Settings.ThinBlueLine.EnableKnownTarget")
    @runtimeProperty("ModSettings.description", "DD.Settings.ThinBlueLine.EnableKnownTarget.Description")
    public let enableThinBlueLineKnownTarget: Bool = true;

    // Flesh & Chrome - Stamina loss from cooking
    @runtimeProperty("ModSettings.mod", "DD.Settings.System.Name")
    @runtimeProperty("ModSettings.category", "DD.Settings.FleshAndChrome")
    @runtimeProperty("ModSettings.category.order", "40")
    @runtimeProperty("ModSettings.displayName", "DD.Settings.FleshAndChrome.CookingStaminaLoss")
    @runtimeProperty("ModSettings.description", "DD.Settings.FleshAndChrome.CookingStaminaLoss.Description")
    @runtimeProperty("ModSettings.step", "50")
    @runtimeProperty("ModSettings.min", "0")
    @runtimeProperty("ModSettings.max", "2000")
    public let cookingStaminaLoss: Float = 200.0;

    // Flesh & Chrome - Maximum stamina loss per cooking session
    @runtimeProperty("ModSettings.mod", "DD.Settings.System.Name")
    @runtimeProperty("ModSettings.category", "DD.Settings.FleshAndChrome")
    @runtimeProperty("ModSettings.category.order", "40")
    @runtimeProperty("ModSettings.displayName", "DD.Settings.FleshAndChrome.CookingStaminaLossMaximum")
    @runtimeProperty("ModSettings.description", "DD.Settings.FleshAndChrome.CookingStaminaLossMaximum.Description")
    @runtimeProperty("ModSettings.step", "100")
    @runtimeProperty("ModSettings.min", "1000")
    @runtimeProperty("ModSettings.max", "20000")
    public let cookingStaminaLossMaximum: Float = 2500.0;

    // Dark Future - Nerve loss from cooking by product
    @runtimeProperty("ModSettings.mod", "DD.Settings.System.Name")
    @runtimeProperty("ModSettings.category", "DD.Settings.DarkFuture")
    @runtimeProperty("ModSettings.category.order", "50")
    @runtimeProperty("ModSettings.displayName", "DD.Settings.DarkFuture.CookingNerveLoss")
    @runtimeProperty("ModSettings.description", "DD.Settings.DarkFuture.CookingNerveLoss.Description")
    @runtimeProperty("ModSettings.step", "1")
    @runtimeProperty("ModSettings.min", "0")
    @runtimeProperty("ModSettings.max", "10")
    public let cookingNerveLoss: Float = 1.0;

    // Dark Future - Maximum Nerve loss per cooking session
    @runtimeProperty("ModSettings.mod", "DD.Settings.System.Name")
    @runtimeProperty("ModSettings.category", "DD.Settings.DarkFuture")
    @runtimeProperty("ModSettings.category.order", "50")
    @runtimeProperty("ModSettings.displayName", "DD.Settings.DarkFuture.CookingNerveLossMaximum")
    @runtimeProperty("ModSettings.description", "DD.Settings.DarkFuture.CookingNerveLossMaximum.Description")
    @runtimeProperty("ModSettings.step", "1")
    @runtimeProperty("ModSettings.min", "10")
    @runtimeProperty("ModSettings.max", "100")
    public let cookingNerveLossMaximum: Float = 25.0;
}

