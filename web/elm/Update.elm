module Update exposing (..)

import Types exposing (Msg(..))
import Model exposing (..)
import Contact.Model
import Contacts.Update
import Contact.Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ContactsMsg subMsg ->
            let
                ( updatedContacts, cmd ) =
                    Contacts.Update.update subMsg model.contacts
            in
                ( { model | contacts = updatedContacts, contact = Contact.Model.initialModel }
                , Cmd.map ContactsMsg cmd
                )

        ContactMsg subMsg ->
            let
                ( updatedContact, cmd ) =
                    Contact.Update.update subMsg model.contact
            in
                ( { model | contact = updatedContact }
                , Cmd.map ContactMsg cmd
                )
