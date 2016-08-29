module Decoders exposing (..)

import Json.Decode as Decode exposing (succeed, int, string, float, list, Decoder, (:=), maybe, oneOf)
import Json.Decode.Extra exposing ((|:))
import Contacts.Model exposing (..)
import Contact.Model exposing (..)


contactDecoder : Decode.Decoder Contact.Model.Model
contactDecoder =
    succeed Contact.Model.Model
        |: (maybe ("id" := int))
        |: ("first_name" := string)
        |: ("last_name" := string)
        |: ("gender" := int)
        |: ("birth_date" := string)
        |: ("location" := string)
        |: ("phone_number" := string)
        |: ("email" := string)
        |: ("headline" := string)
        |: ("picture" := string)


modelDecoder : Decode.Decoder Contacts.Model.Model
modelDecoder =
    succeed Contacts.Model.Model
        |: ("entries" := (list contactDecoder))
        |: ("page_number" := int)
        |: ("total_entries" := int)
        |: ("total_pages" := int)
        |: (oneOf [ "search" := string, succeed "" ])
        |: (oneOf [ "error" := string, succeed "" ])
