local WINDOW_WIDTH = 1280
local WINDOW_HEIGHT = 720
local gameState = 0        --determines what gui is displayed
sequence = {}
score = 0

difficulty_string = {"Easy", "Normal", "Hard", "Insane"}
local current_Difficulty = 1

function love.load()
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
	})
	
    myFont = love.graphics.newFont(40)
    fontHeight = myFont:getHeight()
end
 
local menu = {}
menu.main = {}      --difficulty selection screen
menu.question = {}      --question screen
menu.result = {}       --result screen

menu.main.buttons = {}
menu.main.buttons.b1 = {x = WINDOW_WIDTH / 2 - 205, y = WINDOW_HEIGHT / 4 - 50, buttonWidth=410, buttonHeight=100, isPressed=false}
menu.main.buttons.b2 = {x = WINDOW_WIDTH / 2 - 205, y = WINDOW_HEIGHT / 4 + 60, buttonWidth=410, buttonHeight=100, isPressed=false}
menu.main.buttons.b3 = {x = WINDOW_WIDTH / 2 - 205, y = WINDOW_HEIGHT / 4 + 170, buttonWidth=410, buttonHeight=100, isPressed=false}
menu.main.buttons.b4 = {x = WINDOW_WIDTH / 2 - 205, y = WINDOW_HEIGHT / 4 + 280, buttonWidth=410, buttonHeight=100, isPressed=false}

menu.question.buttons = {}
menu.question.question = {x = WINDOW_WIDTH / 2 - 405, y = WINDOW_HEIGHT / 4 - 45, buttonWidth=810, buttonHeight=90}
menu.question.buttons.bA = {x = WINDOW_WIDTH / 2 - 405, y = WINDOW_HEIGHT / 4 - 45 + 100, buttonWidth=400, buttonHeight=90, isPressed=false}
menu.question.buttons.bB = {x = WINDOW_WIDTH / 2 + 5, y = WINDOW_HEIGHT / 4 - 45 + 100, buttonWidth=400, buttonHeight=90, isPressed=false}
menu.question.buttons.bC = {x = WINDOW_WIDTH / 2 - 405, y = WINDOW_HEIGHT / 4 - 45 + 200, buttonWidth=400, buttonHeight=90, isPressed=false}
menu.question.buttons.bD = {x = WINDOW_WIDTH / 2 + 5, y = WINDOW_HEIGHT / 4 - 45 + 200, buttonWidth=400, buttonHeight=90, isPressed=false}

function love.update(dt)
end

questions = {{}, {}, {}, {}, {}, {}, {}, {}, {}, {}}
-- {question, answer A, answer B, answer C, answer D, Correct answer }
questionPool = {
Easy = {
{"What does 7 + 3 =", "fourteen", "eleven", "ten", "twelve", 4}, {"How many sides does a trapezium have?", "three", "four", "five", "six", 3}, {"The sun is a what?", "star", "planet", "moon", "black hole", 2}, {"Which of the following is not an animal?", "tiger", "seagull", "antelope", "banana", 5}, {}, {}, {}, {}, {}, {},
{}, {}, {}, {}, {}, {}, {}, {}, {}, {},
{}, {}, {}, {}, {}, {}, {}, {}, {}, {}},
Normal = {
{}, {}, {}, {}, {}, {}, {}, {}, {}, {},
{}, {}, {}, {}, {}, {}, {}, {}, {}, {},
{}, {}, {}, {}, {}, {}, {}, {}, {}, {}},
Hard = {
{}, {}, {}, {}, {}, {}, {}, {}, {}, {},
{}, {}, {}, {}, {}, {}, {}, {}, {}, {},
{}, {}, {}, {}, {}, {}, {}, {}, {}, {}}, 
Insane = {
{}, {}, {}, {}, {}, {}, {}, {}, {}, {},
{}, {}, {}, {}, {}, {}, {}, {}, {}, {},
{}, {}, {}, {}, {}, {}, {}, {}, {}, {}}}

local displayed_question = 0

local function displayQuestion()
	for i=1, 3 do
		if displayed_question == i then
			return current_Difficulty[sequence[i]][1]
		end
	end
end

