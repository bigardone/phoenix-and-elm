module Update exposing (..)

import Commands exposing (fetch)
import Messages exposing (..)
import Model exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchResult (Ok response) ->
            { model | contactList = response } ! []

        FetchResult (Err error) ->
            { model | error = Just "Something went wrong..." } ! []

        Paginate pageNumber ->
            model ! [ fetch pageNumber ]
