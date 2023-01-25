import "lua/screens/screen"
import "CoreLibs/sprites"
import "lua/spriteanimation"
import "CoreLibs/ui"
import "lua/enemyScripts/aimEnemies/gutterAim"
import "CoreLibs/crank"


class("Aim").extends("Level")

local gfx <const> = playdate.graphics
local screenBuffor = 180

function Aim:init()
    -- Aim.super.init(self)

    -- self.black = gfx.image.new("images/blank_collisions")
    -- self.levelimage = self.black

    -- self.ui = gfx.image.new('images/cutscenes/cutscene_hvsar_pov/ui')
    -- self.uiSprite = gfx.sprite.new(self.ui)
    -- self.uiSprite:moveTo(200, 120)
    -- self.uiSprite:setZIndex(250)

    -- -- self.uiAmmoBarSprite = gfx.sprite.new(gfx.image.new('images/cutscenes/cutscene_hvsar_pov/uiAmmoBar'))
    -- -- self.uiAmmoBarSprite:setZIndex(250)
    -- -- self.uiAmmoBarSprite:setCenter(0, 0)
    -- -- self.uiAmmoBarSprite:moveTo(0, 0)
    -- self.uiAmmoBarSprite = gfx.sprite.new()
    -- self.uiAmmoBarSprite:setZIndex(250)
    -- self.uiAmmoBarSprite:setCenter(0, 0)
    -- self.uiAmmoBarSprite:moveTo(0, 0)
    -- self.uiAmmoBarSprite:setClipRect(0, 0, 400, 240)
    -- self.uiAmmoReloadAnim = SpriteAnimation(self.uiAmmoBarSprite)
    -- self.uiAmmoReloadAnim:addImage("images/cutscenes/cutscene_hvsar_pov/uiAmmoBar1")
    -- self.uiAmmoReloadAnim:addImage("images/cutscenes/cutscene_hvsar_pov/uiAmmoBar1")
    -- self.uiAmmoReloadAnim:addImage("images/cutscenes/cutscene_hvsar_pov/uiAmmoBar1")
    -- self.uiAmmoReloadAnim:addImage("images/cutscenes/cutscene_hvsar_pov/uiAmmoBar3")
    -- self.uiAmmoReloadAnim:addImage("images/cutscenes/cutscene_hvsar_pov/uiAmmoBar3")
    -- self.uiAmmoReloadAnim:addImage("images/cutscenes/cutscene_hvsar_pov/uiAmmoBar2")
    -- self.uiAmmoReloadAnim:addImage("images/cutscenes/cutscene_hvsar_pov/uiAmmoBar2")
    -- self.uiAmmoReloadAnim:addImage("images/cutscenes/cutscene_hvsar_pov/uiAmmoBar2")
    -- self.uiAmmoReloadAnim:addImage("images/cutscenes/cutscene_hvsar_pov/uiAmmoBar2")

    -- self.currentReloadAnimation = self.uiAmmoReloadAnim


    -- self.uiSprite.collisionResponse = 'overlap'

    -- self.horizont = gfx.sprite.new(gfx.image.new('images/cutscenes/cutscene_hvsar_pov/horizont'))
    -- self.horizont:setZIndex(1000)
    -- self.horizont:setCenter(0.5, 0)
    -- self.horizont:moveTo(201, 6)

    -- self.crack1 = gfx.sprite.new(gfx.image.new('images/cutscenes/cutscene_hvsar_pov/ui_crack'))
    -- self.crack1:moveTo(150, 50)
    -- self.crack1:setZIndex(238)

    -- self.crack2 = gfx.sprite.new(gfx.image.new('images/cutscenes/cutscene_hvsar_pov/ui_crack'))
    -- self.crack2:moveTo(350, 210)
    -- self.crack2:setZIndex(238)

    -- self.crack3 = gfx.sprite.new(gfx.image.new('images/cutscenes/cutscene_hvsar_pov/ui_crack'))
    -- self.crack3:moveTo(75, 170)
    -- self.crack3:setZIndex(238)

    -- self.ammoSprite = gfx.sprite.new(gfx.image.new('images/cutscenes/cutscene_hvsar_pov/ui_fire_bar'))
    -- self.ammoSprite:setZIndex(10000)
    -- self.ammoSprite:setCenter(0, 0)
    -- self.ammoSprite:moveTo(169, 209)
    -- self.ammoSpriteClipX = 89
    -- self.ammoSprite:setClipRect(169, 209, self.ammoSpriteClipX, 16)

    -- self.ammoBarUiCounter = 0 -- COUNTER NEEDED TO BLINK AMMO BAR WHEN AMMO LOW

    -- self.gutterFace = gfx.sprite.new(gfx.image.new("images/gutterAim/gutter_jumpscare"))
    -- self.gutterFace:moveTo(200, 120)
    -- self.gutterFace:setZIndex(237)

    -- -- self.turbo = gfx.sprite.new(gfx.image.new("images/vfx/turbo"))
    -- -- self.turbo:moveTo(200, 120)
    -- -- self.turbo:setZIndex(234)

    -- self.gunLeft = gfx.image.new('images/cutscenes/cutscene_hvsar_pov/gun1')
    -- self.gunLeftSprite = gfx.sprite.new(self.gunLeft)
    -- self.gunLeftSprite:setCenter(0, 0)
    -- self.gunLeftSprite:moveTo(0, -10)
    -- self.gunLeftSprite:setZIndex(235)

    -- self.gunRight = gfx.image.new('images/cutscenes/cutscene_hvsar_pov/gun2')
    -- self.gunRightSprite = gfx.sprite.new(self.gunRight)
    -- self.gunRightSprite:setCenter(1, 0)
    -- self.gunRightSprite:moveTo(400, -10)
    -- self.gunRightSprite:setZIndex(235)

    -- self.cosmonautSprite = gfx.sprite.new(gfx.image.new("images/cutscenes/cutscene_hvsar_pov/cosmonaut"))
    -- self.cosmonautSprite:moveTo(-430, 220)
    -- self.cosmonautSprite:setZIndex(5)

    -- self.bumperSprite = gfx.sprite.new(gfx.image.new("images/cutscenes/cutscene_hvsar_pov/bumper"))
    -- self.bumperSprite:setCenter(0.5, 1)
    -- self.bumperSprite:moveTo(200, 240)
    -- self.bumperSprite:setZIndex(238)

    -- self.dandelionCloseSprite = gfx.sprite.new(gfx.image.new("images/cutscenes/cutscene_hvsar_pov/dandelion"))
    -- self.dandelionFarSprite = gfx.sprite.new(gfx.image.new("images/cutscenes/cutscene_hvsar_pov/dandelion_far"))

    -- self.grassSprite = gfx.sprite.new(gfx.image.new("images/cutscenes/cutscene_hvsar_pov/grass"))

    -- self.grass1 = gfx.sprite.new(gfx.image.new("images/cutscenes/cutscene_hvsar_pov/grass"))
    -- self.grass1:setZIndex(5)
    -- self.grass1:moveTo(130, 160)

    -- self.grass2 = gfx.sprite.new(gfx.image.new("images/cutscenes/cutscene_hvsar_pov/grass"))
    -- self.grass2:setZIndex(5)
    -- self.grass2:moveTo(260, 120)

    -- self.grass3 = gfx.sprite.new(gfx.image.new("images/cutscenes/cutscene_hvsar_pov/grass"))
    -- self.grass3:setZIndex(5)
    -- self.grass2:moveTo(-340, 120)

    -- self.dandelionFar1 = gfx.sprite.new(gfx.image.new("images/cutscenes/cutscene_hvsar_pov/dandelion_far"))
    -- self.dandelionFar1:setZIndex(0)
    -- self.dandelionFar1:moveTo(111, 50)

    -- self.dandelionFar2 = gfx.sprite.new(gfx.image.new("images/cutscenes/cutscene_hvsar_pov/dandelion_far"))
    -- self.dandelionFar2:setZIndex(0)
    -- self.dandelionFar2:moveTo(-136, 50)

    -- self.dandelionClose1 = gfx.sprite.new(gfx.image.new("images/cutscenes/cutscene_hvsar_pov/dandelion"))
    -- self.dandelionClose1:setZIndex(3)
    -- self.dandelionClose1:moveTo(190, 120)

    -- self.dandelionClose2 = gfx.sprite.new(gfx.image.new("images/cutscenes/cutscene_hvsar_pov/dandelion"))
    -- self.dandelionClose2:setZIndex(5)
    -- self.dandelionClose2:moveTo(500, 150)

    -- self.dandelionClose3 = gfx.sprite.new(gfx.image.new("images/cutscenes/cutscene_hvsar_pov/dandelion"))
    -- self.dandelionClose3:setZIndex(4)
    -- self.dandelionClose3:moveTo(-340, 120)

    -- self.rightArrow = gfx.sprite.new(gfx.image.new("images/assets/rightArrow"))
    -- self.rightArrow:moveTo(200, 120)
    -- self.rightArrow:setZIndex(238)

    -- self.leftArrow = gfx.sprite.new(gfx.image.new("images/assets/leftArrow"))
    -- self.leftArrow:moveTo(200, 120)
    -- self.leftArrow:setZIndex(238)


    -- self.whatToAddTable = { self.grass1, self.grass2, self.grass3, self.dandelionFar1, self.dandelionFar2,
    --     self.dandelionClose11, self.dandelionClose2, self.dandelionClose3, self.cosmonautSprite } --TABLE CONTAINS STUFF TO ALWAYS ADD TO SCENE LIKE ENVIRONMENT

    -- -- FIRE BULLETS ANIMATION WITH COLLISION
    -- self.f1 = FireInstance()
    -- self.f2 = FireInstance()
    -- self.f3 = FireInstance()
    -- self.f4 = FireInstance()
    -- self.f5 = FireInstance()
    -- self.f6 = FireInstance()
    -- self.f7 = FireInstance()
    -- self.f8 = FireInstance()
    -- self.f9 = FireInstance()
    -- self.f10 = FireInstance()
    -- self.f11 = FireInstance()
    -- self.f12 = FireInstance()
    -- self.f13 = FireInstance()
    -- self.f14 = FireInstance()
    -- self.f15 = FireInstance()
    -- self.f16 = FireInstance()
    -- self.f17 = FireInstance()
    -- self.f18 = FireInstance()

    -- self.fireTable = { self.f1, self.f2, self.f3, self.f4, self.f5, self.f6, self.f7, self.f8, self.f9, self.f10,
    --     self.f11, self.f12, self.f13, self.f14, self.f15, self.f16, self.f17, self.f18 }
    -- self.fireID = 1 -- STARTING ID OF FIRE TABLE
    -- --SOUNDS ======================================================================
    -- self.glassSound = playdate.sound.fileplayer.new("sounds/glassSound")
    -- self.blindSound = playdate.sound.fileplayer.new("sounds/shootingSound")
    -- self.blindSound:setVolume(0.3)
    -- self.bumperCrashSound = playdate.sound.fileplayer.new("sounds/metalCrashSound")
    -- self.reloadSound = playdate.sound.fileplayer.new("sounds/reloadSound")
    -- self.reloadClick = playdate.sound.fileplayer.new("sounds/clickReload")
    -- self.aimSound = playdate.sound.fileplayer.new("sounds/aimSound")
    -- self.shootSound = playdate.sound.sampleplayer.new("sounds/20_boom_1")
    -- self.shootSound:setVolume(0.1)
    -- self.gutsSound = playdate.sound.fileplayer.new("sounds/stomach")
    -- self.gutsSound:setVolume(0.2)
    -- self.emptyShootSound = playdate.sound.fileplayer.new("sounds/emptyAmmo")
    -- self.emptyShootSound:setVolume(0.3)
    -- self.waveClearSound = playdate.sound.fileplayer.new("sounds/mainBlink")
    -- --self.dieBitchSound = playdate.sound.fileplayer.new("sounds/dieBitch")
    -- self.newLifeForm = playdate.sound.fileplayer.new("sounds/newLifeForm")
    -- self.newLifeForm:setVolume(0.3)
    -- --self.soHotSound = playdate.sound.fileplayer.new("sounds/soHot")
    -- self.hitSound = playdate.sound.fileplayer.new("sounds/hit")
    -- self.canonRotateSound = playdate.sound.sampleplayer.new("sounds/hydraulicSound")
    -- self.canonRotateSound:setVolume(0.5)
    -- self.jumpscare = playdate.sound.fileplayer.new("sounds/grr")
    -- self.jumpscare:setVolume(2)
    -- self.beepSound = playdate.sound.fileplayer.new("sounds/doubleBeep")
    -- self.beepSound:setVolume(0.3)
    -- self.tankEmptySound = playdate.sound.fileplayer.new("sounds/tankEmpty")
    -- self.tankEmptySound:setVolume(0.2)
    -- self.roar3 = playdate.sound.fileplayer.new("sounds/roar3")
    -- self.roar3:setVolume(0.7)
    -- self.roar4 = playdate.sound.fileplayer.new("sounds/roar4")
    -- self.roar4:setVolume(0.8)

    -- self.fireDelayRemovalIterator = 0 -- COUNTER WHEN TO REMOVE BULLET SOUNDS IF IM NOT SHOOTING


    -- playdate.ui.crankIndicator:start()

    -- --ENEMIES------------------------------------------------------------------------------------------

    -- --WAVE MONSTERS ==============================================================================
    -- self.enemy1 = GutterAim(-200, 144, 3)
    -- self.enemy2 = GutterAim(0, 144, 3)
    -- self.enemy3 = GutterAim(200, 144, 3)
    -- self.enemy4 = GutterAim(400, 144, 3)
    -- self.enemy5 = GutterAim(600, 144, 3)

    -- self.enemyTable = { self.enemy1, self.enemy2, self.enemy3, self.enemy4, self.enemy5 }
    -- self.enemyID = 1

    -- --BOOLEANS COLLECTION=====================================
    -- self.canShoot = true
    -- self.crack1appear = false
    -- self.crack2appear = false
    -- self.crack3appear = false
    -- self.gutterCanMove = true
    -- self.canSpawn = false
    -- self.bumperIsActive = true
    -- self.checkIfBumperCollected = true
    -- self.reset = false
    -- self.displayRightArrow = false
    -- self.displayLeftArrow = false
    -- self.waveOneCompleted = false
    -- self.waveTwoCompleted = false
    -- self.waveThreeCompleted = false
    -- self.waveFourCompleted = false
    -- self.waveFiveCompleted = false
    -- self.tankEmptyInfo = true
    -- self.usingAmmo = false
    -- self.jumpscareBool = false
    -- self.finishGame = false

    -- --VALUES =======================================================================
    -- self.ammo = 400
    -- self.spawnCounter = 0
    -- self.crackCounter = 0
    -- self.hitScore = 0 -- HOW MANY GUTTER HAVE YOU KILLED
    -- self.timeBeforeHit = 0 --HOW LONG GUTTER STAYS CLOSE TO ROVER (INDEX 8)
    -- self.gutterMoveTime = 100
    -- self.spawnSpeed = 1
    -- self.reloadValue = 0
    -- self.drawTutorialCounter = 0

