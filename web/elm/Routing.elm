module Routing exposing (..)

import String
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


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ format ContactsRoute (s "")
        , format ContactRoute (s "contacts" </> int)
        ]


hashParser : Navigation.Location -> Result String Route
hashParser location =
    location.pathname
        |> String.dropLeft 1
        |> parse identity routeParser


parser : Navigation.Parser (Result String Route)
parser =
    Navigation.makeParser hashParser


routeFromResult : Result String Route -> Route
routeFromResult result =
    case result of
        Ok route ->
            route

        Err string ->
            NotFoundRoute
