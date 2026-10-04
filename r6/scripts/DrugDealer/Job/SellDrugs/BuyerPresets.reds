module DrugDealer.Job.SellDrugs

// -----------------------------------------------------------------------------
// BuyerPresets - Drug Dealer
// -----------------------------------------------------------------------------
public abstract class BuyerPresets {
    public static func WatsonPresets() -> array<array<TweakDBID>> = [
        [t"Character.HomelessManBackpack"],
        [t"Character.HomelessMan"],
        [t"Character.HomelessFemale"],
        [t"Character.HoodHottie"],
        [t"Character.HobotownHomelessMan"],
        [t"Character.HobotownHomelessWoman"],
        [t"Character.JunkieFemale"],
        [t"Character.JunkieFemaleDE"],
        [t"Character.JunkieMale"],
        [t"Character.JunkieMaleDE"],
        [t"Character.ChildPoorDE"],
        [t"Character.WomanChubbyCarribean"],
        [t"Character.WomanChubbyYoungster"],
        [t"Character.WomanChubbyTenant"],
        [t"Character.LowlifeWoman"],
        [t"Character.LowlifeWomanDE"],
        [t"Character.LowlifeWomanDEfriendly"],
        [t"Character.LowlifeWomanDriver"],
        [t"Character.LowlifeWomanNoTalk"],
        [t"Character.LowlifeWomanRedneck"],
        [t"Character.LowlifeWomanRedneckDE"],
        [t"Character.LowlifeWomanRedneckDriver"],
        [t"Character.LowlifeMale"],
        [t"Character.LowlifeMaleBig"],
        [t"Character.LowlifeMaleDE"],
        [t"Character.LowlifeMaleDEfriendly"],
        [t"Character.LowlifeMaleDriver"],
        [t"Character.LowlifeMaleRedneck"],
        [t"Character.LowlifeMaleRedneckDriver"]
    ];

    public static func SantoDomingoPresets() -> array<array<TweakDBID>> = [
        [t"Character.HomelessManBackpack"],
        [t"Character.HomelessMan"],
        [t"Character.HomelessFemale"],
        [t"Character.HoodHottie"],
        [t"Character.HobotownHomelessMan"],
        [t"Character.HobotownHomelessWoman"],
        [t"Character.ObeseMaleLowlife"],
        [t"Character.JunkieFemale"],
        [t"Character.JunkieFemaleDE"],
        [t"Character.JunkieMale"],
        [t"Character.JunkieMaleDE"],
        [t"Character.ChildPoor"],
        [t"Character.WomanChubbyCarribean"],
        [t"Character.WomanChubbyYoungster"],
        [t"Character.WomanChubbyTenant"],
        [t"Character.LowlifeWoman"],
        [t"Character.LowlifeWomanDE"],
        [t"Character.LowlifeWomanDEfriendly"],
        [t"Character.LowlifeWomanDriver"],
        [t"Character.LowlifeWomanNoTalk"],
        [t"Character.LowlifeWomanRedneck"],
        [t"Character.LowlifeWomanRedneckDE"],
        [t"Character.LowlifeWomanRedneckDriver"],
        [t"Character.LowlifeMale"],
        [t"Character.LowlifeMaleBig"],
        [t"Character.LowlifeMaleDE"],
        [t"Character.LowlifeMaleDEfriendly"],
        [t"Character.LowlifeMaleDriver"],
        [t"Character.LowlifeMaleRedneck"],
        [t"Character.LowlifeMaleRedneckDriver"]
    ];

    public static func BadlandsPresets() -> array<array<TweakDBID>> = [
        [t"Character.CitizenBikerMale"],
        [t"Character.CitizenBikerFemale"],
        [t"Character.CitizenAldecaldosFemale"],
        [t"Character.CitizenAldecaldosFemaleDE"],
        [t"Character.CitizenAldecaldosFemaleTeenager"],
        [t"Character.CitizenAldecaldosMale"],
        [t"Character.CitizenAldecaldosMaleBig"],
        [t"Character.CitizenAldecaldosMaleDE"],
        [t"Character.CitizenAldecaldosMaleFarmer"],
        [t"Character.CitizenAldecaldosMaleMechanic"],
        [t"Character.CitizenAldecaldosMaleTeenager"],
        [t"Character.CitizenAldecaldosMaleNomad"]
    ];

