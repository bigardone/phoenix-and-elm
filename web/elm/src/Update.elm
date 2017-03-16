module Update exposing (..)

import Commands exposing (fetch, fetchContact)
import Decoders exposing (..)
import Json.Decode as JD
import Messages exposing (..)
import Model exposing (..)
import Navigation
import Routing exposing (Route(..), parse, toPath)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchSuccess raw ->
            case JD.decodeValue contactListDecoder raw of
                Ok payload ->
                    { model | contactList = Success payload } ! []

                Err err ->
                    { model | contactList = Failure "Error while decoding contact list" } ! []

        FetchError raw ->
            { model | contactList = Failure "Error while fetching contact list" } ! []

        Paginate pageNumber ->
            model ! [ fetch model.flags.socketUrl pageNumber model.search ]

        HandleSearchInput value ->
            { model | search = value } ! []

        HandleFormSubmit ->
            { model | contactList = Requesting } ! [ fetch model.flags.socketUrl 1 model.search ]

        ResetSearch ->
            { model | search = "" } ! [ fetch model.flags.socketUrl 1 "" ]

        UrlChange location ->
            let
                currentRoute =
                    parse location
            in
                urlUpdate { model | route = currentRoute }

        NavigateTo route ->
            model ! [ Navigation.newUrl <| toPath route ]

        FetchContactSuccess raw ->
            case JD.decodeValue contactDecoder raw of
                Ok payload ->
                    { model | contact = Success payload } ! []

                Err err ->
                    { model | contact = Failure "Error while decoding contact" } ! []

        FetchContactError raw ->
            { model | contact = Failure "Contact not found" } ! []

        UpdateSocketState newState ->
            { model | socketState = newState } ! []


urlUpdate : Model -> ( Model, Cmd Msg )
urlUpdate model =
    case model.route of
        HomeIndexRoute ->
            case model.contactList of
                NotRequested ->
                    model ! [ fetch model.flags.socketUrl 1 "" ]

                _ ->
                    model ! []

        ShowContactRoute id ->
            { model | contact = Requesting } ! [ fetchContact model.flags.socketUrl id ]

        _ ->
            model ! []
