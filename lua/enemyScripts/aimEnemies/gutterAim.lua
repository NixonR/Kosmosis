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


class('GutterAim').extends()

function GutterAim:init(x, y, index)

    self.gutterAimSprite = gfx.sprite.new()
    self.gutterCollider = gfx.sprite.new(gfx.image.new("images/gutterAim/emptyDot"))

    self.gutterCollider:setGroups({ 1 })
    self.gutterCollider:setCollidesWithGroups({ 5 })
    self.gutterCollider:moveTo(self.gutterAimSprite.x, self.gutterAimSprite.y)

    --ANIMATION GUTTER ===============================================================
    self.farSprite = SpriteAnimation(self.gutterAimSprite)
    self.farSprite:addImage("images/gutterAim/gutter_pos1_walk1")

    self.middleSprite = SpriteAnimation(self.gutterAimSprite)
    self.middleSprite:addImage("images/gutterAim/gutter_pos2_walk1")

    self.closeSprite = SpriteAnimation(self.gutterAimSprite)
    self.closeSprite:addImage("images/gutterAim/gutter_pos3_walk1")

    self.burnFar = SpriteAnimation(self.gutterAimSprite)
    self.burnFar:addImage("images/gutterAim/gutter_pos1_burn1")
    self.burnFar:addImage("images/gutterAim/gutter_pos1_burn2")

    self.burnMiddle = SpriteAnimation(self.gutterAimSprite)
    self.burnMiddle:addImage("images/gutterAim/gutter_pos2_burn1")
    self.burnMiddle:addImage("images/gutterAim/gutter_pos2_burn2")

    self.burnClose = SpriteAnimation(self.gutterAimSprite)
    self.burnClose:addImage("images/gutterAim/gutter_pos3_burn1")
    self.burnClose:addImage("images/gutterAim/gutter_pos3_burn2")

    self.hitGraphic = gfx.sprite.new()
    self.hitGraphic:setScale(0.4)
    self.hitGraphic:moveTo(200, 120)
    self.hitGraphic:setZIndex(8)

    self.burnHit = SpriteAnimation(self.hitGraphic)
    self.burnHit:addImage("images/vfx/fireS1")
    self.burnHit:addImage("images/vfx/fireM2")

    -- self.farFade = gfx.sprite.new(gfx.image.new("images/gutterAim/fadeFar"))
    -- self.farFade:setZIndex(100)
    -- self.middleFade = gfx.sprite.new(gfx.image.new("images/gutterAim/fadeMiddle"))
    -- self.middleFade:setZIndex(100)
    -- self.closeFade = gfx.sprite.new(gfx.image.new("images/gutterAim/fadeClose"))
    -- self.closeFade:setZIndex(100)

    self.currentAnimation = self.farSprite

    --PARAMETERS
    self.index = index
    self.iterator = 0
    self.deathCounter = 0
    self.rangeBlockCounter = 0
    self.isActive = false
    self.inBetweenFrame = false
    self.canMove = true
    self.attackTime = 0

    if self.gutterAimSprite ~= nil then
        self.gutterAimSprite:moveTo(x, y)
    end

    --SOUND ================================================================================
    self.hitSound = playdate.sound.sampleplayer.new("sounds/hit")
    self.hitSound:setVolume(0.5)
    self.moveSound = playdate.sound.fileplayer.new("sounds/gulp")
    self.moveSound:setVolume(0.3)

end

--UPDATE WORK ---------------------------------------------------------------------------------------------------------
function GutterAim:updateWork()
    --self.fadeManager(self)
    self.dealingDamage(self)
    self.changePositionWhenClose(self)
    self.moveGutterOnSides(self)

    self.gutterAimSprite:setZIndex(self.index)
    self.changingColliderByIndex(self)

    self.currentAnimation:updateFrame()
    self.burnHit:updateFrame()

    self.resetIfReset(self)


end

