import "CoreLibs/timer"
import "CoreLibs/sprites"
import "lua/spriteanimation"
import "lua/enemyScripts/enemy"
import "lua/screens/level"


local pd <const> = playdate
local gfx <const> = playdate.graphics

class('LilDandelion').extends()

function LilDandelion:init(x, y)
    -- ZMIENNE--------------------------------------------

    self.dandelionCounter = 0

    --OBRAZKI------------------------------
    self.lilDandelion = gfx.sprite.new()
    self.lilDandelion:setZIndex(10)
    self.lilDandelion:moveTo(x, y)
    self.lilDandelion:setCenter(0.5, 1)
    self.lilDandelion:setCollideRect(5, 3, 10, 25)
    self.lilDandelion:setTag(100)

    -- ANIMACJE -----------------
    self.lilDandelionIdle1 = SpriteAnimation(self.lilDandelion)
    self.lilDandelionIdle1:addImage("images/plants/dandelion_baby2")

    self.lilDandelionIdle2 = SpriteAnimation(self.lilDandelion)
    self.lilDandelionIdle2:addImage("images/plants/dandelion_baby1")

    self.lilDandelionBurned = SpriteAnimation(self.lilDandelion)
    self.lilDandelionBurned:addImage("images/plants/dandelion_baby_burned")

    ----------------------------------------------------------------
    self.currentAnimation1 = self.lilDandelionIdle1
    self.currentAnimation1:updateFrame()
    self.m = 0
    self.burned = false
end

function LilDandelion:updateWork()

    self.changeZIndexDependingOnPlayer(self)
    self.currentAnimation1:updateFrame()

    self.playerIsDead = Kosmonaut:returnPlayerIsDead()
    self.removeIfPlayerDead(self)

    self.animationChange(self)
    self.checkCollision(self)
end

function LilDandelion:changeZIndexDependingOnPlayer()
    self.lilDandelion:setZIndex(self.lilDandelion.y - currentscreen.kosmonaut.posY - 20)

end

function LilDandelion:removeIfPlayerDead()
    if self.playerIsDead == true then
        self.lilDandelion:remove()
    end
end

function LilDandelion:animationChange()
    if self.burned == false then
        self.m += 1
        if self.m == 10 then
            self.r = math.random(1, 50)
            self.m = 0
        end

        if self.r ~= nil and self.r < 5 then
            self.currentAnimation1 = self.lilDandelionIdle1
        else
            self.currentAnimation1 = self.lilDandelionIdle2
        end
    end
    if self.burned == true then
        self.currentAnimation1 = self.lilDandelionBurned
    end
end

function LilDandelion:checkCollision()
    local a, b, collision, length = self.lilDandelion:checkCollisions(self.lilDandelion.x, self.lilDandelion.y)

    if length > 0 and collision[#collision].other:getTag() == (45) then
        self.burned = true

    end
end
