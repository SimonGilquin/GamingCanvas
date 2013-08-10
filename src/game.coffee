
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
draw = ->
  drawGrid()

update = ->


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
      setTimeout draw, 10
      setTimeout update, 1


window.game = game = init()

game.start()