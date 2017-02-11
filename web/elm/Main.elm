module Main exposing (..)

import Commands exposing (fetch)
import Html
import Messages exposing (Msg(..))
import Model exposing (..)
import Update exposing (..)
import View exposing (view)


init : ( Model, Cmd Msg )
init =
    initialModel ! [ fetch ]


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = always <| Sub.none
        }
