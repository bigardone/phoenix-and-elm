module Model exposing (..)

import Contacts.Model exposing (..)
import Contact.Model exposing (..)
import Routing


type alias Model =
    { contacts : Contacts.Model.Model
    , contact : Contact.Model.Model
    , route : Routing.Route
    }


initialModel : Routing.Route -> Model
initialModel route =
    { contacts = Contacts.Model.initialModel
    , contact = Contact.Model.initialModel
    , route = route
    }
