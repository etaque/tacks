module Screens.ListDrafts.View where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import AppTypes exposing (..)
import Models exposing (..)
import Routes exposing (..)

import Screens.ListDrafts.Types exposing (..)
import Screens.ListDrafts.Updates exposing (addr)

import Screens.Utils exposing (..)
import Screens.Layout as Layout


view : Context -> Screen -> Html
view ctx ({drafts} as screen) =
  Layout.layoutWithNav "list-drafts" ctx
    [ container ""
      [ h1 [ ] [ text "Drafts" ]
      , ul [ ] (List.map draftItem drafts)
      , if isAdmin ctx.player then createTrackForm screen else div [] []
      ]
    ]


draftItem : Track -> Html
draftItem draft =
  li [ ]
  [ linkTo (EditTrack draft.id) [ class "" ] [ text draft.name ]
  , text " "
  , button [ class "btn btn-danger btn-xs", onClick addr (DeleteDraft draft.id) ] [ text "Delete" ]
  ]


createTrackForm : Screen -> Html
createTrackForm {name} =
  div [ class "form-new-draft" ]
    [ formGroup False
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
