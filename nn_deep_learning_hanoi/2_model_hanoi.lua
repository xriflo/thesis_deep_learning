require 'torch'
require 'image'
require 'nn'
--[[
	from: https://github.com/torch/nn
	nn.SpatialConvolution(nInputPlane, nOutputPlane, kW, kH, [dW], [dH], [padW], [padH])
		--> output:
			owidth  = floor((width  + 2*padW - kW) / dW + 1)
			oheight = floor((height + 2*padH - kH) / dH + 1)
	nn.SpatialSubSampling(nInputPlane, kW, kH, [dW], [dH])
		--> output:
			owidth  = (width  - kW) / dW + 1
			oheight = (height - kH) / dH + 1 .

	nInputPlane: The number of expected input planes in the image given into forward().
	nOutputPlane: The number of output planes the convolution layer will produce.
	kW: The kernel width of the convolution
	kH: The kernel height of the convolution
	dW: The step of the convolution in the width dimension. Default is 1.
	dH: The step of the convolution in the height dimension. Default is 1.
	padW: The additional zeros added per width to the input planes. Default is 0, a good number is (kW-1)/2.
	padH: The additional zeros added per height to the input planes. Default is padW, a good number is (kH-1)/2.
]]--



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