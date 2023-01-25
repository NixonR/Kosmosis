import "CoreLibs/sprites"

local gfx <const> = playdate.graphics

class('AssetsManager').extends()

function AssetsManager:init()

    self.imagesAssetsKey = {}
    self.imagesAssetsValue = {}
    self.imagesAssetCounter = 1;

    self.soundsAssetsKey = {}
    self.soundsAssetsValue = {}
    self.soundsAssetCounter = 1;
end

function AssetsManager:getImageWithPath(path)

    for i = 1, self.imagesAssetCounter do

        if(self.imagesAssetsKey[i] == path) then
            if(self.imagesAssetsValue[i] == nil) then
                self.imagesAssetsValue[i] = playdate.graphics.image.new(path)
            end
            return self.imagesAssetsValue[i]
        end
    end

    self.imagesAssetsKey[self.imagesAssetCounter] = path
    image = playdate.graphics.image.new(path)
    self.imagesAssetsValue[self.imagesAssetCounter] = image
    self.imagesAssetCounter += 1

    return image
end

function AssetsManager:freeImage(path)
    for i = 1, self.imagesAssetCounter do
        if(self.imagesAssetsKey[i] == path) then
           self.imagesAssetsValue[i] = nil;
        end
    end
end

function AssetsManager:getSoundWithPath(path)

    for i = 1, self.soundsAssetCounter do

        if(self.soundsAssetsKey[i] == path) then
            if(self.soundsAssetsValue[i] == nil) then
                self.soundsAssetsValue[i] = playdate.sound.sampleplayer.new(path)
            end
            return self.soundsAssetsValue[i]
        end
    end

    self.soundsAssetsKey[self.imagesAssetCounter] = path
    sound = playdate.sound.sampleplayer.new(path)
    self.soundsAssetsValue[self.soundsAssetCounter] = sound
    self.soundsAssetCounter += 1

    return sound
end

function AssetsManager:freeSound(path)
    for i = 1, self.soundsAssetCounter do
        if(self.soundsAssetsKey[i] == path) then
           self.soundsAssetsValue[i] = nil;
        end
    end
end