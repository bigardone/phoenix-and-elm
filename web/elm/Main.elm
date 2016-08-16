module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App as App
import Http
import Task exposing (Task)
import Json.Decode as Decode


-- model


type alias Contact =
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


type alias Model =
    { entries : List Contact
    , page_number : Int
    , total_entries : Int
    , total_pages : Int
    , search : String
    }


initialModel : Model
initialModel =
    { entries = []
    , page_number = 1
    , total_entries = 0
    , total_pages = 0
    , search = ""
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )



-- messages


type Msg
    = NoOp
    | Paginate Int
    | Search String



-- update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        Paginate pageNumber ->
            ( model, Cmd.none )

        Search search ->
            ( model, Cmd.none )



-- subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- view


view : Model -> Html Msg
view model =
    section
        []
        [ header
            []
            [ h1 [] [ text "Phoenix and Elm: A real use case" ] ]
        , div
            []
            [ cardsList model ]
        ]


cardsList : Model -> Html a
cardsList model =
    [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ]
        |> List.map renderCards
        |> div [ class "cards-wrapper" ]


renderCards : Int -> Html a
renderCards model =
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


main : Program Never
main =
    App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
