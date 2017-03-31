module Messages exposing (..)

import Json.Encode as JE
import Navigation
import Routing exposing (Route)


type Msg
    = FetchSuccess JE.Value
    | FetchError JE.Value
    | Paginate Int
    | HandleSearchInput String
    | HandleFormSubmit
    | ResetSearch
    | UrlChange Navigation.Location
    | NavigateTo Route
    | FetchContactSuccess JE.Value
    | FetchContactError JE.Value
