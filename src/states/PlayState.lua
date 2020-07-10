PlayState = Class {__includes = BaseState}

function PlayState:enter(params)
end

function PlayState:update(dt)
  if love.keyboard.wasPressed('escape') then
    gStateMachine:change('pause')
  end
end

function PlayState:render()
end

function PlayState:reset()
end

function PlayState:exit()
end
