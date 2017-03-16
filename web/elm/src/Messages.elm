module Messages exposing (..)

import Http
import Json.Encode as JE
import Model exposing (ContactList, Contact, SocketState)
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
    | UpdateSocketState SocketState
