module ContactList.View exposing (indexView)

import Contact.View exposing (contactView)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Messages exposing (..)
import Model exposing (..)


indexView : Model -> Html Msg
indexView model =
    div
        [ id "home_index" ]
        [ searchSection model
        , paginationList model.contactList.total_pages model.contactList.page_number
        , div
            []
            [ contactsList model ]
        , paginationList model.contactList.total_pages model.contactList.page_number
        ]


searchSection : Model -> Html Msg
searchSection model =
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
                    [ onSubmit HandleFormSubmit ]
                    [ input
                        [ type_ "search"
                        , placeholder "Search contacts..."
                        , value model.search
                        , onInput HandleSearchInput
                        ]
                        []
                    ]
                ]
            ]


contactsList : Model -> Html Msg
contactsList model =
    if model.contactList.total_entries > 0 then
        model.contactList.entries
            |> List.map contactView
            |> div [ class "cards-wrapper" ]
    else
        let
            classes =
                classList
                    [ ( "warning", True ) ]
        in
            div
                [ classes ]
                [ span
                    [ class "fa-stack" ]
                    [ i [ class "fa fa-meh-o fa-stack-2x" ] [] ]
                , h4
                    []
                    [ text "No contacts found..." ]
                ]


paginationList : Int -> Int -> Html Msg
paginationList totalPages pageNumber =
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
                , onClick <| Paginate page
                ]
                []
            ]
