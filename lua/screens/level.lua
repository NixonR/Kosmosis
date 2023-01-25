import "CoreLibs/object"
import "CoreLibs/graphics"
import "lua/kosmonaut"
import "lua/enemyScripts/enemy"
import "lua/enemyScripts/gutter/gutter"
import "lua/enemyScripts/gutter/gutteridle"
import "lua/enemyScripts/gutter/gutterchase"
import "lua/enemyScripts/dandelion/dandelionenemy"
import "lua/enemyScripts/dandelion/lildandelion"
import "lua/enemyScripts/flower"
import "lua/enemyScripts/fakegutter/fakegutter"
import "CoreLibs/sprites"
import "lua/fireinstance"
import "lua/buttonui"
import "lua/textdisplay"
import "lua/rover"
import "lua/crankindicator"

import "lua/assetsmanager/assetsmanager"


local gfx <const> = playdate.graphics

class("Level").extends("Screen")

fadeNewRenderToTexture = gfx.image.new(400, 240)


local kosmonaut = Kosmonaut()

local fadeIterator = 0

roverisactive = false



function Level:init(image, imagecollisions)

    Level.super.init(self)
    self.blackBarDown = gfx.sprite.new(gfx.image.new("images/assets/blackBar"))
    self.blackBarDown:setCenter(0.5, 1)
    self.blackBarDown:moveTo(200, 270)
    self.blackBarUp = gfx.sprite.new(gfx.image.new("images/assets/blackBar"))
    self.blackBarUp:moveTo(200, -30)
    self.blackBarUp:setCenter(0.5, 0)
    self.blackBarDown:setZIndex(1000)
    self.blackBarUp:setZIndex(1000)
    self.blackBarTemplate = gfx.sprite.new(gfx.image.new("images/assets/blackBar"))
    self.blackBarTemplate:moveTo(200, 120)
    self.cutsceneBar = false
    self.barDownY = 270
    self.barUpY = -30

    self.levelimage = image
    self.levelcollisions = imagecollisions

    self.fadeBlank = gfx.image.new("images/hvsar_cargo/fadeBlank")

    self.gridTable = {}
    self.gridTableLength = 0
    self:checkCollisionsForNode()

    self.enemiesLength = 0
    self.enemies = {}

    self.roverIsActive = false

    self.dandelionsLength = 0
    self.dandelionsTable = {}

    self.lilDandelionsLength = 0
    self.lilDandelionsTable = {}

    self.flowerLength = 0
    self.flowerTable = {}

    self.fakeGutterLength = 0
    self.fakeGutterTable = {}
    self.roverPosX = 200
    self.roverPosY = -30
    self.roverTargetX = 200
    self.roverTargetY = 120

    self.kosmonaut = kosmonaut
    self.rover = Rover(self.roverPosX, self.roverPosY, self.roverTargetX, self.roverTargetY)
    self.fadeInEnable = false
    self.playerIsDead = false

    self.distanceToPlayerValueX = 0
    self.distanceToPlayerValueY = 0
    self.timerStamp = 0
    self.spotlightProgress = 0
    self.fadeMs = 500
    self.jumpSound = playdate.sound.fileplayer.new("sounds/jumpSound")
    self.landingSound = playdate.sound.fileplayer.new("sounds/landingSound")
    self.jumpSoundPlayer = false
    self.fadeType = {
        UP = "UP",
        DOWN = "DOWN",
        LEFT = "LEFT",
        RIGHT = "RIGHT",
        DEATH = "DEATH",
        FADEUP = "FADEUP",
        FADEDOWN = "FADEDOWN",
        FADELEFT = "FADELEFT",
        FADERIGHT = "FADERIGHT"
    }

    self.fadeProgress = 1
    self.fadeAfterDeathAdded = false


end

