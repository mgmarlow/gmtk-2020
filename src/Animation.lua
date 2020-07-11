Animation = Class {}

function Animation:init(def)
  self.frames = def.frames
  self.interval = def.interval
  self.timer = 0
  self.currentFrame = 1
  self.done = false
  self.loop = def.loop or false
end

function Animation:update(dt)
  if self.currentFrame == #self.frames and self.timer > self.interval then
    if self.loop then
      self.currentFrame = 1
    else
      self.done = true
      return
    end
  end

  -- no need to update if animation is only one frame
  if #self.frames > 1 then
    self.timer = self.timer + dt

    if self.timer > self.interval then
      self.timer = self.timer % self.interval

      local activeFrame = (self.currentFrame + 1) % (#self.frames + 1)
      self.currentFrame = math.max(1, activeFrame)
    end
  end
end

function Animation:getCurrentFrame()
  return self.frames[self.currentFrame]
end

function Animation:reset()
  self.done = false
  self.currentFrame = 1
  self.timer = 0
end
