no_stacks = 3
no_disks = 3
first_stack = 1
picker = 1


Disk = {}
Stack = {}
function Disk.new(stack, dim)
	local self = {}
	self.stack = stack
	self.dim = dim
	return self;
end

function Stack.new(stack)
	local self = {}
	self.no_disks = 0
	self.stack = stack
	self.disks = {}
	return self
end

--[[
disk = Disk.new(1, 2)
stack = Stack.new(1)
stack.disks = {disk}
print(stack.disks[1].dim)
]]--
Stacks = {}

function love.load()
	-- program variables
	love.graphics.setBackgroundColor(255, 255, 255)
	love.window.setMode(200, 200, {resizable=false})
	scrW = love.graphics.getWidth()
	scrH = love.graphics.getHeight()
	diskH = 10
	diskW = 2*scrW/(3*no_disks)
	free_space = scrW/(3*(no_stacks+1))
	
	-- creating a list of stacks
	for i = 1, no_stacks do
		Stacks[i] = {}
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
	for stack = 1, no_stacks do
		love.graphics.setLineWidth(1)
		love.graphics.setColor(204, 102, 0)
		love.graphics.line(scrW*stack/(no_stacks+1), scrH/(no_stacks+1), scrW*stack/(no_stacks+1), scrH)
	end

	
	
	for disk = 1, no_disks do
		love.graphics.setColor(255, 0, 0)
	end
	
	for i = 1, no_stacks do
		if Stack[i] ~= nil and table.getn(Stack[i]) ~= 0 then
			for j = 1, table.getn(Stack[i]) do
				love.graphics.rectangle("fill", i*free_space, scrH-j*diskH, Stack[i][j].dim, diskH)
			end
		end
	end
	love.graphics.setColor(255, 0, 0)

	love.graphics.line(100, 0, 100, 200)
end

function love.update(dt)
   	if love.keyboard.isDown("up") then
   		print("up")
   		love.timer.sleep(0.2)
	end
	if love.keyboard.isDown("down") then
		print("down")
		love.timer.sleep(0.2)
	end
	if love.keyboard.isDown("left") then
		print("left")
		love.timer.sleep(0.2)
		if picker == 1 then
			picker = no_stacks
		else
			picker = picker - 1
		end
	end
	if love.keyboard.isDown("right") then
		print("right")
		love.timer.sleep(0.2)
		if picker == no_stacks then
			picker = 1
		else
			picker = picker + 1
		end
	end
end
