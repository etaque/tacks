module Model (..) where

import Task exposing (Task)
import Effects exposing (Effects)
import Drag exposing (MouseEvent)
import Model.Shared exposing (..)
import Page.Home.Model as Home
import Page.Login.Model as Login
import Page.Register.Model as Register
import Page.Explore.Model as Explore
import Page.ShowTrack.Model as ShowTrack
import Page.EditTrack.Model as EditTrack
import Page.ShowProfile.Model as ShowProfile
import Page.Game.Model as Game
import Page.ListDrafts.Model as ListDrafts
import Page.Forum.Model as Forum
import Page.Admin.Model as Admin
import Route
import TransitRouter exposing (WithRoute)


appActionsMailbox : Signal.Mailbox Action
appActionsMailbox =
  Signal.mailbox NoOp


appActionsAddress : Signal.Address Action
appActionsAddress =
  appActionsMailbox.address


(?) : Maybe a -> a -> a
(?) maybe default =
  Maybe.withDefault default maybe
infixr 9 ?


type alias AppSetup =
  { player : Player
  , path : String
  , dims : ( Int, Int )
  }


effect : a -> Effects a
effect =
  Task.succeed >> Effects.task


type Action
  = SetPlayer Player
  | SetLiveStatus (Result () LiveStatus)
  | RouterAction (TransitRouter.Action Route.Route)
  | UpdateDims ( Int, Int )
  | MouseEvent MouseEvent
  | PageAction PageAction
  | Logout
  | NoOp


type PageAction
  = HomeAction Home.Action
  | LoginAction Login.Action
  | RegisterAction Register.Action
  | ExploreAction Explore.Action
  | ShowTrackAction ShowTrack.Action
  | EditTrackAction EditTrack.Action
  | ShowProfileAction ShowProfile.Action
  | GameAction Game.Action
  | ListDraftsAction ListDrafts.Action
  | ForumAction Forum.Action
  | AdminAction Admin.Action


type alias Model =
  WithRoute
    Route.Route
    { player : Player
    , liveStatus : LiveStatus
    , dims : Dims
    , routeTransition : Route.RouteTransition
    , pages : Pages
    }


type alias Pages =
  { home : Home.Model
  , login : Login.Model
  , register : Register.Model
  , explore : Explore.Model
  , showTrack : ShowTrack.Model
  , editTrack : EditTrack.Model
  , showProfile : ShowProfile.Model
  , game : Game.Model
  , listDrafts : ListDrafts.Model
  , forum : Forum.Model
  , admin : Admin.Model
  }


initialModel : AppSetup -> Model
initialModel { path, dims, player } =
  { player = player
  , liveStatus = { liveTracks = [], onlinePlayers = [] }
  , dims = dims
  , transitRouter = TransitRouter.empty Route.EmptyRoute
  , routeTransition = Route.None
  , pages =
      { home = Home.initial
      , login = Login.initial
      , register = Register.initial
      , explore = Explore.initial
      , showTrack = ShowTrack.initial
      , editTrack = EditTrack.initial
      , showProfile = ShowProfile.initial player
      , game = Game.initial
      , listDrafts = ListDrafts.initial
      , forum = Forum.initial
      , admin = Admin.initial
      }
  }
