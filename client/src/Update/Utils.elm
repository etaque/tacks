module Update.Utils exposing (..)




always : msg -> Cmd a -> Cmd msg
always msg effect =
  Cmd.map (\_ -> msg) effect

