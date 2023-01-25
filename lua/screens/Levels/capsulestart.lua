import "lua/screens/screen"
import "lua/screens/level"
import "lua/kosmonaut"
import "lua/enemyScripts/gutter/gutter"
import "CoreLibs/sprites"
import "CoreLibs/graphics"
import "CoreLibs/timer"
import "CoreLibs/crank"
import "CoreLibs/object"



class("CapsuleStart").extends("Level")

local gfx <const> = playdate.graphics




function CapsuleStart:init()


    self.levelimage = gfx.image.new('images/rooms/room_capsule')
    self.levelcollisions = gfx.image.new('images/rooms/room_capsule_collisions')
    CapsuleStart.super.init(self, self.levelimage, self.levelcollisions)

    local kirkorImage = gfx.image.new("images/assets/capsule_start_kirkor")
    self.kirkor = gfx.sprite.new(kirkorImage)
    self.kirkor:moveTo(271, 175)
    self.kirkor:setCollideRect(-10, -5, 100, 60)

    self.kirkor:setZIndex(1)

    self.fogSprite = gfx.sprite.new(gfx.image.new("images/assets/fog1"))
    self.fogSprite:moveTo(250, 182)
    self.fogSprite:setClipRect(216, 0, 114, 190)
    self.fogSprite:setRotation(90)
    self.fogSprite:setZIndex(22)

    self.fogSprite2 = gfx.sprite.new(gfx.image.new("images/assets/fog1"))
    self.fogSprite2:moveTo(250, 382)
    self.fogSprite2:setClipRect(216, 0, 114, 190)
    self.fogSprite2:setRotation(90)
    self.fogSprite2:setZIndex(22)
    self.wakeUpCounter = 0
    self.uiButtonA = gfx.sprite.new(gfx.image.new("images/ui/A_button"))
    self.uiButtonA:setZIndex(999)
    self.uiButtonA:moveTo(320, 200)
    self.buttonAShakeCounter = 0
    self.hit = playdate.sound.fileplayer.new("sounds/hit")
    self.warning = playdate.sound.fileplayer.new("sounds/warning")
    self.changeRadarScreenSound = playdate.sound.sampleplayer.new("sounds/beep1")

    self.radarSprite = gfx.sprite.new(gfx.image.new("images/cutscenes/cutscene_hvsar_detected/cutscene_hvsar_detected_base"))
    self.radarSprite:moveTo(200, 120)
    self.radarSprite:setZIndex(1000)

    self.radarScreen1 = gfx.sprite.new(gfx.image.new("images/cutscenes/cutscene_hvsar_detected/cutscene_hvsar_detected_screen1"))
    self.radarScreen1:moveTo(200, 120)
    self.radarScreen1:setZIndex(1002)

    self.dotCover = gfx.sprite.new(gfx.image.new("images/cutscenes/cutscene_hvsar_detected/white_dot_cover"))
    self.dotCover:moveTo(200, 120)
    self.dotCover:setZIndex(1002)
    self.buttonRight = gfx.sprite.new(gfx.image.new("images/cutscenes/cutscene_hvsar_detected/buttonRight"))
    self.buttonRight:moveTo(200, 120)
    self.buttonRight:setZIndex(1002)

    self.radarScreen2 = gfx.sprite.new(gfx.image.new("images/cutscenes/cutscene_hvsar_detected/cutscene_hvsar_detected_screen2"))
    self.radarScreen2:moveTo(-200, 120)
    self.radarScreen2:setZIndex(1001)

    self.buttonLeft = gfx.sprite.new(gfx.image.new("images/cutscenes/cutscene_hvsar_detected/buttonLeft"))
    self.buttonLeft:moveTo(-200, 120)
    self.buttonLeft:setZIndex(1001)

    self.stopPlayerFromMoving = false
    self.notificationSound = playdate.sound.fileplayer.new("sounds/beep2")
    self.radarIsOn = false
    self.bA = ButtonUI(275, 130, "A")
    self.bB = ButtonUI(20, 220, "B")
    self.buttonBlinkCounter = 0

    self.currentAnimation = self.animationFogRight
    self.fogIterator = 0
    self.radarPage = 1
    self.text1 = TextDisplay(150, 30, "Capsule Destroyed")
    self.text2 = TextDisplay(160, 30, "Head North")

    self.roverPosX = 100
    self.roverPosY = 260
    self.roverTargetX = 100
    self.roverTargetY = 100
