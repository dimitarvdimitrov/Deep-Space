local selection =1
function gameover_load()
    love.graphics.setBackgroundColor(75,0,130)
    menuButton = {}
    menuButton[1] = {text='Play Again', x=300, y=300, execute=startGame}
    menuButton[2] = {text='Exit Game', x=300, y=400, execute=endGame}

    titlefont=love.graphics.newFont("Xcelsion.ttf",40)
    buttonfont=love.graphics.newFont("Xcelsion.ttf",30)
    love.graphics.setFont(titlefont)
end

function gameover_draw()
    love.graphics.setFont(titlefont)

    love.graphics.setColor(255, 255, 255)

    love.graphics.printf("GAME OVER",200,100,400,"center")

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

function gameover_update(dt)

end

function gameover_keyboard(key)
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