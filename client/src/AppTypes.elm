module AppTypes where

import Task exposing (Task)
import Effects exposing (Effects)

import Models exposing (..)

import Screens.Home.Types as Home
import Screens.Login.Types as Login
import Screens.Register.Types as Register
import Screens.ShowTrack.Types as ShowTrack
import Screens.EditTrack.Types as EditTrack
import Screens.ShowProfile.Types as ShowProfile
import Screens.Game.Types as Game
import Screens.ListDrafts.Types as ListDrafts

import Routes


appActionsMailbox : Signal.Mailbox AppAction
appActionsMailbox =
  Signal.mailbox AppNoOp

appActionsAddress : Signal.Address AppAction
appActionsAddress =
  appActionsMailbox.address


(&!) : a -> Task Effects.Never b -> (a, Effects b)
(&!) model task =
  (model, Effects.task task)

(&:) : a -> Effects b -> (a, Effects b)
(&:) = (,)

(?) : Maybe a -> a -> a
(?) maybe default =
  Maybe.withDefault default maybe

(?:) : Result x a -> a -> a
(?:) result default =
  Result.withDefault default result

infixr 9 ?

type alias AppSetup =
  { player : Player
  , path : String
  , dims : (Int, Int)
  }


type AppAction
  = SetPlayer Player
  | SetPath String
  | PathChanged String
  | MountRoute (Maybe Routes.Route)
  | UpdateDims (Int, Int)
  | ScreenAction ScreenAction
  | Logout
  | AppNoOp


type ScreenAction
  = HomeAction Home.Action
  | LoginAction Login.Action
  | RegisterAction Register.Action
  | ShowTrackAction ShowTrack.Action
  | EditTrackAction EditTrack.Action
  | ShowProfileAction ShowProfile.Action
  | GameAction Game.Action
  | ListDraftsAction ListDrafts.Action



type alias AppState =
  { ctx : Context
  , route : Maybe Routes.Route
  , path : String
  , screens : Screens
  }

type alias Context =
  { player : Player
  , dims : (Int, Int)
  , transitStatus : TransitStatus
  }

type TransitStatus = Exit | Enter

type alias Screens =
  { home : Home.Screen
  , login : Login.Screen
  , register : Register.Screen
  , showTrack : ShowTrack.Screen
  , editTrack : EditTrack.Screen
  , showProfile : ShowProfile.Screen
  , game : Game.Screen
  , listDrafts: ListDrafts.Screen
  }


initialAppState : AppSetup -> AppState
initialAppState { path, dims, player } =
  { ctx =
      { player = player
      , dims = dims
      , transitStatus = Enter
      }
  , path = path
  , route = Nothing
  , screens =
    { home = Home.initial player
    , login = Login.initial
    , register = Register.initial
    , showTrack = ShowTrack.initial
    , editTrack = EditTrack.initial dims
    , showProfile = ShowProfile.initial player
    , game = Game.initial
    , listDrafts = ListDrafts.initial
    }
  }
