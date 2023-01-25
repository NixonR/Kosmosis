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



class("Plains").extends("Level")

local gfx <const> = playdate.graphics




function Plains:init()


    self.levelimage = gfx.image.new('images/rooms/room_plains')
    self.levelcollisions = gfx.image.new('images/rooms/room_plains_collisions')
    Plains.super.init(self, self.levelimage, self.levelcollisions)
    self.gutterIntro1 = true
    self.playerWasStopped = false

    self.fakeGutter1 = FakeGutter(180, 30, 430, 50)
    self:addFakeGutterToTable(self.fakeGutter1)

    self.stopPlayerFromMoving = false

    self.playerLeftBeforePlayerWentIntoColliderBool = false

    self.rootsAlone = gfx.sprite.new(gfx.image.new("images/plants/flower/flower_roots"))
    self.rootsAlone:moveTo(85, 205)

    self.flower1 = Flower(240, 120)
    self.flower2 = Flower(310, 160)
    self:addFlowerToTable(self.flower1)
    self:addFlowerToTable(self.flower2)
    

    self.warningSound = playdate.sound.sampleplayer.new("sounds/28_item_1")
    self.warningSound:setVolume(0.4)

    self.roverPosX = 100
    self.roverPosY = 260
    self.roverTargetX = 100
    self.roverTargetY = 100

end

function Plains:loadAssets()
    
end

function Plains:goLeft()
end

function Plains:goRight()
end

function Plains:goUp()
    gfx.sprite:removeAll()
    self.removeEnemies(self)
    self:changescreen(currentscreen, cowplainsscreen, "UP")
    cowplainsscreen.roverPosX = 180
    cowplainsscreen.roverPosY = 260
    cowplainsscreen.roverTargetX = 170
    cowplainsscreen.roverTargetY = 135
    cowplainsscreen:addEnemyBack()
    cowplainsscreen:addDandelions()
    cowplainsscreen:addLilDandelions()
    

    self.fakeGutterTable[0] = nil

    if self.kosmonaut.kosmonautSprite.x > 308 then
        self.kosmonaut.posX = 307
    end
    if self.kosmonaut.kosmonautSprite.x < 133 then
        self.kosmonaut.posX = 132
    end
    if cowplainsscreen.cutsceneBurning == true then
        cowplainsscreen:dandelionShootIsTrue()
    end

end

function Plains:goDown()
    self.removeEnemies(self)
    gfx.sprite.removeAll()
    self:changescreen(currentscreen, capsulestartscreen, "DOWN")
    capsulestartscreen.roverPosX = 150
    capsulestartscreen.roverPosY = -30
    capsulestartscreen.roverTargetX = 150
    capsulestartscreen.roverTargetY = 150

    capsulestartscreen:addEnemyBack()
    capsulestartscreen:addDandelions()
    capsulestartscreen:spritesThatShouldAlwaysBeAdded()
    self.playerLeftBeforePlayerWentIntoColliderBool = true -- kiedy
    self.fakeGutterTable[0] = nil
    if self.kosmonaut.kosmonautSprite.x > 253 then
        self.kosmonaut.posX = 252
    end

    if self.kosmonaut.kosmonautSprite.x < 45 then
        self.kosmonaut.posX = 46
    end

end
-- function Plains:loadAssets()

-- end

function Plains:releaseAssets()
    
end

function Plains:updateInput()

end

function Plains:updatework()
   

    Plains.super.updatework(self)
    self.updateInput(self)
    if self.kosmonaut.kosmonautSprite.y < 240 and self.playerWasStopped == false and
        self.playerLeftBeforePlayerWentIntoColliderBool == false then
        --self.stopPlayerFromMoving = true
        --self.cutsceneBar = true
        self.warningSound:play()
        self.playerWasStopped = true
    end

end

function Plains:addEnemy(enemy)
    Plains.super.addEnemy(self, enemy)

end

function Plains:checkCollisionsForNode()
    Plains.super.checkCollisionsForNode(self)
end

function Plains:returnGrid()
    return self.gridTable
end

function Plains:removeEnemies()
    Plains.super.removeEnemies(self)
end

function Plains:addEnemyBack()
    Plains.super.addEnemyBack(self)
end

-- function Plains:fadeInCompleted()
--    if self.playerWasStopped == false then
--     Plains.super.fadeInCompleted(self)
--     self.kosmonaut.kosmonautSprite:remove()
    

--    else
--     Plains.super.fadeInCompleted(self)
    
--    end
    
-- end

function Plains:restart()
    self.fakeGutterTable[0].sprite.x = 340
    self.fakeGutterTable[0].sprite.y = 50
    self.playerLeftBeforePlayerWentIntoColliderBool = false
    self.playerWasStopped = false
    self.gutterIntro1 = true
    self.stopPlayerFromMoving = false



end


