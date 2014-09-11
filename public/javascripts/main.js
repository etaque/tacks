function formatTimer(millis) {
  var c = Math.round(millis / 1000);
  var m = Math.floor(c / 60);
  var s = c % 60;
  return "" + m + "' " + s + "\"";
}

document.addEventListener('DOMContentLoaded', function(){
  var changeName = document.getElementById('change-name');

  if (changeName) {
    changeName.addEventListener('click', function(e) {
      e.preventDefault();
      var newName = window.prompt("New name?", this.dataset.name);

      var data = new FormData();
      data.append("name", newName);

      var request = new XMLHttpRequest();
      request.open('POST', this.dataset.url, true);
      request.send(data);

      request.onload = function() {
        console.log(this.status, this.response);
        location.reload();
      };
    });
  }
});

