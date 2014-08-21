function formatTimer(now, startTime) {
  var c = Math.round((startTime - now) / 1000);
  var m = Math.floor(c / 60);
  var s = c % 60;
  return "" + m + "' " + s + "\"";
}