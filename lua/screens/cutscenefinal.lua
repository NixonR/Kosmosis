import "lua/screens/screen"
import "CoreLibs/sprites"


class("CutsceneFinal").extends("Screen")

local gfx <const> = playdate.graphics
local screenBuffor = 30

function CutsceneFinal:init()

    CutsceneFinal.super.init(self)
    --IMAGES ===============================================================
    self.sceneOneRover = gfx.image.new("images/cutscenes/cutscene_outro01/1_hvsar")
    self.sceneOneDandelion = gfx.image.new("images/cutscenes/cutscene_outro01/1_dandelion")
    self.sceneOneBg = gfx.image.new("images/cutscenes/cutscene_outro01/2_ground")
    self.sceneOneSky = gfx.image.new("images/cutscenes/cutscene_outro01/3_stars")

    self.sceneTwo = gfx.image.new("images/cutscenes/cutscene_outro02/outro2_bg")
    self.sceneTwo2 = gfx.image.new("images/cutscenes/cutscene_outro02/outro2_screen")

    self.sceneThree = gfx.image.new("images/cutscenes/cutscene_outro03")

    self.black = gfx.image.new("images/blank_collisions")
    --PARAMETERS==========================================================
    self.posX = 0
    self.posY = 0
    self.changePictureCounter = 0
    self.blackAlphaValue = 0
    self.alphaValue = 1
    self.roverx = 0
    self.dandelionx = 400
    self.bgx = 0
    self.cameraAction = false
    self.paralaxCounter = 0
    self.sceneTwoY = 100
    self.sceneThreeY = -200

    self.roarSound = playdate.sound.fileplayer.new("sounds/roar")
    self.roarSound2 = playdate.sound.fileplayer.new("sounds/roar2")
    self.darkTheme = playdate.sound.fileplayer.new("sounds/darkTheme")
    self.bA = ButtonUI(380, 220, "A")

    self.fontDisplay = gfx.font.new("font/Full Circle/font-full-circle")
end

function CutsceneFinal:updateinput()

    screenBuffor -= 1
    if (screenBuffor < 0 and playdate.buttonJustPressed(playdate.kButtonA) or self.bgx < -300) then
        gfx.sprite:removeAll()
        gfx.clear()
        --tobecontinuedscreen:fadeInWithAlpha(true)
        cargoendscreen.kosmonaut.posY = 98
        cargoendscreen.kosmonaut.posX = 80
        roverisactive = true
        cargoendscreen.rover.spriteBase:add()
        cargoendscreen.rover.turret:add()
        cargoendscreen:fadeInWithAlpha(true)
        self:changescreen(cargoendscreen)
        cargoendscreen.deadGutters:add()
        cargoendscreen.roverCollected = true
        cargoendscreen.roverPosX = 100
        cargoendscreen.roverPosY = 160
        cargoendscreen.roverTargetX = 100
        cargoendscreen.roverTargetY = 160
        cargoendscreen.kosmonaut:removeFromInventory("bumper")
        cargoendscreen.stopPlayerFromMoving = false
        self.darkTheme:stop()
        screenBuffor = 30

    end
end

function CutsceneFinal:startFadeIn()

    CutsceneFinal.super.startFadeIn(self)

end

function CutsceneFinal:fadeInCompleted()

    CutsceneFinal.super.fadeInCompleted(self)

end

function CutsceneFinal:updatework()
    
    self.paralaxCounter += 1
    if self.paralaxCounter > 2 then
        self.paralaxCounter = 0
    end
    if self.cameraAction == false then
        playdate.timer.performAfterDelay(2000, function()
            self.cameraAction = true
        end)

    end
    if self.cameraAction == true and self.bgx > -396 then


        --if self.paralaxCounter == 2 then
        self.roverx     -= 2
        self.dandelionx -= 2
        self.bgx        -= 1

        --end

    end

end

function CutsceneFinal:draw()
    gfx.clear()
    print(self.changePictureCounter)
    if self.bgx < -390 then
        self.changePictureCounter += 1
    end
    if self.changePictureCounter < 130 then
        self.sceneOneSky:draw(0, 0)
        self.sceneOneBg:draw(self.bgx, 0)
        self.sceneOneRover:draw(self.roverx, 0)
        self.sceneOneDandelion:draw(self.dandelionx, 76)
    end

end
