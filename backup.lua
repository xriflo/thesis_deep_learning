--for checking equality by value ?!
same_order_disks = true
for i = 1, no_stacks do
	for j= 1, #state[i] do
		same_order_disks = same_order_disks and (state[i][j]==other[i][j])
	end
end

same_order_disks and
state.picker_position==other.picker_position and
state.no_disks == other.no_disks and
state.no_stacks == other.no_stacks and
state.picker_size_disk == other.picker_size_disk