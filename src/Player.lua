Player = Class {}

function Player:init()
  self.width = 96
  self.height = 128
  self.x = love.graphics.getWidth() / 2
  self.y = love.graphics.getHeight() / 2

  self.quads =
    generateQuads(gTextures.playersheet, self.width, self.height)

  self.grabzone =
    GrabZone {
    x = self.x,
    y = self.y,
    playerWidth = self.width,
    playerHeight = self.height
  }

  self.stateMachine =
    StateMachine {
    ['idle'] = function()
      return PlayerIdleState({player = self})
    end,
    ['run'] = function()
      return PlayerRunState({player = self})
    end,
    ['shoot'] = function()
      return PlayerShootingState({player = self})
    end
  }
  self.stateMachine:change('idle')
end

function Player:update(dt, balls)
  if love.mouse.isDown(1) and self.grabzone.shootable ~= nil then
    self.stateMachine:change(
      'shoot',
      {shootable = self.grabzone.shootable}
    )
  end

  self.grabzone:update(dt, self.x, self.y, balls)
  self.stateMachine:update(dt)
end

function Player:render()
  self.grabzone:render()
  self.stateMachine:render()
end
