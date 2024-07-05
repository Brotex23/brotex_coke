-- SCRIPT CREATED BY BROTEX 
-- BROTEX DEVELOPMENT
-- discord.gg/brotexdevelopment

ESX = exports["es_extended"]:getSharedObject()
local ox_inventory = exports.ox_inventory
local spawnedCoke = 0
local cokePlants = {}
local isPickingUp = false


----------------------------------------
----	PROP SPAWN / HARVESTING   	----
----------------------------------------
CreateThread(function()
	while true do
		Wait(700)
		local coords = GetEntityCoords(PlayerPedId())

		if #(coords - Brotex.CircleZones.CokeField.coords) < 50 then
			SpawnCokePlants()
		end
	end
end)

CreateThread(function()
	while true do
		local Sleep = 1500
		
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local nearbyObject, nearbyID

		for i=1, #cokePlants, 1 do
			if #(coords - GetEntityCoords(cokePlants[i])) < 1.5 then
				nearbyObject, nearbyID = cokePlants[i], i
			end
		end

		
			if nearbyObject and IsPedOnFoot(playerPed) then
				Sleep = 0
				if not isPickingUp then
					lib.showTextUI(Strings.coke_pickup, {icon = Brotex.harvesticon})
				end

				if IsControlJustReleased(0, 38) and not isPickingUp then
					isPickingUp = true

					ESX.TriggerServerCallback('brotex:canPickUp', function(canPickUp)
						if canPickUp then
							lib.progressCircle({
								duration = Brotex.HarvestingDuration,
								position = 'bottom',
								label = Strings.HarvestCokeLabel,
								useWhileDead = false,
								canCancel = false,
								disable = {
									car = true,
									move = true,
								},
								anim = {
									dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
									clip = 'machinic_loop_mechandplayer',
								},
							})
			
							ESX.Game.DeleteObject(nearbyObject)
			
							table.remove(cokePlants, nearbyID)
							spawnedCoke = spawnedCoke - 1
			
							TriggerServerEvent('brotex:pickedUpCoke')
						else
							TriggerClientEvent("ox_lib:notify", source, {
								description = Strings.DontHaveStorage,
								type = "error"
							})
						end

						isPickingUp = false
					end, 'Brotex.CokeHarvestItem')
				end
			end


	Wait(Sleep)
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(cokePlants) do
			ESX.Game.DeleteObject(v)
		end
	end
end)

function SpawnCokePlants()
	while spawnedCoke < 25 do
		Wait(0)
		local cokeCoords = GenerateCokeCoords()

		ESX.Game.SpawnLocalObject('prop_plant_01a', cokeCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)

			table.insert(cokePlants, obj)
			spawnedCoke = spawnedCoke + 1
		end)
	end
end

function ValidateCokeCoord(plantCoord)
	if spawnedCoke > 0 then
		local validate = true

		for k, v in pairs(cokePlants) do
			if #(plantCoord - GetEntityCoords(v)) < 5 then
				validate = false
			end
		end

		if #(plantCoord - Brotex.CircleZones.CokeField.coords) > 50 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GenerateCokeCoords()
	while true do
		Wait(0)

		local cokeCoordX, cokeCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-90, 90)

		Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-90, 90)

		cokeCoordX = Brotex.CircleZones.CokeField.coords.x + modX
		cokeCoordY = Brotex.CircleZones.CokeField.coords.y + modY

		local coordZ = GetCoordZ(cokeCoordX, cokeCoordY)
		local coord = vector3(cokeCoordX, cokeCoordY, coordZ)

		if ValidateCokeCoord(coord) then
			return coord
		end
	end
end

function GetCoordZ(x, y)
	local groundCheckHeights = { 48.0, 49.0, 50.0, 51.0, 52.0, 53.0, 54.0, 55.0, 56.0, 57.0, 58.0 }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 43.0
end



------------------------------------
----	  BLIP   HARVESTING    ----
------------------------------------
if Brotex.HarvestingBlip == "true" then 
	CreateThread(function()
		for k, v in pairs(Brotex.CircleZones) do
			local blip = AddBlipForCoord(v.coords)

			SetBlipSprite (blip, 514)
			SetBlipDisplay(blip, 4)
			SetBlipScale  (blip, 0.8)
			SetBlipColour (blip, 5)
			SetBlipAsShortRange(blip, true)
			SetBlipHighDetail(blip, true)

			BeginTextCommandSetBlipName('STRING')
			AddTextComponentSubstringPlayerName(Strings.CokeBlip)
			EndTextCommandSetBlipName(blip)
		end
	end)
end 


