import "CoreLibs/timer"
import "CoreLibs/sprites"
import "lua/spriteanimation"
import "lua/enemyScripts/enemy"
import "lua/screens/level"


local pd <const> = playdate
local gfx <const> = playdate.graphics

class('DandelionEnemy').extends()

function DandelionEnemy:init(x, y)
    -- ZMIENNE=============================================
    self.dandelionRandom = 0
    self.dandelionCounter = 0

    --OBRAZKI===============================================
    self.dandelion1 = gfx.sprite.new()
    self.dandelion1:setZIndex(10)
    self.dandelion1:moveTo(x, y)
    self.dandelion1:setCenter(0.5, 1)
    self.dandelion1:setCollideRect(10, 40, 30, 13)
    self.dandelion1:setTag(99)
    self.canShoot = false

    -- ANIMACJE ==============================================
    self.dandelionBurned = SpriteAnimation(self.dandelion1)
    self.dandelionBurned:addImage("images/assets/dandelion_burned")

    self.dandelionIdle1 = SpriteAnimation(self.dandelion1)
    self.dandelionIdle1:addImage("images/assets/dandelion")

    self.dandelionIdle2 = SpriteAnimation(self.dandelion1)
    self.dandelionIdle2:addImage("images/assets/dandelion2")

    self.dandelionIdle3 = SpriteAnimation(self.dandelion1)
    self.dandelionIdle3:addImage("images/assets/dandelion3")

    self.dandelionIdle4 = SpriteAnimation(self.dandelion1)
    self.dandelionIdle4:addImage("images/assets/dandelion")
    self.dandelionIdle4:addImage("images/assets/dandelion")

    self.dandelionIdle4:addImage("images/assets/dandelion3")
    -- STRZELANIE DANDELIONÓW, CHWILOWO OFF ==========================================
    self.dandelionShot1 = SpriteAnimation(self.dandelion1)
    self.dandelionShot1:addImage("images/assets/dandelionNoSpike1")

    self.dandelionShot2 = SpriteAnimation(self.dandelion1)
    self.dandelionShot2:addImage("images/assets/dandelionNoSpike2")

    self.dandelionShot3 = SpriteAnimation(self.dandelion1)
    self.dandelionShot3:addImage("images/assets/dandelionNoSpike3")
    self.animCounter = 1
    self.restCounter = 0
    ------------------------------------------------------------------------------------------------------------------
    self.currentAnimation1 = self.dandelionIdle1
    self.currentAnimation1:updateFrame()
    self.shootTimer = 1000
    self.isDangerous = true
    self.afterShot = false
    self.shootSpeed = 2

    self.burned = false

    self.spikeSprite1 = gfx.sprite.new(gfx.image.new("images/assets/spikeHorizontalLeft"))
    self.spikeSprite2 = gfx.sprite.new(gfx.image.new("images/assets/spikeHorizontalRight"))
    self.spikeSprite3 = gfx.sprite.new(gfx.image.new("images/assets/spikeVerticalUp"))
    self.spikeSprite4 = gfx.sprite.new(gfx.image.new("images/assets/spikeVerticalDown"))

    self.spikeSprite1:moveTo(self.dandelion1.x, self.dandelion1.y - 40)
    self.spikeSprite2:moveTo(self.dandelion1.x, self.dandelion1.y - 40)
    self.spikeSprite3:moveTo(self.dandelion1.x, self.dandelion1.y - 40)
    self.spikeSprite4:moveTo(self.dandelion1.x, self.dandelion1.y - 40)
    self.randomValue = 0

    self.spikeSprite1:setClipRect(0, 0, 400, 240)
    self.spikeSprite2:setClipRect(0, 0, 400, 240)
    self.spikeSprite3:setClipRect(0, 0, 400, 240)
    self.spikeSprite4:setClipRect(0, 0, 400, 240)

    self.spikeSprite1:setCollideRect(3, 2, 18, 2)
    self.spikeSprite2:setCollideRect(2, 2, 18, 2)
    self.spikeSprite3:setCollideRect(2, 3, 2, 18)
    self.spikeSprite4:setCollideRect(2, 3, 2, 18)

    self.spikeSprite1:setTag(30)
    self.spikeSprite2:setTag(30)
    self.spikeSprite3:setTag(30)
    self.spikeSprite4:setTag(30)

    self.shootSound = playdate.sound.sampleplayer.new("sounds/dandelionShoot")
    self.flesh = playdate.sound.fileplayer.new("sounds/flesh")

end

function DandelionEnemy:updateWork()

    self.checkSpike1Collision(self)
    self.checkSpike2Collision(self)
    self.checkSpike3Collision(self)
    self.checkSpike4Collision(self)

    self.randomValue = math.random(1, 5)
    self.changeZIndexDependingOnPlayer(self)
    self.currentAnimation1:updateFrame()
    self.animationRandomizer(self)
    self.playerIsDead = Kosmonaut:returnPlayerIsDead()
    self.removeIfPlayerDead(self)

    if self.canShoot == true then
        self.shoot(self)
    end

    self.whenBurned(self)

