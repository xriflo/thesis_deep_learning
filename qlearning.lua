
actions = {'UP', 'DOWN', 'LEFT', 'RIGHT'}
epochs = 3
episodes = 100
Q = {}
eps = 0.75
gamma = 0.95
alpha = 0.1

function call_move(action)
	if(action=='UP') then
		return moveUp()
	elseif(action=='DOWN') then
		return moveDown()
	elseif(action=='LEFT') then
		return moveLeft()
	elseif(action=='RIGHT') then
		return moveRight()
	else
		return nil
	end
end

function check_Q(state)
	if not Q[state] then
		for action, _ in pairs(actions) do
			if Q[state][action] then
				Q[state][action] = 0.0
			end
		end
	end
end

function choose_action(state)
	if math.random() < eps then
		action = actions[math.random(#actions)]
		return action, Q[state][action]
	else
		ret_action = nil
		maxq = 0.0
		for action, _ in pairs(actions) do
			if Q[state][action] > maxq then
				maxq = Q[state][action]
				ret_action = action
			end
		end
		return ret_action, Q[state][ret_action]
	end
end

--[[
function main()
	load_game()
	print (scrW)
end

main()
]]--


