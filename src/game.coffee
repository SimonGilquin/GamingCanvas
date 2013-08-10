autostart = true

drawGrid = ->
  game.context.beginPath()
  for x in [game.board.x...game.board.w] by 20
    game.context.moveTo x + .5, game.board.y + .5
    game.context.lineTo x + .5, game.board.h + .5
  for y in [game.board.y..game.board.h] by 20
    game.context.moveTo game.board.x + .5, y + .5
    game.context.lineTo game.board.w + .5, y + .5
  game.context.stroke()
  game.context.closePath()

drawUI = ->
  context = game.context
  context.fillStyle = 'green'
  context.rect game.ui.button.x, game.ui.button.y, game.ui.button.w, game.ui.button.w
  context.fill()
  if game.ui.temp?
    context.rect game.ui.temp.x, game.ui.temp.y, game.ui.temp.w, game.ui.temp.w
    context.fill()

drawUnit = ->
  unit = game.unit
  context = game.context
  context.beginPath()
  context.arc unit.x, unit.y, 5, 0, 2 * Math.PI, false
  context.fillStyle = 'red'
  context.fill()
  context.stroke()
  context.closePath()

drawTurrets = ->
  context = game.context
  for turret in game.turrets
    context.rect turret.x, turret.y, turret.w, turret.w
  context.fillStyle = 'green'
  context.fill()

moveUnit = ->
  unit = game.unit
  if unit.x < game.board.w
    blocked = false
    for turret in game.turrets
      blocked = turret.x <= unit.x+.5 <=turret.x+turret.w and turret.y <= unit.y <=turret.y+turret.h
    if blocked
      unit.y+=.5
    else
      unit.x+=.5

draw = ->
  game.context.clearRect game.canvas.x, game.canvas.y, game.canvas.width, game.canvas.height
  drawGrid()
  drawUI()
  drawTurrets()
  drawUnit()

update = ->
  moveUnit()
  until game.events.length == 0
    event = game.events.shift()
    switch event.type
      when 'mousedown'
        if game.ui.button.x < event.x < game.ui.button.x + game.ui.button.w
          game.ui.temp =
            x: event.x - 10
            y: event.y - 10
            w: 20
            h: 20
            isInBoard: -> game.board.x < @x < game.board.w and game.board.y < @y < game.board.h
      when 'mousemove'
        if game.ui.temp?
          if game.board.x < event.x < game.board.w and game.board.y < event.y < game.board.h
            game.ui.temp.x = Math.floor((event.x - 10) / 20) * 20 + 10
            game.ui.temp.y = Math.floor((event.y - 10) / 20) * 20 + 10
          else
            game.ui.temp.x = event.x - 10
            game.ui.temp.y = event.y - 10
      when 'mouseup'
        if game.ui.temp?.isInBoard()
          game.turrets.push game.ui.temp
          game.ui.temp = null


canvas = document.createElement 'canvas'
canvas.width = 800
canvas.height = 401
canvas.x = 0
canvas.y = 0
document.body.appendChild canvas

context = canvas.getContext '2d'

mainButton = document.createElement 'a'
mainButton.innerHTML = 'Start !'
mainButton.onclick = -> game.start()
document.body.appendChild mainButton

###
resetButton = document.createElement 'a'
resetButton.innerHTML = 'Reset'
resetButton.onclick = -> game.reset()
document.body.appendChild resetButton
###

init = ->
  canvas.onmousedown = (e) ->
    game.events.push
      type: 'mousedown'
      x: e.offsetX
      y: e.offsetY
  canvas.onmouseup = (e) ->
    game.events.push
      type: 'mouseup'
      x: e.offsetX
      y: e.offsetY
  canvas.onmousemove = (e) ->
    game.events.push
      type: 'mousemove'
      x: e.offsetX
      y: e.offsetY
  game =
    canvas: canvas
    context: context
    board:
      x: 0
      y: 0
      w: 601
      h: 401
    events: []
    start: ->
      drawId = setInterval draw, 10
      updateId = setInterval update, 1
      mainButton.innerHTML = 'Pause...'
      mainButton.onclick = -> game.pause()
      @pause = ->
        clearInterval drawId
        clearInterval updateId
        mainButton.innerHTML = 'Start !'
        mainButton.onclick = -> game.start()
    unit:
      x: -100
      y: 200
    ui:
      button:
        x: 690
        y: 190
        w: 20
        h: 20
    turrets: []


window.game = game = init()

game.start() if autostart