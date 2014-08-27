function formatTimer(millis) {
  var c = Math.round(millis / 1000);
  var m = Math.floor(c / 60);
  var s = c % 60;
  return "" + m + "' " + s + "\"";
}