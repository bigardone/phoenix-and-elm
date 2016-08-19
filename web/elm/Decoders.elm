module Decoders exposing (modelDecoder)

import Json.Decode exposing (int, string, float, Decoder)
import Json.Decode.Pipeline exposing (decode, required, optional)
import Contacts.Model exposing (..)


contactDecoder : Json.Decode.Decoder Contact
contactDecoder =
    decode Contact
        |> required "id" Json.Decode.int
        |> required "first_name" Json.Decode.string
        |> required "last_name" Json.Decode.string
        |> required "gender" Json.Decode.int
        |> required "birth_date" Json.Decode.string
        |> required "location" Json.Decode.string
        |> required "phone_number" Json.Decode.string
        |> required "email" Json.Decode.string
        |> required "headline" Json.Decode.string
        |> required "picture" Json.Decode.string


modelDecoder : Json.Decode.Decoder Model
modelDecoder =
    decode Model
        |> required "entries" (Json.Decode.list contactDecoder)
        |> required "page_number" Json.Decode.int
        |> required "total_entries" Json.Decode.int
        |> required "total_pages" Json.Decode.int
        |> optional "search" Json.Decode.string ""
        |> optional "error" Json.Decode.string ""
