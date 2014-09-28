
function mountRace(wsUrl, initialInput) {
  "use strict";

  var ws = new WebSocket(wsUrl);
  var game = Elm.fullscreen(Elm.Main, { raceInput: initialInput });

  ws.onmessage = function(event) {
    game.ports.raceInput.send(JSON.parse(event.data));
  };

  ws.onopen = function() {
    game.ports.playerOutput.subscribe(function(state) {
      ws.send(JSON.stringify(state));
    });
  };
}
