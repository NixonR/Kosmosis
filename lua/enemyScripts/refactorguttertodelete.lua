
-- local pd <const> = playdate
-- local gfx <const> = playdate.graphics


-- class('Gutter').extends('Enemy')

-- local playerPositionX
-- local playerPositionY

-- local movingDirectionForTail

-- --local interval2 =

-- local OldGutterPositionX = 0
-- local OldGutterPositionY = 0

-- local enemyTriggerDistance
-- local enemyChasingDistance

-- local distanceX
-- local distanceY
-- local deathIterator0 = 15
-- local deathIterator1 = 20
-- local deathIterator2 = 20
-- local deathIterator3 = 20
-- local deathIterator4 = 20
-- local moved = false

-- function Gutter:init(x, y)

--     Gutter.super:init(self, x, y)

--     self.randomValue = 0
--     self.blockTailMovement = false
--     self.minusInterval = 0.41 ----- 0.41 dla horizontal lub vertical, 0.292 dla diagonal
--     self.enemyTriggerDistance = 150 ------------------------------------------odleglosc w jakiej gutter się denerwuje
--     self.basicChasingValue = 80
--     self.enemyChasingDistance = self.basicChasingValue ------------------------------------------odleglosc w jakiej gutter goni gracza(jesli gutter goni gracza, odległość ta zwiększa się do 150)
--     self.intervalValue = 91
--     self.interval2 = playdate.getCurrentTimeMilliseconds()
--     self.removed = false
--     self.chaseValue = 0
--     self.timerStamp = 0
--     self.movingInterval = 0


--     self.actualGutterX = 0
--     self.actualGutterY = 0

--     self.sprite:setCenter(0.5, 0.7)
--     self.sprite:setZIndex(3)
--     self.defaulPosition = self.sprite:getPosition()
--     self.animationIdle = SpriteAnimation(self.sprite)
--     self.animationIdle:addImage("images/gutter/gutter_stupor"))
--     self.animationIdle:addImage("images/gutter/gutter_stupor"))
--     self.animationIdle:addImage("images/gutter/gutter_stupor"))
--     self.animationIdle:addImage("images/gutter/gutter_stupor"))
--     self.animationIdle:addImage("images/gutter/gutter_stupor"))
--     self.animationIdle:addImage("images/gutter/gutter_stupor"))
--     self.animationIdle:addImage("images/gutter/gutter_stupor"))
--     self.animationIdle:addImage("images/gutter/gutter_stupor"))
--     self.animationIdle:addImage("images/gutter/gutter_stupor"))

--     self.animationIdle:addImage("images/gutter/gutter_stupor"))
--     self.animationIdle:addImage("images/gutter/gutter_stupor"))
--     self.animationIdle:addImage("images/gutter/gutter_aware"))
--     self.animationIdle:addImage("images/gutter/gutter_aware"))
--     self.animationIdle:addImage("images/gutter/gutter_aware"))
--     self.animationIdle:addImage("images/gutter/gutter_aware"))
--     self.animationIdle:addImage("images/gutter/gutter_aware"))
--     self.animationIdle:addImage("images/gutter/gutter_aware"))




--     self.animationShake = SpriteAnimation(self.sprite)
--     self.animationShake:addImage("images/gutter/gutter_stupor"))
--     self.animationShake:addImage("images/gutter/gutter_stupor"))
--     self.animationShake:addImage("images/gutter/gutter_aware"))
--     self.animationShake:addImage("images/gutter/gutter_aware"))

--     self.animationShakeFast = SpriteAnimation(self.sprite)
--     self.animationShakeFast:addImage("images/gutter/gutter_stupor"))

--     self.animationShakeFast:addImage("images/gutter/gutter_aware"))


--     self.animationChaseUpRight = SpriteAnimation(self.sprite)
--     self.animationChaseUpRight:addImage("images/gutter/gutter_head_down"))
--     self.animationChaseUpRight:addImage("images/gutter/gutter_head_right"))
--     self.animationChaseUpRight:addImage("images/gutter/gutter_head_right"))

