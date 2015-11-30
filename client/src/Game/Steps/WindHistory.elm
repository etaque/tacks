module Game.Steps.WindHistory where

import Time exposing (Time)

import Models exposing (..)
import Game.Models exposing (..)


updateWindHistory : Time -> Wind -> WindHistory -> WindHistory
updateWindHistory now wind h =
  takeSample now wind h
    |> keepInWindow now


takeSample : Time -> Wind -> WindHistory -> WindHistory
takeSample now {origin, speed} h =
  if now - h.lastSample > windHistorySampling then
    { h | samples = (WindSample origin speed now) :: h.samples, lastSample = now }
  else
    h

keepInWindow : Time -> WindHistory -> WindHistory
keepInWindow now h =
  let
    minTime = now - windHistoryLength
    samples = List.filter (\{time} -> time > minTime) h.samples
  in
    { h | samples = samples }

