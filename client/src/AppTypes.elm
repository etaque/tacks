module AppTypes where

import Task exposing (Task)
import Effects exposing (Effects)
import DragAndDrop exposing (MouseEvent)

import Models exposing (..)

import Screens.Home.Types as Home
import Screens.Login.Types as Login
import Screens.Register.Types as Register
import Screens.ShowTrack.Types as ShowTrack
import Screens.EditTrack.Types as EditTrack
import Screens.ShowProfile.Types as ShowProfile
import Screens.Game.Types as Game
import Screens.ListDrafts.Types as ListDrafts
import Screens.Admin.Types as Admin

import Routes
import Transit


appActionsMailbox : Signal.Mailbox AppAction
appActionsMailbox =
  Signal.mailbox AppNoOp

appActionsAddress : Signal.Address AppAction
appActionsAddress =
  appActionsMailbox.address


(?) : Maybe a -> a -> a
(?) maybe default =
  Maybe.withDefault default maybe

infixr 9 ?


type alias AppSetup =
  { player : Player
  , path : String
  , dims : (Int, Int)
  }

type alias Response m a = (m, Effects a)
type alias AppResponse = Response AppState AppAction

res : s -> Effects a -> Response s a
res s fx =
  (s, fx)

taskRes : s -> Task Effects.Never a -> Response s a
taskRes s t =
  (s, Effects.task t)

staticRes : s -> Response s a
staticRes s =
  (s, Effects.none)

mapEffects : (fx -> fx') -> Response m fx -> Response m fx'
mapEffects fn (m, fx) =
  (m, Effects.map fn fx)

mapState : (a -> b) -> Response a f -> Response b f
mapState fn (a, fx) =
  (fn a, fx)

effect : a -> Effects a
effect =
  Task.succeed >> Effects.task

type AppAction
  = SetPlayer Player
  | SetPath String
  | PathChanged String
  | MountRoute (Maybe Routes.Route)
  | TransitAction (Transit.Action AppAction)
  | UpdateDims (Int, Int)
  | MouseEvent MouseEvent
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
  | AdminAction Admin.Action


type alias AppState =
  { ctx : Context
  , route : Maybe Routes.Route
  , path : String
  , screens : Screens
  }

type alias Context = Transit.WithTransition
  { player : Player
  , dims : (Int, Int)
  }

type alias Screens =
  { home : Home.Screen
  , login : Login.Screen
  , register : Register.Screen
  , showTrack : ShowTrack.Screen
  , editTrack : EditTrack.Screen
  , showProfile : ShowProfile.Screen
  , game : Game.Screen
  , listDrafts: ListDrafts.Screen
  , admin: Admin.Screen
  }


initialAppState : AppSetup -> AppState
initialAppState { path, dims, player } =
  { ctx =
      { player = player
      , dims = dims
      , transition = Transit.initial
      }
  , path = path
  , route = Nothing
  , screens =
    { home = Home.initial player
    , login = Login.initial
    , register = Register.initial
    , showTrack = ShowTrack.initial
    , editTrack = EditTrack.initial
    , showProfile = ShowProfile.initial player
    , game = Game.initial
    , listDrafts = ListDrafts.initial
    , admin = Admin.initial
    }
  }