end

-- function DandelionEnemy:changeZIndexDependingOnPlayer2()
--     if Kosmonaut:playerPositionY() > self.dandelion1.y - 20 then
--         if self.shootTimer < 1505 then
--             self.dandelion1:setZIndex(6)
--             self.spikeSprite1:setZIndex(5)
--             self.spikeSprite2:setZIndex(5)
--             self.spikeSprite3:setZIndex(5)
--             self.spikeSprite4:setZIndex(5)
--         else
--             self.dandelion1:setZIndex(5)
--             self.spikeSprite1:setZIndex(6)
--             self.spikeSprite2:setZIndex(6)
--             self.spikeSprite3:setZIndex(6)
--             self.spikeSprite4:setZIndex(6)
--         end

--     else
--         if self.shootTimer < 1505 then
--             self.dandelion1:setZIndex(12)
--             self.spikeSprite1:setZIndex(11)
--             self.spikeSprite2:setZIndex(11)
--             self.spikeSprite3:setZIndex(11)
--             self.spikeSprite4:setZIndex(11)
--         elseif self.shootTimer > 1505 then
--             self.dandelion1:setZIndex(5)
--             self.spikeSprite1:setZIndex(6)
--             self.spikeSprite2:setZIndex(6)
--             self.spikeSprite3:setZIndex(6)
--             self.spikeSprite4:setZIndex(6)
--         end
--     end
-- end

function DandelionEnemy:animationRandomizer()

    if self.afterShot == false then
        if self.burned == false then
            self.dandelionCounter += self.animCounter

            if self.dandelionCounter > 35 then
                self.dandelionRandom = math.random(1, 100)

                self.dandelionCounter = 0
            end
            if self.shootTimer < 1500 then
                if self.dandelionRandom <= 10 then
                    self.currentAnimation1 = self.dandelionIdle3
                elseif self.dandelionRandom > 10 and self.dandelionRandom <= 65 then
                    self.currentAnimation1 = self.dandelionIdle1
                else
                    self.currentAnimation1 = self.dandelionIdle2
                end
            end
        end
    end
    if self.burned == true then
        self.currentAnimation1 = self.dandelionBurned


    end

end

function DandelionEnemy:removeIfPlayerDead()
    if self.playerIsDead == true then
        self.dandelion1:remove()
    end
end

function DandelionEnemy:shoot()
    if self.isDangerous == true then
        if self.burned == false then
            self.shootTimer += self.randomValue


            if self.shootTimer > 1200 and self.shootTimer < 1206 and self.fleshSoundBool == true then
                self.fleshSoundBool = false
                self.flesh:play()
                self.spikeSprite1:moveTo(self.spikeSprite1.x - 12, self.spikeSprite1.y)
                self.spikeSprite2:moveTo(self.spikeSprite2.x + 12, self.spikeSprite2.y)
                self.spikeSprite3:moveTo(self.spikeSprite3.x, self.spikeSprite3.y - 12)
                self.spikeSprite4:moveTo(self.spikeSprite4.x, self.spikeSprite4.y + 12)
                self.spikeSprite1:add()
                self.spikeSprite2:add()
                self.spikeSprite3:add()
                self.spikeSprite4:add()
            end
            if self.shootTimer > 1500 and self.shootTimer < 1505 and Kosmonaut:returnPlayerIsDead() == false and
                currentscreen.className == "Dandelions" then

                self.fleshSoundBool = true
                self.spikeSprite1:add()
                self.spikeSprite2:add()
                self.spikeSprite3:add()
                self.spikeSprite4:add()
                self.shootSound:play()
                --print("addding")

            end
            if self.shootTimer > 1500 then
                self.spikeSprite1:moveTo(self.spikeSprite1.x - self.shootSpeed, self.spikeSprite1.y)
                self.spikeSprite2:moveTo(self.spikeSprite2.x + self.shootSpeed, self.spikeSprite2.y)
                self.spikeSprite3:moveTo(self.spikeSprite3.x, self.spikeSprite3.y - self.shootSpeed)
                self.spikeSprite4:moveTo(self.spikeSprite4.x, self.spikeSprite4.y + self.shootSpeed)
                self.animCounter = 0
            end


            if self.shootTimer > 2000 then

                self.spikeReset(self)
                self.animCounter = 1

                self.canShoot = false
            end
            if self.shootTimer > 1100 then

                self.animCounter = 0
                self.currentAnimation1 = self.dandelionIdle4
            end
            if self.shootTimer > 1510 then
                self.currentAnimation1 = self.dandelionShot1
            end
            if self.shootTimer > 1540 and self.shootTimer < 2000 then
                self.currentAnimation1 = self.dandelionShot2
            end
            if self.shootTimer > 1570 and self.shootTimer < 2020 then
                self.currentAnimation1 = self.dandelionShot3
            end
        end


        if self:checkCollisionAt(self.spikeSprite1.x + 15, self.spikeSprite1.y) == false then
            self.spikeSprite1:remove()
        end

        if self:checkCollisionAt(self.spikeSprite2.x - 15, self.spikeSprite2.y) == false then
            self.spikeSprite2:remove()
        end
        if self:checkCollisionAt(self.spikeSprite3.x, self.spikeSprite3.y + 15) == false then
            self.spikeSprite3:remove()
        end
        if self:checkCollisionAt(self.spikeSprite4.x, self.spikeSprite4.y - 15) == false then
            self.spikeSprite4:remove()
        end


    end
