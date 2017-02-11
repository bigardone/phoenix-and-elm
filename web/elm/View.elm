module View exposing (..)

import ContactList.View exposing (indexView)
import Html exposing (..)
import Html.Attributes exposing (..)
import Model exposing (..)
import Types exposing (..)


view : Model -> Html Msg
view model =
    section
        []
        [ headerView
        , div []
            [ indexView model ]
        ]


headerView : Html Msg
headerView =
    header
        []
        [ h1
            []
            [ text "Phoenix and Elm: A real use case" ]
        ]
