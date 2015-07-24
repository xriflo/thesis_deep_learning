no_stacks = 3
no_disks = 3
love.window.setMode(200, 200, {resizable=false})
scrW = love.graphics.getWidth()
scrH = love.graphics.getHeight()

function love.load()
	for stack = 1, no_stacks do

	end

end

function love.draw()
	--love.graphics.rectangle( "fill", 50, 50, 50, 50 )
	for stack = 1, no_stacks do
		love.graphics.setLineWidth(1 )
		love.graphics.setColor(255, 255, 255)
		love.graphics.line(10,10,50,50)
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
	end
	if love.keyboard.isDown("right") then
		print("right")
		love.timer.sleep(0.2)
	end
end