module Routing exposing (..)

import Navigation
import UrlParser exposing (..)


type Route
    = ContactsRoute
    | ContactRoute Int
    | NotFoundRoute


toPath : Route -> String
toPath route =
    case route of
        ContactsRoute ->
            "/"

        ContactRoute id ->
            "/contacts/" ++ toString id

        NotFoundRoute ->
            "/not-found"


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map ContactsRoute <| s ""
        , map ContactRoute <| s "contacts" </> int
        ]


parse : Navigation.Location -> Route
parse location =
    case UrlParser.parsePath matchers location of
        Just route ->
            route

        Nothing ->
            NotFoundRoute
