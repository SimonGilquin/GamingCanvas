// Generated by CoffeeScript 1.6.2
(function() {
  var draw, drawGrid, drawUI, drawUnit, game, init, moveUnit, update;

  drawGrid = function() {
    var x, y, _i, _j, _ref, _ref1, _ref2, _ref3;

    game.context.beginPath();
    for (x = _i = _ref = game.board.x, _ref1 = game.board.w; _i < _ref1; x = _i += 20) {
      game.context.moveTo(x + .5, game.board.y + .5);
      game.context.lineTo(x + .5, game.board.h + .5);
    }
    for (y = _j = _ref2 = game.board.y, _ref3 = game.board.h; _j <= _ref3; y = _j += 20) {
      game.context.moveTo(game.board.x + .5, y + .5);
      game.context.lineTo(game.board.w + .5, y + .5);
    }
    game.context.stroke();
    return game.context.closePath();
  };

  drawUI = function() {};

  drawUnit = function() {
    var context, unit;

    unit = game.unit;
    context = game.context;
    context.beginPath();
    context.arc(unit.x, unit.y, 5, 0, 2 * Math.PI, false);
    context.fillStyle = 'red';
    context.fill();
    context.stroke();
    return context.closePath();
  };

  moveUnit = function() {
    if (game.unit.x < game.board.w) {
      return game.unit.x += .5;
    }
  };

  draw = function() {
    game.context.clearRect(game.canvas.x, game.canvas.y, game.canvas.width, game.canvas.height);
    drawGrid();
    drawUI();
    return drawUnit();
  };

  update = function() {
    return moveUnit();
  };

  init = function() {
    var canvas, context, game, mainButton;

    canvas = document.createElement('canvas');
    canvas.width = 800;
    canvas.height = 401;
    canvas.x = 0;
    canvas.y = 0;
    document.body.appendChild(canvas);
    context = canvas.getContext('2d');
    mainButton = document.createElement('a');
    mainButton.innerHTML = 'Start !';
    mainButton.onclick = function() {
      return game.start();
    };
    document.body.appendChild(mainButton);
    return game = {
      canvas: canvas,
      context: context,
      board: {
        x: 0,
        y: 0,
        w: 601,
        h: 401
      },
      start: function() {
        var drawId, updateId;

        drawId = setInterval(draw, 10);
        updateId = setInterval(update, 1);
        mainButton.innerHTML = 'Pause...';
        mainButton.onclick = function() {
          return game.pause();
        };
        return this.pause = function() {
          clearInterval(drawId);
          clearInterval(updateId);
          mainButton.innerHTML = 'Start !';
          return mainButton.onclick = function() {
            return game.start();
          };
        };
      },
      unit: {
        x: -10,
        y: 200
      }
    };
  };

  window.game = game = init();

}).call(this);

/*
//@ sourceMappingURL=game.map
*/
