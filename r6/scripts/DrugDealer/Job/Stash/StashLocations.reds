module DrugDealer.Job.Stash

import NightlyNow.Utils.LocationWithOrientation

// -----------------------------------------------------------------------------
// StashLocations - Drug Dealer
// -----------------------------------------------------------------------------
public enum StashLocation {
    Watson = 0,
    SantoDomingo = 1,
    Badlands = 2,
    Westbrook = 3,
    Heywood = 4,
    Pacifica = 5,
}

public abstract class StashLocations {
    public static func WatsonLocations() -> array<ref<LocationWithOrientation>> = [
        LocationWithOrientation.Create(Vector4(-1473.6001, 2982.1165, 11.083351, 1.0), Quaternion(0.0, 0.0, -0.46561584, 0.884987)),
        LocationWithOrientation.Create(Vector4(-1467.7876, 2988.1565, 11.083351, 1.0), Quaternion(0.0, 0.0, -0.8870116, 0.4617472)),
        LocationWithOrientation.Create(Vector4(-1474.0875, 2981.6494, 11.083351, 1.0), Quaternion(0.0, 0.0, -0.42893684, 0.9033345)),
        LocationWithOrientation.Create(Vector4(-1452.0369, 3019.9985, -8.580231, 1.0), Quaternion(0.0, 0.0, 0.31688896, 0.9484627)),
        LocationWithOrientation.Create(Vector4(-1461.3889, 3054.2903, -8.645058, 1.0), Quaternion(0.0, 0.0, 0.9947478, -0.102356166)),
        LocationWithOrientation.Create(Vector4(-1502.356, 3042.8499, -8.200211, 1.0), Quaternion(0.0, 0.0, -0.71477896, 0.6993505)),
        LocationWithOrientation.Create(Vector4(-1513.0728, 3052.1165, -8.748077, 1.0), Quaternion(0.0, 0.0, -0.66327435, 0.74837637)),
        LocationWithOrientation.Create(Vector4(-1584.8708, 3168.7495, 6.973503, 1.0), Quaternion(0.0, 0.0, -0.59096175, 0.80669963)),
        LocationWithOrientation.Create(Vector4(-1570.6984, 3156.749, 7.1013184, 1.0), Quaternion(0.0, 0.0, -0.85400784, 0.5202601)),
        LocationWithOrientation.Create(Vector4(-1639.8788, 3221.037, 7.1430664, 1.0), Quaternion(0.0, 0.0, 0.6444148, 0.76467615)),
        LocationWithOrientation.Create(Vector4(-1608.175, 3402.1074, 7.117531, 1.0), Quaternion(0.0, 0.0, 0.9957599, 0.091990046)),
        LocationWithOrientation.Create(Vector4(-1613.1266, 3410.0574, 7.1114426, 1.0), Quaternion(0.0, 0.0, 0.9999978, -0.0021272195)),
        LocationWithOrientation.Create(Vector4(-1628.117, 3450.8838, 0.5784378, 1.0), Quaternion(0.0, 0.0, 0.3197358, 0.94750684)),
        LocationWithOrientation.Create(Vector4(-1623.9332, 3453.685, 0.962677, 1.0), Quaternion(0.0, 0.0, 0.30689052, 0.9517449)),
        LocationWithOrientation.Create(Vector4(-1613.4536, 3460.734, 1.9273071, 1.0), Quaternion(0.0, 0.0, 0.31973505, 0.947507)),
        LocationWithOrientation.Create(Vector4(-1604.0364, 3467.0833, 2.876442, 1.0), Quaternion(0.0, 0.0, 0.3521996, 0.93592495)),
        LocationWithOrientation.Create(Vector4(-1545.531, 3555.23, 3.4197693, 1.0), Quaternion(0.0, 0.0, -0.88743854, 0.46092623)),
        LocationWithOrientation.Create(Vector4(-1530.2188, 3569.2366, 3.9376984, 1.0), Quaternion(0.0, 0.0, -0.989908, 0.14171161)),
        LocationWithOrientation.Create(Vector4(-1489.1176, 3588.074, 5.4283752, 1.0), Quaternion(0.0, 0.0, -0.993126, 0.11705062)),
        LocationWithOrientation.Create(Vector4(-1469.1377, 3595.625, 5.378372, 1.0), Quaternion(0.0, 0.0, -0.9900312, 0.1408486)),
        LocationWithOrientation.Create(Vector4(-1409.7166, 3587.0063, 6.3735123, 1.0), Quaternion(0.0, 0.0, -0.90848565, -0.4179163)),
        LocationWithOrientation.Create(Vector4(-1293.8574, 3585.6318, 16.099297, 1.0), Quaternion(0.0, 0.0, -0.19589137, -0.9806256)),
        LocationWithOrientation.Create(Vector4(-1195.612, 3522.498, 8.506149, 1.0), Quaternion(0.0, 0.0, 0.28532356, -0.9584313)),
        LocationWithOrientation.Create(Vector4(-1155.5875, 3306.073, 9.115265, 1.0), Quaternion(0.0, 0.0, 0.3758344, -0.9266868)),
        LocationWithOrientation.Create(Vector4(-1075.2216, 3317.0894, 7.118721, 1.0), Quaternion(0.0, 0.0, -0.98889804, 0.1485956)),
        LocationWithOrientation.Create(Vector4(-1007.23566, 3364.733, 11.625961, 1.0), Quaternion(0.0, 0.0, -0.2757398, -0.9612324)),
        LocationWithOrientation.Create(Vector4(-1020.96045, 3343.3328, 16.59156, 1.0), Quaternion(0.0, 0.0, -0.091273, 0.99582595)),
        LocationWithOrientation.Create(Vector4(-1021.84106, 3347.2153, 14.544907, 1.0), Quaternion(0.0, 0.0, -0.24042894, 0.97066677)),
        LocationWithOrientation.Create(Vector4(-1018.14087, 3346.7087, 14.544899, 1.0), Quaternion(0.0, 0.0, 0.18331943, 0.98305345)),
        LocationWithOrientation.Create(Vector4(-990.2398, 3351.928, 7.509079, 1.0), Quaternion(0.0, 0.0, 0.92759633, 0.37358406)),
        LocationWithOrientation.Create(Vector4(-984.3396, 3589.4434, 7.1182556, 1.0), Quaternion(0.0, 0.0, -0.8479459, -0.5300828)),
        LocationWithOrientation.Create(Vector4(-980.17816, 3618.946, 7.1180115, 1.0), Quaternion(0.0, 0.0, -0.72011447, -0.6938553)),
        LocationWithOrientation.Create(Vector4(-937.0842, 3612.6926, 14.747086, 1.0), Quaternion(0.0, 0.0, 0.060806237, -0.99814963)),
        LocationWithOrientation.Create(Vector4(-915.9212, 3594.9175, 14.747086, 1.0), Quaternion(0.0, 0.0, 0.78462595, -0.6199694)),
        LocationWithOrientation.Create(Vector4(-813.52277, 3485.3826, 7.1724396, 1.0), Quaternion(0.0, 0.0, 0.74290305, 0.6693991)),
        LocationWithOrientation.Create(Vector4(-680.4076, 3337.078, 9.492416, 1.0), Quaternion(0.0, 0.0, 0.8956204, -0.44481927)),
        LocationWithOrientation.Create(Vector4(-676.51807, 3341.7676, 8.208366, 1.0), Quaternion(0.0, 0.0, 0.88203025, -0.4711929)),
        LocationWithOrientation.Create(Vector4(-649.8523, 3335.3594, 9.337669, 1.0), Quaternion(0.0, 0.0, 0.50809056, 0.8613037)),
        LocationWithOrientation.Create(Vector4(-676.7615, 3298.0396, 9.114655, 1.0), Quaternion(0.0, 0.0, 0.40373167, 0.9148774)),
        LocationWithOrientation.Create(Vector4(-681.301, 3294.2722, 8.240974, 1.0), Quaternion(0.0, 0.0, 0.5462727, 0.8376074)),
        LocationWithOrientation.Create(Vector4(-847.0009, 2982.4558, 22.13453, 1.0), Quaternion(0.0, 0.0, 0.9846224, -0.17469637)),
        LocationWithOrientation.Create(Vector4(-620.06415, 3205.2295, 7.2898407, 1.0), Quaternion(0.0, 0.0, -0.6506766, 0.7593549)),
        LocationWithOrientation.Create(Vector4(-631.09033, 3190.1128, 7.428467, 1.0), Quaternion(0.0, 0.0, 0.65549755, 0.7551974)),
        LocationWithOrientation.Create(Vector4(-505.3349, 3043.1133, 5.4342957, 1.0), Quaternion(0.0, 0.0, 0.5307567, 0.8475242)),
        LocationWithOrientation.Create(Vector4(-537.0975, 3229.451, 7.359375, 1.0), Quaternion(0.0, 0.0, -0.7723838, 0.63515615)),
        LocationWithOrientation.Create(Vector4(-538.33936, 3237.7961, 5.100876, 1.0), Quaternion(0.0, 0.0, 0.15675177, -0.98763806)),
        LocationWithOrientation.Create(Vector4(-517.94324, 3261.7634, 5.0726166, 1.0), Quaternion(0.0, 0.0, -0.80496216, -0.5933262)),
        LocationWithOrientation.Create(Vector4(-522.53, 3289.3362, 5.120125, 1.0), Quaternion(0.0, 0.0, -0.9618923, -0.27342856)),
        LocationWithOrientation.Create(Vector4(-519.01416, 3345.3506, 4.3181076, 1.0), Quaternion(0.0, 0.0, 0.07280296, 0.99734634)),
        LocationWithOrientation.Create(Vector4(-522.7498, 3317.016, 4.6230164, 1.0), Quaternion(0.0, 0.0, 0.54463863, 0.8386709)),
        LocationWithOrientation.Create(Vector4(-577.22766, 3163.2783, 8.628487, 1.0), Quaternion(0.0, 0.0, -0.31099597, 0.95041126)),
        LocationWithOrientation.Create(Vector4(-586.4697, 3153.8838, 7.14843, 1.0), Quaternion(0.0, 0.0, 0.6062564, -0.79526925)),
        LocationWithOrientation.Create(Vector4(-586.00195, 3146.0732, 7.1541977, 1.0), Quaternion(0.0, 0.0, 0.99935645, -0.03587161)),
        LocationWithOrientation.Create(Vector4(-623.08954, 3068.8894, 8.873764, 1.0), Quaternion(0.0, 0.0, 0.30767655, -0.951491)),
        LocationWithOrientation.Create(Vector4(-614.57935, 3058.0874, 11.189278, 1.0), Quaternion(0.0, 0.0, 0.21974862, -0.9755566)),
        LocationWithOrientation.Create(Vector4(-543.14764, 2963.0278, 17.951126, 1.0), Quaternion(0.0, 0.0, -0.91154253, 0.41120592)),
        LocationWithOrientation.Create(Vector4(-543.45593, 2890.069, 28.85144, 1.0), Quaternion(0.0, 0.0, -0.15978457, 0.9871519)),
        LocationWithOrientation.Create(Vector4(-534.4115, 2876.1006, 29.116684, 1.0), Quaternion(0.0, 0.0, -0.82382303, 0.566847)),
        LocationWithOrientation.Create(Vector4(-536.27795, 2781.9683, 37.973633, 1.0), Quaternion(0.0, 0.0, -0.7250059, 0.68874276)),
        LocationWithOrientation.Create(Vector4(-557.3783, 2751.927, 47.372215, 1.0), Quaternion(0.0, 0.0, -0.5968451, 0.80235654)),
        LocationWithOrientation.Create(Vector4(-569.0807, 2719.0378, 49.38221, 1.0), Quaternion(0.0, 0.0, 0.9833952, -0.18147688)),
        LocationWithOrientation.Create(Vector4(-607.9299, 2719.1338, 49.909317, 1.0), Quaternion(0.0, 0.0, 0.39001983, 0.9208065)),
        LocationWithOrientation.Create(Vector4(-585.31506, 2660.4758, 60.06176, 1.0), Quaternion(0.0, 0.0, -0.27381906, 0.9617813)),
        LocationWithOrientation.Create(Vector4(-590.54333, 2664.1125, 59.92891, 1.0), Quaternion(0.0, 0.0, -0.3109528, 0.95042545)),
        LocationWithOrientation.Create(Vector4(-608.1843, 2672.9136, 59.929115, 1.0), Quaternion(0.0, 0.0, 0.4645844, 0.8855289)),
        LocationWithOrientation.Create(Vector4(-593.83545, 2635.1152, 53.58886, 1.0), Quaternion(0.0, 0.0, 0.79714495, 0.60378796)),
        LocationWithOrientation.Create(Vector4(-627.0924, 2524.7341, 53.763, 1.0), Quaternion(0.0, 0.0, 0.41085124, 0.9117025)),
        LocationWithOrientation.Create(Vector4(-646.58777, 2505.2415, 53.7631, 1.0), Quaternion(0.0, 0.0, 0.34338677, 0.9391942)),
        LocationWithOrientation.Create(Vector4(-661.19836, 2493.3489, 53.7631, 1.0), Quaternion(0.0, 0.0, -0.08396825, 0.9964685)),
        LocationWithOrientation.Create(Vector4(-696.1128, 2522.378, 53.74436, 1.0), Quaternion(0.0, 0.0, -0.3084647, 0.95123583)),
        LocationWithOrientation.Create(Vector4(-787.05554, 2373.6023, 53.75721, 1.0), Quaternion(0.0, 0.0, 0.25136325, 0.9678928)),
        LocationWithOrientation.Create(Vector4(-807.97644, 2408.167, 57.49785, 1.0), Quaternion(0.0, 0.0, -0.50100887, 0.8654422)),
        LocationWithOrientation.Create(Vector4(-819.031, 2400.8381, 56.56504, 1.0), Quaternion(0.0, 0.0, -0.92875594, 0.37069196)),
        LocationWithOrientation.Create(Vector4(-836.1525, 2389.888, 55.84504, 1.0), Quaternion(0.0, 0.0, -0.896035, 0.4439835)),
        LocationWithOrientation.Create(Vector4(-841.33154, 2387.3113, 58.645042, 1.0), Quaternion(0.0, 0.0, -0.9347227, -0.35537812)),
        LocationWithOrientation.Create(Vector4(-842.4521, 2388.4058, 58.645042, 1.0), Quaternion(0.0, 0.0, -0.9406345, -0.33942133)),
        LocationWithOrientation.Create(Vector4(-843.8429, 2389.7085, 58.645042, 1.0), Quaternion(0.0, 0.0, -0.9288638, -0.3704214)),
        LocationWithOrientation.Create(Vector4(-887.2561, 2338.6448, 57.161743, 1.0), Quaternion(0.0, 0.0, 0.9185086, -0.39540127)),
        LocationWithOrientation.Create(Vector4(-882.69745, 2343.276, 57.161743, 1.0), Quaternion(0.0, 0.0, 0.9209068, -0.38978302)),
        LocationWithOrientation.Create(Vector4(-879.1085, 2348.4495, 57.161743, 1.0), Quaternion(0.0, 0.0, -0.91133875, -0.41165742)),
        LocationWithOrientation.Create(Vector4(-2201.4204, 2773.5107, 7.1181107, 1.0), Quaternion(0.0, 0.0, 0.9214086, -0.3885952)),
        LocationWithOrientation.Create(Vector4(-2202.257, 2760.7651, 7.1181107, 1.0), Quaternion(0.0, 0.0, -0.97521544, -0.22125737)),
        LocationWithOrientation.Create(Vector4(-2217.8047, 2757.073, 30.395767, 1.0), Quaternion(0.0, 0.0, 0.88875407, 0.4583845)),
        LocationWithOrientation.Create(Vector4(-2188.3352, 2738.4355, 27.264946, 1.0), Quaternion(0.0, 0.0, -0.2851389, -0.9584862)),
        LocationWithOrientation.Create(Vector4(-2162.3372, 2753.474, 27.26326, 1.0), Quaternion(0.0, 0.0, -0.50176984, -0.8650012)),
        LocationWithOrientation.Create(Vector4(-2163.5183, 2750.2458, 23.63031, 1.0), Quaternion(0.0, 0.0, -0.95786184, 0.2872294)),
        LocationWithOrientation.Create(Vector4(-2176.6929, 2742.6523, 23.627495, 1.0), Quaternion(0.0, 0.0, -0.9675234, 0.25278166)),
        LocationWithOrientation.Create(Vector4(-2184.4443, 2738.2104, 23.621635, 1.0), Quaternion(0.0, 0.0, -0.9695858, 0.244752)),
        LocationWithOrientation.Create(Vector4(-2166.8813, 2695.3948, 27.263672, 1.0), Quaternion(0.0, 0.0, -0.05987794, 0.9982057)),
        LocationWithOrientation.Create(Vector4(-2178.1892, 2687.4753, 29.561478, 1.0), Quaternion(0.0, 0.0, -0.9594755, 0.2817923)),
        LocationWithOrientation.Create(Vector4(-2185.4465, 2693.6562, 29.515495, 1.0), Quaternion(0.0, 0.0, -0.67645484, -0.7364842)),
        LocationWithOrientation.Create(Vector4(-2136.6633, 2709.9233, 7.117981, 1.0), Quaternion(0.0, 0.0, 0.9903476, -0.13860588)),
        LocationWithOrientation.Create(Vector4(-2172.51, 2797.2886, 7.1181183, 1.0), Quaternion(0.0, 0.0, 0.96045315, -0.2784418)),
        LocationWithOrientation.Create(Vector4(-2152.447, 2817.2488, 7.203079, 1.0), Quaternion(0.0, 0.0, -0.34639934, -0.93808717)),
        LocationWithOrientation.Create(Vector4(-2101.6973, 2785.2017, 7.117981, 1.0), Quaternion(0.0, 0.0, 0.19067596, 0.9816531)),
        LocationWithOrientation.Create(Vector4(-2087.1123, 2741.4, 7.100212, 1.0), Quaternion(0.0, 0.0, -0.9285365, 0.3712412)),
        LocationWithOrientation.Create(Vector4(-2085.9773, 2728.5398, 7.110306, 1.0), Quaternion(0.0, 0.0, -0.8944105, 0.44724715)),
        LocationWithOrientation.Create(Vector4(-1735.4921, 2338.1345, 24.700005, 1.0), Quaternion(0.0, 0.0, 0.9976843, 0.06801629)),
        LocationWithOrientation.Create(Vector4(-1730.8914, 2330.6758, 22.845367, 1.0), Quaternion(0.0, 0.0, 0.99705267, 0.07671984)),
        LocationWithOrientation.Create(Vector4(-1626.6602, 2392.1108, 23.305893, 1.0), Quaternion(0.0, 0.0, 0.9953276, -0.096555896)),
        LocationWithOrientation.Create(Vector4(-1633.7936, 2390.6567, 23.30085, 1.0), Quaternion(0.0, 0.0, 0.9809862, -0.19407812))
    ];

