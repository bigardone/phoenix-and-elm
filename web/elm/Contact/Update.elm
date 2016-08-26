module Contact.Update exposing (..)

import Contact.Types exposing (..)
import Contact.Model exposing (..)
import Commands exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ShowContact id ->
            ( model, showContact id )

        ShowContactSucceed newModel ->
            newModel ! []

        ShowContactError error ->
            model ! []
