require "torch"
require "qlearning"
ld = torch.deserialize(torch.load("dumped_data.out"))


function tlen(t)
	count = 0
	for _,_ in pairs(t) do
		count = count + 1
	end
	return count
end

Q = {}
for k, v in pairs(ld) do
	Q[torch.deserialize(k)] = v
end


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

