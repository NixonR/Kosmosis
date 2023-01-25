import "CoreLibs/object"

class("State").extends()

function State:init(objectToControl)
    self.active = false
    self.objectToControl = objectToControl
end

function State:onEnter()
    self.active = true
end

function State:onExit()
    self.active = false
end

function State:onWork()
end

function State:work()
    if(self.active)then
        self:onWork()
    end
end

function State:changeState(previousState, newState)
    if(previousState ~= nil)then
        previousState:onExit()
    end
    newState:onEnter()
    return newState
end

