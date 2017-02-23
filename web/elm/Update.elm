module Update exposing (..)

import Commands exposing (fetch)
import Messages exposing (..)
import Model exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchResult (Ok response) ->
            { model | contactList = Success response } ! []

        FetchResult (Err error) ->
            { model | contactList = Failure "Something went wrong..." } ! []

        Paginate pageNumber ->
            model ! [ fetch pageNumber model.search ]

        HandleSearchInput value ->
            { model | search = value } ! []

        HandleFormSubmit ->
            model ! [ fetch 1 model.search ]
