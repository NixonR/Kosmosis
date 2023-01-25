import "CoreLibs/timer"
import "CoreLibs/sprites"
import "lua/spriteanimation"
import "lua/enemyScripts/enemy"
import "lua/screens/level"


local pd <const> = playdate
local gfx <const> = playdate.graphics

class('DandelionExplode').extends()

function DandelionExplode:init(x, y)
    -- ZMIENNE=============================================
    self.dandelionRandom = 0
    self.dandelionCounter = 0

    --OBRAZKI===============================================
    self.dandelion1 = gfx.sprite.new(gfx.image.new("images/assets/dandelion3"))
    self.dandelion1:setScale(1)
    self.dandelion1:setZIndex(10)
    self.dandelion1:moveTo(x, y)
    self.dandelion1:setCenter(0.5, 1)
    self.dandelion1:setCollideRect(5, 5, 50, 70)
    self.dandelion1:setTag(101)

    self.explode1 = gfx.sprite.new(gfx.image.new("images/dexplode/dexplode_spawn_1"))
    self.explode2 = gfx.sprite.new(gfx.image.new("images/dexplode/dexplode_spawn_2"))
    self.explode3 = gfx.sprite.new(gfx.image.new("images/dexplode/dexplode_spawn_3"))
    self.explode1:moveTo(200, 120)
    self.explode2:moveTo(200, 120)
    self.explode3:moveTo(200, 120)
    self.flesh = playdate.sound.fileplayer.new("sounds/flesh")
    self.burned = false
    self.boiledCounter = 0
    self.explodeCounter = 0

end

function DandelionExplode:updateWork()
    if self.boiledCounter < 100 then
        self.burned = false
    end

    self.changeZIndexDependingOnPlayer(self)
    print(aimscreen.finishExplosive)

    self.playerIsDead = Kosmonaut:returnPlayerIsDead()
    self.checkCollision(self)
    if aimscreen.finishExplosive == false or aimscreen.finishExplosive == nil then
        if self.explodeCounter > 40 and self.explodeCounter < 45 then
            self.explode1:add()
        elseif self.explodeCounter > 40 and self.explodeCounter < 50 then
            self.explode1:remove()
            self.explode2:add()
        elseif self.explodeCounter > 40 and self.explodeCounter < 55 then
            self.explode2:remove()
            self.explode3:add()
        elseif self.explodeCounter == 55 then
            explosivescreen:addEnemy(explosivescreen.gutter1)
            explosivescreen:addEnemy(explosivescreen.gutter2)
            explosivescreen:addEnemy(explosivescreen.gutter3)
            explosivescreen:addEnemy(explosivescreen.gutter4)
            explosivescreen:addEnemyBack()
            self.explode3:remove()
            explosivescreen.spitGutters = true
        end
    end
end

function DandelionExplode:checkCollisionAt(x, y)
    return currentscreen.levelcollisions:sample(x, y) == gfx.kColorBlack
end

function DandelionExplode:changeZIndexDependingOnPlayer()
    self.dandelion1:setZIndex(self.dandelion1.y - currentscreen.kosmonaut.posY - 20)


end

function DandelionExplode:checkCollision()

    local a, b, collision, length = self.dandelion1:checkCollisions(self.dandelion1.x, self.dandelion1.y)
    --print(self.boiledCounter, "boiled counter")

    if length > 0 and collision[#collision].other:getTag() == (45) then
        self.boiledCounter += 1

    end
    if self.boiledCounter > 200 then

        self.burned = true
        --print("boiled ready")
    end
    if self.boiledCounter > 98 then
        self.explodeCounter += 1
    end

end
