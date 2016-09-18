module Model exposing (..)

import Model.Shared exposing (..)
import Page.Home.Model as Home
import Page.Login.Model as Login
import Page.Register.Model as Register
import Page.Explore.Model as Explore
import Page.EditTrack.Model as EditTrack
import Page.Game.Model as Game
import Page.PlayTimeTrial.Model as PlayTimeTrial
import Page.ListDrafts.Model as ListDrafts
import Page.Forum.Model as Forum
import Page.Admin.Model as Admin
import Route exposing (Route)
import Window
import Transit
import Activity
import Json.Decode as Json
import Decoders


type alias Setup =
    { player : Player
    , path : String
    , dims : ( Int, Int )
    , host : String
    , rawLiveStatus : Json.Value
    }


type Msg
    = SetPlayer Player
    | ActivityRawReceive String
    | ActivityEmitMsg Activity.EmitMsg
    | WindowResized Window.Size
    | RouteTransition (Transit.Msg Msg)
    | MountRoute Route
    | PageMsg PageMsg
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
    | PlayTimeTrialMsg PlayTimeTrial.Msg
    | ListDraftsMsg ListDrafts.Msg
    | ForumMsg Forum.Msg
    | AdminMsg Admin.Msg


type alias Model =
    Transit.WithTransition
        { route : Route
        , routeJump : Route.RouteJump
        , player : Player
        , liveStatus : LiveStatus
        , dims : Dims
        , pages : Pages
        , host : String
        }


type alias Pages =
    { home : Home.Model
    , login : Login.Model
    , register : Register.Model
    , explore : Explore.Model
    , editTrack : EditTrack.Model
    , game : Game.Model
    , playTimeTrial : PlayTimeTrial.Model
    , listDrafts : ListDrafts.Model
    , forum : Forum.Model
    , admin : Admin.Model
    }


initialModel : Setup -> Model
initialModel setup =
    { route = Route.EmptyRoute
    , routeJump = Route.None
    , transition = Transit.empty
    , player = setup.player
    , liveStatus =
        Json.decodeValue Decoders.liveStatusDecoder setup.rawLiveStatus
            |> Result.withDefault emptyLiveStatus
    , dims = setup.dims
    , pages =
        { home = Home.initial
        , login = Login.initial
        , register = Register.initial
        , explore = Explore.initial
        , editTrack = EditTrack.initial
        , game = Game.initial
        , playTimeTrial = PlayTimeTrial.initial
        , listDrafts = ListDrafts.initial
        , forum = Forum.initial
        , admin = Admin.initial
        }
    , host = setup.host
    }
