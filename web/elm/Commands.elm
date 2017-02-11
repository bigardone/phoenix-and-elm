module Commands exposing (..)

import Decoders exposing (..)
import Http
import Messages exposing (Msg(..))


fetch : String -> Int -> Cmd Msg
fetch search page =
    let
        apiUrl =
            "/api/contacts?" ++ "search=" ++ search ++ "&page=" ++ (toString page)
    in
        Http.send FetchResult <| Http.get apiUrl contactsModelDecoder
