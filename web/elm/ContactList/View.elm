module ContactList.View exposing (..)

import Contact.View exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model exposing (..)
import String
import Types exposing (..)


indexView : Model -> Html Msg
indexView model =
    div
        [ id "home_index" ]
        [ div
            []
            [ contactsList model ]
        ]


contactsList : Model -> Html Msg
contactsList model =
    if model.contactList.total_entries > 0 then
        model.contactList.entries
            |> List.map Contact.View.contactView
            |> div [ class "cards-wrapper" ]
    else
        let
            classes =
                classList
                    [ ( "warning", True ) ]
        in
            div
                [ classes ]
                [ span
                    [ class "fa-stack" ]
                    [ i [ class "fa fa-meh-o fa-stack-2x" ] [] ]
                , h4
                    []
                    [ text "No contacts found..." ]
                ]
