Config = Config or {}

Config.timesPerRR = 10
Config.pricerPerLocation = math.random(2, 5)

Config.locations = {
    {
        blip = {
            show = true,
            sprite = 365,
            color = 2,
            display = 4,
            scale = 0.8,
            label = 'Gardening',
        },
        ped = {
            model = 's_m_m_gardener_01',
            text = 'Talk with Jose',
            coords = vec4(-1630.1981, 225.7444, 59.7606, 134.6683),
            scenario = 'WORLD_HUMAN_LEANING',
        },
        locations = {
            vec3(-1605.8596, 210.3069, 59.4854),
            vec3(-1607.3627, 213.8023, 59.5332),
            vec3(-1608.8479, 216.8358, 59.5106),
            vec3(-1607.1364, 219.3212, 59.3841),
            vec3(-1604.2507, 220.6766, 59.2796),
            vec3(-1600.9742, 222.2270, 59.1724),
            vec3(-1592.5925, 225.9499, 58.8926),
            vec3(-1589.1125, 227.6112, 58.7823),
            vec3(-1585.7771, 229.1857, 58.6915),
            vec3(-1581.6703, 231.0411, 58.6689),
            vec3(-1579.1737, 232.2426, 58.6595),
            vec3(-1602.9155, 204.6492, 59.3223),
            vec3(-1601.6117, 200.8991, 59.3786),
            vec3(-1599.9159, 197.4956, 59.3374),
            vec3(-1598.5715, 194.4826, 59.2986),
            vec3(-1597.0479, 190.9466, 59.2469),
            vec3(-1594.5646, 185.9710, 59.1880),
            vec3(-1593.3041, 183.0147, 59.1459),
            vec3(-1591.7684, 179.9759, 59.1150),
            vec3(-1588.6635, 177.5469, 59.0099),
            vec3(-1585.6321, 178.9354, 58.8585),
            vec3(-1582.5974, 180.4123, 58.7323),
            vec3(-1635.9885, 193.5655, 60.8758),
            vec3(-1639.9933, 196.4832, 61.1517),
            vec3(-1641.2878, 199.2116, 61.1127),
            vec3(-1642.5558, 201.9517, 61.0330),
        }
    }
}
