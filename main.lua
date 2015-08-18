require "torch"
require "qlearning"
require "hanoi"


function load_global_env()
	Q = getQ()
	states = retrieve_keys(Q)
	no_states = #states
	no_disks = states[1]["no_disks"]
	no_stacks = states[1]["no_stacks"]
	state_index = 1
end

function transfor_dim(dim)
	dim = no_disks - dim + 1
	dim = no_disks - dim
	print(diskW/(2^(dim-1)))
	return diskW/(2^(dim-1))
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
		for j = 1, #state[i] do			
			love.graphics.rectangle("fill", i*free_space-transfor_dim(state[i][j])/2, scrH-j*diskH, transfor_dim(state[i][j]), diskH)
		end
	end

	-- draw the picker
	if not (state.picker_size_disk == nil) then
		love.graphics.rectangle("fill", state.picker_position*free_space-transfor_dim(state.picker_size_disk)/2, pickerH, transfor_dim(state.picker_size_disk), diskH)
	end
	love.graphics.setColor(0, 0, 255)
	love.graphics.rectangle("fill", state.picker_position*free_space-pickerW/2, 0, pickerW, pickerH)
end

function love.load()
	load_global_env()

	-- program variables
	scrW = 400
	scrH = 400
	diskH = scrH/20
	diskW = 2*scrW/(3*no_disks)
	pickerW = scrW/40
	pickerH = scrH/40
	free_space = scrW/(1*(no_stacks+1))

	love.window.setTitle("Bathory Game")
	love.graphics.setBackgroundColor(255, 255, 255)
	love.window.setMode(scrW, scrH, {resizable=false})
end

function love.draw()
	if state_index > no_states then
		love.event.quit()
	end
	draw_state(states[state_index])
	state_index = state_index + 1
	love.timer.sleep(2)
end


function  love.update(dt)
end




