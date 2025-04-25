-- Ronan Tsoi
-- CMPM 121 - Pickup
-- 4-11-25
io.stdout:setvbuf("no")

require "card"
require "grabber"
require "stack"

function love.load()
  love.window.setMode(960, 640)
  love.graphics.setBackgroundColor(0, 0.7, 0.2, 1)
  
  grabber = GrabberClass:new()
  cardTable = {}
  
  testStack = StackClass:new(600, 100)
  
  table.insert(cardTable, CardClass:new(100,100,1,1,false))
  table.insert(cardTable, CardClass:new(300,100,1,1,false))
  table.insert(testStack.cards, CardClass:new(testStack.position.x,testStack.position.y,2,4,false))
  table.insert(testStack.cards, CardClass:new(testStack.position.x,testStack.position.y,3,8,false))
  --piles = {}
  --table.insert(piles, 
end

function love.update()
  grabber:update()
  
  checkForMouseMoving()
  
  for _, card in ipairs(cardTable) do
    card:update()
  end
end

function love.draw()
  for _, card in ipairs(cardTable) do 
    card:draw() --card.draw(card)
    grabber:draw()
  end
  
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.print("Mouse: " .. tostring(grabber.currentMousePos.x) .. ", " ..
    tostring(grabber.currentMousePos.y))
  
  testStack:draw()
end

function checkForMouseMoving()
  if grabber.currentMousePos == nil then
    return
  end
  
  for _, card in ipairs(cardTable) do
    card:checkForMouseOver(grabber)
  end
  testStack:checkForMouseOver(grabber, cardTable)
  
end