end

function Aim:updateinput()


    if self.ammo > 2300 and self.hitScore == 0 then
        self.canSpawn = true
    end

end

function Aim:startFadeIn()

    Aim.super.startFadeIn(self)

end

function Aim:loadAssets()
    Aim.super.init(self)

    self.black = gfx.image.new("images/blank_collisions")
    self.levelimage = self.black

    self.ui = gfx.image.new('images/cutscenes/cutscene_hvsar_pov/ui')
    self.uiSprite = gfx.sprite.new(self.ui)
    self.uiSprite:moveTo(200, 120)
    self.uiSprite:setZIndex(250)

    self.uiAmmoBarSprite = gfx.sprite.new()
    self.uiAmmoBarSprite:setZIndex(250)
    self.uiAmmoBarSprite:setCenter(0, 0)
    self.uiAmmoBarSprite:moveTo(0, 0)
    self.uiAmmoBarSprite:setClipRect(0, 0, 400, 240)
    self.uiAmmoReloadAnim = SpriteAnimation(self.uiAmmoBarSprite)
    self.uiAmmoReloadAnim:addImage("images/cutscenes/cutscene_hvsar_pov/uiAmmoBar1")
    self.uiAmmoReloadAnim:addImage("images/cutscenes/cutscene_hvsar_pov/uiAmmoBar1")
    self.uiAmmoReloadAnim:addImage("images/cutscenes/cutscene_hvsar_pov/uiAmmoBar1")
    self.uiAmmoReloadAnim:addImage("images/cutscenes/cutscene_hvsar_pov/uiAmmoBar3")
    self.uiAmmoReloadAnim:addImage("images/cutscenes/cutscene_hvsar_pov/uiAmmoBar3")
    self.uiAmmoReloadAnim:addImage("images/cutscenes/cutscene_hvsar_pov/uiAmmoBar2")
    self.uiAmmoReloadAnim:addImage("images/cutscenes/cutscene_hvsar_pov/uiAmmoBar2")
    self.uiAmmoReloadAnim:addImage("images/cutscenes/cutscene_hvsar_pov/uiAmmoBar2")
    self.uiAmmoReloadAnim:addImage("images/cutscenes/cutscene_hvsar_pov/uiAmmoBar2")

    self.currentReloadAnimation = self.uiAmmoReloadAnim


    self.uiSprite.collisionResponse = 'overlap'

    self.horizont = gfx.sprite.new(gfx.image.new('images/cutscenes/cutscene_hvsar_pov/horizont'))
    self.horizont:setZIndex(1000)
    self.horizont:setCenter(0.5, 0)
    self.horizont:moveTo(201, 6)

    self.crack1 = gfx.sprite.new(gfx.image.new('images/cutscenes/cutscene_hvsar_pov/ui_crack'))
    self.crack1:moveTo(150, 50)
    self.crack1:setZIndex(238)

    self.crack2 = gfx.sprite.new(gfx.image.new('images/cutscenes/cutscene_hvsar_pov/ui_crack'))
    self.crack2:moveTo(350, 210)
    self.crack2:setZIndex(238)

    self.crack3 = gfx.sprite.new(gfx.image.new('images/cutscenes/cutscene_hvsar_pov/ui_crack'))
    self.crack3:moveTo(75, 170)
    self.crack3:setZIndex(238)

    self.ammoSprite = gfx.sprite.new(gfx.image.new('images/cutscenes/cutscene_hvsar_pov/ui_fire_bar'))
    self.ammoSprite:setZIndex(10000)
    self.ammoSprite:setCenter(0, 0)
    self.ammoSprite:moveTo(169, 209)
    self.ammoSpriteClipX = 89
    self.ammoSprite:setClipRect(169, 209, self.ammoSpriteClipX, 16)

    self.ammoBarUiCounter = 0 -- COUNTER NEEDED TO BLINK AMMO BAR WHEN AMMO LOW

    self.gutterFace = gfx.sprite.new(gfx.image.new("images/gutterAim/gutter_jumpscare"))
    self.gutterFace:moveTo(200, 120)
    self.gutterFace:setZIndex(237)

    self.gunLeft = gfx.image.new('images/cutscenes/cutscene_hvsar_pov/gun1')
    self.gunLeftSprite = gfx.sprite.new(self.gunLeft)
    self.gunLeftSprite:setCenter(0, 0)
    self.gunLeftSprite:moveTo(0, -10)
    self.gunLeftSprite:setZIndex(235)

    self.gunRight = gfx.image.new('images/cutscenes/cutscene_hvsar_pov/gun2')
    self.gunRightSprite = gfx.sprite.new(self.gunRight)
    self.gunRightSprite:setCenter(1, 0)
    self.gunRightSprite:moveTo(400, -10)
    self.gunRightSprite:setZIndex(235)

    self.cosmonautSprite = gfx.sprite.new(gfx.image.new("images/cutscenes/cutscene_hvsar_pov/cosmonaut"))
    self.cosmonautSprite:moveTo(-430, 220)
    self.cosmonautSprite:setZIndex(5)

    self.bumperSprite = gfx.sprite.new(gfx.image.new("images/cutscenes/cutscene_hvsar_pov/bumper"))
    self.bumperSprite:setCenter(0.5, 1)
    self.bumperSprite:moveTo(200, 240)
    self.bumperSprite:setZIndex(238)

    self.dandelionCloseSprite = gfx.sprite.new(gfx.image.new("images/cutscenes/cutscene_hvsar_pov/dandelion"))
    self.dandelionFarSprite = gfx.sprite.new(gfx.image.new("images/cutscenes/cutscene_hvsar_pov/dandelion_far"))

    self.grassSprite = gfx.sprite.new(gfx.image.new("images/cutscenes/cutscene_hvsar_pov/grass"))

    self.grass1 = gfx.sprite.new(gfx.image.new("images/cutscenes/cutscene_hvsar_pov/grass"))
    self.grass1:setZIndex(5)
    self.grass1:moveTo(130, 160)

    self.grass2 = gfx.sprite.new(gfx.image.new("images/cutscenes/cutscene_hvsar_pov/grass"))
    self.grass2:setZIndex(5)
    self.grass2:moveTo(260, 120)

    self.grass3 = gfx.sprite.new(gfx.image.new("images/cutscenes/cutscene_hvsar_pov/grass"))
    self.grass3:setZIndex(5)
    self.grass2:moveTo(-340, 120)

    self.dandelionFar1 = gfx.sprite.new(gfx.image.new("images/cutscenes/cutscene_hvsar_pov/dandelion_far"))
    self.dandelionFar1:setZIndex(0)
    self.dandelionFar1:moveTo(111, 50)

    self.dandelionFar2 = gfx.sprite.new(gfx.image.new("images/cutscenes/cutscene_hvsar_pov/dandelion_far"))
    self.dandelionFar2:setZIndex(0)
    self.dandelionFar2:moveTo(-136, 50)

    self.dandelionClose1 = gfx.sprite.new(gfx.image.new("images/cutscenes/cutscene_hvsar_pov/dandelion"))
    self.dandelionClose1:setZIndex(3)
    self.dandelionClose1:moveTo(190, 120)

    self.dandelionClose2 = gfx.sprite.new(gfx.image.new("images/cutscenes/cutscene_hvsar_pov/dandelion"))
    self.dandelionClose2:setZIndex(5)
    self.dandelionClose2:moveTo(500, 150)

    self.dandelionClose3 = gfx.sprite.new(gfx.image.new("images/cutscenes/cutscene_hvsar_pov/dandelion"))
    self.dandelionClose3:setZIndex(4)
    self.dandelionClose3:moveTo(-340, 120)

    self.rightArrow = gfx.sprite.new(gfx.image.new("images/assets/rightArrow"))
    self.rightArrow:moveTo(200, 120)
    self.rightArrow:setZIndex(238)

    self.leftArrow = gfx.sprite.new(gfx.image.new("images/assets/leftArrow"))
    self.leftArrow:moveTo(200, 120)
    self.leftArrow:setZIndex(238)


    self.whatToAddTable = { self.grass1, self.grass2, self.grass3, self.dandelionFar1, self.dandelionFar2,
        self.dandelionClose11, self.dandelionClose2, self.dandelionClose3, self.cosmonautSprite } --TABLE CONTAINS STUFF TO ALWAYS ADD TO SCENE LIKE ENVIRONMENT

    -- FIRE BULLETS ANIMATION WITH COLLISION
    self.f1 = FireInstance()
    self.f2 = FireInstance()
    self.f3 = FireInstance()
    self.f4 = FireInstance()
    self.f5 = FireInstance()
    self.f6 = FireInstance()
    self.f7 = FireInstance()
    self.f8 = FireInstance()
    self.f9 = FireInstance()
    self.f10 = FireInstance()
    self.f11 = FireInstance()
    self.f12 = FireInstance()
    self.f13 = FireInstance()
    self.f14 = FireInstance()
    self.f15 = FireInstance()
    self.f16 = FireInstance()
    self.f17 = FireInstance()
    self.f18 = FireInstance()

    self.fireTable = { self.f1, self.f2, self.f3, self.f4, self.f5, self.f6, self.f7, self.f8, self.f9, self.f10,
        self.f11, self.f12, self.f13, self.f14, self.f15, self.f16, self.f17, self.f18 }
    self.fireID = 1 -- STARTING ID OF FIRE TABLE
    --SOUNDS ======================================================================
    self.glassSound = playdate.sound.fileplayer.new("sounds/glassSound")
    self.blindSound = playdate.sound.fileplayer.new("sounds/shootingSound")
    self.blindSound:setVolume(0.3)
    self.bumperCrashSound = playdate.sound.fileplayer.new("sounds/metalCrashSound")
    self.reloadSound = playdate.sound.fileplayer.new("sounds/reloadSound")
    self.reloadClick = playdate.sound.fileplayer.new("sounds/clickReload")
    self.aimSound = playdate.sound.fileplayer.new("sounds/aimSound")
    self.shootSound = playdate.sound.sampleplayer.new("sounds/20_boom_1")
    self.shootSound:setVolume(0.1)
    self.gutsSound = playdate.sound.fileplayer.new("sounds/stomach")
    self.gutsSound:setVolume(0.2)
    self.emptyShootSound = playdate.sound.fileplayer.new("sounds/emptyAmmo")
    self.emptyShootSound:setVolume(0.3)
    self.waveClearSound = playdate.sound.fileplayer.new("sounds/mainBlink")
    self.bgFight = playdate.sound.fileplayer.new("sounds/bgFight")
    self.bgFight:setVolume(0.1)
    -- self.newLifeForm = playdate.sound.fileplayer.new("sounds/newLifeForm")
    -- self.newLifeForm:setVolume(0.3)

    self.hitSound = playdate.sound.fileplayer.new("sounds/hit")
    self.canonRotateSound = playdate.sound.sampleplayer.new("sounds/hydraulicSound")
    self.canonRotateSound:setVolume(0.5)
    self.jumpscare = playdate.sound.fileplayer.new("sounds/grr")
    self.jumpscare:setVolume(2)
    self.beepSound = playdate.sound.fileplayer.new("sounds/doubleBeep")
    self.beepSound:setVolume(0.3)
    self.tankEmptySound = playdate.sound.fileplayer.new("sounds/tankEmpty")
    self.tankEmptySound:setVolume(0.2)
    self.roar3 = playdate.sound.fileplayer.new("sounds/roar3")
    self.roar3:setVolume(0.7)
    self.roar4 = playdate.sound.fileplayer.new("sounds/roar4")
    self.roar4:setVolume(0.8)

    self.fireDelayRemovalIterator = 0 -- COUNTER WHEN TO REMOVE BULLET SOUNDS IF IM NOT SHOOTING


    playdate.ui.crankIndicator:start()

    --ENEMIES------------------------------------------------------------------------------------------

    --WAVE MONSTERS ==============================================================================
    self.enemy1 = GutterAim(-200, 144, 3)
    self.enemy2 = GutterAim(0, 144, 3)
    self.enemy3 = GutterAim(200, 144, 3)
    self.enemy4 = GutterAim(400, 144, 3)
    self.enemy5 = GutterAim(600, 144, 3)

    self.enemyTable = { self.enemy1, self.enemy2, self.enemy3, self.enemy4, self.enemy5 }
    self.enemyID = 1

    --BOOLEANS COLLECTION=====================================
    self.canShoot = true
    self.crack1appear = false
    self.crack2appear = false
    self.crack3appear = false
    self.gutterCanMove = true
    self.canSpawn = false
    self.bumperIsActive = true
    self.checkIfBumperCollected = true
    self.reset = false
    self.displayRightArrow = false
    self.displayLeftArrow = false
    self.waveOneCompleted = false
    self.waveTwoCompleted = false
    self.waveThreeCompleted = false
    self.waveFourCompleted = false
    self.waveFiveCompleted = false
    self.tankEmptyInfo = true
    self.usingAmmo = false
    self.jumpscareBool = false
    self.finishGame = false

    --VALUES =======================================================================
    self.ammo = 400
    self.spawnCounter = 0
    self.crackCounter = 0
    self.hitScore = 0 -- HOW MANY GUTTER HAVE YOU KILLED
    self.timeBeforeHit = 0 --HOW LONG GUTTER STAYS CLOSE TO ROVER (INDEX 8)
    self.gutterMoveTime = 100
    self.spawnSpeed = 1
    self.reloadValue = 0
    self.drawTutorialCounter = 0
    self.waveType = 1
    self.finishExplosive = false
