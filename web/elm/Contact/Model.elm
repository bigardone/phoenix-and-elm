module Contact.Model exposing (..)


type alias Model =
    { id : Maybe Int
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
    { id = Nothing
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
