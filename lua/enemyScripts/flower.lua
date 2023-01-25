import "CoreLibs/timer"
import "CoreLibs/sprites"
import "lua/spriteanimation"
import "lua/enemyScripts/enemy"
import "lua/screens/level"


local pd <const> = playdate
local gfx <const> = playdate.graphics

class('Flower').extends()

function Flower:init(x, y)

    --OBRAZKI------------------------------
    self.flower = gfx.sprite.new()
    self.flower:setZIndex(10)
    self.flower:moveTo(x, y)
    self.flower:setCenter(0.5, 1)
    self.flower:setCollideRect(10, 40, 30, 13)
    self.flower:setTag(99)

    self.roots = gfx.sprite.new(gfx.image.new("images/plants/flower_roots"))
    self.roots:setZIndex(11)
    self.roots:moveTo(x, y + 8)
    self.roots:setCenter(0.5, 1)
    self.roots:setTag(99)

    -- ANIMACJE -----------------
    self.flower1 = SpriteAnimation(self.flower)
    self.flower1:addImage("images/plants/flower_open")

    self.flower2 = SpriteAnimation(self.flower)
    self.flower2:addImage("images/plants/flower_open2")

    self.flower3 = SpriteAnimation(self.flower)
    self.flower3:addImage("images/plants/flower_close")
    self.dx = 0
    self.dy = 0
    self.rx = 0
    self.ry = 0

    self.animationCounter = 0




    self.currentAnimation1 = self.flower1
    self.currentAnimation1:updateFrame()
    self.flowerSound1 = playdate.sound.sampleplayer.new("sounds/flower")
    self.flowerSound1:setVolume(0.2)
end

function Flower:updateWork()
    self.dx = math.abs(Kosmonaut:playerPositionX() - self.flower.x)
    self.dy = math.abs(Kosmonaut:playerPositionY() - self.flower.y)
    
    self.rx = math.abs(currentscreen.rover.spriteBase.x - self.flower.x)
    self.ry = math.abs(currentscreen.rover.spriteBase.y - self.flower.y)
    if (self.dx < 70 and self.dy < 70) or (self.rx < 70 and self.ry < 70) then


        self.changeZIndexDependingOnPlayer(self)
        self.currentAnimation1:updateFrame()
        self.animationChange(self)
        self.playerIsDead = Kosmonaut:returnPlayerIsDead()
        self.removeIfPlayerDead(self)
    end


end

function Flower:changeZIndexDependingOnPlayer()
    self.flower:setZIndex(self.flower.y - currentscreen.kosmonaut.posY - 20)
    self.roots:setZIndex(self.roots.y - currentscreen.kosmonaut.posY - 20)
    -- if Kosmonaut:playerPositionY() > self.flower.y - 20 then
    -- else
    --     self.flower:setZIndex(currentscreen.kosmonaut.kosmonautSprite:getZIndex()+ 1)
    --     self.roots:setZIndex(currentscreen.kosmonaut.kosmonautSprite:getZIndex()+2)
    -- end

end

function Flower:animationChange()
    --print(self.animationCounter, "animation counter")
    if (self.dx > 60 or self.dy > 60) and (self.rx > 60 or self.ry > 60) then
        if self.animationCounter < 4 then -- opening
            self.animationCounter += 1

        end
    end

    if (self.dx < 60 and self.dy < 60) or (self.rx < 60 and self.ry < 60) then
        if self.animationCounter > 0 then
            self.animationCounter -= 1 -- closing
        end
    end

    if self.animationCounter == 0 then
        self.currentAnimation1 = self.flower3
    end
    if self.animationCounter == 1 or self.animationCounter == 2 then
        self.currentAnimation1 = self.flower2
    end
    if self.animationCounter == 2 then
        self.flowerSound1:play()
    end
    if self.animationCounter == 3 then
        self.currentAnimation1 = self.flower1
    end


end

function Flower:removeIfPlayerDead()
    if self.playerIsDead == true then
        self.flower:remove()
        self.roots:remove()

    end
end
