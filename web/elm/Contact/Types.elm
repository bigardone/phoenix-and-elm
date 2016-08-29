module Contact.Types exposing (..)

import Contact.Model exposing (..)
import Http


type Msg
    = FetchContact (Maybe Int)
    | FetchContactSucceed Model
    | FetchContactError Http.Error
