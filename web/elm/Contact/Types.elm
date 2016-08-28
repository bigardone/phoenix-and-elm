module Contact.Types exposing (..)

import Contact.Model exposing (..)
import Http


type Msg
    = FetchContact Int
    | FetchContactSucceed Model
    | FetchContactError Http.Error
