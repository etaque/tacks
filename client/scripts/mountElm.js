"use strict";

var $ = require('jquery');
var readData = require('./util').readData;
var routes = require('./routes');

function mountGame() {
  var wsUrl = readData("wsUrl");
  var initialInput = {
    gameSetup: readData("gameSetup"),
    raceInput: readData("initialInput")
  };

  function start() {
    mountWebSocket(null, wsUrl, window.Elm.Main, "raceInput", "playerOutput", initialInput);
  }

  if (wsUrl && initialInput) {
    var $help = $("#help");

    if ($help.length) {
      $("#startGame").click(function() {
        $help.hide();
        start();
      });
    } else {
      start();
    }
  }
}

function mountLiveCenter(div) {
  var initialInput = {
    messagesStore: readData("messages")
  };
  console.log(initialInput);

  var liveCenter = Elm.embed(window.Elm.LiveCenter.Main, div, initialInput);
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
  mountLiveCenter: mountLiveCenter,
  mountWebSocket: mountWebSocket
};