    public static func SantoDomingoLocations() -> array<ref<LocationWithOrientation>> = [
        LocationWithOrientation.Create(Vector4(-677.1078, -954.62695, 7.3694, 1.0), Quaternion(0.0, 0.0, -0.5989718, 0.8007701)),
        LocationWithOrientation.Create(Vector4(-682.5897, -950.19653, 9.772041, 1.0), Quaternion(0.0, 0.0, -0.6342261, 0.7731477)),
        LocationWithOrientation.Create(Vector4(-713.55194, -1002.4325, 12.993904, 1.0), Quaternion(0.0, 0.0, -0.90914446, -0.41648096)),
        LocationWithOrientation.Create(Vector4(-723.31726, -991.77045, 12.004074, 1.0), Quaternion(0.0, 0.0, 0.25692368, -0.9664317)),
        LocationWithOrientation.Create(Vector4(-768.24927, -988.2608, 7.525856, 1.0), Quaternion(0.0, 0.0, -0.15449329, -0.98799384)),
        LocationWithOrientation.Create(Vector4(-823.60754, -1027.8435, 9.21476, 1.0), Quaternion(0.0, 0.0, 0.5934016, -0.8049066)),
        LocationWithOrientation.Create(Vector4(-868.9078, -1104.952, 12.991951, 1.0), Quaternion(0.0, 0.0, -0.034439966, 0.99940675)),
        LocationWithOrientation.Create(Vector4(-974.11786, -1223.8575, 11.95031, 1.0), Quaternion(0.0, 0.0, 0.82512605, 0.56494874)),
        LocationWithOrientation.Create(Vector4(-1082.4944, -1367.6874, 29.875504, 1.0), Quaternion(0.0, 0.0, -0.8039163, -0.5947425)),
        LocationWithOrientation.Create(Vector4(-1162.4791, -1498.2532, 30.423447, 1.0), Quaternion(0.0, 0.0, -0.28660098, 0.95805013)),
        LocationWithOrientation.Create(Vector4(-1211.4885, -1560.5186, 32.12284, 1.0), Quaternion(0.0, 0.0, -0.6281698, -0.7780763)),
        LocationWithOrientation.Create(Vector4(-928.9214, -1779.6577, 10.21151, 1.0), Quaternion(0.0, 0.0, 0.8085872, 0.5883764)),
        LocationWithOrientation.Create(Vector4(-869.55457, -1817.2438, 8.690552, 1.0), Quaternion(0.0, 0.0, 0.69035375, 0.72347206)),
        LocationWithOrientation.Create(Vector4(-877.3252, -1767.354, 9.571266, 1.0), Quaternion(0.0, 0.0, -0.99226046, 0.124174595)),
        LocationWithOrientation.Create(Vector4(-755.9116, -1811.2186, 11.700165, 1.0), Quaternion(0.0, 0.0, -0.6151086, -0.7884424)),
        LocationWithOrientation.Create(Vector4(-749.5226, -1797.612, 10.249336, 1.0), Quaternion(0.0, 0.0, 0.228184, -0.97361803)),
        LocationWithOrientation.Create(Vector4(-748.80896, -1789.1079, 10.3741, 1.0), Quaternion(0.0, 0.0, -0.43184686, -0.901947)),
        LocationWithOrientation.Create(Vector4(-633.08124, -1934.2625, 6.5427322, 1.0), Quaternion(0.0, 0.0, 0.829429, -0.5586123)),
        LocationWithOrientation.Create(Vector4(-639.266, -1939.6714, 9.3482895, 1.0), Quaternion(0.0, 0.0, 0.8779003, -0.47884348)),
        LocationWithOrientation.Create(Vector4(-649.2103, -1947.2052, 9.389381, 1.0), Quaternion(0.0, 0.0, 0.87070024, -0.49181423)),
        LocationWithOrientation.Create(Vector4(-653.61536, -1971.9174, 11.062637, 1.0), Quaternion(0.0, 0.0, -0.539361, 0.8420747)),
        LocationWithOrientation.Create(Vector4(-663.29224, -1974.9407, 11.09951, 1.0), Quaternion(0.0, 0.0, -0.7908519, 0.6120076)),
        LocationWithOrientation.Create(Vector4(-687.0106, -1966.2715, 7.0586166, 1.0), Quaternion(0.0, 0.0, 0.88327706, -0.46885154)),
        LocationWithOrientation.Create(Vector4(-347.86414, -1704.8241, 7.3249207, 1.0), Quaternion(0.0, 0.0, 0.7476958, 0.66404146)),
        LocationWithOrientation.Create(Vector4(-338.21188, -1688.1844, 7.332596, 1.0), Quaternion(0.0, 0.0, 0.3080411, 0.95137304)),
        LocationWithOrientation.Create(Vector4(-32.662415, -1887.3848, 2.5725937, 1.0), Quaternion(0.0, 0.0, 0.9796964, -0.20048715)),
        LocationWithOrientation.Create(Vector4(-16.97927, -1920.9799, 2.3693695, 1.0), Quaternion(0.0, 0.0, 0.24937342, 0.9684074)),
        LocationWithOrientation.Create(Vector4(-28.924065, -1913.0493, 3.498932, 1.0), Quaternion(0.0, 0.0, 0.8663273, -0.49947688)),
        LocationWithOrientation.Create(Vector4(-118.11871, -2067.37, 5.647133, 1.0), Quaternion(0.0, 0.0, 0.050169267, -0.9987408)),
        LocationWithOrientation.Create(Vector4(-139.40533, -2070.9565, 5.81308, 1.0), Quaternion(0.0, 0.0, 0.4878702, -0.8729162)),
        LocationWithOrientation.Create(Vector4(-125.62384, -2091.5823, 6.8090744, 1.0), Quaternion(0.0, 0.0, -0.36244965, 0.93200344)),
        LocationWithOrientation.Create(Vector4(-126.65515, -2110.7395, 6.8353653, 1.0), Quaternion(0.0, 0.0, -0.45203438, -0.8920006)),
        LocationWithOrientation.Create(Vector4(-124.901794, -2170.153, 6.0522003, 1.0), Quaternion(0.0, 0.0, 0.039272368, -0.99922854)),
        LocationWithOrientation.Create(Vector4(-57.016777, -2129.8655, 5.381668, 1.0), Quaternion(0.0, 0.0, 0.6681671, -0.74401134)),
        LocationWithOrientation.Create(Vector4(-30.933739, -2071.3545, 5.320381, 1.0), Quaternion(0.0, 0.0, 0.9967428, 0.08064727)),
        LocationWithOrientation.Create(Vector4(-85.806274, -2061.252, 9.717644, 1.0), Quaternion(0.0, 0.0, -0.99542004, 0.095598236)),
        LocationWithOrientation.Create(Vector4(-95.29907, -2100.1685, 10.129196, 1.0), Quaternion(0.0, 0.0, 0.08392492, -0.9964722)),
        LocationWithOrientation.Create(Vector4(-94.736176, -2118.2598, 6.9038925, 1.0), Quaternion(0.0, 0.0, 0.32580316, -0.9454376)),
        LocationWithOrientation.Create(Vector4(-101.11336, -2130.4497, 6.1540146, 1.0), Quaternion(0.0, 0.0, 0.7753385, 0.631546)),
        LocationWithOrientation.Create(Vector4(-174.2975, -2130.5464, 6.855484, 1.0), Quaternion(0.0, 0.0, 0.08169026, 0.99665785)),
        LocationWithOrientation.Create(Vector4(-188.14932, -1993.2557, 6.2864914, 1.0), Quaternion(0.0, 0.0, 0.3905577, -0.92057854)),
        LocationWithOrientation.Create(Vector4(-136.97446, -1946.1705, 11.997704, 1.0), Quaternion(0.0, 0.0, -0.00012445576, -1.0)),
        LocationWithOrientation.Create(Vector4(-135.66455, -1951.8218, 11.998062, 1.0), Quaternion(0.0, 0.0, 0.9600151, -0.27994838)),
        LocationWithOrientation.Create(Vector4(-149.74622, -1971.4569, 12.228027, 1.0), Quaternion(0.0, 0.0, 0.9781218, -0.20803338)),
        LocationWithOrientation.Create(Vector4(-147.66135, -1985.9841, 12.228035, 1.0), Quaternion(0.0, 0.0, -0.2543001, -0.9671254)),
        LocationWithOrientation.Create(Vector4(-156.15074, -1984.6027, 12.228027, 1.0), Quaternion(0.0, 0.0, 0.22142765, -0.9751769)),
        LocationWithOrientation.Create(Vector4(-154.03128, -1971.8346, 12.228027, 1.0), Quaternion(0.0, 0.0, 0.7374884, -0.67535985)),
        LocationWithOrientation.Create(Vector4(-140.45866, -1952.4489, 9.87648, 1.0), Quaternion(0.0, 0.0, 0.4951878, 0.868786)),
        LocationWithOrientation.Create(Vector4(-78.20761, -1873.2808, 2.615448, 1.0), Quaternion(0.0, 0.0, 0.69645065, -0.71760476)),
        LocationWithOrientation.Create(Vector4(-41.64308, -1913.2006, 3.5281525, 1.0), Quaternion(0.0, 0.0, 0.2688012, -0.9631957)),
        LocationWithOrientation.Create(Vector4(-37.31337, -1906.145, 3.5319366, 1.0), Quaternion(0.0, 0.0, -0.4917708, -0.8707248)),
        LocationWithOrientation.Create(Vector4(9.272934, -1877.9083, 3.3610458, 1.0), Quaternion(0.0, 0.0, 0.95149815, 0.30765465)),
        LocationWithOrientation.Create(Vector4(27.546371, -1803.3453, 2.5880585, 1.0), Quaternion(0.0, 0.0, 0.4624526, 0.886644)),
        LocationWithOrientation.Create(Vector4(24.420769, -1803.8531, -10.450752, 1.0), Quaternion(0.0, 0.0, -0.85545355, 0.5178797)),
        LocationWithOrientation.Create(Vector4(18.262413, -1802.8993, -10.29628, 1.0), Quaternion(0.0, 0.0, -0.88567644, 0.464303)),
        LocationWithOrientation.Create(Vector4(20.727814, -1806.4369, -10.435402, 1.0), Quaternion(0.0, 0.0, -0.73325455, 0.6799543)),
        LocationWithOrientation.Create(Vector4(57.522392, -1808.1345, -8.999084, 1.0), Quaternion(0.0, 0.0, 0.9621705, 0.27244836)),
        LocationWithOrientation.Create(Vector4(52.57627, -1839.8776, -9.387703, 1.0), Quaternion(0.0, 0.0, 0.49067536, -0.8713425)),
        LocationWithOrientation.Create(Vector4(53.77127, -1864.0159, -10.084274, 1.0), Quaternion(0.0, 0.0, -0.09740964, -0.9952444)),
        LocationWithOrientation.Create(Vector4(97.50044, -1837.8291, -9.359222, 1.0), Quaternion(0.0, 0.0, 0.43782288, 0.8990613)),
        LocationWithOrientation.Create(Vector4(190.3234, -1694.6395, 9.337112, 1.0), Quaternion(0.0, 0.0, -0.8129488, 0.5823351)),
        LocationWithOrientation.Create(Vector4(214.4757, -1719.3209, 8.717201, 1.0), Quaternion(0.0, 0.0, -0.9287443, -0.37072098)),
        LocationWithOrientation.Create(Vector4(226.21527, -1722.6974, 8.792076, 1.0), Quaternion(0.0, 0.0, -0.9752849, 0.22095111)),
        LocationWithOrientation.Create(Vector4(243.28838, -1729.3162, 8.949005, 1.0), Quaternion(0.0, 0.0, -0.27454776, 0.9615735)),
        LocationWithOrientation.Create(Vector4(338.14615, -1807.8827, 10.4226, 1.0), Quaternion(0.0, 0.0, 0.8613185, 0.50806546)),
        LocationWithOrientation.Create(Vector4(387.96243, -1803.8251, 12.453049, 1.0), Quaternion(0.0, 0.0, 0.38090792, 0.92461294)),
        LocationWithOrientation.Create(Vector4(398.64417, -1818.1958, 12.710693, 1.0), Quaternion(0.0, 0.0, 0.8891363, 0.4576425)),
        LocationWithOrientation.Create(Vector4(408.6097, -1823.1102, 12.736084, 1.0), Quaternion(0.0, 0.0, 0.39891037, -0.9169899)),
        LocationWithOrientation.Create(Vector4(474.89905, -1796.6199, 22.550323, 1.0), Quaternion(0.0, 0.0, -0.6780299, -0.73503435)),
        LocationWithOrientation.Create(Vector4(494.20886, -1809.7794, 25.615181, 1.0), Quaternion(0.0, 0.0, 0.02679134, -0.9996411)),
        LocationWithOrientation.Create(Vector4(447.05447, -1671.5107, 37.272804, 1.0), Quaternion(0.0, 0.0, -0.8119327, 0.5837512)),
        LocationWithOrientation.Create(Vector4(460.24423, -1691.395, 9.952164, 1.0), Quaternion(0.0, 0.0, 0.9640686, -0.26565352)),
        LocationWithOrientation.Create(Vector4(447.4978, -1686.1011, 12.637619, 1.0), Quaternion(0.0, 0.0, 0.8374257, -0.54655117)),
        LocationWithOrientation.Create(Vector4(432.72452, -1684.4426, 12.112198, 1.0), Quaternion(0.0, 0.0, 0.98295367, 0.18385354)),
        LocationWithOrientation.Create(Vector4(407.6727, -1675.2509, 9.31105, 1.0), Quaternion(0.0, 0.0, -0.3916258, -0.9201246)),
        LocationWithOrientation.Create(Vector4(490.66882, -1545.4995, 14.892723, 1.0), Quaternion(0.0, 0.0, -0.5920944, -0.80586857)),
        LocationWithOrientation.Create(Vector4(546.6062, -1461.5682, 20.460747, 1.0), Quaternion(0.0, 0.0, -0.9567162, -0.2910228)),
        LocationWithOrientation.Create(Vector4(545.637, -1410.9292, 20.241547, 1.0), Quaternion(0.0, 0.0, 0.7413215, -0.6711501)),
        LocationWithOrientation.Create(Vector4(538.1649, -1380.2876, 23.804314, 1.0), Quaternion(0.0, 0.0, 0.97593933, 0.21804212)),
        LocationWithOrientation.Create(Vector4(639.6851, -1209.8844, 28.054314, 1.0), Quaternion(0.0, 0.0, -0.8650989, 0.50160134)),
        LocationWithOrientation.Create(Vector4(709.9966, -1236.4065, 27.98767, 1.0), Quaternion(0.0, 0.0, -0.15288255, 0.98824435)),
        LocationWithOrientation.Create(Vector4(740.1878, -1247.878, 28.05175, 1.0), Quaternion(0.0, 0.0, -0.41022605, 0.9119839)),
        LocationWithOrientation.Create(Vector4(746.4236, -1309.7716, 30.395561, 1.0), Quaternion(0.0, 0.0, -0.18084659, 0.9835113)),
        LocationWithOrientation.Create(Vector4(748.3677, -1304.2242, 30.26632, 1.0), Quaternion(0.0, 0.0, 0.97507566, 0.22187315)),
        LocationWithOrientation.Create(Vector4(860.4511, -1244.1455, 28.060028, 1.0), Quaternion(0.0, 0.0, -0.59910613, -0.80066967)),
        LocationWithOrientation.Create(Vector4(840.37024, -1170.0167, 28.146591, 1.0), Quaternion(0.0, 0.0, -0.9999901, 0.004465807)),
        LocationWithOrientation.Create(Vector4(869.5012, -1123.9645, 28.008286, 1.0), Quaternion(0.0, 0.0, -0.52481693, -0.8512152)),
        LocationWithOrientation.Create(Vector4(891.1875, -1109.3052, 32.083748, 1.0), Quaternion(0.0, 0.0, 0.96123326, -0.2757365)),
        LocationWithOrientation.Create(Vector4(885.22943, -1118.9163, 31.967804, 1.0), Quaternion(0.0, 0.0, 0.85598886, -0.5169944)),
        LocationWithOrientation.Create(Vector4(876.8367, -1024.823, 28.25985, 1.0), Quaternion(0.0, 0.0, 0.9723461, -0.23354448)),
        LocationWithOrientation.Create(Vector4(914.25, -969.36163, 28.087433, 1.0), Quaternion(0.0, 0.0, -0.9945568, 0.104196206)),
        LocationWithOrientation.Create(Vector4(940.2693, -952.4763, 29.354141, 1.0), Quaternion(0.0, 0.0, 0.87803245, 0.47860125)),
        LocationWithOrientation.Create(Vector4(953.9669, -957.76587, 31.17588, 1.0), Quaternion(0.0, 0.0, -0.9666854, 0.25596762)),
        LocationWithOrientation.Create(Vector4(1029.0336, -897.80975, 33.57531, 1.0), Quaternion(0.0, 0.0, 0.5168345, 0.85608536)),
        LocationWithOrientation.Create(Vector4(1037.6002, -900.8361, 33.57531, 1.0), Quaternion(0.0, 0.0, 0.51159585, 0.8592262)),
        LocationWithOrientation.Create(Vector4(1038.1475, -896.38055, 33.57531, 1.0), Quaternion(0.0, 0.0, 0.8802306, 0.47454634))
    ];

