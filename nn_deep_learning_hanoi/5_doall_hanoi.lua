torch.setnumthreads(1)
dofile '1_data_hanoi.lua'
dofile '2_model_hanoi.lua'
dofile '3_loss_hanoi.lua'
dofile '4_train_hanoi.lua'

for i = 1, 1000 do
	print("(-----------------------------------------)")
	output = model:forward(trainData.data[i]:double())
	target = trainData.labels[i]
	print(output)
	print(target)
end