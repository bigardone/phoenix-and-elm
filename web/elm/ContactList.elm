module ContactList exposing (init, view, update, Msg)

import Html exposing (..)
import Html.Attributes exposing (class, id, href, classList)
import Html.Events exposing (onClick)
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
            ( model, fetch { model | page_number = pageNumber } )

        Search search ->
            model ! []

        FetchSucceed newModel ->
            newModel ! []

        FetchError error ->
            { model | error = (toString error) } ! []


fetch : Model -> Cmd Msg
fetch model =
    Task.perform FetchError FetchSucceed (Http.get modelDecoder (apiUrl model))


apiUrl : Model -> String
apiUrl model =
    Http.url "http://localhost:4000/api/contacts"
        [ ( "search", model.search )
        , ( "page", (toString model.page_number) )
        ]



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
        , pagination model.total_pages model.page_number
        , div
            []
            [ listContacts model ]
        , pagination model.total_pages model.page_number
        ]


pagination : Int -> Int -> Html Msg
pagination totalPages pageNumber =
    [1..totalPages]
        |> List.map (paginationLink pageNumber)
        |> ul [ class "pagination" ]


paginationLink : Int -> Int -> Html Msg
paginationLink currentPage page =
    let
        classes =
            classList [ ( "active", currentPage == page ) ]
    in
        li
            []
            [ a
                [ href "#"
                , classes
                , onClick (Paginate page)
                ]
                []
            ]


listContacts : Model -> Html a
listContacts model =
    model.entries
        |> List.map Contact.view
        |> div [ class "cards-wrapper" ]
