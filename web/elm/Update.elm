module Update exposing (..)

import Types exposing (Msg(..))
import Model exposing (..)
import Contacts.Update
import Contact.Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        _ =
            Debug.log "msg" msg
    in
        case msg of
            ContactsMsg subMsg ->
                let
                    ( updatedContacts, cmd ) =
                        Contacts.Update.update subMsg model.contacts
                in
                    ( { model
                        | contacts = updatedContacts
                        , contact = Nothing
                      }
                    , Cmd.map ContactsMsg cmd
                    )

            ContactMsg subMsg ->
                case model.contact of
                    Just contact ->
                        let
                            ( updatedContact, cmd ) =
                                Contact.Update.update subMsg contact
                        in
                            ( { model | contact = updatedContact }
                            , Cmd.map ContactMsg cmd
                            )

                    Nothing ->
                        ( model, Cmd.none )
