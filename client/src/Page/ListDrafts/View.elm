module Page.ListDrafts.View (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Maybe
import String
import Model.Shared exposing (..)
import Route exposing (..)
import Page.ListDrafts.Model exposing (..)
import Page.ListDrafts.Update exposing (addr)
import Page.ShowTrack.View as ShowTrack
import View.Utils exposing (..)
import View.Layout as Layout


view : Context -> Model -> Html
view ctx ({ drafts } as model) =
  Layout.layoutWithNav
    "list-drafts"
    ctx
    [ Layout.section
        "blue"
        [ h1 [] [ text "Tracks editor" ]
        ]
    , Layout.section
        "white"
        [ div
            [ class "row drafts" ]
            (List.map (\t -> draftItem (Just t == model.confirmDelete) t) drafts)
        , createTrackForm model
        ]
    ]



-- confirmDelete : Track -> Html
-- confirmDelete track =
--   div [ class "alert alert-danger" ]
--   [ text <| "Confirm deletion of track \"" ++ track.name ++ "\"?"
--   , button [ class "btn btn-danger btn-xs pull-right" ] [ text "Yes" ]
--   ]


draftItem : Bool -> Track -> Html
draftItem confirmDelete draft =
  div
    [ class "col-md-4" ]
    [ div
        ([ classList
            [ ( "live-track", True )
            , ( "confirm-delete", confirmDelete )
            ]
         ]
          ++ (linkAttrs (EditTrack draft.id))
        )
        [ div
            [ class "live-track-header" ]
            [ h3
                [ class "name" ]
                [ text draft.name ]
            ]
        , div
            [ class "live-track-body" ]
            []
        , div
            [ class "live-track-actions" ]
            [ button
                [ class "btn-flat"
                , onButtonClick addr (ConfirmDeleteDraft draft)
                  -- , disabled confirmDelete
                ]
                [ text "Delete" ]
            , button
                [ class "btn-flat", onButtonClick addr (DeleteDraft draft.id) ]
                [ text "Confirm?" ]
            ]
        ]
    ]


createTrackForm : Model -> Html
createTrackForm { name } =
  div
    [ class "form-inline form-new-draft" ]
    [ formGroup
        False
        [ textInput
            [ value name
            , placeholder "New track name"
            , onInput addr SetDraftName
            , onEnter addr CreateDraft
            ]
        ]
    , button
        [ class "btn btn-primary"
        , onClick addr CreateDraft
        , disabled (String.isEmpty name)
        ]
        [ text "Create draft" ]
    ]
