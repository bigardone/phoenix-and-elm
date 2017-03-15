module Main exposing (..)

import Messages exposing (Msg(..))
import Model exposing (..)
import Navigation
import Routing exposing (parse)
import Update exposing (..)
import View exposing (view)


init : Flags -> Navigation.Location -> ( Model, Cmd Msg )
init flags location =
    let
        currentRoute =
            parse location

        model =
            initialModel flags currentRoute
    in
        urlUpdate model


main : Program Flags Model Msg
main =
    Navigation.programWithFlags UrlChange
        { init = init
        , view = view
        , update = update
        , subscriptions = always <| Sub.none
        }
