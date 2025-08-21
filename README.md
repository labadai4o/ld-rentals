# QB-Rentals - Система за наемане на превозни средства

Модерна система за наемане на превозни средства.

## 📋 Описание

QB-Rentals е скрипт който позволява на играчите да наемат превозни средства от NPC-та на определени локации. Системата включва:

- 🚗 Наемане на превозни средства с различни цени
- 🎯 NPC-та с clipboard които могат да бъдат взаимодействани
- 💰 Плащане с кеш или банкова сметка
- ⛽ Поддръжка за различни fuel системи (ps-fuel, LegacyFuel, cdn-fuel)
- 🔑 Автоматично получаване на ключове за наетото превозно средство
- 🗺️ Blip-ове на картата за локациите
- 🖥️ Модерен UI интерфейс
- 🔄 Предотвратяване на наемане на множество превозни средства

## 🚀 Инсталация

1. Копирайте папката `qb-rentals` в `resources` директорията
2. Добавете `ensure qb-rentals` в `server.cfg`
3. Рестартирайте сървъра

## ⚙️ Конфигурация

### Основни настройки

```lua
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

### Добавяне на нови локации

```lua
Config.Locations = {
    {
        label = 'City Rentals',
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

### Добавяне на нови превозни средства

```lua
vehicles = {
    { label = 'Име на колата', model = 'model_name', price = 500 }
}
```

## 🎮 Използване

1. Отидете до една от локациите за наемане
2. Взаимодействайте с NPC-то използвайки `qb-target`
3. Изберете превозно средство от менюто
4. Платете сумата и получете ключовете
5. Карайте внимателно!

## 🔧 Зависимости

- [qb-core](https://github.com/qbcore-framework/qb-core)
- [qb-target](https://github.com/qbcore-framework/qb-target)
- [qb-vehiclekeys](https://github.com/qbcore-framework/qb-vehiclekeys)

### Fuel системи (изберете една):
- [ps-fuel](https://github.com/Project-Sloth/ps-fuel)
- [LegacyFuel](https://github.com/InZidiuZ/LegacyFuel)
- [cdn-fuel](https://github.com/CodineDev/cdn-fuel)

### Notification системи (изберете една):
- qb-core (вградена)
- [okokNotify](https://okok.tebex.io/package/4724993)

## 🔑 Регистрационни номера

Наетите превозни средства получават регистрационни номера във формат:
- `RENT` + 4 случайни цифри (например: `RENT1234`)

## 🐛 Известни проблеми

- Няма известни проблеми в момента

## 📝 Changelog

### v1.0.0
- Първоначална версия
- Система за наемане на превозни средства
- Поддръжка за различни fuel системи
- Модерен UI интерфейс
- Предотвратяване на множествено наемане

## 🤝 Поддръжка

За въпроси и проблеми, моля отворете issue в GitHub репозиторията.

## 📄 Лиценз

Този проект е лицензиран под MIT License - вижте [LICENSE](LICENSE) файла за детайли.

## 👨‍💻 Автор

**labadai4o**

---

⭐ Ако ви харесва този скрипт, моля дайте звезда в GitHub репозиторията!
