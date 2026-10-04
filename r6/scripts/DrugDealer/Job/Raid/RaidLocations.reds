module DrugDealer.Job.Raid

import NightlyNow.Utils.LocationWithOrientation
import DrugDealer.State.{TurfLocation, PlayerStateSystem}

// -----------------------------------------------------------------------------
// RaidLocations - Drug Dealer
// -----------------------------------------------------------------------------
public enum RaidLocation {
    None = 0,
    Watson = 1,
    SantoDomingo = 2,
    Badlands = 3,
    Westbrook = 4,
    Heywood = 5,
    Pacifica = 6,
}

public func ConvertToTurfLocation(raidLocation: RaidLocation) -> TurfLocation {
    if Equals(raidLocation, RaidLocation.Watson) {
        return TurfLocation.Watson;
    }
    if Equals(raidLocation, RaidLocation.SantoDomingo) {
        return TurfLocation.SantoDomingo;
    }
    if Equals(raidLocation, RaidLocation.Badlands) {
        return TurfLocation.Badlands;
    }
    if Equals(raidLocation, RaidLocation.Westbrook) {
        return TurfLocation.Westbrook;
    }
    if Equals(raidLocation, RaidLocation.Heywood) {
        return TurfLocation.Heywood;
    }
    if Equals(raidLocation, RaidLocation.Pacifica) {
        return TurfLocation.Pacifica;
    }
    return TurfLocation.None;
}

public func ConvertToRaidLocation(turfLocation: TurfLocation) -> RaidLocation {
    if Equals(turfLocation, TurfLocation.Watson) {
        return RaidLocation.Watson;
    }
    if Equals(turfLocation, TurfLocation.SantoDomingo) {
        return RaidLocation.SantoDomingo;
    }
    if Equals(turfLocation, TurfLocation.Badlands) {
        return RaidLocation.Badlands;
    }
    if Equals(turfLocation, TurfLocation.Westbrook) {
        return RaidLocation.Westbrook;
    }
    if Equals(turfLocation, TurfLocation.Heywood) {
        return RaidLocation.Heywood;
    }
    if Equals(turfLocation, TurfLocation.Pacifica) {
        return RaidLocation.Pacifica;
    }
    return RaidLocation.None;
}

public abstract class RaidLocations {
    public static func WatsonLocations() -> array<ref<LocationWithOrientation>> = [
        LocationWithOrientation.Create(Vector4(-1404.5525, 2199.1792, 18.182152, 1.0), Quaternion(0.0, 0.0, 0.64759916, 0.76198125)),
        LocationWithOrientation.Create(Vector4(-991.128, 2471.188, 21.227379, 1.0), Quaternion(0.0, 0.0, 0.8276772, 0.5612046)),
        LocationWithOrientation.Create(Vector4(-1175.6423, 2178.8591, 8.882851, 1.0), Quaternion(0.0, 0.0, -0.9970001, -0.0774005)),
        LocationWithOrientation.Create(Vector4(-1244.015, 2142.2705, 8.886848, 1.0), Quaternion(0.0, 0.0, -0.8361824, 0.5484515)),
        LocationWithOrientation.Create(Vector4(-1326.5867, 2848.9404, 7.1660995, 1.0), Quaternion(0.0, 0.0, 0.98411506, -0.17753175)),
        LocationWithOrientation.Create(Vector4(-1394.1086, 2810.16, 7.1869125, 1.0), Quaternion(0.0, 0.0, -0.92360383, 0.3833486)),
        LocationWithOrientation.Create(Vector4(-1239.1862, 2612.5542, 7.1744614, 1.0), Quaternion(0.0, 0.0, 0.51060593, -0.8598148)),
        LocationWithOrientation.Create(Vector4(-1533.0895, 2569.3254, 7.1178207, 1.0), Quaternion(0.0, 0.0, 0.22063, 0.97535765)),
        LocationWithOrientation.Create(Vector4(-1557.6307, 2551.549, 8.077644, 1.0), Quaternion(0.0, 0.0, 0.43830934, 0.8988243)),
        LocationWithOrientation.Create(Vector4(-1831.939, 2710.7488, 7.137642, 1.0), Quaternion(0.0, 0.0, -0.02335919, 0.99972713)),
        LocationWithOrientation.Create(Vector4(-2009.1433, 2824.5605, 7.204506, 1.0), Quaternion(0.0, 0.0, -0.15245241, 0.9883108)),
        LocationWithOrientation.Create(Vector4(-2167.006, 2857.9165, 7.117775, 1.0), Quaternion(0.0, 0.0, 0.9498027, -0.3128494)),
        LocationWithOrientation.Create(Vector4(-2101.291, 2837.4175, 7.0235977, 1.0), Quaternion(0.0, 0.0, -0.81576794, -0.57837933)),
        LocationWithOrientation.Create(Vector4(-2122.151, 2677.2822, 18.200005, 1.0), Quaternion(0.0, 0.0, 0.82599276, -0.5636808)),
        LocationWithOrientation.Create(Vector4(-2079.766, 2657.1938, 18.17102, 1.0), Quaternion(0.0, 0.0, -0.8259582, -0.56373155)),
        LocationWithOrientation.Create(Vector4(-2033.8354, 2631.763, 18.156342, 1.0), Quaternion(0.0, 0.0, 0.29094034, -0.9567413)),
        LocationWithOrientation.Create(Vector4(-1981.5242, 2645.0073, 18.368439, 1.0), Quaternion(0.0, 0.0, 0.47315443, -0.8809795)),
        LocationWithOrientation.Create(Vector4(-1758.6116, 2533.7908, 18.156296, 1.0), Quaternion(0.0, 0.0, 0.43859503, -0.8986848)),
        LocationWithOrientation.Create(Vector4(-1599.1628, 2422.2148, 18.039993, 1.0), Quaternion(0.0, 0.0, -0.82472634, -0.5655322)),
        LocationWithOrientation.Create(Vector4(-1631.5087, 2376.4324, 18.156189, 1.0), Quaternion(0.0, 0.0, -0.7353787, 0.6776564)),
        LocationWithOrientation.Create(Vector4(-1599.3096, 2316.2947, 18.200005, 1.0), Quaternion(0.0, 0.0, 0.8172877, -0.5762299)),
        LocationWithOrientation.Create(Vector4(-1595.6743, 2259.7468, 18.191101, 1.0), Quaternion(0.0, 0.0, 0.7628283, -0.64660114)),
        LocationWithOrientation.Create(Vector4(-1589.928, 2215.7783, 18.193954, 1.0), Quaternion(0.0, 0.0, 0.8458594, -0.53340584)),
        LocationWithOrientation.Create(Vector4(-1568.1978, 2129.8413, 18.200005, 1.0), Quaternion(0.0, 0.0, 0.85729426, -0.5148267)),
        LocationWithOrientation.Create(Vector4(-1433.1641, 2187.447, 18.181244, 1.0), Quaternion(0.0, 0.0, -0.16098657, 0.9869566)),
        LocationWithOrientation.Create(Vector4(-1479.5872, 2154.7673, 18.189445, 1.0), Quaternion(0.0, 0.0, 0.29338765, 0.95599353)),
        LocationWithOrientation.Create(Vector4(-1521.8282, 2124.8376, 18.156998, 1.0), Quaternion(0.0, 0.0, -0.27707762, -0.96084756)),
        LocationWithOrientation.Create(Vector4(-1561.5583, 2062.9265, 18.15628, 1.0), Quaternion(0.0, 0.0, 0.51972985, -0.8543308)),
        LocationWithOrientation.Create(Vector4(-810.19006, 2020.2689, 43.58596, 1.0), Quaternion(0.0, 0.0, 0.7457659, -0.66620815)),
        LocationWithOrientation.Create(Vector4(-816.5727, 2050.0066, 49.83362, 1.0), Quaternion(0.0, 0.0, -0.20791031, 0.9781479)),
        LocationWithOrientation.Create(Vector4(-824.1093, 2110.4526, 52.80616, 1.0), Quaternion(0.0, 0.0, -0.9205043, 0.3907325)),
        LocationWithOrientation.Create(Vector4(-689.1709, 2148.3523, 52.88748, 1.0), Quaternion(0.0, 0.0, 0.027050702, 0.99963415)),
        LocationWithOrientation.Create(Vector4(-523.45074, 1951.803, 36.15033, 1.0), Quaternion(0.0, 0.0, 0.8389083, 0.5442728)),
        LocationWithOrientation.Create(Vector4(-544.68774, 2071.6094, 36.27439, 1.0), Quaternion(0.0, 0.0, 0.93773776, -0.3473442)),
        LocationWithOrientation.Create(Vector4(-555.51013, 2031.338, 36.26194, 1.0), Quaternion(0.0, 0.0, 0.945661, -0.32515433)),
        LocationWithOrientation.Create(Vector4(-593.64, 2033.5032, 36.24096, 1.0), Quaternion(0.0, 0.0, 0.999086, -0.042746194)),
        LocationWithOrientation.Create(Vector4(-591.87787, 2003.337, 36.301506, 1.0), Quaternion(0.0, 0.0, -0.032717872, -0.9994647)),
        LocationWithOrientation.Create(Vector4(-671.0275, 1948.578, 38.752296, 1.0), Quaternion(0.0, 0.0, -0.6593465, 0.7518393)),
        LocationWithOrientation.Create(Vector4(-670.4889, 1918.441, 38.685913, 1.0), Quaternion(0.0, 0.0, 0.7043251, -0.70987767)),
        LocationWithOrientation.Create(Vector4(-643.2748, 1888.8047, 36.294174, 1.0), Quaternion(0.0, 0.0, 0.8748313, -0.48442787)),
        LocationWithOrientation.Create(Vector4(-652.7503, 1843.8209, 37.53705, 1.0), Quaternion(0.0, 0.0, -0.68803775, 0.7256749)),
        LocationWithOrientation.Create(Vector4(-835.3695, 1839.3505, 36.191414, 1.0), Quaternion(0.0, 0.0, 0.9996594, 0.02609642)),
        LocationWithOrientation.Create(Vector4(-905.4955, 1845.0403, 36.15599, 1.0), Quaternion(0.0, 0.0, -0.9994813, -0.03220331)),
        LocationWithOrientation.Create(Vector4(-930.9132, 1879.4395, 36.122665, 1.0), Quaternion(0.0, 0.0, -0.9948003, -0.101844355)),
        LocationWithOrientation.Create(Vector4(-891.83606, 1893.1058, 36.157326, 1.0), Quaternion(0.0, 0.0, -0.99184924, -0.12741722)),
        LocationWithOrientation.Create(Vector4(-879.01843, 1875.4148, 37.349472, 1.0), Quaternion(0.0, 0.0, -0.9997507, 0.022331486)),
        LocationWithOrientation.Create(Vector4(-843.3513, 1860.1458, 35.348877, 1.0), Quaternion(0.0, 0.0, -0.999714, -0.023915466)),
        LocationWithOrientation.Create(Vector4(-1099.0161, 1162.9546, 1.2403183, 1.0), Quaternion(0.0, 0.0, -0.6513518, -0.75877595)),
        LocationWithOrientation.Create(Vector4(-1101.1759, 1145.632, 1.2403183, 1.0), Quaternion(0.0, 0.0, -0.64703655, -0.76245904)),
        LocationWithOrientation.Create(Vector4(-1202.2133, 1158.9644, 17.343193, 1.0), Quaternion(0.0, 0.0, 0.9994171, 0.034139905)),
        LocationWithOrientation.Create(Vector4(-1218.0491, 1246.8875, 17.240791, 1.0), Quaternion(0.0, 0.0, 0.7016113, -0.71255994)),
        LocationWithOrientation.Create(Vector4(-1191.8833, 1252.7156, 17.38739, 1.0), Quaternion(0.0, 0.0, -0.0042511006, -0.999991)),
        LocationWithOrientation.Create(Vector4(-1180.3217, 1282.2817, 19.942078, 1.0), Quaternion(0.0, 0.0, 0.9918802, 0.12717625)),
        LocationWithOrientation.Create(Vector4(-1166.846, 1136.996, 17.343193, 1.0), Quaternion(0.0, 0.0, 0.093847476, -0.99558663)),
        LocationWithOrientation.Create(Vector4(-2148.1013, 1975.8025, 18.18, 1.0), Quaternion(0.0, 0.0, 0.95285106, 0.30343863)),
        LocationWithOrientation.Create(Vector4(-2101.3843, 1851.3613, 18.103363, 1.0), Quaternion(0.0, 0.0, -0.9111848, 0.4119978)),
        LocationWithOrientation.Create(Vector4(-2009.9633, 1761.7705, 15.200005, 1.0), Quaternion(0.0, 0.0, 0.9883099, 0.15245855)),
        LocationWithOrientation.Create(Vector4(-1867.2734, 1846.7208, 18.045242, 1.0), Quaternion(0.0, 0.0, -0.9632536, 0.2685936)),
        LocationWithOrientation.Create(Vector4(-1841.7845, 1831.1261, 18.183998, 1.0), Quaternion(0.0, 0.0, -0.17870602, 0.9839025)),
        LocationWithOrientation.Create(Vector4(-1719.3417, 1924.8367, 18.18106, 1.0), Quaternion(0.0, 0.0, 0.7977885, -0.60293734)),
        LocationWithOrientation.Create(Vector4(-1679.1956, 1921.7163, 18.157639, 1.0), Quaternion(0.0, 0.0, 0.6521718, 0.7580713)),
        LocationWithOrientation.Create(Vector4(-1715.6881, 1871.2953, 18.150002, 1.0), Quaternion(0.0, 0.0, -0.48815632, 0.87275624)),
        LocationWithOrientation.Create(Vector4(-1619.1626, 1815.3005, 18.380005, 1.0), Quaternion(0.0, 0.0, -0.84226984, -0.5390562)),
        LocationWithOrientation.Create(Vector4(-1596.791, 1764.0073, 18.380005, 1.0), Quaternion(0.0, 0.0, -0.45291007, -0.89155626)),
        LocationWithOrientation.Create(Vector4(-1622.0659, 1446.3353, 18.193237, 1.0), Quaternion(0.0, 0.0, -0.2207932, -0.9753207)),
        LocationWithOrientation.Create(Vector4(-1641.487, 1329.3384, 18.190002, 1.0), Quaternion(0.0, 0.0, -0.6613857, -0.75004596)),
        LocationWithOrientation.Create(Vector4(-1612.6108, 1367.8021, 18.198112, 1.0), Quaternion(0.0, 0.0, -0.64819497, -0.76147455)),
        LocationWithOrientation.Create(Vector4(-1590.2067, 1365.6902, 25.111496, 1.0), Quaternion(0.0, 0.0, 0.74947006, -0.6620383)),
        LocationWithOrientation.Create(Vector4(-1572.9886, 1316.4854, 23.12709, 1.0), Quaternion(0.0, 0.0, 0.3412915, 0.9399575)),
        LocationWithOrientation.Create(Vector4(-1438.343, 1166.4863, 23.070526, 1.0), Quaternion(0.0, 0.0, 0.06975451, -0.99756426)),
        LocationWithOrientation.Create(Vector4(-1439.6273, 994.90424, 29.017448, 1.0), Quaternion(0.0, 0.0, 0.99922913, 0.039257254)),
        LocationWithOrientation.Create(Vector4(-1493.1067, 1028.8856, 22.495834, 1.0), Quaternion(0.0, 0.0, 0.7561391, -0.6544109)),
        LocationWithOrientation.Create(Vector4(-1492.7363, 994.25757, 23.280113, 1.0), Quaternion(0.0, 0.0, -0.9952272, 0.09758492)),
        LocationWithOrientation.Create(Vector4(-1523.0652, 987.0567, 23.786697, 1.0), Quaternion(0.0, 0.0, -0.9995066, -0.031408913)),
        LocationWithOrientation.Create(Vector4(-1402.6702, 1027.6576, 29.052483, 1.0), Quaternion(0.0, 0.0, -0.6855028, -0.72807)),
        LocationWithOrientation.Create(Vector4(-1441.6886, 1084.3964, 29.010963, 1.0), Quaternion(0.0, 0.0, 0.9253743, -0.37905478))
    ];

