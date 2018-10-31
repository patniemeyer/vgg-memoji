

-- Grab a region of the screen and evalute it (display it for confirmation)
-- (x,y,w,h) e.g. "100,100,256,256"
-- Note that for purposes of this project we need 224x224 square images so the region
-- must be square and we scale them.
function grabImage(grabRegion, fileName)
  local i, t, popen = 0, {}, io.popen
  local cmd='screencapture -x -R'..grabRegion..' '..fileName..'; sips -Z 224 '..fileName
  local pfile = popen(cmd)
  pfile:close()
  local img = image.load(fileName,3,'float')
end

-- Convert an input image from float to 0-255 and reverse the layers to BGR.
-- We also subtract the mean BGR values from the training set as supplied and instructed by the VGG Face.
function process(img) 
  img = img*255
  mean = {129.1863,104.7624,93.5940}
  local imageBgr = img:index(1,torch.LongTensor{3,2,1})
  for i=1,3 do imageBgr[i]:add(-mean[i]) end -- Should these be clamped?
  return imageBgr
end

function indexsort(tbl)
  return (table.unpack or unpack)(indexsortTable(tbl))
end

function indexsortTable(tbl)
  local idx = {}
  for i = 1, #tbl do idx[i] = i end 
  table.sort(idx, function(a, b) return tbl[a] > tbl[b] end)
  return idx
end

function sleep(n)
  os.execute("sleep " .. tonumber(n))
end

function readline()
  os.execute("read")
end