local function displayAnswer(k) 		--note k=1 is A, k=2 is B, k=3 is C, and k=4 is D
	for i=1, 3 do
		if displayed_question == i then
			return current_Difficulty[sequence[i]][k+1]
		end
	end
end

function check(n, k)        --checks if the generated number is equal to any of the previous numbers, if not then it will regenerate the number 
    for i=1, 100 do
        for j=1, n-1 do
            if sequence[n] == sequence[j] then 
                sequence[n] = love.math.random(k)
            end
        end
    end
end

function gen(small, big)        --generates "small" # of non-repeating random numbers from 1 to "big"
    sequence[1] = love.math.random(big)
    for t=2, small do
    sequence[t] = love.math.random(big)
    check(t, big)
    end
end

local function question_fill(small, big)
	gen(small, big)
	if menu.main.buttons.b1.isPressed then
		for t=1, 3 do
			for j=1, 6 do
				table.insert(questions[t], t, questionPool.Easy[sequence[t]][j]) 
			end
		end
	end

	if menu.main.buttons.b2.isPressed then
		for t=1, 3 do
			for j=1, 6 do
				table.insert(questions[t], t, questionPool.Normal[sequence[t]][j])
			end
		end
	end

	if menu.main.buttons.b3.isPressed then
		for t=1, 3 do
			for j=1, 6 do
				table.insert(questions[t], t, questionPool.Hard[sequence[t]][j])
			end
		end
	end
	
	if menu.main.buttons.b4.isPressed then
		for t=1, 3 do
			for j=1, 6 do
				table.insert(questions[t], t, questionPool.Insane[sequence[t]][j])
			end
		end
	end

end

--there will be a function that switches screen depending on the gamestate


local function mainGUI()        --defines main GUI as a function that can be called on when there is a change in gamestate
	--Easy difficulty button 
	myFont = love.graphics.newFont(40)
	fontHeight = myFont:getHeight()
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle("fill", WINDOW_WIDTH / 2 - 205, WINDOW_HEIGHT / 4 - 50, 410, 100)
    love.graphics.setColor(0.9, 1, 0.9, 1)
    love.graphics.rectangle("fill", WINDOW_WIDTH / 2 - 200, WINDOW_HEIGHT / 4 - 45, 400, 90)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.printf(difficulty_string[1], WINDOW_WIDTH / 2 - 200, WINDOW_HEIGHT / 4 - fontHeight / 2, 400, "center")

    --Normal difficulty button
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle("fill", WINDOW_WIDTH / 2 - 205, WINDOW_HEIGHT / 4 + 60, 410, 100)
    love.graphics.setColor(0.9, 1, 0.9, 1)
    love.graphics.rectangle("fill", WINDOW_WIDTH / 2 - 200, WINDOW_HEIGHT / 4 + 65, 400, 90)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.printf(difficulty_string[2], WINDOW_WIDTH / 2 - 200, WINDOW_HEIGHT / 4 + 110 - fontHeight / 2, 400, "center")

    --Hard difficulty button
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle("fill", WINDOW_WIDTH / 2 - 205, WINDOW_HEIGHT / 4 + 170, 410, 100)
    love.graphics.setColor(0.9, 1, 0.9, 1)
    love.graphics.rectangle("fill", WINDOW_WIDTH / 2 - 200, WINDOW_HEIGHT / 4 + 175, 400, 90)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.printf(difficulty_string[3], WINDOW_WIDTH / 2 - 200, WINDOW_HEIGHT / 4 + 220 - fontHeight / 2, 400, "center")

    --Insane difficulty button
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle("fill", WINDOW_WIDTH / 2 - 205, WINDOW_HEIGHT / 4 + 280, 410, 100)
    love.graphics.setColor(0.9, 1, 0.9, 1)
    love.graphics.rectangle("fill", WINDOW_WIDTH / 2 - 200, WINDOW_HEIGHT / 4 + 285, 400, 90)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.printf(difficulty_string[4], WINDOW_WIDTH / 2 - 200, WINDOW_HEIGHT / 4 + 330 - fontHeight / 2, 400, "center")
end

