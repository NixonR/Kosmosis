import "lua/screens/screen"
import "lua/screens/level"
import "lua/kosmonaut"
import "lua/enemyScripts/gutter/gutter"
import "CoreLibs/sprites"
import "CoreLibs/graphics"
import "CoreLibs/timer"
import "CoreLibs/crank"
import "CoreLibs/object"
import "lua/screens/cutscenewelcome"
import "lua/rover"


class("CargoEndRover").extends("Level")

local gfx <const> = playdate.graphics




function CargoEndRover:init()


    -- self.levelimage = gfx.image.new('images/rooms/room_cargo')
    -- self.levelcollisions = gfx.image.new('images/rooms/room_cargo_collisions')
    -- CargoEndRover.super.init(self, self.levelimage, self.levelcollisions)
    -- local roverImage = gfx.image.new("images/hvsar/hvsar_down1")
    -- self.roverSprite = gfx.sprite.new(roverImage)
    -- self.roverSprite:moveTo(129, 79)

    -- self.roverCounter = 0
    -- self.fakeGutter1 = FakeGutter(60, 270)
    -- self.fakeGutter2 = FakeGutter(80, 290)
    -- self.fakeGutter3 = FakeGutter(120, 260)
    -- self.fakeGutter4 = FakeGutter(150, 300)
    -- self.fakeGutter5 = FakeGutter(40, 350)
    -- self.fakeGutter6 = FakeGutter(60, 370)
    -- self.fakeGutter7 = FakeGutter(130, 400)

    -- self:addFakeGutterToTable(self.fakeGutter1)
    -- self:addFakeGutterToTable(self.fakeGutter2)
    -- self:addFakeGutterToTable(self.fakeGutter3)
    -- self:addFakeGutterToTable(self.fakeGutter4)
    -- self:addFakeGutterToTable(self.fakeGutter5)
    -- self:addFakeGutterToTable(self.fakeGutter6)
    -- self:addFakeGutterToTable(self.fakeGutter7)

    -- self.fakeGutterTable[0].endScenario = "down"
    -- self.fakeGutterTable[1].endScenario = "down"
    -- self.fakeGutterTable[2].endScenario = "down"
    -- self.fakeGutterTable[3].endScenario = "down"

    -- self.fakeGutterTable[4].endScenario = "down"
    -- self.fakeGutterTable[5].endScenario = "down"
    -- self.fakeGutterTable[6].endScenario = "down"
    -- self.roverPosX = 150
    -- self.roverPosY = 91
    -- self.roverTargetX = 150
    -- self.roverTargetY = 91


    -- self.stopPlayerFromMoving = true
    -- self.roverOut = true
    -- self.entrySoundForWelcome = playdate.sound.fileplayer.new("sounds/kosmosisLogo")
    -- self.roverDrive = playdate.sound.sampleplayer.new("sounds/roverRide")

end

function CargoEndRover:loadAssets()
    
    self.levelimage = gfx.image.new('images/rooms/room_cargo')
    self.levelcollisions = gfx.image.new('images/rooms/room_cargo_collisions')
    CargoEndRover.super.init(self, self.levelimage, self.levelcollisions)
    local roverImage = gfx.image.new("images/hvsar/hvsar_down1")
    self.roverSprite = gfx.sprite.new(roverImage)
    self.roverSprite:moveTo(129, 79)

    self.roverCounter = 0
    self.fakeGutter1 = FakeGutter(60, 250)
    self.fakeGutter2 = FakeGutter(80, 270)
    self.fakeGutter3 = FakeGutter(120, 260)
    self.fakeGutter4 = FakeGutter(150, 280)
    self.fakeGutter5 = FakeGutter(40, 270)
    self.fakeGutter6 = FakeGutter(60, 280)
    self.fakeGutter7 = FakeGutter(130, 250)

    self:addFakeGutterToTable(self.fakeGutter1)
    self:addFakeGutterToTable(self.fakeGutter2)
    self:addFakeGutterToTable(self.fakeGutter3)
    self:addFakeGutterToTable(self.fakeGutter4)
    self:addFakeGutterToTable(self.fakeGutter5)
    self:addFakeGutterToTable(self.fakeGutter6)
    self:addFakeGutterToTable(self.fakeGutter7)

    self.fakeGutterTable[0].endScenario = "down"
    self.fakeGutterTable[1].endScenario = "down"
    self.fakeGutterTable[2].endScenario = "down"
    self.fakeGutterTable[3].endScenario = "down"

    self.fakeGutterTable[4].endScenario = "down"
    self.fakeGutterTable[5].endScenario = "down"
    self.fakeGutterTable[6].endScenario = "down"
    self.roverPosX = 150
    self.roverPosY = 91
    self.roverTargetX = 150
    self.roverTargetY = 91


    self.stopPlayerFromMoving = true
    self.roverOut = true
    self.entrySoundForWelcome = playdate.sound.fileplayer.new("sounds/kosmosisLogo")
    self.roverDrive = playdate.sound.sampleplayer.new("sounds/roverRide")
    