    public static func SantoDomingoLocations() -> array<ref<LocationWithOrientation>> = [
        LocationWithOrientation.Create(Vector4(-785.023, -1379.281, 7.79364, 1.0), Quaternion(0.0, 0.0, -0.87800413, 0.47865322)),
        LocationWithOrientation.Create(Vector4(-849.7787, -1493.5518, 8.043846, 1.0), Quaternion(0.0, 0.0, 0.99852264, -0.05433795)),
        LocationWithOrientation.Create(Vector4(-938.9805, -1663.404, 10.939476, 1.0), Quaternion(0.0, 0.0, -0.5141414, -0.8577055)),
        LocationWithOrientation.Create(Vector4(-987.1265, -1727.3904, 11.137428, 1.0), Quaternion(0.0, 0.0, 0.08828681, 0.9960951)),
        LocationWithOrientation.Create(Vector4(-955.73846, -1752.9851, 10.932541, 1.0), Quaternion(0.0, 0.0, 0.85819983, 0.5133158)),
        LocationWithOrientation.Create(Vector4(-933.52826, -1785.2489, 10.042679, 1.0), Quaternion(0.0, 0.0, 0.97748375, -0.21101096)),
        LocationWithOrientation.Create(Vector4(-878.5785, -1812.3945, 8.856865, 1.0), Quaternion(0.0, 0.0, 0.8339496, 0.55184066)),
        LocationWithOrientation.Create(Vector4(-587.9479, -1901.609, 6.5460663, 1.0), Quaternion(0.0, 0.0, -0.7022106, -0.7119693)),
        LocationWithOrientation.Create(Vector4(-184.79616, -1762.8364, 7.0369797, 1.0), Quaternion(0.0, 0.0, -0.9948218, 0.10163554)),
        LocationWithOrientation.Create(Vector4(-520.9093, -1862.23, 7.458229, 1.0), Quaternion(0.0, 0.0, 0.014866649, 0.9998895)),
        LocationWithOrientation.Create(Vector4(-737.2065, -1317.9814, 8.063713, 1.0), Quaternion(0.0, 0.0, 0.9811836, -0.19307695)),
        LocationWithOrientation.Create(Vector4(-677.15326, -1235.643, 9.120354, 1.0), Quaternion(0.0, 0.0, 0.8793544, -0.47616807)),
        LocationWithOrientation.Create(Vector4(-635.7523, -1174.5952, 7.8172836, 1.0), Quaternion(0.0, 0.0, 0.81300366, -0.58225864)),
        LocationWithOrientation.Create(Vector4(-721.1389, -1018.457, 7.485161, 1.0), Quaternion(0.0, 0.0, 0.988283, 0.15263313)),
        LocationWithOrientation.Create(Vector4(-680.56104, -883.0668, 7.51429, 1.0), Quaternion(0.0, 0.0, 0.9897499, -0.14281137)),
        LocationWithOrientation.Create(Vector4(-632.1212, -872.9027, 7.392975, 1.0), Quaternion(0.0, 0.0, -0.6950192, 0.7189913)),
        LocationWithOrientation.Create(Vector4(-739.41504, -816.96326, 10.865326, 1.0), Quaternion(0.0, 0.0, -0.40074134, 0.9161913)),
        LocationWithOrientation.Create(Vector4(-511.86536, -476.3978, 8.195213, 1.0), Quaternion(0.0, 0.0, 0.66182375, 0.7496595)),
        LocationWithOrientation.Create(Vector4(61.3547, -547.69745, 7.5230103, 1.0), Quaternion(0.0, 0.0, -0.89007705, -0.45581016)),
        LocationWithOrientation.Create(Vector4(153.21812, -667.55786, 7.155838, 1.0), Quaternion(0.0, 0.0, 0.038029816, 0.99927664)),
        LocationWithOrientation.Create(Vector4(679.04614, -982.6873, 28.580276, 1.0), Quaternion(0.0, 0.0, -0.52232397, 0.85274714)),
        LocationWithOrientation.Create(Vector4(729.58264, -1025.9022, 27.979706, 1.0), Quaternion(0.0, 0.0, 0.7961531, 0.6050952)),
        LocationWithOrientation.Create(Vector4(657.9954, -1209.8423, 28.193832, 1.0), Quaternion(0.0, 0.0, 0.02028893, 0.9997942)),
        LocationWithOrientation.Create(Vector4(956.15674, -1031.8494, 28.015785, 1.0), Quaternion(0.0, 0.0, -0.97799796, -0.20861444)),
        LocationWithOrientation.Create(Vector4(1075.4838, -1059.867, 29.576561, 1.0), Quaternion(0.0, 0.0, -0.27032888, -0.9627681)),
        LocationWithOrientation.Create(Vector4(570.84705, -1271.8792, 28.748833, 1.0), Quaternion(0.0, 0.0, -0.6273447, 0.7787418)),
        LocationWithOrientation.Create(Vector4(644.5721, -1332.6674, 28.046516, 1.0), Quaternion(0.0, 0.0, -0.95871025, -0.28438485)),
        LocationWithOrientation.Create(Vector4(638.9295, -1402.8795, 27.620049, 1.0), Quaternion(0.0, 0.0, 0.72982234, 0.68363684)),
        LocationWithOrientation.Create(Vector4(651.0902, -1435.4939, 27.60968, 1.0), Quaternion(0.0, 0.0, 0.2048631, 0.9787907)),
        LocationWithOrientation.Create(Vector4(641.3544, -1379.7626, 27.619896, 1.0), Quaternion(0.0, 0.0, 0.94363624, 0.33098426)),
        LocationWithOrientation.Create(Vector4(453.15375, -1605.0868, 10.327309, 1.0), Quaternion(0.0, 0.0, 0.55453557, 0.8321601))
    ];

