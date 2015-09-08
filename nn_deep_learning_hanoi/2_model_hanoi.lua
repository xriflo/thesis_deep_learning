require 'torch'
require 'image'
require 'nn'

noutputs = 4

nfeats = 3
width = 32
height = 32
ninputs = nfeats * width * height
nhiddens = ninputs / 2

nstates = {8,20,120,100}
filtsize = 5
poolsize = 2
normkernel = image.gaussian1D(7)

model = nn.Sequential()

model:add(nn.SpatialConvolutionMM(3, 8, 5, 5))
model:add(nn.Tanh())
model:add(nn.SpatialSubSampling(8, 2, 2, 2, 2))

model:add(nn.SpatialConvolutionMM(8, 20, 5, 5))
model:add(nn.Tanh())
model:add(nn.SpatialSubSampling(20, 2, 2, 2, 2))

model:add(nn.SpatialConvolutionMM(20, 120, 5, 5))
model:add(nn.Reshape(120))
model:add(nn.Linear(120, 100))
model:add(nn.Tanh())
model:add(nn.Linear(100, 4))