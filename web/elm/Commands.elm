module Commands exposing (..)

import Decoders exposing (..)
import Http
import Types exposing (Msg(..))


fetch : String -> Int -> Cmd Types.Msg
fetch search page =
    let
        apiUrl =
            "/api/contacts?" ++ "search=" ++ search ++ "&page=" ++ (toString page)
    in
        Http.send FetchResult <| Http.get apiUrl contactsModelDecoder
