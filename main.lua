-- Ronan Tsoi
-- CMPM 121 - Solitaire
-- 4-11-25
io.stdout:setvbuf("no")

require "card"
require "grabber"
require "stack"

function love.load()
  love.window.setTitle("It's Just Solitaire")
  love.window.setMode(1080, 720)
  love.graphics.setBackgroundColor(0, 0.7, 0.2, 1)
  
  grabber = GrabberClass:new()
  cardTable = {}
  
  win = false
  winImage = love.graphics.newImage("assets/win.png")
  
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
  
  -- 13 values (J, Q, K will just be 11-13)
  -- 4 suits
  -- cards created and loaded into deck pile
  for suit = 1, 4, 1 do
    for val = 1, 13, 1 do
      table.insert(deckPile.cards, CardClass:new(deckPile.position.x, deckPile.position.y, suit, val, false, deckPile))
    end
  end
  
  -- fisher-yates shuffle
  math.randomseed(os.time())
  for i = 1, #deckPile.cards, 1 do
    local rand = math.random(1, #deckPile.cards)
    deckPile.cards[i], deckPile.cards[rand] = deckPile.cards[rand], deckPile.cards[i]
  end
  
  -- distribute to tableaux
  for num, tab in ipairs(tabs) do
    for i = 1, 8 - num, 1 do
      local topCard = table.remove(deckPile.cards)
      table.insert(tab.cards, 1, topCard)
      topCard.position.x = tab.position.x
      topCard.position.y = tab.position.y + (40 * (#tab.cards - 1))
      topCard.homePosition = tab
    end
    tab.cards[1].isFaceUp = true
  end
  
end

function love.update()
  if win ~= true then
    grabber:update()
    checkForMouseMoving()
    win = checkForWin()
  end
  
end

WHITE = {1, 1, 1, 1}
-- everything below here is still kind of a mess
function love.draw()
  love.graphics.setColor(WHITE)
  -- DEBUG
  --[[ love.graphics.print("Mouse: " .. tostring(grabber.currentMousePos.x) .. ", " ..
    tostring(grabber.currentMousePos.y)) ]]--
  love.graphics.print("Right Click to Restart", 30, 660)
  
  deckPile:draw()
  drawPile:draw()
  for _, tab in ipairs(tabs) do
    tab:draw()
  end
  for _, stack in ipairs(suits) do
    stack:draw()
  end
  grabber:draw()
  
  if win then
    love.graphics.setColor(WHITE)
    love.graphics.print("Congratulations! You won", 30, 640)
    love.graphics.draw(winImage, 200, 25, 0, 0.3, 0.2)
  end
end

function checkForWin()
  if #deckPile.cards ~= 0 then
    return false
  end
  for _, tab in ipairs(tabs) do
    for _, card in ipairs(tab.cards) do
      if card.isFaceUp == false then
        return false
      end
    end
  end
  return true
  
  -- DEBUG
  --[[ if #deckPile.cards == 0 then
    return true
  else
    return false
  end ]]--
end

function checkForMouseMoving()
  if win ~= true then
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
end

function love.mousepressed(x, y, button, istouch)
  if button == 2 then
    love.load()
  elseif win ~= true then
    deckPile:checkForMouseOver(grabber, drawPile)
  end
end

