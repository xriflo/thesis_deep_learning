math.randomseed(os.time())

actions = {'UP', 'DOWN', 'LEFT', 'RIGHT'}
iterations = 11
episodes = 100
Q = {}
eps = 1
delta_eps = 0.10
gamma = 0.95
alpha = 0.1
inf = 1e309


function tlen(t)
	count = 0
	for _,_ in pairs(t) do
		count = count + 1
	end
	return count
end

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
	if Q[state] == nil then
		Q[state] = {}
		for _, action in pairs(actions) do
			if Q[state][action] == nil then
				Q[state][action] = 0.0
			end
		end
	end
end

function choose_action(state)
	check_Q(state)
	if math.random() < eps then
		action = actions[math.random(#actions)]
		return action, Q[state][action]
	else
		ret_action = nil
		maxq = -inf
		for _, action in pairs(actions) do
			if Q[state][action] > maxq then
				maxq = Q[state][action]
				ret_action = action
			end
		end
		return ret_action, Q[state][ret_action]
	end
end
