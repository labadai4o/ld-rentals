Config = {}

-- Language setting: 'bg' for Bulgarian, 'en' for English
Config.Language = 'bg'

-- Rental locations. Add more as needed.
Config.Locations = {
	{
		label = 'Los Santos Rentals',
		npc = {
			model = 'cs_bankman',
			coords = vec4(215.76, -810.12, 30.73, 160.0),
			scenario = 'WORLD_HUMAN_CLIPBOARD'
		},
		-- Multiple spawn points will be tried in order until a free one is found
		spawnPoints = {
			vec4(221.73, -804.03, 30.51, 248.1),
			vec4(224.59, -796.53, 30.49, 247.87)
		},
		-- Vehicles available for rent at this location
		-- Images will be loaded from https://docs.fivem.net/vehicles/[model].webp
		vehicles = {
			{ label = 'Blista', model = 'blista', price = 300 },
			{ label = 'Prairie', model = 'prairie', price = 450 },
			{ label = 'Issi', model = 'issi2', price = 400 }
		},
		targetIcon = 'fa-solid fa-car'
	}
}

-- Payment account: 'cash' or 'bank'
Config.PaymentAccount = 'cash'

-- Fuel system to use: 'ps-fuel', 'LegacyFuel', 'cdn-fuel'
Config.FuelSystem = 'cdn-fuel'

-- Fuel level for rented vehicles (0-100)
Config.FuelLevel = 90

-- Notification system to use: 'qb-core', 'okok'
Config.NotificationSystem = 'qb-core'

-- Enable putting player in rented vehicle
Config.PutInVehicle = false

-- Map blip settings
Config.Blip = {
	enable = true,
	label = 'Rentals',
	sprite = 523,
	color = 3,
	scale = 0.8
}
