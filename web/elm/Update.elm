module Update exposing (..)

import Http
import Task exposing (Task)
import Types exposing (..)
import Model exposing (..)
import Decoders exposing (..)


init : ( Model, Cmd Msg )
init =
    ( initialModel, fetch initialModel )


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
