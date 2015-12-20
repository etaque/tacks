module Encoders where

import Models exposing (..)

import Dict exposing (Dict)
import Json.Decode exposing (..)
import Json.Encode as Js


(=>) = (,)

courseEncoder : Course -> Value
courseEncoder course =
  Js.object
    [ "upwind" => gateEncoder course.upwind
    , "downwind" => gateEncoder course.downwind
    , "grid" => gridEncoder course.grid
    , "laps" => Js.int course.laps
    , "area" => areaEncoder course.area
    , "windSpeed" => Js.int course.windSpeed
    , "windGenerator" => windGeneratorEncoder course.windGenerator
    , "gustGenerator" => gustGeneratorEncoder course.gustGenerator
    ]

gateEncoder : Gate -> Value
gateEncoder gate =
  Js.object
    [ "y" => Js.float gate.y
    , "width" => Js.float gate.width
    ]

gridEncoder : Grid -> Value
gridEncoder grid =
  dictEncoder Js.int gridRowEncoder grid

gridRowEncoder : GridRow -> Value
gridRowEncoder row =
  dictEncoder Js.int tileKindEncoder row

tileKindEncoder : TileKind -> Value
tileKindEncoder kind =
  Js.string <| case kind of
    Water -> "W"
    Grass -> "G"
    Rock -> "R"

areaEncoder : RaceArea -> Value
areaEncoder a =
  Js.object
    [ "rightTop" => pointEncoder a.rightTop
    , "leftBottom" => pointEncoder a.leftBottom
    ]

pointEncoder : Point -> Value
pointEncoder (x, y) =
  Js.list <| List.map Js.float [ x, y ]

windGeneratorEncoder : WindGenerator -> Value
windGeneratorEncoder g =
  Js.object
    [ "wavelength1" => Js.int g.wavelength1
    , "amplitude1" => Js.int g.amplitude1
    , "wavelength2" => Js.int g.wavelength2
    , "amplitude2" => Js.int g.amplitude2
    ]

gustGeneratorEncoder : GustGenerator -> Value
gustGeneratorEncoder g =
  Js.object
    [ "interval" => Js.int g.interval
    , "radiusBase" => Js.int g.radiusBase
    , "radiusVariation" => Js.int g.radiusVariation
    , "speedVariation" => rangeEncoder g.speedVariation
    , "originVariation" => rangeEncoder g.originVariation
    ]

rangeEncoder : Range -> Value
rangeEncoder r =
  Js.object [ "start" => Js.int r.start, "end" => Js.int r.end ]

dictEncoder : (comparable -> Value) -> (v -> Value) -> Dict comparable v -> Value
dictEncoder encodeKey encodeValue dict =
  let
    encodeField (k, v) = Js.list [ encodeKey k, encodeValue v ]
    fields = dict
      |> Dict.toList
      |> List.map encodeField
  in
    Js.list fields

