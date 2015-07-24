no_stacks = 3
no_disks = 3
picker = 1

Disk = {}
Stack = {}
function Disk.new(stack, dim)
	local self = {}
	self.stack = stack
	self.dim = dim
	return self;
end

hobbir = Disk.new(1, 2)
print(hobbir.stack)
print(hobbir.dim)

function love.load()
	local first_stack = 1
	love.graphics.setBackgroundColor(255, 255, 255)
	love.window.setMode(200, 200, {resizable=false})
	scrW = love.graphics.getWidth()
	scrH = love.graphics.getHeight()
	diskH = 10
	diskW = 2*scrW/(3*no_disks)
	free_space = scrW/(3*(no_stacks+1))
	Stack[first_stack] = {}
	for i = 1, no_disks do
		local disk = Disk.new(first_stack, diskW/(2^(i-1)))
		Stack[first_stack][i] = disk
	end
end

function love.draw()
	for stack = 1, no_stacks do
		love.graphics.setLineWidth(1)
		love.graphics.setColor(204, 102, 0)
		love.graphics.line(scrW*stack/(no_stacks+1), scrH/(no_stacks+1), scrW*stack/(no_stacks+1), scrH)
	end
	for disk = 1, no_disks do
		--love.graphics.rectangle( mode, x, y, width, height )
		love.graphics.setColor(255, 0, 0)
		--love.graphics.rectangle("fill", 10, 10, 10, 10)
	end
	for i = 1, no_stacks do
		if Stack[i] ~= nil and table.getn(Stack[i]) ~= 0 then
			for j = 1, table.getn(Stack[i]) do
				love.graphics.rectangle("fill", i*free_space, scrH-j*diskH, Stack[i][j].dim, diskH)
			end
		end
	end
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
