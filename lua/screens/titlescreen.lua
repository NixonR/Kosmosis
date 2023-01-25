import "lua/screens/screen"
import "lua/statesFramework/teststate"
import "lua/statesFramework/teststate2"
import "lua/buttonui"
import "lua/crankindicator"

class("Titlescreen").extends("Screen")

local gfx <const> = playdate.graphics
bg1 = playdate.sound.fileplayer.new("sounds/bg2")
bg2 = playdate.sound.fileplayer.new("sounds/caveAmbient")
function Titlescreen:init()
    print("debugging time")
    Titlescreen.super.init(self)

    self.titlescreenimage = nil

    --states test
    --call constructor with the object to control
    --self.stateTest = TestState(self.titlescreenimage)
    --self.stateTest2 = TestState2(self.titlescreenimage)
    --self.currentState = self.stateTest:changeState(self.currentState, self.stateTest)
    self.iris = gfx.image.new("images/titlescreen/titlescreen_iris")
    self.shake = 72
    self.tim = 0
    self.iterator = 0
    self.iteratorFade = 0

    self.black = gfx.image.new("images/blank_collisions")
    self.canFade = false
    self.changed = false
    self.aButton = gfx.image.new("images/ui/A_button")
    -------------
end

function Titlescreen:loadAssets()
    self.titlescreenimage = gfx.image.new('images/titlescreen/titlescreen')
end

function Titlescreen:releaseAssets()
    self.titlescreenimage = nil
end
 
function Titlescreen:updateinput()

    --states test
    if (playdate.buttonJustPressed(playdate.kButtonB)) then
        --self.currentState = self.currentState:changeState(self.currentState, self.stateTest2)
    end
    -------------
    
    
    if (playdate.buttonJustPressed(playdate.kButtonA)) then
        bg1:play(0)
        
        gfx.clear()
        --flowervalleyscreen:fadeInWithAlpha(true)
        if self.changed == false then
            playdate.timer.performAfterDelay(40, function()
                
                self:changescreen(firstintroscreen)
            end)
        end
        
        self.changed = true
        screenBuffor = 30
        self.canFade = true
    end
end

function Titlescreen:updatework()
    -- shipscreen:loadAssets()
    -- shipscreen.kosmonaut.posY = 120
    -- shipscreen.kosmonaut.posX = 120
    self.iterator += 1
    if self.iterator > 3 then
        self.tim += 1
        if self.tim % 3 > 0 then
            self.shake = 71

        else
            self.shake = 70

        end
        self.iterator = 0
    end

    if self.iteratorFade < 1 and self.canFade == true then
        self.iteratorFade += 0.1
    end


    --self.currentState:work()

end

function Titlescreen:draw()

    gfx.clear()

    self.titlescreenimage:draw(0, 0)
    self.iris:draw(37, self.shake)

    if (self:isWork()) then
        gfx.drawTextInRect(" Press    to start ", 88, 215, 300, 40)
    end
    self.aButton:draw(189,215)
    if self.canFade == true then
        self.black:drawFaded(0, 0, self.iteratorFade, gfx.image.kDitherTypeHorizontalLine)
    end
end
