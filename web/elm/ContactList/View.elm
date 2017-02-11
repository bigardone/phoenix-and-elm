module ContactList.View exposing (indexView)

import Contact.View exposing (contactView)
import Html exposing (..)
import Html.Attributes exposing (..)
import Messages exposing (..)
import Model exposing (..)


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
            |> List.map contactView
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
