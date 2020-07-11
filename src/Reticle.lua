Reticle = Class {}

function Reticle:init(params)
  self.radius = 25
  self.x = params.x
  self.y = params.y
  self.width = params.width
  self.height = params.height
end

function Reticle:update(dt, shootable)
  self.x = shootable.x
  self.y = shootable.y
end

function Reticle:render()
  love.graphics.circle(
    'line',
    self.x + self.width / 2,
    self.y + self.height / 2,
    self.radius
  )
end
