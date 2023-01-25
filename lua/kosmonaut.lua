import "CoreLibs/sprites"
import "lua/spriteanimation"
import "CoreLibs/timer"
import "lua/enemyScripts/gutter/gutter"

import "lua/assetsmanager/assetsmanager"

class('Kosmonaut').extends()

local gfx <const> = playdate.graphics

local playerPositionX = integer
local playerPositionY = integer
globalPlayerIsDead = false
local playAnimationDeathCompleted = false
local isNotDead = true
local keyTimer = nil
local fadeIterator = 0

function Kosmonaut:init()

    self.stepSound = playdate.sound.sampleplayer.new("sounds/8bit_step2")
    self.stepSound:setVolume(0.1)

    self.die1 = playdate.sound.sampleplayer.new("sounds/die1")
    self.die1:setVolume(0.4)
    --self.die2 = playdate.sound.sampleplayer.new("sounds/die2")
    self.stepcounter = 0
    self.kosmonautSprite = gfx.sprite.new()
    self.kosmonautSprite:setScale(2)
    self.kosmonautSprite:setZIndex(7)

    self.animationIdleRight = SpriteAnimation(self.kosmonautSprite)
    self.animationIdleRight:addImage("images/kosmonaut/cosmonaut_idle_right")

    self.animationIdleLeft = SpriteAnimation(self.kosmonautSprite)
    self.animationIdleLeft:addImage("images/kosmonaut/cosmonaut_idle_left")

    self.animationIdleUp = SpriteAnimation(self.kosmonautSprite)
    self.animationIdleUp:addImage("images/kosmonaut/cosmonaut_idle_up")

    self.animationIdleDown = SpriteAnimation(self.kosmonautSprite)
    self.animationIdleDown:addImage("images/kosmonaut/cosmonaut_idle_down")

    self.animationWalkLeftRight = SpriteAnimation(self.kosmonautSprite)
    self.animationWalkLeftRight:addImage("images/kosmonaut/cosmonaut_walk_right1")
    self.animationWalkLeftRight:addImage("images/kosmonaut/cosmonaut_walk_right2")

    self.animationWalkRightLeft = SpriteAnimation(self.kosmonautSprite)
    self.animationWalkRightLeft:addImage("images/kosmonaut/cosmonaut_walk_left1")
    self.animationWalkRightLeft:addImage("images/kosmonaut/cosmonaut_walk_left2")

    self.animationWalkUp = SpriteAnimation(self.kosmonautSprite)
    self.animationWalkUp:addImage("images/kosmonaut/cosmonaut_walk_up1")
    self.animationWalkUp:addImage("images/kosmonaut/cosmonaut_walk_up2")

    self.animationWalkDown = SpriteAnimation(self.kosmonautSprite)
    self.animationWalkDown:addImage("images/kosmonaut/cosmonaut_walk_down1")
    self.animationWalkDown:addImage("images/kosmonaut/cosmonaut_walk_down2")




    self.animationDeath = SpriteAnimation(self.kosmonautSprite)
    self.animationDeath:addImage("images/kosmonaut/cosmonaut_death1")
    self.animationDeath:addImage("images/kosmonaut/cosmonaut_death2")
    self.animationDeath:addImage("images/kosmonaut/cosmonaut_death3")
    self.animationDeath:addImage("images/kosmonaut/cosmonaut_death4")
    self.animationDeath:addImage("images/kosmonaut/cosmonaut_death5")

    self.animationDeathCompleted = SpriteAnimation(self.kosmonautSprite)
    self.animationDeathCompleted:addImage("images/kosmonaut/cosmonaut_death5")
    self.animationDeathCompleted:addImage("images/kosmonaut/cosmonaut_death5")
    self.animationDeathCompleted:addImage("images/kosmonaut/cosmonaut_death5")

    self.animationDizzy = SpriteAnimation(self.kosmonautSprite)
    self.animationDizzy:addImage("images/kosmonaut/cosmonaut_death4")
    self.animationDizzy:addImage("images/kosmonaut/cosmonaut_death4")
    self.animationDizzy:addImage("images/kosmonaut/cosmonaut_death3")
    self.animationDizzy:addImage("images/kosmonaut/cosmonaut_death1")
    self.animationDizzy:addImage("images/kosmonaut/cosmonaut_death2")
    self.animationDizzy:addImage("images/kosmonaut/cosmonaut_death2")
    self.animationDizzy:addImage("images/kosmonaut/cosmonaut_death1")
    self.animationDizzy:addImage("images/kosmonaut/cosmonaut_death1")
    self.animationDizzy:addImage("images/kosmonaut/cosmonaut_idle_right")
    self.animationDizzy:addImage("images/kosmonaut/cosmonaut_idle_right")
    self.animationDizzy:addImage("images/kosmonaut/cosmonaut_idle_down")



    self.wakeUp = false

    self.inventory = {}
    self.inventorySize = 0

    self.wdSpriteIcon = gfx.sprite.new(gfx.image.new("images/ui/ui_icon_wd40000"))
    self.wdSpriteIcon:moveTo(382, -18)
    self.wdSpriteIcon:setZIndex(1002)

    self.bumperSpriteIcon = gfx.sprite.new(gfx.image.new("images/ui/ui_icon_bumper"))
    self.bumperSpriteIcon:moveTo(348, -18)
    self.bumperSpriteIcon:setZIndex(1002)


    self.animationUse = SpriteAnimation(self.kosmonautSprite)
    self.animationUse:addImage("images/kosmonaut/cosmonaut_use")


    self.currentAnimation = self.animationDizzy
    self.currentAnimation:updateFrame()
    self.kosmonautSprite:setTag(1)
    self.playerIsDead = false
    -- if self.posX == nil then
    self.posX = 100
    self.posY = 180
    print("kosmonaut position --------------------------------------") -- 160 powinno byc
    --end

    self.speed = 2
    self.tempSpeed = self.speed
    self.dashActive = false
    self.vecX = 0
    self.vecY = 0

    self.kosmonautSprite:setCollideRect(23, 22, 20, 32)
    self.kosmonautSprite:moveWithCollisions(self.posX, self.posY)
    self.kosmonautSprite:add()


    self.kosmonautSprite.collisionResponse = 'overlap'
    --self.kosmonautSprite:setGroups(1)
    --self.kosmonautSprite:setCollidesWithGroups({ 2, 1 })

    self.IdleState = {
        IdleLeft = 1,
        IdleRight = 2,
        IdleUp = 3,
        IdleDown = 4
    }

    self.footstepsImage = gfx.image.new("images/kosmonaut/footsteps")
    self.footstepsSprite1 = gfx.sprite.new(self.footstepsImage)
    self.footstepsSprite2 = gfx.sprite.new(self.footstepsImage)
    self.footstepsSprite3 = gfx.sprite.new(self.footstepsImage)
    self.footstepsSprite4 = gfx.sprite.new(self.footstepsImage)
    self.footstepsSprite5 = gfx.sprite.new(self.footstepsImage)
    self.fadeAfterDeathAdded = false

    self.isRover = false


    self.stepsTableLength = 1
    self.stepsTable = { self.footstepsSprite1, self.footstepsSprite2, self.footstepsSprite3, self.footstepsSprite4,
        self.footstepsSprite5 }

    self.stepsTable[1]:moveTo(self.posX, self.posY)
    self.stepsTable[2]:moveTo(self.posX, self.posY)
    self.stepsTable[3]:moveTo(self.posX, self.posY)
    self.stepsTable[4]:moveTo(self.posX, self.posY)
    self.stepsTable[5]:moveTo(self.posX, self.posY)
    self.stepsTable[1]:add()
    self.stepsTable[2]:add()
    self.stepsTable[3]:add()
    self.stepsTable[4]:add()
    self.stepsTable[5]:add()

    -- CRANK COLLECTED FOR CARGOEND -------------------------------------------------------
    self.crankCollected = false
    self.timerStamp = 0
    self.fadeBlank = gfx.image.new("images/blank_collisions")

    self.gutterIdleSound = playdate.sound.fileplayer.new("sounds/grr")
    self.gutterIdleSound:setVolume(0.2)

    self.jetpackSound = playdate.sound.fileplayer.new("sounds/jetpack")
    self.jetpackSoundBeep = playdate.sound.fileplayer.new("sounds/jetpackBeep")
    self.wdY = -18
    self.bumpY = -18
    self.jumpOnRover = false
    self.dashCooldown = 0

    self.deathSpeed = 4500

    --self.step = playdate.sound.fileplayer.new("sounds/items/footf")
