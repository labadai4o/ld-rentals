Config = {}

-- Локации за наемане. Добавете повече според нуждите.
Config.Locations = {
	{
		label = 'City Rentals',
		npc = {
			model = 'cs_bankman',
			coords = vec4(215.76, -810.12, 30.73, 160.0),
			scenario = 'WORLD_HUMAN_CLIPBOARD'
		},
		-- Множествени точки за спаун ще бъдат опитани по ред докато се намери свободна
		spawnPoints = {
			vec4(221.73, -804.03, 30.51, 248.1),
			vec4(224.59, -796.53, 30.49, 247.87)
		},
		-- Превозни средства налични за наемане на тази локация
		-- Изображенията ще се зареждат от https://docs.fivem.net/vehicles/[model].webp
		vehicles = {
			{ label = 'Blista', model = 'blista', price = 300 },
			{ label = 'Prairie', model = 'prairie', price = 450 },
			{ label = 'Issi', model = 'issi2', price = 400 }
		},
		targetIcon = 'fa-solid fa-car'
	}
}

-- Сметка за плащане: 'cash' или 'bank'
Config.PaymentAccount = 'cash'

-- Fuel система за използване: 'ps-fuel', 'LegacyFuel', 'cdn-fuel'
Config.FuelSystem = 'cdn-fuel'

-- Гориво за наетите превозни средства (0-100)
Config.FuelLevel = 90

-- Notification система за използване: 'qb-core', 'okok'
Config.NotificationSystem = 'qb-core'

-- Активиране на поставяне на играча в наетото превозно средство
Config.PutInVehicle = false

-- Настройки за blip на картата
Config.Blip = {
	enable = true,
	label = 'Rentals',
	sprite = 523,
	color = 3,
	scale = 0.8
}
