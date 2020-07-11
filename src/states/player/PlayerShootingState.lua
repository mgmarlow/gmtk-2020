PlayerShootingState = Class {__includes = BaseState}

local animations = {
  ['shooting'] = Animation {
    frames = {14, 15},
    interval = 0.5
  }
}

function PlayerShootingState:init(params)
  self.player = params.player
  self.rightFacing = true
end

function PlayerShootingState:enter(params)
  self.player.speed = 50
  self.shootable = params.shootable
  self.reticle =
    Reticle {
    x = params.shootable.x,
    y = params.shootable.y,
    width = params.shootable.width,
    height = params.shootable.height
  }
end

function PlayerShootingState:exit()
  self.player.speed = 250
end

function PlayerShootingState:update(dt)
  if self.shootable ~= nil then
    self.shootable.velocity = 100
  end

  self.reticle:update(dt, self.shootable)

  -- Check grabzone since this will update to nil if the ball
  -- goes out of range.
  if not self.player.grabzone.shootable then
    self.shootable:resetVelocity()
    -- Don't fire, instead the player loses the ball.
    self.player.actionMachine:change('idle')
    return
  end

  if not love.mouse.isDown(1) then
    self.player.cooldown.fill = 50
    self.player.grabzone.shootable:resetVelocity()
    self.shootable:fire(self.reticle.angle)
    self.player.actionMachine:change('idle')
    self.player.invincible = true
    Timer.after(
      1,
      function()
        self.player.invincible = false
      end
    )
  end
end

function PlayerShootingState:render()
  -- Move into reticle
  if self.shootable ~= nil then
    self.reticle:render()
  end
end
