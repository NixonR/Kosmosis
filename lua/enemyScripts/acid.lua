import "CoreLibs/timer"
import "CoreLibs/sprites"
import "lua/spriteanimation"
import "lua/enemyScripts/enemy"
import "lua/screens/level"



local pd <const> = playdate
local gfx <const> = playdate.graphics

class('Acid').extends()

function Acid:init(x, y)
    self.acidBool = false
    self.acidSound = playdate.sound.fileplayer.new("sounds/acid")
    self.acidGurgleSound = playdate.sound.fileplayer.new("sounds/gurgle")
    self.acidTimer = 0
    self.acidSprite = gfx.sprite.new(gfx.image.new("images/monsters/acid"))
    self.acidSprite:setZIndex(1)
    self.acidSpritePreview = gfx.sprite.new(gfx.image.new("images/monsters/acidPreview"))
    self.acidSpritePreview:setZIndex(1)
    self.acidSpriteSpit = gfx.sprite.new(gfx.image.new("images/monsters/acidSpit"))
    self.acidSpriteSpit:setZIndex(9)

end

function Acid:updateWork()
    self.spawnAcid(self)
   

end



function Acid:animationChange()


end

function Acid:spawnAcid()

    if self.acidBool == true then
        self.randomX = math.random(20, 380)
        self.randomY = math.random(20, 220)
        self.acidSpritePreview:moveTo(self.randomX, self.randomY)
        self.acidSpritePreview:add()
        --self.acidSprite:moveTo(currentscreen.monster.sprite.x, currentscreen.monster.sprite.y + 20)
        self.acidSprite:moveTo(self.randomX, self.randomY)
        self.acidBool = false
        self.acidTimer = 200
        self.acidSprite:setScale(1)
    end
    if self.acidTimer > 0 then
        self.acidTimer -= 1
        if self.acidTimer == 180 then
            self.acidSpritePreview:remove()
            self.acidSprite:add()
            self.acidSound:play()
        end

if self.acidTimer == 198 then
    self.acidSpriteSpit:add()
    self.acidSpriteSpit:moveTo(currentscreen.monster.sprite.x, currentscreen.monster.sprite.y )
end
if self.acidTimer == 195 then
    self.acidSpriteSpit:moveTo(self.acidSpriteSpit.x, self.acidSpriteSpit.y -40 )
end
if self.acidTimer == 190 then
    self.acidSpriteSpit:moveTo(self.acidSpriteSpit.x, self.acidSpriteSpit.y -40 )
end
if self.acidTimer == 185 then
    self.acidSpriteSpit:moveTo(self.randomX, self.acidSpriteSpit.y )
end
if self.acidTimer == 182 then
    self.acidSpriteSpit:moveTo(self.randomX, self.randomY )
end
if self.acidTimer == 180 then
    self.acidSpriteSpit:remove()
end





        if self.acidTimer== 200 then
            self.acidSprite:setScale(1)
        elseif self.acidTimer == 150 then
            self.acidSprite:setScale(0.8)
        elseif self.acidTimer == 100 then
            self.acidSprite:setScale(0.55)
        elseif self.acidTimer == 50 then
            self.acidSprite:setScale(0.2)
        end
    end
    if self.acidTimer == 30 then
        self.acidSprite:remove()
        self.acidSound:stop()
        self.acidGurgleSound:stop()
    end

    if self.acidTimer> 30 then
        self.acidGurgleSound:play()
    else
        self.acidGurgleSound:stop()
    end
end

