module Update exposing (..)

import Commands exposing (..)
import Contact.Update
import ContactList.Update
import Model
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
                ( newModel, cmd ) =
                    ContactList.Update.update subMsg model
            in
                ( newModel
                , Cmd.map ContactListMsg cmd
                )

        ContactMsg subMsg ->
            let
                ( newModel, cmd ) =
                    Contact.Update.update subMsg model
            in
                ( newModel
                , Cmd.map ContactMsg cmd
                )


urlUpdate : Route -> Model -> ( Model, Cmd Msg )
urlUpdate currentRoute model =
    case currentRoute of
        ContactsRoute ->
            ( { model
                | route = currentRoute
                , contact = Nothing
              }
            , Cmd.map ContactListMsg (Commands.fetch model.search model.contactList.page_number)
            )

        ContactRoute id ->
            ( { model | route = currentRoute }
            , Cmd.map ContactMsg (Commands.fetchContact id)
            )

        _ ->
            ( { model | route = currentRoute }
            , Cmd.none
            )
