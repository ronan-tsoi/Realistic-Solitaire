
require "vector"

GrabberClass = {}

GRABBER_STATE = {
  IDLE = 0,
  GRABBING = 1,
  RELEASE = 2,
}

GRABBER_OFFSET = 25

function GrabberClass:new()
  local grabber = {}
  local metadata = {__index = GrabberClass}
  setmetatable(grabber, metadata)
  
  grabber.previousMousePos = nil
  grabber.currentMousePos = nil
  
  grabber.grabPos = nil
  grabber.grabbing = false
  
  grabber.state = GRABBER_STATE.IDLE
  
  grabber.cards = {}
  
  return grabber
end

function GrabberClass:update()
  self.currentMousePos = Vector(
    love.mouse.getX(),
    love.mouse.getY()
  )
  
  -- Click (just the first frame)
  if love.mouse.isDown(1) and self.grabPos == nil then
    self:grab()
  end
  -- Release
  if not love.mouse.isDown(1) and self.grabPos ~= nil then
    self:release()
  end
  
  for _, card in ipairs(self.cards) do
    card.position.x = self.currentMousePos.x- (card.size.x/2)
    card.position.y = self.currentMousePos.y + (GRABBER_OFFSET * (#self.cards-1)) - (card.size.y/2)
  end
  
end

function GrabberClass:grab(item)
  self.grabPos = self.currentMousePos
  print("GRAB - " .. tostring(self.grabPos))
  self.state = GRABBER_STATE.GRABBING
end

function GrabberClass:release()
  print("RELEASE - ")
  self.state = GRABBER_STATE.RELEASE
  self.grabPos = nil
end

function GrabberClass:draw()
  -- DEBUG
  --[[ love.graphics.print(
    "holding " .. tostring(#self.cards) .. "\n" .. "state " .. tostring(self.state), self.currentMousePos.x + 50, self.currentMousePos.y - 50) ]]--
  for _, card in ipairs(self.cards) do
    card:draw()
  end
end
