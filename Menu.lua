require "Home"

function love.load()
    gamestate = "Home"
    if (gamestate == 'Home') then
        home_load()
    else if (gamestate == 'Game') then
        game_load()
    else if (gamestate == 'Game Over') then
        gameover_load()
    end
    end
    end
end

function love.draw()
    if (gamestate == 'Home') then
        menu_draw()
    else if (gamestate == 'Game') then
        game_draw()
    else if (gamestate == 'Game Over') then
        gameover_draw()
    end 
    end
    end
end

function love.update(dt)
    if (gamestate == 'Home') then
        home_update(dt)
    else if (gamestate == 'Game') then
        game_update(dt)
    else if (gamestate == 'Game Over') then
        gameover_update(dt)
    end
    end
    end
end

function home_load()
    menu_load()
    titlefont=love.graphics.newFont("Xcelsion.ttf",40)
    love.graphics.setFont(titlefont)

    buttonfont=love.graphics.newFont("Xcelsion.ttf",30)
end

function home_draw()
    if gamestate=="Home" then
        menu_draw()
    end
end

function home_update(dt)
    if gamestate=="Home" then
        menu_update(dt)
    end
end

function love.keypressed( key, scancode, isrepeat )
    if gamestate =="Home" then
        menu_keyboard(key)
    else if gamestate == "Game Over" then
        gameover_keyboard(key)
    end
    end
end
