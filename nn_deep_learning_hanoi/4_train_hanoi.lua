require 'torch'   -- torch
require 'xlua' 
require 'optim'   --

x, dl_dx = model:getParameters()

feval = function(x_new)
   -- set x to x_new, if differnt
   -- (in this simple example, x_new will typically always point to x,
   -- so the copy is really useless)
   if x ~= x_new then
      x:copy(x_new)
   end

   -- select a new training sample
   _nidx_ = (_nidx_ or 0) + 1
   if _nidx_ > trainData:size() then _nidx_ = 1 end

   local sample = data[_nidx_]
   local target = trainData.labels[_nidx_]:double()
   local inputs = trainData.data[_nidx_]:double()
    --print(c)
   -- reset gradients (gradients are always accumulated, to accomodate 
   -- batch methods)
   dl_dx:zero()
   -- evaluate the loss function and its derivative wrt x, for that sample
   --print(model:forward(inputs))
   local loss_x = criterion:forward(model:forward(inputs), target)

   model:backward(inputs, criterion:backward(model.output, target))


   -- return loss(x) and dloss/dx
   return loss_x, dl_dx
end

sgd_params = {
   learningRate = 1e-1,
   learningRateDecay = 1e-4,
   weightDecay = 0,
   momentum = 0
}

for i = 1,5000 do

   -- this variable is used to estimate the average loss
   current_loss = 0

   -- an epoch is a full loop over our training data
   for i = 1,trainData:size() do

      -- optim contains several optimization algorithms. 
      -- All of these algorithms assume the same parameters:
      --   + a closure that computes the loss, and its gradient wrt to x, 
      --     given a point x
      --   + a point x
      --   + some parameters, which are algorithm-specific
      
      _,fs = optim.sgd(feval,x,sgd_params)

      -- Functions in optim all return two things:
      --   + the new x, found by the optimization method (here SGD)
      --   + the value of the loss functions at all points that were used by
      --     the algorithm. SGD only estimates the function once, so
      --     that list just contains one value.

      current_loss = current_loss + fs[1]
   end

   -- report average error on epoch
   current_loss = current_loss / trainData:size()
   print(i..' - current loss = ' .. current_loss)

end

