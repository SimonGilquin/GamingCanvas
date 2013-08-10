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
  context.rect 690, 190, 20, 20
  context.fillStyle = 'green'
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

moveUnit = ->
  if game.unit.x < game.board.w
    game.unit.x+=.5

draw = ->
  game.context.clearRect game.canvas.x, game.canvas.y, game.canvas.width, game.canvas.height
  drawGrid()
  drawUI()
  drawUnit()

update = ->
  moveUnit()

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
  game =
    canvas: canvas
    context: context
    board:
      x: 0
      y: 0
      w: 601
      h: 401
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
      x: -10
      y: 200


window.game = game = init()

game.start() if autostart