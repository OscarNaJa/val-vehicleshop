local ESX = nil
local Val = GetCurrentResourceName()
local CALLBACK_NAMESPACE = 'val-vehicleshop'

local function fetchESX()
    if ESX then return ESX end

    pcall(function()
        ESX = exports['es_extended']:getSharedObject()
    end)

    while ESX == nil do
        TriggerEvent(Config["BaseServer"]["server_shared_obj"], function(obj) ESX = obj end)
        Wait(100)
    end

    return ESX
end

CreateThread(function()
    fetchESX()
end)

local function vehCfg(model)
    for k, v in pairs(Config['vehicles']) do
        if v.model == model or k == model then
            return v
        end
    end
    return nil
end

local function canAfford(xPlayer, payment, amount)
    if payment == 'cash' or payment == 'money' then
        return xPlayer.getAccount('money').money >= amount
    elseif payment == 'bank' then
        return xPlayer.getAccount('bank').money >= amount
    end
    return false
end

local function removeMoney(xPlayer, payment, amount)
    if payment == 'cash' or payment == 'money' then
        xPlayer.removeAccountMoney('money', amount)
    elseif payment == 'bank' then
        xPlayer.removeAccountMoney('bank', amount)
    end
end

local function cbIsPlateTaken(source, cb, plate)
    fetchESX()
    local row = MySQL.single('SELECT plate FROM owned_vehicles WHERE plate = ?', { tostring(plate) })
    cb(row ~= nil)
end

local function cbBuyVehicle(source, cb, model, price, payment)
    fetchESX()
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
end

CreateThread(function()
    fetchESX()

    ESX.RegisterServerCallback(CALLBACK_NAMESPACE .. ':isPlateTaken', cbIsPlateTaken)
    if Val ~= CALLBACK_NAMESPACE then
        ESX.RegisterServerCallback(Val .. ':isPlateTaken', cbIsPlateTaken)
    end

    ESX.RegisterServerCallback(CALLBACK_NAMESPACE .. ':buyVehicle', cbBuyVehicle)
    if Val ~= CALLBACK_NAMESPACE then
        ESX.RegisterServerCallback(Val .. ':buyVehicle', cbBuyVehicle)
    end
end)

RegisterNetEvent(Val .. ':Vehicle:Test')
AddEventHandler(Val .. ':Vehicle:Test', function(carname)
    local src = source
    TriggerClientEvent(Val .. ':TestCar:Client', src, carname)
end)

RegisterNetEvent(Val .. ':ExitTest')
AddEventHandler(Val .. ':ExitTest', function()
end)

RegisterNetEvent(CALLBACK_NAMESPACE .. ':setVehicleOwned')
AddEventHandler(CALLBACK_NAMESPACE .. ':setVehicleOwned', function(vehicleProps)
    fetchESX()
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

if Val ~= CALLBACK_NAMESPACE then
    RegisterNetEvent(Val .. ':setVehicleOwned')
    AddEventHandler(Val .. ':setVehicleOwned', function(vehicleProps)
        TriggerEvent(CALLBACK_NAMESPACE .. ':setVehicleOwned', vehicleProps)
    end)
end
