module Phoenix.Internal.Channel exposing (..)

import Dict exposing (Dict)
import Json.Decode as Decode exposing (Value)
import Phoenix.Internal.Helpers as Helpers
import Phoenix.Internal.Message as Message exposing (Message)
import Phoenix.Channel as Channel


{-| The current channel state. This is completely handled by the effect manager.
-}
type State
    = Closed
    | Joining
    | Joined
    | Errored
    | Disconnected


type alias InternalChannel msg =
    { state : State, channel : Channel.Channel msg }


type alias Endpoint =
    String


type alias Topic =
    String


type alias Event =
    String


map : (a -> b) -> InternalChannel a -> InternalChannel b
map func { state, channel } =
    InternalChannel state (Channel.map func channel)


joinMessage : InternalChannel msg -> Message
joinMessage { channel } =
    let
        base =
            Message.init channel.topic "phx_join"
    in
        case channel.payload of
            Nothing ->
                base

            Just payload_ ->
                Message.payload payload_ base


leaveMessage : InternalChannel msg -> Message
leaveMessage { channel } =
    Message.init channel.topic "phx_leave"



-- GETTER, SETTER, UPDATER


type alias InternalChannelsDict msg =
    Dict Endpoint (Dict Topic (InternalChannel msg))


get : Endpoint -> Topic -> InternalChannelsDict msg -> Maybe (InternalChannel msg)
get endpoint topic channelsDict =
    Helpers.getIn endpoint topic channelsDict


getState : Endpoint -> Topic -> InternalChannelsDict msg -> Maybe State
getState endpoint topic channelsDict =
    get endpoint topic channelsDict
        |> Maybe.map (\{ state } -> state)


{-|  Inserts the state, identity if channel for given endpoint topic doesn_t exist
-}
insertState : Endpoint -> Topic -> State -> InternalChannelsDict msg -> InternalChannelsDict msg
insertState endpoint topic state dict =
    let
        update =
            Maybe.map (updateState state)
    in
        Helpers.updateIn endpoint topic update dict


updateState : State -> InternalChannel msg -> InternalChannel msg
updateState state internalChannel =
    if internalChannel.channel.debug then
        let
            _ =
                case ( state, internalChannel.state ) of
                    ( Closed, Closed ) ->
                        state

                    ( Joining, Joining ) ->
                        state

                    ( Joined, Joined ) ->
                        state

                    ( Errored, Errored ) ->
                        state

                    ( Disconnected, Disconnected ) ->
                        state

                    _ ->
                        Debug.log ("Channel \"" ++ internalChannel.channel.topic ++ "\"") state
        in
            (InternalChannel state internalChannel.channel)
    else
        (InternalChannel state internalChannel.channel)


updatePayload : Maybe Value -> InternalChannel msg -> InternalChannel msg
updatePayload payload { state, channel } =
    InternalChannel state { channel | payload = payload }


updateOn : Dict Topic (Value -> msg) -> InternalChannel msg -> InternalChannel msg
updateOn on { state, channel } =
    InternalChannel state { channel | on = on }
