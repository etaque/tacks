module Page.ListDrafts.View where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Maybe

import AppTypes exposing (..)
import Models exposing (..)
import Route exposing (..)

import Page.ListDrafts.Model exposing (..)
import Page.ListDrafts.Update exposing (addr)

import View.Utils exposing (..)
import View.Layout as Layout


view : Context -> Screen -> Html
view ctx ({drafts} as screen) =
  Layout.layoutWithNav "list-drafts" ctx
  [ container ""
    [ h1 [ ] [ text "Drafts" ]
    -- , Maybe.map confirmDelete screen.confirmDelete |> Maybe.withDefault (text "")
    , ul [ class "list-unstyled drafts" ]
      (List.map (\t -> draftItem (Just t == screen.confirmDelete) t) drafts)
    , createTrackForm screen
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
  li [ classList [ ( "confirm-delete", confirmDelete) ] ]
  [ linkTo (EditTrack draft.id) [ class "" ] [ text draft.name ]
  , button
      [ class "btn btn-default btn-xs pull-right"
      , onClick addr (ConfirmDeleteDraft draft)
      -- , disabled confirmDelete
      ]
    [ text "Delete" ]
  , button [ class "btn btn-danger btn-xs pull-right delete-draft", onClick addr (DeleteDraft draft.id) ]
    [ text "Confirm?" ]
  ]


createTrackForm : Screen -> Html
createTrackForm {name} =
  div [ class "form-new-draft" ]
  [ h3 [] [ text "New draft" ]
  , formGroup False
    [ textInput
      [ value name
      , placeholder "Track name"
      , onInput addr SetDraftName
      , onEnter addr CreateDraft
      ]
    ]
  , div []
    [ button
      [ class "btn btn-primary"
      , onClick addr CreateDraft
      ]
      [ text "Create draft" ]
    ]
  ]
