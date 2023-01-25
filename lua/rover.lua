import "CoreLibs/timer"
import "CoreLibs/sprites"
import "lua/spriteanimation"
import "lua/enemyScripts/gutter/tail"
import "lua/screens/level"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class('Rover').extends()

function Rover:init(x, y, targetPointX, targetPointY)

    self.spriteBase = gfx.sprite.new()
    self.spriteBase:moveTo(x, y)
    self.spriteBase:setZIndex(5)
    self.spriteBase:setScale(2)
    self.spriteBase:setTag(18)
    self.spriteBase:setCollideRect(0, 0, 30, 30)

    self.turret = gfx.sprite.new()
    self.turret:moveTo(x, y)
    self.turret:setZIndex(6)
    self.turret:setScale(2)
    self.turret:setCenter(0.5, 0)

    self.burst = gfx.sprite.new()
    self.burst:moveTo(x, y)
    self.burst:setZIndex(20)
    self.burst:setCenter(0.5, 1)
    self.burst:setScale(0.4)
    self.burst:setTag(45)


    self.turretDown = SpriteAnimation(self.turret)
    self.turretDown:addImage("images/rover/turret_down")

    self.turretRight = SpriteAnimation(self.turret)
    self.turretRight:addImage("images/rover/turret_right")

    self.turretUp = SpriteAnimation(self.turret)
    self.turretUp:addImage("images/rover/turret_up")

    self.turretLeft = SpriteAnimation(self.turret)
    self.turretLeft:addImage("images/rover/turret_left")
    self.tX = targetPointX
    self.tY = targetPointY


    self.roverSide = SpriteAnimation(self.spriteBase)
    self.roverSide:addImage("images/rover/base_side")
    self.roverSide:addImage("images/rover/base_side")

    self.roverFront = SpriteAnimation(self.spriteBase)
    self.roverFront:addImage("images/rover/base_front")
    self.roverFront:addImage("images/rover/base_front")

    self.driveSide = SpriteAnimation(self.spriteBase)
    self.driveSide:addImage("images/rover/base_side")
    self.driveSide:addImage("images/rover/base_side_walk")

    self.driveFront = SpriteAnimation(self.spriteBase)
    self.driveFront:addImage("images/rover/base_front")
    self.driveFront:addImage("images/rover/base_front_walk")

    self.driveFront = SpriteAnimation(self.spriteBase)
    self.driveFront:addImage("images/rover/base_front")
    self.driveFront:addImage("images/rover/base_front_walk")


    self.burstAnim = SpriteAnimation(self.burst)
    self.burstAnim:addImage("images/rover/burst1")
    self.burstAnim:addImage("images/rover/burst2")
    self.burstAnim:addImage("images/rover/burst3")

    self.currentAnimationBurst = self.burstAnim
    self.currentAnimationBurst:updateFrame()

    self.burstSound = playdate.sound.fileplayer.new("sounds/burstSound")
    self.dangerSound = playdate.sound.fileplayer.new("sounds/danger")
    self.dangerSound:setVolume(0.3)

    self.offShieldSound = playdate.sound.fileplayer.new("sounds/beep1")
    self.hitFromGutter = playdate.sound.fileplayer.new("sounds/metalImpact")

    self.currentAnimationTurret = self.turretDown
    self.currentAnimationTurret:updateFrame()

    self.driveSound = playdate.sound.fileplayer.new("sounds/roverRide")
    self.driveSound:setVolume(0.7)

    self.shootPrepareSound = playdate.sound.fileplayer.new("sounds/machineGun")
    self.shootPrepareSound:setVolume(0.1)
    self.spriteBase.collisionResponse = "overlap"

    self.goUp = false
    self.goDown = false
    self.goLeft = false
    self.goRight = false
    self.randomMovement = 1


    self.leftPath = false
    self.rightPath = false
    self.upPath = false
    self.downPath = false

    self.canBurn = false
    self.baseTurretRotation = self.turretDown
    self.targetsDown = false
    self.currentHighDistanceX = 999
    self.currentHighDistanceY = 999
    self.currentHighDistance = 999
    self.speed = 1
    self.burnTime = 0
    self.random = 1
    self.movingCounter = 0
    self.x = 1
    self.y = 1
    self.rCounter = 0
    self.canBurnFuel = 0
    self.breakCounter = 0
    self.restFromHit = false

    self.pushDown = false
    self.pushUp = false
    self.pushLeft = false
    self.pushRight = false
    self.col = false
    self.roverAppearCounter = 0

    self.crack1 = gfx.sprite.new(gfx.image.new('images/cutscenes/cutscene_hvsar_pov/ui_crack'))
    self.crack1:moveTo(150, 50)
    self.crack1:setZIndex(1111)

    self.crack2 = gfx.sprite.new(gfx.image.new('images/cutscenes/cutscene_hvsar_pov/ui_crack'))
    self.crack2:moveTo(350, 210)
    self.crack2:setZIndex(1111)

    self.crack3 = gfx.sprite.new(gfx.image.new('images/cutscenes/cutscene_hvsar_pov/ui_crack'))
    self.crack3:moveTo(75, 170)
    self.crack3:setZIndex(1111)

    self.glassSound = playdate.sound.fileplayer.new("sounds/glassSound")

    self.canBurnFalseDelay = 0


