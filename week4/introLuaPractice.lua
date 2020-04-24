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


-- If statements ------------------------------------------

age = 17

if age < 16 then
	io.write("You can go to school\n")
	local localVar = 10 --Local to this if statement
elseif age >= 16 and age < 18 then
	io.write("You can drive\n")
else
	io.write("You can vote\n")
end

print(localVar) --Prints nil

-- Conditional operator

print(age > 16 and true or false)

str = "Python is the best"

io.write("String: ", string.gsub(str, "Python", "Lua"), "\n")

io.write("Index: ", string.find(str, "the"))


i = 0

while (i < 10) do
	io.write(i, "\n")
	i = i + 1
end
