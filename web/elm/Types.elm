module Types exposing (..)

import Contact.Types exposing (..)
import ContactList.Types exposing (..)
import Navigation


type Msg
    = UrlChange Navigation.Location
    | ContactListMsg ContactList.Types.Msg
    | ContactMsg Contact.Types.Msg
