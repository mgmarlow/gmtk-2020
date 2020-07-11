require 'src/dependencies'

function love.load()
  if arg[2] == '--console' then
    gDebug = true
  end

  love.window.setTitle('SUPERBALL')

  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)

  gFonts = {
    ['small'] = love.graphics.newFont('fonts/cardenio_modern.otf', 18),
    ['medium'] = love.graphics.newFont('fonts/cardenio_modern.otf', 32),
    ['medium-large'] = love.graphics.newFont(
      'fonts/cardenio_modern.otf',
      64
    ),
    ['large'] = love.graphics.newFont('fonts/cardenio_modern.otf', 142)
  }

  gTextures = {
    ['playersheet'] = love.graphics.newImage(
      'img/character_robot_sheet.png'
    )
  }

  gStateMachine =
    StateMachine {
    ['start'] = function()
      return StartState()
    end,
    ['play'] = function()
      return PlayState()
    end,
    ['pause'] = function()
      return PauseState()
    end,
    ['game_over'] = function()
      return GameOverState()
    end
  }
  gStateMachine:change('start')

  gCamera =
    Camera(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)

  love.keyboard.keysPressed = {}
end

function love.update(dt)
  gStateMachine:update(dt)
  Timer.update(dt)

  love.keyboard.keysPressed = {}
end

function love.keypressed(key)
  love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
  if love.keyboard.keysPressed[key] then
    return true
  else
    return false
  end
end

function love.draw()
  love.graphics.setBackgroundColor(45 / 255, 77 / 255, 149 / 255, 50 / 100)
  gCamera:attach()
  gStateMachine:render()
  gCamera:detach()
end
