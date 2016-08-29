module Contact.Update exposing (..)

import Contact.Types exposing (..)
import Contact.Model exposing (..)
import Commands exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchContact id ->
            case id of
                Just contactId ->
                    ( model, fetchContact contactId )

                Nothing ->
                    model ! []

        FetchContactSucceed newModel ->
            newModel ! []

        FetchContactError error ->
            model ! []