function GutterAim:checkCollisionEnemy()
    if self.isActive == true then
        self.gutterCollider:setCollideRect(-10, -100, 20, 300)
        local a, b, collision, length = self.gutterCollider:checkCollisions(self.gutterCollider.x, self.gutterCollider.y)

        if length > 0 and collision[#collision].other:getTag() == (50)
        then
            self.hitGraphic:add()
            if playdate.getCrankChange() > 40 then
                if self.index == 3 or self.index == 4 then
                    self.deathCounter += 4
                end
                if self.index == 5 or self.index == 6 then
                    self.deathCounter += 6
                end
                if self.index == 7 or self.index == 8 then
                    self.deathCounter += 8
                end

            else
                if self.index == 3 or self.index == 4 then
                    self.deathCounter += 2
                end
                if self.index == 5 or self.index == 6 then
                    self.deathCounter += 3
                end
                if self.index == 7 or self.index == 8 then
                    self.deathCounter += 3
                end

            end

            if self.deathCounter % 10 == 0 then
                self.hitSound:play()
            end
        else
            self.hitGraphic:remove()
        end
        if self.deathCounter >= 300 then
            self.hitGraphic:remove()
            if self.index == 3 or self.index == 4 then
                self.currentAnimation = self.burnFar
            end
            if self.index == 5 or self.index == 6 then
                self.currentAnimation = self.burnMiddle
            end
            if self.index == 7 or self.index == 8 then
                self.currentAnimation = self.burnClose
            end
            self.gutterCollider:remove()
            self.canMove = false
            self.attackTime = 0
            playdate.timer.performAfterDelay(1000, function()
                self.isActive = false
                self.gutterAimSprite:remove()
            end)
            self.deathCounter = 0
            aimscreen.hitScore += 1
        end
    end
end

function GutterAim:dealingDamage()
    if self.index == 8 and aimscreen.gutterCanMove == true and self.canMove == true then
        self.attackTime += math.random(1, 2)
    end
    if self.attackTime >= 150 then
        aimscreen.jumpscareBool = true
        self.isActive = false
        self.canMove = false
        self.attackTime = 0
        self.gutterAimSprite:remove()
        self.gutterCollider:remove()

    end
    if aimscreen.gutterCanMove == true then
        self.canMove = true
    else
        self.canMove = false
    end
end

function GutterAim:moveGutterOnSides()
    self.gutterCollider:moveTo(self.gutterAimSprite.x, self.gutterAimSprite.y - 20)
    if self.rangeBlockCounter > -2 then
        if playdate.buttonJustPressed(playdate.kButtonRight) then
            self.inBetweenFrame = true
            if self.inBetweenFrame == true then
                self.gutterAimSprite.y += 10
                self.gutterAimSprite:moveTo(self.gutterAimSprite.x - 100, self.gutterAimSprite.y)
                self.inBetweenFrame = false
            end
            playdate.timer.performAfterDelay(40, function()
                self.gutterAimSprite.y -= 10
                self.gutterAimSprite:moveTo(self.gutterAimSprite.x - 100, self.gutterAimSprite.y)
                self.gutterCollider:moveTo(self.gutterAimSprite.x, self.gutterAimSprite.y - 20)
            end)
            self.rangeBlockCounter -= 1

        end
    end
    if self.rangeBlockCounter < 2 then
        if playdate.buttonJustPressed(playdate.kButtonLeft) then
            self.inBetweenFrame = true
            if self.inBetweenFrame == true then
                self.gutterAimSprite.y += 10
                self.gutterAimSprite:moveTo(self.gutterAimSprite.x + 100, self.gutterAimSprite.y)
                self.inBetweenFrame = false
            end
            --playdate.timer.performAfterDelay(40, function()
            self.gutterAimSprite.y -= 10
            self.gutterAimSprite:moveTo(self.gutterAimSprite.x + 100, self.gutterAimSprite.y)
            self.gutterCollider:moveTo(self.gutterAimSprite.x, self.gutterAimSprite.y - 20)
            --end)
            self.rangeBlockCounter += 1
        end
    end

    -- MOVING UP DOWN OPTION=============================================================
    -- if playdate.buttonIsPressed(playdate.kButtonUp) then
    --     self.gutterAimSprite:moveTo(self.gutterAimSprite.x, self.gutterAimSprite.y + 4)
    --     self.gutterCollider:moveTo(self.gutterAimSprite.x, self.gutterAimSprite.y + 4)
    -- end
    -- if playdate.buttonIsPressed(playdate.kButtonDown) then
    --     self.gutterAimSprite:moveTo(self.gutterAimSprite.x, self.gutterAimSprite.y - 4)
    --     self.gutterCollider:moveTo(self.gutterAimSprite.x, self.gutterAimSprite.y - 4)
    -- end
end

function GutterAim:changingColliderByIndex()
    if self.isActive == true then
        self.checkCollisionEnemy(self)
        if self.currentAnimation ~= self.burnFar and self.currentAnimation ~= self.burnMiddle and
            self.currentAnimation ~= self.burnClose and self.canMove == true then
            self.iterator += 1
            if self.iterator > aimscreen.gutterMoveTime and self.index < 8 then
                self.iterator = 0
                self.index += 1
                if self.index == 3 or self.index == 5 or self.index == 7 then

                    self.moveSound:play()
                end

            end
            if self.index == 3 then
                -- self.gutterAimSprite:setScale(0.5)
                self.gutterCollider:setCollideRect(-10, -100, 20, 300)
                self.currentAnimation = self.farSprite
            end

            if self.index == 5 then
                -- self.gutterAimSprite:setScale(0.7)
                self.gutterCollider:setCollideRect(-20, -100, 50, 300)
                self.currentAnimation = self.middleSprite
            end

            if self.index == 7 then
                -- self.gutterAimSprite:setScale(0.9)
                self.gutterCollider:setCollideRect(-40, -100, 80, 300)
                self.currentAnimation = self.closeSprite
            end

        end


    else
        self.index = 3
        self.iterator = 0
        self.currentAnimation = self.farSprite
        self.deathCounter = 0
    end
end

function GutterAim:changePositionWhenClose()

    if self.index == 7 or self.index == 8 then
        self.gutterAimSprite:moveTo(self.gutterAimSprite.x, 195)
    else
        self.gutterAimSprite:moveTo(self.gutterAimSprite.x, 144)
    end
end

function GutterAim:resetIfReset()
    if aimscreen.reset == true then
        self.index = 3
        self.gutterAimSprite:setZIndex(3)
        self.isActive = false
        self.canMove = false
        self.gutterAimSprite:remove()
    end
end

function GutterAim:activate()
    self.isActive = true
    self.gutterAimSprite:add()
    self.gutterCollider:add()
end

-- function GutterAim:fadeManager()
--     if self.isActive == true then
--         if self.index == 3 or self.index == 4 then
--             self.closeFade:remove()
--             self.middleFade:remove()
--             self.farFade:add()
--             self.farFade:moveTo(self.gutterAimSprite.x, self.gutterAimSprite.y)
--             self.farFade:setClipRect(self.gutterAimSprite.x - 20, self.gutterAimSprite.y - 32, 40,
--                 64 / 100 * self.deathCounter)
--         end
--         if self.index == 5 or self.index == 6 then
--             self.farFade:remove()
--             self.closeFade:remove()
--             self.middleFade:add()
--             self.middleFade:moveTo(self.gutterAimSprite.x, self.gutterAimSprite.y)
--             self.middleFade:setClipRect(self.gutterAimSprite.x - 43, self.gutterAimSprite.y - 60, 86,
--                 119 / 100 * self.deathCounter)
--         end
--         if self.index == 7 or self.index == 8 then
--             self.farFade:remove()
--             self.middleFade:remove()
--             self.closeFade:add()
--             self.closeFade:moveTo(self.gutterAimSprite.x, self.gutterAimSprite.y)
--             self.closeFade:setClipRect(self.gutterAimSprite.x - 95, self.gutterAimSprite.y - 132, 191,
--                 264 / 100 * self.deathCounter)
--         end
--     else
--         self.farFade:remove()
--         self.closeFade:remove()
--         self.middleFade:remove()
--     end
-- end
