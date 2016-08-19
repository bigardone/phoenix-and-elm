module Types exposing (..)

import Model exposing (..)
import Http


type Msg
    = Paginate Int
    | SearchInput String
    | FormSubmit
    | FetchSucceed Model
    | FetchError Http.Error
    | Reset
