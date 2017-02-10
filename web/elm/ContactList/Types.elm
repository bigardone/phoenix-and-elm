module ContactList.Types exposing (..)

import ContactList.Model exposing (ContactList)
import Http


type Msg
    = NoOp
    | Paginate Int
    | SearchInput String
    | FormSubmit
    | FetchResult (Result Http.Error ContactList)
    | Reset
    | ShowContacts
    | ShowContact Int
