module Main exposing (..)

import Navigation
import View exposing (view)
import Model exposing (..)
import Update exposing (..)
import Types exposing (Msg(..))
import Routing exposing (Route)
import Routing exposing (..)


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    let
        currentRoute =
            Routing.parse location
    in
        urlUpdate currentRoute (initialModel currentRoute)


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program Never Model Msg
main =
    Navigation.program UrlChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
