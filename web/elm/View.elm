module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (id)
import Html.App
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
            Html.App.map ContactsMsg (indexView model.contacts)

        ContactRoute id ->
            showContactView model id

        NotFoundRoute ->
            notFoundView


showContactView : Model -> Int -> Html Msg
showContactView model id =
    let
        maybeContact =
            model.contacts.entries
                |> List.filter (\c -> c.id == id)
                |> List.head
    in
        case maybeContact of
            Just contact ->
                Html.App.map ContactsMsg (Contact.View.view contact)

            Nothing ->
                notFoundView


notFoundView : Html Msg
notFoundView =
    div []
        [ text "Not found" ]
