Ball = Class {}

function Ball:init(params)
  self.x = params.x
  self.y = params.y
  self.kind = 'shootable'
end

function Ball:update(dt)
end

function Ball:render(dt)
  love.graphics.rectangle('fill', self.x, self.y, 10, 10)
end