--     self.animationChaseUpLeft = SpriteAnimation(self.sprite)
--     self.animationChaseUpLeft:addImage("images/gutter/gutter_head_down"))
--     self.animationChaseUpLeft:addImage("images/gutter/gutter_head_left"))
--     self.animationChaseUpLeft:addImage("images/gutter/gutter_head_left"))

--     self.animationChaseDownRight = SpriteAnimation(self.sprite)
--     self.animationChaseDownRight:addImage("images/gutter/gutter_head_down"))
--     self.animationChaseDownRight:addImage("images/gutter/gutter_head_down"))
--     self.animationChaseDownRight:addImage("images/gutter/gutter_head_right"))
--     self.animationChaseDownRight:addImage("images/gutter/gutter_head_right"))

--     self.animationChaseDownLeft = SpriteAnimation(self.sprite)
--     self.animationChaseDownLeft:addImage("images/gutter/gutter_head_down"))
--     self.animationChaseDownLeft:addImage("images/gutter/gutter_head_down"))
--     self.animationChaseDownLeft:addImage("images/gutter/gutter_head_left"))
--     self.animationChaseDownLeft:addImage("images/gutter/gutter_head_left"))
--     self.animationChaseDownLeft:addImage("images/gutter/gutter_head_left"))


--     self.animationChaseDown = SpriteAnimation(self.sprite)
--     self.animationChaseDown:addImage("images/gutter/gutter_head_down"))
--     self.animationChaseDown:addImage("images/gutter/gutter_head_left"))
--     self.animationChaseDown:addImage("images/gutter/gutter_head_down"))
--     self.animationChaseDown:addImage("images/gutter/gutter_head_right"))

--     self.animationChaseUp = SpriteAnimation(self.sprite)
--     self.animationChaseUp:addImage("images/gutter/gutter_head_up"))

--     self.animationRotate = SpriteAnimation(self.sprite)
--     self.animationRotate:addImage("images/gutter/gutter_head_down"))
--     self.animationRotate:addImage("images/gutter/gutter_head_left"))
--     self.animationRotate:addImage("images/gutter/gutter_head_up"))
--     self.animationRotate:addImage("images/gutter/gutter_head_right"))

--     self.currentAnimation = self.animationIdle -- basic animation state
--     self.currentAnimation:updateFrame()

--     self.sprite:setCollideRect(6, 6, 34, 34) -- basic rect to check collisions

--     self.sprite.collisionResponse = 'overlap'
--     self.sprite:setTag("999")
--     self.playerIsDead = false



--     --TAIL MANAGEMENT -------------------------------------------------------------------------
--     self.tail1 = Tail(44, 44)
--     self.tail2 = Tail(44, 44)
--     self.tail3 = Tail(44, 44)
--     self.tail4 = Tail(44, 44)
--     self.tail5 = Tail(44, 44)
--     self.tail6 = Tail(44, 44)
--     self.tail7 = Tail(44, 44)
--     self.tail8 = Tail(44, 44)
--     self.tail9 = Tail(44, 44)
--     self.tail10 = Tail(44, 44)


--     self.tail = { { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }
--     }


--     self.tailSpriteLength = 10



--     self.tailSpriteTable = { self.tail1, self.tail2, self.tail3, self.tail4, self.tail5, self.tail6, self.tail7,
--         self.tail8, self.tail9, self.tail10 }



--     self.speed = 0.3
--     self.movedSpeed = 1

--     for k, v in ipairs(self.tailSpriteTable) do
--         self.tailSpriteTable[k]:moveTo(self.sprite.x, self.sprite.y)

--         --self.tailSpriteTable[k]:add()
--         print("przenoszę do poczatkowego punktu ===============")

--     end