    public static func BadlandsLocations() -> array<ref<LocationWithOrientation>> = [
        LocationWithOrientation.Create(Vector4(1697.3324, -789.31415, 49.596138, 1.0), Quaternion(0.0, 0.0, 0.35320452, 0.93554616)),
        LocationWithOrientation.Create(Vector4(1713.5009, -727.0016, 50.09317, 1.0), Quaternion(0.0, 0.0, -0.63585466, -0.7718088)),
        LocationWithOrientation.Create(Vector4(1620.5736, -696.2624, 50.236496, 1.0), Quaternion(0.0, 0.0, -0.3598606, 0.93300617)),
        LocationWithOrientation.Create(Vector4(2151.2297, -692.20984, 60.3909, 1.0), Quaternion(0.0, 0.0, 0.08442414, 0.9964299)),
        LocationWithOrientation.Create(Vector4(2479.6702, -76.95961, 82.64577, 1.0), Quaternion(0.0, 0.0, 0.9327715, -0.36046824)),
        LocationWithOrientation.Create(Vector4(2605.3604, -18.737572, 80.35684, 1.0), Quaternion(0.0, 0.0, 0.9294803, 0.36887184)),
        LocationWithOrientation.Create(Vector4(2657.1636, 53.417206, 76.8492, 1.0), Quaternion(0.0, 0.0, 0.988084, -0.15391599)),
        LocationWithOrientation.Create(Vector4(2684.086, 147.19315, 73.24129, 1.0), Quaternion(0.0, 0.0, 0.9877459, -0.15607062)),
        LocationWithOrientation.Create(Vector4(2674.2173, 265.04874, 75.91461, 1.0), Quaternion(0.0, 0.0, -0.001814496, -0.99999845)),
        LocationWithOrientation.Create(Vector4(3214.5227, 632.8634, 104.72592, 1.0), Quaternion(0.0, 0.0, 0.994891, 0.10095598)),
        LocationWithOrientation.Create(Vector4(3715.0393, 792.1529, 134.19684, 1.0), Quaternion(0.0, 0.0, -0.8984884, -0.43899748)),
        LocationWithOrientation.Create(Vector4(1249.3672, -582.5147, 35.092346, 1.0), Quaternion(0.0, 0.0, 0.7212695, 0.69265455)),
        LocationWithOrientation.Create(Vector4(1262.9165, -524.0587, 37.35434, 1.0), Quaternion(0.0, 0.0, 0.9886009, -0.15056011)),
        LocationWithOrientation.Create(Vector4(1187.6536, -585.24896, 32.316055, 1.0), Quaternion(0.0, 0.0, -0.90789217, 0.41920385)),
        LocationWithOrientation.Create(Vector4(1166.565, -571.0856, 30.388313, 1.0), Quaternion(0.0, 0.0, -0.58588713, 0.8103927)),
        LocationWithOrientation.Create(Vector4(1205.5332, -532.0974, 33.693687, 1.0), Quaternion(0.0, 0.0, 0.8691438, 0.4945596)),
        LocationWithOrientation.Create(Vector4(1180.5024, -476.91565, 33.18216, 1.0), Quaternion(0.0, 0.0, -0.99598765, 0.08949083)),
        LocationWithOrientation.Create(Vector4(1233.0752, -497.1234, 36.427094, 1.0), Quaternion(0.0, 0.0, 0.19910043, 0.97997916)),
        LocationWithOrientation.Create(Vector4(1243.0413, -470.85843, 37.128525, 1.0), Quaternion(0.0, 0.0, -0.822981, -0.5680689))
    ];

