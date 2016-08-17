module Contact exposing (Model, view)

import Html exposing (..)
import Html.Attributes exposing (..)


-- MODEL


type alias Model =
    { id : Int
    , first_name : String
    , last_name : String
    , gender : Int
    , birth_date : String
    , location : String
    , phone_number : String
    , email : String
    , headline : String
    , picture : String
    }



-- VIEW


view : a -> Html b
view model =
    div
        [ class "card male" ]
        [ div
            [ class "inner" ]
            [ header
                []
                [ div
                    [ class "avatar-wrapper" ]
                    [ img [ class "avatar" ] [] ]
                , div
                    [ class "info-wrapper" ]
                    [ h4 [] [ text "Full Name" ]
                    , ul
                        [ class "meta" ]
                        [ li
                            []
                            [ i [ class "fa fa-map-marker" ] []
                            , text "Location"
                            ]
                        , li
                            []
                            [ i [ class "fa fa-birthday-cake" ] []
                            , text "01-01-1977"
                            ]
                        ]
                    ]
                ]
            , div
                [ class "card-body" ]
                [ div
                    [ class "headline" ]
                    [ p [] [ text "Headline" ] ]
                , ul
                    [ class "contact-info" ]
                    [ li
                        []
                        [ i [ class "fa fa-phone" ] []
                        , text "555-55-555-55"
                        ]
                    , li
                        []
                        [ i [ class "fa fa-envelope" ] []
                        , text "john@doe.com"
                        ]
                    ]
                ]
            ]
        ]
