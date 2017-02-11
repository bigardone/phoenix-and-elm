module Messages exposing (..)

import Http
import Model exposing (ContactList)


type Msg
    = FetchResult (Result Http.Error ContactList)