end

-- function Kosmonaut:collisionResponse(other)
--     if other ~= nil then
--         if other:isA(Gutter) then
--             return 'overlap'
--         end
--         self.kosmonautSprite.collisionResponse = 'overlap'
--     end
-- end

function Kosmonaut:checkCollisionAt(x, y)
    return self.levelCollisions:sample(x, y) == gfx.kColorBlack
end

function Kosmonaut:setCollisions(collisions)
    self.levelCollisions = collisions
end

function Kosmonaut:updateInput()

    if currentscreen.stopPlayerFromMoving == true and self.isRover == false then
        self.speed = 0
        self.canRotate = false
    end
    if currentscreen.stopPlayerFromMoving == false and self.playerIsDead == false and self.dashActive == false and
        self.isRover == false then
        self.speed = 2
        self.canRotate = true
    end


    --print(self.stepsTableLength)

    local function tmCallback()
        if self.isRover == false then
            self.stepcounter += 1
            if self.stepcounter > 10 then
                self.stepsTable[self.stepsTableLength]:moveTo(self.posX, self.posY + 10)
                if self.vecX ~= 0 or self.vecY ~= 0 then
                    self.stepSound:play(1, 1)
                end
                if currentscreen.className ~= "Waterfall" and currentscreen.className ~= "Distract" then
                    self.stepsTable[self.stepsTableLength]:add()
                end
                self.stepsTableLength += 1
                if self.stepsTableLength > 5 then
                    self.stepsTableLength = 1

                end
                self.stepcounter = 0
            end
        end
    end

    self.vecX = 0
    self.vecY = 0

    if (
        playdate.buttonIsPressed(playdate.kButtonLeft) and
            self:checkCollisionAt(self.posX + self.vecX - self.speed, self.posY + self.vecY)) then
        self.vecX = -self.speed
        keyTimer = playdate.timer.performAfterDelay(50, tmCallback)

    elseif (
        playdate.buttonIsPressed(playdate.kButtonRight) and
            self:checkCollisionAt(self.posX + self.vecX + self.speed, self.posY + self.vecY)) then
        self.vecX = self.speed
        keyTimer = playdate.timer.performAfterDelay(200, tmCallback)




    elseif (
        playdate.buttonIsPressed(playdate.kButtonUp) and
            self:checkCollisionAt(self.posX + self.vecX, self.posY + self.vecY - self.speed)) then
        self.vecY = -self.speed
        keyTimer = playdate.timer.performAfterDelay(50, tmCallback)


    elseif (
        playdate.buttonIsPressed(playdate.kButtonDown) and
            self:checkCollisionAt(self.posX + self.vecX, self.posY + self.vecY + self.speed)) then
        self.vecY = self.speed
        keyTimer = playdate.timer.performAfterDelay(50, tmCallback)


    end

