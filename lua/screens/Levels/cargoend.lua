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
import "lua/rover"



class("CargoEnd").extends("Level")

local gfx <const> = playdate.graphics




function CargoEnd:init()


    self.levelimage = gfx.image.new('images/rooms/room_cargo')
    self.levelcollisions = gfx.image.new('images/rooms/room_cargo_collisions')
    CargoEnd.super.init(self, self.levelimage, self.levelcollisions)
    self.cargoImage = gfx.sprite.new(gfx.image.new("images/gutterAim/emptyDot"))
    self.deadGutters = gfx.sprite.new(gfx.image.new("images/assets/deadGutter"))
    self.deadGutters:moveTo(200, 120)

    self.blindCargo = gfx.sprite.new(gfx.image.new("images/assets/blind_cargo"))
    self.blindCargo:setCenter(0.5, 0)
    self.blindCargo:moveTo(139, 54)
    --self.blindCargo:setClipRect(0,0,300, 300)
    --self.cargoImage:add()
    self.cargoImage:setCollideRect(-40, -30, 200, 63)
    self.cargoImage:moveTo(60, 60)
    self.cargoImage:setZIndex(-30)
    self.cargoImage:setTag(10)
    self.uiButtonAisEnabled = false

    self.bA = ButtonUI(100, 40, "A")

    self.roverCollected = false

    self.uiButtonA = gfx.sprite.new(gfx.image.new("images/ui/A_button"))
    self.uiButtonA:moveTo(100, 40)
    self.sX = 0.6

    self.buttonIterator = 1
    self.roverPosX = 100
    self.roverPosY = 260
    self.roverTargetX = 100
    self.roverTargetY = 100
    self.clRec = 100


end

function CargoEnd:goLeft()
end

function CargoEnd:goRight()
end

function CargoEnd:goUp()


end

function CargoEnd:goDown()
    gfx.sprite.removeAll()

    
    self.cargoImage:remove()
    self.removeEnemies(self)
    self.rover.spriteBase:remove()
    self.rover.turret:remove()
    
    self:changescreen(currentscreen, dandelionsscreen, "DOWN")
    dandelionsscreen.roverPosX = 170
    dandelionsscreen.roverPosY = -30
    dandelionsscreen.roverTargetX = 170
    dandelionsscreen.roverTargetY = 135
    dandelionsscreen:addEnemyBack()
    dandelionsscreen:addDandelions()
    dandelionsscreen:addLilDandelions()

    if self.kosmonaut.kosmonautSprite.x > 182 then
        self.kosmonaut.posX = 181
    end
    if self.kosmonaut.kosmonautSprite.x < 138 then
        self.kosmonaut.posX = 139
    end
    if dandelionsscreen.cutsceneBurning == true then
        dandelionsscreen:dandelionShootIsTrue()
    end


end

function CargoEnd:updateInput()
   --print(self.clRec)
    -- if playdate.buttonIsPressed(playdate.kButtonA) then
    --     self.clRec +=1
    -- end
    -- if playdate.buttonIsPressed(playdate.kButtonB) then
    --     self.clRec -=1
    -- end
    if self.bA.uiButtonIsEnabled == true and playdate.buttonJustPressed(playdate.kButtonA) then

        self:startFadeOut()
        gfx.sprite:removeAll()
        roverisactive = false
        self.kosmonaut.posX = 80
        self.kosmonaut.posY = 98
        self:changescreen(currentscreen, hvsar_cargo, gfx.image.kDitherTypeBayer8x8)
        self.kosmonaut.currentAnimation = self.kosmonaut.animationIdleDown
        self.kosmonaut.currentAnimation:updateFrame()
        hvsar_cargo:addSpritesOnChange()
        hvsar_cargo:fadeInWithAlpha(true)
        hvsar_cargo:basicPosition()

    end
end

function CargoEnd:updatework()
    CargoEnd.super.updatework(self)
    self.blindCargo:setClipRect(0,0,300, self.clRec)
    self.updateInput(self)
    self.displayAButton(self)
    --self.buttonAnim(self)
    --print(self.uiButtonA:getScale())
    self.bA:updateWork()

end

function CargoEnd:addEnemy(enemy)
    CargoEnd.super.addEnemy(self, enemy)

end

function CargoEnd:checkCollisionsForNode()
    CargoEnd.super.checkCollisionsForNode(self)
end

function CargoEnd:returnGrid()
    return self.gridTable
end

function CargoEnd:removeEnemies()
    CargoEnd.super.removeEnemies(self)
end

function CargoEnd:addEnemyBack()
    CargoEnd.super.addEnemyBack(self)
end

function CargoEnd:displayAButton()
    local actualX, actualY, collisions, collisionLength = self.cargoImage:checkCollisions(self.cargoImage.x,
        self.cargoImage.y)


    if collisionLength > 0 then
        if collisions[1].other:getTag() == (1) then
            self.bA.uiButtonIsEnabled = true
        end
    else

        self.bA.uiButtonIsEnabled = false
    end
end
