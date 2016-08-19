module Model exposing (..)

import Contacts.Model exposing (..)
import Routing


type alias Model =
    { contacts : Contacts.Model.Model
    , route : Routing.Route
    }


initialModel : Routing.Route -> Model
initialModel route =
    { contacts = Contacts.Model.initialModel
    , route = route
    }