end

function Kosmonaut:leftTransition()
    self.posX += 390;
    print("leftTransition")
    self.resetFootsteps(self)
end

function Kosmonaut:rightTransition()

    self.posX -= 390;
    print("rightTransition")
    self.resetFootsteps(self)

end

function Kosmonaut:downTransition()
    self.posY -= 230;
    print("downTransition")
    self.resetFootsteps(self)

end

function Kosmonaut:upTransition()
    self.posY += 230;
    print("upTransition")
    self.resetFootsteps(self)

end

function Kosmonaut:deathTransition()


end

function Kosmonaut:fadeUp()
    self.posY += 230;
    print("fadeup")
    self.resetFootsteps(self)

end

function Kosmonaut:fadeDown()
    self.posY -= 230;
    print("fadedown")
    self.resetFootsteps(self)

end

function Kosmonaut:fadeLeft()
    self.posX += 390;
    print("fadeleft")
    self.resetFootsteps(self)

end

function Kosmonaut:fadeRight()
    self.posX -= 390;
    print("faderight")
    self.resetFootsteps(self)

end

function Kosmonaut:updateWork()


    self.updateInput(self)
    self.changeAnimationFromDizzyToNormal(self)
    if self.isRover == false then
        self.dashUsage(self)
    end
    -- if currentscreen == labiryntscreen then
    --     self.isRover = true
    -- else
    --     self.isRover = false
    -- end
    --print(math.atan( self.posY - 120, self.posX - 200 ), "kosmonautAtan")

    -- for k, v in pairs(self.inventory) do
    --     print(self.inventory[k])
    -- end

    self.uiIcons(self)
    playerIsDead = self.playerIsDead
    self.posX += self.vecX
    self.posY += self.vecY
    self.currentAnimation:updateFrame()

    self.kosmonautSprite:moveWithCollisions(self.posX, self.posY)
    self.isCollidingWith(self)
    self.movingKosmonaut(self)
    --playerIsDead =  self.playerIsDead
    if self.playerIsDead == true and playAnimationDeathCompleted == false then
        isNotDead = false

        self.currentAnimation = self.animationDeath


        if self.currentAnimation.frame >= 4.75 and isNotDead == false then
            self.currentAnimation:pauseAnimation()
            self.die1:play()

            playdate.timer.performAfterDelay(self.deathSpeed, function()


                currentscreen:removeEnemies()
                self.posX = 114
                self.posY = 212
                -- print("dead change screen")

                deathscreen:playAudio()
                currentscreen:changescreen(currentscreen, deathscreen, "DEATH")
                self.currentAnimation:startAnimation()
                isNotDead = true
                self.posX = 30
                self.posY = 120

                self.playerIsDead = false
                crankscreen.playerIsDead = false



            end)
            --Gutter:setup()
            playAnimationDeathCompleted = true


        end


    end
    for k, v in pairs(self.stepsTable) do

    end

    if (self.posX <= 2) then
        currentscreen:goLeft()
    end
    if (self.posX >= 398) then
        currentscreen:goRight()
    end
    if (self.posY >= 238) then
        currentscreen:goDown()
    end
    if (self.posY <= 2) then
        currentscreen:goUp()
    end

    playerPositionX = self.posX
    playerPositionY = self.posY
    self.kosmonautIsRover(self)

