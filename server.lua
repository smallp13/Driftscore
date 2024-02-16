LEADERBOARD_CLEAR_TIME = 60 -- THIS IS IN MINUTES
MAX_LEADERBOARD_ENTRIES = 10

local Players = {}
local Leaderboards = {}

RegisterCommand('clearleaderboard', function(source)
	-- REPLACE COMMAND WITH YOUR ACE GROUP
	if IsPlayerAceAllowed(source, 'drift') then
		clearLeaderboard()
	end
end)

RegisterNetEvent("SaveScore")
AddEventHandler("SaveScore", function(client, data)
	local identifier = (GetPlayerIdentifier(source, 0))
	local playerName = GetPlayerName(source)
	if Players[identifier] ~= nil then
		if Players[identifier].pb < data.curScore then
			-- Personal Best Beat
			local oldScore = Players[identifier].pb
			Players[identifier] = { pb = data.curScore }
			chatMessage(source, string.format("You have just beaten your own score of ^2%s^0 with ^2%s^0!", GroupDigits(oldScore),  GroupDigits(data.curScore)))
		end
	else
		Players[identifier] = { pb = data.curScore }
	end
	
	if #Leaderboards == 0 then --If no scores are existent
		table.insert(Leaderboards, {score = data.curScore, name = playerName, id = identifier})
		chatMessage(-1, string.format("^2%s^0 has just joined the leaderboard with a score of ^2%s^0pts!", playerName, GroupDigits(data.curScore)))
	else
		local existingIndex = false
		for k, v in ipairs(Leaderboards) do
		    if v.name == GetPlayerName(source) then
		      existingIndex = k
		      break
		    end
		end

		if existingIndex then --Check if player exists
			if Leaderboards[existingIndex].score < data.curScore then -- check if saved score is lower than current score
				Leaderboards[existingIndex].score = data.curScore --update existing players score
				table.sort(Leaderboards, compare) --sort

				local currentPosition
				for k, v in ipairs(Leaderboards) do
				    if v.name == GetPlayerName(source) then
				        currentPosition = k
						chatMessage(-1, string.format("^2%s^0 current score is ^2%s^0pts! Leaderboard #^2%s^0! ", playerName, GroupDigits(data.curScore), k))
				        break
				    end
				end

			end
		else --if player doesnt exist, create their data
			table.insert(Leaderboards, {score = data.curScore, name = playerName, id = identifier})
			chatMessage(-1, string.format("^2%s^0 has just joined with ^2%s^0pts!", playerName, GroupDigits(data.curScore)))
		end

		for k,v in pairs(Leaderboards) do --Max entries 
			if k > MAX_LEADERBOARD_ENTRIES then
				table.remove(Leaderboards, k)
			end
		end
		
	end
	table.sort(Leaderboards, compare) --sort again
end)

function chatMessage(target, msg) --edit the chat message prefix here
	TriggerClientEvent('chat:addMessage', target or -1, {
		color = { 255, 0, 0},
		multiline = true,
		args = {"[Drift] ", msg}
	})
end

function checkLeaderboard(identifier)
	for k, v in ipairs(Leaderboards) do
		if v.id == identifier then
			Leaderboards[k] = nil
		end
	end
	return true
end

function compare(a, b)
	if a ~= nil and b ~= nil then
		return a.score > b.score 
	end
end

function GroupDigits(value)
	local left,num,right = string.match(value,'^([^%d]*%d)(%d*)(.-)$')

	return left..(num:reverse():gsub('(%d%d%d)','%1' .. (' ')):reverse())..right
end


function clearLeaderboard()
	Leaderboards = {}
	chatMessage(-1, "The leaderboard has been cleared!")
end

Citizen.CreateThread(function() --dont touch this
	while true do
		while #Leaderboards == 0 do
			Citizen.Wait(0)
		end
		Citizen.Wait((LEADERBOARD_CLEAR_TIME * 1000 * 60) - (60 * 1000 * 5))
		chatMessage(-1, "The Leaderboard is clearing in 5 minutes!")
		Citizen.Wait(1000 * 60 * 3)
		chatMessage(-1, "The Leaderboard is clearing in 2 minutes!")
		Citizen.Wait(1000 * 60 * 1)
		chatMessage(-1, "The Leaderboard is clearing in 1 minute!")
		Citizen.Wait(1000 * 60 * 1)
		clearLeaderboard()
	end
end)
