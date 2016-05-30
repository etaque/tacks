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

const appSetup = readData('appSetup', document);
appSetup.dims = dims();

const app = Elm.Main.fullscreen(appSetup);

app.ports.setFocus.subscribe(id => {
  document.getElementById(id).focus();
});

app.ports.setBlur.subscribe(id => {
  setTimeout(() => document.getElementById(id).blur());;
});

app.ports.scrollToBottom.subscribe(id => {
  requestAnimationFrame(() => {
    const el = document.getElementById(id);
    if (el) {
      el.scrollTop = el.scrollHeight;
    }
  });
});

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

document.addEventListener('trix-change', (event) => {
  event.target.inputElement.dispatchEvent(new Event('input', { bubbles: true }));
});