--     self.GutterState = {
--         IdleState = 1,
--         ShakeState = 2,
--         ChaseState = 3,
--         PlayerIsDeadState = 4,
--         ShakeFastState = 5
--     }

--     self.gutterIsInTheSamePositionAsPlayer = false
--     --print("gutterinit")


-- end

-- function Gutter:setup()
--     self.minusInterval = 0.41 ----- 0.41 dla horizontal lub vertical, 0.292 dla diagonal
--     self.enemyTriggerDistance = 150 ------------------------------------------odleglosc w jakiej gutter się denerwuje
--     self.basicChasingValue = 80
--     self.enemyChasingDistance = self.basicChasingValue ------------------------------------------odleglosc w jakiej gutter goni gracza(jesli gutter goni gracza, odległość ta zwiększa się do 150)

--     self.sprite:setCenter(0.5, 0.7)
--     self.sprite:setZIndex(3)
--     self.sprite:moveTo(self.defaulPosition)


-- end

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- function Gutter:updateWork()

--     enemyChasingDistance = self.enemyChasingDistance
--     enemyTriggerDistance = self.enemyTriggerDistance
--     distanceX = self.valueX
--     distanceY = self.valueY
--     Gutter.super:updateWork(self)


--     for k, v in ipairs(self.tailSpriteTable) do
--         self.enemyValueX = self.sprite.x
--         self.enemyValueY = self.sprite.y
--         self.tailSpriteTable[k]:updateWork()
--     end


--     self.changeState(self)

--     self.moving(self)

--     self.changeAnimation(self)

--     self.setPlayerPosition(self)
-- self.calculateDistanceFromPlayer(self)
--     self.valueX = math.abs(playerPositionX - self.sprite.x) -- calculating distance x between player and enemy
--     self.valueY = math.abs(playerPositionY - self.sprite.y) -- calculating distance y between player and enemy

--     self.waitBeforeChase(self) --oblicza czy przekroczono aware time

--     self.currentAnimation:updateFrame()

--     self.removeForSpotlight(self)

--     self.setPlayerIsDead(self)

--     self.enemyPosition(self)

--     self.tailPosition(self)

--     if self.blockTailMovement == false then
--         self.tailMoving(self)
--     end

--     self.isInTheSamePosition(self)

--     self.changeSpriteCollisionDependingOnState(self)

--     self.playerCloseToEnemy = Enemy:isEnemyClose()


--     self.movingInterval += 1
--     if self.movingInterval > 20 then
--         self.randomValue = math.random(1, 40)
--         self.movingInterval = 0
--         self.interval2 = playdate.getCurrentTimeMilliseconds()
--     end
--     --print((playdate.getCurrentTimeMilliseconds() - self.interval2)*0.01)
-- end

-- function Gutter:enemyPosition()

--     if (playdate.getCurrentTimeMilliseconds() - self.interval2) * 0.01 > 10 then
--         OldGutterPositionX = self.sprite.x
--         OldGutterPositionY = self.sprite.y
--         self.actualGutterX = self.sprite.x
--         self.actualGutterY = self.sprite.y

--     end

-- end

-- function Gutter:setGutterCloseOrInTrigger()

--     self.playerCloseToEnemy = Enemy:isEnemyClose()
--     self.chasingDistanceTrigger = Enemy:isEnemyInTrigger()
-- end

-- function Gutter:changeState()
--     --print(self.playerCloseToEnemy, self.chasingDistanceTrigger)
--     if self.playerCloseToEnemy == true and self.chasingDistanceTrigger == false then
--         --self.directionChasing = "animationRotate"
--         --pd.timer.performAfterDelay(2200, function()
--         if self.playerCloseToEnemy == true and self.chasingDistanceTrigger == false then
--             self.bowState = self.GutterState.ShakeState
--             self.canTransit = true
--             --print("gutterShake")
--         end
--         --end)
--     elseif self.playerCloseToEnemy == false and self.chasingDistanceTrigger == false then

