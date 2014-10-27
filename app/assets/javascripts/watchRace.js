
function watchRace(wsUrl, initialInput) {
  "use strict";

  var ws = new WebSocket(wsUrl);
  var game = Elm.fullscreen(Elm.Main, { raceInput: initialInput });

  ws.onmessage = function(event) {
    game.ports.raceInput.send(JSON.parse(event.data));
  };

  function outputProxy(watcherOutput) {
    ws.send(JSON.stringify(watcherOutput));
  }

  ws.onopen = function() {
    game.ports.watcherOutput.subscribe(outputProxy);
  };

  ws.onclose = function() {
    game.ports.watcherOutput.unsubscribe(outputProxy);
  };

}
