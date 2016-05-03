module Page.ListDrafts.View (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Date
import Date.Format as DateFormat
import String
import Model.Shared exposing (..)
import Route
import Page.ListDrafts.Model exposing (..)
import Page.ListDrafts.Update exposing (addr)
import View.Utils as Utils
import View.Layout as Layout


view : Context -> Model -> Html
view ctx ({ tracks } as model) =
  Layout.siteLayout
    "list-drafts"
    ctx
    (Just Layout.Build)
    [ Layout.header
        ctx
        []
        [ h1 [] [ text "Tracks editor" ]
        , div
            [ class "btn-floating btn-positive btn-new-track"
            , onClick addr ToggleCreationForm
            ]
            [ Utils.mIcon "add" [] ]
        ]
    , Layout.section
        [ classList [ ( "grey new-track", True ), ( "show", model.showCreationForm ) ] ]
        [ createTrackForm model ]
    , Layout.section
        [ class "white manage-tracks" ]
        [ if List.isEmpty tracks then
            div
            [ class "empty-notice"]
            [ text "No track built yet!"]
          else
            div
              [ class "tracks-list" ]
              (List.concatMap (draftItem model) tracks)
        ]
    ]


draftItem : Model -> Track -> List Html
draftItem model track =
  let
    isSelected =
      (Just track.id == model.selectedTrack)

    confirmDelete =
      (Just track.id == model.confirmDelete)
  in
    [ div
        [ classList [ ( "tracks-item", True ), ( "selected", isSelected ) ]
        , if isSelected then
            onClick addr (SelectTrack Nothing)
          else
            onClick addr (SelectTrack (Just track.id))
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
        [ div
            [ class "actions" ]
            [ Utils.linkTo
                (Route.EditTrack track.id)
                [ class "btn-raised btn-primary" ]
                [ text " Open" ]
            , button
                [ class "btn-flat"
                  -- , Utils.onButtonClick addr (SetEditingName True)
                ]
                [ text "Publish" ]
            , if confirmDelete then
                button
                  [ class "btn-flat pull-right"
                  , Utils.onButtonClick addr (ConfirmDeleteDraft track.id)
                  ]
                  [ text "Cancel" ]
              else
                button
                  [ class "btn-flat btn-danger pull-right"
                  , Utils.onButtonClick addr (ConfirmDeleteDraft track.id)
                  , disabled confirmDelete
                  ]
                  [ text "Delete" ]
            , if confirmDelete then
                button
                  [ class "btn-raised btn-danger pull-right"
                  , Utils.onButtonClick addr (DeleteDraft track.id)
                  ]
                  [ text "Confirm?" ]
              else
                text ""
            ]
        ]
    ]


createTrackForm : Model -> Html
createTrackForm { name } =
  div
    [ class "form-inline form-new-track" ]
    [ Utils.formGroup
        False
        [ Utils.textInput
            [ value name
            , placeholder "New track name"
            , Utils.onInput addr SetDraftName
            , Utils.onEnter addr CreateDraft
            ]
        ]
    , button
        [ class "btn-raised btn-primary"
        , onClick addr CreateDraft
        , disabled (String.isEmpty name)
        ]
        [ text "Create track" ]
    ]
