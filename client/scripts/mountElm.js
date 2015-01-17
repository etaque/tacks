"use strict";

var $ = require('jquery');
var readData = require('./util').readData;

function mountElm() {
  var wsUrl = readData("wsUrl");
  var initialInput = readData("initialInput");

  function start() {
    mountWebSocket(wsUrl, window.Elm.Main, "raceInput", "playerOutput", initialInput);
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

function mountWebSocket(wsUrl, elmApp, inPort, outPort, initialInput) {

  var ws = new WebSocket(wsUrl);
  var portInit = {};
  portInit[inPort] = initialInput;
  var game = Elm.fullscreen(elmApp, portInit);

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
}

module.exports = mountElm;