end

function Aim:updatework()
    if self.hitScore < 16 then
        self.bgFight:play()
    else
        self.bgFight:stop()
    end
    self.reload(self)

    self.horizont:add()
    self.uiSprite:add()
    self.uiAmmoBarSprite:add()
    self.gunLeftSprite:add()
    self.gunRightSprite:add()
    self.ammoSprite:add()
    self.kosmonaut.kosmonautSprite:remove()
    bg1:stop()
    self.currentReloadAnimation:updateFrame()
    self.pauseAfterWave(self)
    self.waveActivator(self)

    self.audio(self)
    self.displayArrows(self)
    self.checkBumper(self)
    self.uiAmmoBarLowAmmo(self)
    self.environmentManagement(self)
    self.ammoClipRect(self)
    self.updateEnemies(self)
    self.addCracksOnGlass(self)
    self.waveManagement(self)
    self.shootingManagement(self)
    self.updateFire(self)
    self.addingMissle(self)
    self.resetLevel(self)

    self.gutsSound:play()
    if self.hitScore == 16 and self.finishGame == false then
        --self.newLifeForm:play()
        self.finishGame = true
        self.waveClearSound:play()
        playdate.timer.performAfterDelay(3000, function()
            self.aimSound:stop()
            self.shootSound:stop()
            self.hitSound:stop()
            self.gutsSound:stop()
            self.blindSound:pause()
            self:changescreen(currentscreen, cutscenefinalscreen, gfx.image.kDitherTypeBayer8x8)
            cutscenefinalscreen.darkTheme:play()
            self.gutsSound:stop()
        end)

    end

    if self.hitScore == 15 and self.waveType == 2 and self.finishExplosive == false then
        self.finishExplosive = true
        playdate.timer.performAfterDelay(3000, function()
            gfx.clear()
            gfx.sprite:removeAll()
            self.aimSound:stop()
            self.shootSound:stop()
            self.hitSound:stop()
            self.gutsSound:stop()
            self.blindSound:pause()
            self.gutsSound:stop()
            self:changescreen(currentscreen, explosivescreen, gfx.image.kDitherTypeBayer8x8)
            explosivescreen:removeEnemiesFromTable()
            explosivescreen.roverPosX = 200
            explosivescreen.roverPosY = 200
            explosivescreen.kosmonaut.posX = 180
            explosivescreen.kosmonaut.posY = 180

        end)
    end

