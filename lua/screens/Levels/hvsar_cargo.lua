import "lua/screens/screen"
import "lua/screens/level"
import "lua/kosmonaut"
import "CoreLibs/sprites"
import "lua/enemyScripts/gutter/gutter"
import "CoreLibs/crank"
import "CoreLibs/ui"


import "CoreLibs/timer"

class("Hvsar_Cargo").extends("Level")
local pd = playdate.graphics
local gfx <const> = playdate.graphics
local fogIterator = 4
local handIterator1 = 4
local rotatorAngle = 0
local blindStuckValueY = 35
local blindStuckValueYdown = 114
kosmonautCanMove = true



function Hvsar_Cargo:init()
    kosmonautCanMove = false
    Hvsar_Cargo.super.init(self, self.levelimage, self.imagecollisions)
    self.uiCrankNotify = gfx.image.new("images/ui/ui_use_crank")
    self.notifyEnabled = true
    self.notifyTimer = 0

    playdate.setCrankSoundsDisabled(disable)
    self.stuck = false
    self.rotatorBlockUp = 0
    self.rotatorBlockDown = 0

    self.stuckSound = playdate.sound.sampleplayer.new("sounds/8bit_hit")
    self.stuckSound:setVolume(0.5)

    self.blindSound = playdate.sound.fileplayer.new("sounds/8bit_blind_moving")
    self.blindSound:setVolume(0.3)
    -- under
    self.levelimage = gfx.image.new("images/hvsar_cargo/hvsar_cargo_screenshot")
    self.levelcollisions = gfx.image.new('images/blank_collisions')

    self.bA = ButtonUI(20, 220, "B")
    

    self.divider = gfx.sprite.new(gfx.image.new("images/hvsar_cargo/divider"))
    self.divider:setZIndex(10)
    self.divider:moveTo(195, 120)


    local hvsar_inside_image = gfx.image.new("images/hvsar_cargo/hvsar_inside")
    self.hvsar_inside = gfx.sprite.new(hvsar_inside_image)
    self.hvsar_inside:setZIndex(-8)
    self.hvsar_inside:moveTo(305, 114)

    self.hvsar_blind = gfx.sprite.new(gfx.image.new("images/hvsar_cargo/hvsar_blind")) --animated
    self.hvsar_blind:setZIndex(-7)
    self.hvsar_blind:moveTo(305, 114)

    self.hvsar_base = gfx.sprite.new(gfx.image.new("images/hvsar_cargo/hvsar_base"))
    self.hvsar_base:moveTo(200, 120)
    self.hvsar_base:setZIndex(-6)

    self.hvsar_shadow_overlay = gfx.sprite.new(gfx.image.new("images/hvsar_cargo/hvsar_shadow_overlay"))
    self.hvsar_shadow_overlay:setZIndex(-5)
    self.hvsar_shadow_overlay:moveTo(200, 120)

    self.hvsar_ground_front = gfx.sprite.new(gfx.image.new("images/hvsar_cargo/hvsar_ground_front"))
    self.hvsar_ground_front:setZIndex(-4)
    self.hvsar_ground_front:moveTo(200, 180)

    self.hvsar_cargo_crank = gfx.sprite.new(gfx.image.new("images/hvsar_cargo/hvsar_cargo_crank"))
    self.hvsar_cargo_crank:setZIndex(-3)
    self.hvsar_cargo_crank:moveTo(170, 150)



    self.hvsar_fog = gfx.sprite.new(gfx.image.new("images/hvsar_cargo/hvsar_fog")) --animated
    self.hvsar_fog:setZIndex(-2)
    self.hvsar_fog:setCenter(1, 0.5)
    self.hvsar_fog:moveTo(400, 180)


    self.hvsar_fog2 = gfx.sprite.new(gfx.image.new("images/hvsar_cargo/hvsar_fog")) --animated
    self.hvsar_fog2:setZIndex(-2)
    self.hvsar_fog2:setCenter(1, 0.5)
    self.hvsar_fog2:moveTo(0, 180)

    self.crank_hand = gfx.sprite.new(gfx.image.new("images/hvsar_cargo/crank_hand"))
    self.crank_hand:setZIndex(9)
    self.crank_hand:setCenter(0.53, 0.10)
    self.crank_hand:moveTo(30, 107)
    self.crank_hand:setClipRect(0, 0, 195, 240)

    self.crank_rotator = gfx.sprite.new(gfx.image.new("images/hvsar_cargo/crank_rotator"))
    self.crank_rotator:setZIndex(7)
    self.crank_rotator:setCenter(1, 0.5)
    self.crank_rotator:moveTo(103, 107)

    rotatorArc = playdate.geometry.arc.new(100, 107, 68, 270, 269, true)
    rotatorArcInverted = playdate.geometry.arc.new(100, 107, 68, 269, 270, false)

    self.crank_shadow = gfx.sprite.new(gfx.image.new("images/hvsar_cargo/crank_shadow"))
    self.crank_shadow:setZIndex(6)
    self.crank_shadow:moveTo(98, 120)

    self.crank_base = gfx.sprite.new(gfx.image.new("images/hvsar_cargo/crank_base"))
    self.crank_base:setZIndex(4)
    self.crank_base:moveTo(100, 120)

    self.crank_wd = gfx.sprite.new(gfx.image.new("images/hvsar_cargo/crank_wd40000"))
    self.crank_wd:setZIndex(11)
    self.crank_wd:moveTo(100, 299)

    self.crank_mask = gfx.sprite.new(gfx.image.new("images/hvsar_cargo/crank_mask"))
    self.crank_mask:setZIndex(2)

    self.rover_inside = true


    self.divider:moveTo(-5, self.divider.y)

    self.crank_base:moveTo(-100, self.crank_base.y)

    self.crank_shadow:moveTo(-102, self.crank_shadow.y)

    self.crank_rotator:moveTo(-97, self.crank_rotator.y)

    self.crank_hand:moveTo(self.crank_hand.x - 200, self.crank_hand.y)

    self.slideCounter = 0

    self.canRotate = false

    self.justEntered = false

    self.randomValForText = 1

    self.randomValForTextBool = true
    self.crankIndicator = false

    self.psst = playdate.sound.fileplayer.new("sounds/flower")
    self.wdTimer = 0
    self.crankPsstBool = true
    playdate.ui.crankIndicator:start()
    self.fontDisplay = gfx.font.new("font/Full Circle/font-full-circle")
    self.crankIcon = CrankIndicator()

