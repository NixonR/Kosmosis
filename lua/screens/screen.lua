import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/frameTimer"






class("Screen").extends()

local gfx <const> = playdate.graphics

currentscreen = nil
fadetargetscreen = nil
fadeRenderToTexture = gfx.image.new(400, 240)



function Screen:init()
    self.State = {
        FADEIN = 1,
        FADEOUT = 2,
        WORK = 3,
        HIDDEN = 4,
    }
    self.state = self.State.HIDDEN
    self.fadeInTime_ms = 400
    self.fadeOutTime_ms = 400
    self.timerStamp = 0
    self.progress = 0



end

function Screen:isWork()
    return self.state == self.State.WORK
end

function Screen:getFadeProgress()
    return self.progress
end

function Screen:firstscreen()
    currentscreen = self;
    currentscreen:startFadeIn()
end

function Screen:changescreen(target)
    fadetargetscreen = target
    currentscreen:startFadeOut()
end

-- Fade In
function Screen:startFadeIn()
    self.timerStamp = playdate.getCurrentTimeMilliseconds()
    self.progress = 0;
    self.state = self.State.FADEIN;

    self:loadAssets()

    gfx.pushContext(fadeRenderToTexture)
    currentscreen:draw()
    gfx.popContext()
end

function Screen:updateFadeIn()
    self.progress = (playdate.getCurrentTimeMilliseconds() - self.timerStamp) / self.fadeInTime_ms
    if (self.progress > 1) then
        self.progress = 1;
        self:fadeInCompleted()
    end
end

function Screen:fadeInCompleted()
    self.state = self.State.WORK;
end

function Screen:drawFadeIn()

    gfx.clear()
    fadeRenderToTexture:drawFaded(0, 0, self:getFadeProgress(), gfx.image.kDitherTypeBayer8x8)
end

-- Assets Manager
function Screen:loadAssets()
end

function Screen:releaseAssets()
end

-- Fade Out
function Screen:startFadeOut()
    self.timerStamp = playdate.getCurrentTimeMilliseconds()
    self.progress = 0;
    self.state = self.State.FADEOUT;

    gfx.pushContext(fadeRenderToTexture)
    self:draw()
    gfx.popContext()

    self:releaseAssets()
end

function Screen:updateFadeOut()
    self.progress = (playdate.getCurrentTimeMilliseconds() - self.timerStamp) / self.fadeOutTime_ms
    if (self.progress > 1) then
        self.progress = 1;
        self:fadeOutCompleted()
    end
end

function Screen:fadeOutCompleted()
    self.state = self.State.HIDDEN
    currentscreen = fadetargetscreen;
    currentscreen:startFadeIn()
    fadetargetscreen = nil
end

function Screen:drawFadeOut()
    gfx.clear()
    fadeRenderToTexture:drawFaded(0, 0, 1 - self:getFadeProgress(), gfx.image.kDitherTypeBayer8x8)
end

-- Work
function Screen:updateinput()

end

function Screen:updatework()
end

function Screen:draw()
    
end

-- Main update
function Screen:update()

    if (self.state == self.State.HIDDEN) then
        --print("HIDDEN 1")
        return
    end

    if (self.state == self.State.FADEIN) then
        --print("FADE IN 1")
        self:updateFadeIn()
    elseif (self.state == self.State.FADEOUT) then
        --print("FADEOUT 1")
        self:updateFadeOut()
    else

        self:updateinput()
        self:updatework()
        --print("update work")
    end


    if (self.state == self.State.HIDDEN) then
        --print("hidden")
        return
    end

    if (self.state == self.State.FADEIN) then
        --print("fade in ")
        self:drawFadeIn()
    elseif (self.state == self.State.FADEOUT) then
        --print("fadeout")
        self:drawFadeOut()

    else
        --if drValue == 0 then
        self:draw()

        --end
    end

   
    --self.blackBarTemplate:add()
    
end


