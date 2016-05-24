module Model exposing (..)

import Model.Shared exposing (..)
import Page.Home.Model as Home
import Page.Login.Model as Login
import Page.Register.Model as Register
import Page.Explore.Model as Explore
import Page.EditTrack.Model as EditTrack
import Page.Game.Model as Game
import Page.ListDrafts.Model as ListDrafts
import Page.Forum.Model as Forum
import Page.Admin.Model as Admin
import Route exposing (Route)
import Location
import Window


type alias Setup =
  { player : Player
  , path : String
  , dims : ( Int, Int )
  }


type Msg
  = SetPlayer Player
  | RefreshLiveStatus
  | SetLiveStatus (Result () LiveStatus)
  | WindowResized Window.Size
  | MountRoute Route Route
  | PageMsg PageMsg
  | LocationMsg Location.Msg
  | Logout
  | Navigate String
  | NoOp


type PageMsg
  = HomeMsg Home.Msg
  | LoginMsg Login.Msg
  | RegisterMsg Register.Msg
  | ExploreMsg Explore.Msg
  | EditTrackMsg EditTrack.Msg
  | GameMsg Game.Msg
  | ListDraftsMsg ListDrafts.Msg
  | ForumMsg Forum.Msg
  | AdminMsg Admin.Msg


type alias Model =
  { location : Location.Model
  , player : Player
  , liveStatus : LiveStatus
  , dims : Dims
  , pages : Pages
  }


type alias Pages =
  { home : Home.Model
  , login : Login.Model
  , register : Register.Model
  , explore : Explore.Model
  , editTrack : EditTrack.Model
  , game : Game.Model
  , listDrafts : ListDrafts.Model
  , forum : Forum.Model
  , admin : Admin.Model
  }


initialModel : Setup -> Model
initialModel { dims, player } =
  { player = player
  , liveStatus = { liveTracks = [], onlinePlayers = [] }
  , dims = dims
  , location = Location.initial
  , pages =
      { home = Home.initial
      , login = Login.initial
      , register = Register.initial
      , explore = Explore.initial
      , editTrack = EditTrack.initial
      , game = Game.initial
      , listDrafts = ListDrafts.initial
      , forum = Forum.initial
      , admin = Admin.initial
      }
  }
