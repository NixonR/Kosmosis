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



class("Ship").extends("Level")

local gfx <const> = playdate.graphics




function Ship:init()

    self.cutsceneLowBattery = true
    self.text1 = TextDisplay(20, 200, "LOW BATTERY. NEED RECHARGING")
    self.text2 = TextDisplay(20, 215, " I'LL STAY HERE ")
    self.text3 = TextDisplay(20, 200, "IM TOO WIDE FOR THIS CAVE")
    self.text4 = TextDisplay(20, 200, "I SHOULD EXPLORE EAST, AT LEAST")
    self.text5 = TextDisplay(20, 200, "MAYBE I SHOULD USE ROVER INSTEAD?")
    self.cutTimer = 0
    self.fakeKosmonautActive = false
    self.fakeKosmoTempX = 0
    self.fakeKosmoTempY = 0

    -- self.levelimage = gfx.image.new('images/rooms/room_ship')
    -- self.levelcollisions = gfx.image.new('images/rooms/room_ship_collisions')
    -- Ship.super.init(self, self.levelimage, self.levelcollisions)

    -- self.shipSprite = gfx.sprite.new(gfx.image.new("images/assets/ship_rocket"))

    -- self.shipSprite:moveTo(200, 120)
    -- self.shipSprite:setCenter(0.5, 0.8)

    -- self.flower1 = Flower(300, 90)
    -- self.flower2 = Flower(100, 170)
    -- self:addFlowerToTable(self.flower1)
    -- self:addFlowerToTable(self.flower2)

end

function Ship:loadAssets()
    self.levelimage = gfx.image.new('images/rooms/room_ship')
    self.levelcollisions = gfx.image.new('images/rooms/room_ship_collisions')
    Ship.super.init(self, self.levelimage, self.levelcollisions)

    self.shipSprite = gfx.sprite.new(gfx.image.new("images/assets/ship_rocket"))
    self.shipSprite:moveTo(200, 120)
    self.shipSprite:setCenter(0.5, 0.8)

    self.cable = gfx.sprite.new(gfx.image.new("images/rover/cable"))
    self.cable:moveTo(170, 120)
    self.flower1 = Flower(300, 90)
    self.flower2 = Flower(350, 170)
    self:addFlowerToTable(self.flower1)
    self:addFlowerToTable(self.flower2)

    if self.cutsceneLowBattery == true then
        self.lowBatterySound = playdate.sound.fileplayer.new("sounds/lowBattery")
    end

    self.batteryIcon = gfx.sprite.new()
    self.batteryIcon:moveTo(130, 90)
    self.batteryIcon:setZIndex(49)

    self.animationCharging = SpriteAnimation(self.batteryIcon)
    self.animationCharging:addImage("images/rover/charging0")
    self.animationCharging:addImage("images/rover/charging1")
    self.animationCharging:addImage("images/rover/charging2")
    self.animationCharging:addImage("images/rover/charging3")

    self.animationChargingEnd = SpriteAnimation(self.batteryIcon)
    self.animationChargingEnd:addImage("images/rover/charging3")
    if waterfallscreen.sateliteLocked == false then
        self.currentCharging = self.animationCharging
    else
        self.currentCharging = self.animationChargingEnd
    end
    self.animationCharging.fps = 3

    self.bA = ButtonUI(100, 120, "A")

    self.fakeKosmonaut = gfx.sprite.new(gfx.image.new("images/kosmonaut/cosmonaut_use"))
    self.fakeKosmonaut:setScale(2)

    self.text3Counter = 205
    self.text4Counter = 205
    self.text5Counter = 205
end

function Ship:goLeft()
    if waterfallscreen.sateliteLocked == false and self.cutsceneLowBattery == false then
        roverisactive = false
    end
    gfx.sprite.removeAll()
    self:changescreen(currentscreen, shortscreen, "LEFT")
    shortscreen.roverPosX = 280
    shortscreen.roverPosY = -30
    shortscreen.roverTargetX = 280
    shortscreen.roverTargetY = 100
    --self.kosmonaut:leftTransition()

    shortscreen:addFlowers()
    shortscreen:addDandelions()
    shortscreen:addLilDandelions()
    if self.kosmonaut.kosmonautSprite.y > 51 then
        self.kosmonaut.posY = 49
    end
    if self.kosmonaut.kosmonautSprite.y < 14 then
        self.kosmonaut.posY = 16
    end
    if self.cutsceneLowBattery == false and self.cutTimer < 300 then
        self.cutTimer = 300
    end
end

function Ship:goRight()
    gfx.sprite.removeAll()
    self:changescreen(self, splitscreen, "RIGHT")
    splitscreen.roverPosX = 280
    splitscreen.roverPosY = -30
    splitscreen.roverTargetX = 280
    splitscreen.roverTargetY = 100
    --self.kosmonaut:rightTransition()
    splitscreen:addFlowers()
    splitscreen:addDandelions()
    splitscreen:addLilDandelions()
    if waterfallscreen.sateliteLocked == false then
        roverisactive = false
    end

    if self.kosmonaut.kosmonautSprite.y > 378 then
        self.kosmonaut.posY = 376
    end
    if self.kosmonaut.kosmonautSprite.y < 69 then
        self.kosmonaut.posY = 71
    end
    if self.cutsceneLowBattery == false and self.cutTimer < 300 then
        self.cutTimer = 300
    end
