import "CoreLibs/timer"
import "CoreLibs/sprites"
import "lua/spriteanimation"
import "lua/enemyScripts/enemy"
import "lua/screens/level"
import "CoreLibs/ui"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class('CrankIndicator').extends()

function CrankIndicator:init()
    self.crankMoved = true
    self.crankInfoTimer = 0
    playdate.ui.crankIndicator:start()
end

function CrankIndicator:updateInput()

end

function CrankIndicator:updateWork()
    
    self.crank(self)
    if self.crankMoved == false then
        playdate.ui.crankIndicator:update()
    end
end


function CrankIndicator:crank()
    if playdate.getCrankChange() > 1 or playdate.getCrankChange() < -1 then
        self.crankMoved = true
        self.crankInfoTimer = 0
    else
        --print("kkkkkkkkkk")
        self.crankInfoTimer += 1
        if self.crankInfoTimer > 100 then
            self.crankMoved = false
            self.crankInfoTimer =0
        end
    end
end