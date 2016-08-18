module ContactList exposing (init, view, update, Msg)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput, onSubmit)
import Http
import String
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
    | SearchInput String
    | FormSubmit
    | FetchSucceed Model
    | FetchError Http.Error
    | Reset



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Paginate pageNumber ->
            ( model, fetch { model | page_number = pageNumber } )

        FormSubmit ->
            ( model, fetch { model | page_number = 1 } )

        SearchInput search ->
            { model | search = search } ! []

        FetchSucceed newModel ->
            newModel ! []

        FetchError error ->
            { model | error = (toString error) } ! []

        Reset ->
            let
                newModel =
                    { model | search = "" }
            in
                ( newModel, fetch newModel )


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
        [ id "home_index" ]
        [ header
            []
            [ h1 [] [ text "Phoenix and Elm: A real use case" ] ]
        , filter model
        , pagination model.total_pages model.page_number
        , div
            []
            [ listContacts model ]
        , pagination model.total_pages model.page_number
        ]


filter : Model -> Html Msg
filter model =
    let
        contactWord =
            if model.total_entries == 1 then
                "contact"
            else
                "contacts"

        headerText =
            (toString model.total_entries) ++ " " ++ contactWord ++ " found"
    in
        div
            [ class "filter-wrapper" ]
            [ div
                [ class "overview-wrapper" ]
                [ h3 [] [ text headerText ] ]
            , div
                [ class "form-wrapper" ]
                [ Html.form
                    [ onSubmit FormSubmit ]
                    [ resetButton model "reset"
                    , input
                        [ type' "search"
                        , placeholder "Search contacts..."
                        , onInput SearchInput
                        , value model.search
                        ]
                        []
                    ]
                ]
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
                [ classes
                , onClick (Paginate page)
                ]
                []
            ]


listContacts : Model -> Html Msg
listContacts model =
    if model.total_entries > 0 then
        model.entries
            |> List.map Contact.view
            |> div [ class "cards-wrapper" ]
    else
        let
            classes =
                classList [ ( "warning", True ), ( "hidden", String.length model.search == 0 ) ]
        in
            div
                [ classes ]
                [ span
                    [ class "fa-stack" ]
                    [ i [ class "fa fa-meh-o fa-stack-2x" ] [] ]
                , h4 [] [ text "No contacts found..." ]
                , resetButton model "btn"
                ]


resetButton : Model -> String -> Html Msg
resetButton model className =
    let
        hide =
            (String.length model.search) < 1

        classes =
            classList [ ( className, True ), ( "hidden", hide ) ]
    in
        a
            [ classes
            , onClick Reset
            ]
            [ text "Reset search" ]
