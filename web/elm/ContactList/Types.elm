module ContactList.Types exposing (..)

import Http
import Model exposing (ContactList)


type Msg
    = NoOp
    | Paginate Int
    | SearchInput String
    | FormSubmit
    | FetchResult (Result Http.Error ContactList)
    | Reset
    | ShowContacts
    | ShowContact Int
