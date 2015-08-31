require 'torch'
require 'image'
require 'nn'

noutputs = 4

nfeats = 3
width = 32
height = 32
ninputs = nfeats * width * height
nhiddens = ninputs / 2

nstates = {64,64,128}
filtsize = 5
poolsize = 2
normkernel = image.gaussian1D(7)

model = nn.Sequential()

   model = nn.Sequential()
   model:add(nn.Reshape(ninputs))
   model:add(nn.Linear(ninputs,ninputs/2))
   model:add(nn.Tanh())
   model:add(nn.Linear(ninputs/2,4))