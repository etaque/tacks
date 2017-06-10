const Elm = window.Elm;

function readData(id, el) {
  const value = el.getElementById(id).textContent.trim();
  return value && JSON.parse(value);
}

function windowSize() {
  return {
    width: window.innerWidth ||
      document.documentElement.clientWidth ||
      document.body.clientWidth,
    height: window.innerHeight ||
      document.documentElement.clientHeight ||
      document.body.clientHeight
  };
}

function notify(msg) {
  const options = {};

  if (!("Notification" in window)) {
    console.log("This browser does not support desktop notification");
  } else if (Notification.permission === "granted") {
    new Notification(msg, options);
  } else if (Notification.permission !== "denied") {
    Notification.requestPermission(function(permission) {
      if (permission === "granted") {
        new Notification(msg, options);
      }
    });
  }
}

const appSetup = readData("appSetup", document);
appSetup.size = windowSize();
appSetup.control =
  window.localStorage && window.localStorage.getItem("deviceControl");

const app = Elm.Main.fullscreen(appSetup);

app.ports.setFocus.subscribe(id => {
  document.getElementById(id).focus();
});

app.ports.setBlur.subscribe(id => {
  setTimeout(() => document.getElementById(id).blur());
});

app.ports.scrollToBottom.subscribe(id => {
  requestAnimationFrame(() => {
    const el = document.getElementById(id);
    if (el) {
      el.scrollTop = el.scrollHeight;
    }
  });
});

app.ports.saveControl.subscribe(deviceControl => {
  if (window.localStorage) {
    window.localStorage.setItem("deviceControl", deviceControl);
  }
});

app.ports.notify.subscribe(msg => {
  notify(msg);
});

document.addEventListener("trix-change", event => {
  event.target.inputElement.dispatchEvent(
    new Event("input", { bubbles: true })
  );
});

// if(window.DeviceOrientationEvent) {
//   window.addEventListener('deviceorientation', function(event) {
//     // alpha : compas
//     // beta : avant/arrière
//     // gamma : gauche/droite
//     if (event.alpha && event.beta && event.gamma) {
//       app.ports.deviceOrientation.send(event);
//     }
//   }, true);
// }

// hide ui on mobile
window.scrollTo(0, 1);
