module Routing exposing (..)

import Navigation
import UrlParser exposing (..)


type Route
    = HomeIndexRoute
    | NotFoundRoute


toPath : Route -> String
toPath route =
    case route of
        HomeIndexRoute ->
            "/"

        NotFoundRoute ->
            "/not-found"


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map HomeIndexRoute <| s "" ]


parse : Navigation.Location -> Route
parse location =
    case UrlParser.parsePath matchers location of
        Just route ->
            route

        Nothing ->
            NotFoundRoute
