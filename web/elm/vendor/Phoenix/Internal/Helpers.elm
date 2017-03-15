module Phoenix.Internal.Helpers exposing (..)

import Json.Decode as Decode exposing (Value)
import Dict exposing (Dict)
import Task exposing (Task)


getIn : comparable -> comparable_ -> Dict comparable (Dict comparable_ value) -> Maybe value
getIn a b dict =
    Dict.get a dict
        |> Maybe.andThen (Dict.get b)


updateIn : comparable -> comparable_ -> (Maybe value -> Maybe value) -> Dict comparable (Dict comparable_ value) -> Dict comparable (Dict comparable_ value)
updateIn a b update dict =
    let
        update_ maybeDict =
            let
                dict_ =
                    Dict.update b update (Maybe.withDefault Dict.empty maybeDict)
            in
                if Dict.isEmpty dict_ then
                    Nothing
                else
                    Just dict_
    in
        Dict.update a update_ dict


insertIn : comparable -> comparable_ -> value -> Dict comparable (Dict comparable_ value) -> Dict comparable (Dict comparable_ value)
insertIn a b value dict =
    let
        update_ maybeValue =
            case maybeValue of
                Nothing ->
                    Just (Dict.singleton b value)

                Just dict_ ->
                    Just (Dict.insert b value dict_)
    in
        Dict.update a update_ dict


removeIn : comparable -> comparable_ -> Dict comparable (Dict comparable_ value) -> Dict comparable (Dict comparable_ value)
removeIn a b dict =
    let
        remove maybeDict_ =
            case maybeDict_ of
                Nothing ->
                    Nothing

                Just dict_ ->
                    let
                        newDict =
                            Dict.remove b dict_
                    in
                        if Dict.isEmpty newDict then
                            Nothing
                        else
                            Just newDict
    in
        Dict.update a remove dict


add : a -> Maybe (List a) -> Maybe (List a)
add value maybeList =
    case maybeList of
        Nothing ->
            Just [ value ]

        Just list ->
            Just (value :: list)


decodeReplyPayload : Value -> Maybe (Result Value Value)
decodeReplyPayload value =
    let
        result =
            Decode.decodeValue ((Decode.field "status" Decode.string) |> Decode.andThen statusInfo)
                value
    in
        case result of
            Err err ->
                let
                    _ =
                        Debug.log err
                in
                    Nothing

            Ok payload ->
                Just payload


statusInfo : String -> Decode.Decoder (Result Value Value)
statusInfo status =
    case status of
        "ok" ->
            Decode.map Ok (Decode.field "response" Decode.value)

        "error" ->
            Decode.map Err (Decode.field "response" Decode.value)

        _ ->
            Decode.fail (status ++ " is a not supported status")


(&>) : Task b a -> Task b c -> Task b c
(&>) t1 t2 =
    Task.andThen (\_ -> t2) t1


(<&>) : Task b a -> (a -> Task b c) -> Task b c
(<&>) x f =
    Task.andThen f x
