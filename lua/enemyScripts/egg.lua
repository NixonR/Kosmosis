import "CoreLibs/timer"
import "CoreLibs/sprites"
import "lua/spriteanimation"
import "lua/enemyScripts/enemy"
import "lua/screens/level"


local pd <const> = playdate
local gfx <const> = playdate.graphics

class('Egg').extends()

function Egg:init(x, y)
    self.eggSprite = gfx.sprite.new()

    self.eggAnim = SpriteAnimation(self.eggSprite)
    self.eggAnim:addImage("images/assets/egg1")
    self.eggAnim:addImage("images/assets/egg2")
    self.eggAnim.fps = 1
    self.eggSprite:moveTo(x, y)
    self.eggSprite:setCollideRect(-20,13,60,2)
    self.eggSprite:setTag(66)
    self.eggSprite:add()


end

function Egg:updateWork()
 
    self.eggAnim:updateFrame()
end

function Egg:checkCollision()

end
