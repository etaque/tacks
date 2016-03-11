module Encoders (..) where

import Model.Shared exposing (..)
import Dict exposing (Dict)
import Json.Decode exposing (..)
import Json.Encode as Js


(=>) =
  (,)


courseEncoder : Course -> Value
courseEncoder course =
  Js.object
    [ "start" => gateEncoder course.start
    , "gates" => Js.list (List.map gateEncoder course.gates)
    , "grid" => gridEncoder course.grid
    , "area" => areaEncoder course.area
    , "windSpeed" => Js.int course.windSpeed
    , "windGenerator" => windGeneratorEncoder course.windGenerator
    , "gustGenerator" => gustGeneratorEncoder course.gustGenerator
    ]


gateEncoder : Gate -> Value
gateEncoder gate =
  Js.object
    [ "label" => (Maybe.map Js.string gate.label |> Maybe.withDefault Js.null)
    , "center" => pointEncoder gate.center
    , "width" => Js.float gate.width
    , "orientation" => orientationEncoder gate.orientation
    ]


orientationEncoder : Orientation -> Value
orientationEncoder o =
  Js.string
    (case o of
      North ->
        "N"

      South ->
        "S"
    )


gridEncoder : Grid -> Value
gridEncoder grid =
  dictEncoder (\( i, j ) -> Js.list [ Js.int i, Js.int j ]) tileKindEncoder grid


tileKindEncoder : TileKind -> Value
tileKindEncoder kind =
  Js.string
    (case kind of
      Water ->
        "W"

      Grass ->
        "G"

      Rock ->
        "R"
    )


areaEncoder : RaceArea -> Value
areaEncoder a =
  Js.object
    [ "rightTop" => pointEncoder a.rightTop
    , "leftBottom" => pointEncoder a.leftBottom
    ]


pointEncoder : Point -> Value
pointEncoder ( x, y ) =
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
    encodeField ( k, v ) =
      Js.list [ encodeKey k, encodeValue v ]

    fields =
      dict
        |> Dict.toList
        |> List.map encodeField
  in
    Js.list fields
