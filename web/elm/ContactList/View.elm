module ContactList.View exposing (indexView)

import Contact.View exposing (contactView)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Keyed exposing (..)
import Messages exposing (..)
import Model exposing (..)


indexView : Model -> Html Msg
indexView model =
    div
        [ id "home_index" ]
        [ searchSection model
        , paginationList model.contactList
        , div
            []
            [ contactsList model ]
        , paginationList model.contactList
        ]


searchSection : Model -> Html Msg
searchSection model =
    case model.contactList of
        Failure error ->
            text error

        Success page ->
            let
                totalEntries =
                    page.total_entries

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

        _ ->
            text ""


contactsList : Model -> Html Msg
contactsList model =
    case model.contactList of
        Success page ->
            if page.total_entries > 0 then
                page.entries
                    |> List.map contactView
                    |> Html.Keyed.node "div" [ class "cards-wrapper" ]
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

        _ ->
            text ""


paginationList : RemoteData String ContactList -> Html Msg
paginationList contactList =
    case contactList of
        Success page ->
            List.range 1 page.total_pages
                |> List.map (paginationLink page.page_number)
                |> Html.Keyed.ul [ class "pagination" ]

        _ ->
            text ""


paginationLink : Int -> Int -> ( String, Html Msg )
paginationLink currentPage page =
    let
        classes =
            classList [ ( "active", currentPage == page ) ]
    in
        ( toString page
        , li
            []
            [ a
                [ classes
                , onClick <| Paginate page
                ]
                []
            ]
        )
