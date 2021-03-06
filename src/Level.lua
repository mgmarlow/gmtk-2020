Level = Class {}

function Level:init()
  self.balls = self:initializeBalls()
  self.enemies = self:initializeEnemies()
  self.ballSpawner = BallSpawner {}
  self.player =
    Player {
    x = love.graphics.getWidth() / 4,
    y = love.graphics.getHeight() / 2
  }

  Signal.register(
    'new_ball',
    function(params)
      table.insert(self.balls, Ball(params))
    end
  )
end

function Level:exit()
  Signal.clear('new_ball')
  self.player:exit()

  for _, enemy in ipairs(self.enemies) do
    enemy:exit()
  end
end

function Level:update(dt)
  self.player:update(dt, self.balls)
  self.ballSpawner:update(dt, self.player)

  for _, ball in ipairs(self.balls) do
    ball:update(dt, self.player, self.enemies)
  end

  local numDead = 0
  for _, enemy in ipairs(self.enemies) do
    if enemy.dead then
      numDead = numDead + 1
    end
    enemy:update(dt, self.player)
  end

  if numDead == #self.enemies then
    gStateMachine:change('victory')
  end
end

function Level:render()
  self.ballSpawner:render()
  self.player:render()

  for _, ball in ipairs(self.balls) do
    ball:render()
  end

  for _, enemy in ipairs(self.enemies) do
    enemy:render()
  end
end

local NUM_BALLS = 4
function Level:initializeBalls()
  -- 5 is ball width
  local ballX = love.graphics.getWidth() / 2 - 5

  return {
    Ball {x = ballX, y = 150 - 5},
    Ball {x = ballX, y = 300 - 5},
    Ball {x = ballX, y = 450 - 5},
    Ball {x = ballX, y = 600 - 5}
  }
end

function Level:initializeEnemies()
  local enemyX = love.graphics.getWidth() - 100 - (96 / 2)
  local enemyY = love.graphics.getHeight() / 3 - (130 / 2)

  return {
    Enemy {x = enemyX, y = enemyY},
    Enemy {x = enemyX, y = enemyY * 2 + 100}
  }
end
