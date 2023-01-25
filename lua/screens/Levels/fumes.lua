import "lua/screens/screen"
import "lua/screens/level"
import "lua/kosmonaut"
import "lua/enemyScripts/gutter/gutter"
import "CoreLibs/sprites"
import "CoreLibs/graphics"
import "CoreLibs/timer"
import "CoreLibs/crank"
import "CoreLibs/object"
import "lua/enemyScripts/dandelion/dandelionenemy"



class("Fumes").extends("Level")

local gfx <const> = playdate.graphics




function Fumes:init()


    self.levelimage = gfx.image.new('images/rooms/room_fumes')
    self.levelcollisions = gfx.image.new('images/rooms/room_fumes_collisions')
    Fumes.super.init(self, self.levelimage, self.levelcollisions)

    self.fadeOutTime_ms = 2000
    self.fartSprite = gfx.sprite.new()
    self.fartSprite:moveTo(365, 130)
    self.fartSpriteAnim = SpriteAnimation(self.fartSprite)
    self.fartSpriteAnim:addImage("images/assets/fumes_fart_1")
    self.fartSpriteAnim:addImage("images/assets/fumes_fart_2")
    self.fartSpriteAnim:addImage("images/assets/fumes_fart_3")
    self.fartSpriteAnim:addImage("images/assets/fumes_fart_3")
    self.fartSpriteAnim:addImage("images/assets/fumes_fart_2")
    self.fartSpriteAnim:addImage("images/assets/fumes_fart_1")
    self.fartSpriteAnim.fps = 3

    self.rockPlugSprite = gfx.sprite.new(gfx.image.new("images/assets/fumes_rock"))
    self.rockPlugSprite:moveTo(70, 150)
    self.rockPlugSprite:setCollideRect(0, 0, 28, 28)
    self.rockPlugSpriteLocked = false

    self.rockSlideYValue = 0.3

    self.text1 = TextDisplay(20, 200, "TOXIC FUMES, SUIT IS NOT PREPARED FOR THIS")

    self.bigFog = gfx.sprite.new(gfx.image.new("images/assets/bigFog"))
    self.bigFog:setCenter(0, 0)
    self.bigFog:moveTo(-800, 0)
    self.bigFog:setZIndex(1000)

    self.bigFog2 = gfx.sprite.new(gfx.image.new("images/assets/bigFog"))
    self.bigFog2:setCenter(0, 0)
    self.bigFog2:moveTo(402, 0)
    self.bigFog2:setZIndex(1000)
    self.fogCounter = 0



end

function Fumes:loadAssets()
    self.text1Counter = 0
    self.text1.clipX = 0
    self.cough = playdate.sound.fileplayer.new("sounds/coughFumes")

end

function Fumes:goLeft()
    gfx.sprite.removeAll()
    self:changescreen(self, splitscreen, "LEFT")
    splitscreen.roverPosX = 280
    splitscreen.roverPosY = -30
    splitscreen.roverTargetX = 280
    splitscreen.roverTargetY = 100
    --self.kosmonaut:downTransition()
    splitscreen:addFlowers()
    splitscreen:addDandelions()
    splitscreen:addLilDandelions()
    -- if self.kosmonaut.kosmonautSprite.x > 378 then
    --     self.kosmonaut.posX = 376
    -- end
    -- if self.kosmonaut.kosmonautSprite.x < 20 then
    --     self.kosmonaut.posX = 22
    -- end
end

function Fumes:goUp()
    gfx.sprite.removeAll()
    self:changescreen(self, preludescreen, "UP")
    preludescreen.roverPosX = 280
    preludescreen.roverPosY = -30
    preludescreen.roverTargetX = 280
    preludescreen.roverTargetY = 100
    --self.kosmonaut:downTransition()
    preludescreen:addFlowers()
    preludescreen:addDandelions()
    preludescreen:addLilDandelions()
    -- if self.kosmonaut.kosmonautSprite.x > 378 then
    --     self.kosmonaut.posX = 376
    -- end
    -- if self.kosmonaut.kosmonautSprite.x < 20 then
    --     self.kosmonaut.posX = 22
    -- end


end

function Fumes:goRight()

end

function Fumes:goDown()

end

function Fumes:updateInput()

end

