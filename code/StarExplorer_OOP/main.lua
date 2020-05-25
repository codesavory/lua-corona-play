-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )

-- Seed the random number generator
math.randomseed( os.time() )

-- Configure image sheet
local sheetOptions =
{
    frames =
    {
        {   -- 1) asteroid 1
            x = 0,
            y = 0,
            width = 102,
            height = 85
        },
        {   -- 2) asteroid 2
            x = 0,
            y = 85,
            width = 90,
            height = 83
        },
        {   -- 3) asteroid 3
            x = 0,
            y = 168,
            width = 100,
            height = 97
        },
        {   -- 4) ship
            x = 0,
            y = 265,
            width = 98,
            height = 79
        },
        {   -- 5) laser
            x = 98,
            y = 265,
            width = 14,
            height = 40
        },
    },
}

local backGroup
local mainGroup
local uiGroup
local myShip
local objectSheet = graphics.newImageSheet( "gameObjects.png", sheetOptions )

--ship class
--ship = {position_x=0,position_y=0}
local ship = {disp=0,shipGroup,shipSheet} --need to remove group and sheet if needed

--constructor of ship class
function ship:new(o, group, sheet, frame, width, height, dispX, dispY)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
	self.disp = display.newImageRect( group, sheet, frame, width, height )
  self.disp.x = dispX
	self.disp.y = dispY
  self.shipGroup = group
  self.shipSheet = sheet
	physics.addBody( self.disp, { radius=30, isSensor=true } )
	self.disp.myName = "ship"
  return o
end

--function ship.fireLaser()
--  newLaser = laser:new(nil, self.shipGroup, self.shipSheet, self.disp.x, self.disp.y)
--  newLaser.fireLaser()
--end

--function to drag the ship
function ship.dragShip(event)
  --local ship = self
  --DeepPrint(ship)
    local ship = event.target
    local phase = event.phase
    --print("Ship disp.x")
    --print(self.x)
    if ( "began" == phase ) then
        -- Set touch focus on the ship
        display.currentStage:setFocus(ship)
        -- Store initial offset position
        ship.touchOffsetX = event.x - ship.x
    elseif ("moved" == phase) then
        -- Move the ship to the new touch position
        ship.x = event.x - ship.touchOffsetX
    elseif ("ended" == phase or "cancelled" == phase) then
        -- Release touch focus on the ship
        display.currentStage:setFocus(nil)
    end

    return true
end

local function restoreShip()

    myShip.disp.isBodyActive = false
    myShip.disp.x = display.contentCenterX
    myShip.disp.y = display.contentHeight - 100

    -- Fade in the ship
    transition.to( myShip.disp, { alpha=1, time=4000,
        onComplete = function()
            myShip.disp.isBodyActive = true
            died = false
        end
    } )
end

laser = {disp = 0}
-- class method new //more like constructor

function laser:new (o, group, sheet, instance_X,instance_Y)
   o = o or {}
   setmetatable(o, self)
   self.__index = self
   self.disp = display.newImageRect(group, sheet, 5, 14, 40)
   physics.addBody(self.disp, "dynamic", {isSensor=true})
   self.disp.isBullet = true
   self.disp.myName = "laser"
   self.disp.x = instance_X
   self.disp.y = instance_Y
   return o
end

local function fireLaser()

    local newLaser = laser:new(nil, mainGroup, objectSheet, myShip.disp.x, myShip.disp.y)
    newLaser.disp:toBack()
    transition.to( newLaser.disp, { y=-80, time=500,
        onComplete = function() display.remove( newLaser ) end
    } )
end

local asteroid = {disp=0}

