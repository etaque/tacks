
function mountWebSocket(wsUrl, elmApp, inPort, outPort, initialInput) {
  "use strict";

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
