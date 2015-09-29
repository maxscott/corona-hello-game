-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
-- Your code here

require('physics')
physics.start()

-- require('myImage')
-- module(..., package.seeall)
-- local myFloor = myImage.floorCreator()

local paddle = nil
local function paddleInstance( ... )
	if paddle == nil then
		local x, y, w, h = 200, 500, 100, 100
		paddle = display.newRect(x, y, w, h)
		paddle.name = "Paddle"
		-- physics.addBody(paddle, "static", {density=1})
	end
	return paddle
end

paddle = paddleInstance()

local score = nil
local function scoreInstance( ... ) 
	if score == nil then
		score = display.newRect(0, 10, 20, 20)
		score.anchorX = 0
	end
	return score
end

score = scoreInstance()

local MyImages = {}
local function brickCreator( ... )
	local myImage = display.newImage('Icon.png')
	myImage.x = math.random(0, display.contentWidth)
	myImage.y = -100
	myImage.speed = 4
	myImage.name = "Brick"
	myImage.washit = false
	MyImages[#MyImages+1] = myImage
	-- physics.addBody(myImage)
end

local myTimer = timer.performWithDelay(300, brickCreator, 0)

local function brickFall(event)
	for i, myObject in pairs(MyImages) do
		if myObject ~= nil and myObject.x ~= nil then
			myObject.y = myObject.y + myObject.speed
			myObject.speed = math.min((myObject.speed * 1.08), 40)
			myObject.speed = myObject.speed - (myObject.speed * .02)
		end
	end
end

local function dragMe(event)
	if event.phase == "began" then
		event.target.rotation = event.target.rotation + 5
	elseif event.phase == "moved" then
		event.target.x = event.x
		event.target.y = event.y
	end
end

local function onCollision(event)
	if event.phase == "began" then
		local name1 = event.object1.name 
		local name2 = event.object2.name
		local paddle = nil
		local brick = nil 
		if name1 == "Paddle" and name2 == "Brick" then
			paddle = event.object1
			brick = event.object2
		elseif name2 == "Paddle" and name1 == "Brick" then
			paddle = event.object2
			brick = event.object1
		end

		if paddle ~= nil and brick ~= nil then
			if brick.washit == false then
				brick:setFillColor(1, 0, 0)
				score.width = score.width + 20
				brick.washit = true
			end
		end
	end
end

local function getCollision(event)
	for x, obj1 in pairs(MyImages) do
		for y, obj2 in pairs(MyImages) do
			if x ~= y then
				local myPaddle = nil
				local myBrick = nil
				local myBrick2 = nil
				if obj1.name == "Paddle" and obj2.name == "Brick" then
					myPaddle = obj1
					myBrick = obj2
				elseif obj2.name == "Paddle" and obj1.name == "Brick" then
					myPaddle = obj2
					myBrick = obj1
				elseif obj2.name == "Brick" and obj1.name == "Brick" then
					myBrick = obj1
					myBrick = obj2
				end

				if myPaddle ~= nil and myBrick ~= nil then
					collide()

end

local function update(event)
	brickFall(event)
	getCollisions(event)
end

local function cleanup(event)
	for i, obj in pairs(MyImages) do
		if obj ~= nil and obj.x == nil then
			obj = nil
			MyImages[i] = nil
		end
	end
end

local function onFrame(event)
	cleanup(event)
	update(event)
end


Runtime: addEventListener("enterFrame", onFrame)
Runtime: addEventListener("collision", onCollision)
paddle: addEventListener("touch", dragMe)