    public static func BadlandsLocations() -> array<ref<LocationWithOrientation>> = [
        LocationWithOrientation.Create(Vector4(3626.9749, -829.1838, 123.44626, 1.0), Quaternion(0.0, 0.0, -0.6554786, -0.75521386)),
        LocationWithOrientation.Create(Vector4(3629.5679, -829.37225, 123.44626, 1.0), Quaternion(0.0, 0.0, -0.7723906, 0.6351478)),
        LocationWithOrientation.Create(Vector4(3743.5835, 824.89667, 133.40028, 1.0), Quaternion(0.0, 0.0, -0.9218449, -0.38755915)),
        LocationWithOrientation.Create(Vector4(3274.9763, 689.23804, 119.29622, 1.0), Quaternion(0.0, 0.0, 0.29435998, -0.9556947)),
        LocationWithOrientation.Create(Vector4(3202.1338, 674.827, 105.27855, 1.0), Quaternion(0.0, 0.0, -0.32813808, -0.94462985)),
        LocationWithOrientation.Create(Vector4(2698.0396, 111.7104, 73.01126, 1.0), Quaternion(0.0, 0.0, 0.99990165, -0.014030266)),
        LocationWithOrientation.Create(Vector4(2633.107, -18.585075, 79.31459, 1.0), Quaternion(0.0, 0.0, 0.37170786, -0.9283498)),
        LocationWithOrientation.Create(Vector4(2591.0198, -12.268143, 84.9935, 1.0), Quaternion(0.0, 0.0, 0.7028231, 0.71136475)),
        LocationWithOrientation.Create(Vector4(2527.9517, -58.524612, 85.703094, 1.0), Quaternion(0.0, 0.0, -0.37858468, 0.92556673)),
        LocationWithOrientation.Create(Vector4(2513.618, -56.495987, 85.9666, 1.0), Quaternion(0.0, 0.0, -0.9422268, -0.33497548)),
        LocationWithOrientation.Create(Vector4(2507.3484, -46.844986, 85.863205, 1.0), Quaternion(0.0, 0.0, -0.35027215, -0.93664795)),
        LocationWithOrientation.Create(Vector4(2472.2202, -192.53151, 82.914154, 1.0), Quaternion(0.0, 0.0, -0.78715646, 0.6167534)),
        LocationWithOrientation.Create(Vector4(2365.3887, -117.403656, 84.58241, 1.0), Quaternion(0.0, 0.0, -0.9999939, -0.0034897374)),
        LocationWithOrientation.Create(Vector4(1804.162, -570.0574, 60.294235, 1.0), Quaternion(0.0, 0.0, -0.7626343, -0.64683)),
        LocationWithOrientation.Create(Vector4(1811.3823, -558.6926, 63.10746, 1.0), Quaternion(0.0, 0.0, -0.76713073, -0.64149094)),
        LocationWithOrientation.Create(Vector4(1414.8269, -548.706, 93.346436, 1.0), Quaternion(0.0, 0.0, 0.951236, 0.30846423)),
        LocationWithOrientation.Create(Vector4(1422.8625, -539.96686, 94.33992, 1.0), Quaternion(0.0, 0.0, 0.9869495, 0.16103025)),
        LocationWithOrientation.Create(Vector4(1508.9944, -582.98914, 51.86377, 1.0), Quaternion(0.0, 0.0, 0.75632936, -0.6541911)),
        LocationWithOrientation.Create(Vector4(1508.775, -591.23944, 41.47882, 1.0), Quaternion(0.0, 0.0, 0.06250111, 0.9980449)),
        LocationWithOrientation.Create(Vector4(1609.217, -596.805, 47.130234, 1.0), Quaternion(0.0, 0.0, 0.011054506, 0.9999389)),
        LocationWithOrientation.Create(Vector4(1622.4204, -836.9576, 47.95804, 1.0), Quaternion(0.0, 0.0, 0.97127324, 0.23796706)),
        LocationWithOrientation.Create(Vector4(1402.0322, -731.7744, 48.119057, 1.0), Quaternion(0.0, 0.0, -0.15046835, -0.9886149)),
        LocationWithOrientation.Create(Vector4(1430.0133, -739.866, 49.198746, 1.0), Quaternion(0.0, 0.0, 0.8023393, 0.5968681)),
        LocationWithOrientation.Create(Vector4(1447.2129, -722.9619, 49.618362, 1.0), Quaternion(0.0, 0.0, 0.24283698, 0.9700672)),
        LocationWithOrientation.Create(Vector4(1646.237, -792.40283, 52.13607, 1.0), Quaternion(0.0, 0.0, 0.6079531, -0.79397297)),
        LocationWithOrientation.Create(Vector4(1480.9264, -1398.0062, 56.42079, 1.0), Quaternion(0.0, 0.0, -0.59784317, -0.8016131)),
        LocationWithOrientation.Create(Vector4(1487.0693, -1410.6414, 55.31746, 1.0), Quaternion(0.0, 0.0, -0.24176234, -0.97033554)),
        LocationWithOrientation.Create(Vector4(1480.773, -1406.4913, 57.588226, 1.0), Quaternion(0.0, 0.0, 0.15314773, -0.9882033)),
        LocationWithOrientation.Create(Vector4(1656.0142, -1399.3698, 54.963165, 1.0), Quaternion(0.0, 0.0, 0.9611356, 0.2760766)),
        LocationWithOrientation.Create(Vector4(2011.6467, -1616.3054, 66.83859, 1.0), Quaternion(0.0, 0.0, -0.14260808, -0.98977923)),
        LocationWithOrientation.Create(Vector4(2073.061, -1594.017, 55.549896, 1.0), Quaternion(0.0, 0.0, -0.17620651, -0.98435324)),
        LocationWithOrientation.Create(Vector4(2119.5833, -1614.0336, 55.47654, 1.0), Quaternion(0.0, 0.0, -0.18350314, -0.9830191)),
        LocationWithOrientation.Create(Vector4(2127.3472, -1606.396, 55.484512, 1.0), Quaternion(0.0, 0.0, -0.19078931, -0.981631)),
        LocationWithOrientation.Create(Vector4(2144.712, -1618.9973, 58.244286, 1.0), Quaternion(0.0, 0.0, -0.17147931, -0.98518777)),
        LocationWithOrientation.Create(Vector4(1975.9773, -1615.3044, 70.775314, 1.0), Quaternion(0.0, 0.0, -0.88336706, 0.4686819)),
        LocationWithOrientation.Create(Vector4(1973.0737, -1613.2838, 70.34996, 1.0), Quaternion(0.0, 0.0, 0.24067251, -0.97060645)),
        LocationWithOrientation.Create(Vector4(1948.76, -1597.5488, 70.31511, 1.0), Quaternion(0.0, 0.0, -0.67267364, -0.7399394)),
        LocationWithOrientation.Create(Vector4(2077.3232, -1369.5981, 53.88684, 1.0), Quaternion(0.0, 0.0, -0.6560422, -0.75472426)),
        LocationWithOrientation.Create(Vector4(2066.5457, -1366.396, 53.979134, 1.0), Quaternion(0.0, 0.0, -0.8918078, 0.45241466)),
        LocationWithOrientation.Create(Vector4(1966.5396, -1349.4707, 53.908394, 1.0), Quaternion(0.0, 0.0, 0.8596408, -0.51089895)),
        LocationWithOrientation.Create(Vector4(1916.7019, -1359.1719, 54.4823, 1.0), Quaternion(0.0, 0.0, -0.96986663, -0.24363633)),
        LocationWithOrientation.Create(Vector4(1848.8701, -1369.8026, 55.65306, 1.0), Quaternion(0.0, 0.0, -0.569979, -0.8216594))
    ];

