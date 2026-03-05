
ESX						= nil

Tarn = GetCurrentResourceName()
TarnDev = {}
TarnDev.indexshop = nil

TarnDev.IsInShopMenu = false

TarnDev.Categories = {}
TarnDev.Vehicles = {}
TarnDev.LastVehicles = {}

TarnDev.openfocus = false
TarnDev.testcarme = false

cam = nil
local num = 0

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent(Config["BaseServer"]["clinet_shared_obj"], function(obj) ESX = obj end)
		Citizen.Wait(10)
	end
end)


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function (job)
	ESX.PlayerData.job = job
end)

CreateThread(function()
    for k, v in pairs(Config["Category"]) do
		table.insert(TarnDev.Categories, {name = v.index, label = v.label})
	end
	for k,v in pairs(Config["vehicles"]) do
		for cat,rat in pairs(Config["Category"]) do
			if Config["vehicles"][k]["category"] == rat.index then
				
				table.insert(TarnDev.Vehicles, {name = v.name, model = v.model, price =v.price, category = v.category,kg = v.kg,grade = v.grade,typecar = v.typecar,class = GetClassNameCar(v.model)})
			end
		end
	end
end)

CreateThread(function()
	while true do 
		Wait(1)
		local player = PlayerPedId()
		local coords = GetEntityCoords(player)
		local sleeploop = true
		for k,v in pairs(Config['ZONE_SHOP']) do 
			local distance = GetDistanceBetweenCoords(coords, v.ShopEnterShop.Pos, true)
			if (v.ShopEnterShop.Type ~= -1 and distance < Config.DrawDistance) then
				DrawMarker(v.ShopEnterShop.Type, v.ShopEnterShop.Pos.x, v.ShopEnterShop.Pos.y, v.ShopEnterShop.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.ShopEnterShop.Size.x, v.ShopEnterShop.Size.y, v.ShopEnterShop.Size.z, v.ShopEnterShop.colormarker.r, v.ShopEnterShop.colormarker.g, v.ShopEnterShop.colormarker.b, v.ShopEnterShop.colormarker.a, false, true, 2, false, false, false, false)
				sleeploop = false
			end
			if distance <= 2 then 
				sleeploop = false
				TarnDev.indexshop = k
				if IsControlJustReleased(0, 38) then 
					OpenShopMenu(v.shop,k)
				end
			end
		end
		if sleeploop then 
			Wait(1000)
		end
	end
end)


function OpenShopMenu(shop,indexshop)
	TarnDev.IsInShopMenu = true
	ExecuteCommand('hud')
	ExecuteCommand('closeminimap')
	ExecuteCommand('closehudspeed')
	DisableKeyInShop()
	local playerPed = PlayerPedId()
	FreezeEntityPosition(playerPed, true)
	SetEntityVisible(playerPed, false)
	local config = Config['ZONE_SHOP'][indexshop]
	pcall(function()
        exports["Tarn_report"]:PlayerBypassTPM()
    end)
	SetEntityCoords(playerPed, config.ShopEnterShop.Pos.x, config.ShopEnterShop.Pos.y, config.ShopEnterShop.Pos.z)
	local vehiclesByCategory = {}
	for i=1, #TarnDev.Categories, 1 do
		vehiclesByCategory[TarnDev.Categories[i].name] = {}
	end
	for i=1, #TarnDev.Vehicles, 1 do
		if IsModelInCdimage(GetHashKey(TarnDev.Vehicles[i].model)) then
			table.insert(vehiclesByCategory[TarnDev.Vehicles[i].category], TarnDev.Vehicles[i])
		end
	end	
	local category,vehiclebysell = GetCategory(vehiclesByCategory)
	
	SendNUIMessage({
		openshop = true,
		vehiclesdata = vehiclebysell,
		vehicleCategorys = category,
		colorlist = Config['ColorList'],
		money = GetMoney(),
		bank = GetBank(),	
		shop = shop
	})
	SetNuiFocus(true, true)
	SetNuiFocusKeepInput(false)
	TarnDev.openfocus = true
