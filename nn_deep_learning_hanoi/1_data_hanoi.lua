require 'torch'
require 'image'
require 'nn'


-- log(0) = -inf, 0 is from initializing qlearning table and apparently some state is never reached
function preprocess_labels(dataset)
   for i = 1, dataset:size() do
      for j = 1, 4 do
         if dataset.labels[i][j] == 0 then
            dataset.labels[i][j] = 0.001
         end
      end
   end
end



-- load dataset obtained from QLearning
loaded = torch.load("dataset32x32_alterated.t7")
no_states = loaded.y:size()[2]
no_actions = loaded.y:size()[3]

-- 80% samples for training and 20% samples for testing
samples_train = math.floor(0.8*no_states)
samples_test = no_states - samples_train

-- allocate memory for shuffled dataset
shuffleData = {}
shuffleData.X = torch.ByteTensor(loaded.X:size())
shuffleData.y = torch.DoubleTensor(loaded.y:size())
shuffleIndeces = torch.randperm(no_states)

for i = 1, no_states do
	shuffleData.X[i] = loaded.X[shuffleIndeces[i]]
	shuffleData.y[1][i] = loaded.y[1][shuffleIndeces[i]]
end

-- rotate data 90 degrees
shuffleData.X = shuffleData.X:transpose(3,4):float()


-- split data for training and testing
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



-- transform from rgb to yuv
for i = 1,trainData:size() do
   trainData.data[i] = image.rgb2yuv(trainData.data[i])
end

-- process labels: eliminate 0 values
preprocess_labels(trainData)
preprocess_labels(testData)

trainData.labels = torch.log(trainData.labels)
testData.labels = torch.log(testData.labels)


channels = {'y','u','v'}
-- channel normalization
mean = {}
std = {}

for i,channel in ipairs(channels) do
   -- normalize each channel globally:
   mean[i] = trainData.data[{ {},i,{},{} }]:mean()
   std[i] = trainData.data[{ {},i,{},{} }]:std()
   trainData.data[{ {},i,{},{} }]:add(-mean[i])
   trainData.data[{ {},i,{},{} }]:div(std[i])
end
-- use the same mean,std computed for training
for i,channel in ipairs(channels) do
   -- normalize each channel globally:
   testData.data[{ {},i,{},{} }]:add(-mean[i])
   testData.data[{ {},i,{},{} }]:div(std[i])
end

-- normalize label in 0..1

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



neighbourhood = image.gaussian1D(13)
-- give importance to the closest pixels
--[[
neighbourhood = [
   0.1819
   0.3062
   0.4689
   0.6531
   0.8275
   0.9538
   1.0000
   0.9538
   0.8275
   0.6531
   0.4689
   0.3062
   0.1819
   ]
]]--

-- Define our local normalization operator (It is an actual nn module, 
-- which could be inserted into a trainable model):
normalization = nn.SpatialContrastiveNormalization(1, neighbourhood, 1):float()

-- Normalize all channels locally:
for c in ipairs(channels) do
   for i = 1,trainData:size() do
      trainData.data[{ i,{c},{},{} }] = normalization:forward(trainData.data[{ i,{c},{},{} }])
   end
end


