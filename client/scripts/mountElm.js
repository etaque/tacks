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
    chatInput: null,
    appSetup: readData("appSetup")
  });

  game.ports.playerOutput.subscribe(function(output) {
    if (ws.readyState == WebSocket.OPEN) {
      ws.send(JSON.stringify({ tag: "PlayerInput", "playerInput": output }));
    }
  });

  game.ports.chatOutput.subscribe(function(output) {
    if (output && ws.readyState == WebSocket.OPEN) {
      ws.send(JSON.stringify({ tag: "NewMessage", "content": output }));
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
        var frame = JSON.parse(event.data);
        switch (frame.tag) {
          case "RaceUpdate":
            game.ports.raceInput.send(frame.raceUpdate);
          break;
          case "BroadcastMessage":
            game.ports.chatInput.send(frame.message);
          break;
        }
      };

    } else {
      game.ports.raceInput.send(null);
    }
    currentTrackId = id;
  });
}

module.exports = mountElm;
