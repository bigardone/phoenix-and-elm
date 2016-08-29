module Commands exposing (..)

import Http
import Task exposing (Task)
import Decoders exposing (..)
import Contacts.Types exposing (Msg(..))
import Contact.Types exposing (Msg(..))


fetch : String -> Int -> Cmd Contacts.Types.Msg
fetch search page =
    let
        apiUrl =
            Http.url "/api/contacts"
                [ ( "search", search )
                , ( "page", (toString page) )
                ]
    in
        Task.perform FetchError FetchSucceed (Http.get contactsModelDecoder apiUrl)


fetchContact : Int -> Cmd Contact.Types.Msg
fetchContact id =
    let
        apiUrl =
            Http.url ("/api/contacts/" ++ (toString id)) []
    in
        Task.perform FetchContactError FetchContactSucceed (Http.get contactModelDecoder apiUrl)
