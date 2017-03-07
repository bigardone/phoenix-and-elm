module Messages exposing (..)

import Http
import Model exposing (ContactList)
import Navigation


type Msg
    = FetchResult (Result Http.Error ContactList)
    | Paginate Int
    | HandleSearchInput String
    | HandleFormSubmit
    | ResetSearch
    | UrlChange Navigation.Location