end
function CargoEndRover:goLeft()
end

function CargoEndRover:goRight()
end

function CargoEndRover:goUp()


end

function CargoEndRover:goDown()


end

function CargoEndRover:updateInput()

end

function CargoEndRover:updatework()
    CargoEndRover.super.updatework(self)
    self.addFakeGutter(self)
    Kosmonaut.currentAnimation = Kosmonaut.animationIdleDown

    self.updateInput(self)

    self.cutsceneBar = true


    roverisactive = true
    self.rover.spriteBase:add()
    self.rover.turret:add()
    if self.roverCounter < 150 then
        self.roverCounter += 1
    end
    if self.roverCounter > 70 and self.roverCounter < 90 then
        self.roverTargetX = 150
        self.roverTargetY = 140
    end
    if self.roverCounter > 90 then
        self.roverTargetX = 120
        self.roverTargetY = 140
    end
    if self.roverCounter > 145 then
        if self.roverOut == true then
            self.roverOut = false
            playdate.timer.performAfterDelay(4000, function()
                self:changescreen(currentscreen, cutscenewelcomescreen, gfx.image.kDitherTypeBayer8x8)
                --print("changing screen to rover welcome")
                self.entrySoundForWelcome:play()
                gfx.clear()
                gfx.sprite:removeAll()
            end)
        end

    end
end

function CargoEndRover:addEnemy(enemy)
    CargoEndRover.super.addEnemy(self, enemy)

end

function CargoEndRover:returnGrid()
    return self.gridTable
end

function CargoEndRover:removeEnemies()
    CargoEndRover.super.removeEnemies(self)
end

function CargoEndRover:addEnemyBack()
    CargoEndRover.super.addEnemyBack(self)
end

function CargoEndRover:roverGetsOut()
    if self.roverCounter > 70 then

        self.roverSprite:add()
    end


    if self.roverCounter > 100 and self.roverSprite.y < 130 then
        self.roverSprite:moveTo(self.roverSprite.x, self.roverSprite.y + 1)
        self.roverDrive:play()
        self.roverCounter -= 3

    end

end


function CargoEndRover:restart()
    self.roverSprite:moveTo(129, 79)
    self.roverCounter = 0
    self.stopPlayerFromMoving = true
    self.roverOut = true
end

--ROVER MOVEMENT FOR FUN
-- if playdate.buttonIsPressed(playdate.kButtonRight) then
--     self.roverSprite:moveTo(self.roverSprite.x + 1, self.roverSprite.y)
-- end
-- if playdate.buttonIsPressed(playdate.kButtonLeft) then
--     self.roverSprite:moveTo(self.roverSprite.x - 1, self.roverSprite.y)
-- end
-- if playdate.buttonIsPressed(playdate.kButtonUp) then
--     self.roverSprite:moveTo(self.roverSprite.x, self.roverSprite.y - 1)
-- end
-- if playdate.buttonIsPressed(playdate.kButtonDown) then
--     self.roverSprite:moveTo(self.roverSprite.x, self.roverSprite.y + 1)
-- end
