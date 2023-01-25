import "lua/screens/screen"


class("CutsceneSecret").extends("Screen")

local gfx <const> = playdate.graphics
local screenBuffor = 30

function CutsceneSecret:init()
    CutsceneSecret.super.init(self)
    
    self.fadeInTime_ms = 2000

end

function CutsceneSecret:updateinput()

    screenBuffor -= 1
    if (screenBuffor < 0 and playdate.buttonJustPressed(playdate.kButtonA)) then

        secretscreen:fadeInWithAlpha(true)
        self:changescreen(secretscreen);
        screenBuffor = 30
    end
end

function CutsceneSecret:startFadeIn()

    CutsceneSecret.super.startFadeIn(self)

end

function CutsceneSecret:updatework()

end

function CutsceneSecret:draw()

    gfx.clear()
    

    gfx.drawTextInRect("ASSAULT BUMPER container Hvsar.102", 50, 100, 300, 200, nil, nil, kTextAlignment.center)



end