function Fumes:updatework()
    self.fogCounter += 1
    if self.fogCounter == 5 then
        self.bigFog:add()
        self.bigFog:moveTo(self.bigFog.x + 2, 0)

        self.bigFog2:add()
        self.bigFog2:moveTo(self.bigFog2.x + 2, 0)
        self.fogCounter = 0
    end
    if self.bigFog.x == 0 then
        self.bigFog2:moveTo(-1200, 0)
    end
    if self.bigFog2.x == 0 then
        self.bigFog:moveTo(-1200, 0)
    end

    Fumes.super.updatework(self)
    self.fartSpriteAnim:updateFrame()
    self.fartSprite:add()
    self.rockPlugSprite:add()
    self.checkRockCollision(self)
    if self.rockPlugSpriteLocked == false then
        self.changeToShip(self)
    end
end

function Fumes:checkCollisionsForNode()
    Fumes.super.checkCollisionsForNode(self)
end

function Fumes:returnGrid()
    return self.gridTable
end

function Fumes:checkRockCollision()
    local a, b, collision, length = self.rockPlugSprite:checkCollisions(self.rockPlugSprite.x, self.rockPlugSprite.y)
    if self.rockPlugSpriteLocked == false then
        if length > 0 and collision[#collision].other:getTag() == (18) then
            if self.kosmonaut.posY > self.rockPlugSprite.y then
                self.rockSlideYValue = -0.3
            else
                self.rockSlideYValue = 0.3
            end
            if self.kosmonaut.kosmonautSprite.x < self.rockPlugSprite.x and
                playdate.buttonIsPressed(playdate.kButtonRight) then
                self.rockPlugSprite:moveTo(self.rockPlugSprite.x + self.kosmonaut.speed, self.rockPlugSprite.y)
            elseif self.kosmonaut.kosmonautSprite.x > self.rockPlugSprite.x and
                playdate.buttonIsPressed(playdate.kButtonLeft) then
                self.rockPlugSprite:moveTo(self.rockPlugSprite.x - self.kosmonaut.speed, self.rockPlugSprite.y)
            end
            -- if self.kosmonaut.kosmonautSprite.y < self.rockPlugSprite.y and
            --     playdate.buttonIsPressed(playdate.kButtonDown) then
            --     self.rockPlugSprite:moveTo(self.rockPlugSprite.x, self.rockPlugSprite.y + self.kosmonaut.speed)
            -- elseif self.kosmonaut.kosmonautSprite.y > self.rockPlugSprite.y and
            --     playdate.buttonIsPressed(playdate.kButtonUp) then
            --     self.rockPlugSprite:moveTo(self.rockPlugSprite.x, self.rockPlugSprite.y - self.kosmonaut.speed)
            -- end
            --self.boneSound:play()
        end
        if self.rockPlugSprite.x < 370 and self.rockPlugSprite.x > 80 and length == 0 then
            self.rockPlugSprite:moveTo(self.rockPlugSprite.x - 0.3, self.rockPlugSprite.y)
        elseif self.rockPlugSprite.x < 370 and length > 0 then
            self.rockPlugSprite:moveTo(self.rockPlugSprite.x, self.rockPlugSprite.y + self.rockSlideYValue)
        end
    end

    if self.rockPlugSprite.x > 355 and self.rockPlugSprite.y < 140 and self.rockPlugSprite.y > 120 then
        self.rockPlugSprite:moveTo(360, 130)
        self.rockPlugSpriteLocked = true
        self.fadeOutTime_ms = 400
    end

    --360 130
end

function Fumes:rockSliding()

end

function Fumes:draw()
    Ship.super.draw()

    if self.kosmonaut.isRover == false and self.rockPlugSpriteLocked == false then
        self.text1Counter += 1
    end
    if self.text1Counter > 1 and self.text1Counter < 300 and self.rockPlugSpriteLocked == false then
        self.text1:updateWork()
        self.text1:draw()

    end

end

function Fumes:changeToShip()
    if self.text1Counter == 15 then
        self.stopPlayerFromMoving = true
        self.cough:play()
    end
    if self.text1Counter == 220 then
        gfx.sprite.removeAll()
        self:changescreen(currentscreen, shipscreen, gfx.image.kDitherTypeBayer8x8)
        shipscreen.text5Counter = 0
        roverisactive = true
        shipscreen.stopPlayerFromMoving = false
        self.kosmonaut.posX = 280
        self.kosmonaut.posY = 120
        shipscreen.roverPosX = 130
        shipscreen.roverPosY = 120
        shipscreen.roverTargetX = 130
        shipscreen.roverTargetY = 120
        --self.kosmonaut:downTransition()
        if shipscreen.cutsceneLowBattery == false then
            shipscreen.cable:add()
            shipscreen.batteryIcon:add()
        end
        shipscreen:addFlowers()
        shipscreen:addDandelions()
        shipscreen:addLilDandelions()
        shipscreen.shipSprite:add()

    end
end
