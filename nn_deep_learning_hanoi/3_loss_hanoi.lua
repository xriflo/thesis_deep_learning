
noutputs = 4
model:add(nn.Tanh())

   -- The mean-square error is not recommended for classification
   -- tasks, as it typically tries to do too much, by exactly modeling
   -- the 1-of-N distribution. For the sake of showing more examples,
   -- we still provide it here:

criterion = nn.MSECriterion()


