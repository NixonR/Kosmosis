import "lua/screens/screen"
import "CoreLibs/sprites"


class("CutsceneCrash").extends("Screen")

local gfx <const> = playdate.graphics
local screenBuffor = 30

function CutsceneCrash:init()

    CutsceneCrash.super.init(self)


    self.capsules = gfx.image.new('images/cutscenes/cutscene_intro_destruction/capsules')
    self.cosmonaut = gfx.image.new('images/cutscenes/cutscene_intro_destruction/cosmonaut')
    self.explosion = gfx.image.new('images/cutscenes/cutscene_intro_destruction/explosion')
    self.hvsar = gfx.image.new('images/cutscenes/cutscene_intro_destruction/hvsar')
    self.rosary = gfx.image.new('images/cutscenes/cutscene_intro_destruction/rosary')
    self.panelTimer = 0
    self.heartbeat = playdate.sound.fileplayer.new('sounds/heartbeat')
    self.crash = playdate.sound.fileplayer.new('sounds/capsuleCrash')
    self.alphaValue1 = 0
    self.alphaValue2 = 0
    self.alphaValue3 = 0
    self.alphaValue4 = 0
    self.alphaValue5 = 0
    self.text1 = TextDisplay(20, 200, "UNKNOWN MALFUNCTION CAUSES ")
    self.text2 = TextDisplay(20, 215, "ULTIMATE DESTRUCTION OF NSS COPERNICUS")
    self.posX = 0
    self.pcWarning = playdate.sound.fileplayer.new("sounds/warning2")
    self.pcWarning:setVolume(0.1)
    self.eject = playdate.sound.fileplayer.new("sounds/eject")
    self.eject:setVolume(0.1)
    self.capsuleReady = playdate.sound.fileplayer.new("sounds/capsuleReady")
    self.capsuleReady:setVolume(0.2)
end

function CutsceneCrash:updateinput()
    screenBuffor -= 1
    if screenBuffor < 20 and playdate.buttonJustPressed(playdate.kButtonA) or self.panelTimer > 650 then

        capsuleinsidescreen:fadeInWithAlpha(true)
        self:changescreen(capsuleinsidescreen)
        gfx.sprite:removeAll()
        -- playdate.timer.performAfterDelay(1000, function()

        -- end)
        self.fadeOutTime_ms = 5000
        self.fadeInTime_ms = 5000
        screenBuffor = 30
        gfx.clear()
        aimscreen:loadAssets()
        --plainsscreen:loadAssets()

    end

end

function CutsceneCrash:startFadeIn()

    CutsceneCrash.super.startFadeIn(self)

end

function CutsceneCrash:updatework()
    self.panelTimer += 1
    if self.panelTimer < 450 then
        self.heartbeat:play()
    end
    if self.panelTimer % 50 == 0 and self.panelTimer < 280 then

        self.pcWarning:play()
    end
    if self.panelTimer == 400 then
        self.crash:play()
    end

end

function CutsceneCrash:draw()
    gfx.clear()





    if self.panelTimer > 100 then
        if self.alphaValue1 < 1 then
            self.alphaValue1 += 0.05
        end
        self.capsules:drawFaded(0, 0, self.alphaValue1, gfx.image.kDitherTypeHorizontalLine)
    end

    if self.panelTimer > 200 then
        if self.alphaValue2 < 1 then
            self.alphaValue2 += 0.05
        end
        self.cosmonaut:drawFaded(0, 0, self.alphaValue2, gfx.image.kDitherTypeHorizontalLine)
    end

    if self.panelTimer > 230 then
        if self.alphaValue3 < 1 then
            self.alphaValue3 += 0.05
        end
        self.rosary:drawFaded(0, 0, self.alphaValue3, gfx.image.kDitherTypeHorizontalLine)
    end

    if self.panelTimer > 260 then
        if self.alphaValue4 < 1 then
            self.alphaValue4 += 0.05
        end

        self.text1:updateWork()
        self.text1:draw()
        self.hvsar:drawFaded(0, 0, self.alphaValue4, gfx.image.kDitherTypeHorizontalLine)
    end

    if self.panelTimer == 280 then
        self.capsuleReady:play()
    end

    if self.panelTimer == 350 then
        self.eject:play()
    end

    if self.panelTimer > 400 then
        self.posX += 2
        if self.posX > 2 then
            self.posX = 0
        end
        if self.alphaValue5 < 1 then
            self.alphaValue5 += 0.05
        end
        self.text2:updateWork()
        self.text2:draw()
        self.explosion:drawFaded(self.posX, 0, self.alphaValue5, gfx.image.kDitherTypeHorizontalLine)
    end
end
