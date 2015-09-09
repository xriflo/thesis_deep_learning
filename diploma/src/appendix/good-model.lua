model = nn.Sequential()

model:add(nn.SpatialConvolutionMM(3, 4, 5, 5))
model:add(nn.Tanh())
model:add(nn.SpatialSubSampling(4, 2, 2, 2, 2))

model:add(nn.SpatialConvolutionMM(4, 6, 5, 5))
model:add(nn.Tanh())
model:add(nn.SpatialSubSampling(6, 2, 2, 2, 2))

model:add(nn.Reshape(150))
model:add(nn.Linear(150, 4))