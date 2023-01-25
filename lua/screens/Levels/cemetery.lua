import "lua/screens/screen"
import "lua/screens/level"
import "lua/kosmonaut"
import "lua/enemyScripts/gutter/gutter"
import "CoreLibs/sprites"
import "CoreLibs/graphics"
import "CoreLibs/timer"
import "CoreLibs/crank"
import "CoreLibs/object"



class("Cemetery").extends("Level")

local gfx <const> = playdate.graphics

function Cemetery:init()

    self.levelimage = gfx.image.new('images/rooms/room_cemetery')
    self.levelcollisions = gfx.image.new('images/rooms/room_cemetery_collisions')
    self.col1 = gfx.image.new('images/rooms/room_cemetery_collisions')
    self.col2 = gfx.image.new('images/rooms/room_cemetery_collisions2')
    Cemetery.super.init(self, self.levelimage, self.levelcollisions)
    self.gutterIntro2 = true

    self.fakeGutter1 = FakeGutter(180, 210, 430, 220) --pozycja X, pozycja Y, docelowa pozycja X, docelowa pozycja Y
    self.fakeGutter2 = FakeGutter(160, 230, 430, 220)
    self:addFakeGutterToTable(self.fakeGutter1)
    self:addFakeGutterToTable(self.fakeGutter2)
    self.fakeGutterTable[0].scenario = 2
    self.fakeGutterTable[1].scenario = 1
    self.boneBridge = gfx.sprite.new(gfx.image.new('images/assets/skelet_vertical'))
    self.boneBridge:moveTo(170, 70)
    self.boneBridge:setCollideRect(0, 0, 28, 25)
    self.boneLocked = false
    self.boneLockedSound = playdate.sound.fileplayer.new("sounds/mainBlink")
    self.bonePlaced = playdate.sound.fileplayer.new("sounds/8bit_hit")
    self.boneSound = playdate.sound.fileplayer.new("sounds/boneMove")



    self.playerWasHere = false
end

function Cemetery:goLeft()

    gfx.sprite.removeAll()
    self.removeEnemies(self)
    self:changescreen(currentscreen, dandelionsscreen, "LEFT")
    dandelionsscreen.roverPosX = 420
    dandelionsscreen.roverPosY = 120
    dandelionsscreen.roverTargetX = 170
    dandelionsscreen.roverTargetY = 135
    dandelionsscreen:addEnemyBack()
    dandelionsscreen:addDandelions()
    dandelionsscreen:addLilDandelions()
    self.playerWasHere = true
    self.fakeGutterTable[0] = nil
    self.fakeGutterTable[1] = nil

    if self.kosmonaut.kosmonautSprite.y > 142 then
        self.kosmonaut.posY = 141
    end
    if self.kosmonaut.kosmonautSprite.y < 105 then
        self.kosmonaut.posY = 106
    end
    if dandelionsscreen.cutsceneBurning == true then
        dandelionsscreen:dandelionShootIsTrue()
    end
    if self.boneLocked == false then
        self.boneBridge:moveTo(170, 70)
    end

    
end

function Cemetery:goRight()


    gfx.sprite.removeAll()


    self.removeEnemies(self)
    self:changescreen(currentscreen, gutternestscreen, "RIGHT")
    gutternestscreen.roverPosX = -30
    gutternestscreen.roverPosY = 100
    gutternestscreen.roverTargetX = 220
    gutternestscreen.roverTargetY = 100
    if roverisactive == false then
        gutternestscreen:addEnemyBack()
    else
        gutternestscreen:removeEnemiesFromTable()
    end
        
    gutternestscreen:addDandelions()
    gutternestscreen:addLilDandelions()

    self.playerWasHere = true
    self.fakeGutterTable[0] = nil
    self.fakeGutterTable[1] = nil
    if self.boneLocked == false then
        self.boneBridge:moveTo(170, 70)
    end


end

function Cemetery:goUp()
    gfx.sprite.removeAll()
   roverisactive = false
    self.removeEnemies(self)
    self:changescreen(currentscreen, secretscreen, "UP")
    secretscreen:addEnemyBack()
    secretscreen:addEnemyBack()
    secretscreen:addDandelions()
    self.playerWasHere = true
    if secretscreen.secretBoxBool == true then
        secretscreen.secretBoxSprite:add()
    end

    if self.kosmonaut.kosmonautSprite.x > 217 then
        self.kosmonaut.posX = 216
    end
    if self.kosmonaut.kosmonautSprite.x < 169 then
        self.kosmonaut.posX = 170
    end

end

function Cemetery:goDown()

end

function Cemetery:updateInput()
    if self.boneLocked == false then
        if self.kosmonaut.kosmonautSprite.y < 25 then
            self.kosmonaut.posY = 25

        end
    end
end

function Cemetery:updatework()
    Cemetery.super.updatework(self)
    self.updateInput(self)

    self.moveBone(self)
end

function Cemetery:addEnemy(enemy)
    Cemetery.super.addEnemy(self, enemy)

end

function Cemetery:checkCollisionsForNode()
    Cemetery.super.checkCollisionsForNode(self)
end

function Cemetery:returnGrid()
    return self.gridTable
end

function Cemetery:removeEnemies()
    Cemetery.super.removeEnemies(self)
end

function Cemetery:addEnemyBack()
    Cemetery.super.addEnemyBack(self)
end

function Cemetery:restart()


end

function Cemetery:moveBone()

    local a, b, collision, length = self.boneBridge:checkCollisions(self.boneBridge.x, self.boneBridge.y)
    if self.boneLocked == false then
        if length > 0 and collision[#collision].other:getTag() == (1) then



            if self.kosmonaut.kosmonautSprite.x < self.boneBridge.x and playdate.buttonIsPressed(playdate.kButtonRight) then
                self.boneBridge:moveTo(self.boneBridge.x + 2, self.boneBridge.y)
            elseif self.kosmonaut.kosmonautSprite.x > self.boneBridge.x and
                playdate.buttonIsPressed(playdate.kButtonLeft) then
                self.boneBridge:moveTo(self.boneBridge.x - 2, self.boneBridge.y)
            end
            if self.kosmonaut.kosmonautSprite.y < self.boneBridge.y and playdate.buttonIsPressed(playdate.kButtonDown) then
                self.boneBridge:moveTo(self.boneBridge.x, self.boneBridge.y + 2)
            elseif self.kosmonaut.kosmonautSprite.y > self.boneBridge.y and playdate.buttonIsPressed(playdate.kButtonUp)
                and self.boneBridge.y > 15 then
                self.boneBridge:moveTo(self.boneBridge.x, self.boneBridge.y - 2)
            end
            self.boneSound:play()


        end
    end
    if self.boneBridge.x < 210 and self.boneBridge.x > 190 and self.boneBridge.y > 0 and self.boneBridge.y < 30 and
        self.boneLocked == false then
        self.boneLocked = true
        self.boneBridge:moveTo(200, 15)
        self.boneLockedSound:play()
        self.bonePlaced:play()
    end
end