end

-- RegisterKeyMapping('openfocus', 'openfocus', 'keyboard', 'H')
-- RegisterCommand('openfocus', function(source,arg)
-- 	if TarnDev.IsInShopMenu then 
-- 		if not TarnDev.openfocus then 
-- 			TarnDev.openfocus = true
-- 			Wait(500)
-- 			SetNuiFocus(true, true)
-- 			SetNuiFocusKeepInput(false)
-- 		else
-- 			TarnDev.openfocus = false
-- 			Wait(500)
-- 			SetNuiFocus(true, true)
-- 			SetNuiFocusKeepInput(false)
-- 		end
-- 	end
-- end,false)

RegisterCommand('dbv', function()
	SetNuiFocusKeepInput(true)
	SetNuiFocus(false, false)
end)

RegisterNUICallback('openfocus', function()
	if TarnDev.IsInShopMenu then 
		-- if not TarnDev.openfocus then 
		-- 	TarnDev.openfocus = true
		-- 	Wait(500)
		-- 	SetNuiFocus(true, true)
		-- 	SetNuiFocusKeepInput(false)
		-- else
		-- 	TarnDev.openfocus = false
		-- 	Wait(500)
		-- 	SetNuiFocus(true, true)
		-- 	SetNuiFocusKeepInput(false)
		-- end
		local vehicle       = GetVehiclePedIsIn(PlayerPedId(), false)
		num = num + 1
		if num > 4 then 
			num = 1
		end
		SetVehicleCam(vehicle, num)
	end
	

end)





RegisterNUICallback('testcar', function(data)
	if not TarnDev.testcarme then
		if cam then
			DestroyCam(cam, false)
			RenderScriptCams(false, false, 0, true, true)
			cam = nil
			num = 0
		end 
		TriggerServerEvent(Tarn..':Vehicle:Test', data.carname)
	end
end)

RegisterNetEvent(Tarn..':TestCar:Client')
AddEventHandler(Tarn..':TestCar:Client', function(car)
	if not TarnDev.testcarme then
		local config = Config['ZONE_SHOP'][TarnDev.indexshop]
		local playerPed = PlayerPedId()
		TarnDev.IsInShopMenu = false
		ExecuteCommand('hud')
		ExecuteCommand('closeminimap')
		ExecuteCommand('closehudspeed')
		DeleteShopInsideVehicles()
		ESX.Game.SpawnVehicle(Config["vehicles"][car].model, config.ShopOutside.Pos, config.ShopOutside.Pos.w, function (vehicle)
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
			SetVehicleNumberPlateText(vehicle, 'PLAY')
			SetNuiFocus(false, false)
			SetNuiFocusKeepInput(false)
			TarnDev.openfocus = false
			SendNUIMessage({
				closeui = true
			})
		end)
		FreezeEntityPosition(playerPed, false)
		SetEntityVisible(playerPed, true)
		SendNUIMessage({
			testcar = true,
			time = 60,
			carname = Config["vehicles"][car].name
		})
		TestCarCheck()
	end
end)

function TestCarCheck()
	TarnDev.testcarme = true
	while TarnDev.testcarme do 
		Citizen.Wait(1000)
		if not IsPedInAnyVehicle(PlayerPedId(), false) then
			local current = GetPlayersLastVehicle(GetPlayerPed(-1), true)
			ESX.Game.DeleteVehicle(current)
			Wait(500)
			TriggerServerEvent(Tarn..':ExitTest')
			SendNUIMessage({
				closetime = true
			})
			local config = Config['ZONE_SHOP'][TarnDev.indexshop]
			pcall(function()
        exports["Tarn_report"]:PlayerBypassTPM()
    end)
			SetEntityCoords(PlayerPedId(), config.ShopEnterShop.Pos.x, config.ShopEnterShop.Pos.y, config.ShopEnterShop.Pos.z + 1.0)
			Wait(1500)
			TarnDev.testcarme = false
		end
	end
