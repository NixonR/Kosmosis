import "lua/screens/screen"
import "lua/screens/level"
import "lua/kosmonaut"
import "CoreLibs/sprites"
import "lua/enemyScripts/gutter/gutter"
import "CoreLibs/crank"
import "CoreLibs/graphics"
import "CoreLibs/ui"

local gfx <const> = playdate.graphics

class("CapsuleInside").extends("Level")

function CapsuleInside:init()
    CapsuleInside.super.init(self)
    self.levelcollisions = gfx.image.new("images/blank_collisions")
    self.fadeInTime_ms = 5000
    self.fadeOutTime_ms = 2000
    self.bgImage = gfx.image.new("images/capsule_kirkor/bgImage")
    self.skyImage = gfx.image.new("images/capsule_kirkor/bg")
    self.sky = gfx.sprite.new(self.skyImage)
    self.sky:moveTo(200, 120)
    self.sky:setZIndex(20)
    self.levelimage = self.bgImage

    self.blind = gfx.sprite.new(gfx.image.new("images/capsule_kirkor/blind"))
    self.blind:setCenter(0, 0)
    self.blind:moveTo(0, 0)
    self.blind:setZIndex(30)
    self.blind:setClipRect(0, 0, 400, 240)

    self.front = gfx.sprite.new(gfx.image.new("images/capsule_kirkor/front"))

    self.front:moveTo(200, 120)
    self.front:setZIndex(40)

    self.text = gfx.sprite.new(gfx.drawTextInRect("_Press_ *A* _to restart_", 88, 215, 300, 40, nil, nil,
        kTextAlignment.center))
    self.text:setZIndex(100)
    self.text:moveTo(200, 120)

    self.blindOpen = false
    self.counterBlindUp = 0

    self.lookingUpCounter = 0
    self.lookingRightCounter = 0
    self.lookingDownCounter = 0
    self.lookingLeftCounter = 0
    self.lookingDistance = 10
    self.escape = false --true if blind is open and kosmonaut can escape from capsule
    self.changed = false

    self.breathSlow = playdate.sound.fileplayer.new("sounds/breathSlow")

    self.breathSlow:setVolume(0.3)

    self.crateMechanismSound = playdate.sound.fileplayer.new("sounds/crateMechanism")
    self.clothSound = playdate.sound.fileplayer.new("sounds/clothSound")
    self.metalImpact = playdate.sound.fileplayer.new("sounds/metalImpact")
    self.steamSound = playdate.sound.fileplayer.new("sounds/steamSound")
    self.doorClosing = playdate.sound.fileplayer.new("sounds/doorClosing")
    self.it = 0
    self.scaleFrontCounter = 0

    self.textX = 50
    self.textY = -8

    self.aButton = gfx.image.new("images/ui/A_button")

    playdate.ui.crankIndicator:start()
    self.kosmonaut.canRotate = false

    self.black = gfx.image.new("images/blank_collisions")
    self.canFade = false
    self.blackAlphaValue = 0
    self.stopPlayerFromMoving = true

    self.bA = ButtonUI(380, 220, "A")
    self.crankIcon = CrankIndicator()
    self.openTextCounter = 0
end

function CapsuleInside:updateinput()

    if playdate.buttonJustPressed(playdate.kButtonA) then
        if self.blindOpen == false then
            self.steamSound:play()
        end
        self.blindOpen = true

    end
    self.movingBlindRight(self)
    self.shakingHead(self)


    if self.scaleFrontCounter > 340 and playdate.buttonJustPressed(playdate.kButtonA) or self.scaleFrontCounter > 450 then ----------CHANGE SCENE
        self:changescreen(currentscreen, cutscenecapsulescreen, gfx.image.kDitherTypeBayer8x8)
        bg1:setVolume(0.2)
        bg1:play(0)
        screenBuffor = 30
        gfx.clear()
        gfx.sprite:removeAll()
        self.changed = true
        
    end


end

