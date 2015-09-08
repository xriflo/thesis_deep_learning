dofile '1_data_hanoi.lua'
dofile '2_model_hanoi.lua'
dofile '3_loss_hanoi.lua'
dofile '4_train_hanoi.lua'
dofile '5_test_hanoi.lua'
torch.setnumthreads(4)


for i = 1, 1000 do
	io.write("------------epoch "..i.."------------\n")
	train()
	io.write("\n")
	test()
	io.write("\n")
end


for i = 1, trainData.data:size()[1]/10 do
	print("(-----------------------------------------)")
	output = model:forward(trainData.data[i]:double())
	target = trainData.labels[i]
	print(output)
	print(target)
end