    public static func WestbrookLocations() -> array<ref<LocationWithOrientation>> = [
        LocationWithOrientation.Create(Vector4(-450.64062, 1389.5979, 37.270004, 1.0), Quaternion(0.0, 0.0, 0.170324, -0.9853881)),
        LocationWithOrientation.Create(Vector4(-181.12296, -82.887726, 7.1929703, 1.0), Quaternion(0.0, 0.0, 0.7832297, 0.62173235)),
        LocationWithOrientation.Create(Vector4(-105.39555, -85.86815, 11.002541, 1.0), Quaternion(0.0, 0.0, 0.94513285, 0.32668638)),
        LocationWithOrientation.Create(Vector4(-244.46849, -205.54794, 0.7660446, 1.0), Quaternion(0.0, 0.0, -0.17180681, 0.98513067)),
        LocationWithOrientation.Create(Vector4(-200.5232, -200.66826, 1.9464417, 1.0), Quaternion(0.0, 0.0, -0.95427734, -0.2989226)),
        LocationWithOrientation.Create(Vector4(-142.22928, -132.49033, -0.71139526, 1.0), Quaternion(0.0, 0.0, 0.9469696, 0.321323)),
        LocationWithOrientation.Create(Vector4(-343.79916, 163.01979, 22.081856, 1.0), Quaternion(0.0, 0.0, 0.9540992, 0.2994911)),
        LocationWithOrientation.Create(Vector4(-330.83945, 189.25208, 28.097603, 1.0), Quaternion(0.0, 0.0, -0.40318206, 0.9151199)),
        LocationWithOrientation.Create(Vector4(-236.83473, 294.74182, 28.821823, 1.0), Quaternion(0.0, 0.0, -0.9559243, -0.29361334)),
        LocationWithOrientation.Create(Vector4(-207.95753, 562.93475, 74.41609, 1.0), Quaternion(0.0, 0.0, -0.6642796, 0.74748427)),
        LocationWithOrientation.Create(Vector4(-305.63672, 974.5626, 65.47775, 1.0), Quaternion(0.0, 0.0, -0.07776417, 0.99697185)),
        LocationWithOrientation.Create(Vector4(-270.60635, 1021.0091, 65.28024, 1.0), Quaternion(0.0, 0.0, -0.9164672, -0.40010992)),
        LocationWithOrientation.Create(Vector4(-283.80374, 1190.1, 65.28175, 1.0), Quaternion(0.0, 0.0, -0.73724926, -0.6756209)),
        LocationWithOrientation.Create(Vector4(-321.92352, 1401.1149, 43.03463, 1.0), Quaternion(0.0, 0.0, 0.49841097, 0.866941)),
        LocationWithOrientation.Create(Vector4(-352.91486, 1509.6859, 36.06372, 1.0), Quaternion(0.0, 0.0, 0.99767643, 0.06813049)),
        LocationWithOrientation.Create(Vector4(-403.30725, 1355.5608, 42.160683, 1.0), Quaternion(0.0, 0.0, 0.7050265, -0.709181)),
        LocationWithOrientation.Create(Vector4(-428.65976, 1316.7332, 42.997406, 1.0), Quaternion(0.0, 0.0, 0.7127203, -0.7014484)),
        LocationWithOrientation.Create(Vector4(-388.0294, 1246.9806, 23.428368, 1.0), Quaternion(0.0, 0.0, 0.5403389, -0.8414476)),
        LocationWithOrientation.Create(Vector4(-545.4429, 1435.2953, 37.248634, 1.0), Quaternion(0.0, 0.0, 0.8963276, -0.44339246)),
        LocationWithOrientation.Create(Vector4(-554.1394, 1426.48, 37.248444, 1.0), Quaternion(0.0, 0.0, 0.67532617, -0.73751926)),
        LocationWithOrientation.Create(Vector4(-583.8425, 1347.3009, 37.24157, 1.0), Quaternion(0.0, 0.0, 0.88202703, -0.4711988)),
        LocationWithOrientation.Create(Vector4(-545.8496, 1285.4806, 37.24945, 1.0), Quaternion(0.0, 0.0, 0.24115117, 0.9704876)),
        LocationWithOrientation.Create(Vector4(-630.4747, 1331.933, 37.261894, 1.0), Quaternion(0.0, 0.0, -0.30104712, 0.95360935)),
        LocationWithOrientation.Create(Vector4(-802.3362, 1294.5852, 28.092484, 1.0), Quaternion(0.0, 0.0, 0.8591435, -0.5117347)),
        LocationWithOrientation.Create(Vector4(-789.7969, 1274.239, 28.092476, 1.0), Quaternion(0.0, 0.0, -0.17501383, -0.98456603)),
        LocationWithOrientation.Create(Vector4(-780.34814, 1196.6818, 28.616325, 1.0), Quaternion(0.0, 0.0, -0.0051583853, 0.99998677)),
        LocationWithOrientation.Create(Vector4(-734.40936, 1179.2628, 28.622246, 1.0), Quaternion(0.0, 0.0, -0.36845806, 0.92964435)),
        LocationWithOrientation.Create(Vector4(-716.7001, 1206.6223, 28.6063, 1.0), Quaternion(0.0, 0.0, 0.94016606, 0.34071684)),
        LocationWithOrientation.Create(Vector4(-737.256, 1219.2943, 28.6063, 1.0), Quaternion(0.0, 0.0, 0.99487287, -0.101133235)),
        LocationWithOrientation.Create(Vector4(-773.4448, 1098.7904, 28.200005, 1.0), Quaternion(0.0, 0.0, 0.21608984, 0.97637355)),
        LocationWithOrientation.Create(Vector4(-765.2073, 1076.4954, 28.199997, 1.0), Quaternion(0.0, 0.0, 0.22970082, 0.97326136)),
        LocationWithOrientation.Create(Vector4(-723.9716, 1082.7181, 30.200005, 1.0), Quaternion(0.0, 0.0, -0.7154421, -0.69867206)),
        LocationWithOrientation.Create(Vector4(-818.78064, 1035.4424, 17.225174, 1.0), Quaternion(0.0, 0.0, 0.0054207863, 0.99998534)),
        LocationWithOrientation.Create(Vector4(-879.7023, 1081.1721, 21.116966, 1.0), Quaternion(0.0, 0.0, 0.5215388, 0.85322756)),
        LocationWithOrientation.Create(Vector4(-852.86865, 1131.6705, 21.117348, 1.0), Quaternion(0.0, 0.0, 0.73710775, 0.67577523)),
        LocationWithOrientation.Create(Vector4(-852.4539, 1152.2576, 21.117393, 1.0), Quaternion(0.0, 0.0, 0.9746075, 0.2239199)),
        LocationWithOrientation.Create(Vector4(-874.81445, 1162.0112, 21.117203, 1.0), Quaternion(0.0, 0.0, 0.7932021, 0.60895854)),
        LocationWithOrientation.Create(Vector4(-884.7003, 1186.4467, 21.314056, 1.0), Quaternion(0.0, 0.0, 0.8610598, 0.50850374)),
        LocationWithOrientation.Create(Vector4(-845.9303, 1299.4751, 28.116653, 1.0), Quaternion(0.0, 0.0, 0.8217139, -0.5699001)),
        LocationWithOrientation.Create(Vector4(-807.9253, 1318.7529, 28.083138, 1.0), Quaternion(0.0, 0.0, 0.82517993, -0.5648701)),
        LocationWithOrientation.Create(Vector4(-856.35974, 926.30597, 22.46135, 1.0), Quaternion(0.0, 0.0, -0.78684795, -0.6171469)),
        LocationWithOrientation.Create(Vector4(-813.7354, 922.37823, 12.036369, 1.0), Quaternion(0.0, 0.0, 0.35077024, 0.9364616)),
        LocationWithOrientation.Create(Vector4(-788.4383, 889.24585, 12.025284, 1.0), Quaternion(0.0, 0.0, 0.09904925, 0.9950825)),
        LocationWithOrientation.Create(Vector4(-749.23706, 891.8262, 12.19474, 1.0), Quaternion(0.0, 0.0, 0.4963591, 0.8681174)),
        LocationWithOrientation.Create(Vector4(-823.86615, 881.0555, 12.40625, 1.0), Quaternion(0.0, 0.0, -0.25064325, 0.96807957)),
        LocationWithOrientation.Create(Vector4(-778.2624, 827.5038, 22.431496, 1.0), Quaternion(0.0, 0.0, -0.98058254, 0.19610667)),
        LocationWithOrientation.Create(Vector4(-757.6028, 866.37756, 20.299484, 1.0), Quaternion(0.0, 0.0, -0.94302315, 0.33272734)),
        LocationWithOrientation.Create(Vector4(-698.2379, 867.87683, 20.28318, 1.0), Quaternion(0.0, 0.0, 0.36868235, 0.92955554)),
        LocationWithOrientation.Create(Vector4(-677.3515, 867.2074, 20.232956, 1.0), Quaternion(0.0, 0.0, -0.17939237, -0.9837777)),
        LocationWithOrientation.Create(Vector4(-692.47296, 968.2954, 12.0, 1.0), Quaternion(0.0, 0.0, 0.9988194, -0.04857865)),
        LocationWithOrientation.Create(Vector4(-730.29065, 979.34644, 12.025284, 1.0), Quaternion(0.0, 0.0, -0.62033415, 0.7843377)),
        LocationWithOrientation.Create(Vector4(-702.60846, 999.0001, 35.568016, 1.0), Quaternion(0.0, 0.0, 0.46344385, 0.88612634)),
        LocationWithOrientation.Create(Vector4(-718.9531, 1040.6323, 35.572052, 1.0), Quaternion(0.0, 0.0, 0.9595131, -0.28166395)),
        LocationWithOrientation.Create(Vector4(-748.411, 995.63654, 35.64334, 1.0), Quaternion(0.0, 0.0, -0.071662776, -0.99742895)),
        LocationWithOrientation.Create(Vector4(-727.3159, 960.72485, 35.578476, 1.0), Quaternion(0.0, 0.0, 0.27631694, -0.9610666)),
        LocationWithOrientation.Create(Vector4(-733.7309, 871.6387, 32.67975, 1.0), Quaternion(0.0, 0.0, 0.8390547, -0.544047)),
        LocationWithOrientation.Create(Vector4(-780.62146, 852.82416, 32.667023, 1.0), Quaternion(0.0, 0.0, 0.84023976, -0.54221517)),
        LocationWithOrientation.Create(Vector4(-760.84375, 745.2663, 22.493622, 1.0), Quaternion(0.0, 0.0, 0.65980035, 0.7514409)),
        LocationWithOrientation.Create(Vector4(-772.51855, 709.90894, 22.470436, 1.0), Quaternion(0.0, 0.0, -0.5571603, -0.83040506)),
        LocationWithOrientation.Create(Vector4(-751.364, 583.25684, 19.55928, 1.0), Quaternion(0.0, 0.0, -0.8710818, -0.4911379)),
        LocationWithOrientation.Create(Vector4(-698.3805, 603.683, 19.315636, 1.0), Quaternion(0.0, 0.0, 0.91559523, -0.4021013))
    ];

