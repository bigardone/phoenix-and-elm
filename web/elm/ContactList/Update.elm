module ContactList.Update exposing (..)

import Commands exposing (..)
import ContactList.Model exposing (ContactList)
import ContactList.Types exposing (..)
import Navigation
import Routing exposing (toPath, Route(..))


update : Msg -> ContactList -> ( ContactList, Cmd Msg )
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

        FetchResult (Ok newModel) ->
            newModel ! []

        FetchResult (Err error) ->
            { model | error = (toString error) } ! []

        Reset ->
            let
                newModel =
                    { model | search = "" }
            in
                ( newModel, fetch newModel.search 1 )

        ShowContacts ->
            ( model, Navigation.newUrl (toPath ContactsRoute) )

        ShowContact id ->
            ( model, Navigation.newUrl (toPath (ContactRoute id)) )
