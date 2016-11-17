module Types exposing (..)

import Navigation
import Contacts.Types exposing (..)
import Contact.Types exposing (..)


type Msg
    = UrlChange Navigation.Location
    | ContactsMsg Contacts.Types.Msg
    | ContactMsg Contact.Types.Msg
