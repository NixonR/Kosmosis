import "CoreLibs/object"
import "lua/statesFramework/state"
import "lua/enemyScripts/gutter/gutter"
import "lua/spriteanimation"
import "lua/kosmonaut"
import "lua/enemyScripts/gutter/tail"




local pd <const> = playdate
local gfx <const> = playdate.graphics

class("GutterVictory").extends("State")

local dir
local r = 0 --simple counter to determine how often gutter changes direction following player
local t = 0 -- how often tail moves, tail gaps depend on that
local movingInterval = 0

function GutterVictory:Init()
    GutterVictory.super.init(Gutter())

end

function GutterVictory:onEnter()

    GutterVictory.super.onEnter(self)
    -- print("GutterVictory on enter ")
    -- TAIL MANAGEMENT ----------------------------------------------------------------------------------------------------------------
    self.tailCounter = 0
    self.tailSpriteLength = 1
    self.tailSpriteTable = { self.objectToControl.tail1, self.objectToControl.tail2, self.objectToControl.tail3,
        self.objectToControl.tail4, self.objectToControl.tail5, self.objectToControl.tail6 }

    self.curID = 0
    self.objectToControl.sprite:setCollideRect(-12, -12, 60, 60)
    self.objectToControl.currentAnimation:updateFrame()

    self.gridG = self.objectToControl:returnGridG()
    self.startID = self.objectToControl.startID
    self.currentID = self.startID


    self.counter = 0
    self.sprite = self.objectToControl.sprite
    self.m = 0

end

function GutterVictory:onExit()

    --print("GutterVictory onExit")
    GutterVictory.super.onExit(self)
end

function GutterVictory:onWork()
    GutterVictory.super.onWork(self)
    --self.objectToControl.sprite:setCollideRect(-12, -12, 60, 60)

    self.objectToControl:setDistanceToReturn() --DISTANCE FROM PLAYER TO ENEMY

    self.random = math.random(1, 40)
    self.simpleCounter(self)
    self.playerIsDead = self.objectToControl.playerIsDead
    if self.m == 10 then
        self:movingHead()

        -- elseif self.playerIsDead == true and (self.m == 2 or self.m == 5 or self.m == 8) then
        --     self:movingHead()
    end --GUTTER MOVING
    --print(self.playerIsDead, "victory state------------")



    self.objectToControl:animationUpdate(dir) --CHANGE ANIMATION

    dir = self.directionChasing --CHANGE ANIMATION - PASS THE ARGUMENT -- directionChasing taken from movingHead

    self.objectToControl.currentAnimation:updateFrame() --CHANGE ANIMATION -- ANIMATION WORKING

    self.checkCollsionsForHead(self)

    if self.playerIsDead == true then
        self.objectToControl.sprite:setZIndex(12)
        for k, v in ipairs(self.tailSpriteTable) do
            self.tailSpriteTable[k].tailSprite:setZIndex(11)
        end
    end





end

function GutterVictory:checkCurrentID() --SPRAWDZA OBECNE ID
    for k, v in ipairs(self.gridG) do
        if self.gridG[k][1] == self.sprite.x and self.gridG[k][2] == self.sprite.y then
            self.startID = k
            self.currentID = k
        end
    end
    return self.startID
end

function GutterVictory:checkCollsionsForHead()
    if self.gridG[self.currentID - 1] ~= nil then
        self.a = currentscreen:checkCollisionAt(self.gridG[self.currentID - 1][1], self.gridG[self.currentID - 1][2]) -- left
    end
    if self.gridG[self.currentID - 40] ~= nil then
        self.b = currentscreen:checkCollisionAt(self.gridG[self.currentID - 40][1], self.gridG[self.currentID - 40][2])
    end
    if self.gridG[self.currentID + 1] ~= nil then -- up
        self.c = currentscreen:checkCollisionAt(self.gridG[self.currentID + 1][1], self.gridG[self.currentID + 1][2])
    end
    if self.gridG[self.currentID + 40] ~= nil then -- right
        self.d = currentscreen:checkCollisionAt(self.gridG[self.currentID + 40][1], self.gridG[self.currentID + 40][2]) -- down
    end

end

function GutterVictory:simpleCounter() --simple counter to determine how often gutter changes direction following player

    self.m += 1

    if self.m > 10 then
        self.m = 0
    end
end

function GutterVictory:movingHead()

    self.tailMoving(self)
    self.removeIfTooFarAndPlayerDead(self)
    self.checkCurrentID(self)
    self.checkCollsionsForHead(self)


    self.counter += 1

    if self.a and self.counter < 2 then
        self.currentID -= 1
        self.directionChasing = "animationChaseDownLeft"

    elseif self.d and self.counter >= 2 and self.counter < 4 then
        self.currentID += 40
        self.directionChasing = "animationChaseDownLeft"

    elseif self.c and self.counter >=4 and self.counter < 5 then
        self.currentID += 1
        self.directionChasing = "animationChaseDownRight"


    elseif self.b and self.counter >= 5 and self.counter < 8 then

        self.currentID -= 40
        self.directionChasing = "animationChaseDownRight"
    elseif self.c and self.counter >= 8 and self.counter < 9 then

        self.currentID += 1
        self.directionChasing = "animationChaseDownRight"

    elseif self.d and self.counter >= 9 and self.counter < 11 then

        self.currentID += 40
        self.directionChasing = "animationChaseDownRight"
    elseif self.a and self.counter >= 11 and self.counter < 14 then

        self.currentID -= 1 
        self.directionChasing = "animationChaseDownRight"

   
    end
    if self.counter >= 11 then

        --gfx.sprite:removeAll()
    end




    sprite:moveTo(self.gridG[self.currentID][1], self.gridG[self.currentID][2])
end

function GutterVictory:tailMoving()
    self.tailCounter += 1
    if self.tailCounter > 0 then
        self.tailSpriteTable[self.tailSpriteLength]:moveTo(self.objectToControl.sprite.x, self.objectToControl.sprite.y)

        self.tailSpriteTable[self.tailSpriteLength]:add()
        -- victory")
        self.tailSpriteLength += 1
        if self.tailSpriteLength > 6 then
            self.tailSpriteLength = 1
        end
        self.tailCounter = 0
    end
end

function GutterVictory:removeIfTooFarAndPlayerDead()
    if (self.objectToControl.distanceX > 60 and self.playerIsDead == true) or
        (self.objectToControl.distanceY > 60 and self.playerIsDead == true) then
        self.objectToControl.sprite:remove()
        for k, v in ipairs(self.tailSpriteTable) do
            self.tailSpriteTable[k]:remove()
        end
        -- print("removal555")
    end
end
