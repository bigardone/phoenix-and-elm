module Commands exposing (..)

import Contact.Types exposing (Msg(..))
import ContactList.Types exposing (Msg(..))
import Decoders exposing (..)
import Http


fetch : String -> Int -> Cmd ContactList.Types.Msg
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
