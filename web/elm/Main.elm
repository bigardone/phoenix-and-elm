module Main exposing (..)

import Html.App as App
import View exposing (view)
import Model exposing (..)
import Update exposing (..)
import Types exposing (..)


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program Never
main =
    App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
