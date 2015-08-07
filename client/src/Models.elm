module Models where


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
  }

type alias Track =
  { id: String
  , slug: String
  , course: Course
  , countdown: Int
  , startCycle: Int
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
