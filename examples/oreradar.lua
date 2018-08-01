-- WARNING: This example is NOT to be deployed in a multiplayer environment, as it crushes server peformance.

printError("WARNING: This example is NOT to be deployed in a multiplayer environment, as it crushes server peformance.")

local indicatorSize = 16 -- character base size (this is used as a factor alongside with the distance of an ore)
local indicator = "x" -- indicator character to use
local fov = 80 -- field of view ( as set in the client in degrees.)
local ar = 1.8 -- aspect ratio (divide your screen width by it's height, so for 1080x1920 it is 16/9 = 1.777~. For windowed Minecraft on Windows use 1.8)

local modules = peripheral.wrap("back") -- for this demo you need overlay glasses, an introspection module, an entity sensor and a block scanner
local can = modules.canvas()
local blocks = modules.scan()
local blocksToShow = {
    ["minecraft:emerald_ore"] = 0x46FF26FF,
    ["minecraft:diamond_ore"] = 0x50F8FFFF,
    ["minecraft:gold_ore"] = 0xFFDF50FF,
    ["minecraft:redstone_ore"] = 0xCC1215FF,
    ["minecraft:lit_redstone_ore"] = 0xCC1215FF,
    ["minecraft:iron_ore"] = 0xFFAC87FF,
    ["minecraft:lapis_ore"] = 0x0A107FFF,
    ["minecraft:coal_ore"] = 0x202020FF,
    ["minecraft:quartz_ore"] = 0xCCCCCCFF
}

ARCore = require("ARCore")
local preparedCanvas = ARCore.prepare(can, fov, ar)

function drawOre(x, y, z, yaw, pitch, color)
    local valid, x, y, d = ARCore.project(x, y, z, preparedCanvas, yaw, pitch, false)
    if valid then can.addText({x - (2 * indicatorSize / d), y - (2 * indicatorSize / d)}, indicator, colour, indicatorSize / d) end
end

function scan()
    while true do
        blocks = modules.scan()
        sleep(.2)
    end
end

function render()
    while true do
        local meta = modules.getMetaOwner()
        local yaw = math.rad(meta.yaw)
        local pitch = math.rad(meta.pitch)
        can.clear()

        for x = -8,8 do
            for y = -8,8 do
                for z = -8,8 do
                    local block = blocks[17^2 * (x + 8) + 17 * (y + 8) + (z + 8) + 1]
                    colour = blocksToShow[block.name]

                    if colour ~= nil then
                        drawOre(block.x - meta.withinBlock.x + .5, -block.y - 0.5 + meta.withinBlock.y, block.z - meta.withinBlock.z + .5, yaw, pitch, colour)
                    end
                end
            end
        end
        sleep(.05)
    end
end

print("oreradar is running...")

parallel.waitForAny(
    render,
    scan
)