end

function Rover:updateInput()
    -- if playdate.buttonIsPressed(playdate.kButtonA) then
    --     self.canBurn = true
    --     self.burstSound:play()
    -- else
    --     self.canBurn = false
    -- end

    if self.randomMovement == 1 then
        if self.goLeft == true and self.leftPath == true then
            self.currentAnimation = self.driveSide
            self.currentAnimationTurret = self.turretLeft
            self.turret:setCenter(0.7, 0.7)
            self.spriteBase:moveTo(self.spriteBase.x - self.speed, self.spriteBase.y)
            self.driveSound:play()
            self.burst:setRotation(270)
            self.burst:setCollideRect(5, 5, 40, 25)

        elseif self.goRight == true and self.rightPath == true then
            self.currentAnimation = self.driveSide
            self.currentAnimationTurret = self.turretRight
            self.turret:setCenter(0.3, 0.7)
            self.spriteBase:moveTo(self.spriteBase.x + self.speed, self.spriteBase.y)
            self.driveSound:play()
            self.burst:setRotation(90)
            self.burst:setCollideRect(15, 5, 40, 25)


        elseif self.goUp == true and self.upPath == true then
            self.currentAnimation = self.driveFront
            self.currentAnimationTurret = self.turretUp
            self.turret:setCenter(0.5, 0.8)
            self.spriteBase:moveTo(self.spriteBase.x, self.spriteBase.y - self.speed)
            self.driveSound:play()
            self.burst:setRotation(1)
            self.burst:setCollideRect(8, -2, 25, 40)


        elseif self.goDown == true and self.downPath == true then
            self.currentAnimation = self.driveFront
            self.currentAnimationTurret = self.turretDown
            self.turret:setCenter(0.5, 0.3)
            self.spriteBase:moveTo(self.spriteBase.x, self.spriteBase.y + self.speed)
            self.driveSound:play()
            self.burst:setRotation(180)
            self.burst:setCollideRect(8, 10, 25, 40)
        else
            if self.currentAnimationTurret == self.turretUp or self.currentAnimationTurret == self.turretDown then
                self.currentAnimation = self.roverFront
            else
                self.currentAnimation = self.roverSide
            end
            --self.currentAnimationTurret = self.baseTurretRotation
            self.turret:setCenter(0.5, 0.3)
            if self.currentAnimationTurret == self.turretDown then
                self.burst:setRotation(180)
                self.turret:setCenter(0.5, 0.3)
            elseif self.currentAnimationTurret == self.turretUp then
                self.turret:setCenter(0.5, 0.8)
                self.burst:setRotation(1)
            elseif self.currentAnimationTurret == self.turretLeft then
                self.turret:setCenter(0.7, 0.7)
                self.burst:setRotation(270)
            elseif self.currentAnimationTurret == self.turretRight then
                self.turret:setCenter(0.3, 0.7)
                self.burst:setRotation(90)

            end
        end
    end
    self.burst:moveTo(self.spriteBase.x, self.spriteBase.y)

end

function Rover:updateWork()
    self.collideWithGutters(self)
    --print(self.pushDown, "DOWN--", self.pushUp, "UP--", self.pushLeft, "LEFT--", self.pushRight, "RIGHT--")
    print(self.breakCounter)
    self.updateInput(self)
    self.currentAnimation:updateFrame()
    self.currentAnimationTurret:updateFrame()
    if self.canBurn == true then
        self.burst:add()
        self.burstSound:play()
        self.currentAnimationBurst:updateFrame()
    else
        self.burst:remove()
        self.burstSound:stop()
    end


    if currentscreen.kosmonaut ~= nil and currentscreen.kosmonaut.isRover == false then
        self.levelCollisions = currentscreen.levelcollisions
        self.mappingCollision(self)
        --print(self.canBurnFuel, "canBurnFuel")
        if self.canBurnFuel == 0 then
            self.findNewTarget(self)
        end

        self.rCounter += 1
        if self.rCounter > 5 then
            self.random = math.random(1, 100)
            self.rCounter = 0
        end

        self.followToPoint(self)
        self.turret:moveTo(self.spriteBase.x, self.spriteBase.y)




        if self.canBurnFuel > 0 then
            self.canBurn = true
        else
            self.canBurn = false
        end
        if self.canBurnFuel > 0 then
            self.canBurnFuel -= 1
        end
        self.changeZIndexDependingOnPlayer(self)
        self.speed = 1
    elseif currentscreen.kosmonaut ~= nil and currentscreen.kosmonaut.isRover == true then
        self.speed = 0
        self.whenKosmonautIsRover(self)
        self.rightPath = true
        self.leftPath = true
        self.upPath = true
        self.downPath = true

    end
