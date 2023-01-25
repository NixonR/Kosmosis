import "lua/screens/screen"
import "lua/screens/level"
import "lua/kosmonaut"
import "lua/enemyScripts/gutter/gutter"
import "CoreLibs/sprites"
import "CoreLibs/graphics"
import "CoreLibs/timer"
import "CoreLibs/crank"
import "CoreLibs/object"



class("Secret").extends("Level")

local gfx <const> = playdate.graphics

function Secret:init()

    self.levelimage = gfx.image.new('images/rooms/room_secret')
    self.levelcollisions = gfx.image.new('images/rooms/room_secret_collisions')
    Secret.super.init(self, self.levelimage, self.levelcollisions)
    self.secretBoxImage = gfx.image.new("images/assets/secret_box")
    self.secretBoxSprite = gfx.sprite.new(self.secretBoxImage)
    self.secretBoxSprite:setCollideRect(0,0,30, 30)
    self.secretBoxSprite:moveTo(190, 145)
    self.secretBoxBool = true
    self.bA = ButtonUI(190, 75, "A")

    self.pickupSecretSound = playdate.sound.fileplayer.new("sounds/mainBlink")
end

function Secret:goLeft()
end
function Secret:goRight()
end
function Secret:goUp()
end
function Secret:goDown()
    gfx.sprite:removeAll()
    if cargoendscreen.roverCollected == true then
        roverisactive = true
    end
    self.removeEnemies(self)
    self:changescreen(self, cemeteryscreen, "DOWN")
    cemeteryscreen.roverPosX = 200
    cemeteryscreen.roverPosY = 120
    cemeteryscreen.roverTargetX = 200
    cemeteryscreen.roverTargetY = 120
    cemeteryscreen:addEnemyBack()
    if self.kosmonaut.kosmonautSprite.x > 217 then
        self.kosmonaut.posX = 216
    end
    if self.kosmonaut.kosmonautSprite.x < 167 then
        self.kosmonaut.posX = 168
    end
    cemeteryscreen.boneBridge:add()
end

function Secret:updateInput()
    if self.bA.uiButtonIsEnabled == true and playdate.buttonJustPressed(playdate.kButtonA) then
        
        self.secretBoxSprite:remove()
        self.secretBoxBool = false
        self.pickupSecretSound:play()
        self.kosmonaut:addToInventory("bumper")
        self:changescreen(currentscreen, cutscenesecretscreen, gfx.image.kDitherTypeBayer8x8)
    end 
end

function Secret:updatework()
    Secret.super.updatework(self)
    self.updateInput(self)
    self.collectItem(self)
    self.bA:updateWork()
end

function Secret:addEnemy(enemy)
    Secret.super.addEnemy(self, enemy)

end

function Secret:checkCollisionsForNode()
    Secret.super.checkCollisionsForNode(self)
end

function Secret:returnGrid()
    return self.gridTable
end

function Secret:removeEnemies()
    Secret.super.removeEnemies(self)
end

function Secret:addEnemyBack()
    Secret.super.addEnemyBack(self)
end

function Secret:collectItem()
    local actualX, actualY, collisions, collisionLength = self.secretBoxSprite:checkCollisions(self.secretBoxSprite.x,
        self.secretBoxSprite.y)
    
    if collisionLength > 0 then
        if collisions[1].other:getTag() == (1) then
            self.bA.uiButtonIsEnabled = true
           
        end
    else
        self.bA.uiButtonIsEnabled = false
    end
end

function Secret:restart()
    self.secretBoxBool = true
end


