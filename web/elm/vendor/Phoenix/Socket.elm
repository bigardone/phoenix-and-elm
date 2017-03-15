module Phoenix.Socket exposing (Socket, init, heartbeatIntervallSeconds, withoutHeartbeat, reconnectTimer, withParams, withDebug, onClose, onAbnormalClose, onNormalClose, map)

{-| A socket declares to which endpoint a socket connection should be established.

# Definition
@docs Socket

# Helpers
@docs init, withParams, heartbeatIntervallSeconds, withoutHeartbeat, reconnectTimer, withDebug, onAbnormalClose, onNormalClose, onClose, map
-}

import Time exposing (Time)


{-| Representation of a Socket connection
-}
type alias Socket msg =
    PhoenixSocket msg


type alias PhoenixSocket msg =
    { endpoint : String
    , params : List ( String, String )
    , heartbeatIntervall : Time
    , withoutHeartbeat : Bool
    , reconnectTimer : Int -> Float
    , debug : Bool
    , onClose : Maybe ({ code : Int, reason : String, wasClean : Bool } -> msg)
    , onAbnormalClose : Maybe msg
    , onNormalClose : Maybe msg
    }


{-| Initialize a Socket connection with an endpoint.

    init "ws://localhost:4000/socket/websocket"
-}
init : String -> Socket msg
init endpoint =
    { endpoint = endpoint
    , params = []
    , heartbeatIntervall = 30 * Time.second
    , withoutHeartbeat = False
    , reconnectTimer = defaultReconnectTimer
    , debug = False
    , onClose = Nothing
    , onAbnormalClose = Nothing
    , onNormalClose = Nothing
    }


{-| Attach parameters to the socket connecton. You can use this to do authentication on the socket level. This will be the first argument (as a map) in your `connect/2` callback on the server.

    init "ws://localhost:4000/socket/websocket"
        |> withParams [("token", "GYMXZwXzKFzfxyGntVkYt7uAJnscVnFJ")]
-}
withParams : List ( String, String ) -> Socket msg -> Socket msg
withParams params socket =
    { socket | params = params }


{-| The client regularly sends a heartbeat to the server. With this function you can specify the intervall in which the heartbeats are send. By default it_s 30 seconds.

    init "ws://localhost:4000/socket/websocket"
        |> heartbeatIntervallSeconds 60
-}
heartbeatIntervallSeconds : Int -> Socket msg -> Socket msg
heartbeatIntervallSeconds intervall socket =
    { socket | heartbeatIntervall = (toFloat intervall) * Time.second }


{-| The client regularly sends a heartbeat to the sever. With this function you can disable the heartbeat.

    init "ws://localhost:4000/socket/websocket"
        |> withoutHeartbeat
-}
withoutHeartbeat : Socket msg -> Socket msg
withoutHeartbeat socket =
    { socket | withoutHeartbeat = True }


{-| The effect manager will try to establish a socket connection. If it fails it will try again with a specified backoff. By default the effect manager will use the following exponential backoff strategy:

    defaultReconnectTimer failedAttempts =
        if backoff < 1 then
            0
        else
            toFloat (10 * 2 ^ failedAttempts)

With this function you can specify a custom strategy.
-}
reconnectTimer : (Int -> Time) -> Socket msg -> Socket msg
reconnectTimer timerFunc socket =
    { socket | reconnectTimer = timerFunc }


{-| Enable debug logs for the socket. Every incoming and outgoing message will be printed.
-}
withDebug : Socket msg -> Socket msg
withDebug socket =
    { socket | debug = True }


{-| Set a callback which will be called if the socket connection got closed abnormal, i.e., if the server declined the socket authentication. So this callback is useful for updating query params like access tokens.

    type Msg =
        RefreshAccessToken | ...

        init "ws://localhost:4000/socket/websocket"
            |> withParams [ ( "accessToken", "abc123" ) ]
            |> onAbnormalClose RefreshAccessToken
-}
onAbnormalClose : msg -> Socket msg -> Socket msg
onAbnormalClose onAbnormalClose_ socket =
    { socket | onAbnormalClose = Just onAbnormalClose_ }


{-| Set a callback which will be called if the socket connection got closed normal. Useful if you have to do some additional clean up.
-}
onNormalClose : msg -> Socket msg -> Socket msg
onNormalClose onNormalClose_ socket =
    { socket | onNormalClose = Just onNormalClose_ }


{-| Set a callback which will be called if the socket connection got closed. You can learn more about the code [here](https://developer.mozilla.org/en-US/docs/Web/API/CloseEvent).
-}
onClose : ({ code : Int, reason : String, wasClean : Bool } -> msg) -> Socket msg -> Socket msg
onClose onClose_ socket =
    { socket | onClose = Just onClose_ }


defaultReconnectTimer : Int -> Time
defaultReconnectTimer failedAttempts =
    if failedAttempts < 1 then
        0
    else
        toFloat (10 * 2 ^ failedAttempts)


{-| Composes each callback with the function `a -> b`.
-}
map : (a -> b) -> Socket a -> Socket b
map func socket =
    { socket
        | onClose = Maybe.map ((<<) func) socket.onClose
        , onNormalClose = Maybe.map func socket.onNormalClose
        , onAbnormalClose = Maybe.map func socket.onAbnormalClose
    }
