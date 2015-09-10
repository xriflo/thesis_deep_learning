function love.draw()

   drawGame()
   screenshot = love.graphics.newScreenshot(false)
   screenshot:encode("sample", "png")

   sample = imageDataToTensor(screenshot):double()
   sample = preprocess(sample)
   output_q = q:forward(sample)
   r = math.random()
   if r < eps then
      action = actions[math.random(no_actions)]
   else
      action, _ = maxQ(output_q)
   end
   applyAction(action)
   reward = getReward()

   if isGameOver() then
      print("Episode "..episode.." finished with "..no_moves.." moves and eps="..eps)
      target = reward
      love.load()
      episode = episode + 1
      no_moves = 0
      if episode%10 == 0 then
         eps = eps - 0.1
         if eps < 0 then
            eps = 0
         end
      end
   else
      sample = imageDataToTensor(screenshot):double()
      sample = preprocess(sample)
      output_q_target = q_target:forward(sample)
      a , max_val = maxQ(output_q_target)
      target = reward + gamma * max_val
      output_q_target[actions_ind[a]] = target
      criterion:forward(output_q, output_q_target)
      q:backward(sample, criterion:backward(q.output, output_q_target))
      x = x + 1
      if x%100 == 0 then
         q_target = q:clone()
      end
   end
end