    public static func WestbrookLocations() -> array<ref<LocationWithOrientation>> = [
        LocationWithOrientation.Create(Vector4(-666.3237, 549.5901, 21.61116, 1.0), Quaternion(0.0, 0.0, -0.27154484, 0.9624258)),
        LocationWithOrientation.Create(Vector4(-697.3776, 958.1252, 16.047195, 1.0), Quaternion(0.0, 0.0, 0.98886204, -0.14883578)),
        LocationWithOrientation.Create(Vector4(-778.26575, 926.64545, 18.219116, 1.0), Quaternion(0.0, 0.0, 0.95673454, 0.29096252)),
        LocationWithOrientation.Create(Vector4(-795.012, 952.82776, 18.170876, 1.0), Quaternion(0.0, 0.0, 0.74587613, 0.66608465)),
        LocationWithOrientation.Create(Vector4(-792.7665, 938.87787, 18.176323, 1.0), Quaternion(0.0, 0.0, 0.77283776, 0.63460374)),
        LocationWithOrientation.Create(Vector4(-815.3151, 955.0309, 16.681053, 1.0), Quaternion(0.0, 0.0, 0.9495111, -0.31373358)),
        LocationWithOrientation.Create(Vector4(-813.41907, 942.5292, 16.634354, 1.0), Quaternion(0.0, 0.0, 0.5918813, -0.8060252)),
        LocationWithOrientation.Create(Vector4(-812.5498, 890.22864, 15.302803, 1.0), Quaternion(0.0, 0.0, 0.7571026, 0.653296)),
        LocationWithOrientation.Create(Vector4(-827.73303, 1162.7875, 21.11766, 1.0), Quaternion(0.0, 0.0, 0.9891079, 0.14719275)),
        LocationWithOrientation.Create(Vector4(-823.295, 1160.2731, 21.11808, 1.0), Quaternion(0.0, 0.0, 0.5418647, 0.8404657)),
        LocationWithOrientation.Create(Vector4(-602.15643, 1311.3262, 46.491745, 1.0), Quaternion(0.0, 0.0, -0.50195605, -0.86489314)),
        LocationWithOrientation.Create(Vector4(-615.5995, 1320.1033, 46.502808, 1.0), Quaternion(0.0, 0.0, 0.88250047, -0.47031164)),
        LocationWithOrientation.Create(Vector4(-618.1426, 1319.2214, 42.671234, 1.0), Quaternion(0.0, 0.0, 0.7155458, -0.69856584)),
        LocationWithOrientation.Create(Vector4(-568.99927, 1224.0123, 39.314323, 1.0), Quaternion(0.0, 0.0, 0.48651963, 0.8736697)),
        LocationWithOrientation.Create(Vector4(-373.728, 1216.1737, 25.87584, 1.0), Quaternion(0.0, 0.0, 0.49328387, -0.8698684)),
        LocationWithOrientation.Create(Vector4(-373.39612, 1214.9905, 23.428368, 1.0), Quaternion(0.0, 0.0, 0.49821165, -0.86705554)),
        LocationWithOrientation.Create(Vector4(-367.72937, 1216.4705, 23.43583, 1.0), Quaternion(0.0, 0.0, -0.5834453, -0.8121525)),
        LocationWithOrientation.Create(Vector4(-231.58675, 1346.966, 34.074776, 1.0), Quaternion(0.0, 0.0, -0.9256584, -0.37836018)),
        LocationWithOrientation.Create(Vector4(-242.96225, 1391.046, 33.256317, 1.0), Quaternion(0.0, 0.0, 0.2980893, 0.954538)),
        LocationWithOrientation.Create(Vector4(-283.5928, 940.86523, 65.42641, 1.0), Quaternion(0.0, 0.0, 0.867462, 0.4975034)),
        LocationWithOrientation.Create(Vector4(-282.31955, 937.73584, 65.51669, 1.0), Quaternion(0.0, 0.0, 0.4735504, 0.8807668)),
        LocationWithOrientation.Create(Vector4(-115.65758, 767.4889, 81.05411, 1.0), Quaternion(0.0, 0.0, 0.70974964, -0.704454)),
        LocationWithOrientation.Create(Vector4(-161.00468, 651.8413, 55.281685, 1.0), Quaternion(0.0, 0.0, 0.3524211, 0.93584156)),
        LocationWithOrientation.Create(Vector4(-133.7993, 666.5199, 63.803856, 1.0), Quaternion(0.0, 0.0, 0.99398106, 0.109552816)),
        LocationWithOrientation.Create(Vector4(-139.29816, 683.4219, 70.17026, 1.0), Quaternion(0.0, 0.0, -0.64859027, -0.7611377)),
        LocationWithOrientation.Create(Vector4(-115.647415, 726.7268, 71.35013, 1.0), Quaternion(0.0, 0.0, -0.9102173, -0.41413113)),
        LocationWithOrientation.Create(Vector4(-103.89664, 742.5406, 77.66824, 1.0), Quaternion(0.0, 0.0, -0.52562636, -0.8507155)),
        LocationWithOrientation.Create(Vector4(-271.64572, 1492.0658, 34.10965, 1.0), Quaternion(0.0, 0.0, 0.13883092, -0.9903162)),
        LocationWithOrientation.Create(Vector4(-258.10577, 1525.3158, 34.033844, 1.0), Quaternion(0.0, 0.0, 0.87781733, -0.47899562)),
        LocationWithOrientation.Create(Vector4(-240.14616, 1613.2874, 34.243828, 1.0), Quaternion(0.0, 0.0, 0.91492367, 0.40362683)),
        LocationWithOrientation.Create(Vector4(-232.86258, 1610.213, 36.89997, 1.0), Quaternion(0.0, 0.0, 0.9069922, 0.4211474)),
        LocationWithOrientation.Create(Vector4(-219.3959, 1562.2803, 36.899963, 1.0), Quaternion(0.0, 0.0, 0.8426205, 0.5385079)),
        LocationWithOrientation.Create(Vector4(-230.70447, 1522.5608, 34.170288, 1.0), Quaternion(0.0, 0.0, 0.56306237, 0.8264144))
    ];

