PlayState = Class {__includes = BaseState}

function PlayState:enter(params)
  self.player = Player {}
  -- totally arbitrary
  self.ball = Ball {x = 200, y = 200}
end

function PlayState:update(dt)
  if love.keyboard.wasPressed('escape') then
    gStateMachine:change('pause')
  end

  self.player:update(dt)
  self.ball:update(dt)
end

function PlayState:render()
  self.player:render()
  self.ball:render()
end

function PlayState:reset()
end

function PlayState:exit()
end
