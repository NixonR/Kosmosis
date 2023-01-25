import "lua/screens/screen"
import "lua/screens/level"
import "lua/kosmonaut"
import "lua/enemyScripts/gutter/gutter"
import "CoreLibs/sprites"
import "CoreLibs/graphics"
import "CoreLibs/timer"
import "CoreLibs/crank"
import "CoreLibs/object"
import "lua/enemyScripts/dasherenemy"
import "lua/rock"


class("Dasher").extends("Level")

local gfx <const> = playdate.graphics




function Dasher:init()

    self.enemyHp = 360
    -- self.levelimage = gfx.image.new('images/rooms/room_Dasher')
    -- self.levelcollisions = gfx.image.new('images/rooms/room_Dasher_collisions')
    -- Dasher.super.init(self, self.levelimage, self.levelcollisions)

end

function Dasher:loadAssets()
    self.levelimage = gfx.image.new('images/rooms/room_Dasher')
    self.levelcollisions = gfx.image.new('images/rooms/room_Dasher_collisions')
    Dasher.super.init(self, self.levelimage, self.levelcollisions)

    self.monster = DasherEnemy(200, 120)
    self:addEnemy(self.monster)
    self.rockHitSound = playdate.sound.fileplayer.new("sounds/rockHitSound")
    self.monsterHurtSound = playdate.sound.fileplayer.new("sounds/monsterHurt")
    -- self.rock = gfx.sprite.new(gfx.image.new('images/assets/rock'))
    -- self.rock:moveTo(130, 140)
    -- self.rock:setCollideRect(0, 0, 20, 20)
    -- self.rock:setZIndex(30)
    -- self.rock:add()

    -- self.rockThrow = false
    -- self.rockDistance = 0
    -- self.rockThrowDirection = "left"
    -- self.rockPicked = false
    -- self.throwSpeed = 5
    -- self.drawDamage = false
    -- self.damageDealt = 0
    playdate.graphics.setLineWidth(2)
    playdate.graphics.setColor(playdate.graphics.kColorWhite)

    self.rock1 = Rock(120, 120)
    self.rock2 = Rock(300, 160)
end

function Dasher:goLeft()
end

function Dasher:goRight()
end

function Dasher:goUp()
    gfx.sprite.removeAll()
    self:changescreen(self, waterfallscreen, gfx.image.kDitherTypeBayer8x8)
    waterfallscreen.roverPosX = 280
    waterfallscreen.roverPosY = -30
    waterfallscreen.roverTargetX = 280
    waterfallscreen.roverTargetY = 100
    self.kosmonaut:upTransition()
    waterfallscreen:addFlowers()
    waterfallscreen:addDandelions()
    waterfallscreen:addLilDandelions()
    waterfallscreen.kosmonaut.kosmonautSprite:setScale(1)
    waterfallscreen.kosmonaut.speed = 1
    -- if self.kosmonaut.kosmonautSprite.x > 378 then
    --     self.kosmonaut.posX = 376
    -- end
    -- if self.kosmonaut.kosmonautSprite.x < 20 then
    --     self.kosmonaut.posX = 22
    -- end


end

function Dasher:goDown()

    gfx.sprite.removeAll()
    self:changescreen(self, labiryntscreen, gfx.image.kDitherTypeBayer8x8)
    labiryntscreen.roverPosX = 280
    labiryntscreen.roverPosY = -30
    labiryntscreen.roverTargetX = 280
    labiryntscreen.roverTargetY = 100
    self.kosmonaut:downTransition()
    labiryntscreen.blackHole:add()
    labiryntscreen:addFlowers()
    labiryntscreen:addDandelions()
    labiryntscreen:addLilDandelions()
    if self.kosmonaut.kosmonautSprite.x > 390 then
        self.kosmonaut.posX = 388
    end
    if self.kosmonaut.kosmonautSprite.x < 362 then
        self.kosmonaut.posX = 364
    end

end

function Dasher:updateInput()

end

function Dasher:updatework()

    Dasher.super.updatework(self)
    self.rock1:updateWork()
    self.rock2:updateWork()
    -- self.throwingRock(self)
    -- self.pickingRock(self)

    -- self.checkCollision(self)


end

function Dasher:checkCollisionsForNode()
    Dasher.super.checkCollisionsForNode(self)
end

function Dasher:returnGrid()
    return self.gridTable
end

function Dasher:pickingRock()
    if math.abs(self.kosmonaut.posX - self.rock.x) < 15 and math.abs(self.kosmonaut.posY - self.rock.y) < 15 and
        self.rockPicked == false then
        if playdate.buttonJustPressed(playdate.kButtonB) then
            self.rockPicked = true
        end
    end

    if self.rockPicked == true then
        self.rockDistance = 0
        self.rockThrow = false
        if playdate.buttonIsPressed(playdate.kButtonLeft) then
            self.rock:moveTo(self.kosmonaut.posX - 15, self.kosmonaut.posY)
        elseif playdate.buttonIsPressed(playdate.kButtonRight) then
            self.rock:moveTo(self.kosmonaut.posX + 15, self.kosmonaut.posY)
        elseif playdate.buttonIsPressed(playdate.kButtonUp) then
            self.rock:moveTo(self.kosmonaut.posX, self.kosmonaut.posY - 5)
        elseif playdate.buttonIsPressed(playdate.kButtonDown) then
            self.rock:moveTo(self.kosmonaut.posX, self.kosmonaut.posY + 5)
        else
            --self.rock:moveTo(self.kosmonaut.posX, self.kosmonaut.posY)
        end
    end

    self.rock:setZIndex(self.rock.y - currentscreen.kosmonaut.posY + 7)

end

function Dasher:throwingRock()
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

function Dasher:draw()
    Dasher.super.draw()
    -- if self.drawDamage == true and self.rockPicked == false then
    --     gfx.drawText("-"..self.damageDealt, self.rock.x - 5, self.rock.y - 28)
    -- end
    -- playdate.graphics.drawRect(20, 10, self.enemyHp, 4)
    self.rock1:draw()
    self.rock2:draw()
    if currentscreen.enemyHp ~= nil then
        if currentscreen.enemyHp < 0 then
            currentscreen.enemyHp = 0
        end
        playdate.graphics.drawRect(20, 10, currentscreen.enemyHp, 4)
    end
end

function Dasher:checkCollision()
    local a, b, collision, length = self.rock:checkCollisions(self.rock.x, self.rock.y)

    if length > 0 and collision[#collision].other:getTag() == (101) and self.rockDistance < 20 then
        self.enemyHp -= self.rockDistance
        self.drawDamage = true
        self.damageDealt = self.rockDistance
        self.rock:moveTo(self.rock.x, self.rock.y + 10)
        self.rockDistance = 20
        playdate.timer.performAfterDelay(500, function()
            self.drawDamage = false
        end)
    end
end