function Level:changescreen(start, target, fadeType)

    if ((start ~= nil and start:isa(Level) == false) or (target ~= nil and target:isa(Level) == false)) then
        Level.super.changescreen(self, target)

        currentscreen:fadeOutCompleted()
        return
    end

    start.rover.spriteBase:remove()
    start.rover.turret:remove()
    if target.loaded == nil then
        target:loadAssets()
    end
    fadetargetscreen = target

    gfx.sprite.setBackgroundDrawingCallback(
        function(x, y, width, height)
            if fadetargetscreen ~= nil then
                gfx.setClipRect(x, y, width, height)
                fadetargetscreen.levelimage:draw(0, 0)

                gfx.clearClipRect()
                --print(currentscreen.className)
            end
        end
    )

    gfx.lockFocus(fadeNewRenderToTexture)
    fadetargetscreen:draw()
    gfx.unlockFocus()


    gfx.sprite.setBackgroundDrawingCallback(
        function(x, y, width, height)
            gfx.setClipRect(x, y, width, height)
            -- print(currentscreen.className, "with clipping rect")
            currentscreen.levelimage:draw(0, 0)
            gfx.clearClipRect()
            --print("bg2")
        end
    )

    start.fadeType = fadeType
    target.fadeType = fadeType

    gfx.lockFocus(fadeRenderToTexture)
    currentscreen:draw()
    gfx.unlockFocus()
    if roverisactive == true then
        target.rover.spriteBase:add()
        target.rover.turret:add()

    end

    currentscreen:startFadeOut()
    start:releaseAssets()
end

-- Assets Manager
function Level:loadAssets()
end

function Level:releaseAssets()
end

function Level:fadeInWithAlpha(enable)
    self.fadeInEnable = enable
end

function Level:startFadeIn()

    gfx.sprite.setBackgroundDrawingCallback(
        function(x, y, width, height)

            if self.playerIsDead == false then

                self.levelimage:draw(0, 0)
                self.fadeProgress = 1

                self.timerStamp = playdate.getCurrentTimeMilliseconds()
            elseif self.playerIsDead == true then
                if self.fadeProgress > 0 then
                    self.fadeProgress -= (playdate.getCurrentTimeMilliseconds() - self.timerStamp) * 0.001
                    if self.fadeProgress < 0.02 then
                        self.fadeProgress = 0

                    end

                end
                self.levelimage:drawFaded(0, 0, self.fadeProgress, gfx.image.kDitherTypeBayer8x8)
            end
        end
    )

    self.kosmonaut:setCollisions(self.levelcollisions)

    self:setCollisions(self.levelcollisions)


    if (self.fadeInEnable) then
        Level.super.startFadeIn(self)
        self.fadeInEnable = false
    else
        if (self.fadeType == "LEFT") then
            self.kosmonaut:leftTransition()
        end
        if (self.fadeType == "RIGHT") then
            self.kosmonaut:rightTransition()
        end
        if (self.fadeType == "UP") then
            self.kosmonaut:upTransition()
        end

        if (self.fadeType == "DOWN") then
            self.kosmonaut:downTransition()
        end

        if (self.fadeType == "DEATH") then
            self.kosmonaut.deathTransition()
        end

        if (self.fadeType == "FADEUP") then
            self.kosmonaut.fadeUp()
        end
        if (self.fadeType == "FADEDOWN") then
            self.kosmonaut.fadeDown()
        end
        if (self.fadeType == "FADELEFT") then
            self.kosmonaut.fadeLeft()
        end
        if (self.fadeType == "FADERIGHT") then
            self.kosmonaut.fadeRight()
        end

        fadetargetscreen:fadeInCompleted()
    end

end

function Level:startFadeOut()
    self.timerStamp = playdate.getCurrentTimeMilliseconds()
    self.progress = 0;
    self.state = self.State.FADEOUT;
end

function Level:drawFadeOut()
    gfx.clear()
    if (self.fadeType == "LEFT") then
        fadeRenderToTexture:draw(400 * self.progress, 0)
        fadeNewRenderToTexture:draw(-400 + 400 * self.progress, 0)
    end

    if (self.fadeType == "RIGHT") then
        fadeRenderToTexture:draw(-400 * self.progress, 0)
        fadeNewRenderToTexture:draw(400 - 400 * self.progress, 0)
    end

    if (self.fadeType == "DOWN") then
        fadeRenderToTexture:draw(0, -240 * self.progress)
        fadeNewRenderToTexture:draw(0, 240 - 240 * self.progress)
    end

    if (self.fadeType == "UP") then
        fadeRenderToTexture:draw(0, 240 * self.progress)
        fadeNewRenderToTexture:draw(0, -240 + 240 * self.progress)
    end

end

function Level:updateinput()
    --print("up date up date")


end

function Level:fadeInCompleted()
    Level.super.fadeInCompleted(self)

    self.kosmonaut.kosmonautSprite:add()
    self.rover.spriteBase:moveTo(self.roverPosX, self.roverPosY)