    public static func WestbrookPresets() -> array<array<TweakDBID>> = [
        [t"Character.NightlifeMale"],
        [t"Character.NightlifeMaleBig"],
        [t"Character.NightlifeMaleDriver"],
        [t"Character.NightlifeWoman"],
        [t"Character.NonBinaryFemaleBodyNightlife"],
        [t"Character.NonBinaryMaleBodyNightlife"],
        [t"Character.ObeseMaleNightlife"],
        [t"Character.YoungsterMale"],
        [t"Character.YoungsterMaleBig"],
        [t"Character.YoungsterMaleDE"],
        [t"Character.Mallrat"],
        [t"Character.YoungsterFemale"],
        [t"Character.YoungsterFemaleDE"],
        [t"Character.StoopKing"],
        [t"Character.StoopKingBig"],
        [t"Character.StoopQueen"],
        [t"Character.CitizenRichFemale"],
        [t"Character.CitizenRichFemaleCasual"],
        [t"Character.CitizenRichMale"],
        [t"Character.CitizenRichMaleCasual"],
        [t"Character.CitizenRichMaleDE"],
        [t"Character.NonBinaryMaleBodyPosh"],
        [t"Character.NonBinaryFemaleBodyPosh"]
    ];

    public static func HeywoodPresets() -> array<array<TweakDBID>> = [
        [t"Character.NightlifeWoman"],
        [t"Character.NightlifeMale"],
        [t"Character.NightlifeMaleBig"],
        [t"Character.NightlifeMaleDriver"],
        [t"Character.ProstituteFemale"],
        [t"Character.ProstituteFemaleDE"],
        [t"Character.LowlifeMale"],
        [t"Character.LowlifeMaleDE"],
        [t"Character.LowlifeWoman"],
        [t"Character.LowlifeWomanDE"]
    ];

    public static func WestbrookHighSocietyPresets() -> array<array<TweakDBID>> = [
        [t"Character.bodyguard"],
        [t"Character.q005_hotel_bodyguard"],
        [t"Character.q306_interview_manager"]
    ];

    public static func PacificaPresets() -> array<array<TweakDBID>> = [
        [t"Character.CreoleWoman"],
        [t"Character.CreoleMan"],
        [t"Character.CreoleManBig"],
        [t"Character.LowlifeMale"],
        [t"Character.FreakMale"],
        [t"Character.FreakFemale"],
        [t"Character.NightlifeWoman"],
        [t"Character.NightlifeMale"],
        [t"Character.NightlifeMaleBig"],
        [t"Character.CitizenRichMaleDE"]
    ];

    public static func GetBuyerPreset(location: BuyerLocation) -> array<TweakDBID> {
        let presets: array<array<TweakDBID>>;
        switch location {
            case BuyerLocation.SantoDomingo:
                presets = BuyerPresets.SantoDomingoPresets();
                break;
            case BuyerLocation.Badlands:
                presets = BuyerPresets.BadlandsPresets();
                break;
            case BuyerLocation.Westbrook:
                presets = BuyerPresets.WestbrookPresets();
                break;
            case BuyerLocation.WestbrookHighSociety:
                presets = BuyerPresets.WestbrookHighSocietyPresets();
                break;
            case BuyerLocation.Heywood:
                presets = BuyerPresets.HeywoodPresets();
                break;
            case BuyerLocation.Pacifica:
                presets = BuyerPresets.PacificaPresets();
                break;
            default:
                presets = BuyerPresets.WatsonPresets();
                break;
        }
        let idx = RandRange(0, ArraySize(presets));
        return presets[idx];
    }
}

