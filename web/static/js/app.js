import Elm from './main';

const elmDiv = document.querySelector('#elm-target');

if (elmDiv) {
  Elm.Main.embed(elmDiv);
}