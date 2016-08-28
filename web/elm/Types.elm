module Types exposing (..)

import Contacts.Types exposing (..)
import Contact.Types exposing (..)


type Msg
    = ContactsMsg Contacts.Types.Msg
    | ContactMsg Contact.Types.Msg
