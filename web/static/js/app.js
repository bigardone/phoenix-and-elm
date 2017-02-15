import Elm from './main';

const elmDiv = document.querySelector('#elm_target');

if (elmDiv) {
  Elm.Main.embed(elmDiv);
}
