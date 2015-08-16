require "hanoi"
require "qlearning"
require "socket"


--[[
function love.load()
	load_game()

	-- program variables
	love.window.setTitle("Bathory Game")
	love.graphics.setBackgroundColor(255, 255, 255)
	love.window.setMode(scrW, scrH, {resizable=false})
	love.graphics.setColor(0, 0, 255)
	love.graphics.rectangle("fill", picker.pointing_stack*free_space-pickerW/2, 0, pickerW, pickerH)
end

function love.draw()
	-- draw the stacks
	love.graphics.setColor(204, 102, 0)
	for stack = 1, no_stacks do
		love.graphics.setLineWidth(1)
		love.graphics.line(scrW*stack/(no_stacks+1), scrH/(no_stacks+1), scrW*stack/(no_stacks+1), scrH)
	end
	
	-- draw the disks
	love.graphics.setColor(255, 0, 0)
	for i = 1, no_stacks do
		for j = 1, Stacks[i].no_disks do			
			love.graphics.rectangle("fill", i*free_space-Stacks[i].disks[j].dim/2, scrH-j*diskH, Stacks[i].disks[j].dim, diskH)
		end
	end

	if picker.having_disk then
		love.graphics.rectangle("fill", picker.pointing_stack*free_space-picker.disk.dim/2, pickerH, picker.disk.dim, diskH)
	end
	love.graphics.setColor(0, 0, 255)
	love.graphics.rectangle("fill", picker.pointing_stack*free_space-pickerW/2, 0, pickerW, pickerH)
end
]]--

ep = 0
it = 0
load_game()
start_time = socket.gettime()*1000

while(1) do
	--[[
	if ep == 0 then
		episodes = 5
	elseif ep == 1
		episodes = 6
	elseif ep == 2
		episodes =  
	]]--
	if it == iterations then
		print("finished all")
		torch.save("dumped_data.out", torch.serialize(Q))
		for state, qvalues in pairs(Q) do
				print(tostring(Q[state]['UP']).." "..tostring(Q[state]['DOWN']).." "..tostring(Q[state]['LEFT']).." "..tostring(Q[state]['RIGHT']))
		end
		break
	else
		if ep==episodes then
			ep = 0
			print("iteration "..tostring(it).." finished")
			it = it + 1
			eps = eps - delta_eps
			if(eps<0) then
				eps = 0
			end
		else
			if isGameOver() then
				end_time =  socket.gettime()*1000
				delta_time = end_time - start_time
				print("[eps="..eps.."] it_"..tostring(it)..": episode "..tostring(ep).." finished in "..tostring(delta_time).."ms with #Q="..tlen(Q))
				ep = ep + 1
				start_time = socket.gettime()*1000
				load_game()
			else
				old_state = torch.serialize(State.getState())
				action, _ = choose_action(old_state)
				call_move(action)
				reward = getReward()
				new_state = torch.serialize(State.getState())
				_, newq = choose_action(new_state)

				Q[old_state][action] = Q[old_state][action] + alpha *
					(reward + gamma*newq - Q[old_state][action])
			end
		end
	end
end