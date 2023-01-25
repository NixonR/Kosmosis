import "CoreLibs/object"
import "lua/statesFramework/state"

class("TestState").extends("State")


function TestState:onEnter()
    TestState.super.onEnter(self)
    --print("TestState onEnter and print size of objectToControl that is an image")
    --print(self.objectToControl:getSize())
end

function TestState:onExit()
    TestState.super.onExit(self)
    --print("TestState onExit")
end

function TestState:onWork()
    TestState.super.onWork(self)
    --print("TestState onWork")
end
