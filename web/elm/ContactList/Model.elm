module ContactList.Model exposing (..)

import Contact.Model exposing (Contact)


type alias ContactList =
    { entries : List Contact
    , page_number : Int
    , total_entries : Int
    , total_pages : Int
    , search : String
    , error : String
    }


initialModel : ContactList
initialModel =
    { entries = []
    , page_number = 1
    , total_entries = 0
    , total_pages = 0
    , search = ""
    , error = ""
    }
