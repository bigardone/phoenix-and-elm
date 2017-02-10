module Contact.Update exposing (..)

import Commands exposing (..)
import Contact.Types exposing (..)
import Model exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchContact id ->
            model ! [ fetchContact id ]

        FetchContactResult (Ok response) ->
            { model | contact = response.contact } ! []

        FetchContactResult (Err response) ->
            { model | error = Just "Something went wrong" } ! []
