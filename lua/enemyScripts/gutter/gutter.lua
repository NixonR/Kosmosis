import "CoreLibs/timer"
import "CoreLibs/sprites"
import "lua/spriteanimation"
import "lua/enemyScripts/enemy"
import "lua/enemyScripts/gutter/tail"
import "lua/statesFramework/state"
import "lua/enemyScripts/gutter/gutteridle"
import "lua/enemyScripts/gutter/gutterchase"
import "lua/enemyScripts/gutter/guttervictory"
import "lua/screens/level"
import "lua/kosmonaut"

local pd <const> = playdate
local gfx <const> = playdate.graphics


class('Gutter').extends('Enemy')

local playerPositionX
local playerPositionY
local x
local y
local rValue = 10 -- losowa wartość dla poruszania się guttera




function Gutter:init(x, y)



    Gutter.super:init(self, x, y)
    self.g = nil
    self.basicX = 0
    self.basicY = 0
    self.enemyChasingDelay = 0
    self.sprite:setCenter(0.5, 0.5)

    self.defaulPosition = self.sprite:getPosition()
    self.sprite:setTag(20)
    self.GRIDidBOOL = true
    self.victoryBool = true
    self.startID = 0
    self.blockTailMovement = false
    self.damageTaken = 0

    --self.gridID = self

    -- ANIMATION--
    self.animationIdle = SpriteAnimation(self.sprite)
    self.animationIdle:addImage("images/gutter/gutter_sleep")


    self.animationShake = SpriteAnimation(self.sprite)
    self.animationShake:addImage("images/gutter/gutter_stupor")
    self.animationShake:addImage("images/gutter/gutter_stupor")
    self.animationShake:addImage("images/gutter/gutter_aware")
    self.animationShake:addImage("images/gutter/gutter_aware")

    self.animationShakeFast = SpriteAnimation(self.sprite)
    self.animationShakeFast:addImage("images/gutter/gutter_stupor")
    self.animationShakeFast:addImage("images/gutter/gutter_aware")

    self.animationChaseUpRight = SpriteAnimation(self.sprite)
    self.animationChaseUpRight:addImage("images/gutter/gutter_head_down")
    self.animationChaseUpRight:addImage("images/gutter/gutter_head_right")
    self.animationChaseUpRight:addImage("images/gutter/gutter_head_right")

    self.animationChaseUpLeft = SpriteAnimation(self.sprite)
    self.animationChaseUpLeft:addImage("images/gutter/gutter_head_down")
    self.animationChaseUpLeft:addImage("images/gutter/gutter_head_left")
    self.animationChaseUpLeft:addImage("images/gutter/gutter_head_left")

    self.animationChaseDownRight = SpriteAnimation(self.sprite)
    self.animationChaseDownRight:addImage("images/gutter/gutter_head_down")
    self.animationChaseDownRight:addImage("images/gutter/gutter_head_down")
    self.animationChaseDownRight:addImage("images/gutter/gutter_head_right")
    self.animationChaseDownRight:addImage("images/gutter/gutter_head_right")

    self.animationChaseDownLeft = SpriteAnimation(self.sprite)
    self.animationChaseDownLeft:addImage("images/gutter/gutter_head_down")
    self.animationChaseDownLeft:addImage("images/gutter/gutter_head_down")
    self.animationChaseDownLeft:addImage("images/gutter/gutter_head_left")
    self.animationChaseDownLeft:addImage("images/gutter/gutter_head_left")
    self.animationChaseDownLeft:addImage("images/gutter/gutter_head_left")

    self.animationChaseDown = SpriteAnimation(self.sprite)
    self.animationChaseDown:addImage("images/gutter/gutter_head_down")
    self.animationChaseDown:addImage("images/gutter/gutter_head_left")
    self.animationChaseDown:addImage("images/gutter/gutter_head_down")
    self.animationChaseDown:addImage("images/gutter/gutter_head_right")

    self.animationChaseUp = SpriteAnimation(self.sprite)
    self.animationChaseUp:addImage("images/gutter/gutter_head_up")

    self.animationRotate = SpriteAnimation(self.sprite)
    self.animationRotate:addImage("images/gutter/gutter_head_down")
    self.animationRotate:addImage("images/gutter/gutter_head_left")
    self.animationRotate:addImage("images/gutter/gutter_head_up")
    self.animationRotate:addImage("images/gutter/gutter_head_right")

    self.deathSprite = gfx.sprite.new(gfx.image.new("images/gutter/gutter_head_death"))
  

    -- basic animation state
    self.currentAnimation = self.animationRotate

    self.sprite:setCollideRect(0, 0, 20, 20) -- basic rect to check collisions

    self.sprite.collisionResponse = 'overlap'

    self.playerIsDead = false

    self.speed = 0.5 -- szybkość poruszania się guttera
    self.distanceX = 0
    self.distanceY = 0

    self.tail1 = Tail(44, 44)
    self.tail2 = Tail(44, 44)
    self.tail3 = Tail(44, 44)
    self.tail4 = Tail(44, 44)
    self.tail5 = Tail(44, 44)
    self.tail6 = Tail(44, 44)
    self.tailTableToCopy = { self.tail1, self.tail2, self.tail3,
        self.tail4, self.tail5, self.tail6 }

    -- for k, v in ipairs(self.tailSpriteTable) do
    --     self.tailSpriteTable[k]:moveTo(self.sprite.x, self.sprite.y)
    --     self.tailSpriteTable[k]:add()
    --     print("przenoszę do poczatkowego punktu ===============")

    -- end

    --DOSTĘPNE STANY DLA GUTTERA ----------------------------------------------------------------------------

    self.gutterIdle = GutterIdle(self)
    self.gutterChase = GutterChase(self)
    self.gutterVictory = GutterVictory(self)
    self.currentState = self.gutterIdle:changeState(self.currentState, self.gutterIdle)
    self.path = nil
    self.isInRoverScreen = false
    self.whenChaseStateChangesToIdle = 200

    self.burned = false