end

function CapsuleStart:goLeft()
end

function CapsuleStart:goRight()
end

function CapsuleStart:goUp()

    self.removeEnemies(self)
    gfx.sprite:removeAll()
    plainsscreen.roverPosX = 150
    plainsscreen.roverPosY = 260
    plainsscreen.roverTargetX = 180
    plainsscreen.roverTargetY = 120
    self:changescreen(currentscreen, plainsscreen, "UP")
    plainsscreen:addEnemyBack()
    plainsscreen:addDandelions()
    plainsscreen:addFlowers()
    if plainsscreen.gutterIntro1 == true then
        plainsscreen:addFakeGutter(180, 190, 200, 210, 220, 230)


        plainsscreen.gutterIntro1 = false
    end

    if self.kosmonaut.kosmonautSprite.x > 183 then
        self.kosmonaut.posX = 182
    end
    if self.kosmonaut.kosmonautSprite.x < 45 then
        self.kosmonaut.posX = 46
    end

    plainsscreen.rootsAlone:add()


end

function CapsuleStart:goDown()

end

function CapsuleStart:updateInput()

    if self.radarIsOn == true then
        if playdate.buttonJustPressed(playdate.kButtonB) then
            self.radarSprite:remove()
            self.radarScreen1:remove()
            self.radarScreen2:remove()
            self.buttonLeft:remove()
            self.buttonRight:remove()
            self.notificationSound:stop()
            self.bA.uiButtonIsEnabled = false

            self.stopPlayerFromMoving = false
            self.radarIsOn = false
        end

        if playdate.buttonJustPressed(playdate.kButtonRight) and self.radarPage == 1 then
            self.radarScreen1:moveTo(-200, 120)
            self.radarScreen2:moveTo(200, 120)

            self.changeRadarScreenSound:play()
            self.radarPage = 2
        end
        if playdate.buttonJustPressed(playdate.kButtonLeft) and self.radarPage == 2 then
            self.radarScreen1:moveTo(200, 120)
            self.radarScreen2:moveTo(-200, 120)

            self.changeRadarScreenSound:play()
            self.radarPage = 1

        end
    end
end

function CapsuleStart:releaseAssets()
    self.titlescreenimage = nil
end

function CapsuleStart:updatework()

    self.wakeUpPlayer(self)
    self.displayAButton(self)

    self.bA:updateWork()
    self.bB:updateWork()

    self.signalDetectedMessage(self)
    self.fogIndex(self)
    self.kosmonaut.canRotate = true
    self.kirkor:add()
    self.fogSprite:add()
    self.fogSprite2:add()

    self.fogIterator += 1
    if self.fogIterator > 4 then
        self.fogSprite:moveTo(self.fogSprite.x, self.fogSprite.y - 4)
        self.fogSprite2:moveTo(self.fogSprite2.x, self.fogSprite2.y - 4)
        self.fogIterator = 0
    end
    if self.fogSprite.y < -112 then
        self.fogSprite:moveTo(self.fogSprite.x, 280)
    end

    if self.fogSprite2.y < -112 then
        self.fogSprite2:moveTo(self.fogSprite2.x, 280)
    end




    self:addDandelions()
    CapsuleStart.super.updatework(self)
    self.updateInput(self)
    if self.kosmonaut.kosmonautSprite.y > self.kirkor.y - 6 then
        self.kirkor:setZIndex(1)

    else
        self.kirkor:setZIndex(20)
    end

end

function CapsuleStart:draw()
    CapsuleStart.super.draw()


end

