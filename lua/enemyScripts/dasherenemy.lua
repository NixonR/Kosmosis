import "CoreLibs/timer"
import "CoreLibs/sprites"
import "lua/spriteanimation"
import "lua/enemyScripts/enemy"
import "lua/screens/level"
import "lua/enemyScripts/acid"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class('DasherEnemy').extends()

function DasherEnemy:init(x, y)


    --graphics===============================================
    self.sprite = gfx.sprite.new(gfx.image.new("images/monsters/cow_std"))
    self.sprite:moveTo(x, y)
    self.sprite:setCollideRect(10, 10, 40, 60)
    self.sprite:setTag(101)
    self.sprite:setZIndex(11)

    self.smokeSprite = gfx.sprite.new(gfx.image.new("images/monsters/monster_smoke"))
    self.smokeSprite:moveTo(x, y)
    self.smokeSprite:setZIndex(12)



    --sounds
    self.monsterChargeSound = playdate.sound.fileplayer.new("sounds/monsterCharge")
    self.monsterExhaleSound = playdate.sound.fileplayer.new("sounds/monsterExhale")
    self.dyingSound = playdate.sound.fileplayer.new("sounds/dyingMonster")
    --direction to follow
    self.right = false
    self.left = false
    self.down = false
    self.up = false

    -- basic moving speed
    self.speed = 0.5

    -- follow delay timer
    self.timer = 0

    -- attack phase
    self.attack1 = true
    self.attack2 = false
    self.attack3 = false

    -- state of dasher dead or not
    self.dasherDead = false

    --attack acid parameters
    self.acid1 = Acid(200, 120)
    self.acid2 = Acid(200, 120)
    self.acid3 = Acid(200, 120)
    self.acid4 = Acid(200, 120)
    self.acid5 = Acid(200, 120)
    self.acidCounter = 1
    self.acidTable = { self.acid1, self.acid2, self.acid3, self.acid4, self.acid5 }
    self.acidActivatorTimer = 200

    --attack dash parameters
    self.dash = false
    self.dashSpeed = 1
    self.dashCooldown = 0
    self.dashReload = false

    --monster stunned state
    self.stunned = false
    self.stunnedCooldown = 0

end

function DasherEnemy:updateWork()
    --self.sprite:add()
    if currentscreen.enemyHp <= 0 and self.dasherDead == false then
        self.dyingSound:play()
    end
    if self.dasherDead == false then
        self.checkCollision(self)
        if self.stunned == false then
            self.followPlayer(self)

            if self.dashCooldown > 160 then
                self.dashCooldown = 0
                self.dashReload = false
            end
            if self.dashCooldown > 45 then
                self.dash = false
            end
            if self.dashReload == true then
                self.dashCooldown += 1
            end
            if self.dashCooldown == 90 and currentscreen.enemyHp < 160 then
                self.monsterExhaleSound:play()
            end

        end
        if self.dashCooldown > 150 and self.dashCooldown < 161 and currentscreen.enemyHp < 160 then
            self.smokeSprite:moveTo(self.sprite.x, self.sprite.y)
            self.smokeSprite:add()
        else
            self.smokeSprite:remove()
        end

        if self.stunnedCooldown > 0 then
            self.stunnedCooldown -= 1
            self.stunned = true
        else
            self.stunned = false
        end
    end

    self.timer += 1
    if self.timer > 50 then
        self.timer = 0
    end
    for k, v in pairs(self.acidTable) do
        self.acidTable[k]:updateWork()
    end
end

function DasherEnemy:checkCollisionAt(x, y)
    return currentscreen.levelcollisions:sample(x, y) == gfx.kColorBlack
end

function DasherEnemy:changeZIndexDependingOnPlayer()



end

