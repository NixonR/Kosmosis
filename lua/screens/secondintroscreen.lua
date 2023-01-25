import "lua/screens/screen"
import "CoreLibs/sprites"


class("SecondIntroScreen").extends("Screen")

local gfx <const> = playdate.graphics
local screenBuffor = 30

function SecondIntroScreen:init()

    SecondIntroScreen.super.init(self)

    self.secondIntroScreenImage = gfx.image.new('images/cutscenes/cutscene_intro_ship/bg')
    self.secondIntroScreenSprite = gfx.sprite.new(self.secondIntroScreenImage)
    self.secondIntroScreenSprite:setZIndex(9)
    --self.secondIntroScreenSprite:moveTo(200, 120)

    self.shipImage = gfx.image.new("images/cutscenes/cutscene_intro_ship/copernicus")
    self.shipSprite = gfx.sprite.new(self.shipImage)
    self.shipSprite:setClipRect(0, 0, 400, 240)

    self.shipPositionY = 0
    self.simpleCounter = 0

    -- self.shipSprite:moveTo(50, 120)
    -- self.shipSprite:setZIndex(11)
    -- self.shipSprite:setCollideRect(0, 0, 100, 100)

    self.fadeInTime_ms = 2000

    self.kosmosisImage = gfx.image.new("images/cutscenes/cutscene_intro_ship/title")
    self.kosmosisLogo = gfx.sprite.new(self.kosmosisImage)
    self.kosmosisLogo:moveTo(200, 120)
    self.kosmosisLogo:setZIndex(10)
    self.kosmosisLogoCounter = 0
    self.timerStamp = 0
    self.logoFadeIterator = 1
    self.shipPositionX = -100
    self.fadeInTime_ms = 2000
    self.fadeOutTime_ms = 3000
    self.shipp = playdate.sound.sampleplayer.new("sounds/aimSound")
    self.shipp:setVolume(0.2)
    self.enterStage = playdate.sound.sampleplayer.new("sounds/45_select_6")
    self.enterStage:setVolume(0.4)
    self.kosmosisLogoSound = playdate.sound.sampleplayer.new("sounds/mainBlink")
    self.logoSoundBool = true
    self.currentVolume = 1
    self.changed = false
    self.text1 = TextDisplay(20, 200, "BIOCENOSIS RESEARCH DATA MISSION IN THE")
    self.text2 = TextDisplay(20, 215, "PARTS OF SPACE UNKNOWN TO HUMAN")

end

function SecondIntroScreen:updateinput()

    screenBuffor -= 1
    if (screenBuffor < 20 and playdate.buttonJustPressed(playdate.kButtonA) or
        screenBuffor < 0 and self.shipPositionX > -20) then
        if self.changed == false then
            --cutscenecomputerscreen:fadeInWithAlpha(true)
            --playdate.timer.performAfterDelay(2000, function()
                self.shipp:stop()
                self.enterStage:play()
                gfx.clear()
                self.kosmosisLogoCounter = 0
                self:changescreen(cutscenecomputerscreen)
                -- splitscreen:loadAssets()
                -- preludescreen:loadAssets()
                -- labiryntscreen:loadAssets()
                -- explosivescreen:loadAssets()
                -- monsterscreen:loadAssets()

           -- end)
            self.changed = true

            screenBuffor = 30
            self.logoFadeIterator = 0

        end
    end
end

function SecondIntroScreen:startFadeIn()

    SecondIntroScreen.super.startFadeIn(self)

end

function SecondIntroScreen:loadAssets()
    self.kosmosisImage = gfx.image.new("images/cutscenes/cutscene_intro_ship/title")
    self.kosmosisLogo = gfx.sprite.new(self.kosmosisImage)
    self.shipp = playdate.sound.sampleplayer.new("sounds/aimSound")

    self.enterStage = playdate.sound.sampleplayer.new("sounds/45_select_6")

    self.kosmosisLogoSound = playdate.sound.sampleplayer.new("sounds/mainBlink")
end

function SecondIntroScreen:releaseAssets()
    self.kosmosisImage = nil
    self.kosmosisLogo = nil
    self.shipp = nil

    self.enterStage = nil

    self.kosmosisLogoSound = nil
end

function SecondIntroScreen:updatework()

    if self.currentVolume > 0 then
        self.currentVolume -= 0.02
    end


    bg1:setVolume(self.currentVolume)
    self.simpleCounter += 1
    if self.simpleCounter > 30 then
        self.shipPositionX += 4
        self.shipp:play(2, 1)
        self.simpleCounter = 0
    end

    if self.kosmosisLogoCounter > 229 and self.changed == false then

        if self.logoFadeIterator > 0 then
            self.logoFadeIterator -= (playdate.getCurrentTimeMilliseconds() - self.timerStamp) * 0.0001
            if self.logoFadeIterator < 0.1 then
                self.logoFadeIterator = 0
            end
        end
    end

end

function SecondIntroScreen:draw()


    gfx.clear()
    self.secondIntroScreenImage:draw(0, 0)
    self.kosmosisLogoCounter += 1

    self.shipImage:draw(self.shipPositionX, 30) -- dodac shipPosition do update

    if (self.kosmosisLogoCounter > 160 and self.kosmosisLogoCounter < 310) then
        self.kosmosisImage:drawFaded(0, 0, 1, playdate.graphics.image.kDitherTypeBayer8x8)
        if self.logoSoundBool == true then
            self.kosmosisLogoSound:play()
            self.logoSoundBool = false
        end

    end

    if playdate.buttonJustPressed(playdate.kButtonA) and self.kosmosisLogoCounter < 161 then
        -- self.kosmosisImage:drawFaded(0, 0, 1, playdate.graphics.image.kDitherTypeBayer8x8)
        -- if self.logoSoundBool == true then
        --     self.kosmosisLogoSound:play()
        --     self.logoSoundBool = false
        -- end

    end

    if self.kosmosisLogoCounter < 309 then
        self.timerStamp = playdate.getCurrentTimeMilliseconds()
    end
    if self.kosmosisLogoCounter > 309 then

        self.kosmosisImage:drawFaded(0, 0, self.logoFadeIterator, playdate.graphics.image.kDitherTypeBayer8x8)
    end
    print(self.kosmosisLogoCounter, "logo counter")
    if self.kosmosisLogoCounter > 350 then
        self.text1:updateWork()
        self.text1:draw()
    end
    if self.kosmosisLogoCounter > 510 then
        self.text2:updateWork()
        self.text2:draw()
    end

end
