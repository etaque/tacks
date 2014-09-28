
function mountRace(wsUrl, initialInput) {
  "use strict";

  var ws = new WebSocket(wsUrl);
  var game = Elm.fullscreen(Elm.Main, { raceInput: initialInput });

  var started = false;
  var previousData = {};

  ws.onmessage = function(event) {
    var data = JSON.parse(event.data);
    if (data.startTime) {
      if (!started && data.now < data.startTime) {
        document.title = util.timer(data.startTime - data.now);
      } else {
        if (!started) {
          started = true;
          document.title = "Race started!";
        }
      }
    } else {
      if (!previousData.opponents || data.opponents.length != previousData.opponents.length) {
        document.title = "(" + (data.opponents.length + 1) + ") Waiting...";
      }
    }
    game.ports.raceInput.send(data);
    previousData = data;
  };

  ws.onopen = function() {
    game.ports.playerOutput.subscribe(function(state) {
      ws.send(JSON.stringify(state));
    });
  };
}
