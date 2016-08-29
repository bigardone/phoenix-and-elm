module Contact.Model exposing (..)


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
    { contact : Maybe Contact
    , error : Maybe String
    }


initialModel : Model
initialModel =
    { contact = Nothing
    , error = Nothing
    }
