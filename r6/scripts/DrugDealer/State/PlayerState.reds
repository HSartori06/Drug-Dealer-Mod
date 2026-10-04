module DrugDealer.State

import NightlyNow.Utils.IsPlayerInBadlands
import DrugDealer.Settings.{SettingsSystem, RankProgression, Constants}

// -----------------------------------------------------------------------------
// State - DrugDealer
// -----------------------------------------------------------------------------
public enum DrugDealerRank {
    SmallTimePusher = 0,
    CornerBoy = 1,
    Slinger = 2,
    StreetDealer = 3,
    ShotCaller = 4,
    Lieutenant = 5,
    Supplier = 6,
    Underboss = 7,
    DrugLord = 8,
    Kingpin = 9,
    DrugSaint = 10,
    DrugGod = 11,
}

public class PlayerStateSystem extends ScriptableSystem {
    // Persistent vars
    // Always use GetRank() to read rank to be compliant with dev mode
    private persistent let rank: DrugDealerRank = DrugDealerRank.SmallTimePusher;
    private persistent let score: Int32;
    private persistent let raidsCompleted: Int32;
    private persistent let fiendsServed: Int32;
    private persistent let researchesCompleted: Int32;
    private persistent let crackhouseSales: Int32;
    private persistent let recentRaidLocations: array<Vector4>;

    public static func Get() -> ref<PlayerStateSystem> {
        return GameInstance
            .GetScriptableSystemsContainer(GetGameInstance())
            .Get(n"DrugDealer.State.PlayerStateSystem") as PlayerStateSystem;
    }

    public func IsAmbushAllowed() -> Bool = EnumInt(this.GetRank()) >= Constants.AmbushMinRank();

    public func IsNcpdDrugBustAllowed() -> Bool = EnumInt(this.GetRank()) >= Constants.NcpdDrugBustMinRank();

    public func IsHighNotorietyEventsAllowed() -> Bool = EnumInt(this.GetRank()) >= Constants.HighNotorietyMinRank();

    // Award points for completing a raid
    public func ScoreRaid() {
        this.raidsCompleted += 1;
        this.score += 10;
        this.UpdateRank();
    }

    // Award points for completing a planned raid, difficult variant
    public func ScorePlannedRaid() {
        this.raidsCompleted += 1;
        this.score += 100;
        this.UpdateRank();
    }

    // Award points for completing a drug deal
    public func ScoreDrugDeal() {
        this.fiendsServed += 1;
        this.score += 20;
        this.UpdateRank();
    }

    // Award less points for completing a drug deal when only partial demand is met
    public func ScorePartialDrugDeal() {
        this.fiendsServed += 1;
        this.score += 5;
        this.UpdateRank();
    }

    public func ScoreResearch(scoreMultiplier: Int32) {
        this.researchesCompleted += 1;
        this.score += 10 * scoreMultiplier;
        this.UpdateRank();
    }

    // Award points for batch selling to crackhouse
    public func ScoreSellingToCrackhouse(quantity: Int32) {
        this.crackhouseSales += 1;
        this.score += quantity;
        this.UpdateRank();
    }

    // Award points custom amount
    public func AwardScore(score: Int32) {
        this.score += score;
        this.UpdateRank();
    }

    public func GetRank() -> DrugDealerRank {
        let settings = SettingsSystem.Get();
        if !IsDefined(settings) {
            return this.rank;
        }
        if settings.enableDevMode {
            // Return max rank for dev mode
            return DrugDealerRank.DrugGod;
        }
        return this.rank;
    }

    // Notoriety in percent (used for combat check), scales with rank 
    public func RollNotoriety() -> Int32 = EnumInt(this.GetRank()) * 10 + 5;

    // Notoriety in percent for higher impact events like raid reinforcements
    public func RollHighNotoriety() -> Int32 {
        if !this.IsHighNotorietyEventsAllowed() {
            // Low ranks are protected
            return 0;
        }

        let rank = EnumInt(this.GetRank());
        return rank * 5 + 5;
    }

    // Notoriety in percent for ambushes
    public func RollAmbushNotoriety() -> Int32 = EnumInt(this.GetRank()) + 5;

    // Street operations assassination risk chance
    public func RollAssassinationRisk(enemyTurfCount: Int32) -> Int32 = EnumInt(this.GetRank()) / 2 + enemyTurfCount;

    public func RollNcpdNotoriety() -> Int32 {
        if !this.IsNcpdDrugBustAllowed() {
            // Low ranks are protected
            return 0;
        }

        if IsPlayerInBadlands() {
            // No NCPD presence in the Badlands
            return 0;
        }

        return EnumInt(this.GetRank());
    }

    public func GetNcpdHeat() -> Int32 {
        let rank = EnumInt(this.GetRank());
        if rank >= 9 {
            return 5;
        }
        if rank >= 7 {
            return 4;
        }
        if rank >= 3 {
            return 3;
        }
        return 2;
    }

    // Vehicle wave assault count based on rank
    public func RollVehicleWaveSpawnCount() -> Int32 {
        let rank = EnumInt(this.GetRank());
        if rank >= 9 {
            // Up to 5 vehicles to hunt down the most notorious crime figure in NC
            return RandRange(3, 6);
        }
        if rank >= 7 {
            return RandRange(2, 5);
        }
        if rank >= 5 {
            return RandRange(2, 4);
        }
        if rank >= 3 {
            return RandRange(1, 3);
        }
        return 1;
    }

