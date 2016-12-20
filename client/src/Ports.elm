port module Ports exposing (..)


port setFocus : String -> Cmd msg


port setBlur : String -> Cmd msg


port scrollToBottom : String -> Cmd msg


port notify : String -> Cmd msg


port deviceOrientation : ({ alpha : Float, beta : Float, gamma : Float } -> msg) -> Sub msg