function CapsuleInside:updatework()
    CapsuleInside.super.updatework(self)

    self.sky:add()
    self.blind:add()

    if self.scaleFrontCounter < 150 then
        self.front:add()
    else
        self.front:remove()
    end


    self.movingBlindUp(self)
    self.playSound(self)
    self.goingOut(self)
    if self.openTextCounter < 50 then
        self.openTextCounter += 1
    end



    self.text:add()



end

function CapsuleInside:draw()

    CapsuleInside.super.draw()
    
    if self.blindOpen == false and self.openTextCounter > 40 then
        self.bA.glyphA:draw(375, 215)
        gfx.drawText("open", 310, 215)
        
    end
    
    if self.canFade == true and self.scaleFrontCounter < 160 or self.scaleFrontCounter > 299 then
        self.black:drawFaded(0, 0, self.blackAlphaValue, gfx.image.kDitherTypeBayer8x8)
    end
    if (self.blindOpen == true and self.blind.x < 349) then

        self.crankIcon:updateWork()
    end
end

function CapsuleInside:fadeInCompleted()

    CapsuleInside.super.fadeInCompleted(self)
    self.kosmonaut.kosmonautSprite:remove()

end

function CapsuleInside:shakingHead()
    ----KIWANIE GŁOWĄ
    if self.lookingRightCounter < self.lookingDistance then
        if playdate.buttonIsPressed(playdate.kButtonRight) then

            self.blind:moveTo(self.blind.x - 4, self.blind.y)

            self.front:moveTo(self.front.x - 4, self.front.y)

            self.sky:moveTo(self.sky.x - 4, self.sky.y)
            self.textX -= 4
            self.lookingRightCounter += 1
        end
    end
    if self.lookingRightCounter > 0 and playdate.buttonIsPressed(playdate.kButtonRight) == false then
        self.blind:moveTo(self.blind.x + 4, self.blind.y)

        self.front:moveTo(self.front.x + 4, self.front.y)

        self.sky:moveTo(self.sky.x + 4, self.sky.y)
        self.textX += 4
        self.lookingRightCounter -= 1
        print(self.lookingRightCounter)
    end

    if self.lookingLeftCounter < self.lookingDistance then
        if playdate.buttonIsPressed(playdate.kButtonLeft) then
            self.blind:moveTo(self.blind.x + 4, self.blind.y)

            self.front:moveTo(self.front.x + 4, self.front.y)

            self.sky:moveTo(self.sky.x + 4, self.sky.y)
            self.textX += 4
            self.lookingLeftCounter += 1
        end
    end
    if self.lookingLeftCounter > 0 and playdate.buttonIsPressed(playdate.kButtonLeft) == false then
        self.blind:moveTo(self.blind.x - 4, self.blind.y)

        self.front:moveTo(self.front.x - 4, self.front.y)

        self.sky:moveTo(self.sky.x - 4, self.sky.y)
        self.lookingLeftCounter -= 1
        self.textX -= 4
        print(self.lookingLeftCounter)
    end

    if self.lookingUpCounter < self.lookingDistance then
        if playdate.buttonIsPressed(playdate.kButtonUp) then
            self.blind:moveTo(self.blind.x, self.blind.y + 4)

            self.front:moveTo(self.front.x, self.front.y + 4)

            self.sky:moveTo(self.sky.x, self.sky.y + 4)
            self.textY += 4
            self.lookingUpCounter += 1
        end
    end
    if self.lookingUpCounter > 0 and playdate.buttonIsPressed(playdate.kButtonUp) == false then
        self.blind:moveTo(self.blind.x, self.blind.y - 4)

        self.front:moveTo(self.front.x, self.front.y - 4)

        self.sky:moveTo(self.sky.x, self.sky.y - 4)
        self.textY -= 4
        self.lookingUpCounter -= 1
    end

    if self.lookingDownCounter < self.lookingDistance then
        if playdate.buttonIsPressed(playdate.kButtonDown) then

            self.blind:moveTo(self.blind.x, self.blind.y - 4)

            self.front:moveTo(self.front.x, self.front.y - 4)

            self.sky:moveTo(self.sky.x, self.sky.y - 4)
            self.textY -= 4
            self.lookingDownCounter += 1
        end
    end
    if self.lookingDownCounter > 0 and playdate.buttonIsPressed(playdate.kButtonDown) == false then
        self.blind:moveTo(self.blind.x, self.blind.y + 4)

        self.front:moveTo(self.front.x, self.front.y + 4)

        self.sky:moveTo(self.sky.x, self.sky.y + 4)
        self.textY += 4
        self.lookingDownCounter -= 1
    end
