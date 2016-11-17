module Contacts.Types exposing (..)

import Contacts.Model exposing (..)
import Http


type Msg
    = NoOp
    | Paginate Int
    | SearchInput String
    | FormSubmit
    | FetchResult (Result Http.Error Model)
    | Reset
    | ShowContacts
    | ShowContact Int
