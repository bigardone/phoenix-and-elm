module Update exposing (..)

import Commands exposing (..)
import Contact.Model
import Contact.Update
import ContactList.Update
import Model exposing (..)
import Routing exposing (..)
import Types exposing (Msg(..))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlChange location ->
            let
                currentRoute =
                    Routing.parse location
            in
                urlUpdate currentRoute (initialModel currentRoute)

        ContactListMsg subMsg ->
            let
                ( updatedContacts, cmd ) =
                    ContactList.Update.update subMsg model.contactList
            in
                ( { model | contactList = updatedContacts }
                , Cmd.map ContactListMsg cmd
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
            ( { model
                | route = currentRoute
                , contact = Contact.Model.initialModel
              }
            , Cmd.map ContactListMsg (Commands.fetch model.contactList.search model.contactList.page_number)
            )

        ContactRoute id ->
            ( { model | route = currentRoute }
            , Cmd.map ContactMsg (Commands.fetchContact id)
            )

        _ ->
            ( { model | route = currentRoute }
            , Cmd.none
            )