    // Get immersive player's drug dealer description
    public func GetRankDescription() -> String {
        switch this.GetRank() {
            case DrugDealerRank.SmallTimePusher:
                return GetLocalizedTextByKey(n"DD.Rank.SmallTimePusher");
            case DrugDealerRank.CornerBoy:
                return GetLocalizedTextByKey(n"DD.Rank.CornerBoy");
            case DrugDealerRank.Slinger:
                return GetLocalizedTextByKey(n"DD.Rank.Slinger");
            case DrugDealerRank.StreetDealer:
                return GetLocalizedTextByKey(n"DD.Rank.StreetDealer");
            case DrugDealerRank.ShotCaller:
                return GetLocalizedTextByKey(n"DD.Rank.ShotCaller");
            case DrugDealerRank.Lieutenant:
                return GetLocalizedTextByKey(n"DD.Rank.Lieutenant");
            case DrugDealerRank.Supplier:
                return GetLocalizedTextByKey(n"DD.Rank.Supplier");
            case DrugDealerRank.Underboss:
                return GetLocalizedTextByKey(n"DD.Rank.Underboss");
            case DrugDealerRank.DrugLord:
                return GetLocalizedTextByKey(n"DD.Rank.DrugLord");
            case DrugDealerRank.Kingpin:
                return GetLocalizedTextByKey(n"DD.Rank.Kingpin");
            case DrugDealerRank.DrugSaint:
                return GetLocalizedTextByKey(n"DD.Rank.DrugSaint");
            case DrugDealerRank.DrugGod:
                return GetLocalizedTextByKey(n"DD.Rank.DrugGod");
            default:
                return "";
        }
    }

    // Get short rank desc, used by Informative Healthbar by Scream81
    public func GetShortRankDescription() -> String {
        switch this.GetRank() {
            case DrugDealerRank.SmallTimePusher:
                return GetLocalizedTextByKey(n"DD.Rank.Short.SmallTimePusher");
            case DrugDealerRank.CornerBoy:
                return GetLocalizedTextByKey(n"DD.Rank.Short.CornerBoy");
            case DrugDealerRank.Slinger:
                return GetLocalizedTextByKey(n"DD.Rank.Short.Slinger");
            case DrugDealerRank.StreetDealer:
                return GetLocalizedTextByKey(n"DD.Rank.Short.StreetDealer");
            case DrugDealerRank.ShotCaller:
                return GetLocalizedTextByKey(n"DD.Rank.Short.ShotCaller");
            case DrugDealerRank.Lieutenant:
                return GetLocalizedTextByKey(n"DD.Rank.Short.Lieutenant");
            case DrugDealerRank.Supplier:
                return GetLocalizedTextByKey(n"DD.Rank.Short.Supplier");
            case DrugDealerRank.Underboss:
                return GetLocalizedTextByKey(n"DD.Rank.Short.Underboss");
            case DrugDealerRank.DrugLord:
                return GetLocalizedTextByKey(n"DD.Rank.Short.DrugLord");
            case DrugDealerRank.Kingpin:
                return GetLocalizedTextByKey(n"DD.Rank.Short.Kingpin");
            case DrugDealerRank.DrugSaint:
                return GetLocalizedTextByKey(n"DD.Rank.Short.DrugSaint");
            case DrugDealerRank.DrugGod:
                return GetLocalizedTextByKey(n"DD.Rank.Short.DrugGod");
            default:
                return "";
        }
    }

    // Number of turfs player can control by rank
    public func MaxControlledTurfs() -> Int32 {
        let rank = EnumInt(this.GetRank());
        if rank >= 11 {
            // Drug god unlimited control
            return 99;
        }
        if rank >= 10 {
            // Drug saint 6 turfs
            return 6;
        }
        if rank >= 9 {
            // Kingpin 5 turfs
            return 5;
        }
        if rank >= 7 {
            return 4;
        }
        if rank >= 6 {
            return 3;
        }
        if rank >= 5 {
            return 2;
        }
        if rank >= 3 {
            return 1;
        }
        return 0;
    }

    public func IsRecentRaidLocation(location: Vector4) -> Bool {
        for recent in this.recentRaidLocations {
            if recent.X == location.X && recent.Y == location.Y && recent.Z == location.Z {
                return true;
            }
        }
        return false;
    }

    public func RememberRaidLocation(location: Vector4) {
        ArrayPush(this.recentRaidLocations, location);
        while ArraySize(this.recentRaidLocations) > Constants.RememberedRaidLocationCount() {
            ArrayErase(this.recentRaidLocations, 0);
        }
    }

    // Set rank based on score thresholds scaled by rank progression setting
    private func UpdateRank() {
        // Normal starts at 0 so we need to offset that (Redscript doesn't allow for enum constants to start at anything else)
        let settings = SettingsSystem.Get();
        if !IsDefined(settings) {
            return;
        }
        let rankProgressMultiplier = EnumInt(settings.rankProgression) + 1;

        let thresholds = [0, 50, 200, 400, 800, 1600, 3200, 6400, 12800, 25600, 51200, 102400];
        let i = ArraySize(thresholds) - 1;
        while i > 0 && this.score < thresholds[i] * rankProgressMultiplier {
            i -= 1;
        }
        this.rank = IntEnum<DrugDealerRank>(i);
    }
}