    public static func HeywoodLocations() -> array<ref<LocationWithOrientation>> = [
        LocationWithOrientation.Create(Vector4(-2178.8274, -120.20207, 11.6414795, 1.0), Quaternion(0.0, 0.0, 0.7103372, 0.70386153)),
        LocationWithOrientation.Create(Vector4(-2424.0981, -1049.1729, 4.2329407, 1.0), Quaternion(0.0, 0.0, 0.56087846, 0.8278982)),
        LocationWithOrientation.Create(Vector4(-2269.596, -855.6769, 17.783295, 1.0), Quaternion(0.0, 0.0, -0.9976942, 0.067870155)),
        LocationWithOrientation.Create(Vector4(-2085.101, -876.29553, 11.24379, 1.0), Quaternion(0.0, 0.0, -0.046687715, 0.9989096)),
        LocationWithOrientation.Create(Vector4(-2111.701, -870.11487, 14.008011, 1.0), Quaternion(0.0, 0.0, -0.02881057, 0.9995849)),
        LocationWithOrientation.Create(Vector4(-2080.0164, -1032.6526, 12.408081, 1.0), Quaternion(0.0, 0.0, -0.90483385, 0.42576507)),
        LocationWithOrientation.Create(Vector4(-2107.4917, -1006.4443, 12.421379, 1.0), Quaternion(0.0, 0.0, -0.7411081, 0.67138577)),
        LocationWithOrientation.Create(Vector4(-2245.9539, -995.85455, 11.373375, 1.0), Quaternion(0.0, 0.0, 0.8813108, -0.47253707)),
        LocationWithOrientation.Create(Vector4(-2090.75, -1258.6624, 23.305496, 1.0), Quaternion(0.0, 0.0, 1.0, -0.0004347497)),
        LocationWithOrientation.Create(Vector4(-2121.973, -1258.2085, 21.672073, 1.0), Quaternion(0.0, 0.0, 0.71660703, -0.69747716)),
        LocationWithOrientation.Create(Vector4(-2047.3794, -1381.7683, 5.1287994, 1.0), Quaternion(0.0, 0.0, 0.99788445, 0.06501329)),
        LocationWithOrientation.Create(Vector4(-1562.2318, -1371.9258, 54.670258, 1.0), Quaternion(0.0, 0.0, 0.91307944, -0.40778187)),
        LocationWithOrientation.Create(Vector4(-1576.6627, -1374.5168, 53.413902, 1.0), Quaternion(0.0, 0.0, -0.99998975, -0.0045280857)),
        LocationWithOrientation.Create(Vector4(-1609.107, -1403.3616, 45.66884, 1.0), Quaternion(0.0, 0.0, -0.9995346, -0.030508116)),
        LocationWithOrientation.Create(Vector4(-1493.4788, -1157.1759, 20.390251, 1.0), Quaternion(0.0, 0.0, 0.026725285, 0.9996429)),
        LocationWithOrientation.Create(Vector4(-1451.2837, -1127.7688, 14.292618, 1.0), Quaternion(0.0, 0.0, -0.7218389, -0.6920611)),
        LocationWithOrientation.Create(Vector4(-1458.4498, -1138.85, 10.033295, 1.0), Quaternion(0.0, 0.0, -0.0009838869, -0.9999996)),
        LocationWithOrientation.Create(Vector4(-1615.8043, -1182.8976, 21.100014, 1.0), Quaternion(0.0, 0.0, 0.009270566, 0.9999571)),
        LocationWithOrientation.Create(Vector4(-1343.9105, -1134.2014, 18.404686, 1.0), Quaternion(0.0, 0.0, 0.99959797, -0.028355049)),
        LocationWithOrientation.Create(Vector4(-1313.4155, -1170.2914, 15.824135, 1.0), Quaternion(0.0, 0.0, 0.75198257, 0.65918297)),
        LocationWithOrientation.Create(Vector4(-1302.913, -1168.3062, 18.218964, 1.0), Quaternion(0.0, 0.0, -0.72941726, 0.68406904)),
        LocationWithOrientation.Create(Vector4(-1248.44, -1080.161, 18.805336, 1.0), Quaternion(0.0, 0.0, -0.21746096, -0.9760691)),
        LocationWithOrientation.Create(Vector4(-1084.3619, -908.26355, 20.054695, 1.0), Quaternion(0.0, 0.0, 0.9958618, -0.09088068)),
        LocationWithOrientation.Create(Vector4(-1092.2974, -828.47845, 12.243011, 1.0), Quaternion(0.0, 0.0, -0.94574183, -0.32491902)),
        LocationWithOrientation.Create(Vector4(-1088.0157, -843.629, 14.525398, 1.0), Quaternion(0.0, 0.0, -0.05084212, -0.9987067)),
        LocationWithOrientation.Create(Vector4(-900.9036, -721.0466, 8.199997, 1.0), Quaternion(0.0, 0.0, 0.85771024, -0.5141335)),
        LocationWithOrientation.Create(Vector4(-892.4536, -668.46204, 20.159462, 1.0), Quaternion(0.0, 0.0, -0.27035517, 0.96276075)),
        LocationWithOrientation.Create(Vector4(-858.1845, -656.6109, 12.320671, 1.0), Quaternion(0.0, 0.0, 0.8704445, -0.49226677)),
        LocationWithOrientation.Create(Vector4(-848.11255, -641.48694, 14.422882, 1.0), Quaternion(0.0, 0.0, -0.8784861, 0.47776794)),
        LocationWithOrientation.Create(Vector4(-860.1212, -658.9315, 14.421219, 1.0), Quaternion(0.0, 0.0, -0.8738594, 0.4861787)),
        LocationWithOrientation.Create(Vector4(-843.9298, -638.50586, 14.207077, 1.0), Quaternion(0.0, 0.0, 0.88525605, -0.4651041)),
        LocationWithOrientation.Create(Vector4(-827.5762, -611.39343, 10.794212, 1.0), Quaternion(0.0, 0.0, 0.8751097, -0.48392472)),
        LocationWithOrientation.Create(Vector4(-806.80884, -545.1064, 8.168884, 1.0), Quaternion(0.0, 0.0, 0.8811613, -0.4728159)),
        LocationWithOrientation.Create(Vector4(-623.7328, -419.81622, 1.3783112, 1.0), Quaternion(0.0, 0.0, -0.44881207, -0.8936263)),
        LocationWithOrientation.Create(Vector4(-647.5919, -307.46753, 8.835419, 1.0), Quaternion(0.0, 0.0, 0.26357841, -0.964638)),
        LocationWithOrientation.Create(Vector4(-643.6076, -4.4741287, 10.526611, 1.0), Quaternion(0.0, 0.0, -0.9506104, -0.31038666)),
        LocationWithOrientation.Create(Vector4(-637.7827, -21.720154, 13.707039, 1.0), Quaternion(0.0, 0.0, -0.8854543, 0.46472654))
    ];

