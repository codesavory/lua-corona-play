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

local objectSheet = graphics.newImageSheet( "gameObjects.png", sheetOptions )

local ship = {}

function ship.new(group, sheet, frame, width, height, dispX, dispY)
  	local self = setmetatable({}, ship)
	self.disp = display.newImageRect( group, sheet, frame, width, height )
  	self.disp.x = dispX
	self.disp.y = dispY
	physics.addBody( self.disp, { radius=30, isSensor=true } )
	self.disp.myName = "ship"
  	return self
end

local asteroid = {}

function asteroid.new(group, sheet, frame, width, height)
  	local self = setmetatable({}, asteroid)
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

  	return self
end


-- Initialize variables
local lives = 3
local score = 0
local died = false
 
local asteroidsTable = {}
 
local gameLoopTimer
local livesText
local scoreText


-- Set up display groups
local backGroup = display.newGroup()  -- Display group for the background image
local mainGroup = display.newGroup()  -- Display group for the ship, asteroids, lasers, etc.
local uiGroup = display.newGroup()    -- Display group for UI objects like the score

-- Load the background
local background = display.newImageRect( backGroup, "background.png", 800, 1400 )
background.x = display.contentCenterX
background.y = display.contentCenterY

-- ship = display.newImageRect( mainGroup, objectSheet, 4, 98, 79 )

local myShip = ship.new(mainGroup, objectSheet, 4, 98, 79, display.contentCenterX, display.contentHeight - 100)

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

local newAsteroid = asteroid.new(mainGroup, objectSheet, 1, 102, 85, display.contentCenterX, display.contentHeight - 100)
