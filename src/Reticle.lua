Reticle = Class {}

local LINE_LENGTH = 100

function Reticle:init(params)
  self.radius = 25
  self.x = params.x
  self.y = params.y
  self.destX = params.x
  self.destY = params.y
  self.width = params.width
  self.height = params.height
end

function Reticle:update(dt, shootable)
  self.x = shootable.x
  self.y = shootable.y

  local normX, normY = self:getNormalizedVector()
  self.destX = self.x + normX * LINE_LENGTH
  self.destY = self.y + normY * LINE_LENGTH
end

function Reticle:render()
  love.graphics.circle(
    'line',
    self.x + self.width / 2,
    self.y + self.height / 2,
    self.radius
  )

  love.graphics.line(
    self.x + self.width / 2,
    self.y + self.height / 2,
    self.destX,
    self.destY
  )
end

function Reticle:getNormalizedVector()
  local mx, my = love.mouse.getPosition()

  -- vectors
  local dirX = mx - self.x
  local dirY = my - self.y

  local dirLength = math.sqrt(dirX * dirX + dirY * dirY)

  return dirX / dirLength, dirY / dirLength
end
