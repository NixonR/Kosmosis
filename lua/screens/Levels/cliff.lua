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



class("Cliff").extends("Level")

local gfx <const> = playdate.graphics




function Cliff:init()


    -- self.levelimage = gfx.image.new('images/rooms/room_cliff')
    -- self.levelcollisions = gfx.image.new('images/rooms/room_cliff_collisions')
    -- Cliff.super.init(self, self.levelimage, self.levelcollisions)

    -- self.playerWasStopped = false
    -- self.stopPlayerFromMoving = false
    -- self.bA = ButtonUI(210, 100, "A")


    -- self.roverPosX = -10
    -- self.roverPosY = 140
    -- self.roverTargetX = 130
    -- self.roverTargetY = 130


end

function Cliff:loadAssets()

    self.levelimage = gfx.image.new('images/rooms/room_cliff')
    self.levelcollisions = gfx.image.new('images/rooms/room_cliff_collisions')
    Cliff.super.init(self, self.levelimage, self.levelcollisions)

    self.playerWasStopped = false
    self.stopPlayerFromMoving = false
    self.bA = ButtonUI(210, 100, "A")


    self.roverPosX = -10
    self.roverPosY = 140
    self.roverTargetX = 130
    self.roverTargetY = 130

end

function Cliff:goLeft()
    gfx.sprite.removeAll()
    flowervalleyscreen.roverPosX = 420
    flowervalleyscreen.roverPosY = 100
    flowervalleyscreen.roverTargetX = 280
    flowervalleyscreen.roverTargetY = 100
    self:changescreen(currentscreen, flowervalleyscreen, "LEFT")
    flowervalleyscreen:addFlowers()
    flowervalleyscreen:addDandelions()
    flowervalleyscreen:addLilDandelions()
    --aimscreen:loadAssets()
    if self.kosmonaut.kosmonautSprite.y > 214 then
        self.kosmonaut.posY = 212
    end
    if self.kosmonaut.kosmonautSprite.x < 96 then
        self.kosmonaut.posY = 98
    end

end

function Cliff:goRight()
end

function Cliff:goUp()


end

function Cliff:goDown()



end

function Cliff:updateInput()

end

function Cliff:updatework()
print(self.kosmonaut.posX, "posx", self.kosmonaut.posY, "posy")
    Cliff.super.updatework(self)
    self.bA:updateWork()
    if self.kosmonaut.posX > 150 then
        self.bA.uiButtonIsEnabled = true
        if playdate.buttonJustPressed(playdate.kButtonA) then
            self:startFadeOut()
            gfx.sprite:removeAll()
            roverisactive = false
            -- self.kosmonaut.posX = 80
            -- self.kosmonaut.posY = 98
            self:changescreen(currentscreen, cliffviewscreen, gfx.image.kDitherTypeBayer8x8)
            self.kosmonaut.currentAnimation = self.kosmonaut.animationIdleDown
            self.kosmonaut.currentAnimation:updateFrame()


        end
    else
        self.bA.uiButtonIsEnabled = false
    end



end
-- function Cliff:fadeInCompleted()

--     Cliff.super.fadeInCompleted(self)
    

-- end
function Cliff:checkCollisionsForNode()
    Cliff.super.checkCollisionsForNode(self)
end

function Cliff:returnGrid()
    return self.gridTable
end
