
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
  drawUnit()

update = ->
  moveUnit()

init = ->
  canvas = document.createElement 'canvas'
  canvas.width = 800
  canvas.height = 401
  canvas.x = 0
  canvas.y = 0
  document.body.appendChild canvas

  context = canvas.getContext '2d'
  game =
    canvas: canvas
    context: context
    board:
      x: 0
      y: 0
      w: 601
      h: 401
    start: ->
      setInterval draw, 10
      setInterval update, 1
    unit:
      x: -10
      y: 200


window.game = game = init()

game.start()