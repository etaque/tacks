module Models where

import Time exposing (Time)

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
  , playerIds : List String
  , leaderboard : List PlayerTally
  }

type alias PlayerTally =
  { playerId : String
  , playerHandle : Maybe String
  , gates : List Time
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
  , laps : Int
  , islands : List Island
  , area : RaceArea
  , windGenerator : WindGenerator
  }

type alias Gate =
  { y : Float
  , width : Float
  }

type alias Island =
  { location : Point
  , radius : Float
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

type alias Segment = (Point, Point)
