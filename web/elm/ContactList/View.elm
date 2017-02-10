module ContactList.View exposing (..)

import Contact.View exposing (..)
import ContactList.Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model exposing (..)
import String


indexView : Model -> Html Msg
indexView model =
    div
        [ id "home_index" ]
        [ filterView model
        , paginationView model.contactList.total_pages model.contactList.page_number
        , div
            []
            [ contactsList model ]
        , paginationView model.contactList.total_pages model.contactList.page_number
        ]


filterView : Model -> Html Msg
filterView model =
    let
        totalEntries =
            model.contactList.total_entries

        contactWord =
            if totalEntries == 1 then
                "contact"
            else
                "contacts"

        headerText =
            if totalEntries == 0 then
                ""
            else
                (toString totalEntries) ++ " " ++ contactWord ++ " found"
    in
        div
            [ class "filter-wrapper" ]
            [ div
                [ class "overview-wrapper" ]
                [ h3
                    []
                    [ text headerText ]
                ]
            , div
                [ class "form-wrapper" ]
                [ Html.form
                    [ onSubmit FormSubmit ]
                    [ resetButton model "reset"
                    , input
                        [ type_ "search"
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
    List.range 1 totalPages
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


contactsList : Model -> Html Msg
contactsList model =
    if model.contactList.total_entries > 0 then
        model.contactList.entries
            |> List.map (Contact.View.contactView True)
            |> div [ class "cards-wrapper" ]
    else
        let
            classes =
                classList
                    [ ( "warning", True )
                    , ( "hidden", String.length model.search == 0 )
                    ]
        in
            div
                [ classes ]
                [ span
                    [ class "fa-stack" ]
                    [ i [ class "fa fa-meh-o fa-stack-2x" ] [] ]
                , h4
                    []
                    [ text "No contacts found..." ]
                , resetButton model "btn"
                ]


resetButton : Model -> String -> Html Msg
resetButton model className =
    let
        hide =
            (String.length model.search) < 1

        classes =
            classList
                [ ( className, True )
                , ( "hidden", hide )
                ]
    in
        a
            [ classes
            , onClick Reset
            ]
            [ text "Reset search" ]