end

function Level:updatework()
    self.kosmonaut:updateWork()
    if roverisactive == true then
        self.rover:updateWork()
    end
    --self.kosmonaut.kosmonautSprite:add()
    self.enemyWork(self)
    self.dandelionWork(self)
    self.lilDandelionsWork(self)
    self.flowerWork(self)
    self.fakegutterwork(self)
    self.cutsceneBars(self)
    self.playerIsDead = self.kosmonaut.playerIsDead




    self.spotlightWhenDead(self)


    Tail:updateWork()
    self.jumpOnRover(self)
    --print(self.kosmonaut.speed)

end

function Level:draw()

    gfx.clear()

    gfx.sprite:update()
    --gfx.drawText(currentscreen.className, 30, 30)
    --playdate.timer.updateTimers()
end

function Level:goLeft()
    self.rover.spriteBase:moveTo(self.roverPosX, self.roverPosY)

end

function Level:goDown()
    self.rover.spriteBase:moveTo(self.roverPosX, self.roverPosY)
    print(self.posX, "kosmonaut pos X")

end

function Level:goUp()
    self.rover.spriteBase:moveTo(self.roverPosX, self.roverPosY)

    --gfx.clear(3)
end

function Level:goRight()
    self.rover.spriteBase:moveTo(self.roverPosX, self.roverPosY)
    self.rover.spriteBase:remove()
    self.rover.turret:remove()

end

function Level:enemyWork()
    if self.enemies ~= nil then
        for i = 0, self.enemiesLength - 1 do
            if self.enemies[i] ~= nil then
                self.enemies[i]:updateWork()
            end
        end
    end
end

function Level:dandelionWork()
    if self.dandelionsTable ~= nil then
        for i = 0, self.dandelionsLength - 1 do
            if self.dandelionsTable[i] ~= nil then
                self.dandelionsTable[i]:updateWork()
            end
        end
    end
end

function Level:lilDandelionsWork()
    if self.lilDandelionsTable ~= nil then
        for i = 0, self.lilDandelionsLength - 1 do

            self.lilDandelionsTable[i]:updateWork()

        end
    end
end

function Level:flowerWork()
    if self.flowerTable ~= nil then
        for i = 0, self.flowerLength - 1 do

            self.flowerTable[i]:updateWork()

        end
    end
end

function Level:fakegutterwork()
    for i = 0, self.fakeGutterLength - 1 do
        if self.fakeGutterTable[i] ~= nil then

            self.fakeGutterTable[i]:updateWork()

        end
    end
end

function Level:addEnemy(enemy)
    self.enemies[self.enemiesLength] = enemy
    self.enemiesLength += 1
end

function Level:addDandelionToTable(dandelion)
    self.dandelionsTable[self.dandelionsLength] = dandelion
    self.dandelionsLength += 1
end

function Level:addLilDandelionsToTable(lildandelion)
    self.lilDandelionsTable[self.lilDandelionsLength] = lildandelion
    self.lilDandelionsLength += 1
end

function Level:addFlowerToTable(flower)
    self.flowerTable[self.flowerLength] = flower
    self.flowerLength += 1
end

function Level:addFakeGutterToTable(fakegutter)
    self.fakeGutterTable[self.fakeGutterLength] = fakegutter
    self.fakeGutterLength += 1
end

function Level:removeEnemies()

    for k, v in pairs(self.enemies) do
        self.enemies[k].sprite:remove()
    end

end

function Level:removeEnemiesFromTable()

    for k, v in pairs(self.enemies) do
        self.enemies[k] = nil
    end

end

function Level:addEnemyBack()

    -- for i = 1, #self.enemies do
    --     self.enemies[i].victoryBool = false;
    --     self.enemies[i].sprite:add()

    -- end
    if self.enemies ~= nil then
        for i = 0, self.enemiesLength - 1 do
            if self.enemies[i] ~= nil then
                self.enemies[i].sprite:add()
                self.enemies[i].victoryBool = false
                print("add enemy back repeat")
            end

        end
    end
end

function Level:addDandelions()
    for k, v in pairs(self.dandelionsTable) do
        self.dandelionsTable[k].dandelion1:add()

    end
end

function Level:addLilDandelions()
    for k, v in pairs(self.lilDandelionsTable) do
        self.lilDandelionsTable[k].lilDandelion:add()

    end
end

function Level:addFlowers()
    for k, v in pairs(self.flowerTable) do
        self.flowerTable[k].flower:add()
        self.flowerTable[k].roots:add()
    end


end

function Level:addFakeGutter(a, b, c, d, e, f, a1, b1, c1, d1, e1, f1)
    if currentscreen.className == "CapsuleStart" then
        --print(currentscreen.className)
        for k, v in pairs(self.fakeGutterTable) do
            self.fakeGutterTable[k].sprite:add()
            self.fakeGutterTable[0]:setTailStartPosition(a, b, c, d, e, f)
        end

    end
    if currentscreen.className == "Dandelions" then
        for k, v in pairs(self.fakeGutterTable) do
            self.fakeGutterTable[k].sprite:add()
            self.fakeGutterTable[0]:setTailStartPosition(a, b, c, d, e, f)
            self.fakeGutterTable[1]:setTailStartPosition(a1, b1, c1, d1, e1, f1)
        end
    end
    if currentscreen.className == "CargoEndRover" then
        for k, v in pairs(self.fakeGutterTable) do
            self.fakeGutterTable[k].sprite:add()

        end
    end


end

function Level:checkCollisionsForNode()
    --check and set nodes if collision is false
    if self.levelcollisions ~= nil then
        for y = 0, 230, 10 do
            for x = 0, 390, 10 do
                if (self:checkCollisionAt(x, y)) then
                    self:setGrid(x, y)
                else
                    self:setGrid(0, 0)
                end
            end
        end
    end
end

function Level:setGrid(x, y) --store grid position values
    self.gridTable[self.gridTableLength] = { x, y }
    self.gridTableLength += 1
end

function Level:checkCollisionAt(x, y) --check collision by pixel color from levelcollisions
    return self.levelcollisions:sample(x, y) == gfx.kColorBlack
end

function Level:setCollisions(collisions)
    self.levelcollisions = collisions
end

function Level:spotlightWhenDead()
    if (self.playerIsDead == true and fadeIterator < 1) then

        fadeIterator += (playdate.getCurrentTimeMilliseconds() - self.timerStamp) * 0.001
        gfx.sprite.setBackgroundDrawingCallback(
            function(x, y, width, height)
                --playdate.graphics.drawRect(22, 22, 22, 22)

                self.fadeBlank:drawFaded(0, 0, fadeIterator, gfx.image.kDitherTypeBayer8x8)
            end
        )
    elseif self.playerIsDead == false then

        self.timerStamp = playdate.getCurrentTimeMilliseconds()
        fadeIterator = 0
    end
    --print(fadeIterator)
end

function Level:reset()
    self.fakeGutterLength = 0
    self.fakeGutterTable = {}
end

function Level:returnPlayerIsDead()
    return self.playerIsDead
end

function Level:cutsceneBars()
    --print(self.barDownY)
    self.blackBarDown:moveTo(200, self.barDownY)
    self.blackBarUp:moveTo(200, self.barUpY)

    if self.cutsceneBar == true then
        self.blackBarDown:add()
        self.blackBarUp:add()
        if self.barDownY > 240 then
            self.barDownY -= 2
        end
        if self.barUpY < 0 then
            self.barUpY += 2
        end


        print("saomdpoasmdsa")
    else
        if self.barDownY < 270 then
            self.barDownY += 2
        end
        if self.barUpY > -30 then
            self.barUpY -= 2
        end
    end
end

function Level:jumpOnRover()
    if self.kosmonaut.playerIsDead == false and roverisactive == true then
        if math.abs(self.kosmonaut.kosmonautSprite.x - self.rover.spriteBase.x) < 20 and
            math.abs(self.kosmonaut.kosmonautSprite.y - self.rover.spriteBase.y + 8) < 20 then
            self.kosmonaut.kosmonautSprite:setCenter(0.5, 0.7)
            if self.jumpSoundPlayer == false and self.kosmonaut.isRover == false then
                self.jumpSoundPlayer = true
                self.jumpSound:play()
            end
        else
            if self.jumpSoundPlayer == true then
                self.landingSound:play()
                self.jumpSoundPlayer = false
            end

            self.kosmonaut.kosmonautSprite:setCenter(0.5, 0.5)
        end
    end

end