end

function Aim:draw()
    Aim.super.draw()
    if playdate.isCrankDocked() == true then
        playdate.ui.crankIndicator:update()
    end
    if self.waveType == 1 then
        gfx.drawText(16 - self.hitScore, 30, 200)
    elseif self.waveType == 2 then
        gfx.drawText(15 - self.hitScore, 30, 200)
    end
end

function Aim:waveActivator()
    -- print(self.canSpawn, "can spawn")
    -- print(self.reset, "reset")
    print(self.waveType)
    if self.canSpawn == true then
        if self.waveType == 1 then
            if self.hitScore == 0 then
                self.enemyTable[3]:activate()
            elseif self.hitScore == 1 then
                self.enemyTable[5]:activate()
            elseif self.hitScore == 2 then
                self.enemyTable[1]:activate()
            elseif self.hitScore == 3 then
                self.enemyTable[5]:activate()
            elseif self.hitScore == 4 then
                self.enemyTable[3]:activate()
            elseif self.hitScore == 5 then
                self.enemyTable[1]:activate()
                self.enemyTable[3]:activate()
            elseif self.hitScore == 7 then
                self.enemyTable[2]:activate()
                self.enemyTable[4]:activate()
            elseif self.hitScore == 9 then
                self.enemyTable[1]:activate()
                self.enemyTable[5]:activate()
            elseif self.hitScore == 11 then
                self.enemyTable[1]:activate()
                self.enemyTable[2]:activate()
                self.enemyTable[3]:activate()
                self.enemyTable[4]:activate()
                self.enemyTable[5]:activate()
            end
        elseif self.waveType == 2 then
            if self.hitScore == 0 then
                self.enemyTable[1]:activate()
                self.enemyTable[2]:activate()
                self.enemyTable[3]:activate()
                self.enemyTable[4]:activate()
                self.enemyTable[5]:activate()
            elseif self.hitScore == 5 then
                self.enemyTable[1]:activate()
                self.enemyTable[2]:activate()
                self.enemyTable[3]:activate()
                self.enemyTable[4]:activate()
                self.enemyTable[5]:activate()
            elseif self.hitScore == 10 then
                self.enemyTable[1]:activate()
                self.enemyTable[2]:activate()
                self.enemyTable[3]:activate()
                self.enemyTable[4]:activate()
                self.enemyTable[5]:activate()
            end
        end
    end
