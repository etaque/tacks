const Elm = window.Elm;


function readData(id, el) {
  const value = el.getElementById(id).textContent.trim();
  return value && JSON.parse(value);
}

function dims() {
  return [
    window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth,
    window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight
  ];
}

// let ws = null;
// let wsUrl = null;

const appSetup = readData('appSetup', document);
appSetup.dims = dims();

const app = Elm.Main.fullscreen(appSetup);

app.ports.setPath.subscribe(path => {
  history.pushState({}, '', path);
  app.ports.pathUpdates.send(path);
});

window.onpopstate = () => {
  app.ports.pathUpdates.send(document.location.pathname);
};

// const sendMessage = (msg) => {
//   if (msg && ws && ws.readyState === WebSocket.OPEN) {
//     ws.send(JSON.stringify(msg));
//   }
// };


// game.ports.playerOutput.subscribe((output) => {
//   if (output) sendMessage({ tag: 'PlayerInput', playerInput: output });
// });

// game.ports.serverActions.subscribe((msg) => {
//   sendMessage(msg);
// });

// // game.ports.chatOutput.subscribe((output) => {
// //   sendMessage({ tag: 'NewMessage', content: output });
// // });

// game.ports.chatScrollDown.subscribe(() => {
//   const el = document.getElementsByClassName('messages')[0];
//   if (el) {
//     requestAnimationFrame(() => {
//       el.scrollTop = el.scrollHeight;
//     });
//   }
// });

// game.ports.title.subscribe(title => {
//   document.title = title;
// });

// game.ports.activeTrack.subscribe((id) => {
//   if (ws) {
//     ws.close();
//   }

//   if (id) {
//     wsUrl = window.jsRoutes.controllers.WebSockets.trackPlayer(id).webSocketURL();
//     ws = new WebSocket(wsUrl);

//     ws.onmessage = (event) => {
//       const frame = JSON.parse(event.data);
//       if (frame.tag === 'RaceUpdate') {
//         game.ports.raceInput.send(frame.raceUpdate);
//       } else {
//         game.ports.gameActionsInput.send(frame);
//       }
//     };

//     ws.onclose = () => game.ports.raceInput.send(null);
//   } else {
//     game.ports.raceInput.send(null);
//   }
// });

document.addEventListener('trix-change', (event) => {
  event.target.inputElement.dispatchEvent(new Event('input', { bubbles: true }));
});
