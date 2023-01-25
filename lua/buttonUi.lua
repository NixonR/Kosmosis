import "CoreLibs/timer"
import "CoreLibs/sprites"
import "lua/spriteanimation"
import "lua/enemyScripts/enemy"
import "lua/screens/level"


local pd <const> = playdate
local gfx <const> = playdate.graphics

class('ButtonUI').extends()

function ButtonUI:init(x, y, button)
    self.font1 = playdate.graphics.font.new("font/Asheville/Asheville Sans 14 Light/Asheville-Sans-14-Light")
    self.glyphA = self.font1:getGlyph("Ⓐ")
    self.glyphB = self.font1:getGlyph("Ⓑ")
    self.uiButtonA = gfx.sprite.new(self.glyphA)
    self.uiButtonA:setZIndex(1001)
    self.uiButtonB = gfx.sprite.new(self.glyphB)
    self.uiButtonB:setZIndex(1001)

    
   

    self.uiButtonIsEnabled = false

    --self.sX = 0.6

    self.buttonIterator = 1
    if button == "A" then
        self.uiButton = self.uiButtonA

    elseif button == "B" then
        self.uiButton = self.uiButtonB
    end
    if self.uiButton ~= nil then
        self.uiButton:moveTo(x, y)
    end

end

function ButtonUI:updateInput()

end

function ButtonUI:updateWork()

    self.buttonAnim(self)
end

function ButtonUI:buttonAnim()
    --self.uiButton:setScale(self.sX, 1)
    self.buttonIterator += 1


    if self.buttonIterator == 20 then
        self.uiButton:moveTo(self.uiButton.x, self.uiButton.y + 3)
    end
    if self.buttonIterator == 1 then
        self.uiButton:moveTo(self.uiButton.x, self.uiButton.y - 3)
    end
    if self.buttonIterator > 30 then
        self.buttonIterator = 0
    end

    if self.uiButtonIsEnabled == true then
        self.uiButton:add()
        -- if self.sX < 1 then
      
        --     self.sX += 0.1

        -- end

    else
        self.uiButton:remove()
        --self.sX = 0.6

    end
end
