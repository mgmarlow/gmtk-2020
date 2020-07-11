PlayState = Class {__includes = BaseState}

function PlayState:enter(params)
  self.player = Player {}
  -- totally arbitrary
  self.balls = {Ball {x = 200, y = 200}, Ball {x = 400, y = 400}}
end

function PlayState:update(dt)
  if love.keyboard.wasPressed('escape') then
    gStateMachine:change('pause')
  end

  self.player:update(dt, self.balls)

  for _, ball in ipairs(self.balls) do
    ball:update(dt, self.player)
  end
end

function PlayState:render()
  self.player:render()

  for _, ball in ipairs(self.balls) do
    ball:render()
  end
end

function PlayState:reset()
end

function PlayState:exit()
end
