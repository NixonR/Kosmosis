-- import "lua/enemyScripts/gutter"
import "lua/spriteanimation"
import "CoreLibs/timer"
import "CoreLibs/sprites"
import "lua/enemyScripts/gutter/tail"
import "CoreLibs/frameTimer"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class('Tail').extends()

function Tail:init(x, y)
    self.playerIsDead = false
    self.tailSprite = gfx.sprite.new()
    self.tailSprite:setZIndex(2)


    self.Tail1 = gfx.sprite.new(gfx.image.new("images/gutter/guuter_segment_round1"))
    -- self.Tail2 = gfx.sprite.new(gfx.image.new("images/gutter/guuter_segment_round2"))
    -- self.Tail3 = gfx.sprite.new(gfx.image.new("images/gutter/guuter_segment_round3"))
    -- self.Tail4 = gfx.sprite.new(gfx.image.new("images/gutter/guuter_segment_round4"))
    -- self.Tail5 = gfx.sprite.new(gfx.image.new("images/gutter/guuter_segment_round5"))


    self.tailSprite = self.Tail1
end

function Tail:updateWork()
    self.playerIsDead = Kosmonaut:returnPlayerIsDead()
    
    --print(hideTail)
    -- function Tail:tailMoving(tailSpriteTable, tailPositionTable)
    --     if hideTail == false then
    --         for k, v in ipairs(tailSpriteTable) do
    --             tailSpriteTable[k]:moveTo(tailPositionTable[k][1], tailPositionTable[k][2])
    --             tailSpriteTable[k]:changeSegmentSprite()
    --             tailSpriteTable[k].tailSprite:setZIndex(2)
    --             tailSpriteTable[k]:add()
    --         end
    --     elseif hideTail == true then 
    --         for k, v in ipairs(tailSpriteTable) do
    --             tailSpriteTable[k]:removeFromScene()
              
    --         end
            
    --     end
    -- end

end

-- function Tail:changeSegmentSprite()
--     randomTailSegmentValue = math.random(1, 10)
--     if randomTailSegmentValue == 1 then
--         self.tailSprite = self.Tail1
--     elseif randomTailSegmentValue == 2 then
--         self.tailSprite = self.Tail2
--     elseif randomTailSegmentValue == 3 then
--         self.tailSprite = self.Tail3
--     elseif randomTailSegmentValue == 4 then
--         self.tailSprite = self.Tail4
--     elseif randomTailSegmentValue == 5 then
--         self.tailSprite = self.Tail5
--     end
-- end

function Tail:moveBy(x, y)
    self.tailSprite:moveBy(x, y)
end

function Tail:moveTo(x, y)
    self.tailSprite:moveTo(x, y)
end

function Tail:add()
    self.tailSprite:add()
end

function Tail:remove()
    self.tailSprite:remove()
end

-- function Tail:tailPosition(tailPositionTable, OldGutterPositionX, OldGutterPositionY)
--     for k, v in ipairs(tailPositionTable) do
--         local x, y = v[1], v[2] -- k 0.0        --0.0
--         v[1], v[2] = OldGutterPositionX, OldGutterPositionY -- k 100,100    k 0, 0
--         OldGutterPositionX, OldGutterPositionY = x, y -- old 0.0      k


--     end
-- end