local function questionGUI()

	--question_string = displayQuestion()
	love.graphics.print(tostring(score))
	--Question Box
	myFont = love.graphics.newFont(30)
	fontHeight = myFont:getHeight()
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle("fill", WINDOW_WIDTH / 2 - 405, WINDOW_HEIGHT / 4 - 45, 810, 90)
    love.graphics.setColor(0.9, 1, 0.9, 1)
    love.graphics.rectangle("fill", WINDOW_WIDTH / 2 - 400, WINDOW_HEIGHT / 4 - 40, 800, 80)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.printf(displayQuestion(), WINDOW_WIDTH / 2 - 400, WINDOW_HEIGHT / 4 - fontHeight / 2, 800, "center")
	
    --Answer A button
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle("fill", WINDOW_WIDTH / 2 - 405, WINDOW_HEIGHT / 4 - 45 + 100, 400, 90)
    love.graphics.setColor(0.9, 1, 0.9, 1)
	love.graphics.rectangle("fill", WINDOW_WIDTH / 2 - 400, WINDOW_HEIGHT / 4 - 40 + 100, 390, 80)
	love.graphics.setColor(0, 0, 0, 1)
	love.graphics.printf(" A)   " .. displayAnswer(1), WINDOW_WIDTH / 2 - 400, WINDOW_HEIGHT / 4 + 100 - fontHeight / 2, 400, "left")

    --Answer C button
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle("fill", WINDOW_WIDTH / 2 - 405, WINDOW_HEIGHT / 4 - 45 + 200, 400, 90)
    love.graphics.setColor(0.9, 1, 0.9, 1)
	love.graphics.rectangle("fill", WINDOW_WIDTH / 2 - 400, WINDOW_HEIGHT / 4 - 40 + 200, 390, 80)
	love.graphics.setColor(0, 0, 0, 1)
	love.graphics.printf(" C)   " .. displayAnswer(3), WINDOW_WIDTH / 2 - 400, WINDOW_HEIGHT / 4 + 200 - fontHeight / 2, 400, "left")

    --Answer B button
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle("fill", WINDOW_WIDTH / 2 + 5, WINDOW_HEIGHT / 4 - 45 + 100, 400, 90)
    love.graphics.setColor(0.9, 1, 0.9, 1)
	love.graphics.rectangle("fill", WINDOW_WIDTH / 2 + 10, WINDOW_HEIGHT / 4 - 40 + 100, 390, 80)
	love.graphics.setColor(0, 0, 0, 1)
	love.graphics.printf(" B)   " .. displayAnswer(2), WINDOW_WIDTH / 2 + 10, WINDOW_HEIGHT / 4 + 100 - fontHeight / 2, 400, "left")

    --Answer D button
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle("fill", WINDOW_WIDTH / 2 + 5, WINDOW_HEIGHT / 4 - 45 + 200, 400, 90)
    love.graphics.setColor(0.9, 1, 0.9, 1)
	love.graphics.rectangle("fill", WINDOW_WIDTH / 2 + 10, WINDOW_HEIGHT / 4 - 40 + 200, 390, 80)
	love.graphics.setColor(0, 0, 0, 1)
	love.graphics.printf(" D)   " .. displayAnswer(4), WINDOW_WIDTH / 2 + 10, WINDOW_HEIGHT / 4 + 200 - fontHeight / 2, 400, "left")
end

