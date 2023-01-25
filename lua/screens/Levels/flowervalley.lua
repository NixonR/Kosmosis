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



class("FlowerValley").extends("Level")

local gfx <const> = playdate.graphics




function FlowerValley:init()


    self.levelimage = gfx.image.new('images/rooms/room_flowervalley')
    self.levelcollisions = gfx.image.new('images/rooms/room_flowervalley_collisions')
    FlowerValley.super.init(self, self.levelimage, self.levelcollisions)

    self.playerWasStopped = false
    self.stopPlayerFromMoving = false

    self.flower1 = Flower(30, 240)
    self.flower2 = Flower(110, 240)
    self.flower3 = Flower(190, 240)
    self.flower4 = Flower(270, 240)
    self.flower5 = Flower(350, 240)
    self.flower6 = Flower(70, 180)
    self.flower7 = Flower(150, 180)
    self.flower8 = Flower(230, 180)
    self.flower9 = Flower(310, 180)
    self.flower10 = Flower(390, 180)
    self.flower11 = Flower(30, 120)
    self.flower12 = Flower(110, 120)
    self.flower13 = Flower(190, 120)
    self.flower14 = Flower(270, 120)
    self.flower15 = Flower(350, 120)
    self.flower16 = Flower(70, 60)
    self.flower17 = Flower(150, 60)
    self.flower18 = Flower(230, 60)
    self.flower19 = Flower(310, 60)
    self.flower20 = Flower(390, 60)
    self:addFlowerToTable(self.flower1)
    self:addFlowerToTable(self.flower2)
    self:addFlowerToTable(self.flower3)
    self:addFlowerToTable(self.flower4)
    self:addFlowerToTable(self.flower5)
    self:addFlowerToTable(self.flower6)
    self:addFlowerToTable(self.flower7)
    self:addFlowerToTable(self.flower8)
    self:addFlowerToTable(self.flower9)
    self:addFlowerToTable(self.flower10)
    self:addFlowerToTable(self.flower11)
    self:addFlowerToTable(self.flower12)
    self:addFlowerToTable(self.flower13)
    self:addFlowerToTable(self.flower14)
    self:addFlowerToTable(self.flower15)
    self:addFlowerToTable(self.flower16)
    self:addFlowerToTable(self.flower17)
    self:addFlowerToTable(self.flower18)
    self:addFlowerToTable(self.flower19)
    self:addFlowerToTable(self.flower20)

    self.roverPosX = 100
    self.roverPosY = 260
    self.roverTargetX = 100
    self.roverTargetY = 100
    --roverisactive = true
end

function FlowerValley:goLeft()
end

function FlowerValley:goRight()
    gfx.sprite.removeAll()
    --cliffscreen:fadeInWithAlpha(true)
    self:changescreen(currentscreen, cliffscreen, "RIGHT")
    cliffscreen.roverPosX = -10
    cliffscreen.roverPosY = 140
    cliffscreen.roverTargetX = 130
    cliffscreen.roverTargetY = 130
    --self.kosmonaut:rightTransition()
    cliffscreen:addDandelions()
    cliffscreen:addLilDandelions()
    if self.kosmonaut.kosmonautSprite.y > 214 then
        self.kosmonaut.posY = 212
    end
    if self.kosmonaut.kosmonautSprite.y < 98 then
        self.kosmonaut.posY = 100
    end

end

function FlowerValley:goUp()
    gfx.sprite:removeAll()


    self.removeEnemies(self)
    self:changescreen(currentscreen, explosivescreen, "UP")
    explosivescreen.roverPosX = 200
    explosivescreen.roverPosY = 260
    explosivescreen.roverTargetX = 200
    explosivescreen.roverTargetY = 210
    --self.kosmonaut:upTransition()
    if aimscreen.finishExplosive == false or aimscreen.finishExplosive == nil then
        print("etwas")
        explosivescreen:addDandelions()
        explosivescreen:addLilDandelions()

    end
    if self.kosmonaut.kosmonautSprite.x > 366 then
        self.kosmonaut.posX = 364
    end
    if self.kosmonaut.kosmonautSprite.x < 32 then
        self.kosmonaut.posX = 34
    end
    explosivescreen:checkCollisionsForNode()



end

function FlowerValley:goDown()
    gfx.sprite.removeAll()

    self.removeEnemies(self)
    self:changescreen(currentscreen, gutternestscreen, "DOWN")
    gutternestscreen.roverPosX = 300
    gutternestscreen.roverPosY = -30
    gutternestscreen.roverTargetX = 220
    gutternestscreen.roverTargetY = 100
    gutternestscreen.rover.baseTurretRotation = gutternestscreen.rover.turretDown
    gutternestscreen:addDandelions()
    gutternestscreen:addLilDandelions()
    if self.kosmonaut.kosmonautSprite.x > 353 then
        self.kosmonaut.posX = 350
    end
    if self.kosmonaut.kosmonautSprite.x < 258 then
        self.kosmonaut.posX = 260
    end

end

function FlowerValley:updateInput()

end

function FlowerValley:updatework()

    FlowerValley.super.updatework(self)

end

function FlowerValley:checkCollisionsForNode()
    FlowerValley.super.checkCollisionsForNode(self)
end

function FlowerValley:returnGrid()
    return self.gridTable
end
