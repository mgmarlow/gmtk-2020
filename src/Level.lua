Level = Class {}

function Level:init()
  self.balls = self:initializeBalls()
  self.ballSpawner = BallSpawner {}
  self.player =
    Player {
    x = love.graphics.getWidth() / 4,
    y = love.graphics.getHeight() / 2
  }

  Signal.register(
    'new_ball',
    function(params)
      table.insert(self.balls, Ball {x = params.x, y = params.y})
    end
  )
end

function Level:exit()
  Signal.clear('new_ball')
end

function Level:update(dt)
  self.ballSpawner:update(dt, self.balls)
  self.player:update(dt, self.balls)

  for _, ball in ipairs(self.balls) do
    ball:update(dt, self.player)
  end
end

function Level:render()
  self.ballSpawner:render()
  self.player:render()

  for _, ball in ipairs(self.balls) do
    ball:render()
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
