PauseState = Class {__includes = BaseState}

function PauseState:enter(params)
end

function PauseState:update(dt)
  if love.keyboard.wasPressed('return') then
    love.event.quit()
  end

  if love.keyboard.wasPressed('escape') then
    gStateMachine:change('play')
  end
end

function PauseState:render()
  love.graphics.setColor(0, 0, 0, 0.6)
  love.graphics.rectangle('fill', 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)

  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.setFont(gFonts['large'])
  love.graphics.printf('Paused!', 0, 50, WINDOW_WIDTH, 'center')

  love.graphics.setFont(gFonts['medium'])
  love.graphics.printf(
    "Hit 'escape' again to resume,\n'enter' to exit.",
    0,
    WINDOW_HEIGHT / 2 - 50,
    WINDOW_WIDTH,
    'center'
  )
end
