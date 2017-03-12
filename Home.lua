local selection = 1 
function menu_load()
	love.graphics.setBackgroundColor(75,0,130)

	menuButton={}
	menuButton[1]={text="Start Game",x=300,y=300,execute=startGame}
	menuButton[2]={text="Exit Game",x=300,y=400,execute=endGame}
end

function menu_draw()
	love.graphics.setFont(titlefont)

	love.graphics.setColor(255, 255, 255)

	love.graphics.printf("DEEP SPACE",200,100,400,"center")

	love.graphics.setFont(buttonfont)

	for i,v in ipairs(menuButton) do
		if i == selection then 
			love.graphics.setColor(255, 255, 255)
			love.graphics.printf(v.text,v.x,v.y,200,"center")
		else
			love.graphics.setColor(64, 64, 180)
			love.graphics.printf(v.text,v.x,v.y,200,"center")
		end

	end
end

function menu_update(dt)
	-- body
end

function menu_keyboard(key)
	if key == "up" then

		selection = selection - 1
		if selection == 0 then 
			selection =#menuButton
		end

	end

	if key == "down" then
		selection = (selection + 1) 
		if selection > #menuButton then
			selection = 1
		end
	end
	if key == "return" then
		menuButton[selection].execute()
	end
end

function startGame()
    game_load()
    gamestate="Game"
	print("Starting game")
end

function endGame()
	print("Quitting")
	love.event.push("quit")
end