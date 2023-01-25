import "CoreLibs/object"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "lua/assetsmanager/assetsmanager"


local gfx <const> = playdate.graphics
class('SpriteAnimation').extends(gfx.sprite)


-- local fps = 10

function SpriteAnimation:init(sprite)
    self.fps = 10
    self.images = {}
    self.parentSprite = sprite
    self.frame = 0
    self.imagesLength = 0
end


function SpriteAnimation:addImage(imagePath)
    --print(imagePath)
    self.images[self.imagesLength] = assetsManager:getImageWithPath(imagePath)
    self.imagesLength += 1
end

function SpriteAnimation:updateFrame()

    self.frame += self.fps / playdate.display.getRefreshRate()
    if (self.frame >= self.imagesLength) then
        self.frame = 0;
    end
    self.parentSprite:setImage(self:getImage())
end

function SpriteAnimation:getImage()
    return self.images[math.floor(self.frame)]
end

function SpriteAnimation:removeSprites(spriteArray)
    playdate.graphics.sprite.removeSprites(self.images)
end

function SpriteAnimation:pauseAnimation()
    self.fps = 0
end

function SpriteAnimation:startAnimation()
    self.fps = 10
end
