"use strict";

var $ = require('jquery');
var readData = require('./util').readData;
var routes = require('./routes');

function mountGame() {
  var wsUrl = readData("wsUrl");
  var initialInput = { raceInput: readData("initialInput") };

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
  var messages = readData("messages");
  var initialInput = {
    serverInput: { tag: "NoOp" },
    messagesStore: messages
  };

  var mount = mountWebSocket(div, wsUrl, window.Elm.Chat.Main, "serverInput", "localOutput", initialInput);

  mount.game.ports["scrollDown"].subscribe(function() {
    var el = document.getElementsByClassName("chat-messages")[0];
    if (el) {
      setTimeout(function() {
        el.scrollTop = el.scrollHeight;
      }, 30);
    }
  });
}

function mountWebSocket(div, wsUrl, elmApp, inPort, outPort, initialInput) {

  var ws = new WebSocket(wsUrl);
  var game = div ? Elm.embed(elmApp, div, initialInput) : Elm.fullscreen(elmApp, initialInput);

  ws.onmessage = function(event) {
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

  return {
    ws: ws,
    game: game
  }
}

module.exports = {
  mountGame: mountGame,
  mountChat: mountChat,
  mountWebSocket: mountWebSocket
};
