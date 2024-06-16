-- SCRIPT CREATED BY BROTEX 
-- BROTEX DEVELOPMENT
-- discord.gg/brotexdevelopment

ESX = exports["es_extended"]:getSharedObject()
local ox_inventory = exports.ox_inventory


local function ValidatePickupCoke(src)
	local ECoords = Brotex.CircleZones.CokeField.coords
	local PCoords = GetEntityCoords(GetPlayerPed(src))
	local Dist = #(PCoords-ECoords)
	if Dist <= 90 then return true end
end




----------------------------------------
----	       HARVESTING      		----
----------------------------------------
RegisterServerEvent('brotex:pickedUpCoke')
AddEventHandler('brotex:pickedUpCoke', function()
	local src = source
    local Inventory = exports.ox_inventory:Inventory()
	local xPlayer = ESX.GetPlayerFromId(src)
	local cime = math.random(5,10)
	if ValidatePickupCoke(src) then
        if Inventory.CanCarryItem(source, Brotex.CokeHarvestItem, 2 ) then
            Inventory.AddItem(source, Brotex.CokeHarvestItem, 2)
        else
            TriggerClientEvent("ox_lib:notify", source, {
                description = Strings.DontHaveStorage,
                type = "error"
            })
		end
	else
		FoundExploiter(src,'YOUR Event Trigger')
	end
end)

ESX.RegisterServerCallback('brotex:canPickUp', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	cb(xPlayer.canCarryItem(item, 1))
end)



------------------------------------
----		 PROCESS        	----
------------------------------------


lib.callback.register('brotex:cokeprocess', function()

    local _source = source
    local Inventory = exports.ox_inventory:Inventory()
    local xPlayer = ESX.GetPlayerFromId(_source)

        if Inventory.GetItem(source, Brotex.CokeHarvestItem).count > 1 then
            Inventory.RemoveItem(source, Brotex.CokeHarvestItem, 2)
            Inventory.AddItem(source, Brotex.CokeProcessItem, 1)
    else
        TriggerClientEvent("ox_lib:notify", source, {
            description = Strings.DontHaveStorage,
            type = "error"
        })
    end
end)


------------------------------------
----	 SELL COKE BRICK      	----
------------------------------------
for index, item in ipairs(Brotex['Sell']) do
    RegisterServerEvent('sellItems_' .. index)
    AddEventHandler('sellItems_' .. index, function(count)
        local itemIndex = index
        local player = source
        local xPlayer = ESX.GetPlayerFromId(player)

        if not Brotex['Sell'][itemIndex] then
            TriggerClientEvent("ox_lib:notify", player, {
                description = Strings.invaliditem,
                type = "error"
            })
            return
        end

        local itemName = Brotex['Sell'][itemIndex].name
        local itemLabel = Brotex['Sell'][itemIndex].label
        local itemPrice = Brotex['Sell'][itemIndex].price

        if xPlayer.getInventoryItem(itemName).count >= count then
            xPlayer.removeInventoryItem(itemName, count)
            xPlayer.addMoney(itemPrice * count)
            TriggerClientEvent('ox_lib:notify', player, { type = 'success', description =  'You selled this item amount: '..count..' '..itemLabel..' ' })
        else
            TriggerClientEvent('ox_lib:notify', player, { type = 'error', description = Strings.noitemtosell })
        end
    end)
end

