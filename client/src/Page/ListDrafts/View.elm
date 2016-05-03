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
        [ h1 [] [ text "Your tracks" ]
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
              [ class "empty-notice" ]
              [ text "No track built yet!" ]
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
  in
    [ div
        [ classList
            [ ( "tracks-item", True )
            , ( toString track.status |> String.toLower, True )
            , ( "selected", isSelected )
            ]
        , if isSelected then
            onClick addr (Select Nothing)
          else
            onClick addr (Select (Just track.id))
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


draftActions : Model -> Track -> Html
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
          , Utils.onButtonClick addr (ConfirmPublish True)
          ]
          [ text "Publish" ]
      , button
          [ class "btn-flat btn-danger pull-right"
          , Utils.onButtonClick addr (ConfirmDelete True)
          ]
          [ text "Delete" ]
      ]


confirmPublish : Track -> Html
confirmPublish track =
  div
    [ class "actions" ]
    [ button
        [ class "btn-raised btn-positive"
        , Utils.onButtonClick addr (Publish track.id)
        ]
        [ text "Publish!" ]
    , button
        [ class "btn-flat"
        , Utils.onButtonClick addr (ConfirmPublish False)
        ]
        [ text "Cancel" ]
    , span [] [ text "Track will be frozen, no changes allowed anymore!" ]
    ]


confirmDelete : Track -> Html
confirmDelete track =
  div
    [ class "actions right" ]
    [ button
        [ class "btn-raised btn-danger"
        , Utils.onButtonClick addr (Delete track.id)
        ]
        [ text "Confirm?" ]
    , button
        [ class "btn-flat"
        , Utils.onButtonClick addr (ConfirmDelete False)
        ]
        [ text "Cancel" ]
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
            , Utils.onInput addr SetName
            , Utils.onEnter addr Create
            ]
        ]
    , button
        [ class "btn-raised btn-primary"
        , onClick addr Create
        , disabled (String.isEmpty name)
        ]
        [ text "Create track" ]
    ]