end

function Aim:ammoClipRect()
    self.ammoSprite:setClipRect(169, 209, self.ammoSpriteClipX, 16)
    if self.ammo > 2800 then
        self.ammoSpriteClipX = 89
    elseif self.ammo > 2600 then
        self.ammoSpriteClipX = 83
    elseif self.ammo > 2400 then
        self.ammoSpriteClipX = 77
    elseif self.ammo > 2200 then
        self.ammoSpriteClipX = 71
    elseif self.ammo > 2000 then
        self.ammoSpriteClipX = 65
    elseif self.ammo > 1800 then
        self.ammoSpriteClipX = 59
    elseif self.ammo > 1600 then
        self.ammoSpriteClipX = 53
    elseif self.ammo > 1400 then
        self.ammoSpriteClipX = 47
    elseif self.ammo > 1200 then
        self.ammoSpriteClipX = 41
    elseif self.ammo > 1000 then
        self.ammoSpriteClipX = 35
    elseif self.ammo > 800 then
        self.ammoSpriteClipX = 29
    elseif self.ammo > 600 then
        self.ammoSpriteClipX = 23
    elseif self.ammo > 400 then
        self.ammoSpriteClipX = 17
    elseif self.ammo > 200 then
        self.ammoSpriteClipX = 11
    elseif self.ammo > 0 then
        self.ammoSpriteClipX = 5
    else
        self.ammoSpriteClipX = 0
    end
