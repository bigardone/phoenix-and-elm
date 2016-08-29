module Decoders exposing (..)

import Json.Decode as Decode exposing (succeed, int, string, float, list, Decoder, (:=), maybe, oneOf)
import Json.Decode.Extra exposing ((|:))
import Contacts.Model exposing (..)
import Contact.Model exposing (..)


contactDecoder : Decode.Decoder Contact.Model.Contact
contactDecoder =
    succeed Contact.Model.Contact
        |: ("id" := int)
        |: ("first_name" := string)
        |: ("last_name" := string)
        |: ("gender" := int)
        |: ("birth_date" := string)
        |: ("location" := string)
        |: ("phone_number" := string)
        |: ("email" := string)
        |: ("headline" := string)
        |: ("picture" := string)


contactModelDecoder : Decode.Decoder Contact.Model.Model
contactModelDecoder =
    succeed Contact.Model.Model
        |: (maybe ("contact" := contactDecoder))
        |: (maybe ("error" := string))


contactsModelDecoder : Decode.Decoder Contacts.Model.Model
contactsModelDecoder =
    succeed Contacts.Model.Model
        |: ("entries" := (list contactDecoder))
        |: ("page_number" := int)
        |: ("total_entries" := int)
        |: ("total_pages" := int)
        |: (oneOf [ "search" := string, succeed "" ])
        |: (oneOf [ "error" := string, succeed "" ])
