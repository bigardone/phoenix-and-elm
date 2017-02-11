module Main exposing (..)

import Commands exposing (fetch)
import Html
import Model exposing (..)
import Types exposing (Msg(..))
import Update exposing (..)
import View exposing (view)


init : ( Model, Cmd Msg )
init =
    initialModel ! [ fetch "" 1 ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
