import "lua/screens/screen"
import "lua/screens/level"
import "lua/kosmonaut"
import "CoreLibs/sprites"
import "lua/enemyScripts/gutter/gutter"
import "CoreLibs/crank"
import "CoreLibs/graphics"
import "CoreLibs/ui"

local gfx <const> = playdate.graphics

class("CliffView").extends("Level")

function CliffView:init()
    -- CliffView.super.init(self)
    -- self.levelcollisions = gfx.image.new("images/blank_collisions")
    -- self.levelimage = self.levelcollisions

    -- self.bg = gfx.sprite.new(gfx.image.new("images/cliffview/cliffview_bg"))
    -- self.bg:moveTo(200, 120)
    -- self.bg:setZIndex(1)
    -- self.foreground = gfx.sprite.new(gfx.image.new("images/cliffview/cliffview_foreground"))
    -- self.foreground:moveTo(200, 120)
    -- self.foreground:setZIndex(3)

    -- self.roverSprite = gfx.sprite.new(gfx.image.new("images/cliffview/cliffview_roverSprite"))
    -- self.roverSprite:moveTo(200, 120)
    -- self.roverSprite:setZIndex(5)
    -- self.lookingUpCounter = 0
    -- self.lookingRightCounter = 0
    -- self.lookingLeftCounter = 0
    -- self.lookingDownCounter = 0
    -- self.lookingDistance = 10
    -- self.bA = ButtonUI(20, 220, "B")
    -- self.buttonCounter = 0
end
function CliffView:loadAssets()
    CliffView.super.init(self)
    self.levelcollisions = gfx.image.new("images/blank_collisions")
    self.levelimage = self.levelcollisions

    self.bg = gfx.sprite.new(gfx.image.new("images/cliffview/cliffview_bg"))
    self.bg:moveTo(200, 120)
    self.bg:setZIndex(1)
    self.foreground = gfx.sprite.new(gfx.image.new("images/cliffview/cliffview_foreground"))
    self.foreground:moveTo(200, 120)
    self.foreground:setZIndex(3)

    self.roverSprite = gfx.sprite.new(gfx.image.new("images/cliffview/cliffview_roverSprite"))
    self.roverSprite:moveTo(200, 120)
    self.roverSprite:setZIndex(5)
    self.lookingUpCounter = 0
    self.lookingRightCounter = 0
    self.lookingLeftCounter = 0
    self.lookingDownCounter = 0
    self.lookingDistance = 10
    self.bA = ButtonUI(20, 220, "B")
    self.buttonCounter = 0
    
end

function CliffView:updateInput()
    if playdate.buttonJustPressed(playdate.kButtonB) then
        self:startFadeOut()
        roverisactive = true
        self.kosmonaut.posX = 160
        self.kosmonaut.posY = 140
        gfx.clear()
        gfx.sprite:removeAll()
        self:changescreen(currentscreen, cliffscreen, gfx.image.kDitherTypeBayer8x8)
        cliffscreen.roverPosX = 130
        cliffscreen.roverPosY = 130
        cliffscreen.roverTargetX = 130
        cliffscreen.roverTargetY = 130
        self.kosmonaut.currentAnimation = self.kosmonaut.animationIdleDown
        self.kosmonaut.currentAnimation:updateFrame()
        self.buttonCounter = 0

    end


end

function CliffView:updatework()
    self.bA:updateWork()
    self.buttonCounter += 1
    if self.buttonCounter > 50 then
        self.bA.uiButtonIsEnabled = true
    else
        self.bA.uiButtonIsEnabled = false
    end
    CliffView.super.updatework(self)
    self.viewing(self)
    self.bg:add()
    self.roverSprite:add()
    self.foreground:add()
    self.updateInput(self)

end

function CliffView:draw()

    CliffView.super.draw()


end

function CliffView:fadeInCompleted()

    CliffView.super.fadeInCompleted(self)
    self.kosmonaut.kosmonautSprite:remove()

end

function CliffView:viewing()
    if self.lookingRightCounter < self.lookingDistance then
        if playdate.buttonIsPressed(playdate.kButtonRight) then

            self.roverSprite:moveTo(self.roverSprite.x + 3, self.roverSprite.y)
            self.foreground:moveTo(self.foreground.x + 1, self.foreground.y)
            self.bg:moveTo(self.bg.x - 1, self.bg.y)

            self.lookingRightCounter += 1
        end
    end
    if self.lookingRightCounter > 0 and playdate.buttonIsPressed(playdate.kButtonRight) == false then
        
        self.roverSprite:moveTo(self.roverSprite.x - 3, self.roverSprite.y)
        self.foreground:moveTo(self.foreground.x - 1, self.foreground.y)
        self.bg:moveTo(self.bg.x + 1, self.bg.y)

        self.lookingRightCounter -= 1

    end

    if self.lookingLeftCounter < self.lookingDistance then
        if playdate.buttonIsPressed(playdate.kButtonLeft) then
            
            self.roverSprite:moveTo(self.roverSprite.x - 3, self.roverSprite.y)
            self.foreground:moveTo(self.foreground.x - 1, self.foreground.y)
            self.bg:moveTo(self.bg.x + 1, self.bg.y)
            self.lookingLeftCounter += 1
        end
    end
    if self.lookingLeftCounter > 0 and playdate.buttonIsPressed(playdate.kButtonLeft) == false then
        
        self.roverSprite:moveTo(self.roverSprite.x + 3, self.roverSprite.y)
        self.foreground:moveTo(self.foreground.x + 1, self.foreground.y)
        self.bg:moveTo(self.bg.x - 1, self.bg.y)


        self.lookingLeftCounter -= 1


    end

    if self.lookingUpCounter < self.lookingDistance then
        if playdate.buttonIsPressed(playdate.kButtonUp) then
            
            self.roverSprite:moveTo(self.roverSprite.x, self.roverSprite.y + 3)
            self.foreground:moveTo(self.foreground.x, self.foreground.y + 2)
            self.bg:moveTo(self.bg.x, self.bg.y - 1)



            self.lookingUpCounter += 1
        end
    end
    if self.lookingUpCounter > 0 and playdate.buttonIsPressed(playdate.kButtonUp) == false then
        
        self.roverSprite:moveTo(self.roverSprite.x, self.roverSprite.y - 3)
        self.foreground:moveTo(self.foreground.x, self.foreground.y - 2)
        self.bg:moveTo(self.bg.x, self.bg.y + 1)
        
        
        self.lookingUpCounter -= 1
    end

    if self.lookingDownCounter < self.lookingDistance then
        if playdate.buttonIsPressed(playdate.kButtonDown) then

            
            self.roverSprite:moveTo(self.roverSprite.x, self.roverSprite.y - 1)
            self.foreground:moveTo(self.foreground.x, self.foreground.y - 2)
            self.bg:moveTo(self.bg.x, self.bg.y + 1)


            self.lookingDownCounter += 1
        end
    end
    if self.lookingDownCounter > 0 and playdate.buttonIsPressed(playdate.kButtonDown) == false then
        
        self.roverSprite:moveTo(self.roverSprite.x, self.roverSprite.y +1)
        self.foreground:moveTo(self.foreground.x, self.foreground.y + 2)
        self.bg:moveTo(self.bg.x, self.bg.y - 1)


        self.lookingDownCounter -= 1
    end

end
