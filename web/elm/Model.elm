module Model exposing (..)


type alias Model =
    { contactList : ContactList
    , error : Maybe String
    , search : String
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


initialModel : Model
initialModel =
    { contactList = initialContatcList
    , error = Nothing
    , search = ""
    }
