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

function Disk.new(stack, dim)
	local disk = {}
	setmetatable(disk,Disk)
	disk.stack = stack
	disk.dim = dim
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
		picker.disk = Disk.new(nil, self.disks[self.no_disks].dim)
		picker.having_disk = true
		self.disks[self.no_disks] = nil
		self.no_disks = self.no_disks - 1
	end
end

function Stack:add()
	if having_disk then
		self.no_disks = self.no_disks + 1
		self.disks[self.no_disks] = Disk.new(self.stack, picker.disk.dim)
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
	love.graphics.setBackgroundColor(255, 255, 255)
	love.window.setMode(200, 200, {resizable=false})
	scrW = love.graphics.getWidth()
	scrH = love.graphics.getHeight()
	diskH = 10
	diskW = 2*scrW/(3*no_disks)
	free_space = scrW/(1*(no_stacks+1))
	
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
		local disk = Disk.new(first_stack, diskW/(2^(i-1)))
		Stacks[first_stack].disks[i] = disk
	end
	Stacks[first_stack].no_disks = 3
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
			love.graphics.rectangle("fill", i*free_space-Stacks[i].disks[j].dim/2, scrH-j*diskH, Stacks[i].disks[j].dim, 10)
		end
	end

	if picker.having_disk then
		love.graphics.rectangle("fill", picker.pointing_stack*free_space-picker.disk.dim/2, 0, picker.disk.dim, 10)
	end
	--print(Stacks[picker.pointing_stack].no_disks..picker.having_disk)
end

function love.update(dt)
	-- pick-up disk
   	if love.keyboard.isDown("up") then
   		Stacks[picker.pointing_stack]:remove()
   		--print("up")
   		love.timer.sleep(0.2)
	end
	if love.keyboard.isDown("down") then
		Stacks[picker.pointing_stack]:add()
		--print("down")
		love.timer.sleep(0.2)
	end

	-- move the picker to left or right
	if love.keyboard.isDown("left") then
		moveLeft()
		love.timer.sleep(0.2)
		
	end
	if love.keyboard.isDown("right") then
		moveRight()
		love.timer.sleep(0.2)
		
	end
	--print(picker.pointing_stack)
end

function moveUp()

end
function moveDown()
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