end

--UPDATE WORK ---------------------------------------------------------------------------------------------------------
function Gutter:updateWork()
    self.setDistanceToReturn(self)
    self.setValuesToLocals(self)
    self.changeStateIfTooClose(self)
    self.gridG = currentscreen:returnGrid()
    print(self.damageTaken, "damage taken")
    self.g = self.gridG

    self.currentState:work()
    if currentscreen.kosmonaut.isRover == true then
        self.whenChaseStateChangesToIdle = 500
    else
        self.whenChaseStateChangesToIdle = 100
    end

    self.playerIsDead = currentscreen.playerIsDead
    self.startIDWriting(self)
    self.changeStateIfDead(self) -- ZMIENIA STAN JEŚLI GRACZ JEST MARTWY
    self.removeIfTooFarAndPlayerDead(self)
    self.changeZIndexDependingOnPlayer(self)
    --self.playerIsDead = globalPlayerIsDead
    --print(self.playerIsDead, "player is dead info")

    self.checkCollision(self)
    if self.burned == true then
        self.sprite:remove()
        self.currentState = self.gutterIdle:changeState(self.currentState, self.gutterIdle)
    end


end

--GRID TEST--------------------------------------------------------------------------------------
function Gutter:returnGridG()
    return self.g
end

function Gutter:startIDWriting()
    if self.basicX == 0 and self.basicY == 0 then --ZAPISUJE STARTOWE ID GUTTERA W DANYM MIEJSCU
        self.basicX = self.sprite.x
        self.basicY = self.sprite.y
    end
end

--ANIMATION MANAGEMENT-----------------------------------------------------------------
function Gutter:animationUpdate(dir)
    self.directionChasing = dir
    if self.directionChasing == "animationChaseUpRight" then
        self.currentAnimation = self.animationChaseUpRight

    elseif self.directionChasing == "animationChaseUpLeft" then
        self.currentAnimation = self.animationChaseUpLeft

    elseif self.directionChasing == "animationChaseDownRight" then
        self.currentAnimation = self.animationChaseDownRight

    elseif self.directionChasing == "animationChaseDownLeft" then
        self.currentAnimation = self.animationChaseDownLeft

    elseif self.directionChasing == "animationChaseLeft" then
        self.currentAnimation = self.animationChaseDownLeft

    elseif self.directionChasing == "animationChaseRight" then
        self.currentAnimation = self.animationChaseDownRight

    elseif self.directionChasing == "animationChaseUp" then
        self.currentAnimation = self.animationChaseUp

    elseif self.directionChasing == "animationChaseDown" then
        self.currentAnimation = self.animationChaseDown

    elseif self.directionChasing == "animationRotate" then
        self.currentAnimation = self.animationRotate
    end

end

function Gutter:idleAnim(distanceX, distanceY, enemyTriggerDistance, enemyChasingDistance)

    if self.distanceX > enemyTriggerDistance or self.distanceY > enemyTriggerDistance then
        self.currentAnimation = self.animationIdle
    elseif self.distanceX < enemyTriggerDistance and self.distanceY < enemyTriggerDistance then
        self.currentAnimation = self.animationShake
    end
    if self.distanceX < enemyChasingDistance and self.distanceY < enemyChasingDistance then
        self.currentAnimation = self.animationShakeFast
        self.enemyChasingDelay += 1
    else
        self.enemyChasingDelay = 0
    end
    return self.enemyChasingDelay
end

--VALUES NEEDED -----------------------------------------------------------------------------------
function Gutter:setValuesToLocals()
    x = self.sprite.x
    y = self.sprite.y
    sprite = self.sprite
    speed = self.speed
end

