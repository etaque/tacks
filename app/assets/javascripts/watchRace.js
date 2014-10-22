
function watchRace(wsUrl, initialInput) {
  "use strict";

  var ws = new WebSocket(wsUrl);
  var game = Elm.fullscreen(Elm.Main, { raceInput: initialInput });

  ws.onmessage = function(event) {
    game.ports.raceInput.send(JSON.parse(event.data));
  };

  ws.onopen = function() {
    ws.send(JSON.stringify({ live: true }));
  };

}
