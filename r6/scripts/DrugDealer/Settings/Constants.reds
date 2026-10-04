module DrugDealer.Settings

// -----------------------------------------------------------------------------
// Constants - Drug Dealer
// -----------------------------------------------------------------------------
public abstract class Constants {
    // ------------------------------- Mod constants that are not user configurable --------------------------------------------
    //---------------------------------- Inputs ----------------------------------
    public static func InputRegisteredActions() -> array<CName> = [n"DDInteractionActionMain", n"DDInteractionActionSecondary"];
    //---------------------------------- Tutorials ----------------------------------
    public static func TutorialLoopInSeconds() -> Float = 60.0;
    //---------------------------------- Integration ----------------------------------
    // This seconds after player is loaded into game the integration fires after 
    public static func IntegrationApplyDelayInSeconds() -> Float = 20.0;

    // Min crime rank for SS fear to have effect (counted from 0)
    public static func IntegrationStreetSenseFearMinRank() -> Float = 4.0;

    //---------------------------------- Phone ----------------------------------
    public static func PhoneTypingDelay() -> Float = 1.5;

    //---------------------------------- Jobs ----------------------------------
    // Standard job expiration 2 hours
    public static func JobExpirationInHours() -> Int32 = 2;

    // Min range for job cooldown 1 hour
    public static func JobCooldownMinInSeconds() -> Int32 = 3600;

    // Max range for job cooldown 6 hours
    public static func JobCooldownMaxInSeconds() -> Int32 = 21600;

    //---------------------------------- Vehicle spawn ----------------------------------
    public static func VehicleSpawnMinDistanceInMeters() -> Float = 50.0;

    public static func VehicleSpawnMaxDistanceInMeters() -> Float = 70.0;

    // Delay between each wave of 2 vehicles
    public static func VehicleWaveDelayInSeconds() -> Float = 5.0;

    // Delay before applying player ally attitude after spawn for player's goons
    public static func PlayerAllyAttitudeDelayInSeconds() -> Float = 3.5;

    //---------------------------------- Raids ----------------------------------
    // 8 hours for roaming raid to expire
    public static func RoamingRaidExpirationInHours() -> Int32 = 8;

    // Spawning rivals is randomizes, this is min in seconds
    public static func RoamingRaidTickMinInSeconds() -> Float = 300.0;

    // Spawning rivals is randomizes, this is max in seconds
    public static func RoamingRaidTickMaxInSeconds() -> Float = 1200.0;

    // Maximum remembered raid locations
    public static func RememberedRaidLocationCount() -> Int32 = 10;

    //---------------------------------- Stashes ----------------------------------
    // 24 hours for stash to expire
    public static func StashExpirationInHours() -> Int32 = 24;

    // Shanice polling every 5 seconds
    public static func ShanicePollingInSeconds() -> Float = 5.0;

    //---------------------------------- Labs ----------------------------------
    // Lab is disabled after ambush for 30 minutes
    public static func LabDisableDurationInSeconds() -> Int32 = 1800;

    // Default max distance for proximity detection
    public static func DefaultProximityMaxDistance() -> Float = 4.0;

    // Max products that can be cooked in one session
    public static func LabMaxProductsPerSession() -> Int32 = 100;

    // Specialized lab equipment yields this many times products
    public static func LabHighYieldMultiplier() -> Int32 = 2;

    // 5 minutes to cook a single dose
    public static func LabCookingTimePerDoseInMinutes() -> Int32 = 5;

    //---------------------------------- Big drug deals ----------------------------------
    // Minimum demanded quantity for big drug deal high society
    public static func BigDrugDealHighSocietyMinQuantity() -> Int32 = 20;

    // Maximum demanded quantity for big drug deal high society
    public static func BigDrugDealHighSocietyMaxQuantity() -> Int32 = 50;

    // 50% sales bonus when selling big volumes to high society
    public static func BigDrugDealHighSocietySalesModifier() -> Float = 0.5;

    //---------------------------------- Turf control ----------------------------------
    // Control value required for turf to be controlled
    public static func TurfControlControlledValue() -> Int32 = 70;

    // Control value required for turf to be contested
    public static func TurfControlContestedValue() -> Int32 = 20;

    // Real-time polling interval for decay checks (seconds)
    public static func TurfControlDecayTickInSeconds() -> Float = 60.0;

    // Ingame hours needed to lose 1 control point per state
    public static func TurfControlSurrenderedDecay() -> Int32 = 2;

