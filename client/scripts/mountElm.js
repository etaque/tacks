"use strict";

var $ = require('jquery');
var routes = require('./routes');

function readData(id, el) {
  var value = $.trim($(('#' + id), el).html());
  return value && JSON.parse(value);
}

function mountElm() {
  var ws, wsUrl, currentTrackId;

  var game = window.Elm.fullscreen(window.Elm.Main, {
    raceInput: null,
    appSetup: readData("appSetup")
  });

  game.ports.playerOutput.subscribe(function(output) {
    if (ws.readyState == WebSocket.OPEN) {
      ws.send(JSON.stringify(output));
    }
  });

  game.ports.activeTrack.subscribe(function(id) {

    if (ws) {
      ws.close();
    }

    if (id) {
      wsUrl = routes.WebSockets.trackPlayer(id).webSocketURL();
      ws = new WebSocket(wsUrl);

      ws.onmessage = function(event) {
        game.ports.raceInput.send(JSON.parse(event.data));
      };

    } else {
      game.ports.raceInput.send(null);
    }
    currentTrackId = id;
  });
}

module.exports = mountElm;
