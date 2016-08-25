module Contacts.Model exposing (..)

import Contact.Model as Contact


type alias Model =
    { entries : List Contact.Model
    , page_number : Int
    , total_entries : Int
    , total_pages : Int
    , search : String
    , error : String
    }


initialModel : Model
initialModel =
    { entries = []
    , page_number = 1
    , total_entries = 0
    , total_pages = 0
    , search = ""
    , error = ""
    }
