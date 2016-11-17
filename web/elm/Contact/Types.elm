module Contact.Types exposing (..)

import Contact.Model exposing (..)
import Http


type Msg
    = FetchContact Int
    | FetchContactResult (Result Http.Error Model)
