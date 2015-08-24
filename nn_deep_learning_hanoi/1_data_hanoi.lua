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

shuffleData.X:transpose(3,4):float()


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

print(trainData.data:size())




