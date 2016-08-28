module Contact.Model exposing (..)


type alias Model =
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


initialModel : Model
initialModel =
    { id = -1
    , first_name = ""
    , last_name = ""
    , gender = 0
    , birth_date = ""
    , location = ""
    , phone_number = ""
    , email = ""
    , headline = ""
    , picture = ""
    }