    public static func HeywoodLocations() -> array<ref<LocationWithOrientation>> = [
        LocationWithOrientation.Create(Vector4(-1530.911, -1346.1655, 48.63173, 1.0), Quaternion(0.0, 0.0, -0.0128180375, 0.9999179)),
        LocationWithOrientation.Create(Vector4(-1076.8444, -919.8376, 16.417473, 1.0), Quaternion(0.0, 0.0, -0.94854116, -0.31665388)),
        LocationWithOrientation.Create(Vector4(-1155.5728, 275.08563, 4.748596, 1.0), Quaternion(0.0, 0.0, 0.21843965, 0.97585046)),
        LocationWithOrientation.Create(Vector4(-1142.5214, 237.53497, 5.280037, 1.0), Quaternion(0.0, 0.0, 0.3167644, 0.9485043)),
        LocationWithOrientation.Create(Vector4(-1147.6566, 177.5938, 5.2800446, 1.0), Quaternion(0.0, 0.0, 0.84612215, 0.5329891)),
        LocationWithOrientation.Create(Vector4(-1127.2578, 146.11534, 5.280037, 1.0), Quaternion(0.0, 0.0, 0.759752, 0.650213)),
        LocationWithOrientation.Create(Vector4(-822.4937, 8.355438, 8.152145, 1.0), Quaternion(0.0, 0.0, 0.73971975, -0.67291516)),
        LocationWithOrientation.Create(Vector4(-702.5216, -2.1691895, 8.121399, 1.0), Quaternion(0.0, 0.0, -0.9575334, -0.2883227)),
        LocationWithOrientation.Create(Vector4(-591.903, -133.68222, 7.6800003, 1.0), Quaternion(0.0, 0.0, -0.20377104, 0.97901857)),
        LocationWithOrientation.Create(Vector4(-565.1107, -152.36397, 7.680008, 1.0), Quaternion(0.0, 0.0, -0.63449544, 0.77292657)),
        LocationWithOrientation.Create(Vector4(-561.3375, -234.23093, 7.6890182, 1.0), Quaternion(0.0, 0.0, 0.88626456, -0.46317953)),
        LocationWithOrientation.Create(Vector4(-570.94946, -248.78665, 7.6800003, 1.0), Quaternion(0.0, 0.0, 0.8912642, -0.4534845)),
        LocationWithOrientation.Create(Vector4(-641.43884, -343.4145, 7.707451, 1.0), Quaternion(0.0, 0.0, 0.8848458, -0.46588406)),
        LocationWithOrientation.Create(Vector4(-690.4525, -428.16898, 8.209999, 1.0), Quaternion(0.0, 0.0, 0.58612585, -0.81022)),
        LocationWithOrientation.Create(Vector4(-727.437, -481.7608, 8.199997, 1.0), Quaternion(0.0, 0.0, 0.8536197, -0.5208967)),
        LocationWithOrientation.Create(Vector4(-730.51733, -538.9446, 8.231491, 1.0), Quaternion(0.0, 0.0, 0.81807274, 0.57511485)),
        LocationWithOrientation.Create(Vector4(-783.7612, -555.9791, 8.208992, 1.0), Quaternion(0.0, 0.0, 0.6137042, -0.7895361)),
        LocationWithOrientation.Create(Vector4(-1007.61835, -869.54443, 8.199692, 1.0), Quaternion(0.0, 0.0, 0.8751313, -0.48388574)),
        LocationWithOrientation.Create(Vector4(-1029.1786, -886.56995, 8.16674, 1.0), Quaternion(0.0, 0.0, 0.947849, 0.3187198)),
        LocationWithOrientation.Create(Vector4(-1046.1383, -875.4719, 8.16674, 1.0), Quaternion(0.0, 0.0, 0.9427256, 0.33356938)),
        LocationWithOrientation.Create(Vector4(-1075.9299, -876.6078, 8.161682, 1.0), Quaternion(0.0, 0.0, -0.49220482, 0.87047946)),
        LocationWithOrientation.Create(Vector4(-1106.2948, -981.4774, 13.002388, 1.0), Quaternion(0.0, 0.0, 0.62749, -0.7786247)),
        LocationWithOrientation.Create(Vector4(-1212.4662, -1097.8927, 12.853104, 1.0), Quaternion(0.0, 0.0, 0.6549413, -0.75567967)),
        LocationWithOrientation.Create(Vector4(-1262.2091, -1075.7654, 12.656921, 1.0), Quaternion(0.0, 0.0, -0.7239905, -0.68981)),
        LocationWithOrientation.Create(Vector4(-1326.9705, -1149.3103, 12.279137, 1.0), Quaternion(0.0, 0.0, -0.6799211, -0.73328537)),
        LocationWithOrientation.Create(Vector4(-1374.8164, -1116.2601, 12.354454, 1.0), Quaternion(0.0, 0.0, -0.6968545, 0.7172126)),
        LocationWithOrientation.Create(Vector4(-1508.1545, -1169.6389, 16.975014, 1.0), Quaternion(0.0, 0.0, 0.3607105, -0.93267787)),
        LocationWithOrientation.Create(Vector4(-1453.4534, -1142.4297, 17.016426, 1.0), Quaternion(0.0, 0.0, -0.7787225, 0.62736857)),
        LocationWithOrientation.Create(Vector4(-1466.9803, -1174.5122, 12.190285, 1.0), Quaternion(0.0, 0.0, -0.7168342, 0.69724375)),
        LocationWithOrientation.Create(Vector4(-1603.0171, -1267.7191, 24.851624, 1.0), Quaternion(0.0, 0.0, -0.99999905, 0.0014201556)),
        LocationWithOrientation.Create(Vector4(-1603.5988, -1312.223, 38.519485, 1.0), Quaternion(0.0, 0.0, -0.999924, 0.012328284)),
        LocationWithOrientation.Create(Vector4(-1651.6982, -1367.5388, 38.441673, 1.0), Quaternion(0.0, 0.0, -0.73097813, 0.68240094)),
        LocationWithOrientation.Create(Vector4(-1680.9088, -1367.5457, 38.44162, 1.0), Quaternion(0.0, 0.0, -0.69064915, -0.72319)),
        LocationWithOrientation.Create(Vector4(-1598.467, -1373.4242, 48.989075, 1.0), Quaternion(0.0, 0.0, 0.99932235, 0.036808547)),
        LocationWithOrientation.Create(Vector4(-1563.1418, -1375.814, 49.96189, 1.0), Quaternion(0.0, 0.0, 0.9992225, 0.039425258)),
        LocationWithOrientation.Create(Vector4(-1588.2205, -1374.8502, 49.90133, 1.0), Quaternion(0.0, 0.0, -0.007582711, 0.9999713)),
        LocationWithOrientation.Create(Vector4(-1835.236, -1346.2123, 34.631424, 1.0), Quaternion(0.0, 0.0, 0.999684, -0.025139214)),
        LocationWithOrientation.Create(Vector4(-1809.287, -1348.2429, 34.66707, 1.0), Quaternion(0.0, 0.0, 0.99907887, 0.04291297)),
        LocationWithOrientation.Create(Vector4(-1860.6117, -1353.9272, 34.72055, 1.0), Quaternion(0.0, 0.0, -0.9153782, 0.4025949)),
        LocationWithOrientation.Create(Vector4(-1836.668, -1239.2213, 20.23935, 1.0), Quaternion(0.0, 0.0, -0.44487602, -0.8955922)),
        LocationWithOrientation.Create(Vector4(-1864.4375, -1242.71, 20.190987, 1.0), Quaternion(0.0, 0.0, 0.15056315, -0.9886005)),
        LocationWithOrientation.Create(Vector4(-1890.4772, -1272.2611, 20.23304, 1.0), Quaternion(0.0, 0.0, 0.69767076, 0.7164186)),
        LocationWithOrientation.Create(Vector4(-1914.6838, -1270.2511, 20.257568, 1.0), Quaternion(0.0, 0.0, -0.7007175, 0.71343887)),
        LocationWithOrientation.Create(Vector4(-1863.776, -1195.769, 20.824455, 1.0), Quaternion(0.0, 0.0, 0.72028065, -0.6936828)),
        LocationWithOrientation.Create(Vector4(-1823.1609, -1160.4551, 20.05568, 1.0), Quaternion(0.0, 0.0, 0.6943113, 0.71967477)),
        LocationWithOrientation.Create(Vector4(-1799.1532, -1128.7659, 20.038528, 1.0), Quaternion(0.0, 0.0, 0.7079992, 0.70621324)),
        LocationWithOrientation.Create(Vector4(-1788.8885, -1063.7506, 19.933395, 1.0), Quaternion(0.0, 0.0, 0.999869, 0.016190514)),
        LocationWithOrientation.Create(Vector4(-1822.1564, -1048.1266, 15.146736, 1.0), Quaternion(0.0, 0.0, -0.003973491, 0.9999922)),
        LocationWithOrientation.Create(Vector4(-1832.1903, -1036.1116, 7.927994, 1.0), Quaternion(0.0, 0.0, 0.7274419, 0.68616927)),
        LocationWithOrientation.Create(Vector4(-1824.2677, -1195.7599, 20.073463, 1.0), Quaternion(0.0, 0.0, -0.006499998, -0.9999789)),
        LocationWithOrientation.Create(Vector4(-1859.9989, -1353.4221, 34.72104, 1.0), Quaternion(0.0, 0.0, -0.9065112, 0.42218173)),
        LocationWithOrientation.Create(Vector4(-2122.1396, -1245.2832, 12.473114, 1.0), Quaternion(0.0, 0.0, 0.7443101, 0.6678342)),
        LocationWithOrientation.Create(Vector4(-2150.5364, -1225.1876, 8.339691, 1.0), Quaternion(0.0, 0.0, 0.34693348, 0.93788975)),
        LocationWithOrientation.Create(Vector4(-2150.4128, -1196.7292, 8.3414, 1.0), Quaternion(0.0, 0.0, 0.9175804, 0.3975503)),
        LocationWithOrientation.Create(Vector4(-2143.2222, -1145.719, 12.200005, 1.0), Quaternion(0.0, 0.0, 0.9999923, -0.003925306)),
        LocationWithOrientation.Create(Vector4(-2138.3054, -1171.3224, 12.200745, 1.0), Quaternion(0.0, 0.0, 0.99995804, -0.009161133)),
        LocationWithOrientation.Create(Vector4(-2187.517, -1171.4751, 9.073631, 1.0), Quaternion(0.0, 0.0, -0.5891979, 0.8079888)),
        LocationWithOrientation.Create(Vector4(-2179.9565, -1158.368, 8.240425, 1.0), Quaternion(0.0, 0.0, -0.9960023, 0.08932718)),
        LocationWithOrientation.Create(Vector4(-2233.473, -1169.8429, 12.814827, 1.0), Quaternion(0.0, 0.0, -0.8218965, 0.569637)),
        LocationWithOrientation.Create(Vector4(-2253.0532, -1148.4542, 11.7374115, 1.0), Quaternion(0.0, 0.0, 0.9620984, 0.27270278)),
        LocationWithOrientation.Create(Vector4(-2258.9812, -1116.5065, 12.851669, 1.0), Quaternion(0.0, 0.0, 0.9472093, 0.32061595)),
        LocationWithOrientation.Create(Vector4(-2232.735, -1077.1558, 8.851669, 1.0), Quaternion(0.0, 0.0, -0.17537014, 0.98450255)),
        LocationWithOrientation.Create(Vector4(-2221.0195, -1011.617, 7.8202515, 1.0), Quaternion(0.0, 0.0, 0.6411118, 0.7674476)),
        LocationWithOrientation.Create(Vector4(-2241.4526, -997.7762, 7.871025, 1.0), Quaternion(0.0, 0.0, 0.89610136, -0.44384947)),
        LocationWithOrientation.Create(Vector4(-2217.689, -940.1352, 7.9310226, 1.0), Quaternion(0.0, 0.0, -0.8208912, -0.57108474)),
        LocationWithOrientation.Create(Vector4(-2209.803, -896.1643, 7.9400253, 1.0), Quaternion(0.0, 0.0, -0.9399854, -0.34121472)),
        LocationWithOrientation.Create(Vector4(-2169.3057, -880.43726, 7.870682, 1.0), Quaternion(0.0, 0.0, -0.9999755, -0.0069966596)),
        LocationWithOrientation.Create(Vector4(-2172.6433, -939.78784, 2.8210754, 1.0), Quaternion(0.0, 0.0, 0.811838, -0.5838828)),
        LocationWithOrientation.Create(Vector4(-2170.1218, -1000.0305, 8.014442, 1.0), Quaternion(0.0, 0.0, 0.7034057, -0.7107886)),
        LocationWithOrientation.Create(Vector4(-2141.1687, -985.7911, 8.036026, 1.0), Quaternion(0.0, 0.0, 0.69244665, 0.72146916)),
        LocationWithOrientation.Create(Vector4(-2114.4028, -1046.1691, 7.6596603, 1.0), Quaternion(0.0, 0.0, -0.4285265, -0.90352917)),
        LocationWithOrientation.Create(Vector4(-2135.7449, -919.4953, 14.094536, 1.0), Quaternion(0.0, 0.0, 0.9995331, 0.030554306)),
        LocationWithOrientation.Create(Vector4(-2129.7664, -872.6192, 14.094536, 1.0), Quaternion(0.0, 0.0, 0.66619515, 0.74577755)),
        LocationWithOrientation.Create(Vector4(-2047.8627, -859.42676, 7.712181, 1.0), Quaternion(0.0, 0.0, -0.010052419, 0.9999495)),
        LocationWithOrientation.Create(Vector4(-2193.8953, -858.76154, 7.6774216, 1.0), Quaternion(0.0, 0.0, 0.14045249, 0.99008745)),
        LocationWithOrientation.Create(Vector4(-2247.068, -875.1149, 7.655075, 1.0), Quaternion(0.0, 0.0, 0.7451965, -0.66684496)),
        LocationWithOrientation.Create(Vector4(-2275.6492, -910.009, 8.098816, 1.0), Quaternion(0.0, 0.0, -0.85695094, 0.515398)),
        LocationWithOrientation.Create(Vector4(-2306.1917, -941.7803, 8.098816, 1.0), Quaternion(0.0, 0.0, -0.8634037, 0.50451374)),
        LocationWithOrientation.Create(Vector4(-2347.5996, -977.6152, 8.149567, 1.0), Quaternion(0.0, 0.0, -0.9993279, -0.036659237)),
        LocationWithOrientation.Create(Vector4(-2376.7783, -920.4479, 12.154167, 1.0), Quaternion(0.0, 0.0, -0.9999839, -0.0056758937)),
        LocationWithOrientation.Create(Vector4(-2376.8433, -884.4804, 12.213898, 1.0), Quaternion(0.0, 0.0, 0.007421188, -0.9999725)),
        LocationWithOrientation.Create(Vector4(-2337.6697, -865.34937, 12.833672, 1.0), Quaternion(0.0, 0.0, -0.06714052, -0.99774355)),
        LocationWithOrientation.Create(Vector4(-2241.5476, -857.15735, 7.684143, 1.0), Quaternion(0.0, 0.0, 0.71701247, -0.69706035)),
        LocationWithOrientation.Create(Vector4(-2249.031, -874.26, 7.655075, 1.0), Quaternion(0.0, 0.0, 0.7435345, -0.66869766)),
        LocationWithOrientation.Create(Vector4(-2413.2612, -999.73816, 7.9048767, 1.0), Quaternion(0.0, 0.0, 0.6976856, 0.7164041)),
        LocationWithOrientation.Create(Vector4(-2416.763, -1035.4257, 7.90123, 1.0), Quaternion(0.0, 0.0, 0.2863845, 0.95811486)),
        LocationWithOrientation.Create(Vector4(-2420.0608, -1098.0063, 2.4835815, 1.0), Quaternion(0.0, 0.0, 0.80995566, 0.5864912)),
        LocationWithOrientation.Create(Vector4(-2388.4233, -1121.9968, 4.212425, 1.0), Quaternion(0.0, 0.0, -0.9855311, -0.16949476)),
        LocationWithOrientation.Create(Vector4(-2261.5906, -1248.615, 3.2700272, 1.0), Quaternion(0.0, 0.0, -0.5377926, 0.8430771)),
        LocationWithOrientation.Create(Vector4(-2242.8354, -1297.8024, 2.1552277, 1.0), Quaternion(0.0, 0.0, -0.55024314, 0.83500445)),
        LocationWithOrientation.Create(Vector4(-2200.0034, -1340.508, 3.8963013, 1.0), Quaternion(0.0, 0.0, -0.5418359, 0.8404844)),
        LocationWithOrientation.Create(Vector4(-2156.2002, -1347.635, 3.147766, 1.0), Quaternion(0.0, 0.0, 0.8861326, 0.46343178)),
        LocationWithOrientation.Create(Vector4(-2224.0562, -1340.0621, 12.290413, 1.0), Quaternion(0.0, 0.0, -0.20251088, 0.97928)),
        LocationWithOrientation.Create(Vector4(-2255.95, -1281.625, 12.271194, 1.0), Quaternion(0.0, 0.0, -0.5341147, 0.845412)),
        LocationWithOrientation.Create(Vector4(-2232.324, -1217.6643, 12.290413, 1.0), Quaternion(0.0, 0.0, 0.9414182, 0.3372417)),
        LocationWithOrientation.Create(Vector4(-2273.537, -1137.8821, 12.851669, 1.0), Quaternion(0.0, 0.0, -0.9990191, 0.044281982)),
        LocationWithOrientation.Create(Vector4(-2273.4893, -1123.2651, 8.050247, 1.0), Quaternion(0.0, 0.0, 0.95219874, 0.30547932)),
        LocationWithOrientation.Create(Vector4(-2272.2073, -1097.8594, 5.050247, 1.0), Quaternion(0.0, 0.0, 0.95986915, 0.28044832)),
        LocationWithOrientation.Create(Vector4(-2245.5117, -1080.8843, 5.050247, 1.0), Quaternion(0.0, 0.0, 0.37360343, 0.9275885)),
        LocationWithOrientation.Create(Vector4(-2268.3398, -1005.8056, 7.8202515, 1.0), Quaternion(0.0, 0.0, 0.95713276, 0.28964972)),
        LocationWithOrientation.Create(Vector4(-2217.1284, -942.9415, 7.9310226, 1.0), Quaternion(0.0, 0.0, -0.70200425, -0.71217275)),
        LocationWithOrientation.Create(Vector4(-2248.5676, -873.92163, 7.655075, 1.0), Quaternion(0.0, 0.0, -0.7216028, 0.6923073)),
        LocationWithOrientation.Create(Vector4(-2275.5586, -782.65265, 11.061684, 1.0), Quaternion(0.0, 0.0, -0.0351261, -0.999383)),
        LocationWithOrientation.Create(Vector4(-2314.16, -781.2774, 11.5688095, 1.0), Quaternion(0.0, 0.0, -0.005462464, -0.9999851)),
        LocationWithOrientation.Create(Vector4(-2347.952, -796.6771, 19.569885, 1.0), Quaternion(0.0, 0.0, -0.741542, -0.67090654)),
        LocationWithOrientation.Create(Vector4(-2363.757, -815.9417, 19.568314, 1.0), Quaternion(0.0, 0.0, 0.27164403, -0.9623978)),
        LocationWithOrientation.Create(Vector4(-2370.2852, -799.3889, 19.569885, 1.0), Quaternion(0.0, 0.0, 0.023785168, 0.9997171)),
        LocationWithOrientation.Create(Vector4(-2240.7974, -819.254, 19.569885, 1.0), Quaternion(0.0, 0.0, -0.37157643, -0.9284024)),
        LocationWithOrientation.Create(Vector4(-2276.7563, -811.68054, 19.569885, 1.0), Quaternion(0.0, 0.0, -0.9986639, -0.051676665)),
        LocationWithOrientation.Create(Vector4(-2300.4048, -811.9838, 19.569885, 1.0), Quaternion(0.0, 0.0, -0.920247, 0.39133823)),
        LocationWithOrientation.Create(Vector4(-2228.3386, -669.59155, 7.472618, 1.0), Quaternion(0.0, 0.0, 0.684701, -0.72882414)),
        LocationWithOrientation.Create(Vector4(-2237.3943, -630.0635, 7.397148, 1.0), Quaternion(0.0, 0.0, -0.6866062, 0.7270295)),
        LocationWithOrientation.Create(Vector4(-2233.8303, -585.8948, 7.412407, 1.0), Quaternion(0.0, 0.0, -0.9999826, 0.0058982223)),
        LocationWithOrientation.Create(Vector4(-2244.6296, -536.16815, 7.3971405, 1.0), Quaternion(0.0, 0.0, 0.7249188, -0.68883437)),
        LocationWithOrientation.Create(Vector4(-2222.7925, -450.11343, 7.4497833, 1.0), Quaternion(0.0, 0.0, -0.6967005, -0.71736217)),
        LocationWithOrientation.Create(Vector4(-2272.704, -394.10858, 7.421898, 1.0), Quaternion(0.0, 0.0, -0.9988377, 0.048201818)),
        LocationWithOrientation.Create(Vector4(-2249.0823, -365.9779, 7.421898, 1.0), Quaternion(0.0, 0.0, -0.73535466, 0.67768246)),
        LocationWithOrientation.Create(Vector4(-2272.6082, -360.00485, 17.325233, 1.0), Quaternion(0.0, 0.0, -0.6935554, 0.7204033)),
        LocationWithOrientation.Create(Vector4(-2280.7603, -396.83975, 17.330002, 1.0), Quaternion(0.0, 0.0, -0.71431637, 0.69982296)),
        LocationWithOrientation.Create(Vector4(-2250.79, -424.52768, 17.349876, 1.0), Quaternion(0.0, 0.0, -0.7134001, 0.70075697)),
        LocationWithOrientation.Create(Vector4(-2190.094, -403.93106, 17.742851, 1.0), Quaternion(0.0, 0.0, -0.99999714, -0.0023948364)),
        LocationWithOrientation.Create(Vector4(-2191.1736, -439.05792, 17.742851, 1.0), Quaternion(0.0, 0.0, -0.02420906, 0.999707)),
        LocationWithOrientation.Create(Vector4(-2169.5376, -443.94623, 17.770004, 1.0), Quaternion(0.0, 0.0, -0.7143233, -0.69981587)),
        LocationWithOrientation.Create(Vector4(-2185.9326, -330.32556, 17.742844, 1.0), Quaternion(0.0, 0.0, -0.9516629, -0.30714467)),
        LocationWithOrientation.Create(Vector4(-2222.3738, -273.60095, 7.5, 1.0), Quaternion(0.0, 0.0, -0.7072628, 0.7069507)),
        LocationWithOrientation.Create(Vector4(-2223.6145, -247.94882, 7.5199966, 1.0), Quaternion(0.0, 0.0, -0.7088032, 0.7054063)),
        LocationWithOrientation.Create(Vector4(-2183.5913, -181.69667, 7.5598297, 1.0), Quaternion(0.0, 0.0, 0.7097229, 0.70448107)),
        LocationWithOrientation.Create(Vector4(-2178.4463, -154.36499, 8.348129, 1.0), Quaternion(0.0, 0.0, 0.7010627, 0.71309966)),
        LocationWithOrientation.Create(Vector4(-2151.7498, -115.03908, 10.400589, 1.0), Quaternion(0.0, 0.0, -0.034248624, 0.9994134)),
        LocationWithOrientation.Create(Vector4(-2109.7473, -117.47406, 10.446243, 1.0), Quaternion(0.0, 0.0, -0.008947986, 0.99995995)),
        LocationWithOrientation.Create(Vector4(-2077.535, -106.64714, 7.4355927, 1.0), Quaternion(0.0, 0.0, -0.38248575, 0.92396146)),
        LocationWithOrientation.Create(Vector4(-2090.156, -125.83574, 8.235046, 1.0), Quaternion(0.0, 0.0, -0.69009584, 0.72371805)),
        LocationWithOrientation.Create(Vector4(-2088.1084, -136.84819, 8.235039, 1.0), Quaternion(0.0, 0.0, -0.035120916, 0.99938315)),
        LocationWithOrientation.Create(Vector4(-2091.5947, -171.68141, 8.235031, 1.0), Quaternion(0.0, 0.0, -0.70664597, 0.70756733)),
        LocationWithOrientation.Create(Vector4(-2091.4756, -202.12999, 8.250008, 1.0), Quaternion(0.0, 0.0, 0.91292447, -0.40812865)),
        LocationWithOrientation.Create(Vector4(-2337.5913, -98.063034, 8.078529, 1.0), Quaternion(0.0, 0.0, 0.0006515705, 0.9999999)),
        LocationWithOrientation.Create(Vector4(-2341.2024, -124.148056, 13.982193, 1.0), Quaternion(0.0, 0.0, 0.6808782, 0.73239666)),
        LocationWithOrientation.Create(Vector4(-2387.1082, -115.76932, 8.090332, 1.0), Quaternion(0.0, 0.0, 0.68977404, 0.7240248)),
        LocationWithOrientation.Create(Vector4(-2440.5427, -112.636536, 8.12532, 1.0), Quaternion(0.0, 0.0, 0.9610826, -0.27626145)),
        LocationWithOrientation.Create(Vector4(-2483.1829, -104.95531, 8.12532, 1.0), Quaternion(0.0, 0.0, 0.9350562, 0.35449964)),
        LocationWithOrientation.Create(Vector4(-2504.4155, -91.26437, 7.957611, 1.0), Quaternion(0.0, 0.0, -0.004150232, 0.9999914))
    ];