--         --self.directionChasing = "animationRotate"
--         pd.timer.performAfterDelay(2200, function()
--             if self.playerCloseToEnemy == false and self.chasingDistanceTrigger == false then
--                 self.bowState = self.GutterState.IdleState
--                 self.canTransit = true

--             end
--         end)

--     elseif self.chasingDistanceTrigger == true and self.canTransit == true then
--         if self.chaseValue > 60 then
--             self.bowState = self.GutterState.ChaseState
--             -- print("gutterShake")
--             -- elseif playerIsDead == true then
--             --     self.bowState = self.GutterState.PlayerIsDeadState
--             --     self.canTransit = false
--             self.canTransit = false
--         end
--     end
-- end

-- function Gutter:changeAnimation()
--     if (self.bowState == self.GutterState.IdleState) then
--         self.sprite:setCenter(0.5, 0.7)
--         self.currentAnimation = self.animationIdle
--     elseif (self.bowState == self.GutterState.ShakeState) then
--         self.sprite:setCenter(0.5, 0.7)
--         --pd.timer.performAfterDelay(2000, function()
--         self.currentAnimation = self.animationShake

--         --end)
--     elseif (self.bowState == self.GutterState.ChaseState) then
--         self.sprite:setCenter(0.5, 0.5)
--         if self.directionChasing == "animationChaseUpRight" then
--             self.currentAnimation = self.animationChaseUpRight

--         elseif self.directionChasing == "animationChaseUpLeft" then
--             self.currentAnimation = self.animationChaseUpLeft

--         elseif self.directionChasing == "animationChaseDownRight" then
--             self.currentAnimation = self.animationChaseDownRight

--         elseif self.directionChasing == "animationChaseDownLeft" then
--             self.currentAnimation = self.animationChaseDownLeft

--         elseif self.directionChasing == "animationChaseLeft" then
--             self.currentAnimation = self.animationChaseDownLeft

--         elseif self.directionChasing == "animationChaseRight" then
--             self.currentAnimation = self.animationChaseDownRight

--         elseif self.directionChasing == "animationChaseUp" then
--             self.currentAnimation = self.animationChaseUp

--         elseif self.directionChasing == "animationChaseDown" then
--             self.currentAnimation = self.animationChaseDown

--         elseif self.directionChasing == "animationRotate" then
--             self.currentAnimation = self.animationRotate

--         end
--         -- elseif (self.bowState == self.GutterState.PlayerIsDeadState) then

--     end
-- end

-- function Gutter:moving()

--     if self.chasingDistanceTrigger == true then
--         self.enemyChasingDistance = 150

--         if self.bowState == self.GutterState.ChaseState and self.playerIsDead == false then
--             moved = false

--             if playerPositionX < self.sprite.x and playerPositionY < self.sprite.y + 2 and
--                 playerPositionY > self.sprite.y -
--                 2 and
--                 self.gutterIsInTheSamePositionAsPlayer == false then -- player is left

--                 self.sprite:moveBy(-self.speed, 0) -- player left
--                 self.directionChasing = "animationChaseLeft"
--                 movingDirectionForTail = "left"


--             elseif playerPositionX > self.sprite.x and playerPositionY < self.sprite.y + 2 and
--                 playerPositionY > self.sprite.y - 2 and
--                 self.gutterIsInTheSamePositionAsPlayer == false then -- player is right

--                 self.sprite:moveBy(self.speed, 0) -- player left
--                 self.directionChasing = "animationChaseRight"
--                 movingDirectionForTail = "right"


--             elseif playerPositionX < self.sprite.x + 2 and playerPositionX > self.sprite.x - 2 and
--                 playerPositionY < self.sprite.y and
--                 self.gutterIsInTheSamePositionAsPlayer == false then -- player is up

--                 self.sprite:moveBy(0, -self.speed)
--                 -- player left
--                 self.directionChasing = "animationChaseUp"
--                 movingDirectionForTail = "up"


