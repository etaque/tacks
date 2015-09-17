module Encoders where

import Models exposing (..)

import Dict exposing (Dict)
import Json.Decode exposing (..)
import Json.Encode as Js


gateEncoder : Gate -> Value
gateEncoder gate =
  Js.object [ ("y", Js.float gate.y), ("width", Js.float gate.width) ]

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

dictEncoder : (comparable -> Value) -> (v -> Value) -> Dict comparable v -> Value
dictEncoder encodeKey encodeValue dict =
  let
    encodeField (k, v) = Js.list [ encodeKey k, encodeValue v ]
    fields = dict
      |> Dict.toList
      |> List.map encodeField
  in
    Js.list fields

