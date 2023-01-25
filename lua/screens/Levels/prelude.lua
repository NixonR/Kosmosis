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



class("Prelude").extends("Level")

local gfx <const> = playdate.graphics




function Prelude:init()


    -- self.levelimage = gfx.image.new('images/rooms/room_prelude')
    -- self.levelcollisions = gfx.image.new('images/rooms/room_prelude_collisions')
    -- Prelude.super.init(self, self.levelimage, self.levelcollisions)

end
function Prelude:loadAssets()
    self.levelimage = gfx.image.new('images/rooms/room_prelude')
    self.levelcollisions = gfx.image.new('images/rooms/room_prelude_collisions')
    Prelude.super.init(self, self.levelimage, self.levelcollisions)
end
function Prelude:goLeft()
end

function Prelude:goRight()
    
    gfx.sprite.removeAll()
    self:changescreen(self, monsterscreen, gfx.image.kDitherTypeBayer8x8)
    monsterscreen.roverPosX = 280
    monsterscreen.roverPosY = -30
    monsterscreen.roverTargetX = 280
    monsterscreen.roverTargetY = 100
    self.kosmonaut:rightTransition()
    monsterscreen:addFlowers()
    monsterscreen:addDandelions()
    monsterscreen:addLilDandelions()
    -- if self.kosmonaut.kosmonautSprite.x > 378 then
    --     self.kosmonaut.posX = 376
    -- end
    -- if self.kosmonaut.kosmonautSprite.x < 20 then
    --     self.kosmonaut.posX = 22
    -- end
    
end

function Prelude:goUp()



end

function Prelude:goDown()
    gfx.sprite.removeAll()
    self:changescreen(self, fumesscreen, "DOWN")
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

function Prelude:updateInput()

end

function Prelude:updatework()

    Prelude.super.updatework(self)

end

function Prelude:checkCollisionsForNode()
    Prelude.super.checkCollisionsForNode(self)
end

function Prelude:returnGrid()
    return self.gridTable
end

