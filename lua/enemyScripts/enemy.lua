import "CoreLibs/object"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/graphics"
import "CoreLibs/frameTimer"

import "lua/spriteanimation"

local pd <const> = playdate
local gfx <const> = playdate.graphics


class('Enemy').extends(gfx.sprite)



function Enemy:init(self, x, y)

    self.sprite = gfx.sprite.new()
    
    
    --self.gridTable = Level:returnGrid
    if (x ~= nil) then
        self.sprite:moveTo(x, y)
      
    end
    self.sprite:setTag("666")
    --self.sprite:add()
    self.canTransit = true


    self.distanceFromPlayerX = 0
    self.distanceFromPlayerY = 0
    self.enemyChasingDistance = 0
    self.enemyTriggerDistance = 0
    -- self.sprite:setGroups(2)
    -- self.sprite:setCollidesWithGroups({2, 1})
    self.playerCloseToEnemy = nil
    self.enemyChasingDistance = nil
    --print("enemy init")



end

function Enemy:updateWork()
    self.setDistanceFromPlayer(self)
    --print(self.distanceFromPlayerY)
    self.setEnemyTriggerDistance(self)
    --print(self.enemyTriggerDistance)
    self.setEnemyChasingDistance(self)
    --print(self.enemyChasingDistance)
    self.isEnemyClose(self)
    self.isEnemyInTrigger(self)
    --print("enemy updateWork")
    
    
    -- self.isEnemyInTrigger(self)
    -- self.isEnemyClose(self)

    --self.setEnemyTriggerDistance(self)
    --print(distanceFromPlayerX, enemyTriggerDistance, self.playerCloseToEnemy)

end

function Enemy:isEnemyClose()
    if self.distanceFromPlayerX ~= nil and self.distanceFromPlayerY ~= nil then
        if self.distanceFromPlayerX < self.enemyTriggerDistance and self.distanceFromPlayerY < self.enemyTriggerDistance then
            self.playerCloseToEnemy = true
        else
            self.playerCloseToEnemy = false
        end
    end
    --return self.playerCloseToEnemy

end

function Enemy:isEnemyInTrigger()
    if self.distanceFromPlayerX ~= nil and self.distanceFromPlayerY ~= nil then
        if self.distanceFromPlayerX < self.enemyChasingDistance and self.distanceFromPlayerY < self.enemyChasingDistance then
            self.chasingDistanceTrigger = true

        else
            self.chasingDistanceTrigger = false
        end
    end
    --return self.chasingDistanceTrigger

end

function Enemy:setDistanceFromPlayer()
    self.distanceFromPlayerX = Gutter:returnDistanceToPlayerX()
    self.distanceFromPlayerY = Gutter:returnDistanceToPlayerY()
end

function Enemy:setEnemyChasingDistance()
    self.enemyChasingDistance = Gutter:returnEnemyChasingDistance()
end

function Enemy:setEnemyTriggerDistance()
    self.enemyTriggerDistance = Gutter:returnEnemyTriggerDistance()
end
