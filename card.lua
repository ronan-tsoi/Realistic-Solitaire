
require "vector"

CardClass = {}

CARD_STATE = {
  IDLE = 0,
  MOUSE_OVER = 1,
  GRABBED = 2
}

function CardClass:new(xPos, yPos)
  local card = {}
  local metadata = {__index = CardClass}
  setmetatable(card, metadata)
  
  card.position = Vector(xPos, yPos)
  card.size = Vector(50, 70)
  card.state = CARD_STATE.IDLE
  card.isMouseOver = false
  
  return card
end

function CardClass:update()
  
end

function CardClass:draw()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.rectangle("fill", self.position.x, self.position.y, self.size.x, self.size.y, 6, 6)
  
  love.graphics.print(
    tostring(self.state),
    self.position.x + 20, self.position.y - 20
    ) --debug
  
end

function CardClass:checkForMouseOver(grabber)  
  --self.grabbedBy = grabber
  
  local mousePos = grabber.currentMousePos
  
  self.isMouseOver =
    mousePos.x > self.position.x and
    mousePos.x < self.position.x + self.size.x and
    mousePos.y > self.position.y and
    mousePos.y < self.position.y + self.size.y
  
  if grabber.grabPos ~= nil then
    if self.isMouseOver then
      self.state = CARD_STATE.GRABBED
      end
  else
    if self.isMouseOver then
      self.state = CARD_STATE.MOUSE_OVER
    else
      self.state = CARD_STATE.IDLE
    end
  end
  
  if self.state == CARD_STATE.GRABBED then
    self.position.x =  mousePos.x - (self.size.x/2)
    self.position.y =  mousePos.y - (self.size.y/2)
  end

end
