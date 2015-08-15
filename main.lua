no_stacks = 3
no_disks = 3
first_stack = 1
picker = 1


Disk = {}
Disk.__index = Disk
Stack = {}
Stack.__index = Stack
Picker = {}
Picker.__index = Picker

function Disk.new(stack, dim, no)
	local disk = {}
	setmetatable(disk,Disk)
	disk.stack = stack
	disk.dim = dim
	disk.no = no
	return disk;
end

function Stack.new(stack)
	local self = {}
	setmetatable(self,Stack)
	self.no_disks = 0
	self.stack = stack
	self.disks = {}
	return self
end

function Stack:remove()
	if self.no_disks>=1 and not(picker.having_disk) then
		picker.disk = Disk.new(nil, self.disks[self.no_disks].dim, self.disks[self.no_disks].no)
		picker.having_disk = true
		self.disks[self.no_disks] = nil
		self.no_disks = self.no_disks - 1
		print(picker.disk.no)
	end
end

function Stack:add()
	if picker.having_disk and (self.no_disks==0 or (picker.disk.dim < self.disks[self.no_disks].dim)) then
		print(picker.disk.no)
		self.no_disks = self.no_disks + 1
		self.disks[self.no_disks] = Disk.new(self.stack, picker.disk.dim, picker.disk.no)
		picker.having_disk = false
		picker.disk = nil
	end
end



function Picker.new()
	local self = {}
	setmetatable(self, Picker)
	self.pointing_stack = first_stack
	self.having_disk = false
	self.disk = nil
	return self
end


function love.load()
	Stacks = {}
	picker = Picker.new()
	-- program variables
	love.window.setTitle("Bathory Game")
	love.graphics.setBackgroundColor(255, 255, 255)
	love.window.setMode(400, 400, {resizable=false})
	

	scrW = love.graphics.getWidth()
	scrH = love.graphics.getHeight()
	diskH = scrH/20
	diskW = 2*scrW/(3*no_disks)
	pickerW = 10
	pickerH = 10
	free_space = scrW/(1*(no_stacks+1))

	love.graphics.setColor(0, 0, 255)
	love.graphics.rectangle("fill", picker.pointing_stack*free_space-pickerW/2, 0, pickerW, pickerH)
	
	-- creating a list of stacks
	for i = 1, no_stacks do
		Stacks[i] = Stack.new(i)
		Stacks[i].no_disks = 0
		for j = 1, no_disks do
			Stacks[i].disks = {}
		end
	end

	-- put the disks on the first stack
	for i = 1, no_disks do
		local disk = Disk.new(first_stack, diskW/(2^(i-1)), no_disks-i+1)
		Stacks[first_stack].disks[i] = disk
	end
	Stacks[first_stack].no_disks = 3
end
t = 0
function love.draw()
	t = t + 1
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

	if isGameOver() then
		love.load()
	end
end

function love.update(dt)
	-- pick-up disk if possible
   	if love.keyboard.isDown("up") then
   		moveUp()
   		love.timer.sleep(0.15)
	end
	-- put down disk if possible
	if love.keyboard.isDown("down") then
		moveDown()
		love.timer.sleep(0.15)
	end

	-- move the picker to left or right
	if love.keyboard.isDown("left") then
		moveLeft()
		love.timer.sleep(0.15)
	end
	if love.keyboard.isDown("right") then
		moveRight()
		love.timer.sleep(0.15)
	end

	if love.keyboard.isDown('up', 'down', 'left', 'right') then
		stateToString()
	end
end

function moveUp()
	Stacks[picker.pointing_stack]:remove()
end
function moveDown()
	Stacks[picker.pointing_stack]:add()
	
end

function moveLeft()
	if picker.pointing_stack == 1 then
		picker.pointing_stack = no_stacks
	else
		picker.pointing_stack = picker.pointing_stack - 1
	end
end

function moveRight()
	if picker.pointing_stack == no_stacks then
		picker.pointing_stack = 1
	else
		picker.pointing_stack = picker.pointing_stack + 1
	end
end

function isGameOver()
	if Stacks[#Stacks].no_disks == no_disks then
		return true
	else
		return false
	end
end

State = {}
State.__index = State


function State.new()
	local state = {}
	setmetatable(state,State)
	state["picker_position"] = picker.pointing_stack
	state["size_disk"] = nil if picker.disk == nil then state["size_disk"] = picker.disk.no end
	state["no_disks"] = no_disks
	state["no_stacks"] = no_stacks
	for i = 1, no_stacks do
		state[i] = {}
		for j = 1, Stacks[i].no_disks do
			state[i][j] = Stacks[i].disks[j].no
		end
	end
	return state;
end


function stateToString()
	if(picker==nil) then return nil end
	state = {}
	state["picker_position"] = picker.pointing_stack
	print("picker",picker)
	print("picker.disk",picker.disk)
	--state["size_disk"] = nil if picker.disk == nil then state["size_disk"] = picker.disk.no end
	if picker.disk == nil then
		state["size_disk"] = nil
	else
		state["size_disk"] = picker.disk.no
	end

	state["no_disks"] = no_disks
	state["no_stacks"] = no_stacks
	for i = 1, no_stacks do
		state[i] = {}
		for j = 1, Stacks[i].no_disks do
			state[i][j] = Stacks[i].disks[j].no
		end
	end
	return state
end
