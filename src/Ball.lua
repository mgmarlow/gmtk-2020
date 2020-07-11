Ball = Class {}

function Ball:init(params)
  self.x = params.x
  self.y = params.y
  self.width = 10
  self.height = 10
  self.kind = 'shootable'
end

function Ball:update(dt)
end

function Ball:render(dt)
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end
