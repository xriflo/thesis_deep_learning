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
--[[
   -- stage 1 : filter bank -> squashing -> L2 pooling -> normalization
      model:add(nn.SpatialConvolutionMM(nfeats, nstates[1], filtsize, filtsize))
      model:add(nn.Tanh())
      model:add(nn.SpatialLPPooling(nstates[1],2,poolsize,poolsize,poolsize,poolsize))
      model:add(nn.SpatialSubtractiveNormalization(nstates[1], normkernel))

      -- stage 2 : filter bank -> squashing -> L2 pooling -> normalization
      model:add(nn.SpatialConvolutionMM(nstates[1], nstates[2], filtsize, filtsize))
      model:add(nn.Tanh())
      model:add(nn.SpatialLPPooling(nstates[2],2,poolsize,poolsize,poolsize,poolsize))
      model:add(nn.SpatialSubtractiveNormalization(nstates[2], normkernel))

      -- stage 3 : standard 2-layer neural network
      model:add(nn.Reshape(nstates[2]*filtsize*filtsize))
      model:add(nn.Linear(nstates[2]*filtsize*filtsize, nstates[3]))
      model:add(nn.Tanh())
      model:add(nn.Linear(nstates[3], noutputs))
   ]]--
      --[[
         -- stage 1 : mean suppresion -> filter bank -> squashing -> max pooling
      model:add(nn.SpatialConvolutionMM(3, 32, 5, 5))
      model:add(nn.Tanh())
      model:add(nn.SpatialMaxPooling(3, 3, 3, 3))

      -- stage 2 : mean suppresion -> filter bank -> squashing -> max pooling
      model:add(nn.SpatialConvolutionMM(32, 64, 5, 5))
      model:add(nn.Tanh())
      model:add(nn.SpatialMaxPooling(2, 2, 2, 2))
      -- stage 3 : standard 2-layer MLP:
      model:add(nn.Reshape(64*2*2))
      model:add(nn.Linear(64*2*2, 200))
      model:add(nn.Tanh())
      model:add(nn.Linear(200, 4))
      ]]--
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