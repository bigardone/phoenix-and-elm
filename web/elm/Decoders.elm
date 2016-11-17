module Decoders exposing (..)

import Json.Decode as Decode exposing (..)
import Json.Decode.Extra exposing ((|:))
import Contacts.Model exposing (..)
import Contact.Model exposing (..)


contactDecoder : Decode.Decoder Contact.Model.Contact
contactDecoder =
    succeed Contact.Model.Contact
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


contactModelDecoder : Decode.Decoder Contact.Model.Model
contactModelDecoder =
    succeed Contact.Model.Model
        |: (maybe (field "contact" contactDecoder))
        |: (maybe (field "error" string))


contactsModelDecoder : Decode.Decoder Contacts.Model.Model
contactsModelDecoder =
    succeed Contacts.Model.Model
        |: (field "entries" (list contactDecoder))
        |: (field "page_number" int)
        |: (field "total_entries" int)
        |: (field "total_pages" int)
        |: (oneOf [ field "search" string, succeed "" ])
        |: (oneOf [ field "error" string, succeed "" ])
