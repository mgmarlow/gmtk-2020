LifeCounter = Class {}

function LifeCounter:init(params)
  self.x = params.x
  self.y = params.y
  self.entityWidth = params.width
  self.hearts = params.lives
  self.visible = false
  self.image = love.graphics.newImage('img/heart.png')
end

function LifeCounter:update(x, y)
  self.x = x
  self.y = y
end

function LifeCounter:render()
  if not self.visible then
    return
  end

  for i = 0, self.hearts - 1 do
    love.graphics.draw(
      self.image,
      self.x - self.entityWidth / 2 - (i * self.image:getWidth() * 1.5 + 5),
      self.y - self.image:getHeight() - 40,
      0,
      1.5,
      1.5
    )
  end
end

function LifeCounter:decrement()
  self.hearts = self.hearts - 1
  self.visible = true
  Timer.after(
    1,
    function()
      self.visible = false
    end
  )
end

function LifeCounter:isDead()
  return self.hearts <= 0
end
