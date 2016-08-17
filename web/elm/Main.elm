module Main exposing (..)

import Html.App as App
import ContactList exposing (init, view, update, Msg)
import Models exposing (..)


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