end

function Rover:followToPoint()
    ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    local x = self.spriteBase.x
    local y = self.spriteBase.y
    --print(self.goDown, self.goUp, self.goRight, self.goLeft, "down up right left")
    if x < self.tX and self.rightPath then
        self.goRight = true
    else
        self.goRight = false
    end
    if x > self.tX and self.leftPath then
        self.goLeft = true
    else
        self.goLeft = false
    end
    if y < self.tY and self.downPath then
        self.goDown = true
    else
        self.goDown = false
    end
    if y > self.tY and self.upPath then
        self.goUp = true
    else
        self.goUp = false
    end


    if x < 5 then
        self.goRight = true
        print("aa")
    end
    if x > 395 then
        self.goLeft = true
        print("bb")
    end
    if y < 5 then
        self.goDown = true
        print("cc")
    end
    if y > 235 then
        self.goUp = true
        print("dd")
    end

end

function Rover:checkCollisionAt(x, y)
    return self.levelCollisions:sample(x, y) == gfx.kColorBlack

end

function Rover:mappingCollision()

    if self:checkCollisionAt(self.spriteBase.x - 3, self.spriteBase.y) or self.spriteBase.x > 395 then
        self.leftPath = true
    else
        self.leftPath = false
    end

    if self:checkCollisionAt(self.spriteBase.x + 3, self.spriteBase.y) or self.spriteBase.x < 5 then
        self.rightPath = true
    else
        self.rightPath = false
    end

    if self:checkCollisionAt(self.spriteBase.x, self.spriteBase.y - 3) or self.spriteBase.y > 235 then
        self.upPath = true
    else
        self.upPath = false
    end

    if self:checkCollisionAt(self.spriteBase.x, self.spriteBase.y + 3) or self.spriteBase.y < 5 then
        self.downPath = true
    else
        self.downPath = false
    end
end

function Rover:findNewTarget()
    if currentscreen.dandelionsTable[0] ~= nil and currentscreen.dandelionsTable[0].burned == false then
        self.tX = currentscreen.dandelionsTable[0].dandelion1.x
        self.tY = currentscreen.dandelionsTable[0].dandelion1.y
        self:burnTarget(0)

    elseif currentscreen.dandelionsTable[1] ~= nil and currentscreen.dandelionsTable[1].burned == false then
        self.tX = currentscreen.dandelionsTable[1].dandelion1.x
        self.tY = currentscreen.dandelionsTable[1].dandelion1.y
        self:burnTarget(1)
    elseif currentscreen.dandelionsTable[2] ~= nil and currentscreen.dandelionsTable[2].burned == false then
        self.tX = currentscreen.dandelionsTable[2].dandelion1.x
        self.tY = currentscreen.dandelionsTable[2].dandelion1.y
        self:burnTarget(2)
    elseif currentscreen.dandelionsTable[3] ~= nil and currentscreen.dandelionsTable[3].burned == false then
        self.tX = currentscreen.dandelionsTable[3].dandelion1.x
        self.tY = currentscreen.dandelionsTable[3].dandelion1.y
        self:burnTarget(3)
    elseif currentscreen.dandelionsTable[4] ~= nil and currentscreen.dandelionsTable[4].burned == false then
        self.tX = currentscreen.dandelionsTable[4].dandelion1.x
        self.tY = currentscreen.dandelionsTable[4].dandelion1.y
        self:burnTarget(4)
    else
        self.tX = currentscreen.roverTargetX
        self.tY = currentscreen.roverTargetY
    end

end

function Rover:burnTarget(n)
    local x = self.spriteBase.x
    local y = self.spriteBase.y
    if math.abs(y - self.tY) < 70 or math.abs(x - self.tX) < 70 then
        self.dangerSound:play()
    end
    if x == self.tX and math.abs(y - self.tY) < 70 or y == self.tY and math.abs(x - self.tX) < 70 then
        self.canBurnFuel = 50
        currentscreen.dandelionsTable[n].burned = true

    end


end

function Rover:changeZIndexDependingOnPlayer()
    self.spriteBase:setZIndex(self.spriteBase.y - currentscreen.kosmonaut.posY - 20)
    self.turret:setZIndex(self.spriteBase.y - currentscreen.kosmonaut.posY - 19)
    -- if Kosmonaut:playerPositionY() > self.flower.y - 20 then
    -- else
    --     self.flower:setZIndex(currentscreen.kosmonaut.kosmonautSprite:getZIndex()+ 1)
    --     self.roots:setZIndex(currentscreen.kosmonaut.kosmonautSprite:getZIndex()+2)
    -- end

