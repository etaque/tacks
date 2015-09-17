module Game.Render.Utils where

import Game.Models exposing (..)

import String as S
import Text as T
import List exposing (..)
import Time exposing (..)
import Graphics.Collage as C
import Graphics.Element as E
import Color exposing (rgb, white)


startCountdownMessage = "press C to start countdown (30s)"

emptyForm = C.toForm E.empty

-- colors =
--   { seaBlue = rgb 147 202 223
--   , water = rgb 147 202 223
--   , sand = rgb 242 243 196
--   , grass = rgb 200 230 180
--   , rock = rgb 160 146 159
--   , gateMark = white
--   , gateLine = rgb 200 130 170
--   , orange = rgb 200 130 170
--   , green = rgb 100 180 106
--   }

baseText : String -> T.Text
baseText s = s
  |> T.fromString
  |> T.height 15
  |> T.typeface ["Inconsolata", "monospace"]

bigText : String -> T.Text
bigText s = s
  |> T.fromString
  |> T.height 32
  |> T.typeface ["Inconsolata", "monospace"]


fixedLength : Int -> String -> String
fixedLength l txt =
  if S.length txt < l then
    S.padRight l ' ' txt
  else
    S.left (l - 3) txt ++ "..."

formatTimer : Time -> Bool -> String
formatTimer t showMs =
  let
    t' = t |> ceiling |> abs
    totalSeconds = t' // 1000
    minutes = totalSeconds // 60
    seconds = if showMs || t <= 0 then totalSeconds `rem` 60 else (totalSeconds `rem` 60) + 1
    millis = t' `rem` 1000
    sMinutes = toString minutes
    sSeconds = S.padLeft 2 '0' (toString seconds)
    sMillis = if showMs then "." ++ (S.padLeft 3 '0' (toString millis)) else ""
  in
    sMinutes ++ ":" ++ sSeconds ++ sMillis


gameTitle : GameState -> String
gameTitle {startTime,now,opponents} =
  case startTime of
    Just t ->
      if now < t then
        formatTimer (t - now) False
      else
        "Started"
    Nothing ->
      "(" ++ toString (1 + length opponents) ++ ") Waiting..."
