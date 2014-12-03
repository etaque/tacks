module Render.Utils where

import String as S
import Text
import Game

helpMessage = "←/→ to turn left/right, SHIFT + ←/→ to fine tune direction, \n" ++
  "ENTER to lock angle to wind, SPACE to tack/jibe, S to cast a spell"

startCountdownMessage = "press C to start countdown (60s)"

emptyForm = toForm empty

colors =
  { seaBlue = rgb 35 57 92
  , sand = rgb 224 163 73
  , gateMark = white
  , gateLine = rgb 234 99 68
  , orange = rgb 234 99 68
  , green = rgb 100 180 106
  }

baseText : String -> Text
baseText s = s
  |> toText
  |> Text.height 15
  |> typeface ["Inconsolata", "monospace"]

bigText : String -> Text
bigText s = s
  |> toText
  |> Text.height 32
  |> typeface ["Inconsolata", "monospace"]


fixedLength : Int -> String -> String
fixedLength l txt =
  if S.length txt < l then
    S.padRight l ' ' txt
  else
    S.left (l - 3) txt ++ "..."

formatCountdown : Time -> String
formatCountdown c =
  let cs = c |> inSeconds |> ceiling
      m = cs // 60
      s = cs `rem` 60
  in  (show m) ++ "' " ++ (show s) ++ "\""

gameTitle : Game.GameState -> String
gameTitle {countdown,opponents,watchMode} = case countdown of
  Just c ->
    if c > 0 then formatCountdown c else "Started"
  Nothing -> case watchMode of
    Game.Watching _  -> "Waiting..."
    Game.NotWatching -> "(" ++ show (1 + length opponents) ++ ") Waiting..."
