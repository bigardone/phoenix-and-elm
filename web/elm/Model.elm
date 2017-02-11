module Model exposing (..)

import Routing exposing (Route)


type alias Model =
    { contactList : ContactList
    , contact : Maybe Contact
    , route : Route
    , search : String
    , error : Maybe String
    }


type alias ContactList =
    { entries : List Contact
    , page_number : Int
    , total_entries : Int
    , total_pages : Int
    }


type alias Contact =
    { id : Int
    , first_name : String
    , last_name : String
    , gender : Int
    , birth_date : String
    , location : String
    , phone_number : String
    , email : String
    , headline : String
    , picture : String
    }


initialContatcList : ContactList
initialContatcList =
    { entries = []
    , page_number = 1
    , total_entries = 0
    , total_pages = 0
    }


initialModel : Routing.Route -> Model
initialModel route =
    { contactList = initialContatcList
    , contact = Nothing
    , route = route
    , search = ""
    , error = Nothing
    }
