import "lua/screens/screen"
import "CoreLibs/sprites"


class("CutsceneWelcome").extends("Screen")

local gfx <const> = playdate.graphics
local screenBuffor = 30

function CutsceneWelcome:init()

    CutsceneWelcome.super.init(self)

    self.welcome = gfx.image.new('images/cutscenes/cutscene_hvsar_welcome')
    self.welcomeCounter = 0

    self.roverSound = playdate.sound.sampleplayer.new("sounds/husar102")
    
end

function CutsceneWelcome:updateinput()

    screenBuffor -= 1
    if (screenBuffor < 0 and playdate.buttonJustPressed(playdate.kButtonA)) or self.welcomeCounter > 120 then

        --tobecontinuedscreen:fadeInWithAlpha(true)
        self:changescreen(aimscreen)
        screenBuffor = 30
        self.welcomeCounter = 0

        gfx.clear()


    end
end

function CutsceneWelcome:startFadeIn()

    CutsceneWelcome.super.startFadeIn(self)

end

function CutsceneWelcome:fadeInCompleted()
    
    CutsceneWelcome.super.fadeInCompleted(self)
    self.roverSound:play()
end

function CutsceneWelcome:updatework()
    self.welcomeCounter+=1
end

function CutsceneWelcome:draw()

    gfx.clear()
    self.welcome:draw(0, 0)
    gfx.drawText(" Hvsar 102 activated ", 70, 220)

end
