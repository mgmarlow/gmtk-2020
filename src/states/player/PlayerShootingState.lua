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
  self.shootable = params.shootable
  self.reticle =
    Reticle {
    x = params.shootable.x,
    y = params.shootable.y,
    width = params.shootable.width,
    height = params.shootable.height
  }
end

-- TODO: Need to slow down the physics a bit while click is being held
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
    self.player.stateMachine:change('run')
    return
  end

  if not love.mouse.isDown(1) then
    self.player.grabzone.shootable:resetVelocity()
    -- TODO: need a timer on this animation so it actually finishes
    -- self.player.currentAnimation = animations.shooting
    -- Timer.after(
    --   0.6,
    --   function()
    --     self.player.currentAnimation = nil
    --   end
    -- )
    self.shootable:fire(self.reticle.angle)
    self.player.stateMachine:change('run')
  end
end

function PlayerShootingState:render()
  -- Move into reticle
  if self.shootable ~= nil then
    self.reticle:render()
  end

  love.graphics.draw(
    gTextures.playersheet,
    self.player.quads[14],
    self.player.x,
    self.player.y,
    0,
    self.rightFacing and 1 or -1,
    1,
    self.player.width / 2,
    self.player.height / 2
  )
end
