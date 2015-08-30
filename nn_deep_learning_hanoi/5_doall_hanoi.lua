dofile '1_data_hanoi.lua'
dofile '2_model_hanoi.lua'
dofile '3_loss_hanoi.lua'
dofile '4_train_hanoi.lua'

for i = 1, trainData:size() do
	print("(-----------------------------------------)")
	output = model:forward(trainData.data[i]:double())
	target = trainData.labels[i]
	print(output)
	print(target)
end