function DasherEnemy:checkCollision()

    local a, b, collision, length = self.sprite:checkCollisions(self.sprite.x, self.sprite.y)
    --print(self.boiledCounter, "boiled counter")

    if length > 0 and collision[#collision].other:getTag() == (45) then


    end


end

function DasherEnemy:followPlayer()


    if currentscreen.enemyHp < 1 then
        self.dasherDead = true
    end
    if currentscreen.enemyHp < 180 and currentscreen.enemyHp > 0 then
        self.attack2 = true
    else
        self.attack2 = false
    end

    if currentscreen.enemyHp < 1 then
        self.attack1 = false
    end

    if self.sprite.x < currentscreen.kosmonaut.posX then
        if self.timer > 40 then
            self.right = true
            self.left = false
        end

    end

    if self.sprite.x > currentscreen.kosmonaut.posX then
        if self.timer > 40 then
            self.left = true
            self.right = false
        end
    end

    if self.sprite.y > currentscreen.kosmonaut.posY then
        if self.timer > 40 then
            self.up = true
            self.down = false
        end
    end

    if self.sprite.y < currentscreen.kosmonaut.posY then
        if self.timer > 40 then
            self.down = true
            self.up = false
        end
    end

    if self.attack1 then
        if self.right then
            if currentscreen.kosmonaut.posY > self.sprite.y then
                self.sprite:moveTo(self.sprite.x + self.speed, self.sprite.y + self.speed * 0.5) -- player jest niżej
            end
            if currentscreen.kosmonaut.posY < self.sprite.y then
                self.sprite:moveTo(self.sprite.x + self.speed, self.sprite.y + self.speed * -0.5) -- player jest wyżej
            end
            if currentscreen.kosmonaut.posY == self.sprite.y then
                self.sprite:moveTo(self.sprite.x + self.speed, self.sprite.y) -- player jest niżej
            end
        end

        if self.left then
            if currentscreen.kosmonaut.posY > self.sprite.y then
                self.sprite:moveTo(self.sprite.x - self.speed, self.sprite.y + self.speed * 0.5) -- player jest niżej
            end
            if currentscreen.kosmonaut.posY < self.sprite.y then
                self.sprite:moveTo(self.sprite.x - self.speed, self.sprite.y + self.speed * -0.5) -- player jest wyżej
            end
            if currentscreen.kosmonaut.posY == self.sprite.y then
                self.sprite:moveTo(self.sprite.x - self.speed, self.sprite.y) -- player jest niżej
            end
        end

        if currentscreen.kosmonaut.posX == self.sprite.x and currentscreen.kosmonaut.posY > self.sprite.y then
            self.sprite:moveTo(self.sprite.x, self.sprite.y + self.speed) -- player jest niżej
        end
        if currentscreen.kosmonaut.posX == self.sprite.x and currentscreen.kosmonaut.posY < self.sprite.y then
            self.sprite:moveTo(self.sprite.x, self.sprite.y - self.speed) -- player jest niżej
        end
        self.activateAcid(self)

    end

    if self.attack2 then
        if math.abs(currentscreen.kosmonaut.posY - self.sprite.y) < 10 or
            math.abs(currentscreen.kosmonaut.posX - self.sprite.x) < 10 then
            if self.dashCooldown < 45 then
                self.dash = true
                self.dashReload = true
                if self.dashCooldown == 5 then
                    self.monsterChargeSound:play()
                end
            end
        end

        if self.dash == true and self.right and self.sprite.x < 400 then
            self.sprite:moveTo(self.sprite.x + self.dashSpeed, self.sprite.y)
        end

        if self.dash == true and self.left and self.sprite.x > 0 then
            self.sprite:moveTo(self.sprite.x - self.dashSpeed, self.sprite.y)
        end

        if self.dash == true and self.down and self.sprite.y < 240 then
            self.sprite:moveTo(self.sprite.x, self.sprite.y + self.dashSpeed)
        end

        if self.dash == true and self.up and self.sprite.y > 0 then
            self.sprite:moveTo(self.sprite.x, self.sprite.y - self.dashSpeed)
        end

    end

end

function DasherEnemy:activateAcid()
    self.acidActivatorTimer -= 1
    if self.acidActivatorTimer == 0 then
        self.acidTable[self.acidCounter].acidBool = true
        self.acidCounter += 1
        self.acidActivatorTimer = 70
        if self.acidCounter > 5 then
            self.acidCounter = 1
        end
    end
end
