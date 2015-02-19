module Steps.Vmg where

import Game (..)
import Geo (..)
import Core (..)
import Steps.Util (..)

import Maybe as M
import List as L


vmgStep : PlayerState -> PlayerState
vmgStep state =
  let
    vmgValue = getVmgValue state.windAngle state.velocity
    upwindVmg = getUpwindVmg state.windSpeed
    downwindVmg = getDownwindVmg state.windSpeed
  in
    { state
      | vmgValue <- vmgValue
      , upwindVmg <- upwindVmg
      , downwindVmg <- downwindVmg
    }

makeVmg : Float -> Float -> Vmg
makeVmg windSpeed windAngle =
  let
    boatSpeed = polarSpeed windSpeed windAngle
    value = getVmgValue windAngle boatSpeed
  in
    { angle = windAngle
    , speed = windSpeed
    , value = value
    }

getVmgValue : Float -> Float -> Float
getVmgValue windAngle boatSpeed =
  abs <| sin (toRadians windAngle) * boatSpeed

getUpwindVmg : Float -> Vmg
getUpwindVmg windSpeed =
  findVmgInInterval windSpeed 40 60

getDownwindVmg : Float -> Vmg
getDownwindVmg windSpeed =
  findVmgInInterval windSpeed 130 150

findVmgInInterval : Float -> Int -> Int -> Vmg
findVmgInInterval windSpeed minAngle maxAngle =
  let
    vmgs = L.map (makeVmg windSpeed) (floatRange minAngle maxAngle)
    bestMaybe = L.sortBy .value vmgs |> L.reverse |> headMaybe
  in
    M.withDefault defaultVmg bestMaybe
