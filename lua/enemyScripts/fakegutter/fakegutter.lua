import "CoreLibs/timer"
import "CoreLibs/sprites"
import "lua/spriteanimation"
import "lua/enemyScripts/gutter/tail"
import "lua/screens/level"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class('FakeGutter').extends()

function FakeGutter:init(x, y, targetPointX, targetPointY)

    self.sprite = gfx.sprite.new()
    self.sprite:moveTo(x, y)
    self.sprite:setZIndex(3)

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

    self.currentAnimation = self.animationChaseDownRight

    self.tail1 = Tail(44, 44)
    self.tail2 = Tail(54, 44)
    self.tail3 = Tail(64, 44)
    self.tail4 = Tail(74, 44)
    self.tail5 = Tail(84, 44)
    self.tail6 = Tail(94, 44)
    self.canUpdateFakeGutterPlains = true
    self.tailCounter = 0

    self.tailSpriteTable = { self.tail1, self.tail2, self.tail3,
        self.tail4, self.tail5, self.tail6 }
    for k, v in pairs(self.tailSpriteTable) do
        self.tailSpriteTable[k].tailSprite:setZIndex(2)
    end

    self.tailSpriteLength = 1

    self.m = 0
    self.n = 0

    self.currentAnimation:updateFrame()

    self.givenPositionX = targetPointX
    self.givenPositionY = targetPointY

    self.movingCounterPlains = 3
    self.movingCounterCemetery = 0
    self.movingCounterCargoEndRover = 0

    self.scenario = 1 
    self.canCount = true
    self.gutterMoveSound = playdate.sound.sampleplayer.new("sounds/gulp")
    self.gutterMoveSound:setVolume(0.05)
    self.cargoEndRoverDelayCounter = 0
end

function FakeGutter:updateWork()
    self.simpleCounter(self)
 
    if currentscreen == cargoendroverscreen then
        if self.n == 30 then
            self:movingHead()
            
        end
    else
        if self.m == 15 then
            self:movingHead()
            
        end
    end

    if currentscreen == cargoendroverscreen then
        self.cargoEndRoverDelayCounter += 1
    end

    self.currentAnimation:updateFrame()




end

