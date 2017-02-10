module Decoders exposing (..)

import Contact.Model exposing (..)
import ContactList.Model exposing (ContactList)
import Json.Decode as JD exposing (..)
import Json.Decode.Extra exposing ((|:))


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


contactModelDecoder : JD.Decoder Contact.Model.Model
contactModelDecoder =
    succeed
        Contact.Model.Model
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
        |: (oneOf [ field "search" string, succeed "" ])
        |: (oneOf [ field "error" string, succeed "" ])