end

function Rover:whenKosmonautIsRover()
    if (playdate.buttonIsPressed(playdate.kButtonLeft)) then
        self.goLeft = true
        self.goDown = false
        self.goUp = false
        self.goRight = false

    elseif (playdate.buttonIsPressed(playdate.kButtonRight)) then
        self.goRight = true
        self.goDown = false
        self.goUp = false

        self.goLeft = false

    elseif (playdate.buttonIsPressed(playdate.kButtonUp)) then
        self.goUp = true
        self.goDown = false

        self.goRight = false
        self.goLeft = false


    elseif (playdate.buttonIsPressed(playdate.kButtonDown)) then
        self.goDown = true

        self.goUp = false
        self.goRight = false
        self.goLeft = false
    else
        self.goDown = false
        self.goUp = false
        self.goRight = false
        self.goLeft = false

    end

    if playdate:getCrankChange() > 15 or playdate.getCrankChange() < -15 then
        self.canBurn = true
        self.shootPrepareSound:setVolume(1)
        self.canBurnFalseDelay = 10
    else
        if playdate:getCrankChange() ~= 0 then
            self.shootPrepareSound:play()
        end
        self.shootVolume = playdate:getCrankChange() / 10
        if self.canBurnFalseDelay > 0 then
            self.canBurnFalseDelay -= 1
        end

        if self.canBurnFalseDelay == 0 then
            self.canBurn = false
        end
        self.shootPrepareSound:setVolume(self.shootVolume)
    end



end

function Rover:collideWithGutters()
    local a, b, collision, length = self.spriteBase:checkCollisions(self.spriteBase.x, self.spriteBase.y)

    if length > 0 and collision[#collision].other:getTag() == (20) and self.restFromHit == false then

        self.col = true
        self.hitFromGutter:play()
        self.glassSound:play()
        if self.restFromHit == false and collision[#collision].other.x - self.spriteBase.x < -10 and
            math.abs(collision[#collision].other.y - self.spriteBase.y) < 10 and
            currentscreen.kosmonaut:checkCollisionAt(currentscreen.kosmonaut.posX + 5, currentscreen.kosmonaut.posY) then --gutter po prawej
            currentscreen.kosmonaut.posX += 5
            self.restFromHit = true
        end
        if self.restFromHit == false and collision[#collision].other.x - self.spriteBase.x > 10 and
            math.abs(collision[#collision].other.y - self.spriteBase.y) < 10 and
            currentscreen.kosmonaut:checkCollisionAt(currentscreen.kosmonaut.posX - 5, currentscreen.kosmonaut.posY) then --gutter po lewej
            currentscreen.kosmonaut.posX -= 5
            self.restFromHit = true
        end

        if self.restFromHit == false and collision[#collision].other.y - self.spriteBase.y < -10 and
            math.abs(collision[#collision].other.x - self.spriteBase.x) < 10 and
            currentscreen.kosmonaut:checkCollisionAt(currentscreen.kosmonaut.posX, currentscreen.kosmonaut.posY + 5) then --gutter u góry
            currentscreen.kosmonaut.posY += 5
            self.restFromHit = true
        end

        if self.restFromHit == false and collision[#collision].other.y - self.spriteBase.y > 10 and
            math.abs(collision[#collision].other.x - self.spriteBase.x) < 10 and
            currentscreen.kosmonaut:checkCollisionAt(currentscreen.kosmonaut.posX, currentscreen.kosmonaut.posY - 5) then --gutter u dołu
            currentscreen.kosmonaut.posY -= 5
            self.restFromHit = true
        end
        self.restFromHit = true




    end
    if self.restFromHit == true and self.col == true then
        self.col = false
        self.breakCounter += 1
        if self.breakCounter == 1 then
            self.crack1:add()
        end
        if self.breakCounter == 2 then
            self.crack2:add()
        end
        if self.breakCounter == 3 then
            self.crack3:add()
        end
        playdate.timer.performAfterDelay(3500, function()
            self.restFromHit = false
            self.offShieldSound:play()
            self.spriteBase:add()
            self.turret:add()
        end)
    end
    if self.restFromHit == true then
        self.roverAppearCounter += 1
        if self.roverAppearCounter > 20 then
            self.roverAppearCounter = 0
        end

        if self.roverAppearCounter > 10 then
            self.spriteBase:add()
            self.turret:add()
        else
            self.spriteBase:remove()
            self.turret:remove()
        end
    else
        self.roverAppearCounter = 0
    end


end
