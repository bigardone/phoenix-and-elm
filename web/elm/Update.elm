module Update exposing (..)

import Model exposing (..)
import Types exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchResult (Ok response) ->
            { model | contactList = response } ! []

        FetchResult (Err error) ->
            { model | error = Just (toString error) } ! []
