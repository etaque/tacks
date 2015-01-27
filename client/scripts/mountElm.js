"use strict";

var $ = require('jquery');
var readData = require('./util').readData;
var routes = require('./routes');

function mountGame() {
  var wsUrl = readData("wsUrl");
  var initialInput = readData("initialInput");

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

function mountChat(div) {
  var wsUrl = routes.WebSockets.chatRoom().webSocketURL();
  var initialInput = { tag: "NoOp" };

  mountWebSocket(div, wsUrl, window.Elm.Chat.Main, "serverInput", "localOutput", initialInput);
}

function mountWebSocket(div, wsUrl, elmApp, inPort, outPort, initialInput) {

  var ws = new WebSocket(wsUrl);
  var portInit = {};
  portInit[inPort] = initialInput;
  var game = div ? Elm.embed(elmApp, div, portInit) : Elm.fullscreen(elmApp, portInit);

  ws.onmessage = function(event) {
    console.log(event.data);
    game.ports[inPort].send(JSON.parse(event.data));
  };

  function outputProxy(output) {
    ws.send(JSON.stringify(output));
  }

  ws.onopen = function() {
    game.ports[outPort].subscribe(outputProxy);
  };

  ws.onclose = function() {
    game.ports[outPort].unsubscribe(outputProxy);
  };
}

module.exports = {
  mountGame: mountGame,
  mountChat: mountChat,
  mountWebSocket: mountWebSocket
};
