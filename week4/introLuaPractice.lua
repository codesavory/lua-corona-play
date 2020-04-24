-- VARIABLES --------------------------------------------

name = "John"

-- Len of str
io.write("Size of ", name, " is ", #name, "\n")

num = 14207502983
 -- Type func
io.write(type(num), "\n")

-- Floats
num = 1.42075029832340879

io.write(num, "\n")

longString = [[
I am a very long string
that goes on forever]]

-- Concatenation
longString = longString .. name

-- Bools
isAbleToDrive = true

io.write(type(isAbleToDrive), "\n")

io.write(type(madeUpVar), "\n")


-- MATH --------------------------------------------------

io.write(5+3, "\n")

io.write(5-3, "\n")

io.write(5*3, "\n")

io.write(5/3, "\n")

io.write(5.2%3, "\n")

io.write(math.random(), "\n")   -- Between 0 and 1

io.write(math.random(10), "\n")	-- Between 1 and 10

io.write(math.random(5, 100), "\n")

math.randomseed(os.time())

print(string.format("Pi = %.10f", math.pi))

-- Operators ----------------------------------------------

-- Not equals: ~=

