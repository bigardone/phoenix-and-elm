module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App as App
import Http
import Task exposing (Task)
import Json.Decode as Decode
import Contact exposing (Model, view)


-- MODEL


type alias Model =
    { entries : List Contact.Model
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



-- MESSAGES


type Msg
    = NoOp
    | Paginate Int
    | Search String



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        Paginate pageNumber ->
            ( model, Cmd.none )

        Search search ->
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


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
        |> List.map Contact.view
        |> div [ class "cards-wrapper" ]


main : Program Never
main =
    App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
