module Page.ListDrafts.Model exposing (..)

import CoreExtra
import Model.Shared exposing (..)


type alias Model =
    { tracks : List Track
    , showCreationForm : Bool
    , name : String
    , selectedTrack : Maybe String
    , confirmDelete : Bool
    , confirmPublish : Bool
    }


initial : Model
initial =
    { tracks = []
    , showCreationForm = False
    , name = ""
    , selectedTrack = Nothing
    , confirmDelete = False
    , confirmPublish = False
    }


type Msg
    = ListResult (Result () (List Track))
    | SetName String
    | Select (Maybe String)
    | ToggleCreationForm
    | Create
    | CreateResult (FormResult Track)
    | ConfirmPublish Bool
    | Publish String
    | PublishResult (FormResult Track)
    | ConfirmDelete Bool
    | Delete String
    | DeleteResult (HttpResult String)
    | NoOp


getSelectedTrack : Model -> Maybe Track
getSelectedTrack { tracks, selectedTrack } =
    selectedTrack
        `Maybe.andThen` (\id -> CoreExtra.find (\t -> t.id == id) tracks)