function asteroid:new(o, group, sheet, frame, width, height)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
	self.disp = display.newImageRect( group, sheet, frame, width, height )
	physics.addBody( self.disp, "dynamic", { radius=40, bounce=0.8 } )
	self.disp.myName = "asteroid"

	local whereFrom = math.random( 3 )

	if ( whereFrom == 1 ) then
        -- From the left
        self.disp.x = -60
        self.disp.y = math.random( 500 )
        self.disp:setLinearVelocity( math.random( 40,120 ), math.random( 20,60 ) )
    elseif ( whereFrom == 2 ) then
        -- From the top
        self.disp.x = math.random( display.contentWidth )
        self.disp.y = -60
        self.disp:setLinearVelocity( math.random( -40,40 ), math.random( 40,120 ) )
    elseif ( whereFrom == 3 ) then
        -- From the right
        self.disp.x = display.contentWidth + 60
        self.disp.y = math.random( 500 )
        self.disp:setLinearVelocity( math.random( -120,-40 ), math.random( 20,60 ) )
    end
    self.disp:applyTorque(math.random(-6, 6))
  	return o
end

-- Initialize variables
local lives = 3
local score = 0
local died = false

local asteroidTable = {}

local gameLoopTimer
local livesText
local scoreText


-- Set up display groups
backGroup = display.newGroup()  -- Display group for the background image
mainGroup = display.newGroup()  -- Display group for the ship, asteroids, lasers, etc.
uiGroup = display.newGroup()    -- Display group for UI objects like the score

-- Load the background
local background = display.newImageRect( backGroup, "background.png", 800, 1400 )
background.x = display.contentCenterX
background.y = display.contentCenterY

-- ship = display.newImageRect( mainGroup, objectSheet, 4, 98, 79 )

myShip = ship:new(nil, mainGroup, objectSheet, 4, 98, 79, display.contentCenterX, display.contentHeight - 100)
--print("Ship table")
--print(myShip[0])
-- Display lives and score
livesText = display.newText( uiGroup, "Lives: " .. lives, 70, 0, native.systemFont, 24 )
scoreText = display.newText( uiGroup, "Score: " .. score, 170, 0, native.systemFont, 24 )

-- Hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- Make thsi text also an object?
local function updateText()
    livesText.text = "Lives: " .. lives
    scoreText.text = "Score: " .. score
end

--newAsteroid = asteroid:new(nil, mainGroup, objectSheet, 1, 102, 85)

myShip.disp:addEventListener("tap", fireLaser)
myShip.disp:addEventListener("touch", myShip.dragShip)

local function gameLoop()

    -- Create new asteroid
    newAsteroid = asteroid:new(nil, mainGroup, objectSheet, 1, 102, 85, display.contentCenterX, display.contentHeight - 100)
    table.insert(asteroidTable, newAsteroid )

    -- Remove asteroids which have drifted off screen
    for i = #asteroidTable, 1, -1 do
        local thisAsteroid = asteroidTable[i].disp

        if ( thisAsteroid.x < -100 or
             thisAsteroid.x > display.contentWidth + 100 or
             thisAsteroid.y < -100 or
             thisAsteroid.y > display.contentHeight + 100 )
        then
            display.remove( thisAsteroid )
            table.remove( asteroidTable, i )
        end
    end
end

gameLoopTimer = timer.performWithDelay( 1000, gameLoop, 0 )

local function onCollision( event )

    if ( event.phase == "began" ) then

        local obj1 = event.object1
        local obj2 = event.object2

        if ( ( obj1.myName == "laser" and obj2.myName == "asteroid" ) or
             ( obj1.myName == "asteroid" and obj2.myName == "laser" ) )
        then
            -- Remove both the laser and asteroid
            display.remove( obj1 )
            display.remove( obj2 )

            for i = #asteroidTable, 1, -1 do
                if ( asteroidTable[i] == obj1 or asteroidTable[i] == obj2 ) then
                    table.remove( asteroidTable, i )
                    break
                end
            end

            -- Increase score
            score = score + 100
            scoreText.text = "Score: " .. score
        elseif ( ( obj1.myName == "ship" and obj2.myName == "asteroid" ) or
                 ( obj1.myName == "asteroid" and obj2.myName == "ship" ) )
        then
            if ( died == false ) then
                died = true

                -- Update lives
                lives = lives - 1
                livesText.text = "Lives: " .. lives

                if ( lives == 0 ) then
                    display.remove( myShip.disp )
                else
                    myShip.disp.alpha = 0
                    timer.performWithDelay( 1000, restoreShip )
                end
            end
        end
    end
end

Runtime:addEventListener( "collision", onCollision )
