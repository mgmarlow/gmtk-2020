Player = Class {}

function Player:init()
  self.x = love.graphics.getWidth() / 2 - (96 / 2)
  self.y = love.graphics.getHeight() / 2 - (128 / 2)
  self.width = 96
  self.height = 128
  self.quads = generateQuads(gTextures.playersheet, 96, 128)
  self.grabzone = GrabZone {x = self.x, y = self.y}

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
  self.grabzone:update(dt, self.x, self.y)
end

function Player:render()
  self.stateMachine:render()
  self.grabzone:render()
end
