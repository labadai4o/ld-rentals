local QBCore = exports['qb-core']:GetCoreObject()

local spawnedPeds = {}
local activeRental = nil
local nuiOpen = false
local rentalBlips = {}

-- Notification function that supports multiple systems
local function SendNotification(message, type)
	if Config.NotificationSystem == 'qb-core' then
		QBCore.Functions.Notify(message, type)
	elseif Config.NotificationSystem == 'okok' and GetResourceState('okokNotify') == 'started' then
		exports['okokNotify']:Alert("Rentals", message, 5000, type)
	end
end

local function trimPlate(plate)
    if not plate then return nil end
    return (string.gsub(plate, "^%s*(.-)%s*$", "%1"))
end

local function findVehicleByPlate(plate)
    if not plate then return 0 end
    plate = trimPlate(plate)
    local vehicles = GetGamePool('CVehicle')
    for i = 1, #vehicles do
        local v = vehicles[i]
        if trimPlate(GetVehicleNumberPlateText(v)) == plate then
            return v
        end
    end
    return 0
end

local function loadModel(model)
	if type(model) == 'string' then model = joaat(model) end
	if not IsModelInCdimage(model) then return false end
	RequestModel(model)
	while not HasModelLoaded(model) do Wait(10) end
	return model
end

local function canSpawnAt(coords)
	local vehicles = GetGamePool('CVehicle')
	for i = 1, #vehicles do
		if #(GetEntityCoords(vehicles[i]) - vec3(coords.x, coords.y, coords.z)) < 3.0 then
			return false
		end
	end
	return true
end

local function findFreeSpawnPoint(points)
	for i = 1, #points do
		local p = points[i]
		if canSpawnAt(p) then return p end
	end
	return nil
end

-- Helper function to restore clipboard for all NPCs
local function restoreClipboards()
	for i, ped in pairs(spawnedPeds) do
		if DoesEntityExist(ped) then
			local loc = Config.Locations[i]
			if loc and loc.npc and loc.npc.scenario then
				if not IsPedUsingScenario(ped, loc.npc.scenario) then
					ClearPedTasks(ped)
					Wait(100)
					TaskStartScenarioInPlace(ped, loc.npc.scenario, 0, true)
				end
			end
		end
	end
end

	local function openNui(locationIndex)
	if nuiOpen then return end
	nuiOpen = true
	SetNuiFocus(true, true)
	local location = Config.Locations[locationIndex]
	SendNUIMessage({
		action = 'open',
		locationLabel = location.label,
		locationIndex = locationIndex,
		vehicles = location.vehicles,
		hasActiveRental = activeRental ~= nil,
		language = Config.Language
	})
end

RegisterNetEvent('ld-rentals:client:openMenu', function(locationIndex)
	openNui(locationIndex)
end)

-- NUI callbacks
RegisterNUICallback('rentals:rent', function(data, cb)
	TriggerEvent('ld-rentals:client:tryRent', data)
	cb(true)
end)

RegisterNUICallback('rentals:close', function(_, cb)
	SetNuiFocus(false, false)
	SendNUIMessage({ action = 'close' })
	nuiOpen = false
	
	-- Restore clipboard for all NPCs after menu closes
	CreateThread(function()
		Wait(500) -- Small delay to ensure menu is fully closed
		restoreClipboards()
	end)
	
	cb(true)
end)

RegisterNetEvent('ld-rentals:client:tryRent', function(data)
	-- Check if player already has an active rental
	if activeRental then
		SendNotification(_U('already_rented'), 'error')
		return
	end

	local location = Config.Locations[data.locationIndex]
	if not location then return end

	local spawnPoint = findFreeSpawnPoint(location.spawnPoints)
	if not spawnPoint then
		SendNotification(_U('no_spawn_space'), 'error')
		return
	end

	-- ask server to charge and approve
			TriggerServerEvent('ld-rentals:server:rent', data.model, data.price, data.label, data.locationIndex, spawnPoint)
end)

RegisterNetEvent('ld-rentals:client:spawnApproved', function(model, label, spawnPoint, plate)
	local mdl = loadModel(model)
	if not mdl then
		SendNotification(_U('model_error'), 'error')
		return
	end
	local veh = CreateVehicle(mdl, spawnPoint.x, spawnPoint.y, spawnPoint.z, spawnPoint.w, true, false)
	if not DoesEntityExist(veh) then
		SendNotification(_U('spawn_error'), 'error')
		return
	end
	SetVehicleOnGroundProperly(veh)
	SetEntityAsMissionEntity(veh, true, true)
	SetVehicleNeedsToBeHotwired(veh, false)
	SetVehicleDirtLevel(veh, 0.0)
	SetVehicleDoorsLocked(veh, 1)

	-- plate
	if plate and type(plate) == 'string' then
		SetVehicleNumberPlateText(veh, plate)
	else
		plate = "RENT" .. string.format('%04d', math.random(0, 9999))
		SetVehicleNumberPlateText(veh, plate)
	end

	-- fuel
	if Config.FuelLevel and Config.FuelSystem then
		if Config.FuelSystem == 'ps-fuel' and GetResourceState('ps-fuel') == 'started' then
			exports['ps-fuel']:SetFuel(veh, Config.FuelLevel + 0.0)
		elseif Config.FuelSystem == 'LegacyFuel' and GetResourceState('LegacyFuel') == 'started' then
			exports['LegacyFuel']:SetFuel(veh, Config.FuelLevel + 0.0)
		elseif Config.FuelSystem == 'cdn-fuel' and GetResourceState('cdn-fuel') == 'started' then
			exports['cdn-fuel']:SetFuel(veh, Config.FuelLevel + 0.0)
		end
	end

	-- keys
	if GetResourceState('qb-vehiclekeys') == 'started' then
		TriggerEvent('vehiclekeys:client:SetOwner', plate)
	elseif GetResourceState('qbx-vehiclekeys') == 'started' then
		TriggerServerEvent('qbx-vehiclekeys:server:AcquireVehicleKeys', plate)
	end

	-- make rentals ignore locks to avoid accidental relock issues
	if Entity and Entity(veh) and Entity(veh).state then
		Entity(veh).state:set('ignoreLocks', true, true)
	end

	if Config.PutInVehicle then
		TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
	end

	activeRental = { plate = plate, model = model, label = label }
	SendNotification(_U('rental_success', label), 'success')
	if nuiOpen then
		SetNuiFocus(false, false)
		SendNUIMessage({ action = 'close' })
		nuiOpen = false
		
		-- Restore clipboard for all NPCs after successful rental
		CreateThread(function()
			Wait(500) -- Small delay to ensure menu is fully closed
			restoreClipboards()
		end)
	end
end)

