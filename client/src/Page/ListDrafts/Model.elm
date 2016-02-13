module Page.ListDrafts.Model where

import Model.Shared exposing (..)


type alias Model =
  { drafts : List Track
  , name : String
  , confirmDelete : Maybe Track
  , confirmPublish : Maybe Track
  }

initial : Model
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

