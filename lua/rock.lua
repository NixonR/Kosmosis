import "CoreLibs/timer"
import "CoreLibs/sprites"
import "lua/spriteanimation"
import "lua/enemyScripts/enemy"
import "lua/screens/level"


local pd <const> = playdate
local gfx <const> = playdate.graphics

class('Rock').extends()

function Rock:init(x, y)

    self.rock = gfx.sprite.new(gfx.image.new('images/assets/rock'))
    self.rock:moveTo(x, y)
    self.rock:setCollideRect(0, 0, 20, 20)
    self.rock:setZIndex(30)


    self.rockThrow = false
    self.rockDistance = 0
    self.rockThrowDirection = "left"
    self.rockPicked = false
    self.throwSpeed = 5
    self.drawDamage = false
    self.damageDealt = 0
end

function Rock:updateInput()

end

function Rock:updateWork()
    self.rock:add()
    self.throwingRock(self)
    self.pickingRock(self)
    if self.rockDistance < 20 and self.rockDistance > 0 then
        self.checkCollision(self)
    end

end

function Rock:pickingRock()
    if math.abs(currentscreen.kosmonaut.posX - self.rock.x) < 15 and
        math.abs(currentscreen.kosmonaut.posY - self.rock.y) < 15 and
        self.rockPicked == false then
        if playdate.buttonJustPressed(playdate.kButtonB) then
            self.rockPicked = true
            self.rock:moveTo(currentscreen.kosmonaut.posX, currentscreen.kosmonaut.posY + 5)
        end
    end

    if self.rockPicked == true then
        self.rockDistance = 0
        self.rockThrow = false
        if playdate.buttonIsPressed(playdate.kButtonLeft) then
            self.rock:moveTo(currentscreen.kosmonaut.posX - 15, currentscreen.kosmonaut.posY)
        elseif playdate.buttonIsPressed(playdate.kButtonRight) then
            self.rock:moveTo(currentscreen.kosmonaut.posX + 15, currentscreen.kosmonaut.posY)
        elseif playdate.buttonIsPressed(playdate.kButtonUp) then
            self.rock:moveTo(currentscreen.kosmonaut.posX, currentscreen.kosmonaut.posY - 5)
        elseif playdate.buttonIsPressed(playdate.kButtonDown) then
            self.rock:moveTo(currentscreen.kosmonaut.posX, currentscreen.kosmonaut.posY + 5)
        else
            --self.rock:moveTo(self.kosmonaut.posX, self.kosmonaut.posY)
        end
    end

    self.rock:setZIndex(self.rock.y - currentscreen.kosmonaut.posY + 7)

end

function Rock:throwingRock()
    if self.rockPicked == true and playdate.buttonJustPressed(playdate.kButtonB) then
        self.rockThrow = true
        if playdate.buttonIsPressed(playdate.kButtonLeft) then
            self.rockThrowDirection = "left"
            print("left throw")
        elseif playdate.buttonIsPressed(playdate.kButtonRight) then
            self.rockThrowDirection = "right"
        elseif playdate.buttonIsPressed(playdate.kButtonUp) then
            self.rockThrowDirection = "up"
        elseif playdate.buttonIsPressed(playdate.kButtonDown) then
            self.rockThrowDirection = "down"
        else
            self.rockThrowDirection = "idle"
        end
        self.rockPicked = false
    end
    if self.rockDistance < 20 and self.rockThrow == true then
        self.rockDistance += 1
        if self.rockThrowDirection == "left" then
            self.rock:moveTo(self.rock.x - self.throwSpeed, self.rock.y)
        elseif self.rockThrowDirection == "right" then
            self.rock:moveTo(self.rock.x + self.throwSpeed, self.rock.y)
        elseif self.rockThrowDirection == "up" then
            self.rock:moveTo(self.rock.x, self.rock.y - self.throwSpeed)
        elseif self.rockThrowDirection == "down" then
            self.rock:moveTo(self.rock.x, self.rock.y + self.throwSpeed)
        else
            self.rock:moveTo(self.rock.x, self.rock.y + 22)
            self.rockDistance = 20
        end




    end
end

function Rock:draw()

    -- gfx.clear()
    -- gfx.sprite:update()
    if self.drawDamage == true and self.rockPicked == false then
        gfx.drawText("-" .. self.damageDealt, self.rock.x - 5, self.rock.y - 28)
    end

end

function Rock:checkCollision()
    local a, b, collision, length = self.rock:checkCollisions(self.rock.x, self.rock.y)

    if length > 0 and collision[#collision].other:getTag() == (101) and self.rockDistance < 20 then
        currentscreen.enemyHp -= self.rockDistance * 5
        currentscreen.monster.stunnedCooldown = 20
        if currentscreen.monster.dasherDead == false then
            currentscreen.monsterHurtSound:play()
        end
        currentscreen.monster.dashCooldown = 89
        currentscreen.monster.dashReload = true 
        currentscreen.rockHitSound:play()
        currentscreen.monster.monsterChargeSound:stop()
        self.drawDamage = true
        self.damageDealt = self.rockDistance
        self.rock:moveTo(self.rock.x, self.rock.y + 10)
        self.rockDistance = 20
        playdate.timer.performAfterDelay(500, function()
            self.drawDamage = false
        end)
    end
end