-- Reacquire keys and ensure unlock on entering our rental
RegisterNetEvent('QBCore:Client:VehicleInfo', function(data)
	if data and data.event == 'Entering' and activeRental and activeRental.plate then
		local ped = PlayerPedId()
		local entering = GetVehiclePedIsTryingToEnter(ped)
		if entering ~= 0 and DoesEntityExist(entering) then
			local plate = trimPlate(GetVehicleNumberPlateText(entering))
			if plate == trimPlate(activeRental.plate) then
				if GetResourceState('qb-vehiclekeys') == 'started' and exports['qb-vehiclekeys'] then
					local has = exports['qb-vehiclekeys']:HasKeys(plate)
					if not has then
						TriggerServerEvent('qb-vehiclekeys:server:AcquireVehicleKeys', plate)
					end
				end
				SetVehicleDoorsLocked(entering, 1)
			end
		end
	end
end)

-- Cleanup NPCs on resource stop
RegisterNetEvent('ld-rentals:client:cleanupNPCs', function()
	for _, ped in pairs(spawnedPeds) do
		if DoesEntityExist(ped) then
			DeleteEntity(ped)
		end
	end
	spawnedPeds = {}
end)

local function spawnNpcAndTarget(index)
	local loc = Config.Locations[index]
	local model = loadModel(loc.npc.model)
	if not model then return end
	local p = CreatePed(0, model, loc.npc.coords.x, loc.npc.coords.y, loc.npc.coords.z - 1.0, loc.npc.coords.w, false, true)
	SetEntityAsMissionEntity(p, true, true)
	SetBlockingOfNonTemporaryEvents(p, true)
	FreezeEntityPosition(p, true)
	SetEntityInvincible(p, true)
	
	-- Ensure scenario is properly applied with a small delay
	if loc.npc.scenario then
		Wait(100) -- Small delay to ensure ped is fully spawned
		TaskStartScenarioInPlace(p, loc.npc.scenario, 0, true)
		-- Double check scenario is active
		Wait(200)
		if not IsPedUsingScenario(p, loc.npc.scenario) then
			TaskStartScenarioInPlace(p, loc.npc.scenario, 0, true)
		end
	end
	
	spawnedPeds[#spawnedPeds+1] = p

	exports['qb-target']:AddTargetEntity(p, {
		options = {
			{
				label = _U('target_label'),
				icon = loc.targetIcon or 'fa-solid fa-car',
				action = function()
					TriggerEvent('ld-rentals:client:openMenu', index)
				end
			}
		},
		distance = 2.0
	})
end

-- Cleanup existing NPCs and spawn new ones on resource start
AddEventHandler('onResourceStart', function(res)
	if res ~= GetCurrentResourceName() then return end
	
	-- Clean up any existing NPCs first
	for _, ped in pairs(spawnedPeds) do
		if DoesEntityExist(ped) then
			DeleteEntity(ped)
		end
	end
	spawnedPeds = {}
	
	-- Spawn new NPCs
	for i = 1, #Config.Locations do 
		spawnNpcAndTarget(i) 
	end
end)

-- Spawn NPCs when player loads (for server restarts)
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
	-- Small delay to ensure everything is loaded
	Wait(1000)
	
	-- Clean up any existing NPCs first
	for _, ped in pairs(spawnedPeds) do
		if DoesEntityExist(ped) then
			DeleteEntity(ped)
		end
	end
	spawnedPeds = {}
	
	-- Spawn new NPCs
	for i = 1, #Config.Locations do 
		spawnNpcAndTarget(i) 
	end
end)

-- Blips for rental locations
CreateThread(function()
	if not Config.Blip or not Config.Blip.enable then return end
	for i = 1, #Config.Locations do
		local loc = Config.Locations[i]
		local blip = AddBlipForCoord(loc.npc.coords.x, loc.npc.coords.y, loc.npc.coords.z)
		SetBlipSprite(blip, Config.Blip.sprite or 225)
		SetBlipDisplay(blip, 4)
		SetBlipScale(blip, Config.Blip.scale or 0.8)
		SetBlipColour(blip, Config.Blip.color or 3)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName('STRING')
		AddTextComponentString(loc.label or (Config.Blip.label or _U('blip_label')))
		EndTextCommandSetBlipName(blip)
		rentalBlips[#rentalBlips+1] = blip
	end
end)

-- Periodic check to ensure NPCs always have their clipboard
CreateThread(function()
	while true do
		Wait(2000) -- Check every 2 seconds for better responsiveness
		restoreClipboards()
	end
end)
