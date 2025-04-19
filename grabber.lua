
require "vector"

GrabberClass = {}

function GrabberClass:new()
  local grabber = {}
  local metadata = {__index = GrabberClass}
  setmetatable(grabber, metadata)
  
  grabber.previousMousePos = nil
  grabber.currentMousePos = nil
  
  grabber.grabPos = nil
  
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
  
end

function GrabberClass:grab(item)
  self.grabPos = self.currentMousePos
  print("GRAB - " .. tostring(self.grabPos))
end
function GrabberClass:release()
  print("RELEASE - ")
  self.grabPos = nil
end

function GrabberClass:draw()
  love.graphics.print(tostring(self.grabPos), self.currentMousePos.x + 20, self.currentMousePos.y - 20)
end