end

RegisterNUICallback('timeouttest', function()
	local current = GetPlayersLastVehicle(GetPlayerPed(-1), true)
	ESX.Game.DeleteVehicle(current)
	Wait(500)
	TriggerServerEvent(Tarn..':ExitTest')
	SendNUIMessage({
		closetime = true
	})
	local config = Config['ZONE_SHOP'][TarnDev.indexshop]
	pcall(function()
        exports["Tarn_report"]:PlayerBypassTPM()
    end)
	SetEntityCoords(PlayerPedId(), config.ShopEnterShop.Pos.x, config.ShopEnterShop.Pos.y, config.ShopEnterShop.Pos.z + 1.0)
	Wait(1500)
	TarnDev.testcarme = false
end)

function CheckTestCar()
	return TarnDev.testcarme
end
RegisterCommand('ls', function()
	if TarnDev.testcarme then 
		exports.mechanic_car:MenuMechanic()
	end
end)
exports("CheckTestCar", CheckTestCar)

RegisterNUICallback('buycar', function(data)
	local playerPed   = PlayerPedId()

	ESX.TriggerServerCallback('val-vehicleshop:buyVehicle', function (hasEnoughMoney)
		if hasEnoughMoney then
			TarnDev.IsInShopMenu = false
			DeleteShopInsideVehicles()
			local config = Config['ZONE_SHOP'][TarnDev.indexshop]
			ESX.Game.SpawnVehicle(Config["vehicles"][data.carname].model, config.ShopOutside.Pos, config.ShopOutside.Pos.w, function (vehicle)
				TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
				local newPlate = GeneratePlate()
				if data.color1 ~= nil then 
					local colorcar = Config['ColorList'][1][data.color]
					if colorcar then
						SetVehicleCustomPrimaryColour(vehicle, colorcar.r, colorcar.g, colorcar.b)
					else
						SetVehicleCustomPrimaryColour(vehicle, 93, 182, 229)
					end
				end
				if data.color2 ~= nil then 
					local colorcar2 = Config['ColorList'][2][data.color2]
					if colorcar2 then
						SetVehicleCustomSecondaryColour(vehicle, colorcar2.r, colorcar2.g, colorcar2.b)
					else
						SetVehicleCustomSecondaryColour(vehicle, 93, 182, 229)
					end
				end
				local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
				vehicleProps.plate = newPlate
				SetVehicleNumberPlateText(vehicle, newPlate)
				SendNUIMessage({
					closeui = true
				})
				SetNuiFocus(false, false)
				SetNuiFocusKeepInput(false)
				TarnDev.openfocus = false
				local job = Config["vehicles"][data.carname].category
				if job == 'ambulance' or job == 'police' or job == 'council' then
					TriggerServerEvent('val-vehicleshop:setVehicleOwned', vehicleProps,job)
				else
					TriggerServerEvent('val-vehicleshop:setVehicleOwned', vehicleProps,nil)
				end

				local sendToDiscord = '' .. GetPlayerName(PlayerId()) .. ' ซื้อรถ ' .. Config["vehicles"][data.carname].model .. ' ทะเบียน ' .. vehicleProps.plate .. ' ราคา ' .. ESX.Math.GroupDigits(Config["vehicles"][data.carname].price) ..'$'
				TriggerServerEvent('Tarn_serverlogs:sendToDiscord', 'BuyVehicle', sendToDiscord, GetPlayerServerId(PlayerId()), '^2')
				if Config["vehicles"][data.carname].price > 650000 then 
					local sendToDiscord2 = '' .. GetPlayerName(PlayerId()) .. ' ซื้อรถ ' .. Config["vehicles"][data.carname].model .. ' ทะเบียน ' .. vehicleProps.plate .. ' ราคา ' .. ESX.Math.GroupDigits(Config["vehicles"][data.carname].price) ..'$'
					TriggerServerEvent('Tarn_serverlogs:sendToDiscord', 'over_buycar', sendToDiscord2, GetPlayerServerId(PlayerId()), '^2')
				end
				ExecuteCommand('hud')
				ExecuteCommand('closeminimap')
				ExecuteCommand('closehudspeed')
				exports['mythic_notify']:DoHudText('infoerror', 'ซื้อรถสำเร็จ')
			end)
			FreezeEntityPosition(playerPed, false)
			SetEntityVisible(playerPed, true)
			if cam then
				DestroyCam(cam, false)
				RenderScriptCams(false, false, 0, true, true)
				cam = nil
				num = 0
			end
		else
			exports['mythic_notify']:DoHudText('infoerror', 'คุณไม่มีเงิน')
		end
	end,Config["vehicles"][data.carname].model,Config["vehicles"][data.carname].price,data.payment)
end)

