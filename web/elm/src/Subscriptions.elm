module Subscriptions exposing (..)

import Messages exposing (Msg(..))
import Model exposing (Model, SocketState(..))
import Phoenix
import Phoenix.Channel as Channel exposing (Channel)
import Phoenix.Socket as Socket exposing (Socket)


socket : String -> Socket Msg
socket socketUrl =
    Socket.init socketUrl


lobby : Channel Msg
lobby =
    Channel.init "lobby"
        |> Channel.onJoin (\_ -> UpdateSocketState JoinedLobby)
        |> Channel.withDebug


subscriptions : Model -> Sub Msg
subscriptions model =
    let
        channels =
            case model.socketState of
                JoiningLobby ->
                    [ lobby ]

                JoinedLobby ->
                    [ lobby ]

                _ ->
                    []

        socketUrl =
            model.flags.socketUrl
    in
        Phoenix.connect (socket socketUrl) channels
