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
    gameActionsInput: { tag: "NoOp" },
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

  game.ports.chatScrollDown.subscribe(function() {
    var el = document.getElementsByClassName("messages")[0];
    if (el) {
      setTimeout(function() {
        el.scrollTop = el.scrollHeight;
      }, 30);
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
        if (frame.tag == "RaceUpdate") {
          game.ports.raceInput.send(frame.raceUpdate);
        } else {
          game.ports.gameActionsInput.send(frame);
        }
      };

    } else {
      game.ports.raceInput.send(null);
    }
    currentTrackId = id;
  });
}

module.exports = mountElm;
