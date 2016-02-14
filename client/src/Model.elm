module Model where

import Task exposing (Task)
import Effects exposing (Effects)
import DragAndDrop exposing (MouseEvent)
import Response exposing (..)

import Model.Shared exposing (..)

import Page.Home.Model as Home
import Page.Login.Model as Login
import Page.Register.Model as Register
import Page.ShowTrack.Model as ShowTrack
import Page.EditTrack.Model as EditTrack
import Page.ShowProfile.Model as ShowProfile
import Page.Game.Model as Game
import Page.ListDrafts.Model as ListDrafts
import Page.Forum.Model as Forum
import Page.Admin.Model as Admin

import Route
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
  | PageAction PageAction
  | Logout
  | AppNoOp


type PageAction
  = HomeAction Home.Action
  | LoginAction Login.Action
  | RegisterAction Register.Action
  | ShowTrackAction ShowTrack.Action
  | EditTrackAction EditTrack.Action
  | ShowProfileAction ShowProfile.Action
  | GameAction Game.Action
  | ListDraftsAction ListDrafts.Action
  | ForumAction Forum.Action
  | AdminAction Admin.Action


type alias AppState = WithRoute Route.Route
  { player : Player
  , dims : Dims
  , routeTransition : Route.RouteTransition
  , pages : Pages
  }

type alias Pages =
  { home : Home.Model
  , login : Login.Model
  , register : Register.Model
  , showTrack : ShowTrack.Model
  , editTrack : EditTrack.Model
  , showProfile : ShowProfile.Model
  , game : Game.Model
  , listDrafts : ListDrafts.Model
  , forum : Forum.Model
  , admin : Admin.Model
  }


initialAppState : AppSetup -> AppState
initialAppState { path, dims, player } =
  { player = player
  , dims = dims
  , transitRouter = TransitRouter.empty Route.EmptyRoute
  , routeTransition = Route.None
  , pages =
    { home = Home.initial player
    , login = Login.initial
    , register = Register.initial
    , showTrack = ShowTrack.initial
    , editTrack = EditTrack.initial
    , showProfile = ShowProfile.initial player
    , game = Game.initial
    , listDrafts = ListDrafts.initial
    , forum = Forum.initial
    , admin = Admin.initial
    }
  }