function love.mousepressed(x, y, b, istouch)
    if b == 1 then
        if gameState == 0 then 
            if math.abs(menu.main.buttons.b1.x + menu.main.buttons.b1.buttonWidth / 2 - love.mouse.getX()) < menu.main.buttons.b1.buttonWidth / 2 and
			math.abs(menu.main.buttons.b1.y + menu.main.buttons.b1.buttonHeight / 2 - love.mouse.getY()) < menu.main.buttons.b1.buttonHeight / 2  then 
				current_Difficulty = questionPool.Easy
				displayed_question = displayed_question + 1
                gameState = gameState + 1 
                love.graphics.clear()
				menu.main.buttons.b1.isPressed = true
				question_fill(3, 4)

            elseif math.abs(menu.main.buttons.b2.x + menu.main.buttons.b2.buttonWidth / 2 - love.mouse.getX()) < menu.main.buttons.b2.buttonWidth / 2 and
			math.abs(menu.main.buttons.b2.y + menu.main.buttons.b2.buttonHeight / 2 - love.mouse.getY()) < menu.main.buttons.b2.buttonHeight / 2  then
				current_Difficulty = questionPool.Normal
				displayed_question = displayed_question + 1
                gameState = gameState + 1 
				love.graphics.clear()
				menu.main.buttons.b2.isPressed = true
				question_fill(3, 4)

            elseif math.abs(menu.main.buttons.b3.x + menu.main.buttons.b3.buttonWidth / 2 - love.mouse.getX()) < menu.main.buttons.b3.buttonWidth / 2 and
			math.abs(menu.main.buttons.b3.y + menu.main.buttons.b3.buttonHeight / 2 - love.mouse.getY()) < menu.main.buttons.b3.buttonHeight / 2  then
				current_Difficulty = questionPool.Hard
				displayed_question = displayed_question + 1
                gameState = gameState + 1 
				love.graphics.clear()
				current_Difficulty = 3
				menu.main.buttons.b3.isPressed = true
				question_fill(3, 4)

            elseif math.abs(menu.main.buttons.b4.x + menu.main.buttons.b4.buttonWidth / 2 - love.mouse.getX()) < menu.main.buttons.b4.buttonWidth / 2 and
			math.abs(menu.main.buttons.b4.y + menu.main.buttons.b4.buttonHeight / 2 - love.mouse.getY()) < menu.main.buttons.b4.buttonHeight / 2  then 
				current_Difficulty = questionPool.Insane
				displayed_question = displayed_question + 1
                gameState = gameState + 1 
				love.graphics.clear()
				current_Difficulty = 4
				menu.main.buttons.b4.isPressed = true
				question_fill(3, 4)
			end
			
		elseif gameState == 1 then 
			if math.abs(menu.question.buttons.bA.x + menu.question.buttons.bA.buttonWidth / 2 - love.mouse.getX()) < menu.question.buttons.bA.buttonWidth / 2 and
			math.abs(menu.question.buttons.bA.y + menu.question.buttons.bA.buttonHeight / 2 - love.mouse.getY()) < menu.question.buttons.bA.buttonHeight / 2  then
				love.graphics.clear() 
				if questions[displayed_question][displayed_question] == 2 then			--this checks if the answer is correct
					score = score + 1
				end
				displayed_question = displayed_question + 1

			elseif math.abs(menu.question.buttons.bB.x + menu.question.buttons.bB.buttonWidth / 2 - love.mouse.getX()) < menu.question.buttons.bB.buttonWidth / 2 and
			math.abs(menu.question.buttons.bB.y + menu.question.buttons.bB.buttonHeight / 2 - love.mouse.getY()) < menu.question.buttons.bB.buttonHeight / 2  then
				love.graphics.clear()
				if questions[displayed_question][displayed_question] == 3 then 
					score = score + 1
				end
				displayed_question = displayed_question + 1

			elseif math.abs(menu.question.buttons.bC.x + menu.question.buttons.bC.buttonWidth / 2 - love.mouse.getX()) < menu.question.buttons.bC.buttonWidth / 2 and
			math.abs(menu.question.buttons.bC.y + menu.question.buttons.bC.buttonHeight / 2 - love.mouse.getY()) < menu.question.buttons.bC.buttonHeight / 2  then
				love.graphics.clear()
				if questions[displayed_question][displayed_question] == 4 then
					score = score + 1
				end
				displayed_question = displayed_question + 1

			elseif math.abs(menu.question.buttons.bD.x + menu.question.buttons.bD.buttonWidth / 2 - love.mouse.getX()) < menu.question.buttons.bD.buttonWidth / 2 and
			math.abs(menu.question.buttons.bD.y + menu.question.buttons.bD.buttonHeight / 2 - love.mouse.getY()) < menu.question.buttons.bD.buttonHeight / 2  then
				love.graphics.clear() 
				if questions[displayed_question][displayed_question] == 5 then
					score = score + 1
				end
				displayed_question = displayed_question + 1
			end
        end 
    end
end

function love.draw()

 
    love.graphics.setBackgroundColor(1, 1, 1, 1)    --sets background white
    love.graphics.setFont(myFont)
    
    if gameState == 0 then 
        mainGUI()
    end

    if gameState == 1 then
        questionGUI()
    end

end