"use strict";

var $ = require('jquery');
var readData = require('./util').readData;
var routes = require('./routes');

function mountGame() {
  var game = Elm.fullscreen(window.Elm.Main, {
    raceInput: null,
    messagesStore: readData("messages")
  });

  var ws, wsUrl, currentRaceCourseId;

  game.ports.activeRaceCourse.subscribe(function(id) {
    if (ws) {
      ws.close();
    }

    if (id) {
      wsUrl = routes.WebSockets.raceCoursePlayer(id).webSocketURL();
      ws = new WebSocket(wsUrl);

      function outputProxy(output) {
        ws.send(JSON.stringify(output));
      }

      ws.onmessage = function(event) {
        game.ports.raceInput.send(JSON.parse(event.data));
      };

      ws.onopen = function() {
        game.ports.playerOutput.subscribe(outputProxy);
      };

      ws.onclose = function() {
        game.ports.playerOutput.unsubscribe(outputProxy);
      };
    }
    currentRaceCourseId = id;
  });

}


function mountChat(div) {
  var wsUrl = routes.WebSockets.chatRoom().webSocketURL();
  var messages = readData("messages");
  var initialInput = {
    serverInput: { tag: "NoOp" },
    messagesStore: messages
  };

  var game = mountWebSocket(div, wsUrl, window.Elm.Chat.Main, "serverInput", "localOutput", initialInput);

  game.ports["scrollDown"].subscribe(function() {
    var el = document.getElementsByClassName("chat-messages")[0];
    if (el) {
      setTimeout(function() {
        el.scrollTop = el.scrollHeight;
      }, 30);
    }
  });
}

function mountWebSocket(div, wsUrl, elmApp, inPort, outPort, initialInput) {

  var game = div ? Elm.embed(elmApp, div, initialInput) : Elm.fullscreen(elmApp, initialInput);
  var ws;

  function createWebSocket() {

    ws = new WebSocket(wsUrl);

    ws.onmessage = function(event) {
      game.ports[inPort].send(JSON.parse(event.data));
    };

    function outputProxy(output) {
      ws.send(JSON.stringify(output));
    }

    ws.onopen = function() {
      console.log("WebSocket open:", wsUrl);
      game.ports[outPort].subscribe(outputProxy);
    };

    ws.onclose = function() {
      game.ports[outPort].unsubscribe(outputProxy);
      console.log("WebSocket closed, will try to reconnect in 10s...", wsUrl);

      setTimeout(function () {
        createWebSocket();
      }, 10*1000);
    };
  }

  createWebSocket();

  return game;
}

module.exports = {
  mountGame: mountGame,
  mountChat: mountChat,
  mountWebSocket: mountWebSocket
};
