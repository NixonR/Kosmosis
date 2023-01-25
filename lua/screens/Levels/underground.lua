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
import "lua/enemyScripts/egg"



class("Underground").extends("Level")

local gfx <const> = playdate.graphics




function Underground:init()

    --     self.levelimage = gfx.image.new('images/rooms/room_underground')
    --     self.levelcollisions = gfx.image.new('images/rooms/room_underground_collisions')
    --     Underground.super.init(self, self.levelimage, self.levelcollisions)
    --     self.egg1 = Egg(365, 115)
    --     self.egg2 = Egg(245, 115)
    --     self.egg3 = Egg(215, 182)
    --     self.egg4 = Egg(125, 85)
    --     self.egg5 = Egg(60, 115)
    --     self.egg6 = Egg(18, 215)

    --     self.eggUpdateTable = { self.egg1, self.egg2, self.egg3, self.egg4, self.egg5, self.egg6 }

    --     self.blackHole = gfx.sprite.new(gfx.image.new('images/vfx/blackHole2'))
    --     self.blackHole:setZIndex(1003)
    -- self.stopPlayerFromMoving = false

end

function Underground:loadAssets()
    self.levelimage = gfx.image.new('images/rooms/room_underground')
    self.levelcollisions = gfx.image.new('images/rooms/room_underground_collisions')

    self.eggSound =  playdate.sound.fileplayer.new("sounds/eggSound")
    self.eggPrepare =  playdate.sound.fileplayer.new("sounds/eggPrepare")
    Underground.super.init(self, self.levelimage, self.levelcollisions)
    self.egg1 = Egg(365, 115)
    self.egg2 = Egg(245, 115)
    self.egg3 = Egg(215, 182)
    self.egg4 = Egg(125, 85)
    self.egg5 = Egg(53, 115)
    self.egg6 = Egg(18, 215)
    self.kosmonaut.posX = 335
    self.kosmonaut.posY = 15
    self.eggUpdateTable = { self.egg1, self.egg2, self.egg3, self.egg4, self.egg5, self.egg6 }

    self.blackHole = gfx.sprite.new(gfx.image.new('images/vfx/blackHole2'))
   
   
    self.blackHole:setZIndex(1003)
    self.stopPlayerFromMoving = false

end

function Underground:goLeft()

end

function Underground:goRight()
end

function Underground:goUp()
end

function Underground:goDown()
    gfx.sprite.removeAll()
    self:changescreen(currentscreen, shortscreen, gfx.image.kDitherTypeBayer8x8)
    shortscreen.kosmonaut.posX = 70
    shortscreen.kosmonaut.posY = 10
    shortscreen:addFlowers()
    shortscreen:addDandelions()
    shortscreen:addLilDandelions()
    bg1:play(0)
    bg2:stop()

end

function Underground:updateInput()

end

function Underground:updatework()
    Underground.super.updatework(self)
    for k, v in pairs(self.eggUpdateTable) do
        self.eggUpdateTable[k]:updateWork()

    end


    self.blackHole:moveTo(self.kosmonaut.posX, self.kosmonaut.posY)
end

function Underground:checkCollisionsForNode()
    Underground.super.checkCollisionsForNode(self)
end

function Underground:returnGrid()
    return self.gridTable
end
