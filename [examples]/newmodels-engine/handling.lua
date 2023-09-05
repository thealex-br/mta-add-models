local handlingData = { [1] = "mass",[2] = "turnMass",[3] = "dragCoeff",[4] = "centerOfMassX",[5] = "centerOfMassY",[6] = "centerOfMassZ",[7] = "percentSubmerged",[8] = "tractionMultiplier",[9] = "tractionLoss",[10] = "tractionBias",[11] = "numberOfGears",[12] = "maxVelocity",[13] = "engineAcceleration",[14] = "engineInertia",[15] = "driveType",[16] = "engineType",[17] = "brakeDeceleration",[18] = "brakeBias",[19] = "ABS",[20] = "steeringLock",[21] = "suspensionForceLevel",[22] = "suspensionDamping",[23] = "suspensionHighSpeedDamping",[24] = "suspensionUpperLimit",[25] = "suspensionLowerLimit",[26] = "suspensionFrontRearBias",[27] = "suspensionAntiDiveMultiplier",[28] = "seatOffsetDistance", [29] = "collisionDamageMultiplier", [30] = "monetary", [31] = "modelFlags", [32] = "handlingFlags", [33] = "headLight", [34] = "tailLight", [35] = "animGroup" }
local handlingDriveType = { ["4"] = "awd", ["r"] = "rwd", ["f"] = "fwd" }
function setVehicleHandlingFromText(vehicle, text)
	local x, y, z
    local t = {}
    local tText = split(text, " ")
    table.remove(tText, 1)
    for i, v in pairs(tText) do
        t[handlingData[i]] = v
    end
    local centerMass = {
        x = tonumber(t.centerOfMassX),
        y = tonumber(t.centerOfMassY),
        z = tonumber(t.centerOfMassZ)
    }
    if centerMass.x and centerMass.y and centerMass.z then
        setVehicleHandling(vehicle, "centerOfMass", {centerMass.x, centerMass.y, centerMass.z})
    end
    for i, v in pairs(t) do
        if i == "modelFlags" or i == "handlingFlags" then
            setVehicleHandling(vehicle, i, "0x"..tostring(v))
        elseif i == "driveType" then
            setVehicleHandling(vehicle, i, handlingDriveType[v])
        elseif i ~= "centerOfMassX" and i ~= "centerOfMassY" and i ~= "centerOfMassZ" then
            setVehicleHandling(vehicle, i, tonumber(v) or tostring(v))
        end
    end
end

local handlingCacheFile = {}
function loadHandling(vehicle, id)
    if vehicle and id then

        local cached = handlingCacheFile[id]
        if cached then
            return setVehicleHandlingFromText(vehicle, cached)
        end

        local path = "handling/"..id..".txt"
        if not fileExists(path) then
            return false
        end

        local file = fileOpen(path, true)

        if file then
            local size = fileGetSize(file)
            local hand = fileRead(file, size)
            if not hand then
				fileClose(file)
                return false
            end
            fileClose(file)
            setVehicleHandlingFromText(vehicle, hand)
            handlingCacheFile[id] = hand
            return true
        end
        return false
    end
end