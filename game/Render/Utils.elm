module Render.Utils where

import String
import Text

helpMessage : String
helpMessage = "←/→ to turn left/right, ↓←/↓→ to fine tune direction, ↑ or ENTER to lock angle to wind, SPACE to tack/jibe"

colors = { seaBlue = rgb 10 105 148,
           sand = rgb 239 210 121 }

fullScreenMessage : String -> Form
fullScreenMessage msg = msg
  |> String.toUpper 
  |> toText 
  |> Text.height 60 
  |> Text.color white 
  |> centered 
  |> toForm 
  |> alpha 0.3

baseText : String -> Text
baseText s = s
  |> toText
  |> Text.height 14
  |> Text.color white
  |> monospace