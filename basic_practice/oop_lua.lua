--======================RECTANGLE CLASS===================
-- Meta class //data members
Rectangle = {area = 0, length = 0, breadth = 0}

-- class method new //more like constructor

function Rectangle:new (o,length,breadth)
   o = o or {}
   setmetatable(o, self)
   self.__index = self
   self.length = length or 0
   self.breadth = breadth or 0
   self.area = length*breadth;
   return o
end

-- class method printArea //member functions

function Rectangle:printArea ()
   print("The area of Rectangle as base class is ",self.area)
end

-- objects in lua
r = Rectangle:new(nil,10,20)
print(r.length)
r:printArea()

--===============SHAPE CLASS================
-- Meta class
Shape = {area = 0}

-- Base class method new

function Shape:new (o,side)
   o = o or {}
   setmetatable(o, self)
   self.__index = self
   side = side or 0
   self.area = side*side;
   return o
end

-- Base class method printArea

function Shape:printArea ()
   print("The area of shape base class is ",self.area)
end

-- Creating an object
myshape = Shape:new(nil,10)
myshape:printArea()

--=======================SQUARE CLASS derived from SHAPE CLASS=================
Square = Shape:new()

-- Derived class method new

function Square:new (o,side)
   o = o or Shape:new(o,side)
   setmetatable(o, self)
   self.__index = self
   return o
end

-- Derived class method printArea //overriding base function

function Square:printArea ()
   print("The area of square as derived from shape is ",self.area)
end

-- Creating an object
mysquare = Square:new(nil,10)
mysquare:printArea()

--=======================RECTANGLE CLASS derived from SHAPE CLASS=================
Rectangle = Shape:new()

-- Derived class method new

function Rectangle:new (o,length,breadth)
   o = o or Shape:new(o)
   setmetatable(o, self)
   self.__index = self
   self.area = length * breadth
   return o
end

-- Derived class method printArea //overriding base function

function Rectangle:printArea ()
    print("The area of Rectangle as derived from shape is ",self.area)
end

-- Creating an object

myrectangle = Rectangle:new(nil,10,20)
myrectangle:printArea()