end

function Hvsar_Cargo:updatework()
    self.bA:updateWork()

    if self.canRotate == true or self.justEntered == true then
        playdate.getCrankChange()

        self.handMovement(self)
        self.blindMovement(self)
    end
    if crankscreen.crankBool == true then
        blindStuckValueY = 35

    else
        blindStuckValueY = -60
    end

    Hvsar_Cargo.super.updatework(self)


    self.crank_hand:setClipRect(0, 0, self.divider.x, 240)
    self.fogMoving(self)
    self.loopFog(self)
    if self.divider.x == 195 and self.crank_wd.y > 297 then
        self.canRotate = true
    else
        self.canRotate = false
    end

    self.goBack(self)
    self.addCrankSpritesOnChange(self)
    self.releaseRover(self)


    self.kosmonaut.kosmonautSprite:remove()

end

function Hvsar_Cargo:draw()
    Hvsar_Cargo.super.draw(self)
    self.crankIcon:updateWork()
    if self.stuck == true and self.randomValForTextBool == true then
        self.bA.uiButtonIsEnabled = true
        self.randomValForText = math.random(1, 2)
        self.randomValForTextBool = false
    elseif self.stuck == false then
        self.randomValForTextBool = true
    end
    if self.stuck == true and self.hvsar_blind.y < 110 then
        if self.randomValForText == 1 then
            gfx.drawText(" The crank is very rusty ", 45, 200)
        elseif self.randomValForText == 2 then
            gfx.drawTextInRect(" Rust remover required ", 45, 200, 400, 20, nil, nil, self.fontDisplay)
        end
    else

    end

end

function Hvsar_Cargo:updateinput()

end

function Hvsar_Cargo:fadeInCompleted()

    Hvsar_Cargo.super.fadeInCompleted(self)
    self.kosmonaut.kosmonautSprite:remove()

end

