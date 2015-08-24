require "hanoi"
require "qlearning_functions"
require "socket"
require "torch"

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

function getQ()
	Qdeserialized = {}
	while(1) do
		if it == iterations then
			--print("finished all")
			
			for state, values in pairs(Q) do
				s = torch.deserialize(state)
				--deleteInvalidActions(s, values)
				Qdeserialized[s] = values
			end

			
			for state, qvalues in pairs(Q) do
					--print(tostring(Q[state]['UP']).." "..tostring(Q[state]['DOWN']).." "..tostring(Q[state]['LEFT']).." "..tostring(Q[state]['RIGHT']))
			end
			return Qdeserialized
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
end

function deleteInvalidActions(s, values)
	stack_corresponding_to_picker = s[tonumber(s["picker_position"])]

	if s["picker_size_disk"] then
		values["UP"] = 0.0
		if stack_corresponding_to_picker[#stack_corresponding_to_picker] then
			if s["picker_size_disk"] > stack_corresponding_to_picker[#stack_corresponding_to_picker] then
				values["DOWN"] = 0.0
			end
		end
	end
	if not s["picker_size_disk"] then
		values["DOWN"] = 0.0
	end
	if stack_corresponding_to_picker[#stack_corresponding_to_picker] == nil then
		values["UP"] = 0.0
	end
	if tonumber(s["picker_position"])==tonumber(s["no_stacks"]) then
		values["UP"] = 0.0
		values["DOWN"] = 0.0
		values["LEFT"] = 0.0
		values["RIGHT"] = 0.0
	end
end

function printQ(Qtable)
	for k, v in pairs(Qtable) do
		io.write("{")
		io.write("\n\tpicker_position = "..tostring(k.picker_position))
		io.write("\n\tno_disks = "..tostring(k.no_disks))
		io.write("\n\tno_stacks = "..tostring(k.no_stacks))
		io.write("\n\tpicker_size_disk = "..tostring(k.picker_size_disk))
		io.write("\n")
		for i = 1,3 do
			io.write("\t")
			io.write("{")
			for j = 1, #k[i] do
				io.write(tostring(k[i][j]).." ")
			end
			io.write("}")
			io.write("\n")
		end
		io.write("\t[\n")
		for _,a in pairs(actions) do
			io.write("\t\t"..a.."="..v[a].."\n")
		end
		io.write("\t]\n")
		io.write("}\n")
	end
end
