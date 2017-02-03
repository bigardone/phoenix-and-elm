module Commands exposing (..)

import Http
import Decoders exposing (..)
import Contacts.Types exposing (Msg(..))
import Contact.Types exposing (Msg(..))


fetch : String -> Int -> Cmd Contacts.Types.Msg
fetch search page =
    let
        apiUrl =
            "/api/contacts?" ++ "search=" ++ search ++ "&page=" ++ (toString page)
    in
        Http.send FetchResult <| Http.get apiUrl contactsModelDecoder


fetchContact : Int -> Cmd Contact.Types.Msg
fetchContact id =
    let
        apiUrl =
            "/api/contacts/" ++ (toString id)
    in
        Http.send FetchContactResult <| Http.get apiUrl contactModelDecoder
