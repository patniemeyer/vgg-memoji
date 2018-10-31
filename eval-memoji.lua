
--[[
  This script grabs screenshots from a specified region of the screen, scores them with VGG Face against a folder of reference photos, and saves each captured image to a folder naming the file with its score. The script waits for you to hit enter on the keyboard for each capture.
--]]

-- The reference images that we want to match with the generated images
-- e.g. real world photos of people.
local refsFolder = "pics/obama"
local refsPattern = "*.png"

-- The x,y,w,h of the screen to grab with screen capture.
local grabRegion="145,70,190,190"
local grabFileName="screen.png"

-- The folder where scored images are stored.
local outFolder="out"

--
-- Main
--

require 'image'
require 'nn'
require 'image'
paths.dofile('util.lua')
paths.dofile('files.lua')
paths.dofile('compare.lua')
local pl = require('pl.import_into')() printf = pl.utils.printf

-- There shouldn't be any randomness involved here but I always do this.
torch.manualSeed(42) 

net = torch.load('./torch_model/VGG_FACE.t7')
print(net)
net:evaluate()

-- The layers for which we will do the evaluation. 
-- Layer 38 output is the 4096 element vector that characterizes the face, just before the prediction layer.
local selectedLayer = 38

-- Load the reference files
local refs = {}
local files = scandir(refsFolder, refsPattern)
for i,file in pairs(files) do
  local refImg = process(image.load(file,3,'float'))
  net:forward(refImg)
  table.insert(refs,net.modules[selectedLayer].output:clone())
end

local count=0
while true do
  grabImage(grabRegion, grabFileName)
  -- Compare the references with each file in the targets folder
  local result = compareFile(selectedLayer, refs, grabFileName)
  print("result: ", result)

  local img = image.load(grabFileName,3,'float')
  image.save(outFolder..'/'..refsFolder..result.."-"..count..".jpg", img)
  win=image.display{ image=img, legend="score: "..result, win=win }
  print("hit enter")
  readline()
  count = count + 1
end


