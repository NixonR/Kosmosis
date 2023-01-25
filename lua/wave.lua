import "CoreLibs/graphics"
import "CoreLibs/object"

local gfx <const> = playdate.graphics
local timer = 0;
local amplitude = 5;

class("wave").extends()

function wave:getoffsety()
    return 2 * amplitude;
end

function wave:update()
    timer = playdate.getElapsedTime() * 4
    amplitude = 2 + 0.6 * math.sin(timer / 1);
end

function wave:draw()
    gfx.drawSineWave(0, 120, 400, 120, amplitude, amplitude, 20, 4 * amplitude)
end

