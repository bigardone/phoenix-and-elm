module Subscriptions exposing (..)

import Messages exposing (Msg(..))
import Model exposing (Model, SocketState(..))
import Phoenix
import Phoenix.Channel as Channel exposing (Channel)
import Phoenix.Socket as Socket exposing (Socket)


socket : String -> Socket Msg
socket socketUrl =
    Socket.init socketUrl


contacts : Channel Msg
contacts =
    Channel.init "contacts"
        |> Channel.onJoin (\_ -> UpdateSocketState JoinedLobby)
        |> Channel.withDebug


subscriptions : Model -> Sub Msg
subscriptions model =
    let
        channels =
            case model.socketState of
                JoiningLobby ->
                    [ contacts ]

                JoinedLobby ->
                    [ contacts ]

                _ ->
                    []

        socketUrl =
            model.flags.socketUrl
    in
        Phoenix.connect (socket socketUrl) channels
