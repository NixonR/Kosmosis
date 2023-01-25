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



class("Labirynt").extends("Level")

local gfx <const> = playdate.graphics




function Labirynt:init()


    -- self.levelimage = gfx.image.new('images/rooms/room_labirynt')
    -- self.levelcollisions = gfx.image.new('images/rooms/room_labirynt_collisions')
    -- Labirynt.super.init(self, self.levelimage, self.levelcollisions)
    -- self.stopPlayerFromMoving = false

end

function Labirynt:loadAssets()
    self.levelimage = gfx.image.new('images/rooms/room_labirynt')
    self.levelcollisions = gfx.image.new('images/rooms/room_labirynt_collisions')
    Labirynt.super.init(self, self.levelimage, self.levelcollisions)
    self.stopPlayerFromMoving = false

    self.blackHole = gfx.sprite.new(gfx.image.new('images/vfx/blackHole'))
    self.blackHole:setZIndex(1003)

end

function Labirynt:goLeft()
end

function Labirynt:goRight()

    -- if self.kosmonaut.kosmonautSprite.x > 378 then
    --     self.kosmonaut.posX = 376
    -- end
    -- if self.kosmonaut.kosmonautSprite.x < 20 then
    --     self.kosmonaut.posX = 22
    -- end

end

function Labirynt:goUp()
    gfx.sprite.removeAll()
    self:changescreen(self, dasherscreen, gfx.image.kDitherTypeBayer8x8)
    dasherscreen.roverPosX = 280
    dasherscreen.roverPosY = -30
    dasherscreen.roverTargetX = 280
    dasherscreen.roverTargetY = 100
    self.kosmonaut:upTransition()
    dasherscreen:addFlowers()
    dasherscreen:addDandelions()
    dasherscreen:addLilDandelions()
    dasherscreen:addEnemyBack()
    dasherscreen.monster.sprite:add()
    if self.kosmonaut.kosmonautSprite.x > 390 then
        self.kosmonaut.posX = 388
    end
    if self.kosmonaut.kosmonautSprite.x < 362 then
        self.kosmonaut.posX = 364
    end

end

function Labirynt:goDown()

    gfx.sprite.removeAll()
    roverisactive = true
    self:changescreen(currentscreen, shipscreen, gfx.image.kDitherTypeBayer8x8)
    shipscreen.roverPosX = 130
    shipscreen.roverPosY = 120
    shipscreen.roverTargetX = 130
    shipscreen.roverTargetY = 120
    if waterfallscreen.sateliteLocked == true then
        shipscreen.roverPosX = 130
        shipscreen.roverPosY = 120
        shipscreen.roverTargetX = 130
        shipscreen.roverTargetY = 120

        shipscreen.currentCharging = shipscreen.animationChargingEnd
    end
    if shipscreen.cutsceneLowBattery == false then
        shipscreen.cable:add()
        shipscreen.batteryIcon:add()
    end
    self.kosmonaut:downTransition()
    
    shipscreen:addFlowers()

    shipscreen.shipSprite:add()
    -- explosivescreen:addDandelions()
    -- explosivescreen:addLilDandelions()
    if self.kosmonaut.kosmonautSprite.x > 199 then
        self.kosmonaut.posX = 177
    end
    if self.kosmonaut.kosmonautSprite.x < 182 then
        self.kosmonaut.posX = 184
    end

end

function Labirynt:updateInput()

end

function Labirynt:updatework()
    self.blackHole:moveTo(self.kosmonaut.posX, self.kosmonaut.posY)
    Labirynt.super.updatework(self)

end

function Labirynt:fadeInCompleted()

    Labirynt.super.fadeInCompleted(self)


end

function Labirynt:checkCollisionsForNode()
    Labirynt.super.checkCollisionsForNode(self)
end

function Labirynt:returnGrid()
    return self.gridTable
end
