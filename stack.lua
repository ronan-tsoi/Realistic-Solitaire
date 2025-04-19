StackClass{} 

function StackClass:new(xPos, yPos)
  local stack = {}
  local metadata = {__index = StackClass}
  setmetatable(stack, metadata)
  
  stack.position = nil
  stack.cardTable = {}
  
  return stack
end
function StackClass:update()
  
end
function StackClass:draw()
  
end
function StackClass: