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



class("Distract").extends("Level")

local gfx <const> = playdate.graphics




function Distract:init()


    self.levelimage = gfx.image.new('images/rooms/room_distract')
    self.levelcollisions = gfx.image.new('images/rooms/room_distract_collisions')
    Distract.super.init(self, self.levelimage, self.levelcollisions)
    --self.fadeOutTime_ms = 2000
  
    self.kosmonautClipValue = 50

    self.sandSound = playdate.sound.fileplayer.new("sounds/sandSound")
    self.fallUnderground = playdate.sound.fileplayer.new("sounds/fallUnderground")


end

function Distract:goLeft()
end

function Distract:goRight()
end

function Distract:goUp()



end

function Distract:goDown()

    gfx.sprite.removeAll()
   
    self:changescreen(distractscreen, splitscreen, "DOWN")
    splitscreen.roverPosX = 280
    splitscreen.roverPosY = -30
    splitscreen.roverTargetX = 280
    splitscreen.roverTargetY = 100
    --self.kosmonaut:downTransition()
    splitscreen:addFlowers()
    splitscreen:addDandelions()
    splitscreen:addLilDandelions()
    
    -- if self.kosmonaut.kosmonautSprite.x > 378 then
    --     self.kosmonaut.posX = 376
    -- end
    -- if self.kosmonaut.kosmonautSprite.x < 20 then
    --     self.kosmonaut.posX = 22
    -- end

end

function Distract:updateInput()

end

function Distract:updatework()

    Distract.super.updatework(self)

    self.clipKosmonaut(self)
    self.kosmonautClipValue = currentscreen.kosmonaut.posY / 5
    if self.kosmonaut.posY < 190 then
        self.kosmonaut.speed = currentscreen.kosmonaut.posY / 180
        self.kosmonaut.posY -= 0.2
    else
        self.kosmonaut.speed = 2
    end
    if self.kosmonaut.posY < 65 then
        playdate.timer.performAfterDelay(1500, function ()
            self.fallUnderground:play()
            bg2:play(0)
        end)
        bg1:stop()
        self.kosmonaut.posX = 335
        self.kosmonaut.posY = 15
        undergroundscreen:fadeInWithAlpha(true)
        --gfx.clear()
    
        
        gfx.sprite.removeAll()
        roverisactive = false
        self.sandSound:play()
        self:changescreen(self,undergroundscreen)
        self.kosmonaut.posX = 335
        self.kosmonaut.posY = 15
        undergroundscreen.blackHole:add()
        undergroundscreen.kosmonaut.speed = 2
        undergroundscreen.kosmonaut.kosmonautSprite:setClipRect(0, 0,400,240)
        print("change scene")
    end
end

function Distract:checkCollisionsForNode()
    Distract.super.checkCollisionsForNode(self)
end

function Distract:returnGrid()
    return self.gridTable
end

function Distract:clipKosmonaut()
    currentscreen.kosmonaut.kosmonautSprite:setClipRect(currentscreen.kosmonaut.posX - 25,
        currentscreen.kosmonaut.posY - 25, 50, self.kosmonautClipValue)
end
