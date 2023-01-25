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



class("CowPlains").extends("Level")

local gfx <const> = playdate.graphics




function CowPlains:init()


    self.levelimage = gfx.image.new('images/rooms/room_cowplains')
    self.levelcollisions = gfx.image.new('images/rooms/room_cowplains_collisions')
    Plains.super.init(self, self.levelimage, self.levelcollisions)
    self.gutterIntro1 = true
    self.playerWasStopped = false

    self.fakeGutter1 = FakeGutter(140, 50, 430, 50)
    self:addFakeGutterToTable(self.fakeGutter1)

    self.stopPlayerFromMoving = false

    self.playerLeftBeforePlayerWentIntoColliderBool = false

    self.rootsAlone = gfx.sprite.new(gfx.image.new("images/plants/flower/flower_roots"))
    self.rootsAlone:moveTo(85, 205)

    -- self.flower1 = Flower(240, 120)
    -- self.flower2 = Flower(310, 160)
    -- self:addFlowerToTable(self.flower1)
    -- self:addFlowerToTable(self.flower2)
    

    self.warningSound = playdate.sound.sampleplayer.new("sounds/28_item_1")
    self.warningSound:setVolume(0.4)

    self.roverPosX = 100
    self.roverPosY = 260
    self.roverTargetX = 100
    self.roverTargetY = 100

end

function CowPlains:goLeft()
end

function CowPlains:goRight()
end

function CowPlains:goUp()
    gfx.sprite:removeAll()
    self.removeEnemies(self)
    self:changescreen(currentscreen, dandelionsscreen, "UP")
    dandelionsscreen.roverPosX = 180
    dandelionsscreen.roverPosY = 260
    dandelionsscreen.roverTargetX = 170
    dandelionsscreen.roverTargetY = 135
    dandelionsscreen:addEnemyBack()
    dandelionsscreen:addDandelions()
    dandelionsscreen:addLilDandelions()
    

    self.fakeGutterTable[0] = nil

    if self.kosmonaut.kosmonautSprite.x > 308 then
        self.kosmonaut.posX = 307
    end
    if self.kosmonaut.kosmonautSprite.x < 133 then
        self.kosmonaut.posX = 132
    end
    if dandelionsscreen.cutsceneBurning == true then
        dandelionsscreen:dandelionShootIsTrue()
    end

end

function CowPlains:goDown()
    self.removeEnemies(self)
    gfx.sprite.removeAll()
    self:changescreen(currentscreen, plainsscreen, "DOWN")
    plainsscreen.roverPosX = 150
    plainsscreen.roverPosY = -30
    plainsscreen.roverTargetX = 180
    plainsscreen.roverTargetY = 120
    plainsscreen:addEnemyBack(self)

    plainsscreen:addFlowers()
   
    if self.kosmonaut.kosmonautSprite.x > 184 then
        self.kosmonaut.posX = 183
    end
    if self.kosmonaut.kosmonautSprite.x < 109 then
        self.kosmonaut.posX = 110
    end

    plainsscreen.rootsAlone:add()

end
function CowPlains:loadAssets()

end

function CowPlains:releaseAssets()
    
end

function CowPlains:updateInput()

end

function CowPlains:updatework()
   

    CowPlains.super.updatework(self)
    self.updateInput(self)

end

function CowPlains:addEnemy(enemy)
    CowPlains.super.addEnemy(self, enemy)

end

function CowPlains:checkCollisionsForNode()
    CowPlains.super.checkCollisionsForNode(self)
end

function CowPlains:returnGrid()
    return self.gridTable
end

function CowPlains:removeEnemies()
    CowPlains.super.removeEnemies(self)
end

function CowPlains:addEnemyBack()
    CowPlains.super.addEnemyBack(self)
end


