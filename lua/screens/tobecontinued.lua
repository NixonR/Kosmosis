import "lua/screens/screen"
import "CoreLibs/sprites"


class("ToBeContinued").extends("Screen")

local gfx <const> = playdate.graphics
local screenBuffor = 30

function ToBeContinued:init()

    ToBeContinued.super.init(self)
    self.delay = 0
    --self.welcome = gfx.image.new('images/cutscenes/cutscene_hvsar_welcome')
    self.tobeSound = playdate.sound.fileplayer.new("sounds/mainBlink")
    self.horn = playdate.sound.fileplayer.new("sounds/trailerFinish")
    self.horn:setVolume(0.5)
    self.bA = ButtonUI(380, 220, "A")
    self.black = gfx.image.new("images/blank_collisions")
    self.fadeBlackDelayTimer = 0
    self.blackAlphaValue = 1
    self.credits = false
    self.restartGame = false
    self.restartingText = false

    self.stepSound = playdate.sound.sampleplayer.new("sounds/8bit_step2")
    self.stepSound:setVolume(0.1)
    self.fontDisplay = gfx.font.new("font/Full Circle/font-full-circle")
end

function ToBeContinued:updateinput()

    screenBuffor -= 1

    -- if (self.credits == true and screenBuffor < 0 and playdate.buttonJustPressed(playdate.kButtonA) ) then

    --     self.tobeSound:play()
    --     --cargoendroverscreen:fadeInWithAlpha(true)
    --     self:changescreen(titlescreen)
    --     screenBuffor = 30
    bg1:stop()

    --     gfx.clear()


    -- end
    if playdate.buttonJustPressed(playdate.kButtonA) and self.credits == true then
        self.restartingText = true
        playdate.timer.performAfterDelay(1000, function()
            self.restartGame = true
        end)
        self.stepSound:play()
    end
    if playdate.buttonJustPressed(playdate.kButtonA) and self.credits == false then
        self.credits = true
        self.stepSound:play()
    end
end

function ToBeContinued:startFadeIn()

    ToBeContinued.super.startFadeIn(self)

end

function ToBeContinued:updatework()

    if self.fadeBlackDelayTimer == 30 then
        self.horn:play()
    end
    self.fadeBlackDelayTimer += 1
    print(self.credits, "credits")
    print(self.restartGame, "restart")
    if self.blackAlphaValue > 0 and self.fadeBlackDelayTimer > 200 then
        self.blackAlphaValue -= 0.06
        if self.blackAlphaValue < 0.1 then
            self.blackAlphaValue = 0
        end
    end
end

function ToBeContinued:draw()

    gfx.clear()
    if self.credits == false then
        self.bA.glyphA:draw(375, 215)
        gfx.drawTextInRect("THANKS FOR PLAYING     To be continued.", 50, 90, 300, 200, nil, nil, kTextAlignment.center)
    end
    if self.credits == true then
        gfx.drawTextInRect(" Bulbware 20220 © DIRECTION+ART | Simon Lukasik    CODE | Artur Mikolajczyk, Lukasz Kot"
            , 10
            , 90, 380, 200, nil, nil, kTextAlignment.center, nil, nil, self.fontDisplay)
        if self.restartingText == false then
            gfx.drawTextInRect(" restart"
                , 260
                , 215, 380, 200, nil, nil, kTextAlignment.left, nil, nil, self.fontDisplay)
                self.bA.glyphA:draw(375, 215)
        end

    end
    if self.restartingText == true then
        gfx.drawTextInRect(" restarting..."
            , 10
            , 215, 380, 200, nil, nil, kTextAlignment.right)
    end
    self.black:drawFaded(0, 0, self.blackAlphaValue, gfx.image.kDitherTypeHorizontalLine)


end
