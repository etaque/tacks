
function mountRace(wsUrl, initialInput) {
  "use strict";

  var ws = new WebSocket(wsUrl);
  var game = Elm.fullscreen(Elm.Main, { raceInput: initialInput });

  ws.onmessage = function(event) {
    game.ports.raceInput.send(JSON.parse(event.data));
  };

  function outputProxy(playerOutput) {
    ws.send(JSON.stringify(playerOutput));
  }

  ws.onopen = function() {
    game.ports.playerOutput.subscribe(outputProxy);
  };

  ws.onclose = function() {
    game.ports.playerOutput.unsubscribe(outputProxy);
  };
}
