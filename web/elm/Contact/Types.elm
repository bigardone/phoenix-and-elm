module Contact.Types exposing (..)

import Contact.Model exposing (..)
import Http


type Msg
    = ShowContact Int
    | ShowContactSucceed Model
    | ShowContactError Http.Error
