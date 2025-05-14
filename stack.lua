require "vector"

StackClass = {} 

STACK_STATE = {
  IDLE = 0,
  GRABBED = 1
}

STACK_TYPE = {
  DECK = 1,
  DRAW = 2,
  SUIT = 3,
  TABLEAU = 4
}

BLACK = {0, 0, 0, 1}
SHADE = {0, 0, 0, 0.4}


SUITS = {
  "assets/suitDiamonds.png",
  "assets/suitClubs.png",
  "assets/suitHearts.png",
  "assets/suitSpades.png",
}

TABLEAU_OFFSET = 40

function StackClass:new(xPos, yPos, stackType, suit)
  local stack = {}
  local metadata = {__index = StackClass}
  setmetatable(stack, metadata)
  
  stack.stackType = stackType
  
  if stack.stackType == STACK_TYPE.TABLEAU then
    stack.size = Vector(100, 460)
  elseif stack.stackType == STACK_TYPE.DRAW then
    stack.size = Vector(100, 140 + (TABLEAU_OFFSET * 2))
  else
    stack.size = Vector(100, 140)
  end
  
  if suit ~= nil then
    stack.suit = suit
    stack.suitPip = love.graphics.newImage(SUITS[tonumber(suit)])
  end
  if stackType == STACK_TYPE.DECK then
    stack.recycle = love.graphics.newImage("assets/recycle.png")
  end
  
  stack.position = Vector(xPos, yPos)
  stack.cards = {}
  stack.isMouseOver = false
  stack.state = STACK_STATE.IDLE
  
  return stack
end

function StackClass:draw()
  love.graphics.setColor(BLACK)
  love.graphics.rectangle("line", self.position.x - 5, self.position.y - 5, self.size.x + 10, self.size.y + 10, 6, 6)
  
  love.graphics.setColor(SHADE)
  
  if self.stackType == STACK_TYPE.DECK then
    if #self.cards == 0 then
      love.graphics.draw(self.recycle, self.position.x + 60, self.position.y + 15, 1, 0.15)
    end
  end
  
  if self.stackType == STACK_TYPE.SUIT then
    love.graphics.draw(self.suitPip, self.position.x + 12, self.position.y + 25)
  end
  
  if self.stackType == STACK_TYPE.TABLEAU then
    -- cards are staggered
    for i = #self.cards, 1, -1 do
      self.cards[i]:draw()
    end
  elseif self.stackType == STACK_TYPE.DRAW then
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
  
  -- DEBUG
  --love.graphics.print(tostring(#self.cards), self.position.x, self.position.y - 20)
  --[[ for i, card in ipairs(self.cards) do
    love.graphics.print(card.suit .. " " .. card.value, self.position.x, self.position.y + self.size.y + (20 * i))
  end ]]--
end

function StackClass:pushCard(from, to, cardCount) --move card between stacks (to --> from) and update card's position data
  for i = 1, cardCount, 1 do
    local topCard = table.remove(from.cards, 1)
    table.insert(to.cards, 1, topCard)
    topCard.isFaceUp = true
    if to.position ~= nil then
      topCard.position.x = to.position.x
      if to.stackType ~= STACK_TYPE.TABLEAU then
        topCard.position.y = to.position.y
      else
        topCard.position.y = to.position.y + (TABLEAU_OFFSET * (#to.cards-1))
      end
      topCard.homePosition = to
    end
  end
end

function StackClass:checkForMouseOver(grabber, other)  -- other: pass other stacks through the function- mainly used to link up the deck/draw piles
  local mousePos = grabber.currentMousePos

  self.isMouseOver =
    mousePos.x > self.position.x and
    mousePos.x < self.position.x + self.size.x and
    mousePos.y > self.position.y and
    mousePos.y < self.position.y + self.size.y
  
  -- click / drag input
  if self.stackType ~= STACK_TYPE.DECK then -- stack is not the deck, meaning cards can be dragged from the pile
    self:evaluateDragInput(grabber, other)
  else -- stack is the deck, three cards are drawn and moved to the draw pile
    if self.isMouseOver then
      if #self.cards ~= 0 then
        for i = 1, 3, 1 do
          if self.cards[1] ~= nil then
            self:pushCard(self, other, 1)
          end
        end
      else -- deck is empty, return draw pile cards to the deck
        for i = #other.cards, 1, -1 do
          local bottomCard = table.remove(other.cards, i)
          table.insert(self.cards, bottomCard)
          bottomCard.isFaceUp = false
          bottomCard.position.x = self.position.x
          bottomCard.position.y = self.position.y
        end
      end
    end
  end
  -- drop input
  if self.isMouseOver and #grabber.cards ~= 0 and grabber.state == 2 then
    self:evaluateDropInput(grabber, other)  
  end
end

function StackClass:evaluateDragInput(grabber, other)
  if grabber.state == 1 and #grabber.cards == 0 and #self.cards ~= 0 then
    if self.isMouseOver then
      grabber.grabbing = true
      if self.stackType ~= STACK_TYPE.TABLEAU then
        self:pushCard(self, grabber, 1)
      else -- tableau
        local cursorHeight = #self.cards - math.floor((grabber.currentMousePos.y - self.position.y) / TABLEAU_OFFSET)
        if cursorHeight < 1 then cursorHeight = 1 end
        
        if self.cards[cursorHeight].isFaceUp then
          self:pushCard(self, grabber, cursorHeight)
        end
        
        end
      self.state = STACK_STATE.GRABBED
    end
  else
    self.state = STACK_STATE.IDLE
  end
end

function StackClass:evaluateDropInput(grabber, other)
  if self == grabber.cards[1].homePosition then
      self:pushCard(grabber, self, #grabber.cards)
      grabber.state = 0
      return
    end
    
  if self.stackType <= STACK_TYPE.DRAW then return end -- cannot normally drop cards into deck/draw piles
    
  if self.stackType == STACK_TYPE.SUIT then
    if #self.cards == 0 then -- empty suit pile
      if grabber.cards[1].suit ~= self.suit
      or grabber.cards[1].value ~= 1
      then return end
    else --not empty
      if grabber.cards[1].suit ~= self.suit
      or grabber.cards[1].value ~= self.cards[1].value + 1
      then return end
    end
    
    self:pushCard(grabber, self, 1)
    grabber.state = 0
    for _, tab in ipairs(other) do
      if tab.cards[1] ~= nil then
        tab.cards[1].isFaceUp = true
      end
    end
    
  elseif self.stackType == STACK_TYPE.TABLEAU then
    if #self.cards == 0 then -- empty tableau
      if grabber.cards[1].value ~= 13 then return end -- can only put a king in an empty tableau
    else -- tableau is not empty OR grabber is holding a king
      if grabber.cards[1]:getColor() == self.cards[1]:getColor() or
          grabber.cards[1].value ~= self.cards[1].value - 1 then
          return end
    end
    self:pushCard(grabber, self, #grabber.cards)
    for _, tab in ipairs(other) do
      if tab.cards[1] ~= nil then
        tab.cards[1].isFaceUp = true
      end
    end
  end
end
