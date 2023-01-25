import "lua/screens/screen"
import "lua/screens/level"
import "lua/kosmonaut"
import "lua/enemyScripts/gutter/gutter"
import "lua/enemyScripts/dandelion/dandelionenemy"
import "lua/enemyScripts/dandelion/lildandelion"
import "CoreLibs/sprites"
import "CoreLibs/graphics"
import "CoreLibs/timer"
import "CoreLibs/crank"
import "CoreLibs/object"



class("Dandelions").extends("Level")

local gfx <const> = playdate.graphics




function Dandelions:init()


    self.levelimage = gfx.image.new('images/rooms/room_dandelions')
    self.levelcollisions = gfx.image.new('images/rooms/room_dandelions_collisions')
    Dandelions.super.init(self, self.levelimage, self.levelcollisions)

    self.dandelion1 = DandelionEnemy(200, 130)
    self:addDandelionToTable(self.dandelion1)
    self.dandelion2 = DandelionEnemy(290, 210)
    self:addDandelionToTable(self.dandelion2)

    self.lildandelion1 = LilDandelion(149, 118)
    self:addLilDandelionsToTable(self.lildandelion1)
    self.lildandelion2 = LilDandelion(237, 112)
    self:addLilDandelionsToTable(self.lildandelion2)
    self.lildandelion3 = LilDandelion(256, 85)
    self:addLilDandelionsToTable(self.lildandelion3)
    self.lildandelion4 = LilDandelion(293, 134)
    self:addLilDandelionsToTable(self.lildandelion4)
    self.lildandelion5 = LilDandelion(236, 154)
    self:addLilDandelionsToTable(self.lildandelion5)
    self.lildandelion6 = LilDandelion(207, 180)
    self:addLilDandelionsToTable(self.lildandelion6)


    self.roverPosX = 150
    self.roverPosY = -30
    self.roverTargetX = 180
    self.roverTargetY = 200

    self.cutsceneBurning = true
    self.roverBurningCounter = 0
end
-- function Dandelions:loadAssets()
--     self.levelimage = gfx.image.new('images/rooms/room_dandelions')
--     self.levelcollisions = gfx.image.new('images/rooms/room_dandelions_collisions')
--     Dandelions.super.init(self, self.levelimage, self.levelcollisions)

--     self.dandelion1 = DandelionEnemy(200, 130)
--     self:addDandelionToTable(self.dandelion1)
--     self.dandelion2 = DandelionEnemy(290, 210)
--     self:addDandelionToTable(self.dandelion2)

--     self.lildandelion1 = LilDandelion(149, 118)
--     self:addLilDandelionsToTable(self.lildandelion1)
--     self.lildandelion2 = LilDandelion(237, 112)
--     self:addLilDandelionsToTable(self.lildandelion2)
--     self.lildandelion3 = LilDandelion(256, 85)
--     self:addLilDandelionsToTable(self.lildandelion3)
--     self.lildandelion4 = LilDandelion(293, 134)
--     self:addLilDandelionsToTable(self.lildandelion4)
--     self.lildandelion5 = LilDandelion(236, 154)
--     self:addLilDandelionsToTable(self.lildandelion5)
--     self.lildandelion6 = LilDandelion(207, 180)
--     self:addLilDandelionsToTable(self.lildandelion6)


--     self.roverPosX = 150
--     self.roverPosY = -30
--     self.roverTargetX = 180
--     self.roverTargetY = 200

--     self.cutsceneBurning = true
--     self.roverBurningCounter = 0
    
-- end
function Dandelions:goLeft()

end

function Dandelions:goRight()
    gfx.sprite.removeAll()
    self.removeEnemies(self)
    self.removeDandelionSpikes(self)
    self:changescreen(self, cemeteryscreen, "RIGHT")
    cemeteryscreen.roverPosX = -20
    cemeteryscreen.roverPosY = 85
    cemeteryscreen.roverTargetX = 200
    cemeteryscreen.roverTargetY = 120
    cemeteryscreen:addEnemyBack(self)

    if cemeteryscreen.gutterIntro2 == true then
        cemeteryscreen:addFakeGutter(180, 190, 200, 210, 220, 230, 160, 170, 180, 190, 200, 210)

        cemeteryscreen.gutterIntro2 = false
    end

    if self.kosmonaut.kosmonautSprite.y > 110 then
        self.kosmonaut.posY = 109
    end
    if self.kosmonaut.kosmonautSprite.y < 44 then
        self.kosmonaut.posY = 45
    end
    cemeteryscreen.boneBridge:add()

end

function Dandelions:goUp()

    gfx.sprite.removeAll()
    self.removeEnemies(self)
    self:changescreen(currentscreen, cargoendscreen, "UP")
    cargoendscreen.roverPosX = 140
    cargoendscreen.roverPosY = 260
    cargoendscreen.roverTargetX = 100
    cargoendscreen.roverTargetY = 160
    cargoendscreen:addEnemyBack(self)

    cargoendscreen.cargoImage:add()
    self.removeDandelionSpikes(self)
    cargoendscreen.blindCargo:add()
    if self.kosmonaut.kosmonautSprite.x > 179 then
        self.kosmonaut.posX = 178
    end
    if self.kosmonaut.kosmonautSprite.x < 52 then
        self.kosmonaut.posX = 53
    end
    if cargoendscreen.roverCollected == true then
        cargoendscreen.deadGutters:add()
    end

end

function Dandelions:goDown()

    self.removeEnemies(self)
    gfx.sprite.removeAll()
    self:changescreen(self, cowplainsscreen, "DOWN")
    cowplainsscreen.roverPosX = 150
    cowplainsscreen.roverPosY = -30
    cowplainsscreen.roverTargetX = 180
    cowplainsscreen.roverTargetY = 120
    cowplainsscreen:addEnemyBack(self)

    cowplainsscreen:addFlowers()
    self.removeDandelionSpikes(self)
    if self.kosmonaut.kosmonautSprite.x > 184 then
        self.kosmonaut.posX = 183
    end
    if self.kosmonaut.kosmonautSprite.x < 109 then
        self.kosmonaut.posX = 110
    end




end

function Dandelions:updateInput()

end

function Dandelions:updatework()
    Dandelions.super.updatework(self)
    self.updateInput(self)


end

function Dandelions:addEnemy(enemy)
    Dandelions.super.addEnemy(self, enemy)

end

function Dandelions:checkCollisionsForNode()
    Dandelions.super.checkCollisionsForNode(self)
end

function Dandelions:returnGrid()
    return self.gridTable
end

function Dandelions:removeEnemies()
    Dandelions.super.removeEnemies(self)

end

function Dandelions:addEnemyBack()
    Dandelions.super.addEnemyBack(self)
end

function Dandelions:restart()

end

function Dandelions:removeDandelionSpikes()
    for k, v in pairs(self.dandelionsTable) do
        self.dandelionsTable[k]:removeSpikes()
        self.dandelionsTable[k].flesh:stop()
        self.dandelionsTable[k].shootTimer = 1000
    end
end

function Dandelions:dandelionShootIsTrue()
    for k, v in pairs(self.dandelionsTable) do
        self.dandelionsTable[k].shootTimer = 1000
        self.randomDandelionShoot = math.random(400, 5000)
        self.dandelionsTable[k]:spikeReset()

        playdate.timer.performAfterDelay(self.randomDandelionShoot, function()
            self.dandelionsTable[k].canShoot = true
        end)


    end
end


