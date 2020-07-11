GrabZone = Class {}

function GrabZone:init(params)
  self.x = params.x
  self.y = params.y
  self.playerWidth = params.playerWidth
  self.playerHeight = params.playerHeight
  self.width = 150
  self.height = self.width
end

function GrabZone:update(dt, x, y)
  self.x = x
  self.y = y
end

function GrabZone:render()
  if gDebug == true then
    love.graphics.rectangle(
      'line',
      self.x - self.width / 2,
      self.y - self.playerHeight / 2,
      self.width,
      self.height
    )
  end
end

function GrabZone:collides()
end
