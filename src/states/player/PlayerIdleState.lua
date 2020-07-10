PlayerIdleState = Class {__includes = BaseState}

function PlayerIdleState:init(params)
  self.player = params.player
end

function PlayerIdleState:update(dt)
  if
    love.keyboard.wasPressed('w') or love.keyboard.wasPressed('a') or
      love.keyboard.wasPressed('s') or
      love.keyboard.wasPressed('d')
   then
    self.player.stateMachine:change('run')
  end
end

function PlayerIdleState:render()
  love.graphics.draw(
    gTextures.playersheet,
    self.player.quads[1],
    self.player.x,
    self.player.y
  )
end
