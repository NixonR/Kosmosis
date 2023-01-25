import "lua/screens/screen"
import "CoreLibs/sprites"


class("CutsceneComputer").extends("Screen")

local gfx <const> = playdate.graphics
local screenBuffor = 30

function CutsceneComputer:init()

    CutsceneComputer.super.init(self)

    self.pcBG = gfx.image.new('images/cutscenes/spine_intro_computer/bg')
    self.pcFront = gfx.image.new('images/cutscenes/spine_intro_computer/front')
    self.text1 = gfx.image.new('images/cutscenes/spine_intro_computer/text1')
    self.text2 = gfx.image.new('images/cutscenes/spine_intro_computer/text2')
    self.text3 = gfx.image.new('images/cutscenes/spine_intro_computer/text3')
    self.pcTimer = -40
    self.shake = 0
    self.pcWarning = playdate.sound.fileplayer.new("sounds/warning2")
    self.pcWarning:setVolume(0.1)
    self.pc1 = playdate.sound.sampleplayer.new("sounds/pc1")
    self.engine = playdate.sound.fileplayer.new("sounds/engineFall")
    self.engineDown = playdate.sound.fileplayer.new("sounds/engineDown")

    self.black = gfx.image.new("images/blank_collisions")
    self.skull = gfx.image.new("images/cutscenes/cutscene_intesinegod")
    self.text12 = TextDisplay(20, 200, " CREW: TWO XENOBOTANISTS AND MULTI-PURPOSE ")
    self.text22 = TextDisplay(20, 215, " SPACE ROBOT HVSAR.102 ")
end

function CutsceneComputer:updateinput()

    screenBuffor -= 1
    if screenBuffor < 20 and playdate.buttonJustPressed(playdate.kButtonA) or self.pcTimer > 499 then

        --cutscenecrash:fadeInWithAlpha(true)
        self:changescreen(cutscenecrash)
        gfx.sprite:removeAll()
        -- cliffscreen:loadAssets()
        -- cliffviewscreen:loadAssets()
        -- playdate.timer.performAfterDelay(1000, function()
        -- end)

        screenBuffor = 30
        gfx.clear()
    end
end

function CutsceneComputer:startFadeIn()

    CutsceneComputer.super.startFadeIn(self)

end

function CutsceneComputer:updatework()

end

function CutsceneComputer:draw()
    --print(self.pcTimer % 2)
    self.pcTimer += 1
    if self.pcTimer > 300 then
        
        if self.pcTimer % 3 > 0 then
            self.shake = 4
            
        else
            self.shake = 0
            
        end
    end

    if self.pcTimer % 3 > 0 then
        self.engine:play()

    end

    gfx.clear()

    self.pcBG:draw(self.shake, 0)
    if self.pcTimer < 110 then
        
        self.text1:draw(0, 0)
    end
    if self.pcTimer == 88 then
        self.engineDown:play()
        
        
    end
    
    if self.pcTimer == 110 then
        self.pc1:play(1, 1)
        
    end
    if self.pcTimer > 110 and self.pcTimer < 320 then
        
        self.text2:draw(self.shake, 0)
    end
    if self.pcTimer == 320 then
        self.pc1:play(1, 1)
        
    end
    if self.pcTimer == 334 then
        self.engineDown:play()
        self.shake = -4
        
    end
    if self.pcTimer > 320 and self.pcTimer < 340 then
        self.text3:draw(self.shake, 0)
        self.pcWarning:play(1)
    end

    if self.pcTimer > 343 and self.pcTimer < 370 then
        self.text3:draw(self.shake, 0)
        self.pcWarning:play(1)
    end
    if self.pcTimer > 374 and self.pcTimer < 400 then
        self.text3:draw(self.shake, 0)
        self.pcWarning:play(1)
    end

    self.pcFront:draw(self.shake, 0)
   
    -- if self.pcTimer ==  575 then
    --     --self.capsuleReady:play(1)
    -- end
    -- if self.pcTimer ==  670 then
    --     --self.eject:play(1)
    -- end
    if self.pcTimer > 400 and self.pcTimer < 420 then
        self.black:draw(0,0)
        self.pcWarning:play(1)
    end

    if self.pcTimer>429 and self.pcTimer <432 then
        self.skull:draw(0, 0)
        self.pcWarning:play(1)
    end
    if self.pcTimer > 431 and self.pcTimer < 452 then
        self.black:draw(0,0)
        self.pcWarning:play(1)
    end
    if self.pcTimer > 460 then
        self.black:draw(0,0)
        self.pcWarning:play(1)
        
    end

    if self.pcTimer > -20 and self.pcTimer < 300 then
        self.text12:updateWork()
        self.text12:draw()
    end
    if self.pcTimer > 110 and self.pcTimer < 300 then
        self.text22:updateWork()
        self.text22:draw()
    end
end
