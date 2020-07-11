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
    end
  }
  self.stateMachine:change('idle')
end

function Player:update(dt)
  self.stateMachine:update(dt)
  self.grabzone:update(dt, self.x, self.y, self.width, self.height)
end

function Player:render()
  self.stateMachine:render()
  self.grabzone:render()
end