    public static func PacificaLocations() -> array<ref<LocationWithOrientation>> = [
        LocationWithOrientation.Create(Vector4(-2651.145, -2461.1367, 18.039314, 1.0), Quaternion(0.0, 0.0, 0.8211908, 0.57065386)),
        LocationWithOrientation.Create(Vector4(-2679.1506, -2455.0046, 18.039314, 1.0), Quaternion(0.0, 0.0, -0.43752086, 0.89920837)),
        LocationWithOrientation.Create(Vector4(-2786.15, -2480.6128, 30.89811, 1.0), Quaternion(0.0, 0.0, -0.5169241, 0.8560313)),
        LocationWithOrientation.Create(Vector4(-2781.4, -2458.149, 29.91845, 1.0), Quaternion(0.0, 0.0, -0.9998831, -0.01529121)),
        LocationWithOrientation.Create(Vector4(-2741.9995, -2430.8708, 18.033089, 1.0), Quaternion(0.0, 0.0, 0.8548218, 0.51892173)),
        LocationWithOrientation.Create(Vector4(-2712.1472, -2409.0444, 6.0330887, 1.0), Quaternion(0.0, 0.0, 0.9698079, -0.24387018)),
        LocationWithOrientation.Create(Vector4(-2631.0286, -2375.1226, 6.298584, 1.0), Quaternion(0.0, 0.0, -0.79984254, -0.60021)),
        LocationWithOrientation.Create(Vector4(-2550.7732, -2344.4832, 8.244186, 1.0), Quaternion(0.0, 0.0, 0.53449917, -0.84516907)),
        LocationWithOrientation.Create(Vector4(-2503.9517, -2301.4539, 8.370331, 1.0), Quaternion(0.0, 0.0, 0.989234, -0.14634284)),
        LocationWithOrientation.Create(Vector4(-2409.7417, -2348.8145, 10.373238, 1.0), Quaternion(0.0, 0.0, -0.63257045, -0.7745028)),
        LocationWithOrientation.Create(Vector4(-2381.7847, -2336.274, 10.357048, 1.0), Quaternion(0.0, 0.0, -0.10782568, -0.9941699)),
        LocationWithOrientation.Create(Vector4(-2384.531, -2280.526, 11.507637, 1.0), Quaternion(0.0, 0.0, 0.6728203, -0.73980594)),
        LocationWithOrientation.Create(Vector4(-2336.2346, -2183.3252, 11.829834, 1.0), Quaternion(0.0, 0.0, 0.99763674, -0.06870962)),
        LocationWithOrientation.Create(Vector4(-2308.5703, -2155.8, 11.829834, 1.0), Quaternion(0.0, 0.0, 0.6699101, -0.7424423)),
        LocationWithOrientation.Create(Vector4(-2274.5203, -2104.3103, 13.294281, 1.0), Quaternion(0.0, 0.0, 0.92527676, -0.37929267)),
        LocationWithOrientation.Create(Vector4(-2248.6987, -2079.2722, 11.872383, 1.0), Quaternion(0.0, 0.0, -0.920744, 0.39016736)),
        LocationWithOrientation.Create(Vector4(-2230.697, -2063.3625, 11.872383, 1.0), Quaternion(0.0, 0.0, -0.6175177, 0.78655696)),
        LocationWithOrientation.Create(Vector4(-2151.7532, -2102.9612, 11.65654, 1.0), Quaternion(0.0, 0.0, -0.9217945, -0.38767895)),
        LocationWithOrientation.Create(Vector4(-2142.1533, -2150.4297, 12.052849, 1.0), Quaternion(0.0, 0.0, -0.7318271, -0.68149036)),
        LocationWithOrientation.Create(Vector4(-2175.8, -2186.7668, 11.872383, 1.0), Quaternion(0.0, 0.0, -0.82154584, -0.5701426)),
        LocationWithOrientation.Create(Vector4(-2121.3582, -2271.2932, 18.097458, 1.0), Quaternion(0.0, 0.0, 0.086979076, 0.9962102)),
        LocationWithOrientation.Create(Vector4(-2171.2554, -2330.1763, 14.802597, 1.0), Quaternion(0.0, 0.0, 0.37039277, 0.92887527)),
        LocationWithOrientation.Create(Vector4(-2066.4067, -2151.359, 18.556442, 1.0), Quaternion(0.0, 0.0, -0.99999726, -0.0023590776)),
        LocationWithOrientation.Create(Vector4(-2047.1361, -2123.6736, 19.658005, 1.0), Quaternion(0.0, 0.0, 0.7063068, -0.7079058)),
        LocationWithOrientation.Create(Vector4(-2038.3541, -2114.2402, 20.637444, 1.0), Quaternion(0.0, 0.0, 0.89108735, -0.4538318)),
        LocationWithOrientation.Create(Vector4(-1941.8092, -2060.4639, 29.136574, 1.0), Quaternion(0.0, 0.0, -0.99999124, 0.0041855476)),
        LocationWithOrientation.Create(Vector4(-1926.4213, -2049.301, 30.163841, 1.0), Quaternion(0.0, 0.0, -0.89286256, 0.4503294)),
        LocationWithOrientation.Create(Vector4(-1829.6085, -1978.3262, 43.731155, 1.0), Quaternion(0.0, 0.0, 0.9734385, 0.22894862)),
        LocationWithOrientation.Create(Vector4(-1810.9631, -1986.8912, 43.731155, 1.0), Quaternion(0.0, 0.0, 0.9634662, 0.26783)),
        LocationWithOrientation.Create(Vector4(-1790.2805, -1978.6041, 43.7349, 1.0), Quaternion(0.0, 0.0, 0.97323817, 0.22979882)),
        LocationWithOrientation.Create(Vector4(-1779.4575, -1962.2264, 50.489113, 1.0), Quaternion(0.0, 0.0, -0.997899, 0.064789444)),
        LocationWithOrientation.Create(Vector4(-2640.6558, -2522.4043, 21.525581, 1.0), Quaternion(0.0, 0.0, -0.5339215, 0.84553415)),
        LocationWithOrientation.Create(Vector4(-2632.8037, -2470.241, 42.99633, 1.0), Quaternion(0.0, 0.0, 0.85585475, 0.51721627)),
        LocationWithOrientation.Create(Vector4(-2614.1355, -2466.9478, 42.99633, 1.0), Quaternion(0.0, 0.0, -0.49804458, 0.8671515)),
        LocationWithOrientation.Create(Vector4(-2552.843, -2445.855, 16.961105, 1.0), Quaternion(0.0, 0.0, 0.97366136, -0.2279992)),
        LocationWithOrientation.Create(Vector4(-2502.215, -2441.0925, 16.696945, 1.0), Quaternion(0.0, 0.0, 0.84436864, 0.5357627)),
        LocationWithOrientation.Create(Vector4(-2471.3687, -2465.9834, 16.583435, 1.0), Quaternion(0.0, 0.0, 0.9740577, -0.22630008)),
        LocationWithOrientation.Create(Vector4(-2482.1382, -2441.235, 17.587517, 1.0), Quaternion(0.0, 0.0, -0.97366124, 0.22799984)),
        LocationWithOrientation.Create(Vector4(-2475.4097, -2453.8718, 17.587517, 1.0), Quaternion(0.0, 0.0, -0.539442, 0.8420228)),
        LocationWithOrientation.Create(Vector4(-2472.4966, -2405.5527, 16.626541, 1.0), Quaternion(0.0, 0.0, -0.89451116, 0.4470457)),
        LocationWithOrientation.Create(Vector4(-2459.1997, -2388.5955, 16.764168, 1.0), Quaternion(0.0, 0.0, -0.9936788, -0.11226143)),
        LocationWithOrientation.Create(Vector4(-2477.7786, -2381.317, 12.910118, 1.0), Quaternion(0.0, 0.0, 0.9748416, -0.22289898)),
        LocationWithOrientation.Create(Vector4(-2572.0654, -2372.663, 10.300163, 1.0), Quaternion(0.0, 0.0, 0.1685643, 0.9856908)),
        LocationWithOrientation.Create(Vector4(-2697.5112, -2525.6675, 17.250008, 1.0), Quaternion(0.0, 0.0, -0.5328118, 0.84623384)),
        LocationWithOrientation.Create(Vector4(-2718.589, -2497.5532, 19.266533, 1.0), Quaternion(0.0, 0.0, -0.9796475, 0.2007258)),
        LocationWithOrientation.Create(Vector4(-2768.3223, -2492.98, 17.896736, 1.0), Quaternion(0.0, 0.0, 0.49879992, -0.86671716)),
        LocationWithOrientation.Create(Vector4(-2855.9124, -2477.896, 15.729996, 1.0), Quaternion(0.0, 0.0, 0.18644898, -0.98246473)),
        LocationWithOrientation.Create(Vector4(-2836.0322, -2486.0796, 15.729996, 1.0), Quaternion(0.0, 0.0, -0.5789878, -0.8153362)),
        LocationWithOrientation.Create(Vector4(-2822.6733, -2514.3833, 15.730003, 1.0), Quaternion(0.0, 0.0, 0.83536977, 0.5496885)),
        LocationWithOrientation.Create(Vector4(-2820.1985, -2549.009, 16.702774, 1.0), Quaternion(0.0, 0.0, 0.20200692, 0.9793842)),
        LocationWithOrientation.Create(Vector4(-2778.8667, -2602.936, 26.161911, 1.0), Quaternion(0.0, 0.0, -0.009523642, 0.99995464)),
        LocationWithOrientation.Create(Vector4(-2759.7664, -2597.5452, 26.161911, 1.0), Quaternion(0.0, 0.0, 0.64518225, 0.76402867)),
        LocationWithOrientation.Create(Vector4(-2725.3105, -2580.2148, 26.161911, 1.0), Quaternion(0.0, 0.0, 0.7203009, 0.6936618)),
        LocationWithOrientation.Create(Vector4(-2733.9136, -2561.5752, 30.395988, 1.0), Quaternion(0.0, 0.0, -0.97503585, 0.22204733)),
        LocationWithOrientation.Create(Vector4(-2742.6636, -2542.443, 29.914589, 1.0), Quaternion(0.0, 0.0, -0.93276906, 0.36047462)),
        LocationWithOrientation.Create(Vector4(-2742.4138, -2424.647, 18.05217, 1.0), Quaternion(0.0, 0.0, 0.9741565, -0.22587441)),
        LocationWithOrientation.Create(Vector4(-2773.9863, -2473.202, 17.885918, 1.0), Quaternion(0.0, 0.0, 0.5485957, -0.8360878)),
        LocationWithOrientation.Create(Vector4(-2823.0642, -2354.325, 15.669289, 1.0), Quaternion(0.0, 0.0, 0.5242933, -0.8515377)),
        LocationWithOrientation.Create(Vector4(-2836.015, -2178.0088, 15.813644, 1.0), Quaternion(0.0, 0.0, 0.7163547, 0.6977363)),
        LocationWithOrientation.Create(Vector4(-2405.6057, -1951.944, 2.4088745, 1.0), Quaternion(0.0, 0.0, 0.38919842, 0.92115396)),
        LocationWithOrientation.Create(Vector4(-2339.3777, -1919.4292, 6.33963, 1.0), Quaternion(0.0, 0.0, -0.32879043, 0.9444029)),
        LocationWithOrientation.Create(Vector4(-2337.8086, -1878.7451, 2.5091705, 1.0), Quaternion(0.0, 0.0, 0.9151683, 0.40307206)),
        LocationWithOrientation.Create(Vector4(-2385.6846, -1844.6621, 0.5327835, 1.0), Quaternion(0.0, 0.0, 0.93323845, -0.35925776)),
        LocationWithOrientation.Create(Vector4(-2225.5195, -1886.2861, 2.17247, 1.0), Quaternion(0.0, 0.0, -0.35395816, -0.9352613)),
        LocationWithOrientation.Create(Vector4(-2234.7866, -1928.4927, 5.0645905, 1.0), Quaternion(0.0, 0.0, -0.38879582, -0.92132396)),
        LocationWithOrientation.Create(Vector4(-2217.378, -1926.0277, 5.085228, 1.0), Quaternion(0.0, 0.0, -0.28241804, -0.9592915)),
        LocationWithOrientation.Create(Vector4(-2193.68, -1944.488, 5.4429092, 1.0), Quaternion(0.0, 0.0, 0.67392117, -0.73880327)),
        LocationWithOrientation.Create(Vector4(-2176.9807, -1964.5283, 6.1157, 1.0), Quaternion(0.0, 0.0, -0.3239927, -0.9460597)),
        LocationWithOrientation.Create(Vector4(-2122.057, -1978.168, 15.591721, 1.0), Quaternion(0.0, 0.0, 0.92441005, 0.38140023)),
        LocationWithOrientation.Create(Vector4(-2092.6028, -2004.363, 15.577034, 1.0), Quaternion(0.0, 0.0, 0.81894714, 0.57386893)),
        LocationWithOrientation.Create(Vector4(-2106.016, -2032.8729, 14.82251, 1.0), Quaternion(0.0, 0.0, 0.4008214, 0.91615623)),
        LocationWithOrientation.Create(Vector4(-2133.4373, -2072.576, 15.639351, 1.0), Quaternion(0.0, 0.0, -0.11631644, -0.9932123)),
        LocationWithOrientation.Create(Vector4(-2177.1504, -2099.3179, 11.648064, 1.0), Quaternion(0.0, 0.0, -0.6329818, 0.77416664)),
        LocationWithOrientation.Create(Vector4(-2200.1113, -2116.925, 11.648003, 1.0), Quaternion(0.0, 0.0, -0.9101093, 0.41436848)),
        LocationWithOrientation.Create(Vector4(-2256.2297, -2092.6082, 13.296631, 1.0), Quaternion(0.0, 0.0, -0.92534506, 0.3791262)),
        LocationWithOrientation.Create(Vector4(-2274.9556, -2104.7776, 13.294281, 1.0), Quaternion(0.0, 0.0, -0.9279691, 0.37265727)),
        LocationWithOrientation.Create(Vector4(-2285.3257, -2117.263, 13.298943, 1.0), Quaternion(0.0, 0.0, -0.92132396, 0.38879573)),
        LocationWithOrientation.Create(Vector4(-2300.8362, -2143.1316, 11.646416, 1.0), Quaternion(0.0, 0.0, -0.71502703, 0.6990968)),
        LocationWithOrientation.Create(Vector4(-2314.0442, -2143.9412, 11.829842, 1.0), Quaternion(0.0, 0.0, -0.8191059, 0.57364225)),
        LocationWithOrientation.Create(Vector4(-2336.2817, -2182.4424, 11.829834, 1.0), Quaternion(0.0, 0.0, -0.9901961, 0.13968442)),
        LocationWithOrientation.Create(Vector4(-2339.7012, -2225.905, 11.915558, 1.0), Quaternion(0.0, 0.0, -0.917723, 0.397221)),
        LocationWithOrientation.Create(Vector4(-2308.1692, -2260.661, 11.927803, 1.0), Quaternion(0.0, 0.0, 0.32976583, 0.94406277)),
        LocationWithOrientation.Create(Vector4(-2278.7527, -2228.6284, 11.642075, 1.0), Quaternion(0.0, 0.0, -0.91215277, -0.40985024)),
        LocationWithOrientation.Create(Vector4(-2270.732, -2273.86, 11.932388, 1.0), Quaternion(0.0, 0.0, -0.3974748, 0.9176132)),
        LocationWithOrientation.Create(Vector4(-2240.0413, -2283.7375, 12.059151, 1.0), Quaternion(0.0, 0.0, 0.40082204, 0.9161559)),
        LocationWithOrientation.Create(Vector4(-2198.8782, -2259.4143, 8.040192, 1.0), Quaternion(0.0, 0.0, 0.3474193, 0.93770987)),
        LocationWithOrientation.Create(Vector4(-2171.375, -2194.022, 11.938049, 1.0), Quaternion(0.0, 0.0, -0.9884394, 0.15161647)),
        LocationWithOrientation.Create(Vector4(-2148.1719, -2115.3394, 11.648064, 1.0), Quaternion(0.0, 0.0, -0.9300693, -0.3673842)),
        LocationWithOrientation.Create(Vector4(-2176.7627, -2016.8865, 11.715164, 1.0), Quaternion(0.0, 0.0, 0.99145484, -0.1304503)),
        LocationWithOrientation.Create(Vector4(-2234.0005, -2001.5148, 7.021858, 1.0), Quaternion(0.0, 0.0, -0.6984708, 0.71563864)),
        LocationWithOrientation.Create(Vector4(-2148.7524, -1838.5138, 0.9771805, 1.0), Quaternion(0.0, 0.0, -0.98197323, 0.18901996)),
        LocationWithOrientation.Create(Vector4(-2103.7449, -1796.7743, 0.8653717, 1.0), Quaternion(0.0, 0.0, -0.8538179, 0.5205719)),
        LocationWithOrientation.Create(Vector4(-2032.0908, -1777.1533, 4.3227615, 1.0), Quaternion(0.0, 0.0, -0.19944225, 0.97990966)),
        LocationWithOrientation.Create(Vector4(-2021.2378, -1750.6561, 4.3134766, 1.0), Quaternion(0.0, 0.0, -0.98747075, -0.15780205)),
        LocationWithOrientation.Create(Vector4(-1898.2566, -1617.773, 5.928978, 1.0), Quaternion(0.0, 0.0, 0.8533629, -0.5213174)),
        LocationWithOrientation.Create(Vector4(-1863.0333, -1631.6328, 18.023087, 1.0), Quaternion(0.0, 0.0, 0.52354914, 0.85199547)),
        LocationWithOrientation.Create(Vector4(-1832.9523, -1602.5161, 18.127274, 1.0), Quaternion(0.0, 0.0, 0.5649045, 0.8251564)),
        LocationWithOrientation.Create(Vector4(-1827.5952, -1561.3677, 17.264732, 1.0), Quaternion(0.0, 0.0, 0.939816, 0.34168124)),
        LocationWithOrientation.Create(Vector4(-1861.5405, -1558.036, 10.661949, 1.0), Quaternion(0.0, 0.0, 0.910833, 0.4127752)),
        LocationWithOrientation.Create(Vector4(-1916.1045, -1531.4121, 0.80500793, 1.0), Quaternion(0.0, 0.0, -0.9599484, 0.2801768))
    ];

