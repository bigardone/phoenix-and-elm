module Phoenix.Internal.Socket exposing (..)

import Dict exposing (Dict)
import Process
import String
import Task exposing (Task)
import WebSocket.LowLevel as WS
import Phoenix.Internal.Message as Message exposing (Message)
import Phoenix.Socket as Socket


type alias Endpoint =
    String


type alias Ref =
    Int


{-| The underlying low-level InternalSocket connection.
-}
type Connection
    = Closed
    | Opening Int Process.Id
    | Connected WS.WebSocket Int


type alias InternalSocket msg =
    { connection : Connection, socket : Socket.Socket msg }


internalSocket : Socket.Socket msg -> InternalSocket msg
internalSocket socket =
    { connection = Closed, socket = socket }



-- INSPECT


isOpening : InternalSocket msg -> Bool
isOpening internalSocket =
    case internalSocket.connection of
        Opening _ _ ->
            True

        _ ->
            False



-- MODIFY


opening : Int -> Process.Id -> InternalSocket msg -> InternalSocket msg
opening backoff pid socket =
    { socket | connection = (Opening backoff pid) }


connected : WS.WebSocket -> InternalSocket msg -> InternalSocket msg
connected ws socket =
    { socket | connection = (Connected ws 0) }


increaseRef : InternalSocket msg -> InternalSocket msg
increaseRef socket =
    case socket.connection of
        Connected ws ref ->
            { socket | connection = Connected ws (ref + 1) }

        _ ->
            socket


update : Socket.Socket msg -> InternalSocket msg -> InternalSocket msg
update nextSocket { connection, socket } =
    let
        updatedConnection =
            if nextSocket.params /= socket.params then
                resetBackoff connection
            else
                connection
    in
        InternalSocket updatedConnection nextSocket


resetBackoff : Connection -> Connection
resetBackoff connection =
    case connection of
        Opening backoff pid ->
            Opening 0 pid

        _ ->
            connection



-- PUSH


push : Message -> InternalSocket msg -> Task x (Maybe Ref)
push message { connection, socket } =
    case connection of
        Connected ws ref ->
            let
                message_ =
                    if socket.debug then
                        Debug.log "Send" (Message.ref ref message)
                    else
                        Message.ref ref message
            in
                WS.send ws (Message.encode message_)
                    |> Task.map
                        (\maybeBadSend ->
                            (case maybeBadSend of
                                Nothing ->
                                    Just ref

                                Just badSend ->
                                    if socket.debug then
                                        let
                                            _ =
                                                Debug.log "BadSend" badSend
                                        in
                                            Nothing
                                    else
                                        Nothing
                            )
                        )

        _ ->
            Task.succeed (Nothing)



-- OPEN CONNECTIONs


open : InternalSocket msg -> WS.Settings -> Task WS.BadOpen WS.WebSocket
open { socket } settings =
    let
        query =
            socket.params
                |> List.map (\( key, val ) -> key ++ "=" ++ val)
                |> String.join "&"

        url =
            if String.contains "?" socket.endpoint then
                socket.endpoint ++ "&" ++ query
            else
                socket.endpoint ++ "?" ++ query
    in
        WS.open url settings


after : Float -> Task x ()
after backoff =
    if backoff < 1 then
        Task.succeed ()
    else
        Process.sleep backoff



-- CLOSE CONNECTIONS


close : InternalSocket msg -> Task x ()
close { connection } =
    case connection of
        Opening _ pid ->
            Process.kill pid

        Connected socket _ ->
            WS.close socket

        Closed ->
            Task.succeed ()



-- HELPERS


get : Endpoint -> Dict Endpoint (InternalSocket msg) -> Maybe (InternalSocket msg)
get endpoint dict =
    Dict.get endpoint dict


getRef : Endpoint -> Dict Endpoint (InternalSocket msg) -> Maybe Ref
getRef endpoint dict =
    get endpoint dict |> Maybe.andThen ref


ref : InternalSocket msg -> Maybe Ref
ref { connection } =
    case connection of
        Connected _ ref_ ->
            Just ref_

        _ ->
            Nothing


debugLogMessage : InternalSocket msg -> a -> a
debugLogMessage { socket } msg =
    if socket.debug then
        Debug.log "Received" msg
    else
        msg
