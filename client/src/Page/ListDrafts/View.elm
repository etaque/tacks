module Page.ListDrafts.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Date
import Date.Format as DateFormat
import String
import Model.Shared exposing (..)
import Route
import Page.ListDrafts.Model exposing (..)
import View.Utils as Utils
import View.Layout as Layout exposing (Layout)


view : Context -> Model -> Layout Msg
view ctx ({ tracks } as model) =
    Layout
        "list-drafts"
        []
        (Just Layout.Build)
        [ Layout.header
            ctx
            []
            [ div
                [ class "btn-raised btn-positive btn-new-track cta pull-right"
                , onClick ToggleCreationForm
                ]
                [ text "New course" ]
            , h1 [] [ text "Your courses" ]
            ]
        , Layout.section
            [ classList [ ( "grey new-track inside", True ), ( "show", model.showCreationForm ) ] ]
            [ createTrackForm model ]
        , Layout.section
            [ class "white manage-tracks with-overlap" ]
            [ if List.isEmpty tracks then
                div
                    [ class "empty-notice" ]
                    [ text "No course built yet!" ]
              else
                div
                    [ class "tracks-list is-overlap" ]
                    (List.concatMap (draftItem model) tracks)
            ]
        ]
        Nothing


draftItem : Model -> Track -> List (Html Msg)
draftItem model track =
    let
        isSelected =
            (Just track.id == model.selectedTrack)
    in
        [ div
            [ classList
                [ ( "tracks-item", True )
                , ( toString track.status |> String.toLower, True )
                , ( "selected", isSelected )
                ]
            , if isSelected then
                onClick (Select Nothing)
              else
                onClick (Select (Just track.id))
            ]
            [ div
                [ class "icon" ]
                [ Utils.mIcon "palette" [] ]
            , div
                [ class "desc" ]
                [ div
                    [ class "name" ]
                    [ text track.name
                    ]
                , div
                    [ class "date" ]
                    [ text
                        ((DateFormat.format
                            "%e %b. %k:%M"
                            (Date.fromTime track.updateTime)
                         )
                        )
                    ]
                ]
            , case track.status of
                Open ->
                    div
                        [ class "status" ]
                        [ Utils.mIcon "check" []
                        , span
                            []
                            [ text (trackStatusLabel track.status) ]
                        ]

                _ ->
                    text ""
            , div
                [ class "toggle" ]
                [ if isSelected then
                    Utils.mIcon "expand_less" []
                  else
                    Utils.mIcon "expand_more" []
                ]
            ]
        , div
            [ classList [ ( "tracks-edit", True ), ( "selected", isSelected ) ] ]
            [ case track.status of
                Draft ->
                    draftActions model track

                Open ->
                    div
                        [ class "actions" ]
                        [ Utils.linkTo
                            (Route.PlayTrack track.id)
                            [ class "btn-raised btn-primary" ]
                            [ text "Visit" ]
                        ]

                _ ->
                    text ""
            ]
        ]


draftActions : Model -> Track -> Html Msg
draftActions model track =
    if model.confirmPublish then
        confirmPublish track
    else if model.confirmDelete then
        confirmDelete track
    else
        div
            [ class "actions" ]
            [ Utils.linkTo
                (Route.EditTrack track.id)
                [ class "btn-raised btn-primary" ]
                [ text "Open" ]
            , button
                [ class "btn-flat"
                , Utils.onButtonClick (ConfirmPublish True)
                ]
                [ text "Publish" ]
            , button
                [ class "btn-flat btn-danger pull-right"
                , Utils.onButtonClick (ConfirmDelete True)
                ]
                [ text "Delete" ]
            ]


confirmPublish : Track -> Html Msg
confirmPublish track =
    div
        [ class "actions" ]
        [ button
            [ class "btn-raised btn-positive"
            , Utils.onButtonClick (Publish track.id)
            ]
            [ text "Publish!" ]
        , button
            [ class "btn-flat"
            , Utils.onButtonClick (ConfirmPublish False)
            ]
            [ text "Cancel" ]
        , span [] [ text "Course will be frozen, no changes allowed anymore!" ]
        ]


confirmDelete : Track -> Html Msg
confirmDelete track =
    div
        [ class "actions right" ]
        [ button
            [ class "btn-raised btn-danger"
            , Utils.onButtonClick (Delete track.id)
            ]
            [ text "Confirm?" ]
        , button
            [ class "btn-flat"
            , Utils.onButtonClick (ConfirmDelete False)
            ]
            [ text "Cancel" ]
        ]


createTrackForm : Model -> Html Msg
createTrackForm { name } =
    div
        [ class "form-inline form-new-track" ]
        [ Utils.formGroup
            False
            [ Utils.textInput
                [ value name
                , placeholder "Course name"
                , onInput SetName
                , Utils.onEnter Create
                ]
            ]
        , button
            [ class "btn-raised btn-primary"
            , onClick Create
            , disabled (String.isEmpty name)
            ]
            [ text "Create" ]
        ]
