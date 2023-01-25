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



class("Monster").extends("Level")

local gfx <const> = playdate.graphics




function Monster:init()


    -- self.levelimage = gfx.image.new('images/rooms/room_monster')
    -- self.levelcollisions = gfx.image.new('images/rooms/room_monster_collisions')
    -- Monster.super.init(self, self.levelimage, self.levelcollisions)

end

function Monster:loadAssets()
    self.levelimage = gfx.image.new('images/rooms/room_monster')
    self.levelcollisions = gfx.image.new('images/rooms/room_monster_collisions')
    Monster.super.init(self, self.levelimage, self.levelcollisions)
end
function Monster:goLeft()
    gfx.sprite.removeAll()
    self:changescreen(self, preludescreen, gfx.image.kDitherTypeBayer8x8)
    preludescreen.roverPosX = 280
    preludescreen.roverPosY = -30
    preludescreen.roverTargetX = 280
    preludescreen.roverTargetY = 100
    self.kosmonaut:leftTransition()
    preludescreen:addFlowers()
    preludescreen:addDandelions()
    preludescreen:addLilDandelions()
    -- if self.kosmonaut.kosmonautSprite.x > 378 then
    --     self.kosmonaut.posX = 376
    -- end
    -- if self.kosmonaut.kosmonautSprite.x < 20 then
    --     self.kosmonaut.posX = 22
    -- end
end

function Monster:goRight()
end

function Monster:goUp()



end

function Monster:goDown()



end

function Monster:updateInput()

end

function Monster:updatework()

    Monster.super.updatework(self)

end

function Monster:checkCollisionsForNode()
    Monster.super.checkCollisionsForNode(self)
end

function Monster:returnGrid()
    return self.gridTable
end

