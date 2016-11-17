module Update exposing (..)

import Types exposing (Msg(..))
import Model exposing (..)
import Contact.Model
import Contacts.Update
import Contact.Update
import Routing exposing (..)
import Commands exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlChange location ->
            let
                currentRoute =
                    Routing.parse location
            in
                urlUpdate currentRoute (initialModel currentRoute)

        ContactsMsg subMsg ->
            let
                ( updatedContacts, cmd ) =
                    Contacts.Update.update subMsg model.contacts
            in
                ( { model | contacts = updatedContacts }
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


urlUpdate : Route -> Model -> ( Model, Cmd Msg )
urlUpdate currentRoute model =
    case currentRoute of
        ContactsRoute ->
            ( { model | route = currentRoute, contact = Contact.Model.initialModel }, Cmd.map ContactsMsg (Commands.fetch model.contacts.search model.contacts.page_number) )

        ContactRoute id ->
            ( { model | route = currentRoute }, Cmd.map ContactMsg (Commands.fetchContact id) )

        _ ->
            ( { model | route = currentRoute }, Cmd.none )