RegisterNUICallback('choosecar', function(data)
	local config = Config['ZONE_SHOP'][TarnDev.indexshop]
	local playerPed   = PlayerPedId()
	DeleteShopInsideVehicles()
	WaitForVehicleToLoad(data.model)

	ESX.Game.SpawnLocalVehicle(data.model, config.ShopInside.Pos, config.ShopInside.Pos.w, function (vehicle)
		table.insert(TarnDev.LastVehicles, vehicle)
		TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
		FreezeEntityPosition(vehicle, true)
		SetModelAsNoLongerNeeded(data.model)
		if num == 0 then
			Wait(50)
			local vehicle       = GetVehiclePedIsIn(PlayerPedId(), false)
			num = num + 1
			if num > 4 then 
				num = 1
			end
			SetVehicleCam(vehicle, num)
		end
	end)
	
	
	

end)

RegisterNUICallback('choosecolor1', function(data)
	local vehicle       = GetVehiclePedIsIn(PlayerPedId(), false)
	local color = Config['ColorList'][1][data.color]
	SetVehicleCustomPrimaryColour(vehicle, color.r, color.g, color.b)
	
end)

RegisterNUICallback('choosecolor2', function(data)
	local vehicle       = GetVehiclePedIsIn(PlayerPedId(), false)
	local color2 = Config['ColorList'][2][data.color]
	SetVehicleCustomSecondaryColour(vehicle, color2.r, color2.g, color2.b)
end)

RegisterNUICallback('quit', function()
	if TarnDev.IsInShopMenu then
		ExecuteCommand('hud')
		ExecuteCommand('closeminimap')
		ExecuteCommand('closehudspeed')
		local playerPed   = PlayerPedId()
		DeleteShopInsideVehicles()
		local playerPed = PlayerPedId()
		FreezeEntityPosition(playerPed, false)
		SetEntityVisible(playerPed, true)
		local config = Config['ZONE_SHOP'][TarnDev.indexshop]
		pcall(function()
        exports["Tarn_report"]:PlayerBypassTPM()
    end)
		SetEntityCoords(playerPed, config.ShopEnterShop.Pos.x, config.ShopEnterShop.Pos.y, config.ShopEnterShop.Pos.z)
		SetNuiFocus(false, false)
		SetNuiFocusKeepInput(false)
		TarnDev.IsInShopMenu = false
		TarnDev.openfocus = false
		if cam then
			DestroyCam(cam, false)
			RenderScriptCams(false, false, 0, true, true)
			cam = nil
			num = 0
		end

	end
end)

function CheckInShopCar()
	return TarnDev.IsInShopMenu
end
exports("CheckInShopCar", CheckInShopCar)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		if TarnDev.IsInShopMenu then
			DeleteShopInsideVehicles()
			local playerPed = PlayerPedId()
			FreezeEntityPosition(playerPed, false)
			SetEntityVisible(playerPed, true)
			local config = Config['ZONE_SHOP'][TarnDev.indexshop]
			pcall(function()
        exports["Tarn_report"]:PlayerBypassTPM()
    end)
			SetEntityCoords(playerPed, config.ShopEnterShop.Pos.x, config.ShopEnterShop.Pos.y, config.ShopEnterShop.Pos.z)
		end
	end
end)