// Generated by CoffeeScript 1.6.2
(function() {
  var autostart, canvas, context, draw, drawGrid, drawTurrets, drawUI, drawUnit, game, init, mainButton, moveUnit, update;

  autostart = true;

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

  drawUI = function() {
    var context;

    context = game.context;
    context.fillStyle = 'green';
    context.rect(game.ui.button.x, game.ui.button.y, game.ui.button.w, game.ui.button.w);
    context.fill();
    if (game.ui.temp != null) {
      context.rect(game.ui.temp.x, game.ui.temp.y, game.ui.temp.w, game.ui.temp.w);
      return context.fill();
    }
  };

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

  drawTurrets = function() {
    var context, turret, _i, _len, _ref;

    context = game.context;
    _ref = game.turrets;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      turret = _ref[_i];
      context.rect(turret.x, turret.y, turret.w, turret.w);
    }
    context.fillStyle = 'green';
    return context.fill();
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
    drawTurrets();
    return drawUnit();
  };

  update = function() {
    var event, _ref, _ref1, _ref2, _ref3, _results;

    moveUnit();
    _results = [];
    while (game.events.length !== 0) {
      event = game.events.shift();
      switch (event.type) {
        case 'mousedown':
          if ((game.ui.button.x < (_ref = event.x) && _ref < game.ui.button.x + game.ui.button.w)) {
            _results.push(game.ui.temp = {
              x: event.x - 10,
              y: event.y - 10,
              w: 20,
              h: 20,
              isInBoard: function() {
                var _ref1, _ref2;

                return (game.board.x < (_ref1 = this.x) && _ref1 < game.board.w) && (game.board.y < (_ref2 = this.y) && _ref2 < game.board.h);
              }
            });
          } else {
            _results.push(void 0);
          }
          break;
        case 'mousemove':
          if (game.ui.temp != null) {
            if ((game.board.x < (_ref1 = event.x) && _ref1 < game.board.w) && (game.board.y < (_ref2 = event.y) && _ref2 < game.board.h)) {
              game.ui.temp.x = Math.floor((event.x - 10) / 20) * 20 + 10;
              _results.push(game.ui.temp.y = Math.floor((event.y - 10) / 20) * 20 + 10);
            } else {
              game.ui.temp.x = event.x - 10;
              _results.push(game.ui.temp.y = event.y - 10);
            }
          } else {
            _results.push(void 0);
          }
          break;
        case 'mouseup':
          if ((_ref3 = game.ui.temp) != null ? _ref3.isInBoard() : void 0) {
            game.turrets.push(game.ui.temp);
            _results.push(game.ui.temp = null);
          } else {
            _results.push(void 0);
          }
          break;
        default:
          _results.push(void 0);
      }
    }
    return _results;
  };

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

  /*
  resetButton = document.createElement 'a'
  resetButton.innerHTML = 'Reset'
  resetButton.onclick = -> game.reset()
  document.body.appendChild resetButton
  */


  init = function() {
    var game;

    canvas.onmousedown = function(e) {
      return game.events.push({
        type: 'mousedown',
        x: e.offsetX,
        y: e.offsetY
      });
    };
    canvas.onmouseup = function(e) {
      return game.events.push({
        type: 'mouseup',
        x: e.offsetX,
        y: e.offsetY
      });
    };
    canvas.onmousemove = function(e) {
      return game.events.push({
        type: 'mousemove',
        x: e.offsetX,
        y: e.offsetY
      });
    };
    return game = {
      canvas: canvas,
      context: context,
      board: {
        x: 0,
        y: 0,
        w: 601,
        h: 401
      },
      events: [],
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
      },
      ui: {
        button: {
          x: 690,
          y: 190,
          w: 20,
          h: 20
        }
      },
      turrets: []
    };
  };

  window.game = game = init();

  if (autostart) {
    game.start();
  }

}).call(this);

/*
//@ sourceMappingURL=game.map
*/
