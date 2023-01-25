import "CoreLibs/object"
import "lua/statesFramework/state"
import "lua/enemyScripts/gutter/gutter"
import "lua/enemyScripts/gutter/tail"
import "lua/kosmonaut"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class("GutterIdle").extends("State")


function GutterIdle:Init()
    --print("gutterIdle init")
    GutterIdle.super.init(Gutter())
end

function GutterIdle:onEnter()
    self.objectToControl.sprite:setCollideRect(10,10,20,20)
    GutterIdle.super.onEnter(self)
   
    self.tailCounter = 0
    --self.tail = { { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 } }
    self.tailSpriteTable = self.objectToControl.tailTableToCopy

    self.tailSpriteLength = 1
    self.objectToControl.sprite:setCenter(0.5, 0.7)
    

    self.objectToControl.currentAnimation = self.animationIdle
    self.enemyChasingDelay = 0

    for k, v in ipairs(self.tailSpriteTable) do
        self.tailSpriteTable[k].tailSprite:setZIndex(2)
    end
    
end

function GutterIdle:onExit()
    GutterIdle.super.onExit(self)
end

function GutterIdle:onWork()
    GutterIdle.super.onWork(self)
    self.tailSpriteTable[self.tailSpriteLength].tailSprite:setZIndex(self.objectToControl.sprite:getZIndex() - 102)
    self.playerIsDead = self.objectToControl.playerIsDead
    if self.playerIsDead == true then
        self.removeIfTooFarAndPlayerDead(self)
    end
    self.tailMoving(self)
    self.objectToControl:setDistanceToReturn()
    self.objectToControl:idleAnim(distanceX, distanceY, enemyTriggerDistance, enemyChasingDistance)
    if self.objectToControl.currentAnimation ~=nil then
        self.objectToControl.currentAnimation:updateFrame()
        
    end
    
    self.removeIfTooFarAndPlayerDead(self)
    --self.ChangeZIndexDependingOnPlayerYValue(self)

end

function GutterIdle:tailMoving()
    self.tailCounter +=1
    if self.tailCounter > 10 then
        self.tailSpriteTable[self.tailSpriteLength]:moveTo(self.objectToControl.sprite.x, self.objectToControl.sprite.y)
        
        self.tailSpriteTable[self.tailSpriteLength]:add()
        --print("adding from idle")
        self.tailSpriteLength +=1
        if self.tailSpriteLength > 6 then
            self.tailSpriteLength = 1
        end
        self.tailCounter = 0
    end
end

function GutterIdle:removeIfTooFarAndPlayerDead()
    if (self.objectToControl.distanceX > enemyChasingDistance and self.playerIsDead == true) or (self.objectToControl.distanceY > enemyChasingDistance and self.playerIsDead == true) then
        self.objectToControl.sprite:remove()
        --print("removal +++++++++++++++++++++++++++++++++++++++++")
        for k,v in pairs(self.tailSpriteTable)do
            self.tailSpriteTable[k]:remove()
            
        end
        self.blockTailMovement = true
    end
end

-- function GutterIdle:ChangeZIndexDependingOnPlayerYValue()
--     if Kosmonaut:playerPositionY() > self.objectToControl.sprite.y - 10 and math.abs(Kosmonaut:playerPositionX() - self.objectToControl.sprite.x) <20 then
--         self.objectToControl.sprite:setZIndex(3)
--     else
--         self.objectToControl.sprite:setZIndex(8)
--     end
-- end

