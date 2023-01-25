import "CoreLibs/object"
import "lua/statesFramework/state"
import "lua/enemyScripts/gutter/gutter"
import "lua/spriteanimation"
import "lua/kosmonaut"
import "lua/enemyScripts/gutter/tail"
import "CoreLibs/timer"





local pd <const> = playdate
local gfx <const> = playdate.graphics

class("GutterChase").extends("State")

local dir
local r = 0 --simple counter to determine how often gutter changes direction following player
local t = 0 -- how often tail moves, tail gaps depend on that
local movingInterval = 0

function GutterChase:Init()


    -- self.tail7 = Tail(44, 44)
    -- self.tail8 = Tail(44, 44)
    -- self.tail9 = Tail(44, 44)
    -- self.tail10 = Tail(44, 44)
    GutterChase.super.init(Gutter())
    self.playerIsDead = false
    --self.startID = self.gridG.nodeWithXY(self.gx, self.gy)


end

function GutterChase:onEnter()
    GutterChase.super.onEnter(self)

    self.tailCounter = 0
    --TAIL MANAGEMENT -------------------------------------------------------------------------
    --self.tail = { { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 } }
    self.tailSpriteTable = { self.objectToControl.tail1, self.objectToControl.tail2, self.objectToControl.tail3,
        self.objectToControl.tail4, self.objectToControl.tail5, self.objectToControl.tail6 }


    self.tailSpriteLength = 1
    self.m = 0
    self.curID = 0
    --print("gutter chase ")

    self.objectToControl.sprite:setCollideRect(0, 0, 20, 20)
    self.objectToControl.currentAnimation:updateFrame()

    self.gridG = self.objectToControl:returnGridG()
    self.startID = self.objectToControl.startID
    self.currentID = self.startID
    self.sprite = self.objectToControl.sprite
    self.gutterMoveSound = playdate.sound.sampleplayer.new("sounds/gulp")
    self.gutterMoveSound:setVolume(0.05)
    self.gutterIdleSound = playdate.sound.sampleplayer.new("sounds/grr")
    self.gutterIdleSound:setVolume(0.05)
    self.gutterIdleSound:play()

end

function GutterChase:onExit()
    -- print("GutterChase onExit")


    GutterChase.super.onExit(self)

end

function GutterChase:onWork()

    -- print(self.gutterMoveSound, "gutter move sound")
    -- print(self.gutplay, "gutter move sound  2 2 2 ")


    GutterChase.super.onWork(self)

    self.tailSpriteTable[self.tailSpriteLength].tailSprite:setZIndex(self.sprite:getZIndex() - 102)
    self.playerIsDead = self.objectToControl.playerIsDead
    if self.playerIsDead == true then
        self.removeIfTooFarAndPlayerDead(self)
    end
    self.simpleCounter(self) --GUTTER MOVING
    --print(self.tailCounter)

    self.objectToControl:setDistanceToReturn() --DISTANCE FROM PLAYER TO ENEMY

    self.random = math.random(1, 40)

    if self.m == 25 then
        self:movingHead() --GUTTER MOVING
    end

    self.objectToControl:animationUpdate(dir) --CHANGE ANIMATION
    dir = self.directionChasing --CHANGE ANIMATION - PASS THE ARGUMENT -- directionChasing taken from movingHead
    self.objectToControl.currentAnimation:updateFrame() --CHANGE ANIMATION -- ANIMATION WORKING

    if self.objectToControl.blockTailMovement == false then
        --self.tailMoving(self)

    end

    self.changeToIdle(self)
    self.checkCollsionsForHead(self)

    --print(headToTailX)
    --print(self.objectToControl.playerIsDead, "chase state------------")

end

function GutterChase:simpleCounter() --simple counter to determine how often gutter changes direction following player

    self.m += 1

    if self.m > 25 then
        self.m = 0
    end
end

function GutterChase:checkCollsionsForHead()
    --printTable(self.gridG[self.currentID - 1])
    --print(self.a, "aaa")

    --if self.gridG[self.currentID - 1][1] ~= 0 then
    self.a = currentscreen:checkCollisionAt(self.sprite.x - 10, self.sprite.y) -- left
    --end
    -- if self.gridG[self.currentID - 40] ~= nil then
    self.b = currentscreen:checkCollisionAt(self.sprite.x, self.sprite.y - 10)
    --end
    --if self.gridG[self.currentID + 1] ~= nil then -- up
    self.c = currentscreen:checkCollisionAt(self.sprite.x + 10, self.sprite.y)
    --end
    --if self.gridG[self.currentID + 40] ~= nil then -- right
    self.d = currentscreen:checkCollisionAt(self.sprite.x, self.sprite.y + 10) -- down
    --end

end

