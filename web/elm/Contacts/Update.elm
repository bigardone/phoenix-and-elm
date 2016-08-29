module Contacts.Update exposing (..)

import Navigation
import Contacts.Types exposing (..)
import Contacts.Model exposing (..)
import Commands exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

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

        ShowContacts ->
            ( model, Navigation.newUrl "#" )

        ShowContact id ->
            ( model, Navigation.newUrl ("#contacts/" ++ (toString id)) )
