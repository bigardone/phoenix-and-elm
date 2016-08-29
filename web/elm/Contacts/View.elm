module Contacts.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import String
import Contacts.Types exposing (..)
import Contacts.Model exposing (..)
import Contact.View exposing (..)


indexView : Model -> Html Msg
indexView model =
    div
        [ id "home_index" ]
        [ filterView model
        , paginationView model.total_pages model.page_number
        , div
            []
            [ listContacts model ]
        , paginationView model.total_pages model.page_number
        ]


filterView : Model -> Html Msg
filterView model =
    let
        contactWord =
            if model.total_entries == 1 then
                "contact"
            else
                "contacts"

        headerText =
            (toString model.total_entries) ++ " " ++ contactWord ++ " found"
    in
        div
            [ class "filter-wrapper" ]
            [ div
                [ class "overview-wrapper" ]
                [ h3 [] [ text headerText ] ]
            , div
                [ class "form-wrapper" ]
                [ Html.form
                    [ onSubmit FormSubmit ]
                    [ resetButton model "reset"
                    , input
                        [ type' "search"
                        , placeholder "Search contacts..."
                        , onInput SearchInput
                        , value model.search
                        ]
                        []
                    ]
                ]
            ]


paginationView : Int -> Int -> Html Msg
paginationView totalPages pageNumber =
    [1..totalPages]
        |> List.map (paginationLink pageNumber)
        |> ul [ class "pagination" ]


paginationLink : Int -> Int -> Html Msg
paginationLink currentPage page =
    let
        classes =
            classList [ ( "active", currentPage == page ) ]
    in
        li
            []
            [ a
                [ classes
                , onClick (Paginate page)
                ]
                []
            ]


listContacts : Model -> Html Msg
listContacts model =
    if model.total_entries > 0 then
        model.entries
            |> List.map (Contact.View.contactView True)
            |> div [ class "cards-wrapper" ]
    else
        let
            classes =
                classList [ ( "warning", True ), ( "hidden", String.length model.search == 0 ) ]
        in
            div
                [ classes ]
                [ span
                    [ class "fa-stack" ]
                    [ i [ class "fa fa-meh-o fa-stack-2x" ] [] ]
                , h4 [] [ text "No contacts found..." ]
                , resetButton model "btn"
                ]


resetButton : Model -> String -> Html Msg
resetButton model className =
    let
        hide =
            (String.length model.search) < 1

        classes =
            classList [ ( className, True ), ( "hidden", hide ) ]
    in
        a
            [ classes
            , onClick Reset
            ]
            [ text "Reset search" ]
