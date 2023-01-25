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



class("Short").extends("Level")

local gfx <const> = playdate.graphics




function Short:init()

    self.levelimage = gfx.image.new('images/rooms/room_short')
    self.levelcollisions = gfx.image.new('images/rooms/room_short_collisions')
    Short.super.init(self, self.levelimage, self.levelcollisions)
    --self.kosmonaut.posX = 300
    
end
function Short:loadAssets()
    self.bA = ButtonUI(75, 80, "A")
    -- self.levelimage = gfx.image.new('images/rooms/room_short')
    -- self.levelcollisions = gfx.image.new('images/rooms/room_short_collisions')
    -- Short.super.init(self, self.levelimage, self.levelcollisions)
    -- self.levelimage = gfx.image.new('images/rooms/room_short')
    -- self.levelcollisions = gfx.image.new('images/rooms/room_short_collisions')
    -- Short.super.init(self, self.levelimage, self.levelcollisions)
end
function Short:goLeft()
end

function Short:goRight()
    gfx.sprite.removeAll()
    roverisactive = true
    self:changescreen(currentscreen, shipscreen, "RIGHT")
    if shipscreen.cutsceneLowBattery == true then
    shipscreen.roverPosX = 90
    shipscreen.roverPosY = 120
    shipscreen.roverTargetX = 130
    shipscreen.roverTargetY = 120
    else
        shipscreen.roverPosX = 130
        shipscreen.roverPosY = 120
        shipscreen.roverTargetX = 130
        shipscreen.roverTargetY = 120
    end
    --self.kosmonaut:downTransition()
    if shipscreen.cutsceneLowBattery == false then
        shipscreen.cable:add()
        shipscreen.batteryIcon:add()
    end
   
    shipscreen:addFlowers()
    shipscreen:addDandelions()
    shipscreen:addLilDandelions()
    shipscreen.shipSprite:add()

    if self.kosmonaut.kosmonautSprite.y > 51 then
        self.kosmonaut.posY = 49
    end
    if self.kosmonaut.kosmonautSprite.y < 14 then
        self.kosmonaut.posY = 16
    end
end

function Short:goUp()
    -- if self.kosmonaut.kosmonautSprite.x > 378 then
    --     self.kosmonaut.posX = 376
    -- end
    -- if self.kosmonaut.kosmonautSprite.x < 20 then
    --     self.kosmonaut.posX = 22
    -- end


end

function Short:goDown()

    gfx.sprite.removeAll()
    self:changescreen(currentscreen, explosivescreen, "DOWN")
    explosivescreen.roverPosX = 280
    explosivescreen.roverPosY = -30
    explosivescreen.roverTargetX = 280
    explosivescreen.roverTargetY = 100

    --self.kosmonaut:downTransition()
    explosivescreen:addFlowers()
    explosivescreen:addDandelions()
    explosivescreen:addLilDandelions()
  
    if self.kosmonaut.kosmonautSprite.x > 303 then
        self.kosmonaut.posX = 300
    end
    if self.kosmonaut.kosmonautSprite.x < 34 then
        self.kosmonaut.posX = 36
    end

end

function Short:updateInput()


end

function Short:updatework()

    Short.super.updatework(self)
self.bA:updateWork()
self.jumpDown(self)
end

function Short:checkCollisionsForNode()
    Short.super.checkCollisionsForNode(self)
end

function Short:returnGrid()
    return self.gridTable
end

function Short:jumpDown()
    if self.kosmonaut.posY == 18 and self.kosmonaut.posX < 115 then
        self.bA.uiButtonIsEnabled = true
    else
        self.bA.uiButtonIsEnabled = false
    end
    if self.bA.uiButtonIsEnabled == true and playdate.buttonJustPressed(playdate.kButtonA) then
        self.kosmonaut.posY = 60
        self.landingSound:play()
    end
end