function Hvsar_Cargo:blindMovement()

    if self.hvsar_blind.y < 120 and self.hvsar_blind.y > blindStuckValueY then
        if self.stuck == false then
            rotatorAngle += playdate.getCrankChange() * 0.5

        end

        self.playBlindSound(self)

        self.hvsar_blind:moveBy(0, -playdate.getCrankChange() * 0.1)

        if (rotatorAngle > 360 or rotatorAngle < -360) then
            rotatorAngle = 0
        end

        if self.hvsar_blind.y > blindStuckValueYdown and self.rotatorBlockDown < 10 then --ODBIJA KRATE W GÓRĘ
            self.hvsar_blind:moveTo(self.hvsar_blind.x, 111)
            self.stuckSound:play(1, 1)
            self.rotatorBlockDown += 1
        elseif self.rotatorBlockDown >= 10 then
            self.stuck = true
            self.hvsar_blind:moveTo(self.hvsar_blind.x, 114)
            if playdate.getCrankChange() > 0 then
                self.rotatorBlockDown = 0
                self.stuck = false
            end
        end

        if self.hvsar_blind.y < blindStuckValueY and self.rotatorBlockUp < 10 and crankscreen.crankBool == true then --ODBIJA KRATE W DÓŁ
            self.hvsar_blind:moveTo(self.hvsar_blind.x, blindStuckValueY + 4)
            self.rotatorBlockUp += 1
            self.stuckSound:play(1, 1)
            self.playBlindSound(self)

        elseif self.rotatorBlockUp >= 10 and crankscreen.crankBool == true then
            self.stuck = true
            self.hvsar_blind:moveTo(self.hvsar_blind.x, blindStuckValueY + 1)
            if playdate.getCrankChange() < 0 then
                self.rotatorBlockUp = 0
                self.stuck = false
            end
        elseif crankscreen.crankBool == false then
            self.stuck = false
            self.rotatorBlockUp = 0
        end
    end

end

function Hvsar_Cargo:handMovement()
    if self.hvsar_blind.y < 115 and self.hvsar_blind.y > blindStuckValueY and self.rotatorBlockUp < 10 and
        self.rotatorBlockDown < 10 then

        self.crank_rotator:setRotation(rotatorAngle)
        print("rotation angle", rotatorAngle)
        if (rotatorAngle > 0) then
            self.crank_hand:moveTo(rotatorArc:pointOnArc(rotatorAngle * 1.2))

        elseif (rotatorAngle < 0) then
            self.crank_hand:moveTo(rotatorArcInverted:pointOnArc(-rotatorAngle * 1.2))


        end

    end

end

function Hvsar_Cargo:fogMoving()
    fogIterator -= 1
    if fogIterator < 0 then
        self.hvsar_fog:moveBy(4, 0)
        self.hvsar_fog2:moveBy(4, 0)
        fogIterator = 3
    end
end

function Hvsar_Cargo:loopFog()
    if self.hvsar_fog.x >= 800 then
        self.hvsar_fog:moveTo(0, 180)
    end

    if self.hvsar_fog2.x >= 800 then
        self.hvsar_fog2:moveTo(0, 180)
    end
end

function Hvsar_Cargo:playBlindSound()
    if (
        playdate.getCrankChange() < 0 and self.rotatorBlockDown < 10 and self.canRotate == true or
            playdate.getCrankChange() > 0 and self.rotatorBlockUp < 10 and self.canRotate == true) then
        self.blindSound:play(1, 1)
        self.notifyEnabled = false
    else
        self.blindSound:stop()
    end
end

function Hvsar_Cargo:removeEnemies()
    Hvsar_Cargo.super.removeEnemies(self)
end

function Hvsar_Cargo:addEnemyBack()
    Hvsar_Cargo.super.addEnemyBack(self)
end

function Hvsar_Cargo:goBack()
    if playdate.buttonJustPressed(playdate.kButtonB) then
        if cargoendscreen.roverCollected == true then
            roverisactive = true
        end
       
        self.canRotate = false
        self.kosmonaut.posX = 80
        self.kosmonaut.posY = 98
        gfx.sprite:removeAll()
        cargoendscreen:fadeInWithAlpha(true)
        
        cargoendscreen.clRec = self.hvsar_blind.y +35
        self:changescreen(self, cargoendscreen)
        cargoendscreen.roverPosX = 100
        cargoendscreen.roverPosY = 160
        cargoendscreen.roverTargetX = 100
        cargoendscreen.roverTargetY = 160
        self.justEntered = true
        gfx.clear()
        self.removeEnemies(self)
        cargoendscreen:addEnemyBack()
        cargoendscreen:addDandelions()
        cargoendscreen.cargoImage:add()
        cargoendscreen.blindCargo:add()
        self.blindSound:stop()
        
        self.kosmonaut.currentAnimation = self.kosmonaut.animationWalkDown
        self.kosmonaut.spriteDirection = self.kosmonaut.IdleState.IdleDown
        if cargoendscreen.roverCollected == true then
            cargoendscreen.deadGutters:add()
        end

    end
end

