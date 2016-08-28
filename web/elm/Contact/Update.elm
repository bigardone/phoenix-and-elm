module Contact.Update exposing (..)

import Contact.Types exposing (..)
import Contact.Model exposing (..)
import Commands exposing (..)


update : Msg -> Model -> ( Maybe Model, Cmd Msg )
update msg model =
    case msg of
        FetchContact id ->
            ( Just model, fetchContact id )

        FetchContactSucceed newModel ->
            Just newModel ! []

        FetchContactError error ->
            Nothing ! []
