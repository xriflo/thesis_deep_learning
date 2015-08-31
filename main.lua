require "torch"
require "qlearning"
require "hanoi"


function load_global_env()
	Q = getQ()
	torch.save("Q.t7", Q)
	states = retrieve_keys(Q)
	no_states = #states
	no_disks = states[1]["no_disks"]
	no_stacks = states[1]["no_stacks"]
	state_index = 1
	printQ(Q)
end

function dim(no)
	return diskW/(2^(no-1))
end

function draw_state(state)
	-- draw the stacks
	love.graphics.setColor(204, 102, 0)
	for stack = 1, state.no_stacks do
		love.graphics.setLineWidth(1)
		love.graphics.line(scrW*stack/(no_stacks+1), scrH/(no_stacks+1), scrW*stack/(no_stacks+1), scrH)
	end
	
	-- draw the disks
	love.graphics.setColor(255, 0, 0)
	for i = 1, no_stacks do
		for j = 1,#state[i] do		
			love.graphics.rectangle("fill", i*free_space-dim(state[i][j])/2, scrH-j*diskH, dim(state[i][j]), diskH)
		end
	end

	-- draw the picker
	if not (state.picker_size_disk == nil) then
		love.graphics.rectangle("fill", state.picker_position*free_space-dim(state.picker_size_disk)/2, pickerH, dim(state.picker_size_disk), diskH)
	end
	love.graphics.setColor(0, 0, 255)
	love.graphics.rectangle("fill", state.picker_position*free_space-pickerW/2, 0, pickerW, pickerH)
end

function love.load()
	load_global_env()
	-- program variables
	scrW = 32
	scrH = 32
	diskH = scrH/10
	diskW = 2*scrW/(3*no_disks)
	pickerW = scrW/10
	pickerH = scrH/10
	free_space = scrW/(1*(no_stacks+1))

	dataset = {}
	dataset.y = torch.DoubleTensor(1,no_states, 4)
	dataset.X = torch.ByteTensor(no_states, 3, scrW, scrH)

	love.window.setTitle("Bathory Game")
	love.graphics.setBackgroundColor(255, 255, 255)
	love.window.setMode(scrW, scrH, {resizable=false})
end

function getMaxValue(state)
	values = Q[state]
	ret_action = nil
	maxq = -inf
	for _, action in pairs(actions) do
		if Q[state][action] > maxq then
			maxq = Q[state][action]
			ret_action = action
		end
	end
	return ret_action, classes[ret_action]
end

function love.draw()
	if state_index > no_states then
		torch.save("dataset"..scrW.."x"..scrH..".t7", dataset)
		love.event.quit()
	else
		draw_state(states[state_index])
		local screenshot = love.graphics.newScreenshot()
    	screenshot:encode(tostring(state_index) .. '.png','png')
    	
    	for w = 1, scrW do
    		for h = 1, scrH do
    			-- tre sa schimb, wrong
    			r, g, b, _ = screenshot:getPixel(w-1, h-1)
    			dataset.X[state_index][1][w][h] = r
    			dataset.X[state_index][2][w][h] = g
    			dataset.X[state_index][3][w][h] = b
    		end
    	end
    	_, act_class = getMaxValue(states[state_index])
    	if not dataset.y[1][state_index][1] == 0.0 then
    		dataset.y[1][state_index][1] = Q[states[state_index]]["UP"]
    	else
    		dataset.y[1][state_index][1] = 1e-15
    	end
    	if not dataset.y[1][state_index][2] == 0.0 then
    		dataset.y[1][state_index][2] = Q[states[state_index]]["DOWN"]
    	else
    		dataset.y[1][state_index][2] = 1e-15
    	end
    	if not dataset.y[1][state_index][3] == 0.0 then
    		dataset.y[1][state_index][3] = Q[states[state_index]]["LEFT"]
    	else
    		dataset.y[1][state_index][3] = 1e-15
    	end
    	if not dataset.y[1][state_index][4] == 0.0 then
    		dataset.y[1][state_index][4] = Q[states[state_index]]["RIGHT"]
    	else
    		dataset.y[1][state_index][4] = 1e-15
    	end
		state_index = state_index + 1
	end
	

end


function  love.update(dt)
end