end

function Ship:goUp()


    roverisactive = false
    gfx.sprite.removeAll()
    gfx.clear()
    self:changescreen(self, labiryntscreen, gfx.image.kDitherTypeBayer8x8)

    labiryntscreen.blackHole:add()
    self.kosmonaut:upTransition()
    labiryntscreen:addFlowers()
    labiryntscreen:addDandelions()
    labiryntscreen:addLilDandelions()
    if self.kosmonaut.kosmonautSprite.x > 199 then
        self.kosmonaut.posX = 177
    end
    if self.kosmonaut.kosmonautSprite.x < 182 then
        self.kosmonaut.posX = 184
    end

    if self.cutsceneLowBattery == false and self.cutTimer < 300 then
        self.cutTimer = 300
    end
end

function Ship:goDown()



end

function Ship:updateInput()

end

function Ship:updatework()

    Ship.super.updatework(self)
    self.changeShipSpriteZIndex(self)
    self.cutsceneLowBatteryInit(self)
    
    self.currentCharging:updateFrame()
    self.bA:updateWork()
    self.changeToRover(self)

    if self.kosmonaut.isRover == true then
        if self.kosmonaut.posY < 12 and self.text3Counter > 200 then
            self.text3Counter = 0
            self.text3.clipX = 0
        end
        if self.kosmonaut.posX < 17 and self.text4Counter > 200 then
            self.text4Counter = 0
            self.text4.clipX = 0
        end
        if self.kosmonaut.posY < 12 then
            self.kosmonaut.posY = 12
        end
        if self.kosmonaut.posX < 17 then
            self.kosmonaut.posX = 17
        end

    end
end

function Ship:checkCollisionsForNode()
    Ship.super.checkCollisionsForNode(self)
end

function Ship:returnGrid()
    return self.gridTable
end

function Ship:changeShipSpriteZIndex()
    self.shipSprite:setZIndex(self.shipSprite.y - currentscreen.kosmonaut.posY)
    self.cable:setZIndex(self.shipSprite.y - currentscreen.kosmonaut.posY + 1)


end

function Ship:cutsceneLowBatteryInit()
    if (self.kosmonaut.posX > 390 or self.kosmonaut.posY < 10) and self.cutsceneLowBattery == true then
        self.cutsceneLowBattery = false
        self.lowBatterySound:play()
        self.stopPlayerFromMoving = true
        playdate.timer.performAfterDelay(3000, function()
            self.stopPlayerFromMoving = false
        end)
    end

end

function Ship:draw()
    Ship.super.draw()

    if self.kosmonaut.isRover == true and self.text3Counter < 205 then
        self.text3Counter += 1
    end
    if self.kosmonaut.isRover == true and self.text4Counter < 205 then
        self.text4Counter += 1
    end
    if self.kosmonaut.isRover == false and self.text5Counter < 205 then
        self.text5Counter += 1
    end
    if self.cutTimer < 300 and self.cutsceneLowBattery == false then
        self.cutTimer += 1
    end
    if self.cutTimer > 1 and self.cutTimer < 300 then
        self.text1:updateWork()
        self.text1:draw()
    end
    if self.cutTimer > 115 and self.cutTimer < 300 then
        self.text2:updateWork()
        self.text2:draw()
    end

    if self.text3Counter < 200 then
        self.text3:updateWork()
        self.text3:draw()
    end

    if self.text4Counter < 200 then
        self.text4:updateWork()
        self.text4:draw()
    end
    if self.text5Counter < 200 then
        self.text5:updateWork()
        self.text5:draw()
    end
end

function Ship:changeToRover()

    if waterfallscreen.sateliteLocked == true and self.cutsceneLowBattery == false and self.kosmonaut.isRover == false then
        if self.kosmonaut.posX < 160 and self.kosmonaut.posX > 100 and self.kosmonaut.posY < 155 and
            self.kosmonaut.posY > 90 then
            self.bA.uiButtonIsEnabled = true
        else
            self.bA.uiButtonIsEnabled = false
        end

        if self.bA.uiButtonIsEnabled == true and playdate.buttonJustPressed(playdate.kButtonA) then
            self.kosmonaut.isRover = true
            self.batteryIcon:remove()
            self.fakeKosmonaut:add()
            self.fakeKosmonautActive = true
            self.fakeKosmoTempX = self.kosmonaut.posX
            self.fakeKosmoTempY = self.kosmonaut.posY
            self.fakeKosmonaut:moveTo(self.fakeKosmoTempX, self.fakeKosmoTempY)
            self.kosmonaut.posX = 130
            self.kosmonaut.posY = 120
        end
    end
end
