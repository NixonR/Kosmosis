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
import "lua/enemyScripts/dandelionexplode/dandelionexplode"



class("Explosive").extends("Level")

local gfx <const> = playdate.graphics




function Explosive:init()


    self.levelimage = gfx.image.new('images/rooms/room_explosive')
    self.levelcollisions = gfx.image.new('images/rooms/room_explosive_collisions')
    Explosive.super.init(self, self.levelimage, self.levelcollisions)

    self.dexplode1 = DandelionExplode(200, 120)

    self:addDandelionToTable(self.dexplode1)

    self.gutter1 = Gutter(60, 80)
    self.gutter2 = Gutter(130, 70)
    self.gutter3 = Gutter(260, 70)
    self.gutter4 = Gutter(330, 80)


    self.bA = ButtonUI(100, 130, "A")

    self.cutsceneExplosive = true
    self.hideSound = playdate.sound.fileplayer.new("sounds/hideSound")
    self.hideSound:setVolume(0.5)
    self.hideSoundTimer = 0
    self.spitGutters = true
    self.fakeKosmonaut = gfx.sprite.new(gfx.image.new("images/kosmonaut/cosmonaut_use"))
    self.fakeKosmonaut:setScale(2)
    -- self:addEnemy(self.gutter1)
    -- self:addEnemy(self.gutter2)
    -- self:addEnemy(self.gutter3)
    -- self:addEnemy(self.gutter4)
    -- for k,v in pairs(self.enemies) do
    --     self.enemies[k].tailSprite
    -- end
    self.killCounter = 0
    self.bgFight = playdate.sound.fileplayer.new("sounds/bgFight")
    self.bgFight:setVolume(0.1)

    self.gutterTargetPositionX = 50
    self.gutterTargetPositionY = 200
end

function Explosive:loadAssets()
    -- self.levelimage = gfx.image.new('images/rooms/room_explosive')
    -- self.levelcollisions = gfx.image.new('images/rooms/room_explosive_collisions')
    -- Explosive.super.init(self, self.levelimage, self.levelcollisions)

    -- self.dexplode1 = DandelionExplode(200, 120)

    -- self:addDandelionToTable(self.dexplode1)

    -- self.gutter1 = Gutter(60, 80)
    -- self.gutter2 = Gutter(130, 70)
    -- self.gutter3 = Gutter(260, 70)
    -- self.gutter4 = Gutter(330, 80)


    -- self.bA = ButtonUI(100, 130, "A")

    -- self.cutsceneExplosive = true
    -- self.hideSound = playdate.sound.fileplayer.new("sounds/hideSound")
    -- self.hideSoundTimer = 0
    -- self.spitGutters = true
    -- self.fakeKosmonaut = gfx.sprite.new(gfx.image.new("images/kosmonaut/cosmonaut_use"))
    -- self.fakeKosmonaut:setScale(2)
    -- self:addEnemy(self.gutter1)
    -- self:addEnemy(self.gutter2)
    -- self:addEnemy(self.gutter3)
    -- self:addEnemy(self.gutter4)

end

function Explosive:goLeft()
end

function Explosive:goRight()
end

function Explosive:goUp()
    if self.kosmonaut.isRover == true then
        self.kosmonaut.isRover = false
        self.kosmonaut.speed = 2
    end
    gfx.sprite.removeAll()
    self:changescreen(self, shortscreen, "UP")
    shortscreen.roverPosX = 280
    shortscreen.roverPosY = -30
    shortscreen.roverTargetX = 280
    shortscreen.roverTargetY = 100
    --self.kosmonaut:upTransition()
    shortscreen:addFlowers()
    shortscreen:addDandelions()
    shortscreen:addLilDandelions()
    if self.kosmonaut.kosmonautSprite.x > 303 then
        self.kosmonaut.posX = 300
    end
    if self.kosmonaut.kosmonautSprite.x < 34 then
        self.kosmonaut.posX = 36
    end



end

