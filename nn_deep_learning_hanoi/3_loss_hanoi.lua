
noutputs = 4
model:add(nn.Tanh())

   -- The mean-square error is not recommended for classification
   -- tasks, as it typically tries to do too much, by exactly modeling
   -- the 1-of-N distribution. For the sake of showing more examples,
   -- we still provide it here:

criterion = nn.MSECriterion()

current loss = 822.94552387021   
current loss = 822.94551205865   
current loss = 822.94550141357   
current loss = 822.94549177234   
