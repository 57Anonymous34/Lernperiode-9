local love = require "love"
local enemy = require "Enemy"
local button = require "Button"
local json = require "dkjson"

math.randomseed(os.time())

local game = {
    difficulty = 0.8,
    state = {
        menu = true,
        paused = false,
        running = false,
        ended = false
    },
    points = 0,
    levels = {15, 30, 60, 120}
}

local fonts = {
    small = {
        font = love.graphics.newFont(14),
        size = 14
    },
    medium = {
        font = love.graphics.newFont(18),
        size = 18
    },
    large = {
        font = love.graphics.newFont(28),
        size = 28
    },
    score = {
        font = love.graphics.newFont(40),
        size = 40
    }
}

local player = {
    radius = 20,
    x = 30,
    y = 30
}

local buttons = {
    menu_state = {},
    ended_state = {}
}

local enemies = {}
local logo
local playerName = ""
local enteringName = true
local scoreSaved = false
local highscores = {}

local function changeGameState(state)
    game.state.menu = state == "menu"
    game.state.paused = state == "paused"
    game.state.running = state == "running"
    game.state.ended = state == "ended"
end

local function saveScore()
    if playerName ~= "" then
        local score = math.floor(game.points)

        local command = string.format(
            'curl -X POST http://localhost:3000/score -H "Content-Type: application/json" -d "{\\"player_name\\":\\"%s\\",\\"score\\":%d}"',
            playerName,
            score
        )

        os.execute(command)
    end
end




local function fetchHighscores()
    local command = 'curl http://localhost:3000/highscores > highscores.json'
    os.execute(command)

    local file = io.open("highscores.json", "r")
    if file then
        local content = file:read("*all")
        file:close()

        print("RAW JSON:")
        print(content)

        local data, pos, err = json.decode(content, 1, nil)

        if data and type(data) == "table" then
            highscores = data
            print("Highscores geladen:", #highscores)
        else
            print("JSON Fehler:", err)
            highscores = {}
        end
    else
        print("Datei nicht gefunden")
        highscores = {}
    end
end






local function startNewGame()
    if playerName ~= "" then
        enteringName = false
        changeGameState("running")
        game.points = 0
        scoreSaved = false
        highscores = {}

        enemies = {
            enemy(2)
        }
    end
end

function love.load()
    love.mouse.setVisible(false)
    love.window.setTitle("Save the Ball!")
    love.window.setMode(1000, 700)

    logo = love.graphics.newImage("logo.png")

    buttons.menu_state.play_game = button("Play Game", startNewGame, nil, 180, 50)
    buttons.menu_state.exit_game = button("Exit Game", love.event.quit, nil, 180, 50)

    buttons.ended_state.replay_game = button("Replay", startNewGame, nil, 130, 50)
    buttons.ended_state.menu = button("Menu", changeGameState, "menu", 130, 50)
    buttons.ended_state.exit_game = button("Quit", love.event.quit, nil, 130, 50)
end

function love.mousepressed(x, y, mouseButton, istouch, presses)
    if not game.state.running then
        if mouseButton == 1 then
            if game.state.menu then
                for _, currentButton in pairs(buttons.menu_state) do
                    currentButton:checkPressed(x, y, player.radius)
                end
            elseif game.state.ended then
                for _, currentButton in pairs(buttons.ended_state) do
                    currentButton:checkPressed(x, y, player.radius)
                end
            end
        end
    end
end

function love.textinput(text)
    if game.state.menu and enteringName then
        if #playerName < 15 then
            playerName = playerName .. text
        end
    end
end

function love.keypressed(key)
    if game.state.menu and enteringName then
        if key == "backspace" then
            playerName = playerName:sub(1, -2)
        elseif key == "return" then
            if playerName ~= "" then
                enteringName = false
            end
        end
    end

    if key == "escape" then
        if game.state.running then
            changeGameState("menu")
        end
    end
end

function love.update(dt)
    player.x, player.y = love.mouse.getPosition()

    if game.state.running then
        for i = 1, #enemies do
            if not enemies[i]:checkTouched(player.x, player.y, player.radius) then
                enemies[i]:move(player.x, player.y)

                for j = 1, #game.levels do
                    if math.floor(game.points) == game.levels[j] then
                        table.insert(enemies, enemy(2 + j))
                        game.points = game.points + 1
                    end
                end
            else
                if not scoreSaved then
                    saveScore()
                    fetchHighscores()
                    scoreSaved = true
                end
                changeGameState("ended")
                break
            end
        end

        game.points = game.points + dt
    end
end

function love.draw()
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(fonts.small.font)
    love.graphics.print("FPS: " .. love.timer.getFPS(), 10, screenHeight - 25)

    if game.state.running then
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(fonts.large.font)
        love.graphics.printf(
            math.floor(game.points),
            0,
            20,
            screenWidth,
            "center"
        )

        for i = 1, #enemies do
            enemies[i]:draw()
        end

        love.graphics.circle("fill", player.x, player.y, player.radius)

    elseif game.state.menu then
        local scaleX = screenWidth / logo:getWidth()
        local scaleY = screenHeight / logo:getHeight()

        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(logo, 0, 0, 0, scaleX, scaleY)

        love.graphics.setColor(0, 0, 0, 0.25)
        love.graphics.rectangle("fill", 0, 0, screenWidth, screenHeight)

        love.graphics.setFont(fonts.medium.font)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Name eingeben:", 0, screenHeight - 220, screenWidth, "center")

        local inputWidth = 220
        local inputHeight = 40
        local inputX = (screenWidth - inputWidth) / 2
        local inputY = screenHeight - 180

        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("fill", inputX, inputY, inputWidth, inputHeight)

        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("line", inputX, inputY, inputWidth, inputHeight)
        love.graphics.printf(playerName, inputX, inputY + 10, inputWidth, "center")

        local buttonX = screenWidth / 2 - 90
        buttons.menu_state.play_game:draw(buttonX, screenHeight - 115)
        buttons.menu_state.exit_game:draw(buttonX, screenHeight - 55)

    elseif game.state.ended then
         print(#highscores)
        local centerX = screenWidth / 2
        local buttonWidth = 130
        local buttonX = centerX - buttonWidth / 2

        love.graphics.setColor(1, 1, 1)

        love.graphics.setFont(fonts.large.font)
        love.graphics.printf(
            "Game Over",
            0,
            70,
            screenWidth,
            "center"
            
        )

        love.graphics.setFont(fonts.score.font)
        love.graphics.printf(
            math.floor(game.points),
            0,
            140,
            screenWidth,
            "center"
        )

        love.graphics.setFont(fonts.medium.font)
        love.graphics.printf(
            "Top 10 Highscores",
            0,
            210,
            screenWidth,
            "center"
        )

        love.graphics.setFont(fonts.small.font)
        for i, score in ipairs(highscores) do
            love.graphics.printf(
                i .. ". " .. score.player_name .. " - " .. score.score,
                0,
                240 + (i * 22),
                screenWidth,
                "center"
            )
        end

        buttons.ended_state.replay_game:draw(buttonX, 500)
        buttons.ended_state.menu:draw(buttonX, 560)
        buttons.ended_state.exit_game:draw(buttonX, 620)
    end

    if not game.state.running then
        love.graphics.setColor(1, 1, 1)
        love.graphics.circle("fill", player.x, player.y, player.radius / 2)
    end
end