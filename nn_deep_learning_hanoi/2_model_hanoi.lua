require 'torch'
require 'image'
require 'nn'

noutputs = 4

nfeats = 3
width = 32
height = 32
ninputs = nfeats * width * height
nhiddens = ninputs / 2

model = nn.Sequential()
model:add(nn.SpatialConvolutionMM(3, 8, 5, 5))
model:add(nn.ReLU())
model:add(nn.SpatialSubSampling(8, 2, 2, 2, 2))

model:add(nn.SpatialConvolutionMM(8, 20, 5, 5))
model:add(nn.ReLU())
model:add(nn.SpatialSubSampling(20, 2, 2, 2, 2))

model:add(nn.SpatialConvolutionMM(20, 16, 5, 5))
model:add(nn.Reshape(16))
model:add(nn.Linear(16, 8))
model:add(nn.ReLU())
model:add(nn.Linear(8, 4))	