end

function CapsuleInside:playSound()

    if self.scaleFrontCounter == 35 or self.scaleFrontCounter == 95 or self.scaleFrontCounter == 130 then
        self.clothSound:play(1)
        self.breathSlow:setVolume(0.1)
     
    end
    if self.scaleFrontCounter < 130 then
        self.breathSlow:play()
    end
    if self.blind.x == 350 then
        self.metalImpact:play()
        self.breathSlow:setVolume(0.2)
    end



end

function CapsuleInside:movingBlindUp()
    if self.blindOpen == true then --właz przesuwa się do góry
        if self.counterBlindUp < 36 then
            self.counterBlindUp += 1
            if self.counterBlindUp % 3 == 0 and self.counterBlindUp > 10 then
                self.blind:moveTo(self.blind.x, self.blind.y - 2)
            end
            print("upp")
        end
    end
end

function CapsuleInside:goingOut()
    if self.blind.x > 350 then
        self.scaleFrontCounter += 1
        self.escape = true
        self.front:setClipRect(0, 0, 400, 240)

    end

    if self.scaleFrontCounter > 30 and self.scaleFrontCounter < 150 then
        if self.blackAlphaValue < 1 and self.canFade == true then
            self.blackAlphaValue += 0.1
            if self.blackAlphaValue > 0.9 then
                self.blackAlphaValue = 1
            end
        end
        self.canFade = true

    end



    if self.scaleFrontCounter > 150 and self.scaleFrontCounter < 300 then
        if self.blackAlphaValue > 0 and self.canFade == true then

            self.blackAlphaValue -= 0.1
            if self.blackAlphaValue < 0.2 then
                self.blackAlphaValue = 0
            end
        end

    end
    if self.scaleFrontCounter == 150 then
        self.blind:moveTo(self.blind.x, self.blind.y - 20)

        self.front:moveTo(self.front.x, self.front.y - 20)

        self.sky:moveTo(self.sky.x, self.sky.y - 20)

        self.lookingDownCounter = 5
    end

    if self.scaleFrontCounter > 299 then
        if self.blackAlphaValue < 1 then
            self.blackAlphaValue += 0.02
            if self.blackAlphaValue > 0.9 then
                self.blackAlphaValue = 1
            end
        end
    end

end

function CapsuleInside:movingBlindRight()
    if playdate.getCrankChange() > 1 and self.blindOpen == true then
        self.blind:moveTo(self.blind.x + 2, self.blind.y)
        if self.blind.x < 350 then
            self.crateMechanismSound:play(1)
        elseif playdate.getCrankChange() == 0 or self.blind.x > 349 then
            self.crateMechanismSound:pause(1)
        end
    else
        self.crateMechanismSound:pause()
    end
    if playdate.getCrankChange() < 0 and self.blindOpen == true and self.blind.x > 1 and self.blind.x < 341 then
        self.blind:moveTo(self.blind.x - 2, self.blind.y)
        if self.blind.x > 2 then
            self.crateMechanismSound:play(1)
        elseif playdate.getCrankChange() == 0 then
            self.crateMechanismSound:pause(1)
        end
        if self.blind.x == 2 then
            self.crateMechanismSound:play(1)
            self.doorClosing:play()

        end
    end
end
