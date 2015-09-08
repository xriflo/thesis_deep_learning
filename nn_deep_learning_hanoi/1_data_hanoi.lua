require 'torch'
require 'image'
require 'nn'

function preprocess_labels(dataset)
   for i = 1, dataset:size() do
      for j = 1, 4 do
         if dataset.labels[i][j] == 0 then
            dataset.labels[i][j] = 0.001
         end
      end
   end
end



-- Load dataset obtained from QLearning
loaded = torch.load("dataset32x32_alterated.t7")
no_states = loaded.y:size()[2]
no_actions = loaded.y:size()[3]
samples_train = math.floor(0.8*no_states)
samples_test = no_states - samples_train

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
   data = shuffleData.X[{ {1, samples_train} }],
   labels = shuffleData.y[1][{ {1, samples_train} }],
   size = function() return samples_train end
}
testData = {
   data = shuffleData.X[{ {samples_train+1, no_states} }],
   labels = shuffleData.y[1][{ {samples_train+1, no_states} }],
   size = function() return samples_test end
}



print '==> preprocessing data: colorspace RGB -> YUV'
for i = 1,trainData:size() do
   trainData.data[i] = image.rgb2yuv(trainData.data[i])
end

-- process labels
preprocess_labels(trainData)
preprocess_labels(testData)

trainData.labels = torch.log(trainData.labels)
testData.labels = torch.log(testData.labels)


-- Normalize each channel, and store mean/std
-- per channel. These values are important, as they are part of
-- the trainable parameters. At test time, test data will be normalized
-- using these values.
channels = {'y','u','v'}
print '==> preprocessing data: normalize each feature (channel) globally'
mean = {}
std = {}

for i,channel in ipairs(channels) do
   -- normalize each channel globally:
   mean[i] = trainData.data[{ {},i,{},{} }]:mean()
   std[i] = trainData.data[{ {},i,{},{} }]:std()
   trainData.data[{ {},i,{},{} }]:add(-mean[i])
   trainData.data[{ {},i,{},{} }]:div(std[i])
end

for i,channel in ipairs(channels) do
   -- normalize each channel globally:
   testData.data[{ {},i,{},{} }]:add(-mean[i])
   testData.data[{ {},i,{},{} }]:div(std[i])
end

-- Normalize test data, using the training means/stds

print '==> normalize labels in 0..1'

A = math.min(trainData.labels:min(), testData.labels:min())
B = math.max(trainData.labels:max(), testData.labels:max())
a = 0
b = 1
trainData.labels:add(a-A)
trainData.labels:mul(b-a)
trainData.labels:div(B-A)
testData.labels:add(a-A)
testData.labels:mul(b-a)
testData.labels:div(B-A)


--trainData.labels = trainData.labels:double()
--testData.labels = testData.labels:double()
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
end

----------------------------------------------------------------------
print '==> verify statistics'

-- It's always good practice to verify that data is properly
-- normalized.

for i,channel in ipairs(channels) do
   trainMean = trainData.data[{ {},i }]:mean()
   trainStd = trainData.data[{ {},i }]:std()

   print('training data, '..channel..'-channel, mean: ' .. trainMean)
   print('training data, '..channel..'-channel, standard deviation: ' .. trainStd)

end

----------------------------------------------------------------------


