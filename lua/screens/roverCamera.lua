import "lua/screens/screen"
import "CoreLibs/sprites"


class("RoverCamera").extends("Screen")

local gfx <const> = playdate.graphics
local screenBuffor = 180

function RoverCamera:init()

    RoverCamera.super.init(self)

    self.ui = gfx.image.new('images/cutscenes/cutscene_hvsar_pov/ui')
    self.uiSprite = gfx.sprite.new(self.ui)
    self.uiSprite:moveTo(200, 120)

    self.gutterSplash = gfx.image.new('images/cutscenes/cutscene_hvsar_pov/scene')
    self.gutterSplashSprite = gfx.sprite.new(self.gutterSplash)
    self.gutterSplashSprite:moveTo(600, 120)

    self.gunLeft = gfx.image.new('images/cutscenes/cutscene_hvsar_pov/gun1')
    self.gunLeftSprite = gfx.sprite.new(gfx.image.new('images/cutscenes/cutscene_hvsar_pov/gun1'))
    self.gunLeftSprite:setCenter(0, 0)
    self.gunLeftSprite:moveTo(0, 0)
    self.gunLeftSprite:setZIndex(1000)

    self.gunRight = gfx.image.new('images/cutscenes/cutscene_hvsar_pov/gun2')
    self.gunRightSprite = gfx.sprite.new(self.gunRight)
    self.gunRightSprite:setCenter(1, 0)
    self.gunRightSprite:moveTo(200, 0)

    self.gx = 200
    self.black = gfx.image.new("images/blank_collisions")
    self.iterator = 0
    self.wait = 0
    self.aimSound = playdate.sound.fileplayer.new("sounds/aimSound")
    self.shootSound = playdate.sound.fileplayer.new("sounds/20_boom_1")
    self.canFade = false
    self.changed = false
end

function RoverCamera:updateinput()

    screenBuffor -= 1
    if (screenBuffor < 0 and playdate.buttonJustPressed(playdate.kButtonA)) then
        self.shootSound:play()

        gfx.clear()
        --tobecontinuedscreen:fadeInWithAlpha(true)
        if self.changed == false then
            playdate.timer.performAfterDelay(5000, function()
                self:changescreen(tobecontinuedscreen)

            end)
        end
        self.changed = true
        screenBuffor = 30
        self.canFade = true


    end
end

function RoverCamera:startFadeIn()

    RoverCamera.super.startFadeIn(self)

end

function RoverCamera:updatework()
    if self.gx == 200 then
        self.aimSound:play(0)
    end
    if self.gx == -300 then
        self.aimSound:stop()
    end
    if self.gx > -300 then
        self.gx -= 2
    end
    if self.gx == -300 and self.wait < 120 then
        self.wait += 1
    end
    if self.iterator < 1 and self.canFade == true then
        self.iterator += 0.02
    end
    --print(self.iterator)

end

function RoverCamera:draw()
    gfx.clear()
    self.gutterSplash:draw(self.gx, 0)
    self.gunRight:draw(254, 0)
    self.gunLeft:draw(0, 0)
    self.ui:draw(0, 0)
    if self.canFade == true then
        self.black:drawFaded(0, 0, self.iterator, gfx.image.kDitherTypeHorizontalLine)
    end



end

