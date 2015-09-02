require 'torch'

loaded = torch.load("dataset32x32_1.t7")
loaded.X = loaded.X:transpose(3,4)
Xsz = loaded.X:size()
ysz = loaded.y:size()
no_datasets = 64
dim = 32
no_states = Xsz[1]
green_pixel = torch.ByteTensor({0, 255, 0})
black_pixel = torch.ByteTensor({0, 0, 0})
dataset = {}
dataset.X = torch.ByteTensor(no_datasets*Xsz[1], Xsz[2], Xsz[3], Xsz[4])
dataset.y = torch.DoubleTensor(ysz[1], no_datasets*ysz[2], ysz[3])

function printDataset(loaded)
	for i = 1, loaded.y:size()[2] do
		itorch.image(loaded.X[{{i}}])
		print(loaded.y[1][i])
	end
end

green_values = torch.randperm(255)
for d = 0, no_datasets/2-1 do
	green_value = green_values[d+1]
	dataset.X[{{d*no_states+1, d*no_states+no_states}}]:copy(loaded.X)
	dataset.X[{{d*no_states+1, d*no_states+no_states}, {2}}] = green_value
	dataset.y[1][{{d*no_states+1, d*no_states+no_states}}]:copy(loaded.y[1])
end
t = 0
for d = no_datasets/2, no_datasets-1 do
	wpx = torch.randperm(dim)
	hpx = torch.randperm(dim)
	how_many = math.ceil(dim-t)
	t = t + 1
	dataset.X[{{d*no_states+1, d*no_states+no_states}}]:copy(loaded.X)
	dataset.y[1][{{d*no_states+1, d*no_states+no_states}}]:copy(loaded.y[1])
	what_noise = torch.rand(how_many)
	for m = 1, how_many do
		if what_noise[m] < 0.5 then noise = green_pixel else noise = black_pixel end
		for s = 1, no_states do
			dataset.X[{{d*no_states+s},{1,3},{hpx[m]},{wpx[m]}}][1] = noise
		end
		
	end
end


torch.save("dataset32x32_alterated.t7", dataset)
