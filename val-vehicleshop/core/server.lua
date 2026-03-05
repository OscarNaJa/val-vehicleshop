ESX = nil
Tarn = GetCurrentResourceName()
CreateThread(function()
    while ESX == nil do
        TriggerEvent(Config["BaseServer"]["server_shared_obj"], function(obj) ESX = obj end)
        Wait(10)
    end
end)
local function vehCfg(model)
    for k,v in pairs(Config['vehicles']) do
        if v.model == model or k == model then
            return v
        end
    end
    return nil
end
ESX.RegisterServerCallback('val-vehicleshop:isPlateTaken', function(source, cb, plate)
    local row = MySQL.single('SELECT plate FROM owned_vehicles WHERE plate = ?', { tostring(plate) })
    cb(row ~= nil)
end)
local function canAfford(xPlayer, payment, amount)
    if payment == 'cash' then
        return xPlayer.getAccount('money').money >= amount
    elseif payment == 'bank' then
        return xPlayer.getAccount('bank').money >= amount
    end
    return false
end
local function removeMoney(xPlayer, payment, amount)
    if payment == 'cash' then
        xPlayer.removeAccountMoney('money', amount)
    elseif payment == 'bank' then
        xPlayer.removeAccountMoney('bank', amount)
    end
end
ESX.RegisterServerCallback('val-vehicleshop:buyVehicle', function(source, cb, model, price, payment)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then cb(false) return end
    local cfg = vehCfg(model)
    if not cfg then cb(false) return end
    local amount = tonumber(price or cfg.price or 0) or 0
    if amount <= 0 then cb(false) return end
    if cfg.category == 'ambulance' or cfg.category == 'police' or cfg.category == 'council' then
        if xPlayer.job.name ~= cfg.category then cb(false) return end
        local grade = tonumber(cfg.grade or 0) or 0
        if (xPlayer.job.grade or 0) < grade then cb(false) return end
    end
    if not canAfford(xPlayer, payment, amount) then cb(false) return end
    removeMoney(xPlayer, payment, amount)
    cb(true)
end)
RegisterNetEvent(Tarn..':Vehicle:Test')
AddEventHandler(Tarn..':Vehicle:Test', function(carname)
    local src = source
    TriggerClientEvent(Tarn..':TestCar:Client', src, carname)
end)
RegisterNetEvent(Tarn..':ExitTest')
AddEventHandler(Tarn..':ExitTest', function()
end)
RegisterNetEvent('val-vehicleshop:setVehicleOwned')
AddEventHandler('val-vehicleshop:setVehicleOwned', function(vehicleProps, job)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end
    local identifier = xPlayer.getIdentifier and xPlayer.getIdentifier() or xPlayer.identifier
    local plate = tostring(vehicleProps.plate or '')
    local vehicle = json.encode(vehicleProps)
    MySQL.insert('INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE owner = VALUES(owner), vehicle = VALUES(vehicle)', {
        identifier, plate, vehicle
    })
end)
