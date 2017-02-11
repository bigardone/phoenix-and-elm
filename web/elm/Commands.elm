module Commands exposing (..)

import Decoders exposing (contactListDecoder)
import Http
import Messages exposing (Msg(..))


fetch : Cmd Msg
fetch =
    let
        apiUrl =
            "/api/contacts"

        request =
            Http.get apiUrl contactListDecoder
    in
        Http.send FetchResult request
