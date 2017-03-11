module Common.View exposing (warningMessage, backLink)

import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (..)
import Messages exposing (Msg(..))
import Routing exposing (Route)


warningMessage : String -> String -> Html Msg -> Html Msg
warningMessage iconClasses message content =
    div
        [ class "warning" ]
        [ span
            [ class "fa-stack" ]
            [ i [ class iconClasses ] [] ]
        , h4
            []
            [ text message ]
        , content
        ]


backLink : Route -> Html Msg
backLink route =
    a
        [ onClick <| NavigateTo route ]
        [ text "← Back to contact list" ]
