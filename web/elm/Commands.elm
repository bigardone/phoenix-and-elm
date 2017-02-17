module Commands exposing (..)

import Decoders exposing (contactListDecoder)
import Http
import Messages exposing (Msg(..))


fetch : Int -> String -> Cmd Msg
fetch page search =
    let
        apiUrl =
            "/api/contacts?page=" ++ (toString page) ++ "&search=" ++ search

        request =
            Http.get apiUrl contactListDecoder
    in
        Http.send FetchResult request
