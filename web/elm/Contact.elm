module Contact exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Models exposing (..)


-- VIEW


view : Contact -> Html b
view model =
    div
        [ class "card male" ]
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


full_name : Contact -> String
full_name model =
    model.first_name ++ " " ++ model.last_name
