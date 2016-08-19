module View exposing (..)

import Html exposing (..)
import Html.App
import Types exposing (..)
import Model exposing (..)
import Routing exposing (Route(..))
import Contacts.View exposing (..)


view : Model -> Html Msg
view model =
    div []
        [ page model ]


page : Model -> Html Msg
page model =
    case model.route of
        ContactsRoute ->
            Html.App.map ContactsMsg (indexView model)

        ContactRoute id ->
            showContactView model id

        NotFoundRoute ->
            notFoundView


showContactView : Model -> Int -> Html Msg
showContactView model id =
    let
        maybeContact =
            model.entries
                |> List.filter (\c -> c.id == id)
                |> List.head
    in
        case maybeContact of
            Just contact ->
                Html.App.map ContactsMsg (contactView contact)

            Nothing ->
                notFoundView


notFoundView : Html Msg
notFoundView =
    div []
        [ text "Not found" ]
