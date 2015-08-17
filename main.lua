require "torch"
require "qlearning"
require "hanoi"





for k, v in pairs(Q) do
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

--[[
dmp = torch.deserialize(torch.load("dumped_data.out"))
Q = {}
for k, v in pairs(dmp) do
	Q[torch.deserialize(k)] = v
end
states = retrieve_keys(Q)
print(states)
torch.save("qq.out", torch.serialize(Q))
]]--

function load_global_env()
	Q = getQ()
	printQ(Q)
end



function love.load()
	load_global_env()
	-- program variables
	scrW = 400
	scrH = 400
	love.window.setTitle("Bathory Game")
	love.graphics.setBackgroundColor(255, 0, 0)
	love.window.setMode(scrW, scrH, {resizable=false})
	
end

function love.draw()
	love.graphics.setBackgroundColor(255, 0, 0)
	love.graphics.rectangle("fill", 20, 50, 60, 120 )
	love.timer.sleep(2)
	love.event.quit()
end


function  love.update(dt)
end




