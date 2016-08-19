module Contacts.Update exposing (..)

import Contacts.Types exposing (..)
import Contacts.Model exposing (..)
import Commands exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Paginate pageNumber ->
            ( model, fetch model.search pageNumber )

        FormSubmit ->
            ( model, fetch model.search 1 )

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
                ( newModel, fetch newModel.search 1 )
