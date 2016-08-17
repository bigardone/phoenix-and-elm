module Models exposing (..)


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


type alias Model =
    { entries : List Contact
    , page_number : Int
    , total_entries : Int
    , total_pages : Int
    , search : String
    , error : String
    }
