import "lua/screens/screen"
import "lua/buttonui"

class("DeathScreen").extends("Screen")

local gfx <const> = playdate.graphics
local screenBuffor = 30

function DeathScreen:init()
    DeathScreen.super.init(self)
    self.deathScreenImage = gfx.image.new('images/deathScreens/kosmosis_playdate05')
    self.deathScreenImageSpear = gfx.image.new('images/deathScreens/deathscreen_dandelion')
    self.die1 = playdate.sound.sampleplayer.new("sounds/grr")
    self.die1:setVolume(0.4)
    self.die2 = playdate.sound.sampleplayer.new("sounds/die2")

    self.dieEgg = playdate.sound.sampleplayer.new("sounds/eggCutscene")
    self.bA = ButtonUI(200, 120, "A")
    self.deathType =
    {
        GUTTER_DEATH = "GUTTER",
        DANDELION_DEATH = "DANDELION",
        AIM_DEATH = "AIM",
        ALIEN_DEATH = "ALIEN"

    }

    self.deathType = "DANDELION"
    self.fadeInTime_ms = 2000
    self.canReset = false
    self.waitForButton = 0
    self.alienSplashCounter = 0
    self.deathScreenAlien1 = gfx.image.new('images/deathScreens/alien1')
    self.deathScreenAlien2 = gfx.image.new('images/deathScreens/alien2')
    self.deathScreenAlien3 = gfx.image.new('images/deathScreens/alien3')
    self.deathScreenAlien4 = gfx.image.new('images/deathScreens/alien4')
    


end

function DeathScreen:updateinput()

    screenBuffor -= 1
    if (screenBuffor < 0 and playdate.buttonJustPressed(playdate.kButtonA)) then
        self.bA.uiButtonIsEnabled = false
        self.waitForButton = 0
        print("deady dead")
        gfx.sprite:removeAll()
        if self.deathType == "GUTTER" then
            gutternestscreen:fadeInWithAlpha(true)
            gutternestscreen.roverPosX = 30
            gutternestscreen.roverPosY = 100
            gutternestscreen.roverTargetX = 30
            gutternestscreen.roverTargetY = 100
            self:changescreen(gutternestscreen)
            gutternestscreen:addEnemyBack()
            gutternestscreen:addDandelions()
            gutternestscreen:addLilDandelions()
            gutternestscreen.resetBool = true
            gutternestscreen.kosmonaut:removeFromInventory("wd40000")
            crankscreen.crankBool = true
            gutternestscreen.kosmonaut.crankCollected = false

        elseif self.deathType == "DANDELION" then
            plainsscreen.roverPosX = 150
            plainsscreen.roverPosY = 180
            plainsscreen.roverTargetX = 150
            plainsscreen.roverTargetY = 180
            plainsscreen.rover.spriteBase:add()
            plainsscreen.rover.turret:add()
            plainsscreen.kosmonaut.posX = 200
            plainsscreen.kosmonaut.posY = 120
            plainsscreen:fadeInWithAlpha(true)
            plainsscreen:addFlowers()
            plainsscreen.rootsAlone:add()

            self:changescreen(plainsscreen)
        elseif self.deathType == "AIM" then
            self:changescreen(aimscreen)
        elseif self.deathType == "ALIEN" then
            undergroundscreen.kosmonaut.posX = 335
            undergroundscreen.kosmonaut.posY = 15
            self:changescreen(undergroundscreen)
            undergroundscreen.blackHole:setScale(1)
            undergroundscreen.blackHole:add()
            for k,v in pairs(undergroundscreen.eggUpdateTable) do
                undergroundscreen.eggUpdateTable[k].eggSprite:add()
            end
            self.alienSplashCounter = 0 
        end
        --gutternestscreen.kosmonaut.kosmonautSprite:moveTo(30, 120)
        self.waitForButton = 0


        --Kosmonaut.crankCollected = false
        --Kosmonaut.kosmonautSprite:moveTo(30, 120)
        screenBuffor = 30
        self.canReset = true
    end
end

function DeathScreen:startFadeIn()

    DeathScreen.super.startFadeIn(self)

end

function DeathScreen:updatework()
    self.waitForButton += 1
end

function DeathScreen:draw()
    DeathScreen.super.draw()
    gfx.clear()
    if self.deathType == "GUTTER" or self.deathType == "AIM" then
        self.deathScreenImage:drawScaled(0, 0, 0.25)
    end

    if self.deathType == "DANDELION" then
        self.deathScreenImageSpear:draw(0, 0)
    end
    if self.deathType == "ALIEN" then
        self.alienSplashCounter +=1
        if self.alienSplashCounter < 5 then
        self.deathScreenAlien1:draw(0, 0)
        elseif self.alienSplashCounter < 10 then
            self.deathScreenAlien2:draw(0, 0)
        elseif self.alienSplashCounter < 15 then
            if self.alienSplashCounter == 11 then
                self.dieEgg:play()
            end
            self.deathScreenAlien3:draw(0, 0)
        elseif self.alienSplashCounter < 20 then
            self.deathScreenAlien4:draw(0, 0)
        end
    end
    if self.waitForButton > 100 then
        self.bA.glyphA:draw(380, 220)
    end



end

function DeathScreen:canResetGame()

    return self.canReset
end

function DeathScreen:playAudio()
    --if self.playAudioAfterDeath == true then
    if self.deathType == "GUTTER" or self.deathType == "AIM" then
        self.die1:play()

    end
    if self.deathType == "DANDELION" then
        self.die2:play()

    end

    --end
end
