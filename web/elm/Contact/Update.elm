module Contact.Update exposing (..)

import Contact.Types exposing (..)
import Contact.Model exposing (..)
import Commands exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchContact id ->
            model ! [ fetchContact id ]

        FetchContactResult (Ok newModel) ->
            newModel ! []

        FetchContactResult (Err error) ->
            { model | error = Just (toString error) } ! []
