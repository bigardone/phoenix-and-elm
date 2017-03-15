module Phoenix.Internal.Message exposing (..)

import Json.Decode as JD exposing (Value)
import Json.Encode as JE
import Phoenix.Push as Push exposing (Push)


type alias Message =
    { topic : String
    , event : String
    , payload : Value
    , ref : Maybe Int
    }


type alias Topic =
    String


type alias Event =
    String


type alias Ref =
    Int


init : Topic -> Event -> Message
init topic event =
    Message topic event (JE.object []) Nothing


payload : Value -> Message -> Message
payload payload_ message =
    { message | payload = payload_ }


ref : Ref -> Message -> Message
ref ref_ message =
    { message | ref = Just ref_ }


fromPush : Push msg -> Message
fromPush push =
    init push.topic push.event
        |> payload push.payload


encode : Message -> String
encode { topic, event, payload, ref } =
    JE.object
        [ ( "topic", JE.string topic )
        , ( "event", JE.string event )
        , ( "ref", Maybe.map (JE.int) ref |> (Maybe.withDefault JE.null) )
        , ( "payload", payload )
        ]
        |> JE.encode 0


decode : String -> Result String Message
decode msg =
    let
        decoder =
            JD.map4 Message
                (JD.field "topic" JD.string)
                (JD.field "event" JD.string)
                (JD.field "payload" JD.value)
                (JD.field "ref" (JD.oneOf [ JD.map Just JD.int, JD.null Nothing ]))
    in
        JD.decodeString decoder msg
