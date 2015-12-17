module Screens.ListDrafts.Types where

import Models exposing (..)


type alias Screen =
  { drafts : List Track
  , name : String
  , confirmDelete : Maybe Track
  , confirmPublish : Maybe Track
  }

initial : Screen
initial =
  { drafts = []
  , name = ""
  , confirmDelete = Nothing
  , confirmPublish = Nothing
  }

type Action
  = DraftsResult (Result () (List Track))
  | SetDraftName String
  | CreateDraft
  | CreateDraftResult (FormResult Track)
  | ConfirmDeleteDraft Track
  | DeleteDraft String
  | DeleteDraftResult (FormResult String)
  | NoOp

