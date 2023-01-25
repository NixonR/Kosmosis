import "CoreLibs/timer"
import "CoreLibs/sprites"
import "lua/spriteanimation"
import "lua/enemyScripts/enemy"
import "lua/screens/level"



local pd <const> = playdate
local gfx <const> = playdate.graphics

class('FireInstance').extends()

function FireInstance:init(x, y)


    self.fire = gfx.sprite.new(gfx.image.new("images/vfx/fireS2"))
    self.fire:moveTo(200, 120)
    self.fire:setZIndex(9)

    self.empty = gfx.sprite.new(gfx.image.new("images/ui/empty"))
    self.empty:moveTo(200, 120)
    --self.empty:setZIndex(9)
    self.empty:setTag(50)
    self.empty.collisionResponse = 'overlap'
    self.empty:setGroups({ 5 })
    self.empty:setCollidesWithGroups({ 1 })
    self.empty:setScale(0.05)
    --self.empty:setCollideRect(0,0,1,1)
    self.canUpdate = false

    self.fireS = SpriteAnimation(self.fire)
    self.fireS:addImage("images/vfx/vfx_hvsar_flame/flame1")
    self.fireS:addImage("images/vfx/vfx_hvsar_flame/flame2")
    self.fireS:addImage("images/vfx/vfx_hvsar_flame/flame3")
    self.fireS:addImage("images/vfx/vfx_hvsar_flame/flame4")
    self.fireS:addImage("images/vfx/vfx_hvsar_flame/flame5")
    self.fireS:addImage("images/vfx/vfx_hvsar_flame/flame6")
    self.fireS:addImage("images/vfx/vfx_hvsar_flame/flame7")
    self.fireS:addImage("images/vfx/vfx_hvsar_flame/flame8")
    self.fireS:addImage("images/vfx/vfx_hvsar_flame/flame9")

    self.currentAnimation = self.fireS
    self.currentAnimation.fps = 15
    self.minimumCrankChange = 0
    self.shootDelayCounter = 0
    self.shootDelayValue = 0

    -- self.fireM = SpriteAnimation(self.fire)
    -- self.fireM:addImage("images/vfx/fireM1")
    -- self.fireM:addImage("images/vfx/fireM2")

    -- self.fireL = SpriteAnimation(self.fire)
    -- self.fireL:addImage("images/vfx/fireL1")
    -- self.fireL:addImage("images/vfx/fireL2")
    self.dx = 0
    self.dy = 0
    self.counter = 0
    self.cNN = 0
    -- self.isActive = false
    self.removeFireCounter = 0
    self.stopUpdatingFrame = true
    self.canShootCounter = 0



end

function FireInstance:updateInput()
    self.move(self)
    self.moveEmpty(self)
    -- if playdate.isCrankDocked() == false and math.abs(playdate.getCrankChange()) > 10 then

    --     self.isActive = true

    -- else
    --     self.isActive = false
    -- end
end

function FireInstance:updateWork()
    self.updateInput(self)
    if self.currentAnimation.frame > 8 then

        self.fire:remove()
        self.empty:remove()
        self.currentAnimation.frame = 0
        self.stopUpdatingFrame = true
        self.canUpdate = false
    end

    self.currentAnimation:updateFrame()

    self.stopUpdatingFrame = false

    
    
    
    
    self.empty:setCollideRect(0, 0, self.empty.width, self.empty.height)
    
    self.shooting(self)
    -- if playdate.getCrankChange() < 16 then
    --     self.currentAnimation.fps = 15
    -- elseif playdate.getCrankChange() > 15 and playdate.getCrankChange() < 21 then
    --     self.currentAnimation.fps = 20
    -- elseif playdate.getCrankChange() > 20 then
    --     self.currentAnimation.fps = 30
    -- end
    
    
    

end

function FireInstance:move()

    if playdate.buttonIsPressed(playdate.kButtonRight) then
        self.fire:moveTo(self.fire.x - self.dx, self.fire.y)
    end
    if playdate.buttonIsPressed(playdate.kButtonLeft) then
        self.fire:moveTo(self.fire.x + self.dx, self.fire.y)
    end
    if playdate.buttonIsPressed(playdate.kButtonUp) then
        self.fire:moveTo(self.fire.x, self.fire.y + self.dy)
    end
    if playdate.buttonIsPressed(playdate.kButtonDown) then
        self.fire:moveTo(self.fire.x, self.fire.y - self.dy)
    end
end

function FireInstance:moveEmpty()

    if playdate.buttonIsPressed(playdate.kButtonRight) then
        self.empty:moveTo(self.empty.x - self.dx, self.empty.y)
    end
    if playdate.buttonIsPressed(playdate.kButtonLeft) then
        self.empty:moveTo(self.empty.x + self.dx, self.empty.y)
    end
    if playdate.buttonIsPressed(playdate.kButtonUp) then
        self.empty:moveTo(self.empty.x, self.empty.y + self.dy)
    end
    if playdate.buttonIsPressed(playdate.kButtonDown) then
        self.empty:moveTo(self.empty.x, self.empty.y - self.dy)
    end
end

function FireInstance:shooting()

    if self.currentAnimation.frame >= 0 and self.currentAnimation.frame < 1 then
        self.fire:setZIndex(9)
        self.fire:moveTo(200, 120)
        self.empty:moveTo(200, 120)
        self.dx = 0
        self.dy = 0


    end
    if self.currentAnimation.frame >= 1 and self.currentAnimation.frame < 2 then
        self.fire:setZIndex(8)

        self.dx = 0
        self.dy = 0


    end
    if self.currentAnimation.frame >= 2 and self.currentAnimation.frame < 3 then
        self.fire:setZIndex(7)

        self.dx = 4
        self.dy = 2



    end
    if self.currentAnimation.frame >= 3 and self.currentAnimation.frame < 4 then
        self.fire:setZIndex(6)

        self.dx = 4
        self.dy = 4

    end
    if self.currentAnimation.frame >= 4 and self.currentAnimation.frame < 5 then
        self.fire:setZIndex(5)

        self.dx = 8
        self.dy = 6

    end
    if self.currentAnimation.frame >= 5 and self.currentAnimation.frame < 6 then
        self.fire:setZIndex(4)

        self.dx = 10
        self.dy = 8

    end
    if self.currentAnimation.frame >= 6 and self.currentAnimation.frame < 7 then
        self.fire:setZIndex(3)

        self.dx = 12
        self.dy = 10

    end





end
