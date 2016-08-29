module Contact.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Contact.Model exposing (..)
import Contacts.Types exposing (..)


view : Model -> Html Msg
view model =
    case model.id of
        Nothing ->
            div [] []

        Just contactId ->
            let
                classes =
                    classList [ ( "person-detail", True ), ( "male", model.gender == 0 ), ( "female", model.gender == 1 ) ]
            in
                div
                    [ id "contacts_show" ]
                    [ header []
                        [ h3 []
                            [ text "Person detail" ]
                        ]
                    , a
                        [ onClick ShowContacts ]
                        [ text "← Back to people list" ]
                    , div
                        [ classes ]
                        [ contactView model ]
                    ]


contactView : Model -> Html Msg
contactView model =
    case model.id of
        Nothing ->
            div [] []

        Just contactId ->
            let
                classes =
                    classList [ ( "card", True ), ( "male", model.gender == 0 ), ( "female", model.gender == 1 ) ]
            in
                div
                    [ classes ]
                    [ div
                        [ class "inner" ]
                        [ header
                            []
                            [ div
                                [ class "avatar-wrapper" ]
                                [ a [ onClick (ShowContact contactId) ]
                                    [ img
                                        [ class "avatar"
                                        , src model.picture
                                        ]
                                        []
                                    ]
                                ]
                            , div
                                [ class "info-wrapper" ]
                                [ h4 [] [ text (full_name model) ]
                                , ul
                                    [ class "meta" ]
                                    [ li
                                        []
                                        [ i [ class "fa fa-map-marker" ] []
                                        , text model.location
                                        ]
                                    , li
                                        []
                                        [ i [ class "fa fa-birthday-cake" ] []
                                        , text model.birth_date
                                        ]
                                    ]
                                ]
                            ]
                        , div
                            [ class "card-body" ]
                            [ div
                                [ class "headline" ]
                                [ p [] [ text model.headline ] ]
                            , ul
                                [ class "contact-info" ]
                                [ li
                                    []
                                    [ i [ class "fa fa-phone" ] []
                                    , text model.phone_number
                                    ]
                                , li
                                    []
                                    [ i [ class "fa fa-envelope" ] []
                                    , text model.email
                                    ]
                                ]
                            ]
                        ]
                    ]


full_name : Model -> String
full_name model =
    model.first_name ++ " " ++ model.last_name
