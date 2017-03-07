module Update exposing (..)

import Commands exposing (fetch)
import Messages exposing (..)
import Model exposing (..)
import Routing exposing (Route(..), parse)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchResult (Ok response) ->
            { model | contactList = Success response } ! []

        FetchResult (Err error) ->
            { model | contactList = Failure "Something went wrong..." } ! []

        Paginate pageNumber ->
            model ! [ fetch pageNumber model.search ]

        HandleSearchInput value ->
            { model | search = value } ! []

        HandleFormSubmit ->
            { model | contactList = Requesting } ! [ fetch 1 model.search ]

        ResetSearch ->
            { model | search = "" } ! [ fetch 1 "" ]

        UrlChange location ->
            let
                currentRoute =
                    parse location
            in
                urlUpdate { model | route = currentRoute }


urlUpdate : Model -> ( Model, Cmd Msg )
urlUpdate model =
    case model.route of
        HomeIndexRoute ->
            model ! [ fetch 1 "" ]

        _ ->
            model ! []