function Explosive:goDown()

    gfx.sprite.removeAll()
    if self.kosmonaut.isRover == true then
        self.kosmonaut.isRover = false
        self.kosmonaut.speed = 2
    end
    self:changescreen(self, flowervalleyscreen, "DOWN")
    flowervalleyscreen.roverPosX = 280
    flowervalleyscreen.roverPosY = -30
    flowervalleyscreen.roverTargetX = 280
    flowervalleyscreen.roverTargetY = 100
    --self.kosmonaut:downTransition()
    flowervalleyscreen:addFlowers()
    flowervalleyscreen:addDandelions()
    flowervalleyscreen:addLilDandelions()
    if self.kosmonaut.kosmonautSprite.x > 366 then
        self.kosmonaut.posX = 364
    end
    if self.kosmonaut.kosmonautSprite.x < 32 then
        self.kosmonaut.posX = 34
    end



end

function Explosive:updateInput()

end

function Explosive:updatework()
    --print(self.killCounter, "killcounter")
    --print(self.spitGutters, "spit gutters")
    print(currentscreen.rover.spriteBase.x, currentscreen.rover.spriteBase.y, "x i y")
    Explosive.super.updatework(self)
    self.removeGutterIfBurned(self)
    if self.dexplode1.burned == true and self.rover.spriteBase.y == 210 or aimscreen.finishExplosive == true then
        explosivescreen.roverTargetX = 200
        explosivescreen.roverTargetY = 200

    end
    if aimscreen.finishExplosive == false or aimscreen.finishExplosive == nil then
        self.bA:updateWork()
        self.hideBehindRock(self)
        if self.kosmonaut.isRover == false then
            self.pushBackPlayer(self)
        end
    else
        self.removeDandelionFromTable(self)

    end
    print(self.gutter2.sprite.x, self.gutter2.sprite.y)
    if self.killCounter > 3 then
        self.spitGutters = false
        self.bgFight:stop()
        bg1:play()
    else
        self.bgFight:play()
        bg1:stop()
    end

    self.gutter1.playerPositionX = 50
    self.gutter1.playerPositionY = 200
end

function Explosive:checkCollisionsForNode()
    Explosive.super.checkCollisionsForNode(self)
end

function Explosive:returnGrid()
    return self.gridTable
end

function Explosive:hideBehindRock()
    if self.spitGutters == true then
        if self.kosmonaut.posX < 170 and self.kosmonaut.posX > 50 and self.kosmonaut.isRover == false then
            self.bA.uiButtonIsEnabled = true
            if playdate.buttonJustPressed(playdate.kButtonA) then
                -- gfx.clear()
                -- gfx.sprite:removeAll()
                -- self:changescreen(explosivescreen, aimscreen)
                -- aimscreen.waveType = 2
                self.fakeKosmonaut:moveTo(self.kosmonaut.posX, self.kosmonaut.posY)
                self.kosmonaut.posX = self.rover.spriteBase.x
                self.kosmonaut.posY = self.rover.spriteBase.y
                self.kosmonaut.isRover = true
                self.fakeKosmonaut:add()


            end
        else
            self.bA.uiButtonIsEnabled = false
        end
        if (self.kosmonaut.posX > 170 and self.kosmonaut.isRover == false) or
            (self.kosmonaut.posX < 50 and self.kosmonaut.isRover == false) then
            self.hideSoundTimer += 1
            --self.rover.currentAnimationTurret = self.rover.turretLeft
            if self.hideSoundTimer > 50 then
                self.hideSound:play()
                self.hideSoundTimer = 0

            end
            -- elseif self.kosmonaut.isRover == true then
            --     self.hideSound:stop()
        end
    end
end

function Explosive:pushBackPlayer()
    if self.spitGutters == true then
        if self.kosmonaut.posY < 170 then
            self.kosmonaut.posY = 171
        end
    end

end

function Explosive:removeDandelionFromTable()

    if currentscreen.dandelionsTable[0] ~= nil then
        currentscreen.dandelionsTable[0] = nil
    end

end

function Explosive:removeGutterIfBurned()

    if self.enemies[0] ~= nil and self.enemies[0].burned == true then
        self.enemies[0] = nil
    end
    if self.enemies[1] ~= nil and self.enemies[1].burned == true then
        self.enemies[1] = nil
    end
    if self.enemies[2] ~= nil and self.enemies[2].burned == true then
        self.enemies[2] = nil
    end
    if self.enemies[3] ~= nil and self.enemies[3].burned == true then
        self.enemies[3] = nil
    end

end
