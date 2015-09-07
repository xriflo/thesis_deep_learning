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

model:add(nn.Sigmoid())