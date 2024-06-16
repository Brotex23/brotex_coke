Brotex = {}

-- HARVSTING ITEM 
Brotex.CokeHarvestItem = 'coke' -- Harvset item 

-- PROCESS ITEM 
Brotex.CokeProcessItem = 'cokebrick' -- Process Item

-- PROP 
Brotex.CokePlant = 'prop_bush_dead_02' -- Spawn Prop 

-- HARVSTING COORDS
Brotex.CircleZones = {
	CokeField = {coords = vector3(2542.52, 4808.46, 33.62)}, -- Harvesting Coords 
}

-- TEXTUI ICON 
Brotex.harvesticon = 'hand' -- text ui icon 
Brotex.processicon = 'seedling' -- text ui icon 
Brotex.sellicon = 'dollar' -- text ui icon 

-- PROGRESS DURATION 
Brotex.HarvestingDuration = 10000 -- 10 sec
Brotex.ProcessDuration = 10000 -- 10 sec


-- PROCESS 
Brotex.Process = "true" --  If you want to have a cocaine process put  true / if you don't want to put false
Brotex.ProcessTextui = "textui" -- textui / custom
Brotex.ProcessCoords = {
    {
        coords = vector3(1443.09, 6331.89, 23.98),
        size = vec3(1, 1, 1),
    },
}  

-- BLIP 
Brotex.HarvestingBlip = "true" -- if you want to see the blip on the map put true / if you want it to be turned off, put false
Brotex.ProcessBlip = "true"  -- if you want to see the blip on the map put true / if you want it to be turned off, put false
Brotex.SellBlip = "true" -- if you want to see the blip on the map put true / if you want it to be turned off, put false

-- SELL COKE 
Brotex.SellCoke = "true" -- If you want to have a coke sell put  true / if you don't want to put false
Brotex.SellCokeCoords = { -- sell coke coords 
    {
        coords = vector3(-46.28, 1946.57, 190.36),
        size = vec3(1, 1, 1),
    },
}  


-- SELL COKE MENU 
Brotex['Sell'] = {
    {label = "Coke Brick", name = "cokebrick", price = 600}, -- coke item / price 
}
