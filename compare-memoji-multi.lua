
--[[
  This script takes a folder of references and a folder of target photos and uses VGG Face to rank the targets based on the output of a selected layer of the network and a simple dot product similarity measure. The top three matching images are displayed along with their scores.

  If you have a folder of ranked output from eval-memoji.lua representing e.g. a Memoji with each feature variation, you can run this script on that output folder to match new reference files or experiment with other similarity metrics.
--]]

-- These are the images you want to score or select from. 
-- e.g. a series of Memoji with different features.
local targetsFolder = "pics/memoji"
local targetsPattern = "*.png"

-- These are the reference photos you want to match.
-- e.g. real world photos of people.
local refsFolder = "pics/obama"
local refsPattern = "*.png" 

--
-- Main
--

require 'image'
require 'nn'
paths.dofile('util.lua')
paths.dofile('files.lua')
paths.dofile('compare.lua')
local pl = require('pl.import_into')() printf = pl.utils.printf

net = torch.load('./torch_model/VGG_FACE.t7')
print(net)
net:evaluate()

-- The range of layers for which we will do the evaluation. 
-- Layer 38 output is the 4096 element vector that characterizes the face, just before the prediction layer.
-- Layer 32 is the last pooling before the fully connected layers.
for selectedLayer = 38,38 do -- 1, 40

  -- Load the reference files
  print("Comparing reference files: ", refsFolder, refsPattern, "with targets: ", targetsFolder)
  local refs = {}
  local files = scandir(refsFolder, refsPattern)
  for i,file in pairs(files) do
    local refImg = process(image.load(file,3,'float'))
    net:forward(refImg)
    local output = net.modules[selectedLayer].output:clone()
    table.insert(refs,output)
  end

  -- Compare the references with each file in the targets folder
  local results = {}
  local files = scandir(targetsFolder, targetsPattern)
  for i,file in pairs(files) do
    results[i] = compareFile(selectedLayer, refs, file)
  end

  -- Sort and display the results
  local maxids = indexsortTable(results)
  for i=1, 3 do -- Display the top 3 ranked images
    print("i: ", i, "maxval: ", results[maxids[i]], "file: ", files[maxids[i]]) 
    local img = image.load(files[maxids[i]],3,'float')
    local legend = string.format("l: %i, #: %i, val: %0.3f", selectedLayer, i, results[maxids[i]])
    win=image.display{ image=img, legend=legend }
  end

end

