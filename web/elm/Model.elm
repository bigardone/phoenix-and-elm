module Model exposing (..)

import Contact.Model as Contact exposing (..)
import ContactList.Model as ContactList exposing (ContactList)
import Routing


type alias Model =
    { contactList : ContactList
    , contact : Contact.Model
    , route : Routing.Route
    }


initialModel : Routing.Route -> Model
initialModel route =
    { contactList = ContactList.initialModel
    , contact = Contact.initialModel
    , route = route
    }
