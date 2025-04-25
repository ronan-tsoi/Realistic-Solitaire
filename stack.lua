require "vector"

StackClass = {} 

STACK_STATE = {
  IDLE = 0,
  GRABBED = 1
}

function StackClass:new(xPos, yPos)
  local stack = {}
  local metadata = {__index = StackClass}
  setmetatable(stack, metadata)
  
  stack.position = Vector(xPos, yPos)
  stack.size = Vector(100, 140)
  stack.cards = {}
  stack.isMouseOver = false
  stack.state = STACK_STATE.IDLE
  
  return stack
end

function StackClass:update()
  
end
function StackClass:draw()
  if #self.cards ~= 0 then
    self.cards[1]:draw()
  end
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("line", self.position.x-5, self.position.y-5, self.size.x+10, self.size.y+10, 6, 6)
  
  love.graphics.print(tostring(self.state), self.position.x, self.position.y - 20)
  
end

function StackClass:checkForMouseOver(grabber, cardTable)  
  local mousePos = grabber.currentMousePos

  self.isMouseOver =
    mousePos.x > self.position.x and
    mousePos.x < self.position.x + self.size.x and
    mousePos.y > self.position.y and
    mousePos.y < self.position.y + self.size.y

  if grabber.grabPos ~= nil and grabber.grabbing == false and #self.cards ~= 0 then
    if self.isMouseOver then
      grabber.grabbing = true
      topCard = table.remove(self.cards, 1)
      table.insert(cardTable, topCard)
      topCard.isFaceUp = true
      self.state = STACK_STATE.GRABBED
    end
  else
    self.state = STACK_STATE.IDLE
  end
  
  if self.state == STACK_STATE.GRABBED then
    topCard.position.x =  mousePos.x - (self.size.x/2)
    topCard.position.y =  mousePos.y - (self.size.y/2)
    grabber.grabbing = true
  else
    grabber.grabbing = false
  end
  
  if self.state == STACK_STATE.IDLE then
    if grabber.grabPos == nil then
      if self.isMouseOver then
        for index, card in ipairs(cardTable) do
          isCardOver =
          card.position.x > self.position.x and
          card.position.x < self.position.x + self.size.x and
          card.position.y > self.position.y and
          card.position.y < self.position.y + self.size.y
          if isCardOver == true then
            topCard = table.remove(cardTable, index)
            table.insert(self.cards, 1, topCard)
            topCard.position.x = self.position.x
            topCard.position.y = self.position.y
            break
          end
        end
      end
    end
  end
  

end