end

function DandelionEnemy:checkCollisionAt(x, y)
    return currentscreen.levelcollisions:sample(x, y) == gfx.kColorBlack
end

function DandelionEnemy:checkSpike1Collision()

    local a, b, collision, length = self.spikeSprite1:checkCollisions(self.spikeSprite1.x, self.spikeSprite1.y)

    if length > 0 and collision[#collision].other:getTag() == (1) or self.burned == true then
        self.spikeSprite1:remove()
    end


end

function DandelionEnemy:checkSpike2Collision()

    local a, b, collision, length = self.spikeSprite2:checkCollisions(self.spikeSprite2.x, self.spikeSprite2.y)

    if length > 0 and collision[#collision].other:getTag() == (1) or self.burned == true then
        self.spikeSprite2:remove()
    end


end

function DandelionEnemy:checkSpike3Collision()

    local a, b, collision, length = self.spikeSprite3:checkCollisions(self.spikeSprite3.x, self.spikeSprite3.y)

    if length > 0 and collision[#collision].other:getTag() == (1) or self.burned == true then
        self.spikeSprite3:remove()
    end


end

function DandelionEnemy:checkSpike4Collision()

    local a, b, collision, length = self.spikeSprite4:checkCollisions(self.spikeSprite4.x, self.spikeSprite4.y)

    if length > 0 and collision[#collision].other:getTag() == (1) or self.burned == true then
        self.spikeSprite4:remove()
    end


end

function DandelionEnemy:removeSpikes()
    self.spikeSprite1:remove()
    self.spikeSprite2:remove()
    self.spikeSprite3:remove()
    self.spikeSprite4:remove()
    print("removing")
end

function DandelionEnemy:spikeReset()
    self.fleshSoundBool = true
    self.spikeSprite1:remove()
    self.spikeSprite2:remove()
    self.spikeSprite3:remove()
    self.spikeSprite4:remove()
    self.spikeSprite1:moveTo(self.dandelion1.x, self.dandelion1.y - 40)
    self.spikeSprite2:moveTo(self.dandelion1.x, self.dandelion1.y - 40)
    self.spikeSprite3:moveTo(self.dandelion1.x, self.dandelion1.y - 40)
    self.spikeSprite4:moveTo(self.dandelion1.x, self.dandelion1.y - 40)
end

function DandelionEnemy:whenBurned()
    if currentscreen.rover.canBurn == true then
        if math.abs(currentscreen.rover.spriteBase.x - self.dandelion1.x) < 20 and
            math.abs(currentscreen.rover.spriteBase.y - self.dandelion1.y) < 10 then
            self.burned = true
        end

        if math.abs(currentscreen.rover.spriteBase.x - self.dandelion1.x) < 10 and
            math.abs(currentscreen.rover.spriteBase.y - self.dandelion1.y) < 20 then
            self.burned = true
        end
    end
end

function DandelionEnemy:changeZIndexDependingOnPlayer()
    self.dandelion1:setZIndex(self.dandelion1.y - currentscreen.kosmonaut.posY - 20)
    self.spikeSprite1:setZIndex(self.dandelion1.y - currentscreen.kosmonaut.posY - 21)
    self.spikeSprite2:setZIndex(self.dandelion1.y - currentscreen.kosmonaut.posY - 21)
    self.spikeSprite3:setZIndex(self.dandelion1.y - currentscreen.kosmonaut.posY - 21)
    self.spikeSprite4:setZIndex(self.dandelion1.y - currentscreen.kosmonaut.posY - 21)
    -- if Kosmonaut:playerPositionY() > self.flower.y - 20 then
    -- else
    --     self.flower:setZIndex(currentscreen.kosmonaut.kosmonautSprite:getZIndex()+ 1)
    --     self.roots:setZIndex(currentscreen.kosmonaut.kosmonautSprite:getZIndex()+2)
    -- end

end
