module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Types exposing (..)
import Model exposing (..)
import Routing exposing (Route(..))
import Contacts.View exposing (..)
import Contact.View exposing (..)


view : Model -> Html Msg
view model =
    section
        []
        [ headerView
        , div []
            [ page model ]
        ]


headerView : Html Msg
headerView =
    header
        []
        [ h1 [] [ text "Phoenix and Elm: A real use case" ] ]


page : Model -> Html Msg
page model =
    case model.route of
        ContactsRoute ->
            Html.map ContactsMsg (indexView model.contacts)

        ContactRoute id ->
            Html.map ContactsMsg (Contact.View.view model.contact)

        NotFoundRoute ->
            notFoundView


notFoundView : Html Msg
notFoundView =
    div
        [ id "error_index" ]
        [ div
            [ class "warning" ]
            [ span
                [ class "fa-stack" ]
                [ i [ class "fa fa-meh-o fa-stack-2x" ] [] ]
            , h4 [] [ text "404" ]
            ]
        ]
