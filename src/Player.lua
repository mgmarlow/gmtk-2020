Player = Class {}

function Player:init()
  self.x = love.graphics.getWidth() / 2
  self.y = love.graphics.getHeight() / 2
  self.width = 96
  self.height = 128
  self.quads = generateQuads(gTextures.playersheet, 96, 128)

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
end

function Player:render(dt)
  self.stateMachine:render(dt)
end
