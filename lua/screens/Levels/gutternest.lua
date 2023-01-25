import "lua/screens/screen"
import "lua/screens/level"
import "lua/kosmonaut"
import "lua/enemyScripts/gutter/gutter"
import "CoreLibs/sprites"
import "CoreLibs/graphics"
import "CoreLibs/timer"
import "CoreLibs/crank"
import "CoreLibs/object"



class("GutterNest").extends("Level")

local gfx <const> = playdate.graphics



local px
local py
function GutterNest:init()


    self.levelimage = gfx.image.new('images/rooms/room_gutter_nest')
    self.levelcollisions = gfx.image.new('images/rooms/room_gutter_nest_collisions')
    GutterNest.super.init(self, self.levelimage, self.levelcollisions)

    self.gutter1 = Gutter(270, 140)

    self:addEnemy(self.gutter1)
    self.resetBool = false

    self.fadeCeilValue = 1

    self.shadow = gfx.sprite.new(gfx.image.new("images/assets/screeneffect_dark50_nest"))
    self.shadow:setZIndex(88)
    self.shadow:moveTo(201, 120)
    self.dandelion1 = DandelionEnemy(330, 45)
    self:addDandelionToTable(self.dandelion1)
    self.dandelion2 = DandelionEnemy(290, 50)
    self:addDandelionToTable(self.dandelion2)

    self.lildandelion1 = LilDandelion(260, 30)
    self:addLilDandelionsToTable(self.lildandelion1)
    self.lildandelion2 = LilDandelion(300, 35)
    self:addLilDandelionsToTable(self.lildandelion2)
    self.lildandelion3 = LilDandelion(280, 27)
    self:addLilDandelionsToTable(self.lildandelion3)
    self.lildandelion4 = LilDandelion(320, 30)
    self:addLilDandelionsToTable(self.lildandelion4)
    self.lildandelion5 = LilDandelion(340, 35)
    self:addLilDandelionsToTable(self.lildandelion5)
    self.lildandelion6 = LilDandelion(360, 40)
    self:addLilDandelionsToTable(self.lildandelion6)
    self.bushSound1 = playdate.sound.fileplayer.new("sounds/bush1")
    self.bushSound2 = playdate.sound.fileplayer.new("sounds/bush2")
    self.soundNum = 1

    self.canPassUp = false
    self.roverTargetX = 310
    self.roverTargetY = 100
    self.cutsceneBurning = true
    self.roverBurningCounter = 0
    self.stopPlayerFromMoving = false


end

function GutterNest:goLeft()

    gfx.sprite:removeAll()
    gfx.clear()
    self.removeEnemies(self)
    self:changescreen(self, cemeteryscreen, "LEFT")
    cemeteryscreen.roverPosX = 420
    cemeteryscreen.roverPosY = 85
    cemeteryscreen.roverTargetX = 200
    cemeteryscreen.roverTargetY = 120
    cemeteryscreen:addEnemyBack()
    cemeteryscreen:addDandelions()
    cemeteryscreen.boneBridge:add()
    if self.kosmonaut.kosmonautSprite.y > 140 then
        self.kosmonaut.posY = 139
    end
    if self.kosmonaut.kosmonautSprite.y < 77 then
        self.kosmonaut.posY = 78
    end
end

function GutterNest:goRight()
end

function GutterNest:goDown()
    gfx.clear()
    gfx.sprite:removeAll()
    crankscreen.shadow:add()

    self.removeEnemies(self)
    self:changescreen(self, crankscreen, "DOWN")
    if roverisactive == false then
        crankscreen:addEnemyBack()
    else
        crankscreen:removeEnemiesFromTable()
    end
    roverisactive = false
    crankscreen:addDandelions()

    if crankscreen.crankBool == true then
        crankscreen.crankSprite:add()
    end


    if self.kosmonaut.kosmonautSprite.x > 309 then
        self.kosmonaut.posX = 308
    end
    if self.kosmonaut.kosmonautSprite.x < 265 then
        self.kosmonaut.posX = 266
    end
end

function GutterNest:goUp()
    gfx.sprite:removeAll()
    gfx.clear()

    
    
    self:changescreen(self, flowervalleyscreen, "UP")
    flowervalleyscreen.roverPosX = 300
    flowervalleyscreen.roverPosY = 260
    flowervalleyscreen.roverTargetX = 200
    flowervalleyscreen.roverTargetY = 100
    flowervalleyscreen:addFlowers()
    flowervalleyscreen:addDandelions()
    flowervalleyscreen:addLilDandelions()

    if self.kosmonaut.kosmonautSprite.x > 353 then
        self.kosmonaut.posX = 350
    end
    if self.kosmonaut.kosmonautSprite.x < 258 then
        self.kosmonaut.posX = 260
    end

end

function GutterNest:updateInput()

end

function GutterNest:updatework()
    GutterNest.super.updatework(self)
--print(self.stopPlayerFromMoving, "stopplayer from moving")
    px = self.kosmonaut.posX
    py = self.kosmonaut.posY

    self.updateInput(self)
    if self.resetBool == true then
        self.addEnemyBack(self)
        self.resetBool = false
    end

    if self.canPassUp == false and self.kosmonaut.kosmonautSprite.y < 25 and self.kosmonaut.kosmonautSprite.x > 250 and
        self.kosmonaut.kosmonautSprite.x < 355 then
        if self.soundNum == 1 then
            self.bushSound1:play()
            self.soundNum = 2
        else
            self.bushSound2:play()
            self.soundNum = 1
        end
        self.kosmonaut.posY = 25
    end
    if self.dandelionsTable[0].burned == true and self.dandelionsTable[1].burned == true then
        self.canPassUp = true
    end


end

function GutterNest:addEnemy(enemy)
    GutterNest.super.addEnemy(self, enemy)
end

function GutterNest:checkCollisionsForNode()
    GutterNest.super.checkCollisionsForNode(self)
end

function GutterNest:returnGrid()
    return self.gridTable
end

function GutterNest:removeEnemies()
    GutterNest.super.removeEnemies(self)
end

function GutterNest:addEnemyBack()
    GutterNest.super.addEnemyBack(self)
end

function GutterNest:restart()

end

function GutterNest:setCeilFadeValue()
    if px < 70 and py >= 60 and py <= 120 then
        if self.fadeCeilValue < 1 then
            self.fadeCeilValue += 0.05

            self.shadow:remove()
            crankscreen.shadow:remove()
            self.ceiling:add()
        end
    end

    if px > 90 and py >= 60 and py <= 120 then
        if self.fadeCeilValue > 0 then
            self.fadeCeilValue -= 0.05

            self.shadow:add()
            self.ceiling:remove()
        end
    end

end
