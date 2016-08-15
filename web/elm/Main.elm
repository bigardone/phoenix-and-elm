module Main exposing (..)

import Html exposing (..)
import Html.App as App


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



-- messages


type Msg
    = Page Int
    | Search String



-- update


update : Msg -> Model -> Model
update msg model =
    case msg of
        Page pageNumber ->
            model

        Search search ->
            model



-- subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- view


view : Model -> Html Msg
view model =
    div
        []
        [ text "" ]


main : Program Never
main =
    App.beginnerProgram
        { model = initialModel
        , view = view
        , update = update
        }
