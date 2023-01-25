import "lua/screens/levels/crank"

class("DataStore").extends()

local gfx <const> = playdate.graphics

function DataStore:init()
--   --CURRENT SCENE --
--   CURRENT_SCREEN = currentscreen

--   --ITEMS --

--   CRANK_BOOL = crankscreen.crankBool
--   CRANK_COLLECTED = capsulestartscreen.kosmonaut.crankCollected

--   --PLAYER POSITION --
--   PLAYER_X = capsulestartscreen.kosmonaut.posX
--   PLAYER_Y = capsulestartscreen.kosmonaut.posY

--   --CUTSCENES--
--   PLAINS_GUTTER_INTRO = plainsscreen.gutterIntro1
--   CEMETERY_GUTTER_INTRO = cemeteryscreen.gutterIntro2

--   --SECRET --
--   SECRET_BOX_BOOL = secretscreen.secretBoxBool
end

function DataStore:saveGameData()
    local gameData = {
        currentscreen = currentscreen,
        crankbool = CRANK_BOOL,
        crankcollected = CRANK_COLLECTED,
        playerx = PLAYER_X,
        playery = PLAYER_Y,
        plainsgutterintro = plainsscreen.gutterIntro1,
        cemeterygutterintro = CEMETERY_GUTTER_INTRO,
        secretboxbool = SECRET_BOX_BOOL
    }
    playdate.datastore.write(gameData)
end

function DataStore:loadGameData()
    local gameData = playdate.datastore.read()
    if gameData then
        CURRENT_SCREEN = gameData.currentscreen
        CRANK_BOOL = gameData.crankbool
        CRANK_COLLECTED = gameData.crankcollected
        PLAYER_X = gameData.playerx
        PLAYER_Y = gameData.playery
        PLAINS_GUTTER_INTRO = gameData.plainsgutterintro
        CEMETERY_GUTTER_INTRO = gameData.cemeterygutterintro
        SECRET_BOX_BOOL = gameData.secretboxbool
    end
end

function DataStore:updateInput()
  


    -- if playdate.buttonJustPressed(playdate.kButtonB) then
    --     print("saving game state")
    --     self.saveGameData(self)
    -- end
    -- if playdate.buttonJustPressed(playdate.kButtonDown) then
    --     print("loading game state")
    --     self.loadGameData(self)

    -- end

    -- if playdate.buttonJustPressed(playdate.kButtonLeft) then
    --     print(PLAINS_GUTTER_INTRO)
    --     --currentscreen:changescreen(currentscreen)

    -- end
end
