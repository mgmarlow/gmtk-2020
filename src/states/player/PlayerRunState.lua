PlayerRunState = Class {__includes = BaseState}

local animations = {
  ['running'] = Animation {
    frames = {25, 26, 27},
    interval = 0.1
  }
}

function PlayerRunState:init(params)
  self.player = params.player
end

function PlayerRunState:update(dt)
  local dir

  if self.currentAnimation ~= nil and self.currentAnimation.done == false then
    self.currentAnimation:update(dt)
  end

  if love.keyboard.isDown('a') then
    self.currentAnimation = animations.running
    dir = {x = -1, y = 0}
  elseif love.keyboard.isDown('d') then
    self.currentAnimation = animations.running
    dir = {x = 1, y = 0}
  elseif love.keyboard.isDown('w') then
    self.currentAnimation = animations.running
    dir = {x = 0, y = -1}
  elseif love.keyboard.isDown('s') then
    self.currentAnimation = animations.running
    dir = {x = 0, y = 1}
  else
  end

  if dir == nil then
    return
  end
end

function PlayerRunState:render()
  local quadIndex =
    self.currentAnimation == nil and 1 or
    self.currentAnimation:getCurrentFrame()

  love.graphics.draw(
    gTextures.playersheet,
    self.player.quads[quadIndex],
    self.player.x,
    self.player.y
  )
end
