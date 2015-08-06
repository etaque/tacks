module Requests where

import Models exposing (..)


type Request
  = UpdatePlayer Player
  | RedirectTo String