function GutterChase:movingHead()
    --self.gutterMoveSound:play(1,1)
    if currentscreen.gutterTargetPositionX == nil then
        self.playerPositionX = Kosmonaut:playerPositionX()
        self.playerPositionY = Kosmonaut:playerPositionY()
    else
        self.playerPositionX = currentscreen.gutterTargetPositionX 
        self.playerPositionY = currentscreen.gutterTargetPositionY
    end
    local x = self.objectToControl.sprite.x
    local y = self.objectToControl.sprite.y
    local rValue = 25
    self.counter = r
    self.checkCurrentID(self)



    if self.random ~= nil then
        self.tailMoving(self)
        if (self.playerPositionX < x and self.playerPositionY < y + 5 and self.playerPositionY > y - 5) and self.a then -- player is left

            self.currentID -= 1
            --print(self.currentID)
            self.directionChasing = "animationChaseLeft"
            self.gutterMoveSound:play()

        elseif (
            self.playerPositionX > x and self.playerPositionY < y + 5 and self.playerPositionY > y - 5) and self.c then -- player is right


            self.currentID += 1
            --print(self.currentID)
            self.directionChasing = "animationChaseRight"
            self.gutterMoveSound:play()
        elseif (
            self.playerPositionX < x + 5 and self.playerPositionX > x - 5 and self.playerPositionY < y) and self.b then -- player is up

            -- player left
            self.currentID -= 40
            --print(self.currentID)
            self.directionChasing = "animationChaseUp"
            self.gutterMoveSound:play()
        elseif (
            self.playerPositionX < x + 5 and self.playerPositionX > x - 5 and self.playerPositionY > y) and self.d then -- player is down

            self.currentID += 40
            -- print(self.currentID)
            self.directionChasing = "animationChaseDown"
            self.gutterMoveSound:play()
        elseif (self.playerPositionX < x and self.playerPositionY < y) and self.a and self.b then -- player left up

            if self.random < rValue then
                self.currentID -= 1
                --print(self.currentID)
            elseif self.random > rValue then
                self.currentID -= 40
                --print(self.currentID)
            end
            self.directionChasing = "animationChaseUpLeft"
            self.gutterMoveSound:play()
        elseif (self.playerPositionX < x and self.playerPositionY > y) and self.a and self.d then -- player left down

            if self.random < rValue then
                self.currentID -= 1
                --print(self.currentID)
            elseif self.random > rValue then
                self.currentID += 40
                --print(self.currentID)
            end
            self.directionChasing = "animationChaseDownLeft"
            self.gutterMoveSound:play()
        elseif (self.playerPositionX > x and self.playerPositionY < y) and self.c and self.b then -- player right up

            if self.random < rValue then
                self.currentID += 1
                --print(self.currentID)
            elseif self.random > rValue then
                self.currentID -= 40
                --print(self.currentID)
            end
            self.directionChasing = "animationChaseUpRight"
            self.gutterMoveSound:play()
        elseif (self.playerPositionX > x and self.playerPositionY > y) and self.c and self.d then -- player is right down ;

            if self.random < rValue then
                self.currentID += 1
                --print(self.currentID) -- player right down
            elseif self.random > rValue then
                self.currentID += 40
                --print(self.currentID)
            end
            self.directionChasing = "animationChaseDownRight"
            self.gutterMoveSound:play()
        elseif self.a then
            self.currentID -= 1
            --print("aaa")
            self.gutterMoveSound:play()
        elseif self.b then
            self.currentID -= 40
            --print("bbb")
            self.gutterMoveSound:play()
        elseif self.c then
            self.currentID += 1
            -- print("ccc")
            self.gutterMoveSound:play()
        elseif self.d then
            self.currentID += 40
            -- print("ddd")
            self.gutterMoveSound:play()
        end

    end
    if self.gridG[self.currentID] ~= nil then
        self.sprite:moveTo(self.gridG[self.currentID][1], self.gridG[self.currentID][2])
    end
end

function GutterChase:checkCurrentID() --SPRAWDZA OBECNE ID
    for k, v in ipairs(self.gridG) do
        if self.gridG[k][1] == self.sprite.x and self.gridG[k][2] == self.sprite.y then
            self.startID = k
            self.currentID = k
        end
    end
    return self.startID
end

function GutterChase:changeToIdle()
    self.objectToControl:setDistanceToReturn()
    if self.objectToControl.distanceX > self.objectToControl.whenChaseStateChangesToIdle or
        self.objectToControl.distanceY > self.objectToControl.whenChaseStateChangesToIdle then
        --self.objectToControl.blockTailMovement = true

        self.checkCurrentID(self)
        --print(self.currentID)
        playdate.timer.performAfterDelay(1000, function()

            self.objectToControl.currentState = self.objectToControl.gutterIdle:changeState(self.objectToControl.currentState
                , self.objectToControl.gutterIdle)
            print("change to idle from chase state class")
        end)
    end
end

-- function GutterChase:tailPosition()
--     --print("9999999999999999999")
--     Tail:tailPosition(self.tail, self.sprite.x, self.sprite.y)

-- end

function GutterChase:tailMoving()
    self.tailCounter += 1
    if self.tailCounter > 0 then
        self.tailSpriteTable[self.tailSpriteLength]:moveTo(self.objectToControl.sprite.x, self.objectToControl.sprite.y)



        self.tailSpriteTable[self.tailSpriteLength]:add()
        --print("adding from chase")
        self.tailSpriteLength += 1
        if self.tailSpriteLength > 6 then
            self.tailSpriteLength = 1
        end
        self.tailCounter = 0
    end
end

function GutterChase:removeIfTooFarAndPlayerDead()
    if (self.objectToControl.distanceX > enemyChasingDistance and self.playerIsDead == true) or
        (self.objectToControl.distanceY > enemyChasingDistance and self.playerIsDead == true) then
        self.objectToControl.sprite:remove()
        for k, v in pairs(self.tailSpriteTable) do
            self.tailSpriteTable[k]:remove()
        end
        self.blockTailMovement = true
    end
end
