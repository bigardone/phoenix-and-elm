effect module Phoenix where { command = MyCmd, subscription = MySub } exposing (connect, push)

{-| An Elm client for [Phoenix](http://www.phoenixframework.org) Channels.

This package makes it easy to connect to Phoenix Channels, but in a more declarative manner than the Phoenix Socket Javascript library. Simply provide a `Socket` and a list of `Channel`s you want to join and this library handles the tedious parts like opening a connection, joining channels, reconnecting after a network error and registering event handlers.


#Connect with Phoenix
@docs connect

# Push messages
@docs push
-}

import Json.Encode as Encode exposing (Value)
import WebSocket.LowLevel as WS
import Dict exposing (Dict)
import Task exposing (Task)
import Process
import Phoenix.Internal.Channel as InternalChannel exposing (InternalChannel)
import Phoenix.Internal.Helpers as Helpers exposing ((&>), (<&>))
import Phoenix.Internal.Message as Message exposing (Message)
import Phoenix.Internal.Socket as InternalSocket exposing (InternalSocket)
import Phoenix.Channel as Channel exposing (Channel)
import Phoenix.Socket as Socket exposing (Socket)
import Phoenix.Push as Push exposing (Push)


-- SUBSCRIPTIONS


type MySub msg
    = Connect (Socket msg) (List (Channel msg))


{-| Declare a socket you want to connect to and the channels you want to join. The effect manager will open the socket connection, join the channels. See `Phoenix.Socket` and `Phoenix.Channel` for more configuration and behaviour details.

    import Phoenix.Socket as Socket
    import Phoenix.Channel as Channel

    type Msg = NewMsg Value | ...

    socket =
        Socket.init "ws://localhost:4000/socket/websocket"

    channel =
        Channel.init "room:lobby"
            -- register a handler for messages
            -- with a "new_msg" event
            |> Channel.on "new_msg" NewMsg

    subscriptions model =
        connect socket [channel]

**Note**: An empty channel list keeps the socket connection open.
-}
connect : Socket msg -> List (Channel msg) -> Sub msg
connect socket channels =
    subscription (Connect socket channels)



-- COMMANDS


type MyCmd msg
    = Send Endpoint (Push msg)


{-| Pushes a `Push` message to a particular socket address. The address has to be the same as with which you initalized the `Socket` in the `connect` subscription.

    payload =
        Json.Encode.object [("msg", "Hello Phoenix")]

    message =
        Push.init "room:lobby" "new_msg"
            |> Push.withPayload payload

    push "ws://localhost:4000/socket/websocket" message


**Note**: The message will be queued until you successfully joined a channel to the topic of the message.
-}
push : String -> Push msg -> Cmd msg
push endpoint push_ =
    command (Send endpoint push_)


cmdMap : (a -> b) -> MyCmd a -> MyCmd b
cmdMap func cmd =
    case cmd of
        Send endpoint push_ ->
            Send endpoint (Push.map func push_)



-- SUB MAP


subMap : (a -> b) -> MySub a -> MySub b
subMap func sub =
    case sub of
        Connect socket channels ->
            Connect
                (socket |> Socket.map func)
                (channels |> List.map (Channel.map func))


type alias Message =
    Message.Message



-- INTERNALS


type alias State msg =
    { sockets : InternalSocketsDict msg
    , channels : InternalChannelsDict msg
    , selfCallbacks : Dict Ref (SelfCallback msg)
    , channelQueues : ChannelQueuesDict msg
    }


type alias InternalSocketsDict msg =
    Dict Endpoint (InternalSocket msg)


type alias InternalChannelsDict msg =
    Dict Endpoint (Dict Topic (InternalChannel msg))


type alias ChannelsDict msg =
    Dict Endpoint (Dict Topic (Channel msg))


type alias SubsDict msg =
    Dict Endpoint (EndpointSubsDict msg)


type alias EndpointSubsDict msg =
    Dict Topic (Dict Event (List (Callback msg)))


type alias ChannelQueuesDict msg =
    Dict Endpoint (Dict Topic (List ( Message, Maybe (SelfCallback msg) )))


type alias Callback msg =
    Value -> msg


type alias Endpoint =
    String


type alias Topic =
    String


type alias Event =
    String


type alias Ref =
    Int



-- INIT


init : Task Never (State msg)
init =
    Task.succeed (State Dict.empty Dict.empty Dict.empty Dict.empty)



-- HANDLE APP MESSAGES


onEffects :
    Platform.Router msg (Msg msg)
    -> List (MyCmd msg)
    -> List (MySub msg)
    -> State msg
    -> Task Never (State msg)
onEffects router cmds subs state =
    let
        definedSockets =
            buildSocketsDict subs

        definedChannels =
            buildChannelsDict subs Dict.empty

        updateState newState =
            let
                getNewChannels =
                    handleChannelsUpdate router definedChannels newState.channels

                getNewSockets =
                    handleSocketsUpdate router definedSockets newState.sockets
            in
                Task.map2 (\newSockets newChannels -> { newState | sockets = newSockets, channels = newChannels })
                    getNewSockets
                    getNewChannels
    in
        sendPushsHelp cmds state <&> \newState -> updateState newState



-- BUILD SOCKETS


buildSocketsDict : List (MySub msg) -> Dict String (Socket msg)
buildSocketsDict subs =
    let
        insert sub dict =
            case sub of
                Connect socket _ ->
                    Dict.insert socket.endpoint socket dict
    in
        List.foldl insert Dict.empty subs



-- BUILD CHANNELS


buildChannelsDict : List (MySub msg) -> InternalChannelsDict msg -> InternalChannelsDict msg
buildChannelsDict subs dict =
    case subs of
        [] ->
            dict

        (Connect { endpoint } channels) :: rest ->
            let
                internalChan chan =
                    (InternalChannel InternalChannel.Closed chan)

                build chan dict_ =
                    buildChannelsDict rest (Helpers.insertIn endpoint chan.topic (internalChan chan) dict_)
            in
                List.foldl build dict channels


sendPushsHelp : List (MyCmd msg) -> State msg -> Task x (State msg)
sendPushsHelp cmds state =
    case cmds of
        [] ->
            Task.succeed state

        (Send endpoint push) :: rest ->
            let
                message =
                    Message.fromPush push
            in
                pushSocket endpoint message (Just <| PushResponse push) state
                    <&> sendPushsHelp rest


handleSocketsUpdate : Platform.Router msg (Msg msg) -> Dict String (Socket msg) -> InternalSocketsDict msg -> Task Never (InternalSocketsDict msg)
handleSocketsUpdate router definedSockets stateSockets =
    let
        -- addedSocketsStep: endpoints where we have to open a new socket connection
        addedSocketsStep endpoint definedSocket taskChain =
            let
                socket =
                    (InternalSocket.internalSocket definedSocket)
            in
                taskChain
                    <&> \addedSockets ->
                            attemptOpen router 0 socket
                                <&> \pid ->
                                        Task.succeed (Dict.insert endpoint (InternalSocket.opening 0 pid socket) addedSockets)

        -- we update the authentication parameters
        retainedSocketsStep endpoint definedSocket stateSocket taskChain =
            taskChain |> Task.map (Dict.insert endpoint <| InternalSocket.update definedSocket stateSocket)

        removedSocketsStep endpoint stateSocket taskChain =
            InternalSocket.close stateSocket &> taskChain
    in
        Dict.merge addedSocketsStep retainedSocketsStep removedSocketsStep definedSockets stateSockets (Task.succeed Dict.empty)


handleChannelsUpdate : Platform.Router msg (Msg msg) -> InternalChannelsDict msg -> InternalChannelsDict msg -> Task Never (InternalChannelsDict msg)
handleChannelsUpdate router definedChannels internalChannels =
    let
        leftStep endpoint definedEndpointChannels getNewChannels =
            let
                sendJoin =
                    Dict.values definedEndpointChannels
                        |> List.foldl (\channel task -> task &> sendJoinChannel router endpoint channel)
                            (Task.succeed ())

                insert newChannels =
                    Task.succeed (Dict.insert endpoint definedEndpointChannels newChannels)
            in
                sendJoin &> getNewChannels <&> insert

        bothStep endpoint definedEndpointChannels stateEndpointChannels getNewChannels =
            let
                getEndpointChannels =
                    handleEndpointChannelsUpdate router endpoint definedEndpointChannels stateEndpointChannels
            in
                Task.map2 (\endpointChannels newChannels -> Dict.insert endpoint endpointChannels newChannels)
                    getEndpointChannels
                    getNewChannels

        rightStep endpoint stateEndpointChannels getNewChannels =
            let
                sendLeave =
                    Dict.values stateEndpointChannels
                        |> List.foldl (\channel task -> task &> sendLeaveChannel router endpoint channel)
                            (Task.succeed ())
            in
                sendLeave &> getNewChannels
    in
        Dict.merge leftStep bothStep rightStep definedChannels internalChannels (Task.succeed Dict.empty)


handleEndpointChannelsUpdate : Platform.Router msg (Msg msg) -> Endpoint -> Dict Topic (InternalChannel msg) -> Dict Topic (InternalChannel msg) -> Task Never (Dict Topic (InternalChannel msg))
handleEndpointChannelsUpdate router endpoint definedChannels stateChannels =
    let
        leftStep topic defined getNewChannels =
            (sendJoinChannel router endpoint defined) &> Task.map (Dict.insert topic defined) getNewChannels

        bothStep topic defined state getNewChannels =
            let
                channel =
                    state
                        |> InternalChannel.updatePayload defined.channel.payload
                        |> InternalChannel.updateOn defined.channel.on
            in
                Task.map (Dict.insert topic channel) getNewChannels

        rightStep topic state getNewChannels =
            (sendLeaveChannel router endpoint state) &> getNewChannels
    in
        Dict.merge leftStep bothStep rightStep definedChannels stateChannels (Task.succeed Dict.empty)


sendLeaveChannel : Platform.Router msg (Msg msg) -> Endpoint -> InternalChannel msg -> Task Never ()
sendLeaveChannel router endpoint internalChannel =
    case internalChannel.state of
        InternalChannel.Joined ->
            Platform.sendToSelf router (LeaveChannel endpoint internalChannel)

        _ ->
            Task.succeed ()


sendJoinChannel : Platform.Router msg (Msg msg) -> Endpoint -> InternalChannel msg -> Task Never ()
sendJoinChannel router endpoint internalChannel =
    Platform.sendToSelf router (JoinChannel endpoint internalChannel)



-- STATE UPDATE HELPERS


updateSocket : Endpoint -> InternalSocket msg -> State msg -> State msg
updateSocket endpoint socket state =
    { state | sockets = Dict.insert endpoint socket state.sockets }


updateChannels : InternalChannelsDict msg -> State msg -> State msg
updateChannels channels state =
    { state | channels = channels }


updateSelfCallbacks : Dict Ref (SelfCallback msg) -> State msg -> State msg
updateSelfCallbacks selfCallbacks state =
    { state | selfCallbacks = selfCallbacks }


removeChannelQueue : Endpoint -> Topic -> State msg -> State msg
removeChannelQueue endpoint topic state =
    { state | channelQueues = Helpers.removeIn endpoint topic state.channelQueues }


insertSocket : Endpoint -> InternalSocket msg -> State msg -> State msg
insertSocket endpoint socket state =
    { state
        | sockets = Dict.insert endpoint socket state.sockets
    }


insertSelfCallback : Ref -> Maybe (SelfCallback msg) -> State msg -> State msg
insertSelfCallback ref maybeSelfCb state =
    case maybeSelfCb of
        Nothing ->
            state

        Just selfCb ->
            { state
                | selfCallbacks = Dict.insert ref selfCb state.selfCallbacks
            }



-- HANDLE INTERN MESSAGES


type alias SelfCallback msg =
    Message -> Msg msg


type Msg msg
    = Receive Endpoint Message
    | Die String { code : Int, reason : String, wasClean : Bool }
    | GoodOpen String WS.WebSocket
    | BadOpen String WS.BadOpen
    | Register
    | JoinChannel Endpoint (InternalChannel msg)
    | LeaveChannel Endpoint (InternalChannel msg)
    | ChannelLeaveReply Endpoint (InternalChannel msg) Message
    | ChannelJoinReply Endpoint Topic InternalChannel.State Message
    | GoodJoin Endpoint Topic
    | SendHeartbeat Endpoint
    | PushResponse (Push msg) Message


onSelfMsg : Platform.Router msg (Msg msg) -> Msg msg -> State msg -> Task Never (State msg)
onSelfMsg router selfMsg state =
    case selfMsg of
        GoodOpen endpoint ws ->
            case InternalSocket.get endpoint state.sockets of
                Just internalSocket ->
                    let
                        _ =
                            if internalSocket.socket.debug then
                                Debug.log "WebSocket connected with " endpoint
                            else
                                endpoint

                        state_ =
                            insertSocket endpoint (InternalSocket.connected ws internalSocket) state
                    in
                        (heartbeat router endpoint state_)
                            <&> \newState ->
                                    rejoinAllChannels endpoint newState

                -- somehow the state is messed up
                Nothing ->
                    Task.succeed state

        BadOpen endpoint details ->
            case Dict.get endpoint state.sockets of
                Nothing ->
                    Task.succeed state

                Just internalSocket ->
                    let
                        _ =
                            if internalSocket.socket.debug then
                                Debug.log ("WebSocket couldn_t connect with " ++ endpoint) details
                            else
                                details

                        backoffIteration =
                            case internalSocket.connection of
                                InternalSocket.Opening n _ ->
                                    n + 1

                                _ ->
                                    0

                        backoff =
                            internalSocket.socket.reconnectTimer backoffIteration

                        newState pid =
                            (updateSocket endpoint (InternalSocket.opening backoffIteration pid internalSocket)) state
                    in
                        attemptOpen router backoff internalSocket
                            |> Task.map newState

        Die endpoint details ->
            case Dict.get endpoint state.sockets of
                Nothing ->
                    Task.succeed state

                Just ({ connection, socket } as internalSocket) ->
                    let
                        backoffIteration =
                            case connection of
                                InternalSocket.Opening n _ ->
                                    n + 1

                                _ ->
                                    0

                        backoff =
                            socket.reconnectTimer backoffIteration

                        -- update channels because of disconnect
                        getNewState =
                            handleChannelDisconnect router endpoint state

                        finalNewState pid =
                            Task.map (updateSocket endpoint (InternalSocket.opening backoffIteration pid internalSocket)) getNewState

                        notifyOnClose =
                            if InternalSocket.isOpening internalSocket then
                                Task.succeed ()
                            else
                                Maybe.map (\onClose -> Platform.sendToApp router (onClose details)) socket.onClose
                                    |> Maybe.withDefault (Task.succeed ())

                        notifyOnNormalClose =
                            -- see https://developer.mozilla.org/en-US/docs/Web/API/CloseEvent for error codes
                            if InternalSocket.isOpening internalSocket || details.code /= 1000 then
                                Task.succeed ()
                            else
                                Maybe.map (Platform.sendToApp router) socket.onNormalClose
                                    |> Maybe.withDefault (Task.succeed ())

                        notifyOnAbnormalClose =
                            -- see https://developer.mozilla.org/en-US/docs/Web/API/CloseEvent for error codes
                            if InternalSocket.isOpening internalSocket || details.code /= 1006 then
                                Task.succeed ()
                            else
                                Maybe.map (Platform.sendToApp router) socket.onAbnormalClose
                                    |> Maybe.withDefault (Task.succeed ())
                    in
                        notifyOnClose
                            &> notifyOnNormalClose
                            &> notifyOnAbnormalClose
                            &> attemptOpen router backoff internalSocket
                            |> Task.andThen finalNewState

        Receive endpoint message ->
            dispatchMessage router endpoint message state.channels
                &> ((handleSelfcallback router endpoint message state.selfCallbacks)
                        |> Task.map (\selfCbs -> updateSelfCallbacks selfCbs state)
                   )
                <&> handlePhoenixMessage router endpoint message

        ChannelJoinReply endpoint topic oldState message ->
            (handleChannelJoinReply router endpoint topic message oldState state.channels)
                |> Task.map (\newChannels -> updateChannels newChannels state)

        JoinChannel endpoint internalChannel ->
            case Dict.get endpoint state.sockets of
                Nothing ->
                    Task.succeed state

                Just internalSocket ->
                    case internalSocket.connection of
                        InternalSocket.Connected _ _ ->
                            pushSocket_ endpoint (InternalChannel.joinMessage internalChannel) (Just <| ChannelJoinReply endpoint internalChannel.channel.topic internalChannel.state) state

                        -- Nothing to do GoodOpen will handle the join
                        _ ->
                            Task.succeed state

        LeaveChannel endpoint internalChannel ->
            case Dict.get endpoint state.sockets of
                Nothing ->
                    Task.succeed state

                Just _ ->
                    case internalChannel.state of
                        InternalChannel.Joined ->
                            pushSocket_ endpoint (InternalChannel.leaveMessage internalChannel) (Just <| ChannelLeaveReply endpoint internalChannel) state

                        _ ->
                            Task.succeed state

        ChannelLeaveReply endpoint { channel } message ->
            case Helpers.decodeReplyPayload message.payload of
                Nothing ->
                    Task.succeed state

                Just reply ->
                    case reply of
                        Err error ->
                            case channel.onLeaveError of
                                Nothing ->
                                    Task.succeed state

                                Just onLeaveError ->
                                    Platform.sendToApp router (onLeaveError error) &> Task.succeed state

                        Ok ok ->
                            case channel.onLeave of
                                Nothing ->
                                    Task.succeed state

                                Just onLeave ->
                                    Platform.sendToApp router (onLeave ok) &> Task.succeed state

        SendHeartbeat endpoint ->
            (heartbeat router endpoint state)

        GoodJoin endpoint topic ->
            case Helpers.getIn endpoint topic state.channelQueues of
                Nothing ->
                    Task.succeed state

                Just queuedMessages ->
                    processQueue endpoint queuedMessages state
                        |> Task.map (removeChannelQueue endpoint topic)

        PushResponse push_ message ->
            case Helpers.decodeReplyPayload message.payload of
                Nothing ->
                    Task.succeed state

                Just reply ->
                    case reply of
                        Err error ->
                            case push_.onError of
                                Nothing ->
                                    Task.succeed state

                                Just onError ->
                                    Platform.sendToApp router (onError error) &> Task.succeed state

                        Ok ok ->
                            case push_.onOk of
                                Nothing ->
                                    Task.succeed state

                                Just onOk ->
                                    Platform.sendToApp router (onOk ok) &> Task.succeed state

        _ ->
            Task.succeed state


handleSelfcallback : Platform.Router msg (Msg msg) -> Endpoint -> Message -> Dict Ref (SelfCallback msg) -> Task x (Dict Ref (SelfCallback msg))
handleSelfcallback router endpoint message selfCallbacks =
    case message.ref of
        Nothing ->
            Task.succeed selfCallbacks

        Just ref ->
            case Dict.get ref selfCallbacks of
                Nothing ->
                    Task.succeed selfCallbacks

                Just selfCb ->
                    Platform.sendToSelf router (selfCb message)
                        &> Task.succeed (Dict.remove ref selfCallbacks)


processQueue : Endpoint -> List ( Message, Maybe (SelfCallback msg) ) -> State msg -> Task x (State msg)
processQueue endpoint messages state =
    case messages of
        [] ->
            Task.succeed state

        ( message, maybeSelfCb ) :: rest ->
            pushSocket endpoint message maybeSelfCb state
                <&> processQueue endpoint rest


handlePhoenixMessage : Platform.Router msg (Msg msg) -> Endpoint -> Message -> State msg -> Task x (State msg)
handlePhoenixMessage router endpoint message state =
    case message.event of
        "phx_error" ->
            case Helpers.getIn endpoint message.topic state.channels of
                Nothing ->
                    Task.succeed state

                Just internalChannel ->
                    let
                        newChannel =
                            InternalChannel.updateState InternalChannel.Errored internalChannel

                        sendToApp =
                            case internalChannel.channel.onError of
                                Nothing ->
                                    Task.succeed ()

                                Just onError ->
                                    Platform.sendToApp router onError
                    in
                        sendToApp &> sendJoinHelper endpoint [ newChannel ] state

        -- TODO do we have to do something here?
        "phx_close" ->
            Task.succeed state

        _ ->
            Task.succeed state


dispatchMessage : Platform.Router msg (Msg msg) -> Endpoint -> Message -> InternalChannelsDict msg -> Task x ()
dispatchMessage router endpoint message channels =
    case getEventCb endpoint message channels of
        Nothing ->
            Task.succeed ()

        Just cb ->
            Platform.sendToApp router (cb message.payload)


getEventCb : Endpoint -> Message -> InternalChannelsDict msg -> Maybe (Callback msg)
getEventCb endpoint message channels =
    case Helpers.getIn endpoint message.topic channels of
        Nothing ->
            Nothing

        Just { channel } ->
            Dict.get message.event channel.on


handleChannelJoinReply : Platform.Router msg (Msg msg) -> Endpoint -> Topic -> Message -> InternalChannel.State -> InternalChannelsDict msg -> Task x (InternalChannelsDict msg)
handleChannelJoinReply router endpoint topic message prevState channels =
    let
        maybeChannel =
            InternalChannel.get endpoint topic channels

        maybePayload =
            Helpers.decodeReplyPayload message.payload

        newChannels state =
            Task.succeed (InternalChannel.insertState endpoint topic state channels)

        handlePayload { channel } payload =
            case payload of
                Err response ->
                    case channel.onJoinError of
                        Nothing ->
                            newChannels InternalChannel.Errored

                        Just onError ->
                            Platform.sendToApp router (onError response) &> newChannels InternalChannel.Errored

                Ok response ->
                    let
                        join =
                            Platform.sendToSelf router (GoodJoin endpoint topic)
                                &> newChannels InternalChannel.Joined
                    in
                        case prevState of
                            InternalChannel.Disconnected ->
                                case channel.onRejoin of
                                    Nothing ->
                                        join

                                    Just onRejoin ->
                                        Platform.sendToApp router (onRejoin response) &> join

                            _ ->
                                case channel.onJoin of
                                    Nothing ->
                                        join

                                    Just onJoin ->
                                        Platform.sendToApp router (onJoin response) &> join
    in
        Maybe.map2 handlePayload maybeChannel maybePayload
            |> Maybe.withDefault (Task.succeed channels)


handleChannelDisconnect : Platform.Router msg (Msg msg) -> Endpoint -> State msg -> Task x (State msg)
handleChannelDisconnect router endpoint state =
    case Dict.get endpoint state.channels of
        Nothing ->
            Task.succeed state

        Just endpointChannels ->
            let
                notifyApp { state, channel } =
                    case state of
                        InternalChannel.Joined ->
                            case channel.onDisconnect of
                                Nothing ->
                                    Task.succeed ()

                                Just onDisconnect ->
                                    Platform.sendToApp router onDisconnect

                        _ ->
                            Task.succeed ()

                notify =
                    Dict.foldl (\_ channel task -> task &> notifyApp channel) (Task.succeed ()) endpointChannels

                updateChannel _ channel =
                    case channel.state of
                        InternalChannel.Errored ->
                            channel

                        _ ->
                            InternalChannel.updateState InternalChannel.Disconnected channel

                updatedEndpointChannels =
                    Dict.map updateChannel endpointChannels
            in
                notify
                    &> Task.succeed
                        ({ state
                            | channels = Dict.insert endpoint updatedEndpointChannels state.channels
                         }
                        )


heartbeat : Platform.Router msg (Msg msg) -> Endpoint -> State msg -> Task x (State msg)
heartbeat router endpoint state =
    case Dict.get endpoint state.sockets of
        Just { socket } ->
            if socket.withoutHeartbeat then
                Task.succeed state
            else
                (Process.spawn (Process.sleep socket.heartbeatIntervall &> (Platform.sendToSelf router (SendHeartbeat endpoint))))
                    &> pushSocket_ endpoint heartbeatMessage Nothing state

        Nothing ->
            Task.succeed state


heartbeatMessage : Message
heartbeatMessage =
    Message.init "phoenix" "heartbeat"


rejoinAllChannels : Endpoint -> State msg -> Task x (State msg)
rejoinAllChannels endpoint state =
    case Dict.get endpoint state.channels of
        Nothing ->
            Task.succeed state

        Just endpointChannels ->
            sendJoinHelper endpoint (Dict.values endpointChannels) state


sendJoinHelper : Endpoint -> List (InternalChannel msg) -> State msg -> Task x (State msg)
sendJoinHelper endpoint channels state =
    case channels of
        [] ->
            Task.succeed state

        internalChannel :: rest ->
            let
                selfCb =
                    ChannelJoinReply endpoint internalChannel.channel.topic internalChannel.state

                message =
                    InternalChannel.joinMessage internalChannel

                newChannel =
                    InternalChannel.updateState InternalChannel.Joining internalChannel

                newChannels =
                    Helpers.insertIn endpoint internalChannel.channel.topic newChannel state.channels
            in
                pushSocket_ endpoint message (Just selfCb) (updateChannels newChannels state)
                    <&> \newState -> sendJoinHelper endpoint rest newState



-- PUSH MESSAGES


{-| pushes a message to a certain socket. Ignores if the sending failes.
-}
pushSocket_ : Endpoint -> Message -> Maybe (SelfCallback msg) -> State msg -> Task x (State msg)
pushSocket_ endpoint message maybeSelfCb state =
    case Dict.get endpoint state.sockets of
        Nothing ->
            Task.succeed state

        Just socket ->
            InternalSocket.push message socket
                <&> \maybeRef ->
                        case maybeRef of
                            Nothing ->
                                Task.succeed state

                            Just ref ->
                                insertSocket endpoint (InternalSocket.increaseRef socket) state
                                    |> insertSelfCallback ref maybeSelfCb
                                    |> Task.succeed


{-| pushes a message to a certain socket. Queues the message if the channel is not joined.
-}
pushSocket : Endpoint -> Message -> Maybe (SelfCallback msg) -> State msg -> Task x (State msg)
pushSocket endpoint message selfCb state =
    let
        queuedState =
            Task.succeed
                { state
                    | channelQueues = Helpers.updateIn endpoint message.topic (Helpers.add ( message, selfCb )) state.channelQueues
                }

        afterSocketPush socket maybeRef =
            case maybeRef of
                Nothing ->
                    queuedState

                Just ref ->
                    insertSocket endpoint (InternalSocket.increaseRef socket) state
                        |> insertSelfCallback ref selfCb
                        |> Task.succeed
    in
        case Dict.get endpoint state.sockets of
            Nothing ->
                queuedState

            Just socket ->
                case InternalChannel.get endpoint message.topic state.channels of
                    Nothing ->
                        let
                            _ =
                                Debug.log "Queued message (no channel exists)" message
                        in
                            queuedState

                    Just channel ->
                        case channel.state of
                            InternalChannel.Joined ->
                                InternalSocket.push message socket
                                    <&> afterSocketPush socket

                            _ ->
                                let
                                    _ =
                                        Debug.log "Queued message (channel not joined)" message
                                in
                                    queuedState



-- OPENING WEBSOCKETS WITH EXPONENTIAL BACKOFF


attemptOpen : Platform.Router msg (Msg msg) -> Float -> InternalSocket msg -> Task x Process.Id
attemptOpen router backoff ({ connection, socket } as internalSocket) =
    let
        goodOpen ws =
            Platform.sendToSelf router (GoodOpen socket.endpoint ws)

        badOpen details =
            Platform.sendToSelf router (BadOpen socket.endpoint details)

        actuallyAttemptOpen =
            (open internalSocket router |> Task.andThen goodOpen)
                |> Task.onError badOpen
    in
        Process.spawn (after backoff &> actuallyAttemptOpen)


open : InternalSocket msg -> Platform.Router msg (Msg msg) -> Task WS.BadOpen WS.WebSocket
open socket router =
    let
        onMessage _ msg =
            case Message.decode msg of
                Ok message ->
                    Platform.sendToSelf router (Receive socket.socket.endpoint <| InternalSocket.debugLogMessage socket message)

                -- TODO proper error handling
                Err err ->
                    Task.succeed ()
    in
        InternalSocket.open socket
            { onMessage = onMessage
            , onClose = \details -> Platform.sendToSelf router (Die socket.socket.endpoint details)
            }


after : Float -> Task x ()
after backoff =
    if backoff < 1 then
        Task.succeed ()
    else
        Process.sleep backoff
