# LD-Rentals - Vehicle Rental System

Modern vehicle rental system.

## 📋 Description

LD-Rentals is a script that allows players to rent vehicles from NPCs at specific locations. The system includes:

- 🚗 Vehicle rental with different prices
- 🎯 NPCs with clipboard that can be interacted with
- 💰 Payment with cash or bank account
- ⛽ Support for different fuel systems (ps-fuel, LegacyFuel, cdn-fuel)
- 🔑 Automatic key acquisition for rented vehicles
- 🗺️ Map blips for locations
- 🖥️ Modern UI interface
- 🔄 Prevention of multiple vehicle rentals

## 🚀 Installation

1. Copy the `ld-rentals` folder to the `resources` directory
2. Add `ensure ld-rentals` to `server.cfg`
3. Restart the server

## ⚙️ Configuration

### Basic Settings

```lua
-- Language setting: 'bg' for Bulgarian, 'en' for English
Config.Language = 'bg'

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
```

### Adding New Locations

```lua
Config.Locations = {
    {
        label = 'LS Rentals',
        npc = {
            model = 'cs_bankman',
            coords = vec4(215.76, -810.12, 30.73, 160.0),
            scenario = 'WORLD_HUMAN_CLIPBOARD'
        },
        spawnPoints = {
            vec4(221.73, -804.03, 30.51, 248.1),
            vec4(224.59, -796.53, 30.49, 247.87)
        },
        vehicles = {
            { label = 'Blista', model = 'blista', price = 300 },
            { label = 'Prairie', model = 'prairie', price = 450 },
            { label = 'Issi', model = 'issi2', price = 400 }
        },
        targetIcon = 'fa-solid fa-car'
    }
}
```

### Adding New Vehicles

```lua
vehicles = {
    { label = 'Car Name', model = 'model_name', price = 500 }
}
```

## 🎮 Usage

1. Go to one of the rental locations
2. Interact with the NPC using `qb-target`
3. Select a vehicle from the menu
4. Pay the amount and receive the keys
5. Drive carefully!

## 🔧 Dependencies

- [qb-core](https://github.com/qbcore-framework/qb-core)
- [qb-target](https://github.com/qbcore-framework/qb-target)
- [qb-vehiclekeys](https://github.com/qbcore-framework/qb-vehiclekeys)

### Fuel Systems (choose one):
- [ps-fuel](https://github.com/Project-Sloth/ps-fuel)
- [LegacyFuel](https://github.com/InZidiuZ/LegacyFuel)
- [cdn-fuel](https://github.com/CodineDev/cdn-fuel)

### Notification Systems (choose one):
- qb-core (built-in)
- [okokNotify](https://okok.tebex.io/package/4724993)

## 🔑 License Plates

Rented vehicles receive license plates in the format:
- `RENT` + 4 random digits (e.g.: `RENT1234`)

## 🐛 Known Issues

- Sometimes the clipboard disappears from the NPC's hands

## 📝 Changelog

### v1.0.0
- Initial version
- Vehicle rental system
- Support for different fuel systems
- Modern UI interface
- Prevention of multiple rentals

## 🤝 Support

For questions and issues, please open an issue in the GitHub repository.

## 📄 License

This project is licensed under MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Team Low-Dev**

---

⭐ If you like this script, please give it a star in the GitHub repository!
