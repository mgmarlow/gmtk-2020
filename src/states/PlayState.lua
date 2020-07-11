PlayState = Class {__includes = BaseState}

function PlayState:enter(params)
  self.level = params.level or Level {}
end

function PlayState:update(dt)
  if love.keyboard.wasPressed('escape') then
    gStateMachine:change('pause', {level = self.level})
  end

  self.level:update(dt)
end

function PlayState:render()
  self.level:render()
end

function PlayState:reset()
end

function PlayState:exit()
end
