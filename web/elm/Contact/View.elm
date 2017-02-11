module Contact.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model exposing (..)
import Types exposing (..)


contactView : Contact -> Html Msg
contactView model =
    let
        classes =
            classList
                [ ( "card", True )
                , ( "male", model.gender == 0 )
                , ( "female", model.gender == 1 )
                ]

        fullName =
            model.first_name ++ " " ++ model.last_name
    in
        div
            [ classes ]
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
                            [ text fullName ]
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