--             elseif playerPositionX < self.sprite.x + 2 and playerPositionX > self.sprite.x - 2 and
--                 playerPositionY > self.sprite.y and
--                 self.gutterIsInTheSamePositionAsPlayer == false then -- player is down

--                 self.sprite:moveBy(0, self.speed)
--                 self.directionChasing = "animationChaseDown"
--                 movingDirectionForTail = "down"

--             elseif playerPositionX < self.sprite.x and playerPositionY < self.sprite.y and
--                 self.gutterIsInTheSamePositionAsPlayer == false then -- player left up
--                 if self.randomValue < 10 then
--                     self.sprite:moveBy(0, -self.speed)
--                 else
--                     self.sprite:moveBy(-self.speed, 0)
--                 end
--                 self.directionChasing = "animationChaseUpLeft"

--                 movingDirectionForTail = "upleft"

--             elseif playerPositionX < self.sprite.x and playerPositionY > self.sprite.y and
--                 self.gutterIsInTheSamePositionAsPlayer == false then -- player left down
--                 if self.randomValue < 10 then
--                     self.sprite:moveBy(0, self.speed)
--                 else
--                     self.sprite:moveBy(-self.speed, 0)
--                 end
--                 self.directionChasing = "animationChaseDownLeft"
--                 movingDirectionForTail = "downleft"


--             elseif playerPositionX > self.sprite.x and playerPositionY < self.sprite.y and
--                 self.gutterIsInTheSamePositionAsPlayer == false then -- player right up
--                 if self.randomValue < 10 then
--                     self.sprite:moveBy(self.speed, 0)
--                 else
--                     self.sprite:moveBy(0, -self.speed)
--                 end
--                 self.directionChasing = "animationChaseUpRight"
--                 movingDirectionForTail = "upright"

--             elseif playerPositionX > self.sprite.x and playerPositionY > self.sprite.y and
--                 self.gutterIsInTheSamePositionAsPlayer == false then -- player is right down ;
--                 if self.randomValue < 10 then
--                     self.sprite:moveBy(self.speed, 0) -- player right down
--                 else
--                     self.sprite:moveBy(0, self.speed)
--                 end
--                 self.directionChasing = "animationChaseDownRight"
--                 movingDirectionForTail = "downright"


--             elseif self.gutterIsInTheSamePositionAsPlayer == true then -- player is in the same spot

--                 --print("rotaterotate")
--                 self.sprite:moveBy(0, 0) -- player left
--                 self.directionChasing = "animationRotate"


--             end

--         elseif self.bowState == self.GutterState.ChaseState and
--             self.playerIsDead == true then

--             if moved == false then

--                 self.movingAfterDeath(self)
--             end

--             if moved == true then
--                 -- local randomNumberDirection = math.random(1,2)
--                 --if randomNumberDirection == 2 then
--                 self.movingTriumph(self)
--                 --end
--             end




--         elseif self.bowState == self.GutterState.ChaseState and self.chasingDistanceTrigger == false and
--             self.playerIsDead == false then
--             self.sprite:moveBy(0, 0)
--             self.directionChasing = "animationRotate"

--         else
--             --self.sprite:setCollideRect(6, 6, 34, 34)
--             self.enemyChasingDistance = self.basicChasingValue

--         end
--         if self.playerIsDead == false then
--             deathIterator0 = 15
--             deathIterator1 = 20
--             deathIterator2 = 20
--             deathIterator3 = 20
--             deathIterator4 = 20
--         end
--     end

-- end

-- function Gutter:tailPosition()
--     for k, v in ipairs(self.tail) do
--         local x, y = v[1], v[2] -- k 0.0        --0.0
--         v[1], v[2] = OldGutterPositionX, OldGutterPositionY -- k 100,100    k 0, 0
--         OldGutterPositionX, OldGutterPositionY = x, y -- old 0.0      k


--     end
-- end

