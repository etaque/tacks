module Screens.Messages where

import AppTypes exposing (..)

trackName : String -> String
trackName slug =
  case slug of
    "warmup"  -> "Short Track"
    "classic" -> "Classic"
    "inlands" -> "Inlands"
    _         -> "?"

trackDesc : String -> String
trackDesc slug =
  case slug of
    "warmup"  -> "get your hands warm with the three laps of this short course"
    "classic" -> "back to basics: some islands and gusts on a two laps course"
    "inlands" -> "a narrow course with many gusts & lulls, your favorite inland spot"
    _         -> "?"
