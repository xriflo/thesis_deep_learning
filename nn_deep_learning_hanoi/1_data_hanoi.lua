require 'torch'
require 'image'
require 'nn'

function printData(trainData)
	for i = 1, 160 do
		print("UP = "..trainData.labels[i][1])
		print("DOWN = "..trainData.labels[i][2])
		print("LEFT = "..trainData.labels[i][3])
		print("RIGHT = "..trainData.labels[i][4])
		itorch.image(trainData.data[{ i }])
		print("\n")
	end
end


-- Load dataset obtained from QLearning
loaded = torch.load("dataset32x32.t7")
no_states = loaded.y:size()[2]
no_actions = loaded.y:size()[3]

-- Percent value of samples for training/test
percent_samples_training = 0.8
no_samples_training = math.floor(percent_samples_training * no_states)
no_samples_testing = no_states - no_samples_training

-- Shuffle data
shuffleData = {}
shuffleData.X = torch.ByteTensor(loaded.X:size())
shuffleData.y = torch.DoubleTensor(loaded.y:size())
shuffleIndeces = torch.randperm(no_states)

for i = 1, no_states do
	shuffleData.X[i] = loaded.X[shuffleIndeces[i]]
	shuffleData.y[1][i] = loaded.y[1][shuffleIndeces[i]]
end

shuffleData.X = shuffleData.X:transpose(3,4):float()

-- Split data for training and testing
trainData = {
   data = shuffleData.X[{ {1, no_samples_training} }],
   labels = shuffleData.y[1][{ {1, no_samples_training} }],
   size = function() return no_samples_training end
}

testData = {
   data = shuffleData.X[{ {no_samples_training+1, no_samples_training+no_samples_testing} }],
   labels = shuffleData.y[1][{ {no_samples_training+1, no_samples_training+no_samples_testing} }],
   size = function() return no_samples_testing end
}

print '==> preprocessing data: colorspace RGB -> YUV'
for i = 1,trainData:size() do
   trainData.data[i] = image.rgb2yuv(trainData.data[i])
end
for i = 1,testData:size() do
   testData.data[i] = image.rgb2yuv(testData.data[i])
end

channels = {'y','u','v'}

-- Normalize each channel, and store mean/std
-- per channel. These values are important, as they are part of
-- the trainable parameters. At test time, test data will be normalized
-- using these values.
print(trainData.data:type())
print '==> preprocessing data: normalize each feature (channel) globally'
mean = {}
std = {}
print(trainData.data:size())
for i,channel in ipairs(channels) do
   -- normalize each channel globally:
   mean[i] = trainData.data[{ {},i,{},{} }]:mean()
   std[i] = trainData.data[{ {},i,{},{} }]:std()
   trainData.data[{ {},i,{},{} }]:add(-mean[i])
   trainData.data[{ {},i,{},{} }]:div(std[i])
end

-- Normalize test data, using the training means/stds
for i,channel in ipairs(channels) do
   -- normalize each channel globally:
   testData.data[{ {},i,{},{} }]:add(-mean[i])
   testData.data[{ {},i,{},{} }]:div(std[i])
end

-- Local normalization
print '==> preprocessing data: normalize all three channels locally'

-- Define the normalization neighborhood:
neighborhood = image.gaussian1D(13)

-- Define our local normalization operator (It is an actual nn module, 
-- which could be inserted into a trainable model):
normalization = nn.SpatialContrastiveNormalization(1, neighborhood, 1):float()

-- Normalize all channels locally:
for c in ipairs(channels) do
   for i = 1,trainData:size() do
      trainData.data[{ i,{c},{},{} }] = normalization:forward(trainData.data[{ i,{c},{},{} }])
   end
   for i = 1,testData:size() do
      testData.data[{ i,{c},{},{} }] = normalization:forward(testData.data[{ i,{c},{},{} }])
   end
end

----------------------------------------------------------------------
print '==> verify statistics'

-- It's always good practice to verify that data is properly
-- normalized.

for i,channel in ipairs(channels) do
   trainMean = trainData.data[{ {},i }]:mean()
   trainStd = trainData.data[{ {},i }]:std()

   testMean = testData.data[{ {},i }]:mean()
   testStd = testData.data[{ {},i }]:std()

   print('training data, '..channel..'-channel, mean: ' .. trainMean)
   print('training data, '..channel..'-channel, standard deviation: ' .. trainStd)

   print('test data, '..channel..'-channel, mean: ' .. testMean)
   print('test data, '..channel..'-channel, standard deviation: ' .. testStd)
end

----------------------------------------------------------------------
print '==> visualizing data'

-- Visualization is quite easy, using itorch.image().
--[[

   first256Samples_y = trainData.data[{ {1,trainData:size()},1 }]
   first256Samples_u = trainData.data[{ {1,trainData:size()},2 }]
   first256Samples_v = trainData.data[{ {1,trainData:size()},3 }]
   itorch.image(first256Samples_y)
   itorch.image(first256Samples_u)
   itorch.image(first256Samples_v)
]]--
 