function FakeGutter:movingHead()
    if currentscreen == cemeteryscreen and cemeteryscreen.playerWasHere == false and self.movingCounterCemetery < 60 then
        if self.canCount == true then
            self.movingCounterCemetery += 1
          
        end

       
        if self.scenario == 1 then
            if self.movingCounterCemetery > 0 and self.movingCounterCemetery < 8 then
                self.sprite:moveTo(self.sprite.x + 10, self.sprite.y)
                self.tailMoving(self)
                
            end

            if self.movingCounterCemetery > 7 and self.movingCounterCemetery < 10 then
                self.sprite:moveTo(self.sprite.x, self.sprite.y - 10)
                self.tailMoving(self)
               
            end
            if self.movingCounterCemetery > 9 and self.movingCounterCemetery < 15 then
                self.currentAnimation = self.animationChaseDownLeft
                
            end
            if self.movingCounterCemetery > 14 and self.movingCounterCemetery < 17 then
                self.currentAnimation = self.animationChaseDownRight
                self.sprite:moveTo(self.sprite.x + 10, self.sprite.y)
                self.tailMoving(self)
            end
            if self.movingCounterCemetery > 16 and self.movingCounterCemetery < 19 then
                self.currentAnimation = self.animationChaseDown
                self.sprite:moveTo(self.sprite.x, self.sprite.y + 10)
                self.tailMoving(self)
            end
            if self.movingCounterCemetery > 18 and self.movingCounterCemetery < 40 then
                self.currentAnimation = self.animationChaseDown
                self.sprite:moveTo(self.sprite.x + 10, self.sprite.y)
                self.tailMoving(self)
            end





            if self.movingCounterCemetery > 50 or currentscreen ~= cemeteryscreen then

                self.sprite:remove()
                for k, v in pairs(self.tailSpriteTable) do
                    self.tailSpriteTable[k].tailSprite:remove()
                   
                end
                cemeteryscreen.fakeGutterTable[0] = nil

            end
        end



        if self.scenario == 2 then
            if self.movingCounterCemetery < 6 then
                self.currentAnimation = self.animationChaseDownLeft
                self.sprite:moveTo(self.sprite.x - 10, self.sprite.y)
                self.tailMoving(self)
            end
            if self.movingCounterCemetery > 5 and self.movingCounterCemetery < 8 then
                self.currentAnimation = self.animationChaseDown
                self.sprite:moveTo(self.sprite.x, self.sprite.y + 10)
                self.tailMoving(self)
            end

            if self.movingCounterCemetery > 7 and self.movingCounterCemetery < 12 then
                self.currentAnimation = self.animationChaseDownRight
                self.sprite:moveTo(self.sprite.x + 10, self.sprite.y)
                self.tailMoving(self)
            end
            if self.movingCounterCemetery > 11 and self.movingCounterCemetery < 13 then
                self.currentAnimation = self.animationChaseDownRight
                self.sprite:moveTo(self.sprite.x, self.sprite.y - 10)
                self.tailMoving(self)
            end
            if self.movingCounterCemetery > 12 and self.movingCounterCemetery < 15 then
                self.currentAnimation = self.animationChaseDownRight
                self.sprite:moveTo(self.sprite.x + 10, self.sprite.y)
                self.tailMoving(self)
            end
            if self.movingCounterCemetery > 14 and self.movingCounterCemetery < 17 then
                self.currentAnimation = self.animationChaseDownRight
                self.sprite:moveTo(self.sprite.x, self.sprite.y - 10)
                self.tailMoving(self)
            end
            if self.movingCounterCemetery > 16 and self.movingCounterCemetery < 27 then
                self.currentAnimation = self.animationChaseDownRight
                self.sprite:moveTo(self.sprite.x + 10, self.sprite.y)
                self.tailMoving(self)
            end
            if self.movingCounterCemetery > 26 and self.movingCounterCemetery < 28 then
                self.currentAnimation = self.animationChaseDownRight
                self.sprite:moveTo(self.sprite.x, self.sprite.y + 10)
                self.tailMoving(self)
            end
            if self.movingCounterCemetery > 27 and self.movingCounterCemetery < 50 then
                self.currentAnimation = self.animationChaseDownRight
                self.sprite:moveTo(self.sprite.x + 10, self.sprite.y)
                self.tailMoving(self)
            end

            if self.movingCounterCemetery > 50 or currentscreen ~= cemeteryscreen then
                self.movingCounterCemetery = 51
                self.canCount = false
                self.canUpdateFakeGutter = false
                for k, v in pairs(self.tailSpriteTable) do
                    self.tailSpriteTable[k].tailSprite:remove()
                    
                end
                self.sprite:remove()
                cemeteryscreen.fakeGutterTable[1] = nil
            end
        end

    end


    if currentscreen == plainsscreen then
        if plainsscreen.playerWasStopped == true and plainsscreen.playerLeftBeforePlayerWentIntoColliderBool == false then
            self.movingCounterPlains += 1

        end

        if self.movingCounterPlains < 4 then
            self.currentAnimation = self.animationChaseDown
        end

        if self.movingCounterPlains > 3 and self.movingCounterPlains < 5 then
            self.currentAnimation = self.animationChaseDownRight
            self.sprite:moveTo(self.sprite.x - 10, self.sprite.y)
            self.tailMoving(self)
        end
        if self.movingCounterPlains > 4 and self.movingCounterPlains < 13 then
            self.currentAnimation = self.animationChaseDown
            self.sprite:moveTo(self.sprite.x, self.sprite.y - 10)
            self.tailMoving(self)
        end
        if self.movingCounterPlains > 12 and self.movingCounterPlains < 14 then
            self.currentAnimation = self.animationChaseDownLeft
            self.sprite:moveTo(self.sprite.x - 10, self.sprite.y)
            self.tailMoving(self)
        end
        if self.movingCounterPlains > 13 and self.movingCounterPlains < 23 then
            self.currentAnimation = self.animationChaseDownRight
            self.sprite:moveTo(self.sprite.x, self.sprite.y - 10)
            self.tailMoving(self)
        end
        if self.movingCounterPlains > 23 then

            self.sprite:remove()

            for k, v in pairs(self.tailSpriteTable) do
                self.tailSpriteTable[k].tailSprite:remove()
            end

            self.sprite:moveTo(340, 50)
            plainsscreen.fakeGutterTable[0] = nil
            
        end

    else
        self.movingCounterPlains = 0

    end

    if currentscreen == cargoendroverscreen then

        print(self.cargoEndRoverDelayCounter)
        if self.endScenario == "left" then
            --print("left scenario")
            self.tailMoving(self)
            self.randomValue = math.random(1, 20)
            if self.randomValue < 4 then
                self.sprite:moveTo(self.sprite.x, self.sprite.y + 10)
            end

            if self.randomValue > 16 then
                self.sprite:moveTo(self.sprite.x, self.sprite.y - 10)
            end

            if self.randomValue > 3 and self.randomValue < 17 then
                self.sprite:moveTo(self.sprite.x + 10, self.sprite.y)
            end
        end

        if self.endScenario == "right" then
            self.tailMoving(self)
            self.randomValue = math.random(1, 20)
            if self.randomValue < 4 then
                self.sprite:moveTo(self.sprite.x, self.sprite.y + 10)
            end

            if self.randomValue > 16 then
                self.sprite:moveTo(self.sprite.x, self.sprite.y - 10)
            end

            if self.randomValue > 3 and self.randomValue < 17 then
                self.sprite:moveTo(self.sprite.x - 10, self.sprite.y)
            end
        end

        if self.endScenario == "down" and self.cargoEndRoverDelayCounter > 40 then
            self.tailMoving(self)
            self.randomValue = math.random(1, 20)
            if self.randomValue < 4 then
                self.sprite:moveTo(self.sprite.x + 10, self.sprite.y)
            end

            if self.randomValue > 16 then
                self.sprite:moveTo(self.sprite.x - 10, self.sprite.y)
            end

            if self.randomValue > 3 and self.randomValue < 17 then
                self.sprite:moveTo(self.sprite.x, self.sprite.y - 10)
            end
        end

        if self.endScenario == "up" then
            self.tailMoving(self)
            self.randomValue = math.random(1, 20)
            if self.randomValue < 4 then
                self.sprite:moveTo(self.sprite.x + 10, self.sprite.y)
            end

            if self.randomValue > 16 then
                self.sprite:moveTo(self.sprite.x - 10, self.sprite.y)
            end

            if self.randomValue > 3 and self.randomValue < 17 then
                self.sprite:moveTo(self.sprite.x, self.sprite.y + 10)
            end
        end



    end