------------------------------------
----		 PROCESS        	----
------------------------------------
if Brotex.Process == "true" then 
	CreateThread(function()
		while true do
			local Sleep = 1500
			if Brotex.ProcessTextui == "textui" then 
				for k, v in ipairs(Brotex.ProcessCoords) do

					local box = lib.zones.box({
					  coords = v.coords,
					  size = v.size,
					  debug = false, 
					  inside = function()
						lib.showTextUI(Strings.ProcessTextui, {icon = Brotex.processicon})
						if IsControlJustPressed(1, 38) then
							lib.progressCircle({
								duration = Brotex.ProcessDuration,
								position = 'bottom',
								label = Strings.ProcessCokeLabel,
								useWhileDead = false,
								canCancel = false,
								disable = {
									car = true,
									move = true,
								},
								anim = {
									dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
									clip = 'machinic_loop_mechandplayer',
								},
								prop = {
									model = `prop_meth_bag_01`,
									pos = vec3(0.03, 0.03, 0.02),
									rot = vec3(0.0, 0.0, -1.5)
								},
							})
							lib.callback('brotex:cokeprocess')
						end 
					end,
				
					  onExit = function()
						lib.hideTextUI()
				  
					  end
					})
				end  
			elseif Brotex.ProcessTextui == "custom" then 
				-- your custom function 
			end 	
			Wait(Sleep)
		end 	
	end)	
end 





------------------------------------
----		BLIP   PROCESS     	----
------------------------------------
if Brotex.ProcessBlip == "true" then 
	CreateThread(function()
		for k, v in pairs(Brotex.ProcessCoords) do
			local blip = AddBlipForCoord(v.coords)

			SetBlipSprite (blip, 365) -- https://docs.fivem.net/docs/game-references/blips/#blips
			SetBlipDisplay(blip, 4)
			SetBlipScale  (blip, 1.2)
			SetBlipColour (blip, 29) -- https://docs.fivem.net/docs/game-references/blips/#blip-colors
			SetBlipAsShortRange(blip, true)
			SetBlipHighDetail(blip, true)

			BeginTextCommandSetBlipName('STRING')
			AddTextComponentSubstringPlayerName(Strings.ProcessBlip)
			EndTextCommandSetBlipName(blip)
		end
	end)
end 







------------------------------------
----		SELL COCAIN      	----
------------------------------------
if Brotex.SellCoke == "true" then 
	local options = {}
	local options2 = {}
	local Player = PlayerPedId() -- spy_pawnshop:menu1

	for k, v in ipairs(Brotex.SellCokeCoords) do

		local box = lib.zones.box({
		  coords = v.coords,
		  size = v.size,
		  debug = false, 
		  inside = function()
			lib.showTextUI(Strings.sellcoke, {icon = Brotex.sellicon})
			if IsControlJustPressed(1, 38) then
				TriggerEvent('BrotexSell')
			end 
		end,
	
		  onEnter = function()
			lib.showTextUI({icon = Brotex.sellicon, Strings.sellcoke})
		  end,
		  onExit = function()
			lib.hideTextUI()
	  
		  end
		})
	end 
	
	RegisterNetEvent('BrotexSell')
	AddEventHandler('BrotexSell', function(items)
    local options = {}

    for index, item in ipairs(Brotex['Sell']) do
        table.insert(options, {
            title = item.label .. " - $" .. item.price,
            event = 'sellItemss_' .. index,
            arrow = true
        })
    end

    lib.registerContext({
        id = 'sellmenu',
        title = 'Selling Menu',
        options = options
    })

    lib.showContext('sellmenu')
end)

for index, item in ipairs(Brotex['Sell']) do
    RegisterNetEvent('sellItemss_' .. index)
    AddEventHandler('sellItemss_' .. index, function()
        local itemIndex = index
        local input = lib.inputDialog('How many do you want to sell?', {'Enter quantity'})
        if not input then return end
        local count = tonumber(input[1])
        if count > 0 then
            TriggerServerEvent('sellItems_' .. index, count)
        end
    end)
end


end 




------------------------------------
----		BLIP   COKE     	----
------------------------------------
if Brotex.SellBlip == "true" then 
	CreateThread(function()
		for k, v in pairs(Brotex.SellCokeCoords) do
			local blip = AddBlipForCoord(v.coords)

			SetBlipSprite (blip, 108) -- https://docs.fivem.net/docs/game-references/blips/#blips
			SetBlipDisplay(blip, 4)
			SetBlipScale  (blip, 0.8)
			SetBlipColour (blip, 1) -- https://docs.fivem.net/docs/game-references/blips/#blip-colors
			SetBlipAsShortRange(blip, true)
			SetBlipHighDetail(blip, true)

			BeginTextCommandSetBlipName('STRING')
			AddTextComponentSubstringPlayerName(Strings.SellBlip)
			EndTextCommandSetBlipName(blip)
		end
	end)
end 









