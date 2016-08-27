module Model exposing (..)

import Contacts.Model exposing (..)
import Contact.Model exposing (..)
import Routing


type alias Model =
    { contacts : Contacts.Model.Model
    , contact : Maybe Contact.Model.Model
    , route : Routing.Route
    }


initialModel : Routing.Route -> Model
initialModel route =
    { contacts = Contacts.Model.initialModel
    , contact = Nothing
    , route = route
    }
