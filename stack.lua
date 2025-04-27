require "vector"

StackClass = {} 

STACK_STATE = {
  IDLE = 0,
  GRABBED = 1
}

SUITS = {
  "assets/suitDiamonds.png",
  "assets/suitHearts.png",
  "assets/suitClubs.png",
  "assets/suitSpades.png",
}

TABLEAU_OFFSET = 40

function StackClass:new(xPos, yPos, stackType, suit)
  local stack = {}
  local metadata = {__index = StackClass}
  setmetatable(stack, metadata)
  
  stack.stackType = stackType
  -- 1 deck pile - no drag, no drop - click only, linked to draw pile
  -- 2 draw pile - yes drag, no drop
  -- 3 suit pile - yes drag, yes drop - draw suit
  -- 4 tableau - yes drag, yes drop - stagger cards
  
  if stack.stackType == 4 then
    stack.size = Vector(100, 460)
  elseif stack.stackType == 2 then
    stack.size = Vector(100, 140 + (TABLEAU_OFFSET * 2))
  else
    stack.size = Vector(100, 140)
  end
  
  if suit ~= nil then
    stack.suit = suit
    stack.suitPip = love.graphics.newImage(SUITS[tonumber(suit)])
  end
  
  stack.position = Vector(xPos, yPos)
  stack.cards = {}
  stack.isMouseOver = false
  stack.state = STACK_STATE.IDLE
  
  
  return stack
end

function StackClass:update()
  
end
function StackClass:draw()
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("line", self.position.x-5, self.position.y-5, self.size.x+10, self.size.y+10, 6, 6)
  
  if self.stackType == 3 then
    love.graphics.setColor(0, 0, 0, 0.4)
    love.graphics.draw(self.suitPip, self.position.x + 12, self.position.y + 25)
  end
  
  if self.stackType == 4 then
    --cards are staggered
    for i = #self.cards, 1, -1 do
      self.cards[i]:draw()
    end
  elseif self.stackType == 2 then
    for i = 3, 1, -1 do
      if i <= #self.cards then
        self.cards[i].position.x = self.position.x
        self.cards[i].position.y = self.position.y + (TABLEAU_OFFSET * (3-i))
        self.cards[i]:draw()
      end
    end
  else
    if #self.cards ~= 0 then
      self.cards[1]:draw()
    end
    
  end
  
  love.graphics.print(tostring(#self.cards), self.position.x, self.position.y - 20)
  -- DEBUG
  --[[ for i, card in ipairs(self.cards) do
    love.graphics.print(card.suit .. " " .. card.value, self.position.x, self.position.y + self.size.y + (20 * i))
  end ]]--
end

function StackClass:checkForMouseOver(grabber, ext)  --ext: multi-purpose variable for passing things into the stack
  local mousePos = grabber.currentMousePos

  self.isMouseOver =
    mousePos.x > self.position.x and
    mousePos.x < self.position.x + self.size.x and
    mousePos.y > self.position.y and
    mousePos.y < self.position.y + self.size.y
  
  -- click / drag input
  if self.stackType ~= 1 then
    if grabber.state == 1 and #grabber.cards == 0 and #self.cards ~= 0 then
      if self.isMouseOver then
        grabber.grabbing = true
        local topCard = table.remove(self.cards, 1)
        table.insert(grabber.cards, topCard)
        topCard.isFaceUp = true
        self.state = STACK_STATE.GRABBED
      end
    else
      self.state = STACK_STATE.IDLE
    end
  else
    if self.isMouseOver then
      for i = 1, 3, 1 do
        local topCard = table.remove(self.cards, 1)
        table.insert(ext.cards, 1, topCard)
        topCard.isFaceUp = true
        topCard.position.x = ext.position.x
        topCard.position.y = ext.position.y
      end
    end
  end

  -- drop input
  if self.isMouseOver and #grabber.cards ~= 0 and grabber.state == 2 then
    if self.stackType <= 2 then return
      
    elseif self.stackType == 3 then
      if #self.cards == 0 then --empty suit pile
        if grabber.cards[1].suit ~= self.suit
        or grabber.cards[1].value ~= 1
        then return end
      else --not empty
        if grabber.cards[1].suit ~= self.suit
        or grabber.cards[1].value ~= self.cards[1].value + 1
        then return end
      end
      
      local topCard = table.remove(grabber.cards, i)
      table.insert(self.cards, 1, topCard)
      topCard.position.x = self.position.x
      topCard.position.y = self.position.y
      grabber.state = 0
      for _, tab in ipairs(ext) do
        tab.cards[1].isFaceUp = true
      end
      
    elseif self.stackType == 4 then
      if #self.cards == 0 then --empty tableau
        if grabber.cards[1].suit ~= 13
        then
          return end
      else --not empty
        if grabber.cards[1]:getColor() == self.cards[1]:getColor()
        or grabber.cards[1].value ~= self.cards[1].value - 1
        then
          return end
      end
      local topCard = table.remove(grabber.cards, i)
      table.insert(self.cards, 1, topCard)
      topCard.position.x = self.position.x
      topCard.position.y = self.position.y + (TABLEAU_OFFSET * (#self.cards-1))
      for _, tab in ipairs(ext) do
        tab.cards[1].isFaceUp = true
      end
    end
  
  end

end
