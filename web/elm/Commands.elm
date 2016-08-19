module Commands exposing (..)

import Http
import Task exposing (Task)
import Decoders exposing (..)
import Contacts.Types exposing (..)


fetch : String -> Int -> Cmd Msg
fetch search page =
    Task.perform FetchError FetchSucceed (Http.get modelDecoder (apiUrl search page))


apiUrl : String -> Int -> String
apiUrl search page =
    Http.url "http://localhost:4000/api/contacts"
        [ ( "search", search )
        , ( "page", (toString page) )
        ]
