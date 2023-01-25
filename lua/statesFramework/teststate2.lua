import "CoreLibs/object"
import "lua/statesFramework/state"


class("TestState2").extends("State")

local gfx <const> = playdate.graphics
function TestState2:onEnter()
    TestState2.super.onEnter(self)
    --print("TestState2 onEnter")

end

function TestState2:onExit()
    TestState2.super.onExit(self)
    --print("TestState2 onExit")
end

function TestState2:onWork()
    TestState2.super.onWork(self)
    --print("TestState2 onWork")
    
end
