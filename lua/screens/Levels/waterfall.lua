import "lua/screens/screen"
import "lua/screens/level"
import "lua/kosmonaut"
import "lua/enemyScripts/gutter/gutter"
import "CoreLibs/sprites"
import "CoreLibs/graphics"
import "CoreLibs/timer"
import "CoreLibs/crank"
import "CoreLibs/object"
import "lua/enemyScripts/dandelion/dandelionenemy"



class("Waterfall").extends("Level")

local gfx <const> = playdate.graphics




function Waterfall:init()


    self.levelimage = gfx.image.new('images/rooms/room_waterfall')
    self.levelcollisions = gfx.image.new('images/rooms/room_waterfall_collisions')
    Waterfall.super.init(self, self.levelimage, self.levelcollisions)

    self.sateliteLocked = false
end

function Waterfall:loadAssets()
    -- self.levelimage = gfx.image.new('images/rooms/room_waterfall')
    -- self.levelcollisions = gfx.image.new('images/rooms/room_waterfall_collisions')
    -- Waterfall.super.init(self, self.levelimage, self.levelcollisions)
    self.bA = ButtonUI(275, 130, "A")
    self.sideView = false
    self.sidePanel = gfx.sprite.new(gfx.image.new('images/cutscenes/waterfall_sideView'))
    self.sidePanel:moveTo(200, 120)
    self.sidePanel:setZIndex(50)

    self.sideSatelite = gfx.sprite.new(gfx.image.new('images/cutscenes/waterfall_satelite'))
    self.sideSatelite:setCenter(0.5, 0)
    self.sideSatelite:moveTo(270, 0)
    self.sideSatelite:setZIndex(55)

    self.sideBackground = gfx.sprite.new(gfx.image.new('images/cutscenes/waterfall_background'))
    self.sideBackground:setCenter(0, 1)
    self.sideBackground:moveTo(200, 120)
    self.sideBackground:setZIndex(51)

    self.sideKosmonaut = gfx.sprite.new(gfx.image.new('images/cutscenes/waterfall_kosmonaut'))
    self.sideKosmonaut:moveTo(330, 120)
    self.sideKosmonaut:setZIndex(53)

    self.sideRope = gfx.sprite.new(gfx.image.new('images/cutscenes/waterfall_rope'))
    self.sideRope:moveTo(320, 120)
    self.sideRope:setZIndex(52)

    self.overburn = 0
    self.penalty = false

    self.grab = gfx.sprite.new()
    self.grab:moveTo(200, 120)
    self.grab:setZIndex(49)
    self.animationGrab = SpriteAnimation(self.grab)
    self.animationGrab:addImage("images/cutscenes/grab1")
    self.animationGrab:addImage("images/cutscenes/grab2")
    self.animationGrab:addImage("images/cutscenes/grab3")
    self.animationGrab:addImage("images/cutscenes/grab4")
    self.animationGrab:addImage("images/cutscenes/grab5")
    self.animationGrab:addImage("images/cutscenes/grab6")
    self.grabFrame = 0

    self.grabAnim = self.animationGrab
    self.grabCounter = 0

end

function Waterfall:goLeft()
end

function Waterfall:goRight()
end

function Waterfall:goUp()



end

function Waterfall:goDown()

    gfx.sprite.removeAll()
    self:changescreen(currentscreen, dasherscreen, gfx.image.kDitherTypeBayer8x8)
    dasherscreen.roverPosX = 280
    dasherscreen.roverPosY = -30
    dasherscreen.roverTargetX = 280
    dasherscreen.roverTargetY = 100
    self.kosmonaut:downTransition()
    dasherscreen:addFlowers()
    dasherscreen:addDandelions()
    dasherscreen:addLilDandelions()
    dasherscreen:addEnemyBack()
    dasherscreen.kosmonaut.kosmonautSprite:setScale(2)
    dasherscreen.monster.sprite:add()
    dasherscreen.kosmonaut.speed = 2
    roverisactive = false
    -- if self.kosmonaut.kosmonautSprite.x > 378 then
    --     self.kosmonaut.posX = 376
    -- end
    -- if self.kosmonaut.kosmonautSprite.x < 20 then
    --     self.kosmonaut.posX = 22
    -- end

end

function Waterfall:updateInput()

end

function Waterfall:updatework()

    Waterfall.super.updatework(self)
    self.bA:updateWork()
    self.enableButton(self)
    self.sideViewScreen(self)
    if self.overburn > 0 then
        self.overburn -= 2
        if self.overburn < 0 then
            self.overburn = 0
        end

    end
    if self.grabFrame > 5 then
        self.grabFrame = 0
    end
    if self.sateliteLocked == false then
        self.grabCounter += playdate.getCrankChange() * 0.1
    end
    if self.grabCounter > 10 then
        self.grabCounter = 0
        self.grabFrame += 1
    end
    if self.grabCounter == 0 then
        self.grabAnim:updateFrame()
        self.grabAnim.frame = self.grabFrame

    end
    print(self.sideKosmonaut.y, "SIDE kosmonaut Y ")
    if self.sideKosmonaut.y > 970 then
        self.sateliteLocked = true
    end
end

function Waterfall:checkCollisionsForNode()
    Waterfall.super.checkCollisionsForNode(self)
end

function Waterfall:returnGrid()
    return self.gridTable
end

function Waterfall:enableButton()
    if currentscreen.kosmonaut.posY < 50 and currentscreen.kosmonaut.posX < 100 and currentscreen.kosmonaut.posX > 50 and
        self.sideView == false then
        self.bA.uiButtonIsEnabled = true
        if playdate.buttonJustPressed(playdate.kButtonA) then
            self.sideView = true
            self.kosmonaut.speed = 0
        end
    else
        self.bA.uiButtonIsEnabled = false
    end
    if self.sideView == true and playdate.buttonJustPressed(playdate.kButtonB) then
        self.sideView = false

        self.kosmonaut.speed = 1
    end
    if self.sateliteLocked == false then
        if self.sideBackground.y > 120 then
            self.sideBackground:moveTo(self.sideBackground.x, self.sideBackground.y - 1)
        end
        if self.sideKosmonaut.y > 120 then
            self.sideKosmonaut:moveTo(self.sideKosmonaut.x, self.sideKosmonaut.y - 1)
        end
    else
        self.grabAnim.frame = 0
    end
    if self.overburn > 100 then
        self.penalty = true
        playdate.timer.performAfterDelay(4000, function()
            self.penalty = false
        end)
    end



end

function Waterfall:draw()
    Waterfall.super.draw()
    gfx.drawText(self.overburn, 360, 210)
end

function Waterfall:sideViewScreen()
    if self.sideView == true then
        self.sideKosmonaut:add()
        self.sideRope:add()
        self.sidePanel:add()
        self.sideBackground:add()
        self.sideSatelite:add()
        self.grab:add()
        if self.penalty == false and playdate.getCrankChange() > 0 and self.sateliteLocked == false then
            self.sideKosmonaut:moveTo(self.sideKosmonaut.x, self.sideKosmonaut.y + playdate.getCrankChange() * 0.1)
            self.sideBackground:moveTo(self.sideBackground.x, self.sideBackground.y + playdate.getCrankChange() * 0.1)
            self.overburn += playdate.getCrankChange() * 0.1


        end

    else
        self.grab:remove()
        self.sideKosmonaut:remove()
        self.sideRope:remove()
        self.sidePanel:remove()
        self.sideBackground:remove()
        self.sideSatelite:remove()
    end
end
