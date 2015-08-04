"use strict";

var $ = require('jquery');
var readData = require('./util').readData;
var routes = require('./routes');

function mountElm() {
  var game = window.Elm.fullscreen(window.Elm.Main, {
    raceInput: null,
    messagesStore: readData("messages"),
    currentPlayer: readData("currentPlayer")
  });

  var ws, wsUrl, currentRaceCourseId;

  function outputProxy(output) {
    ws.send(JSON.stringify(output));
  }

  game.ports.activeRaceCourse.subscribe(function(id) {
    if (ws) {
      ws.close();
    }

    if (id) {
      wsUrl = routes.WebSockets.raceCoursePlayer(id).webSocketURL();
      ws = new WebSocket(wsUrl);

      ws.onmessage = function(event) {
        game.ports.raceInput.send(JSON.parse(event.data));
      };

      ws.onopen = function() {
        game.ports.playerOutput.subscribe(outputProxy);
      };

      ws.onclose = function() {
        game.ports.playerOutput.unsubscribe(outputProxy);
      };
    } else {
      game.ports.raceInput.send(null);
    }
    currentRaceCourseId = id;
  });
}

module.exports = mountElm;
