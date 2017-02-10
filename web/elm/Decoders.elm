module Decoders exposing (..)

import Json.Decode as JD exposing (..)
import Json.Decode.Extra exposing ((|:))
import Model exposing (..)


type alias ContactResponse =
    { contact : Maybe Contact
    , error : Maybe String
    }


contactDecoder : JD.Decoder Contact
contactDecoder =
    succeed
        Contact
        |: (field "id" int)
        |: (field "first_name" string)
        |: (field "last_name" string)
        |: (field "gender" int)
        |: (field "birth_date" string)
        |: (field "location" string)
        |: (field "phone_number" string)
        |: (field "email" string)
        |: (field "headline" string)
        |: (field "picture" string)


contactModelDecoder : JD.Decoder ContactResponse
contactModelDecoder =
    succeed
        ContactResponse
        |: (maybe (field "contact" contactDecoder))
        |: (maybe (field "error" string))


contactsModelDecoder : JD.Decoder ContactList
contactsModelDecoder =
    succeed
        ContactList
        |: (field "entries" (list contactDecoder))
        |: (field "page_number" int)
        |: (field "total_entries" int)
        |: (field "total_pages" int)
