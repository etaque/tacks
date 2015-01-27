var routes = require('./routes');
var Messages = require('./messages');

function notifications() {

  if ('Notification' in window) {

    Notification.requestPermission(function() {
      var ws = new WebSocket(routes.WebSockets.notifications().webSocketURL());

      ws.onmessage = function (msg) {
        var event = JSON.parse(msg.data);
        var title = Messages("notifications.events." + event.key + ".title");
        var body = Messages.apply(null, ["notifications.events." + event.key + ".body"].concat(event.params));

        new Notification(title, {
          body: body,
          icon: "/assets/favicon-32x32.png"
        });
      };
    });
  }

}

module.exports = notifications;
