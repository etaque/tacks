"use strict";

var $ = require('jquery');
var readData = require('./util').readData;
var routes = require('./routes');

function mountElm() {
  var game = window.Elm.fullscreen(window.Elm.Main, {
    raceInput: null,
    appSetup: readData("appSetup")
  });

  var ws, wsUrl, currentTrackId;

  function outputProxy(output) {
    if (ws.readyState == WebSocket.OPEN) {
      ws.send(JSON.stringify(output));
    }
  }

  game.ports.playerOutput.subscribe(outputProxy);

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

      // ws.onopen = function() {
      //   game.ports.playerOutput.subscribe(outputProxy);
      // };

      // ws.onclose = function() {
      //   game.ports.playerOutput.unsubscribe(outputProxy);
      // };
    } else {
      game.ports.raceInput.send(null);
    }
    currentTrackId = id;
  });
}

module.exports = mountElm;