-- function Gutter:tailMoving()
--     for k, v in ipairs(self.tailSpriteTable) do
--         --if math.abs(self.actualGutterX - self.sprite.x) > 5 then
--             self.tailSpriteTable[k]:moveTo(self.tail[k][1], self.tail[k][2])
--             self.tailSpriteTable[k]:add()
--             self.tailSpriteTable[k]:changeAnimation()
--         --end

--     end
--     print(math.abs(self.actualGutterX - self.sprite.x))
-- end

-- function Gutter:isInTheSamePosition()
--     if math.abs(self.sprite.x - playerPositionX) < 5 and math.abs(self.sprite.y - playerPositionY) < 5 then
--         self.gutterIsInTheSamePositionAsPlayer = true
--     else
--         self.gutterIsInTheSamePositionAsPlayer = false
--     end
-- end

-- function Gutter:changeSpriteCollisionDependingOnState()
--     if self.bowState == self.GutterState.ChaseState and self.playerIsDead == false then
--         self.sprite:setCollideRect(0, 0, 20, 20)
--     elseif self.bowState == self.GutterState.ShakeFastState and self.playerIsDead == true then
--         self.sprite:setCollideRect(-12, -20, 64, 64)
--     elseif self.playerIsDead == true and self.bowState == self.GutterState.ChaseState then
--         self.sprite:setCollideRect(-12, -20, 64, 64)
--     elseif self.playerIsDead == true and self.bowState ~= self.GutterState.IdleState then
--         self.sprite:setCollideRect(6, 0, 32, 38)
--     end
-- end

-- function Gutter:setPlayerPosition()
--     playerPositionX = Kosmonaut:playerPositionX()
--     playerPositionY = Kosmonaut:playerPositionY()
-- end

-- function Gutter:returnEnemyValueX()
--     return self.enemyValueX
-- end

-- function Gutter:returnEnemyValueY()
--     return self.enemyValueY
-- end

-- function Gutter:returnEnemyChasingDistance()
--     return enemyChasingDistance
-- end

-- function Gutter:returnEnemyTriggerDistance()
--     return enemyTriggerDistance
-- end

-- function Gutter:returnDistanceToPlayerX()
--     return distanceX
-- end

-- function Gutter:returnDistanceToPlayerY()
--     return distanceY
-- end

-- function Gutter:setPlayerIsDead()
--     self.playerIsDead = Kosmonaut:returnPlayerIsDead()

-- end

-- function Gutter:movingAfterDeath()
--     if playerPositionX < self.sprite.x and playerPositionY < self.sprite.y + 2 and
--         playerPositionY > self.sprite.y - 2 and
--         self.gutterIsInTheSamePositionAsPlayer == false then -- player is left

--         self.sprite:moveBy(-self.movedSpeed, 0) -- player left
--         self.directionChasing = "animationChaseLeft"



--     elseif playerPositionX > self.sprite.x and playerPositionY < self.sprite.y + 2 and
--         playerPositionY > self.sprite.y - 2 and
--         self.gutterIsInTheSamePositionAsPlayer == false then -- player is right

--         self.sprite:moveBy(self.movedSpeed, 0) -- player left
--         self.directionChasing = "animationChaseRight"

--     elseif playerPositionX < self.sprite.x + 2 and playerPositionX > self.sprite.x - 2 and
--         playerPositionY < self.sprite.y and
--         self.gutterIsInTheSamePositionAsPlayer == false then -- player is up
--         self.sprite:moveBy(0, -self.movedSpeed)
--         self.directionChasing = "animationChaseUp"

--     elseif playerPositionX < self.sprite.x + 2 and playerPositionX > self.sprite.x - 2 and
--         playerPositionY > self.sprite.y and
--         self.gutterIsInTheSamePositionAsPlayer == false then -- player is down
--         self.sprite:moveBy(0, self.movedSpeed)
--         self.directionChasing = "animationChaseDown"

