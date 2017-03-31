module Subscriptions exposing (..)

import Messages exposing (Msg(..))
import Model exposing (Model)
import Phoenix
import Phoenix.Channel as Channel exposing (Channel)
import Phoenix.Socket as Socket exposing (Socket)


subscriptions : Model -> Sub Msg
subscriptions model =
    Phoenix.connect (socket model.flags.socketUrl) [ contacts ]


socket : String -> Socket Msg
socket socketUrl =
    Socket.init socketUrl


contacts : Channel Msg
contacts =
    Channel.init "contacts"
        |> Channel.withDebug
