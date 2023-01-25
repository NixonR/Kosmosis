import "lua/screens/screen"


class("FirstIntroScreen").extends("Screen")

local gfx <const> = playdate.graphics
local screenBuffor = 30

function FirstIntroScreen:init()
    FirstIntroScreen.super.init(self)
    self.firstIntroScreenImage = gfx.image.new('images/blank_collisions')
    self.fadeInTime_ms = 2000
    self.fadeOutTime_ms = 3000
    self.screenDelay = 0
    
    

end

function FirstIntroScreen:updateinput()
    --print(screenBuffor)
    screenBuffor -= 1
    if (screenBuffor < 20 and playdate.buttonJustPressed(playdate.kButtonA) or screenBuffor <-120) then
       -- print("times")
        --secondintroscreen:fadeInWithAlpha(true)

        self:changescreen(secondintroscreen);
        screenBuffor = 30
        self.screenDelay = 0

        -- waterfallscreen:loadAssets()
        -- shortscreen:loadAssets()
        -- dasherscreen:loadAssets()
        -- shipscreen:loadAssets()
        --dandelionsscreen:loadAssets()
        -- playdate.timer.performAfterDelay(100, function()
            
        --     if self.currentVolume < 0.2 then
                
        --         print("times2")
        --     end
        -- end)

    end
end
function FirstIntroScreen:loadAssets()
    self.firstIntroScreenImage = gfx.image.new('images/blank_collisions')
end

function FirstIntroScreen:releaseAssets()
    self.firstIntroScreenImage = nil
end
function FirstIntroScreen:startFadeIn()

    FirstIntroScreen.super.startFadeIn(self)

end

function FirstIntroScreen:updatework()
    
end

function FirstIntroScreen:draw()
    self.screenDelay += 1
    gfx.clear()



    gfx.drawTextInRect("'But the children of the Kingdom will be cast out to outer darkness; there will be weeping and gnashing of teeth.' Matt. 8:12 KJV"
        , 50, 60, 300, 200, nil, nil, kTextAlignment.center)



end
