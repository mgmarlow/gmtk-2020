PlayerShootingState = Class {__includes = BaseState}

local animations = {
  ['shooting'] = Animation {
    frames = {14, 15},
    interval = 0.2
  }
}

function PlayerShootingState:init(params)
  self.player = params.player
  self.rightFacing = true
end

function PlayerShootingState:enter(params)
  self.shootable = params.shootable
  self.reticle =
    Reticle {
    x = params.shootable.x,
    y = params.shootable.y,
    width = params.shootable.width,
    height = params.shootable.height
  }
end

function PlayerShootingState:update(dt)
  self.reticle:update(dt, self.shootable)

  if not love.mouse.isDown(1) then
    self.currentAnimation = animations.shooting
    self.shootable.dir = self.reticle.angle
    self.player.stateMachine:change('run')
  end
end

function PlayerShootingState:render()
  -- Move into reticle
  if self.shootable ~= nil then
    self.reticle:render()
  end

  local quadIndex =
    self.currentAnimation == nil and 14 or
    self.currentAnimation:getCurrentFrame()

  love.graphics.draw(
    gTextures.playersheet,
    self.player.quads[quadIndex],
    self.player.x,
    self.player.y,
    0,
    self.rightFacing and 1 or -1,
    1,
    self.player.width / 2,
    self.player.height / 2
  )
end
