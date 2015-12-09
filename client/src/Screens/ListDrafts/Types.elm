module Screens.ListDrafts.Types where

import Models exposing (..)


type alias Screen =
  { drafts : List Track
  , name : String
  }

initial : Screen
initial =
  { drafts = []
  , name = ""
  }

type Action
  = DraftsResult (Result () (List Track))
  | SetDraftName String
  | CreateDraft
  | CreateDraftResult (FormResult Track)
  | NoOp