end

function Aim:addCracksOnGlass()
    if self.gutterCanMove == false then
        playdate.timer.performAfterDelay(500, function()
            self.gutterFace.y += 4
            self.gutterFace:moveTo(self.gutterFace.x, self.gutterFace.y)


        end)
    else
        self.gutterFace:moveTo(200, 120)
    end


    if self.jumpscareBool == true and self.bumperIsActive == false then
        self.jumpscareBool = false
        self.gutterCanMove = false
        self.jumpscare:play()
        self.gutterFace:add()
        self.hitScore += 1
        self.crackCounter += 1
        if self.crackCounter == 1 then
            self.crack1:add()
        end
        if self.crackCounter == 2 then
            self.crack2:add()
        end
        if self.crackCounter == 3 then
            self.crack3:add()
        end

        playdate.timer.performAfterDelay(3000, function()
            self.gutterFace:remove()
            self.gutterFace:moveTo(200, 120)

        end)
        playdate.timer.performAfterDelay(5000, function()

            self.gutterCanMove = true

        end)

        self.glassSound:play()
    elseif self.jumpscareBool == true and self.bumperIsActive == true then

        self.bumperSprite:setRotation(5)
        self.bumperSprite:moveTo(self.bumperSprite.x, 260)

        self.gutterCanMove = false
        self.jumpscare:play()
        self.gutterFace:add()
        playdate.timer.performAfterDelay(3000, function()
            self.gutterFace:remove()
            self.gutterFace:moveTo(200, 120)


        end)
        playdate.timer.performAfterDelay(5000, function()

            self.gutterCanMove = true

        end)

        self.bumperIsActive = false
        self.jumpscareBool = false
        self.hitScore += 1
        for k, v in ipairs(self.kosmonaut.inventory) do

            if self.kosmonaut.inventory[k] == "bumper" then
                self.kosmonaut.inventory[k] = "empty"

            end
        end
        playdate.timer.performAfterDelay(2000, function()
            self.bumperSprite:remove()
            self.kosmonaut.bumperSpriteIcon:remove()

        end)
        self.bumperCrashSound:play()
    end