end

function Kosmonaut:playerPositionX()

    return playerPositionX
end

function Kosmonaut:playerPositionY()

    return playerPositionY
end

function Kosmonaut:isCollidingWith()
    local actualX, actualY, collisions, collisionLength = self.kosmonautSprite:checkCollisions(self.posX, self.posY)

    if collisionLength > 0 then

        --print(collisions[1].other:getTag())
        self.timerStamp = playdate.getCurrentTimeMilliseconds()
        if collisions[1].other:getTag() == (20) then ----enemyTag should be 20
            self.deathSpeed = 4500
            self.playerIsDead = true
            self.speed = 0
            currentscreen.isPlayerDead = true
            deathscreen.deathType = "GUTTER"
            --print("fading time")
        elseif collisions[1].other:getTag() == (30) then ----dandelionTag should be 30
            self.deathSpeed = 4500
            self.playerIsDead = true
            self.speed = 0
            currentscreen.isPlayerDead = true
            deathscreen.deathType = "DANDELION"
        elseif collisions[1].other:getTag() == (66) then ----dandelionTag should be 30
            undergroundscreen.blackHole:setScale(2)
            self.deathSpeed = 300
            undergroundscreen.eggPrepare:play()
            if self.playerIsDead == false then
                playdate.timer.performAfterDelay(200, function()
                    currentscreen.isPlayerDead = true
                    deathscreen.deathType = "ALIEN"
                    self.speed = 0
                    self.playerIsDead = true
                end)


            end
            --print("fading time")

        end
        -- if collisionLength > 0 and collisions[#collisions].other:getTag() == (18) and self.jumpOnRover == false then
        --     print("playerjump")
        --     self.jumpOnRover = true
        --     playdate.timer.performAfterDelay(50, function ()
        --     self.posY -= 8
        --     end)
        -- end

    elseif isNotDead == true then



        self.playerIsDead = false
        --fadeIterator = 0
        --Level:aliveFadeIn()


        --self.speed = 2
    end

    -- if collisionLength > 0 and collisions[#collisions].other:getTag() ~= (18) or collisionLength == 0  then
    --     if self.jumpOnRover == true then
    --         self.jumpOnRover = false
    --         playdate.timer.performAfterDelay(50, function ()
    --             self.posY += 8
    --         end)

    --     end
    -- end
end

function Kosmonaut:returnPlayerIsDead()

    return playerIsDead
end

function Kosmonaut:currentAnimationCurrentFrame()
    currentFrame = SpriteAnimation:currentFrameRead()
end

function Kosmonaut:movingKosmonaut()
    print("kosmo y", self.kosmonautSprite.y)
    if self.playerIsDead == false then
        if self.isRover == false then
            playAnimationDeathCompleted = false
            if (self.vecX > 0) then

                self.currentAnimation = self.animationWalkLeftRight
                self.spriteDirection = self.IdleState.IdleRight
                -- print("I")

            elseif (self.vecX < 0) then


                self.currentAnimation = self.animationWalkRightLeft
                self.spriteDirection = self.IdleState.IdleLeft
                --print("H")

            elseif (self.vecY < 0) then
                self.currentAnimation = self.animationWalkUp
                self.spriteDirection = self.IdleState.IdleUp
                --print("G")

            elseif (self.vecY > 0) then
                self.currentAnimation = self.animationWalkDown
                self.spriteDirection = self.IdleState.IdleDown


            elseif self.vecX == 0 and self.vecY == 0 and currentscreen ~= cargoendroverscreen then
                if (self.spriteDirection == self.IdleState.IdleRight) then
                    self.currentAnimation = self.animationIdleRight
                elseif (self.spriteDirection == self.IdleState.IdleLeft) then
                    self.currentAnimation = self.animationIdleLeft
                elseif (self.spriteDirection == self.IdleState.IdleUp) then
                    self.currentAnimation = self.animationIdleUp
                elseif (self.spriteDirection == self.IdleState.IdleDown) then
                    self.currentAnimation = self.animationIdleDown
                end
                --print("C")
            end
        end
    end
end

function Kosmonaut:kosmonautIsRover()
    if self.isRover == true then
        self.kosmonautSprite:remove()
        self.speed = 1
        currentscreen.rover.spriteBase:moveTo(self.posX, self.posY)
        currentscreen.rover.turret:moveTo(self.posX, self.posY)

    end
end

function Kosmonaut:resetFootsteps()
    for k, v in pairs(self.stepsTable) do
        self.stepsTable[k]:moveTo(self.posX, self.posY)
    end
end

function Kosmonaut:crankIsCollected()
    self.crankCollected = true
    --print("CRANK COLLECTED!")
end

function Kosmonaut:restart()
    self.crankCollected = false
    self.posX = 20
    self.posY = 100
    self.stepcounter = 0
    self.speed = 2
    self.vecX = 0
    self.vecY = 0
end

function Kosmonaut:changeAnimationFromDizzyToNormal()
    if self.wakeUp == false and self.currentAnimation == self.animationDizzy then
        self.currentAnimation:pauseAnimation()
    elseif self.wakeUp == true and self.currentAnimation == self.animationDizzy then
        self.currentAnimation:startAnimation()
    end
    if self.currentAnimation.frame >= 10 and self.currentAnimation == self.animationDizzy then
        self.currentAnimation = self.animationIdleDown
    end
end

function Kosmonaut:addToInventory(inventoryString)
    self.inventory[self.inventorySize] = inventoryString
    self.inventorySize += 1
end

function Kosmonaut:removeFromInventory(inventoryString)
    for k, v in pairs(self.inventory) do
        if self.inventory[k] == inventoryString then
            self.inventory[k] = "empty"
            self.inventorySize -= 1
        end
    end
end

function Kosmonaut:uiIcons()
    for k, v in pairs(self.inventory) do
        if self.inventory[k] == "wd40000" then
            self.wdSpriteIcon:add()
            if self.wdSpriteIcon.y ~= 18 then
                self.wdY += 2
                self.wdSpriteIcon:moveTo(self.wdSpriteIcon.x, self.wdY)
            end
        else
            --self.wdSpriteIcon:remove()
        end
    end
    for k, v in pairs(self.inventory) do
        if self.inventory[k] == "bumper" then
            self.bumperSpriteIcon:add()
            if self.bumperSpriteIcon.y ~= 18 then
                self.bumpY += 2
                self.bumperSpriteIcon:moveTo(self.bumperSpriteIcon.x, self.bumpY)
            end
        else
            --self.bumperSpriteIcon:remove()
        end
    end
    if self.inventorySize < 2 then
        self.bumperSpriteIcon:moveTo(382, self.bumpY)
    else
        self.bumperSpriteIcon:moveTo(348, self.bumpY)
    end

end

function Kosmonaut:dashUsage()
    if self.dashCooldown > 0 then
        self.dashCooldown -= 1
        if self.dashCooldown == 1 then
            self.jetpackSoundBeep:play()
        end
    end
    if self.dashCooldown == 0 and self.playerIsDead == false and self.speed > 0 and
        playdate.buttonJustPressed(playdate.kButtonA) and
        (
        playdate.buttonIsPressed(playdate.kButtonDown) or playdate.buttonIsPressed(playdate.kButtonRight) or
            playdate.buttonIsPressed(playdate.kButtonLeft) or playdate.buttonIsPressed(playdate.kButtonUp)) then
        self.tempSpeed = self.speed
        self.speed = 4
        self.dashCooldown = 100
        print("DASH")
        self.dashActive = true
        self.jetpackSound:play()
        playdate.timer.performAfterDelay(200, function()
            self.speed = self.tempSpeed
            self.dashActive = false

        end)
    end
end