end



function FakeGutter:tailMoving()
    self.tailCounter += 1
    if self.tailCounter > 0 then
        self.tailSpriteTable[self.tailSpriteLength]:moveTo(self.sprite.x, self.sprite.y)
        self.gutterMoveSound:play()
        self.tailSpriteTable[self.tailSpriteLength]:add()
      
        self.tailSpriteLength += 1
        if self.tailSpriteLength > 6 then
            self.tailSpriteLength = 1
        end
        self.tailCounter = 0
    end
end

function FakeGutter:simpleCounter() --simple counter to determine how often gutter changes direction following player
    self.m += 1

    if self.m > 15 then
        self.m = 0
    end

    self.n += 1

    if self.n > 30 then
        self.n = 0
    end


end

function FakeGutter:checkCollsionsForHead()
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

function FakeGutter:setTailStartPosition(a, b, c, d, e, f)

    self.tailSpriteTable[1].tailSprite:moveTo(f, self.sprite.y)
    self.tailSpriteTable[1].tailSprite:add()
    self.tailSpriteTable[2].tailSprite:moveTo(e, self.sprite.y)
    self.tailSpriteTable[2].tailSprite:add()
    self.tailSpriteTable[3].tailSprite:moveTo(d, self.sprite.y)
    self.tailSpriteTable[3].tailSprite:add()
    self.tailSpriteTable[4].tailSprite:moveTo(c, self.sprite.y)
    self.tailSpriteTable[4].tailSprite:add()
    self.tailSpriteTable[5].tailSprite:moveTo(b, self.sprite.y)
    self.tailSpriteTable[5].tailSprite:add()
    self.tailSpriteTable[6].tailSprite:moveTo(a, self.sprite.y)
    self.tailSpriteTable[6].tailSprite:add()

end

function FakeGutter:restart()
    self.m = 0
    self.tailCounter = 0
    self.tailSpriteLength = 1
    self.movingCounterPlains = 0
    self.movingCounterCemetery = 0

    self.currentAnimation = self.animationChaseDownRight

end
