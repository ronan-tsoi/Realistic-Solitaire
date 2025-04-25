
require "vector"

CardClass = {}

CARD_STATE = {
  IDLE = 0,
  MOUSE_OVER = 1,
  GRABBED = 2
}
SUITS = {
  "assets/suitDiamonds.png",
  "assets/suitClubs.png",
  "assets/suitHearts.png",
  "assets/suitSpades.png",
}

function CardClass:new(xPos, yPos, suit, value, isFaceUp)
  local card = {}
  local metadata = {__index = CardClass}
  setmetatable(card, metadata)
  
  card.position = Vector(xPos, yPos)
  card.size = Vector(100, 140)
  card.state = CARD_STATE.IDLE
  card.isMouseOver = false
  
  card.suit = suit
  card.value = value
  card.isFaceUp = isFaceUp
  
  card.backImage = love.graphics.newImage("assets/cardBackImage.png")
  card.suitPip = love.graphics.newImage(SUITS[tonumber(suit)])
  
  return card
end

function CardClass:update()

end

function CardClass:draw()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.rectangle("fill", self.position.x, self.position.y, self.size.x, self.size.y, 6, 6)
  
  if self.isFaceUp then
    love.graphics.draw(self.suitPip, self.position.x+12, self.position.y+6)
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf(self.value, self.position.x+45, self.position.y+100, 100)
    
  else
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.backImage, self.position.x, self.position.y)
  end
  
  --[[ love.graphics.print(
    tostring(self.state),
    self.position.x + 20, self.position.y - 20
    ) --debug ]]--
  
end

function CardClass:checkForMouseOver(grabber)  
  --self.grabbedBy = grabber
  
  local mousePos = grabber.currentMousePos
  
  self.isMouseOver =
    mousePos.x > self.position.x and
    mousePos.x < self.position.x + self.size.x and
    mousePos.y > self.position.y and
    mousePos.y < self.position.y + self.size.y
  
  if grabber.grabPos ~= nil and grabber.grabbing == false then
    if self.isMouseOver then
      self.state = CARD_STATE.GRABBED
      grabber.grabbing = true
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
    grabber.grabbing = true
  elseif self.state == CARD_STATE.MOUSE_OVER then
    grabber.grabbing = false
  end

end
