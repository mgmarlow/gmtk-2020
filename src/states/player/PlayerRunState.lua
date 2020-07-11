PlayerRunState = Class {__includes = BaseState}

local animations = {
  ['running'] = Animation {
    frames = {25, 26, 27},
    interval = 0.2,
    loop = true
  }
}

function PlayerRunState:init(params)
  self.player = params.player
  self.speed = 250
  self.rightFacing = true
end

function PlayerRunState:update(dt)
  local dir = {x = 0, y = 0}

  if self.currentAnimation ~= nil then
    self.currentAnimation:update(dt)
  end

  if love.keyboard.isDown('a') then
    self.rightFacing = false
    dir.x = -1
  end

  if love.keyboard.isDown('d') then
    self.rightFacing = true
    dir.x = 1
  end

  if love.keyboard.isDown('w') then
    dir.y = -1
  end

  if love.keyboard.isDown('s') then
    dir.y = 1
  end

  if dir.x == 0 and dir.y == 0 then
    self.player.stateMachine:change('idle')
    return
  end

  local normalLength = math.sqrt(dir.x ^ 2 + dir.y ^ 2)

  self.currentAnimation = self.currentAnimation or animations.running
  self.player.x = self.player.x + (dir.x / normalLength) * self.speed * dt
  self.player.y = self.player.y + (dir.y / normalLength) * self.speed * dt
end

function PlayerRunState:render()
  local quadIndex =
    self.currentAnimation == nil and 1 or
    self.currentAnimation:getCurrentFrame()

  love.graphics.draw(
    gTextures.playersheet,
    self.player.quads[quadIndex],
    self.player.x,
    self.player.y,
    0,
    self.rightFacing and 1 or -1,
    1,
    self.player.width / 2
  )
end