function CapsuleStart:addEnemy(enemy)
    CapsuleStart.super.addEnemy(self, enemy)

end

function CapsuleStart:checkCollisionsForNode()
    CapsuleStart.super.checkCollisionsForNode(self)
end

function CapsuleStart:returnGrid()
    return self.gridTable
end

function CapsuleStart:removeEnemies()
    CapsuleStart.super.removeEnemies(self)
end

function CapsuleStart:addEnemyBack()
    CapsuleStart.super.addEnemyBack(self)
end

function CapsuleStart:changeScreen(start, target, fadeType)
    CapsuleStart.super.changescreen(start, target, fadeType)
end

function CapsuleStart:spritesThatShouldAlwaysBeAdded()
    self.kirkor:add()
end

function CapsuleStart:restart()

end

function CapsuleStart:wakeUpPlayer()
    if self.kosmonaut.wakeUp == false and self.stopPlayerFromMoving == false then
        self.stopPlayerFromMoving = true
        self.cutsceneBar = true
        playdate.timer.performAfterDelay(4000, function()
            self.kosmonaut.wakeUp = true

            playdate.timer.performAfterDelay(1000, function()
                self.stopPlayerFromMoving = false
            end)
            self.cutsceneBar = false
        end)
    end
end

function CapsuleStart:signalDetectedMessage()


    if self.radarIsOn == true then
        self.buttonBlinkCounter += 1
        if self.buttonBlinkCounter > 20 then
            self.buttonBlinkCounter = 0
        end
        if self.buttonBlinkCounter > 16 and self.radarPage == 1 then
            self.buttonRight:moveTo(-200, 120)

        elseif self.buttonBlinkCounter <= 16 and self.radarPage == 1 then
            self.buttonRight:moveTo(200, 120)
            self.buttonLeft:moveTo(-200, 120)
        end
        if self.buttonBlinkCounter > 16 and self.radarPage == 2 then
            self.buttonLeft:moveTo(-200, 120)

        elseif self.buttonBlinkCounter <= 16 and self.radarPage == 2 then
            self.buttonLeft:moveTo(200, 120)
            self.buttonRight:moveTo(-200, 120)
        end

        if self.buttonBlinkCounter > 10 and self.radarIsOn == true then
            self.dotCover:add()
        else
            if roverisactive == false then

                self.dotCover:remove()
            end
        end

    end

end

function CapsuleStart:displayAButton()
    local actualX, actualY, collisions, collisionLength = self.kirkor:checkCollisions(self.kirkor.x,
        self.kirkor.y)


    if collisionLength > 0 and self.radarIsOn == false then
        if collisions[1].other:getTag() == (1) then
            self.bA.uiButtonIsEnabled = true
        end
    else

        self.bA.uiButtonIsEnabled = false
    end

    if self.bA.uiButtonIsEnabled == true and playdate.buttonJustPressed(playdate.kButtonA) then
        if roverisactive == false then
            self.notificationSound:play()
        end
        if self.radarIsOn and roverisactive == true then
            self.dotCover:add()
        end
        self.radarSprite:add()
        self.radarScreen1:add()
        self.radarScreen2:add()
        self.buttonLeft:add()
        self.buttonRight:add()
        self.radarIsOn = true

        self.stopPlayerFromMoving = true
    end

    if self.radarIsOn == true then
        self.bB.uiButtonIsEnabled = true
    else
        self.bB.uiButtonIsEnabled = false
    end

end

function CapsuleStart:fogIndex()
    if self.kosmonaut.kosmonautSprite.y < 190 then
        self.fogSprite:setZIndex(self.kosmonaut.kosmonautSprite:getZIndex() + 1)
        self.fogSprite2:setZIndex(self.kosmonaut.kosmonautSprite:getZIndex() + 1)
    else
        self.fogSprite:setZIndex(self.kosmonaut.kosmonautSprite:getZIndex() - 1)
        self.fogSprite2:setZIndex(self.kosmonaut.kosmonautSprite:getZIndex() - 1)
    end
end
