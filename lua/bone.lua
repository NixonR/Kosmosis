import "CoreLibs/timer"
import "CoreLibs/sprites"
import "lua/spriteanimation"
import "lua/enemyScripts/enemy"
import "lua/screens/level"


local pd <const> = playdate
local gfx <const> = playdate.graphics

class('Bone').extends()

function Bone:init(x, y, dir,  xMin, xMax, yMin, yMax)
    
    self.dir = dir
    if self.dir == "horizontal" then
        self.bone = gfx.sprite.new(gfx.image.new("images/assets/skelet_horizontal"))

    elseif self.dir == "vertical" then
        self.bone = gfx.sprite.new(gfx.image.new("images/assets/skelet_vertical"))
    end
    self.bone:setZIndex(3)
    self.bone:moveTo(x, y)
    
    self.tx = tx
    self.ty = ty
    self.xMin = xMin
    self.xMax = xMax
    self.yMin = yMin
    self.yMax = yMax
end

function Bone:updateInput()

end

function Bone:updateWork()

    self.moveBone(self)
end

function Bone:moveBone()

    local a, b, collision, length = self.bone:checkCollisions(self.bone.x, self.bone.y)
    if self.boneLocked == false then
        if length > 0 and collision[#collision].other:getTag() == (1) then

            if self.kosmonaut.kosmonautSprite.x < self.bone.x and playdate.buttonIsPressed(playdate.kButtonRight) then
                self.bone:moveTo(self.bone.x + self.kosmonaut.speed, self.bone.y)
            elseif self.kosmonaut.kosmonautSprite.x > self.bone.x and
                playdate.buttonIsPressed(playdate.kButtonLeft) then
                self.bone:moveTo(self.bone.x - self.kosmonaut.speed, self.bone.y)
            end
            if self.kosmonaut.kosmonautSprite.y < self.bone.y and playdate.buttonIsPressed(playdate.kButtonDown) then
                self.bone:moveTo(self.bone.x, self.bone.y + self.kosmonaut.speed)
            elseif self.kosmonaut.kosmonautSprite.y > self.bone.y and playdate.buttonIsPressed(playdate.kButtonUp) then
                self.bone:moveTo(self.bone.x, self.bone.y - self.kosmonaut.speed)
            end
            self.boneSound:play()
        end
    end
    if self.bone.x < self.xMin and self.bone.x > self.xMax and self.bone.y > self.yMin and self.bone.y < self.yMax and
        self.boneLocked == false then
        self.boneLocked = true
        self.bone:moveTo(200, 15)
        self.boneLockedSound:play()
        self.bonePlaced:play()
    end
end
