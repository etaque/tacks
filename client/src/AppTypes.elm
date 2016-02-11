module AppTypes where

import Task exposing (Task)
import Effects exposing (Effects)
import DragAndDrop exposing (MouseEvent)
import Response exposing (..)

import Models exposing (..)

import Page.Home.Model as Home
import Page.Login.Model as Login
import Page.Register.Model as Register
import Page.ShowTrack.Model as ShowTrack
import Page.EditTrack.Model as EditTrack
import Page.ShowProfile.Model as ShowProfile
import Page.Game.Model as Game
import Page.ListDrafts.Model as ListDrafts
import Page.Admin.Model as Admin

import Route
import Transit
import TransitRouter exposing (WithRoute)


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

type alias AppResponse = Response AppState AppAction

effect : a -> Effects a
effect =
  Task.succeed >> Effects.task

type AppAction
  = SetPlayer Player
  | RouterAction (TransitRouter.Action Route.Route)
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


type alias AppState = WithRoute Route.Route
  { player : Player
  , dims : Dims
  , routeTransition : Route.RouteTransition
  , screens : Screens
  }

type alias Context =
  { player : Player
  , dims : (Int, Int)
  , transition : Transit.Transition
  , routeTransition : Route.RouteTransition
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
  { player = player
  , dims = dims
  , transitRouter = TransitRouter.empty Route.EmptyRoute
  , routeTransition = Route.None
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