--     elseif playerPositionX < self.sprite.x and playerPositionY < self.sprite.y and
--         self.gutterIsInTheSamePositionAsPlayer == false then -- player left up
--         self.sprite:moveBy(-self.movedSpeed, -self.movedSpeed)
--         self.directionChasing = "animationChaseUpLeft"

--     elseif playerPositionX < self.sprite.x and playerPositionY > self.sprite.y and
--         self.gutterIsInTheSamePositionAsPlayer == false then -- player left down
--         self.sprite:moveBy(-self.movedSpeed, self.movedSpeed)
--         self.directionChasing = "animationChaseDownLeft"

--     elseif playerPositionX > self.sprite.x and playerPositionY < self.sprite.y and
--         self.gutterIsInTheSamePositionAsPlayer == false then -- player right up
--         self.sprite:moveBy(self.movedSpeed, -self.movedSpeed)
--         self.directionChasing = "animationChaseUpRight"

--     elseif playerPositionX > self.sprite.x and playerPositionY > self.sprite.y and
--         self.gutterIsInTheSamePositionAsPlayer == false then -- player is right down ;
--         self.sprite:moveBy(self.movedSpeed, self.movedSpeed) -- player right down
--         self.directionChasing = "animationChaseDownRight"

--     elseif self.gutterIsInTheSamePositionAsPlayer == true then
--         self.directionChasing = "animationChaseDownRight"
--         moved = true
--     end
-- end

-- function Gutter:movingTriumph()
--     if self.valueX < 40 and self.valueY < 40 then
--         self.triumphSpeed = self.speed * 2
--         if deathIterator0 > 0 then
--             self.sprite:moveBy(self.triumphSpeed, 0.5)
--             deathIterator0 -= 1

--         elseif deathIterator1 > 0 then
--             self.sprite:moveBy(-self.triumphSpeed, -self.triumphSpeed)
--             deathIterator1 -= 1
--         elseif deathIterator2 > 0 then
--             self.sprite:moveBy(-self.triumphSpeed, self.triumphSpeed)
--             deathIterator2 -= 1
--         elseif deathIterator3 > 0 then
--             self.sprite:moveBy(self.triumphSpeed, self.triumphSpeed)
--             deathIterator3 -= 1
--         elseif deathIterator4 > 0 then
--             self.sprite:moveBy(self.triumphSpeed, -self.triumphSpeed)
--             deathIterator4 -= 1
--         elseif deathIterator4 == 0 and deathIterator3 == 0 and deathIterator2 == 0 and deathIterator1 == 0 then
--             deathIterator1 = 20
--             deathIterator2 = 20
--             deathIterator3 = 20
--             deathIterator4 = 20
--         end
--     end
-- end

-- function Gutter:removeForSpotlight()
--     if (self.playerIsDead == true and self.valueX > 30) or (self.playerIsDead == true and self.valueY > 30) then
--         self.sprite:remove()
--         for k, v in ipairs(self.tailSpriteTable) do
--             self.tailSpriteTable[k]:removeForSpotlight()
--         end
--         self.blockTailMovement = true

--     else

--         self.sprite:add()
--         self.blockTailMovement = false

--     end
-- end

-- function Gutter:waitBeforeChase()
--     if self.valueX < self.enemyChasingDistance and self.valueY < self.enemyChasingDistance and
--         self.bowState ~= self.GutterState.ChaseState then
--         self.chaseValue += (playdate.getCurrentTimeMilliseconds() - self.timerStamp) * 0.001
--         self.currentAnimation = self.animationShakeFast

--     else
--         self.timerStamp = playdate.getCurrentTimeMilliseconds()
--         self.chaseValue = 0
--     end
-- end

-- function Gutter:calculateDistanceFromPlayer() 
--     self.valueX = math.abs(playerPositionX - self.sprite.x) -- calculating distance x between player and enemy
--     self.valueY = math.abs(playerPositionY - self.sprite.y) -- calculating distance y between player and enemy
-- end
