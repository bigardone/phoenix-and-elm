module ContactList exposing (init, view, update, Msg)

import Html exposing (..)
import Html.Attributes exposing (class, id)
import Http
import Task exposing (Task)
import Contact exposing (view)
import Decoders exposing (modelDecoder)
import Models exposing (..)


-- MODEL


initialModel : Model
initialModel =
    { entries = []
    , page_number = 1
    , total_entries = 0
    , total_pages = 0
    , search = ""
    , error = ""
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel, fetch initialModel )



-- MESSAGES


type Msg
    = Paginate Int
    | Search String
    | FetchSucceed Model
    | FetchError Http.Error



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Paginate pageNumber ->
            model ! []

        Search search ->
            model ! []

        FetchSucceed newModel ->
            { model | entries = newModel.entries, error = "Epaaa" } ! []

        FetchError error ->
            { model | error = (toString error) } ! []


fetch : Model -> Cmd Msg
fetch model =
    Task.perform FetchError FetchSucceed (Http.get modelDecoder "http://localhost:4000/api/contacts")



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
            [ h1 [] [ text "Phoenix and Elm: A real use case" ]
            ]
        , div
            []
            [ listContacts model ]
        ]


listContacts : Model -> Html a
listContacts model =
    model.entries
        |> List.map Contact.view
        |> div [ class "cards-wrapper" ]
