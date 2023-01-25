import "lua/screens/screen"
import "CoreLibs/sprites"


class("CutsceneWD40").extends("Screen")

local gfx <const> = playdate.graphics
local screenBuffor = 30

function CutsceneWD40:init()

    CutsceneWD40.super.init(self)

    self.wd40 = gfx.image.new('images/cutscenes/cutscene_wd40000')

end

function CutsceneWD40:updateinput()

    screenBuffor -= 1
    if (screenBuffor < 0 and playdate.buttonJustPressed(playdate.kButtonA)) then

        --tobecontinuedscreen:fadeInWithAlpha(true)
        gfx.clear()
        
        crankscreen:fadeInWithAlpha(true)
        self:changescreen(crankscreen)
        screenBuffor = 30
        --crankscreen:removeEnemies()
        --crankscreen:addEnemyBack()
        --crankscreen:addDandelions()
        if crankscreen.crankBool == true then
            crankscreen.crankSprite:add()
        end
        

        


    end
end

function CutsceneWD40:startFadeIn()

    CutsceneWD40.super.startFadeIn(self)

end

function CutsceneWD40:updatework()

end

function CutsceneWD40:draw()

    gfx.clear()
    self.wd40:draw(0, 0)

end
