require "hanoi"
require "qlearning"



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
	love.timer.sleep(0.05)
end
--[[
function love.update(dt)
	for i = 1, epochs do
		ep = 1
		while (ep <= episodes) do
			load_game()
			ep = ep + 1
			while(not isGameOver()) do
				dr()
				old_state = State.getState()
				action, _ = choose_action(old_state)
				call_move(action)
				reward = getReward()
				new_state = State.getState()
				_, newq = choose_action(new_state)
				Q[old_state][action] = Q[old_state][action] + alpha *
					(reward + gamma*newq - Q[old_state][action])
			end
		end
		print("aici"..dt)
		eps = eps - 0.25
	end
end
]]--
ep = 0
it = 0
function love.update(dt)
	if it == iterations then
		print("finished all")
	else
		if ep==episodes then
			ep = 0
			print("iteration "..tostring(it).."f inished")
			it = it + 1
			eps = eps - 0.25
		else
			if isGameOver() then
				print("episode "..tostring(ep).."f inished")
				ep = ep + 1
				load_game()
			else
				old_state = State.getState()
				action, _ = choose_action(old_state)
				call_move(action)
				reward = getReward()
				new_state = State.getState()
				_, newq = choose_action(new_state)
				Q[old_state][action] = Q[old_state][action] + alpha *
					(reward + gamma*newq - Q[old_state][action])
			end
		end
	end
		
end