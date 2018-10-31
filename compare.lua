
-- Load the image at fileName, run it through the network, and compare the output tensor at selectedLayer 
-- with the the refs tensors returning the average dot product.
function compareFile(selectedLayer, refs, fileName)
  --print("load fileName: ", fileName)
  local img = process(image.load(fileName,3,'float'))
  net:forward(img)
  --print("output layer size: ", net.modules[selectedLayer].output:size())
  local output = net.modules[selectedLayer].output:clone()
  return compareTensors(refs, output, fileName)
end

-- Compare reference tensors to a target tensor and return the average dot product
function compareTensors(refs, target, targetName)
  local sum = 0
  if #refs == 0 then
    print("no reference images")
    os.exit(1)
  end
  --print('comparing with '..#refs..' ref images')
  for i = 1, #refs do
    local ref  = refs[i]

    -- Simple dot works pretty well
    local dotself = torch.dot(ref , ref) -- for normalization, dot with self is just mag squared 
    sum = sum + torch.dot(ref, target) / dotself

    -- Trying straight up distance.  Note: need to reverse sort max/min.
    --sum = sum + torch.dist(ref,target)  

    -- Trying mean squred error.  Note: need to reverse sort max/min.
    --local mse = nn.MSECriterion()
    --mse.sizeAverage = false
    --local loss = mse:forward(ref,target) print("loss=", loss)
    --sum = sum + loss -- note, max/min reversed
  end

  return sum / #refs
end



