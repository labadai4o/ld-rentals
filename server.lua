local QBCore = exports['qb-core']:GetCoreObject()

local ActiveRentals = {}

-- Notification function that supports multiple systems
local function SendNotification(source, message, type)
	if Config.NotificationSystem == 'qb-core' then
		TriggerClientEvent('QBCore:Notify', source, message, type)
	elseif Config.NotificationSystem == 'okok' and GetResourceState('okokNotify') == 'started' then
		TriggerClientEvent('okokNotify:Alert', source, "Rentals", message, 5000, type)
	end
end

local function Trim(str)
	if not str then return str end
	return (string.gsub(str, '^%s*(.-)%s*$', '%1'))
end

local function removeMoney(player, amount)
	local account = Config.PaymentAccount
	if account == 'bank' then
		return player.Functions.RemoveMoney('bank', amount, 'vehicle-rental')
	else
		return player.Functions.RemoveMoney('cash', amount, 'vehicle-rental')
	end
end

RegisterNetEvent('qb-rentals:server:rent', function(model, price, label, locationIndex, spawnPoint)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	if not Player then return end

	-- Basic validation
	local location = Config.Locations[locationIndex]
	if not location then return end

	local valid = false
	for _, v in ipairs(location.vehicles) do
		if v.model == model and v.price == price then valid = true break end
	end
	if not valid then
		DropPlayer(src, 'qb-rentals: invalid rental data')
		return
	end

	if type(spawnPoint) ~= 'vector4' and type(spawnPoint) ~= 'table' then
		return
	end

	if removeMoney(Player, price) then
		local plate = "RENT" .. string.format('%04d', math.random(0, 9999))
		ActiveRentals[src] = { plate = plate, model = model, label = label, price = price }
		TriggerClientEvent('qb-rentals:client:spawnApproved', src, model, label, spawnPoint, plate)
		SendNotification(src, ('Платихте $%s за наем.'):format(price), 'success')
	else
		SendNotification(src, 'Нямате достатъчно средства.', 'error')
	end
end)

-- Cleanup on resource stop
AddEventHandler('onResourceStop', function(resourceName)
	if resourceName == GetCurrentResourceName() then
		-- Clean up all spawned NPCs
		TriggerClientEvent('qb-rentals:client:cleanupNPCs', -1)
	end
end)
