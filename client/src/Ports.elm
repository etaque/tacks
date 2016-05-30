port module Ports exposing (..)

port setFocus : String -> Cmd msg

port setBlur : String -> Cmd msg

port scrollToBottom : String -> Cmd msg
