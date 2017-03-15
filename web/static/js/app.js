import Elm from './main';

const elmDiv = document.querySelector('#elm_target');

if (elmDiv) {
  const socketUrl = window.socketUrl;

  Elm.Main.embed(elmDiv, { socketUrl });
}