    public static func PacificaLocations() -> array<ref<LocationWithOrientation>> = [
        LocationWithOrientation.Create(Vector4(-2181.091, -2239.5652, 15.511581, 1.0), Quaternion(0.0, 0.0, -0.38099965, -0.92457527)),
        LocationWithOrientation.Create(Vector4(-2779.664, -1846.907, 7.2090607, 1.0), Quaternion(0.0, 0.0, 0.15075299, -0.98857147)),
        LocationWithOrientation.Create(Vector4(-2740.9333, -1910.1785, 18.623055, 1.0), Quaternion(0.0, 0.0, -0.87167954, -0.49007633)),
        LocationWithOrientation.Create(Vector4(-2802.6992, -1893.0283, 18.881248, 1.0), Quaternion(0.0, 0.0, -0.80794495, 0.58925796)),
        LocationWithOrientation.Create(Vector4(-2760.98, -1978.8011, 5.3603897, 1.0), Quaternion(0.0, 0.0, -0.9529035, 0.30327374)),
        LocationWithOrientation.Create(Vector4(-2788.661, -2066.3933, 5.3603745, 1.0), Quaternion(0.0, 0.0, -0.53613096, 0.84413487)),
        LocationWithOrientation.Create(Vector4(-2663.6968, -2496.4692, 21.5, 1.0), Quaternion(0.0, 0.0, 0.60523325, -0.79604816)),
        LocationWithOrientation.Create(Vector4(-2522.3237, -2349.9514, 13.945869, 1.0), Quaternion(0.0, 0.0, -0.9702774, 0.24199548)),
        LocationWithOrientation.Create(Vector4(-2609.923, -2497.7822, 49.025734, 1.0), Quaternion(0.0, 0.0, -0.5588929, -0.82923985)),
        LocationWithOrientation.Create(Vector4(-2617.5376, -2466.5308, 48.21859, 1.0), Quaternion(0.0, 0.0, -0.84623265, -0.53281367)),
        LocationWithOrientation.Create(Vector4(-2181.9187, -2083.8318, 16.19542, 1.0), Quaternion(0.0, 0.0, 0.66835034, 0.7438467)),
        LocationWithOrientation.Create(Vector4(-2349.4084, -2233.8208, 15.559845, 1.0), Quaternion(0.0, 0.0, 0.9373723, 0.34832916)),
        LocationWithOrientation.Create(Vector4(-2672.7373, -2473.6743, 22.0, 1.0), Quaternion(0.0, 0.0, -0.7298138, 0.6836461)),
        LocationWithOrientation.Create(Vector4(-2782.5254, -2453.0657, 29.943268, 1.0), Quaternion(0.0, 0.0, 0.22110316, 0.9752505)),
        LocationWithOrientation.Create(Vector4(-2786.247, -2462.2651, 25.586533, 1.0), Quaternion(0.0, 0.0, 0.5144392, -0.8575268)),
        LocationWithOrientation.Create(Vector4(-2641.0664, -2480.2944, 35.000008, 1.0), Quaternion(0.0, 0.0, -0.15305862, -0.9882172))
    ];

