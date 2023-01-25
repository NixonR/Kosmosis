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



class("Split").extends("Level")

local gfx <const> = playdate.graphics




function Split:init()


    self.levelimage = gfx.image.new('images/rooms/room_split')
    self.levelcollisions = gfx.image.new('images/rooms/room_split_collisions')
    Split.super.init(self, self.levelimage, self.levelcollisions)

    self.kosmonaut.posY = 120
end

-- function Split:loadAssets()
--     self.levelimage = gfx.image.new('images/rooms/room_split')
--     self.levelcollisions = gfx.image.new('images/rooms/room_split_collisions')
--     Split.super.init(self, self.levelimage, self.levelcollisions)

-- end

function Split:goLeft()
    gfx.sprite.removeAll()
    roverisactive = true
    self:changescreen(self, shipscreen, "LEFT")
    shipscreen.roverPosX = 130
    shipscreen.roverPosY = 120
    shipscreen.roverTargetX = 130
    shipscreen.roverTargetY = 120
    --self.kosmonaut:downTransition()
    if shipscreen.cutsceneLowBattery == false then
        shipscreen.cable:add()
        if self.kosmonaut.isRover == false then
            shipscreen.batteryIcon:add()
        end 
    end
    shipscreen:addFlowers()
    shipscreen:addDandelions()
    shipscreen:addLilDandelions()
    shipscreen.shipSprite:add()

    if self.kosmonaut.kosmonautSprite.y > 378 then
        self.kosmonaut.posY = 376
    end
    if self.kosmonaut.kosmonautSprite.y < 69 then
        self.kosmonaut.posY = 71
    end

    if shipscreen.fakeKosmonautActive == true then
        shipscreen.fakeKosmonaut:add()
        shipscreen.fakeKosmonaut:moveTo(shipscreen.fakeKosmoTempX, shipscreen.fakeKosmoTempY)
        
    end
end

function Split:goRight()
    gfx.sprite.removeAll()
    self:changescreen(currentscreen, fumesscreen, "RIGHT")
    fumesscreen.roverPosX = 280
    fumesscreen.roverPosY = -30
    fumesscreen.roverTargetX = 280
    fumesscreen.roverTargetY = 100
    --self.kosmonaut:downTransition()
    fumesscreen:addFlowers()
    fumesscreen:addDandelions()
    fumesscreen:addLilDandelions()
    -- if self.kosmonaut.kosmonautSprite.x > 378 then
    --     self.kosmonaut.posX = 376
    -- end
    -- if self.kosmonaut.kosmonautSprite.x < 20 then
    --     self.kosmonaut.posX = 22
    -- end
end

function Split:goUp()
    gfx.sprite.removeAll()
    self:changescreen(currentscreen, distractscreen, "UP")
    distractscreen.roverPosX = 280
    distractscreen.roverPosY = -30
    distractscreen.roverTargetX = 280
    distractscreen.roverTargetY = 100
    --self.kosmonaut:downTransition()
    distractscreen:addFlowers()
    distractscreen:addDandelions()
    distractscreen:addLilDandelions()
    distractscreen.kosmonaut.stepsTable[1]:remove()
    distractscreen.kosmonaut.stepsTable[2]:remove()
    distractscreen.kosmonaut.stepsTable[3]:remove()
    distractscreen.kosmonaut.stepsTable[4]:remove()
    distractscreen.kosmonaut.stepsTable[5]:remove()
    -- if self.kosmonaut.kosmonautSprite.x > 378 then
    --     self.kosmonaut.posX = 376
    -- end
    -- if self.kosmonaut.kosmonautSprite.x < 20 then
    --     self.kosmonaut.posX = 22
    -- end


end

function Split:goDown()



end

function Split:updateInput()

end

function Split:updatework()

    Split.super.updatework(self)
    currentscreen.kosmonaut.kosmonautSprite:clearClipRect()
end

function Split:checkCollisionsForNode()
    Split.super.checkCollisionsForNode(self)
end

function Split:returnGrid()
    return self.gridTable
end
