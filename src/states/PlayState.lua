PlayState = Class {__includes = BaseState}

function PlayState:enter(params)
  self.player = Player {}
end

function PlayState:update(dt)
  if love.keyboard.wasPressed('escape') then
    gStateMachine:change('pause')
  end

  self.player:update(dt)
end

function PlayState:render()
  self.player:render()
end

function PlayState:reset()
end

function PlayState:exit()
end
