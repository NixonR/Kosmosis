import "lua/screens/screen"
import "lua/screens/level"
import "lua/kosmonaut"
import "lua/enemyScripts/gutter/gutter"
import "CoreLibs/sprites"
import "CoreLibs/graphics"
import "CoreLibs/timer"
import "CoreLibs/crank"
import "CoreLibs/object"
import "lua/buttonui"



class("Crank").extends("Level")

local gfx <const> = playdate.graphics




function Crank:init()


    self.levelimage = gfx.image.new('images/rooms/room_crank')
    self.levelcollisions = gfx.image.new('images/rooms/room_crank_collisions')
    Crank.super.init(self, self.levelimage, self.levelcollisions)
    crankImage = gfx.image.new("images/assets/cargo_wd40000")
    self.crankSprite = gfx.sprite.new(crankImage)
    self.crankSprite:moveTo(175, 47)

    self.crankSprite:setCollideRect(-25, 0, 50, 25)

    self.crankBool = true -- zmień na false jesli gracz zebrał już item
    self.gutter1 = Gutter(250, 90)
    self.gutter2 = Gutter(110, 130)
    self.gutter3 = Gutter(230, 200)

    self:addEnemy(self.gutter1)
    self:addEnemy(self.gutter2)
    self:addEnemy(self.gutter3)

    self.pickupSound = playdate.sound.fileplayer.new("sounds/mainBlink")

    self.shadow = gfx.sprite.new(gfx.image.new("images/assets/screeneffect_dark50"))
    self.shadow:setZIndex(800)
    self.shadow:moveTo(201, 120)

    self.bA = ButtonUI(175, 22, "A")


end

function Crank:goLeft()
end

function Crank:goRight()
end

function Crank:goDown()
end

function Crank:goUp()

    gfx.sprite:removeAll()
    gfx.clear()
    if cargoendscreen.roverCollected == true then
        roverisactive = true
    end
    self.removeEnemies(self)
    self:changescreen(self, gutternestscreen, "UP")
    gutternestscreen.roverPosX = 220
    gutternestscreen.roverPosY = 100
    gutternestscreen.roverTargetX = 220
    gutternestscreen.roverTargetY = 100
    if roverisactive == false then
        
        gutternestscreen:addEnemyBack()
    end
    gutternestscreen:addDandelions()
    gutternestscreen:addLilDandelions()
    self.shadow:remove()


    if self.kosmonaut.kosmonautSprite.x > 306 then
        self.kosmonaut.posX = 305
    end
    if self.kosmonaut.kosmonautSprite.x < 268 then
        self.kosmonaut.posX = 269
    end
end

function Crank:updateInput()
    if self.bA.uiButtonIsEnabled == true and playdate.buttonJustPressed(playdate.kButtonA) then
        self.crankSprite:remove()
        self.crankBool = false
        self.kosmonaut:crankIsCollected()
        self.kosmonaut:addToInventory("wd40000")
        --hvsar_cargo.hvsar_blind:moveTo(305, 110)
        self.pickupSound:play()
        self:changescreen(currentscreen, cutscenewd40screen, gfx.image.kDitherTypeBayer8x8)
    end


end

function Crank:updatework()

    Crank.super.updatework(self)
    --self.invertDrawingEnemies(self)
    
    self.updateInput(self)
    self.collectItem(self)
    self.bA:updateWork()

end

function Crank:addEnemy(enemy)
    Crank.super.addEnemy(self, enemy)

end

function Crank:checkCollisionsForNode()
    Crank.super.checkCollisionsForNode(self)
end

function Crank:returnGrid()
    return self.gridTable
end

function Crank:removeEnemies()
    Crank.super.removeEnemies(self)
end

function Crank:addEnemyBack()
    Crank.super.addEnemyBack(self)
end

function Crank:collectItem()
    local actualX, actualY, collisions, collisionLength = self.crankSprite:checkCollisions(self.crankSprite.x,
        self.crankSprite.y)

    if collisionLength > 0 then
        if collisions[1].other:getTag() == (1) then

            self.bA.uiButtonIsEnabled = true
       

        end
    else
        self.bA.uiButtonIsEnabled = false
  
    end
end

function Crank:restart()
    self.crankBool = true
end


