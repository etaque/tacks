var routes = require('./routes');
var Messages = require('./messages');

function notifications() {

  function notifyEvent(event) {
    var title = Messages("notifications.events." + event.key + ".title");
    var body = Messages.apply(null, ["notifications.events." + event.key + ".body"].concat(event.params));

    new Notification(title, {
      body: body,
      icon: "/assets/favicon-32x32.png"
    });
  }

  if ('Notification' in window) {

    Notification.requestPermission(function() {
      var ws;
      var url = routes.WebSockets.notifications().webSocketURL();

      function createWebSocket() {

        ws = new WebSocket(url);

        ws.onmessage = function (msg) {
          var event = JSON.parse(msg.data);
          notifyEvent(event);
        };

        ws.onclose = function() {
          console.log("Notifications WebSocket closed, will try to reconnect in 10s...", url);

          setTimeout(function () {
            createWebSocket();
          }, 10*1000);
        };
      }

      createWebSocket();
    });
  }

}

module.exports = notifications;
