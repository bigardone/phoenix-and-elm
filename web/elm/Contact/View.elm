module Contact.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Contact.Model exposing (..)
import Contacts.Types exposing (..)


view : Model -> Html Msg
view model =
    case ( model.contact, model.error ) of
        ( Nothing, Just error ) ->
            errorView error

        ( Just contact, Nothing ) ->
            let
                classes =
                    classList
                        [ ( "person-detail", True )
                        , ( "male", contact.gender == 0 )
                        , ( "female", contact.gender == 1 )
                        ]
            in
                div
                    [ id "contacts_show" ]
                    [ header []
                        [ h3
                            []
                            [ text "Person detail" ]
                        ]
                    , a
                        [ onClick ShowContacts ]
                        [ text "← Back to people list" ]
                    , div
                        [ classes ]
                        [ contactView False contact ]
                    ]

        ( _, _ ) ->
            div [] []


contactView : Bool -> Contact -> Html Msg
contactView clickable model =
    let
        classes =
            classList
                [ ( "card", True )
                , ( "clickable", clickable )
                , ( "male", model.gender == 0 )
                , ( "female", model.gender == 1 )
                ]

        headerClick =
            case clickable of
                True ->
                    ShowContact model.id

                False ->
                    NoOp
    in
        div
            [ classes
            , onClick headerClick
            ]
            [ div
                [ class "inner" ]
                [ header
                    []
                    [ div
                        [ class "avatar-wrapper" ]
                        [ img
                            [ class "avatar"
                            , src model.picture
                            ]
                            []
                        ]
                    , div
                        [ class "info-wrapper" ]
                        [ h4
                            []
                            [ text (full_name model) ]
                        , ul
                            [ class "meta" ]
                            [ li
                                []
                                [ i
                                    [ class "fa fa-map-marker" ]
                                    []
                                , text model.location
                                ]
                            , li
                                []
                                [ i
                                    [ class "fa fa-birthday-cake" ]
                                    []
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
                            [ i
                                [ class "fa fa-phone" ]
                                []
                            , text model.phone_number
                            ]
                        , li
                            []
                            [ i
                                [ class "fa fa-envelope" ]
                                []
                            , text model.email
                            ]
                        ]
                    ]
                ]
            ]


errorView : String -> Html Msg
errorView error =
    div
        [ id "error_index" ]
        [ div
            [ class "warning" ]
            [ span
                [ class "fa-stack" ]
                [ i
                    [ class "fa fa-meh-o fa-stack-2x" ]
                    []
                ]
            , h4
                []
                [ text error ]
            , a
                [ onClick ShowContacts ]
                [ text "← Back to people list" ]
            ]
        ]


full_name : Contact -> String
full_name model =
    model.first_name ++ " " ++ model.last_name
