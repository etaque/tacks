module Models where

import Time exposing (Time)
import Dict exposing (Dict)

type alias Player =
  { id:     String
  , handle: Maybe String
  , status: Maybe String
  , avatarId: Maybe String
  , vmgMagnet: Int
  , guest: Bool
  , user: Bool
  }


type alias LiveStatus =
  { liveTracks : List LiveTrack
  , onlinePlayers : List Player
  }


type alias LiveTrack =
  { track: Track
  , players: List Player
  , races: List Race
  , rankings : List Ranking
  }

type alias Track =
  { id: String
  , slug: String
  , course: Course
  , countdown: Int
  , startCycle: Int
  }

type alias Race =
  { id : String
  , trackId : String
  , startTime : Time
  , players : List Player
  , tallies : List PlayerTally
  }

type alias PlayerTally =
  { player : Player
  , gates : List Time
  , finished : Bool
  }

type alias Ranking =
  { rank : Int
  , player : Player
  , finishTime : Time
  }

type alias Message =
  { content : String
  , player : Player
  , time : Float
  }


-- Course

type alias Course =
  { upwind : Gate
  , downwind : Gate
  , grid : Grid
  , laps : Int
  , area : RaceArea
  , windGenerator : WindGenerator
  }

type alias Gate =
  { y : Float
  , width : Float
  }

type alias RaceArea =
  { rightTop : Point
  , leftBottom : Point
  }

type GateLocation
  = DownwindGate
  | UpwindGate
  | StartLine

type alias WindGenerator =
  { wavelength1: Float
  , amplitude1: Float
  , wavelength2: Float
  , amplitude2: Float
  }

type alias Point = (Float, Float)

type alias Dims = (Int, Int)

type alias Segment = (Point, Point)

type alias Coords = (Int, Int)

type alias Cube number = (number, number, number)

-- Grid

type alias Grid = Dict Int GridRow
type alias GridRow = Dict Int TileKind

type alias Tile =
  { kind : TileKind
  , coords : Coords
  }

type TileKind = Water | Grass | Rock


