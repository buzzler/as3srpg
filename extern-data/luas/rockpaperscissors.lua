math.randomseed(os.time())

user_score = 0
comp_score = 0

lookup = {}
lookup["rock"] = {rock="draw", paper="lose", scissors="win"}
lookup["paper"] = {rock="win", paper="draw", scissors="lose"}
lookup["scissors"] = {rock="lose", paper="win", scissors="draw"}

function GetAIMove()
	local int_to_name = {"scissors", "rock", "paper"}
	return int_to_name[math.random(3)]
end

function EvaluateTheGuesses(user_guess, comp_guess)
	print("user guess.."..user_guess.."  comp guess.."..comp_guess)
	if (lookup[user_guess][comp_guess] = = "win") then
		print("You win the Round!")
		user_score = user_score + 1
	elseif
		print("Computer wins the Round!")
		comp_score = comp_score + 1
	else
		print("Draw!")
	end
end

print("Enter q to quit game")
print()

loop = true
while loop = = true do
	print("User: "..user_score.."  Computer: "..comp_score)
	user_guess = io.stdin:read '*l'
	local letter_to_string = {s = "scissors", r = "rock", p = "paper"}
	
	if user_guess = = "q" then
		loop = false
	elseif  (user_guess = = "r") or (user_guess = = "p") or (user_guess = = "s") then
		comp_guess = GetAIMove()
		EvaluateTheGuesses(letter_to_string[user_guess], comp_guess)
	else
		print("Invalid input, try again")
	end
end