    public static func GetRaidLocation(location: RaidLocation) -> ref<LocationWithOrientation> {
        switch location {
            case RaidLocation.Watson:
                return RaidLocations.GetRandomLocation(RaidLocations.WatsonLocations());
            case RaidLocation.SantoDomingo:
                return RaidLocations.GetRandomLocation(RaidLocations.SantoDomingoLocations());
            case RaidLocation.Badlands:
                return RaidLocations.GetRandomLocation(RaidLocations.BadlandsLocations());
            case RaidLocation.Westbrook:
                return RaidLocations.GetRandomLocation(RaidLocations.WestbrookLocations());
            case RaidLocation.Heywood:
                return RaidLocations.GetRandomLocation(RaidLocations.HeywoodLocations());
            case RaidLocation.Pacifica:
                return RaidLocations.GetRandomLocation(RaidLocations.PacificaLocations());
            default:
                return RaidLocations.GetRandomLocation(RaidLocations.WatsonLocations());
        }
    }

    private static func GetRandomLocation(locations: array<ref<LocationWithOrientation>>) -> ref<LocationWithOrientation> {
        let playerState = PlayerStateSystem.Get();
        if !IsDefined(playerState) {
            return null;
        }
        let totalLocations = ArraySize(locations);
        let pickedLocation: ref<LocationWithOrientation>;

        // Reroll until we find a location not amongst last remembered ones
        let i = 0;
        while i < totalLocations {
            pickedLocation = locations[RandRange(0, totalLocations)];
            if !playerState.IsRecentRaidLocation(pickedLocation.location) {
                // Legit new location
                break;
            }
            i += 1;
        }

        // Remember the location
        playerState.RememberRaidLocation(pickedLocation.location);
        return pickedLocation;
    }
}

