module Game.Steps.WindHistory exposing (..)

import Time exposing (Time)
import Game.Models exposing (..)


windHistoryStep : GameState -> GameState
windHistoryStep ({ playerState, windHistory } as gameState) =
    let
        newWindHistory =
            takeSample playerState windHistory
                |> keepInWindow playerState.time
    in
        { gameState | windHistory = newWindHistory }


takeSample : PlayerState -> WindHistory -> WindHistory
takeSample { time, windOrigin, windSpeed } h =
    if time - h.lastSample > windHistorySampling then
        { h | samples = (WindSample windOrigin windSpeed time) :: h.samples, lastSample = time }
    else
        h


keepInWindow : Time -> WindHistory -> WindHistory
keepInWindow now h =
    let
        minTime =
            now - windHistoryLength

        samples =
            List.filter (\{ time } -> time > minTime) h.samples
    in
        { h | samples = samples }