    // Pick a random stash district
    public static func GetRandomStashLocation() -> StashLocation {
        let roll = RandRange(0, EnumInt(StashLocation.Pacifica) + 1);
        return IntEnum<StashLocation>(roll);
    }

    public static func StashLocationToString(stashLocation: StashLocation) -> String {
        switch stashLocation {
            case StashLocation.Watson:
                return GetLocalizedTextByKey(n"DD.Turf.Watson");
            case StashLocation.SantoDomingo:
                return GetLocalizedTextByKey(n"DD.Turf.SantoDomingo");
            case StashLocation.Badlands:
                return GetLocalizedTextByKey(n"DD.Turf.Badlands");
            case StashLocation.Westbrook:
                return GetLocalizedTextByKey(n"DD.Turf.Westbrook");
            case StashLocation.Heywood:
                return GetLocalizedTextByKey(n"DD.Turf.Heywood");
            case StashLocation.Pacifica:
                return GetLocalizedTextByKey(n"DD.Turf.Pacifica");
            default:
                return GetLocalizedTextByKey(n"DD.Turf.Watson");
        }
    }

    public static func RollStashLocation(location: StashLocation) -> ref<LocationWithOrientation> {
        switch location {
            case StashLocation.Watson:
                return StashLocations.RollLocation(StashLocations.WatsonLocations());
            case StashLocation.SantoDomingo:
                return StashLocations.RollLocation(StashLocations.SantoDomingoLocations());
            case StashLocation.Badlands:
                return StashLocations.RollLocation(StashLocations.BadlandsLocations());
            case StashLocation.Westbrook:
                return StashLocations.RollLocation(StashLocations.WestbrookLocations());
            case StashLocation.Heywood:
                return StashLocations.RollLocation(StashLocations.HeywoodLocations());
            case StashLocation.Pacifica:
                return StashLocations.RollLocation(StashLocations.PacificaLocations());
            default:
                return StashLocations.RollLocation(StashLocations.WatsonLocations());
        }
    }

    private static func RollLocation(locations: array<ref<LocationWithOrientation>>) -> ref<LocationWithOrientation> {
        let idx = RandRange(0, ArraySize(locations));
        return locations[idx];
    }
}

