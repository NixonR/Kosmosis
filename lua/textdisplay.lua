import "CoreLibs/timer"
import "CoreLibs/sprites"
import "lua/spriteanimation"
import "lua/enemyScripts/enemy"
import "lua/screens/level"
import "CoreLibs/string"
import "CoreLibs/graphics"


local pd <const> = playdate
local gfx <const> = playdate.graphics

class('TextDisplay').extends()

function TextDisplay:init(x, y, string)

    self.stringToDraw = string
    self.textLength = #self.stringToDraw
    self.textTable = {}
    self.x = x
    self.y = y
    self.clipX = 0
    self.keyboardTyping = playdate.sound.sampleplayer.new("sounds/keyboardTyping")
    self.delay = 0
    self.fontDisplay = gfx.font.new("font/Full Circle/font-full-circle")
    self.fontFamilyTable = {self.fontDisplay}
    self.family = playdate.graphics.setFontFamily(self.fontFamilyTable)
    self.textDelayValue = 2
    
    

    for i = 1, self.textLength do
        self.textTable[i] = self.stringToDraw:sub(i, i)
    end

end

function TextDisplay:updateInput()

end

function TextDisplay:updateWork()
    print(gfx.getTextSize(self.stringToDraw, self.family, kTextAlignment.left), "text size")
    print( playdate.graphics.getTextSizeForMaxWidth(self.stringToDraw, 400, kTextAlignment.left, self.fontDisplay))
    
    self.delay += 1
    print(self.clipX, "clip")
    if self.clipX < playdate.graphics.getTextSizeForMaxWidth(self.stringToDraw, 400, kTextAlignment.left, self.fontDisplay) then
        if self.delay > self.textDelayValue then
            self.clipX += 9
            self.keyboardTyping:play()
            self.delay = 0
        end
    else
        self.keyboardTyping:stop()
    end
    
end

function TextDisplay:draw()

    gfx.drawTextInRect(self.stringToDraw, self.x, self.y, self.clipX, 20, kTextAlignment.center, nil, nil,
        self.fontDisplay)
end
