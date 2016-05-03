module Page.ListDrafts.Model (..) where

import CoreExtra
import Model.Shared exposing (..)


type alias Model =
  { tracks : List Track
  , showCreationForm : Bool
  , name : String
  , selectedTrack : Maybe String
  , confirmDelete : Maybe String
  , confirmPublish : Maybe Track
  }


initial : Model
initial =
  { tracks = []
  , showCreationForm = False
  , name = ""
  , selectedTrack = Nothing
  , confirmDelete = Nothing
  , confirmPublish = Nothing
  }


type Action
  = DraftsResult (Result () (List Track))
  | SetDraftName String
  | SelectTrack (Maybe String)
  | ToggleCreationForm
  | CreateDraft
  | CreateDraftResult (FormResult Track)
  | ConfirmDeleteDraft String
  | DeleteDraft String
  | DeleteDraftResult (FormResult String)
  | NoOp


getSelectedTrack : Model -> Maybe Track
getSelectedTrack { tracks, selectedTrack } =
  selectedTrack
    `Maybe.andThen` (\id -> CoreExtra.find (\t -> t.id == id) tracks)