end

function Aim:environmentManagement()
    for k, v in pairs(self.whatToAddTable) do
        self.whatToAddTable[k]:add()
    end

    if playdate.buttonJustPressed(playdate.kButtonRight) then

        if self.horizont.x < 219 then
            for k, v in pairs(self.whatToAddTable) do
                self.whatToAddTable[k]:moveTo(self.whatToAddTable[k].x - 100, self.whatToAddTable[k].y)
                self.whatToAddTable[k].y += 10

                playdate.timer.performAfterDelay(40, function()
                    self.whatToAddTable[k]:moveTo(self.whatToAddTable[k].x - 100, self.whatToAddTable[k].y)
                    self.whatToAddTable[k].y -= 10
                end)

            end

            self.canonRotateSound:play(1)
            self.horizont:moveTo(self.horizont.x + 9, self.horizont.y)
        end
    end
    if playdate.buttonJustPressed(playdate.kButtonLeft) then

        if self.horizont.x > 183 then
            for k, v in pairs(self.whatToAddTable) do
                self.whatToAddTable[k]:moveTo(self.whatToAddTable[k].x + 100, self.whatToAddTable[k].y)
                self.whatToAddTable[k].y += 10

                playdate.timer.performAfterDelay(40, function()
                    self.whatToAddTable[k]:moveTo(self.whatToAddTable[k].x + 100, self.whatToAddTable[k].y)
                    self.whatToAddTable[k].y -= 10
                end)

            end

            self.canonRotateSound:play(1)
            self.horizont:moveTo(self.horizont.x - 9, self.horizont.y)
        end
    end


end

function Aim:reload()
    print("ammo", self.ammo)
    print("crank change", playdate.getCrankChange())
    print("reload value ", self.reloadValue)
    if playdate.getCrankChange() < -10 and self.canShoot == true
    then --RELOAD================================
        self.canShoot = false

        self.reloadSound:play()
        self.ammo += 3000
        self.gunLeftSprite:moveTo(self.gunLeftSprite.x, 0)
        self.gunRightSprite:moveTo(self.gunRightSprite.x, 0)
        playdate.timer.performAfterDelay(1000, function()
            self.gunLeftSprite:moveTo(self.gunLeftSprite.x, -10)
            self.gunRightSprite:moveTo(self.gunRightSprite.x, -10)
            self.canShoot = true

        end)
    end
    if playdate.getCrankChange() >= 0 then
        self.reloadValue = 0
    end
    if self.ammo > 3000 then
        self.ammo = 3000
    end
end

function Aim:uiAmmoBarLowAmmo()
    if self.ammo < 650 then
        playdate.timer.performAfterDelay(2000, function()
            if self.ammo < 650 then
                self.beepSound:play()
            end
        end)
        self.uiAmmoBarSprite:setClipRect(0, 0, 400, 240)

    else
        self.beepSound:stop()

        self.uiAmmoBarSprite:setClipRect(0, 180, 400, 240)
    end
end

function Aim:addingMissle()


    if playdate.getCrankChange() > 0 and self.ammo > 0 and self.canShoot == true then

        if playdate.getCrankTicks(8) == 1 then

            self.usingAmmo = true
            self.fireTable[self.fireID].fire:add()
            self.fireTable[self.fireID].empty:add()
            self.fireTable[self.fireID].canUpdate = true
            self.fireID += 1

        else
            self.usingAmmo = false
        end

        if self.fireID > 18 then
            self.fireID = 1
        end
    elseif playdate.getCrankChange() > 0 and self.ammo <= 0 and self.canShoot == true then
        self.emptyShootSound:play()
    end
end

function Aim:bumperShield()
    --printTable(self.bumperIsActive, "active or not")
    for k, v in pairs(self.kosmonaut.inventory) do
        if self.kosmonaut.inventory[k] == "bumper" then
            self.bumperSprite:add()
            self.bumperIsActive = true

        end
    end

end

