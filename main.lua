-- Ronan Tsoi
-- CMPM 121 - Solitaire
-- 4-11-25
io.stdout:setvbuf("no")

require "card"
require "grabber"
require "stack"

function love.load()
  love.window.setTitle("Solitaire Hell")
  love.window.setMode(1080, 720)
  love.graphics.setBackgroundColor(0, 0.7, 0.2, 1)
  
  grabber = GrabberClass:new()
  cardTable = {}
  
  -- loading stacks
  deckPile = StackClass:new(30, 40, 1)
  drawPile = StackClass:new(30, 210, 2)
  
  tabs = {}
  for i = 1, 7, 1 do
    table.insert(tabs, StackClass:new(1080 - (120 * i) - 20, 220, 4))
  end
  suits = {}
  for i = 1, 4, 1 do
    table.insert(suits, StackClass:new(1080 - (120 * i) - 20, 40, 3, i))
  end
  
  -- 13 values (J, Q, K will just be 11, 12, 13)
  -- 4 suits
  -- cards created and loaded into deck pile
  for suit = 1, 4, 1 do
    for val = 1, 13, 1 do
      table.insert(deckPile.cards, CardClass:new(deckPile.position.x, deckPile.position.y, suit, val, false))
    end
  end
  
  -- shuffle
  math.randomseed(os.time())
  for i = 1, #deckPile.cards, 1 do
    local rand = math.random(1, #deckPile.cards)
    deckPile.cards[i], deckPile.cards[rand] = deckPile.cards[rand], deckPile.cards[i]
  end
  
  -- distribute to tableaux
  for num, tab in ipairs(tabs) do
    for i = 1, 8-num, 1 do
      local topCard = table.remove(deckPile.cards)
      table.insert(tab.cards, 1, topCard)
      topCard.position.x = tab.position.x
      topCard.position.y = tab.position.y + (40 * (#tab.cards-1))
    end
    tab.cards[1].isFaceUp = true
  end
  
end

function love.update()
  grabber:update()
  
  checkForMouseMoving()
end

--everything below here is still kind of a mess
function love.draw()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.print("Mouse: " .. tostring(grabber.currentMousePos.x) .. ", " ..
    tostring(grabber.currentMousePos.y))
  
  deckPile:draw()
  drawPile:draw()
  for _, tab in ipairs(tabs) do
    tab:draw()
  end
  for _, stack in ipairs(suits) do
    stack:draw()
  end
  grabber:draw()
end

function checkForMouseMoving()
  if grabber.currentMousePos == nil then
    return
  end
  
  drawPile:checkForMouseOver(grabber)
  for _, tab in ipairs(tabs) do
    tab:checkForMouseOver(grabber, tabs)
  end
  for _, stack in ipairs(suits) do
    stack:checkForMouseOver(grabber, tabs)
  end
  
end

function love.mousepressed(x, y, button, istouch)
  print("click")
  if #deckPile.cards ~= 0 then
    deckPile:checkForMouseOver(grabber, drawPile)
  end
  
end