function Hvsar_Cargo:releaseRover()
    if self.rover_inside == true and self.hvsar_blind.y < -50 then
        self.canRotate = false
        gfx.sprite.removeAll()
        self.blindSound:stop()
        self.rover_inside = false
        cargoendroverscreen:loadAssets()

        cargoendroverscreen:fadeInWithAlpha(true)
        self:changescreen(self, cargoendroverscreen, gfx.image.kDitherTypeBayer8x8)
        gfx.clear()

        cargoendroverscreen:addEnemyBack()
        cargoendscreen:addDandelions()
        self.slideCounter = 0
        self.blindSound:stop()
        self.kosmonaut.posY = 64
        self.kosmonaut.posX = 172

        self.kosmonaut.spriteDirection = self.kosmonaut.IdleState.IdleDown
        self.kosmonaut.currentAnimation = self.kosmonaut.animationUse
        self.kosmonaut.currentAnimation:updateFrame()
    end
end

function Hvsar_Cargo:addSpritesOnChange()
    self.handMovement(self)
    self.hvsar_fog:add()
    self.hvsar_fog2:add()

    self.hvsar_base:add()
    self.hvsar_ground_front:add()
    self.hvsar_shadow_overlay:add()
    if self.rover_inside == true then
        self.hvsar_inside:add()
    end
    self.hvsar_blind:add()
    self.hvsar_cargo_crank:add()

end

function Hvsar_Cargo:addCrankSpritesOnChange()

    if playdate.isCrankDocked() == false and self.justEntered == false then

        self.divider:add()
        self.crank_base:add()
        self.crank_shadow:add()
        self.crank_rotator:add()
        self.crank_hand:add()
        self.crankSlideIn(self)




    elseif playdate.isCrankDocked() == true and self.canRotate == true or self.justEntered == true then

        self.divider:moveTo(-5, self.divider.y)
        self.divider:remove()
        self.crank_base:moveTo(-100, self.crank_base.y)
        self.crank_base:remove()
        self.crank_shadow:moveTo(-102, self.crank_shadow.y)
        self.crank_shadow:remove()
        self.crank_rotator:moveTo(-97, self.crank_rotator.y)
        self.crank_rotator:remove()
        self.crank_hand:moveTo(self.crank_hand.x - 200, self.crank_hand.y)
        self.crank_hand:remove()
        self.slideCounter = 0
        self.canRotate = false
        self.justEntered = false

    end
end

function Hvsar_Cargo:crankSlideIn()
    if currentscreen == hvsar_cargo then
        self.slideCounter += 1
        if self.slideCounter < 51 then
            self.divider:moveTo(self.divider.x + 4, self.divider.y)
            self.crank_base:moveTo(self.crank_base.x + 4, self.crank_base.y)
            self.crank_shadow:moveTo(self.crank_shadow.x + 4, self.crank_shadow.y)
            self.crank_rotator:moveTo(self.crank_rotator.x + 4, self.crank_rotator.y)
            self.crank_hand:moveTo(self.crank_hand.x + 4, self.crank_hand.y)
        end

        if self.slideCounter > 51 then
            if self.crankPsstBool == true then
                self.usingSpray(self)
            end
        end
    end

end

function Hvsar_Cargo:restart()
    self.rover_inside = true

    self.crank_hand:moveTo(30, 107)

    self.divider:moveTo(-5, self.divider.y)

    self.crank_base:moveTo(-100, self.crank_base.y)

    self.crank_shadow:moveTo(-102, self.crank_shadow.y)

    self.crank_rotator:moveTo(-97, self.crank_rotator.y)

    self.crank_hand:moveTo(self.crank_hand.x - 200, self.crank_hand.y)

    self.slideCounter = 0

    self.canRotate = false

    self.justEntered = false

    self.stuck = false


end

function Hvsar_Cargo:usingSpray()
    if self.kosmonaut.crankCollected == true then

        if self.crank_wd.y > 170 and self.wdTimer < 180 then
            self.crank_wd:moveTo(self.crank_wd.x, self.crank_wd.y - 5)
            self.canRotate = false
            self.blindSound:stop()
        end

        self.wdTimer += 1
        self.crank_wd:add()
        if self.wdTimer == 60 or self.wdTimer == 120 or self.wdTimer == 150 then
            self.psst:play()
        end
        if self.wdTimer > 180 then

            if self.crank_wd.y < 400 then
                self.crank_wd:moveTo(self.crank_wd.x, self.crank_wd.y + 5)
            end
            if self.crank_wd.y > 380 then
                self.crankPsstBool = false
                self.canRotate = true

                hvsar_cargo.kosmonaut:removeFromInventory("wd40000")
                hvsar_cargo.kosmonaut.wdSpriteIcon:remove()
            end
        end
    end
end

function Hvsar_Cargo:basicPosition()
    rotatorAngle = 323.25
    self.crank_rotator:setRotation(323.25)
    self.crank_hand:moveTo(43.07487 - 200, 144.1958)

end