    public static func TurfControlContestedDecay() -> Int32 = 1;

    public static func TurfControlControlledDecay() -> Int32 = 4;

    public static func TurfControlBodiesModerateGainThreshold() -> Int32 = 4;

    public static func TurfControlBodiesMajorGainThreshold() -> Int32 = 7;

    // Additive 25% modifier both ways for sales
    public static func AdditiveTurfControlSalesModifier() -> Float = 0.25;

    // Additive 50% ambush chance on surrendered turf
    public static func AdditiveTurfControlSurrenderedAmbushChanceModifier() -> Int32 = 50;

    //---------------------------------- Gated by rank ----------------------------------
    // Minimum crime rank for ambush to be allowed
    public static func AmbushMinRank() -> Int32 = 3;

    // Minimum crime rank for NCPD drug bust to be allowed
    public static func NcpdDrugBustMinRank() -> Int32 = 3;

    // Minimum crime rank for high notoriety events to be allowed
    public static func HighNotorietyMinRank() -> Int32 = 2;

    //---------------------------------- Other sales modifiers ----------------------------------
    // Additive 25% night sales bonus
    public static func AdditiveNightSalesBonus() -> Float = 0.25;

    // Additive 25% partial sales malus
    public static func AdditivePartialSalesMalus() -> Float = -0.25;

    //---------------------------------- Terror ----------------------------------
    // How long in seconds between each terror tick
    public static func TerrorUpdateInSeconds() -> Float = 2.0;

    // Terror value the terror progress bar appears for the first time
    public static func TerrorBarVisibleFrom() -> Float = 35.0;

    //---------------------------------- Street operations ----------------------------------
    // Max steet operation capacity (number of drugs)
    public static func OperationMaxCapacity() -> Int32 = 100;

    // Operations execute daily
    public static func OperationExecutionScheduleInSeconds() -> Int32 = 86400;

    // Hub menu button identifier for the operation report popup, must be unique across mods
    public static func OperationUiDataIdentifier() -> Int32 = 101;

    // How long does it take to finish a supply
    public static func OperationSupplyTimeInSeconds() -> Int32 = 600;

    // Polling interval for street operation logic 5s
    public static func OperationLogicTickInSeconds() -> Float = 5.0;

    // Min product consumed daily
    public static func OperationMinProductsConsumed() -> Int32 = 3;

    // Max product consumed daily
    public static func OperationMaxProductsConsumed() -> Int32 = 10;

    // Crime rank score for each running operation per execution run
    public static func OperationRunningCrimePointsAward() -> Int32 = 20;

    // For the turf control generation
    public static func OperationRunningRevenueMultiplier() -> Int32 = 2;

    // Brothel profit multiplier for Joytoy's kiss supply, used for estimate only
    public static func OperationBrothelEstimateRevenueMultiplier() -> Int32 = 8;

    // How many vehicles arrive compared to regular lab ambush for assassination attempt
    public static func OperationAssassinationVehicleWaveMultiplier() -> Int32 = 2;

    //---------------------------------- Lifepath bonuses ----------------------------------
    // 25% Corpo sales bonus to all sales
    public static func CorpoAdditiveSalesBonus() -> Float = 0.25;

    // Extra dose per this number of doses cooked up
    public static func NomadExtraDoseFactor() -> Int32 = 2;

    // Extra volume in crates bought from Night market
    public static func NomadNightMarketExtraVolume() -> Float = 1.25;

    // Drug count multiplied by this value when supplying pushers and brothels 
    public static func StreetKidSupplyMultiplier() -> Int32 = 2;

    //---------------------------------- Night markets ----------------------------------
    public static func NightMarketMinCrates() -> Int32 = 5;

    public static func NightMarketMaxCrates() -> Int32 = 30;

    public static func NightMarketExtraThreshold() -> Int32 = 20;

    // Polling interval for night market logic 5s
    public static func NightMarketLogicTickInSeconds() -> Float = 5.0;

    // How long the night market stays open per cycle
    public static func NightMarketActiveDurationInDays() -> Int32 = 1;

    // How long the night market stays closed between active windows
    public static func NightMarketOffDurationInDays() -> Int32 = 2;

    // Price per crate
    public static func NightMarketCratePrice() -> Float = 10000;

    // Min rank player needs for night markets to appear
    public static func NightMarketMinRank() -> Int32 = 7;
}