function Aim:shootingManagement()
    if playdate.isCrankDocked() == false and playdate.getCrankChange() > 1 and
        math.abs(playdate.getCrankChange()) < 40 and self.ammo > 0 and self.canShoot == true and self.usingAmmo == true then
        self.ammo -= 70
        self.fireDelayRemovalIterator = 0
        self.blindSound:play()
        self.blindSound:setVolume(0.1)
        self.aimSound:play()
        self.aimSound:setVolume(0.2)

    elseif playdate.isCrankDocked() == false and playdate.getCrankChange() > 39 and self.ammo > 0 and
        self.canShoot == true and self.usingAmmo == true then
        self.ammo -= 90
        self.fireDelayRemovalIterator = 0
        self.blindSound:play()
        self.blindSound:setVolume(0.3)
        self.aimSound:play()
        self.aimSound:setVolume(0.4)


    else
        self.fireDelayRemovalIterator += 1
        if self.fireDelayRemovalIterator > 13 then
            self.blindSound:stop()
            self.aimSound:stop()
            self.fireDelayRemovalIterator = 0
        end
    end
end

function Aim:waveManagement()

end

function Aim:pauseAfterWave()

    if self.hitScore == 5 and self.waveOneCompleted == false then
        self.canSpawn = false

        playdate.timer.performAfterDelay(6000, function()
            self.canSpawn = true
            print("=======================================================================")

        end)

        self.waveOneCompleted = true
        self.waveClearSound:play()
        self.roar3:play()
    end
    if self.hitScore == 11 and self.waveTwoCompleted == false then
        self.canSpawn = false

        playdate.timer.performAfterDelay(6000, function()
            self.canSpawn = true
            print("=======================================================================")
        end)

        self.waveTwoCompleted = true
        self.waveClearSound:play()
        self.roar4:play()
    end
    if self.hitScore == 16 and self.waveThreeCompleted == false then
        self.canSpawn = false

        playdate.timer.performAfterDelay(6000, function()
            self.canSpawn = true
            print("=======================================================================")
        end)

        self.waveThreeCompleted = true
    end
    if self.hitScore == 21 and self.waveFourCompleted == false then
        self.canSpawn = false

        playdate.timer.performAfterDelay(6000, function()
            self.canSpawn = true
            print("=======================================================================")
        end)

        self.waveFourCompleted = true
    end
    if self.hitScore == 26 and self.waveFiveCompleted == false then
        self.canSpawn = false

        playdate.timer.performAfterDelay(6000, function()
            self.canSpawn = true
            print("=======================================================================")
        end)
        self.waveClearSound:play()
        self.waveFiveCompleted = true
    end

end

function Aim:audio()
    if self.tankEmptyInfo == true then
        playdate.timer.performAfterDelay(1500, function()

            self.tankEmptySound:play()
        end)
        self.tankEmptyInfo = false
    end
end

function Aim:displayArrows()

    if self.enemyTable[1].gutterAimSprite.x < 200 and self.enemyTable[1].isActive == true or
        self.enemyTable[2].gutterAimSprite.x < 200 and self.enemyTable[2].isActive == true or
        self.enemyTable[3].gutterAimSprite.x < 200 and self.enemyTable[3].isActive == true or
        self.enemyTable[4].gutterAimSprite.x < 200 and self.enemyTable[4].isActive == true or
        self.enemyTable[5].gutterAimSprite.x < 200 and self.enemyTable[5].isActive == true then
        self.displayLeftArrow = true
    else
        self.displayLeftArrow = false
    end

    if self.enemyTable[1].gutterAimSprite.x > 200 and self.enemyTable[1].isActive == true or
        self.enemyTable[2].gutterAimSprite.x > 200 and self.enemyTable[2].isActive == true or
        self.enemyTable[3].gutterAimSprite.x > 200 and self.enemyTable[3].isActive == true or
        self.enemyTable[4].gutterAimSprite.x > 200 and self.enemyTable[4].isActive == true or
        self.enemyTable[5].gutterAimSprite.x > 200 and self.enemyTable[5].isActive == true then
        self.displayRightArrow = true
    else
        self.displayRightArrow = false
    end

    if self.displayRightArrow == true then
        self.rightArrow:add()
    else
        self.rightArrow:remove()
    end

    if self.displayLeftArrow == true then
        self.leftArrow:add()
    else
        self.leftArrow:remove()
    end


end

function Aim:updateFire()
    for k, v in pairs(self.fireTable) do
        if self.fireTable[k].canUpdate == true then
            self.fireTable[k]:updateWork()
        end
    end
end

function Aim:checkBumper()

    if self.checkIfBumperCollected == true and secretscreen.secretBoxBool == true then
        self.bumperIsActive = false
        self.checkIfBumperCollected = false
        self.bumperShield(self)
    end

    if self.checkIfBumperCollected == true and secretscreen.secretBoxBool == false then
        self.bumperIsActive = true
        self.bumperSprite:add()
        self.kosmonaut:addToInventory("bumper")
        self.checkIfBumperCollected = false
        self.bumperShield(self)
    end
end

function Aim:updateEnemies()
    self.enemyTable[1]:updateWork()
    self.enemyTable[2]:updateWork()
    self.enemyTable[3]:updateWork()
    self.enemyTable[4]:updateWork()
    self.enemyTable[5]:updateWork()
end

function Aim:resetLevel()
    if self.reset == true then
        deathscreen.deathType = "AIM"
        self:changescreen(currentscreen, deathscreen, gfx.image.kDitherTypeBayer8x8)
        gfx.clear()
        gfx.sprite:removeAll()
        self.tankEmptyInfo = true
        self.crackCounter = 0
        self.canSpawn = false
        self.hitScore = 0
        self.ammo = 400
        self.crack1appear = false
        self.crack2appear = false
        self.crack3appear = false
        self.spawnCounter = 0
        self.gutterCanMove = false
        self.timeBeforeHit = 0


        self.reset = false
    end
    if self.crackCounter == 3 then
        self.reset = true

    end

end