--CHANGE STATE IF ----------------------------------------------------------------------------------------
function Gutter:changeStateIfTooClose()
    if (self.enemyChasingDelay > 105) then
        self.currentAnimation = self.animationChaseDownLeft
        self.currentState = self.gutterIdle:changeState(self.currentState, self.gutterChase)
        self.enemyChasingDelay = 0
        print("changed to chasing ")
    end
end

function Gutter:changeStateIfDead()
    --OKREŚLA CZY PLAYER JEST MARTWY
    if self.playerIsDead == true then
        self.sprite:setZIndex(12)
    elseif self.playerIsDead == false and self.currentState == self.gutterChase or
        self.currentState == self.gutterVictory then
        self.sprite:setZIndex(4)
    end

    if (self.playerIsDead == true and self.victoryBool == true) then -- JEŚLI GRACZ JEST MARTWY I VICTORY STATE MOŻE SIĘ POJAWIĆ
        playdate.timer.performAfterDelay(1500, function()
            self.currentState = self.gutterIdle:changeState(self.currentState, self.gutterVictory)
        end)

        self.victoryBool = false

    elseif (self.playerIsDead == false and self.victoryBool == false) then -- JEŚLI GRACZ ZROBIL RESPAWN ZMIEŃ STAN I WRÓĆ DO BAZOWEGO POŁOŻENIA
        self.blockTailMovement = false
        self.currentState = self.gutterIdle:changeState(self.currentState, self.gutterIdle)
        self.sprite:moveTo(self.basicX, self.basicY)
        self.sprite:add()
        for k, v in ipairs(self.gridG) do -- PRZYWRÓĆ ID OGONA DO POZYCJI BAZOWEJ
            if self.gridG[k][1] == self.basicX and self.gridG[k][2] == self.basicY then
                self.startID = k
            end
        end

        self.victoryBool = true -- POZWÓL VICTORY STATE NA PONOWNE UŻYCIE
        print("change to idle after death")
        print(self.victoryBool, "victory bool ")
    end
end

--RETURN VALUES TO OTHER CLASS---------------------------------------------------------
function Gutter:returnEnemyValueX()
    return self.distanceToPlayerValueX
end

function Gutter:returnEnemyValueY()
    return self.distanceToPlayerValueY
end

function Gutter:returnEnemyChasingDistance()
    return enemyChasingDistance
end

function Gutter:returnEnemyTriggerDistance()
    return enemyTriggerDistance
end

function Gutter:returnDistanceToPlayerX()
    return distanceX
end

function Gutter:returnDistanceToPlayerY()
    return distanceY
end

function Gutter:returnSelfSprite()
    return self.sprite
end

function Gutter:setDistanceToReturn()
    enemyTriggerDistance = 150
    if currentscreen.kosmonaut.isRover == true then
        enemyTriggerDistance = 400
        enemyChasingDistance = 400

    else
        enemyChasingDistance = 80
        enemyTriggerDistance = 150
    end
    self.playerPositionX = Kosmonaut:playerPositionX()
    self.playerPositionY = Kosmonaut:playerPositionY()
    self.distanceX = math.abs(self.playerPositionX - self.sprite.x) -- calculating distance x between player and enemy
    self.distanceY = math.abs(self.playerPositionY - self.sprite.y) -- calculating distance y between player and enemy
    return distanceX, distanceY, enemyTriggerDistance, enemyChasingDistance
end

function Gutter:changeToChaseState()
    self.currentState = self.gutterIdle:changeState(self.currentState, self.gutterChase)
    print("change to chase function only")
end

function Gutter:removeIfTooFarAndPlayerDead()
    if (self.distanceX > enemyChasingDistance and self.playerIsDead == true) or
        (self.distanceY > enemyChasingDistance and self.playerIsDead == true) then
        self.sprite:remove()
        self.blockTailMovement = true
        --print("remove if too far and player dead")


    end
end

function Gutter:changeZIndexDependingOnPlayer()
    self.sprite:setZIndex(self.sprite.y - currentscreen.kosmonaut.posY)

    -- if Kosmonaut:playerPositionY() > self.flower.y - 20 then
    -- else
    --     self.flower:setZIndex(currentscreen.kosmonaut.kosmonautSprite:getZIndex()+ 1)
    --     self.roots:setZIndex(currentscreen.kosmonaut.kosmonautSprite:getZIndex()+2)
    -- end

end

function Gutter:checkCollision()
  
    local a, b, collision, length = self.sprite:checkCollisions(self.sprite.x, self.sprite.y)
    if self.damageTaken >= 50 then
        self.burned = true
        self.deathSprite:moveTo(self.sprite.x, self.sprite.y)
        self.deathSprite:add()
        explosivescreen.killCounter += 1
        self.deathSprite:setZIndex(self.tail1.tailSprite:getZIndex() + 103)
    end

    if length > 0 and collision[#collision].other:getTag() == (45) then
        self.damageTaken += 1

     
    end

end
