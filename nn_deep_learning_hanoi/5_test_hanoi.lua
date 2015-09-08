----------------------------------------------------------------------
-- This script implements a test procedure, to report accuracy
-- on the test data. Nothing fancy here...
--
-- Clement Farabet
----------------------------------------------------------------------

require 'torch'   -- torch
require 'xlua'    -- xlua provides useful tools, like progress bars
require 'optim'   -- an optimization package, for online and batch methods

----------------------------------------------------------------------
print '==> defining test procedure'

-- test function

ttest = 1


function test()
   local current_loss = 0
   for i = 1,testData:size() do
      local target = testData.labels[i]:double()
      local inputs = testData.data[i]:double()
      current_loss = current_loss + criterion:forward(model:forward(inputs), target)
   end

   current_loss = current_loss / testData:size()
   io.write('current loss ts = ' .. current_loss)
   ttest = ttest + 1
end