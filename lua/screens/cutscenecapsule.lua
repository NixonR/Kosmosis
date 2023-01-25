import "lua/screens/screen"
import "CoreLibs/sprites"


class("CutsceneCapsule").extends("Screen")

local gfx <const> = playdate.graphics
local screenBuffor = 30

function CutsceneCapsule:init()

    CutsceneCapsule.super.init(self)
    self.fadeInTime_ms = 800
    self.capsuleScene = gfx.image.new("images/cutscenes/cutscene_intro_kirkor")
    self.gx = 0
    self.black = gfx.image.new("images/blank_collisions")
    self.delayTimer = 0
    self.delay = 0
    self.changed = false
    self.cutTimer = 0
    self.canFade = false
    self.blackAlphaValue = 0
    self.text1 = TextDisplay(20, 200, " DEFENSELESS AND TERRIFIED YOU SLOWLY ")
    self.text2 = TextDisplay(20, 215, " RAISE FROM KIRKOR RESCUE CAPSULE. ")
    self.text3 = TextDisplay(20, 215, " MIRACLE OR A CURSE? ")
    self.text3.textDelayValue = 4
end

function CutsceneCapsule:updateinput()

    screenBuffor -= 1
    if screenBuffor < 20 and playdate.buttonJustPressed(playdate.kButtonA) or self.cutTimer > 500 then
        if self.changed == false then
            playdate.timer.performAfterDelay(5000, function()
                capsulestartscreen:fadeInWithAlpha(true)
                self:changescreen(capsulestartscreen)
                
            end)

            screenBuffor = 30
            gfx.clear()
        end
        self.changed = true
        self.canFade = true
        bg1:setVolume(0.6)
      
    end
end

function CutsceneCapsule:startFadeIn()

    CutsceneCapsule.super.startFadeIn(self)

end

function CutsceneCapsule:updatework()
    print(self.cutTimer, "cuttimer")
    if self.gx > -134 then
        self.gx -= 1

    end

    if self.blackAlphaValue < 1 and self.canFade == true then
        self.blackAlphaValue += 0.02
    end

    self.cutTimer += 1

end

function CutsceneCapsule:draw()
    CutsceneCapsule.super.draw()

    gfx.clear()
    gfx.sprite:removeAll()
    self.capsuleScene:draw(self.gx, 0)

    if self.cutTimer > 10 and self.cutTimer < 300 then
        self.text1:updateWork()
        self.text1:draw()
    end
    if self.cutTimer > 140 and self.cutTimer < 300  then
        self.text2:updateWork()
        self.text2:draw()
    end

    if self.cutTimer > 300  then
        self.text3:updateWork()
        self.text3:draw()
    end

    if self.canFade == true then
        self.black:drawFaded(0, 0, self.blackAlphaValue, gfx.image.kDitherTypeHorizontalLine)
    end

end
