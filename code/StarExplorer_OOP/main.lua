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

function ship.new(group, sheet)
  	local self = setmetatable({}, ship)
	self.disp = display.newImageRect( group, sheet, 4, 98, 79 )
  	self.disp.x = display.contentCenterX
	self.disp.y = display.contentHeight - 100
	physics.addBody( self.disp, { radius=30, isSensor=true } )
	self.disp.myName = "ship"
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

local myShip = ship.new(mainGroup, objectSheet)
