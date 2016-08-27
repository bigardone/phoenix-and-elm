module Contact.Update exposing (..)

import Contact.Types exposing (..)
import Contact.Model exposing (..)
import Commands exposing (..)


update : Msg -> Model -> ( Maybe Model, Cmd Msg )
update msg model =
    case msg of
        ShowContact id ->
            ( Just model, showContact id )

        ShowContactSucceed newModel ->
            Just newModel ! []

        ShowContactError error ->
            Nothing ! []
