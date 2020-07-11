Player = Class {}

function Player:init()
  self.width = 96
  self.height = 128
  self.speed = 250
  self.x = love.graphics.getWidth() / 2
  self.y = love.graphics.getHeight() / 2

  self.quadIndex = 1
  self.currentAnimation = nil

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

  -- Keep actions separate so a player can move and shoot simultaneously
  self.actionMachine =
    StateMachine {
    ['idle'] = function()
      return BaseState {}
    end,
    ['shoot'] = function()
      return PlayerShootingState({player = self})
    end
  }
  self.stateMachine:change('idle')
end

function Player:update(dt, balls)
  if love.mouse.isDown(1) and self.grabzone.shootable ~= nil then
    self.actionMachine:change(
      'shoot',
      {shootable = self.grabzone.shootable}
    )
  end

  if self.currentAnimation ~= nil then
    self.currentAnimation:update(dt)
  end

  self.quadIndex =
    self.currentAnimation == nil and 1 or
    self.currentAnimation:getCurrentFrame()

  self.grabzone:update(dt, self.x, self.y, balls)
  self.stateMachine:update(dt)
  self.actionMachine:update(dt)
end

function Player:render()
  self.grabzone:render()
  self.stateMachine:render()
  self.actionMachine:render()
end
