module Commands exposing (..)

import Decoders exposing (contactListDecoder)
import Http
import Messages exposing (Msg(..))


fetch : Int -> Cmd Msg
fetch page =
    let
        apiUrl =
            "/api/contacts?page=" ++ (toString page)

        request =
            Http.get apiUrl contactListDecoder
    in
        Http.send FetchResult request
