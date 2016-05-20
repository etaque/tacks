module Main exposing (..)

import Html.App as Html
import Update
import View
import Model


-- Inputs


-- port appSetup : AppSetup


-- port raceInput : Signal (Maybe GameInputs.RaceInput)


-- port gameActionsInput : Signal Json.Value



-- Wiring


main : Program Model.Setup
main =
  Html.programWithFlags
    { init = Update.init
    , update = Update.update
    , view = View.view
    , subscriptions = Update.subscriptions
    -- , inputs =
    --     [ map RouterAction TransitRouter.actions
    --     , map UpdateDims Window.dimensions
    --     , map MouseEvent mouseEvents
    --     , appActionsMailbox.signal
    --     , raceUpdateActions
    --     , gameActions
    --     , map (EditTrackAction >> PageAction) EditTrack.inputs
    --     ]
    }


-- Complex signals


-- rawInput : Signal ( GameInputs.KeyboardInput, ( Int, Int ), Maybe GameInputs.RaceInput )
-- rawInput =
--   Signal.map3 (,,) GameInputs.keyboardInput Window.dimensions raceInput


-- raceUpdateActions : Signal Action
-- raceUpdateActions =
--   Signal.map2 GameInputs.buildGameInput rawInput clock
--     |> Signal.filterMap (Maybe.map (GameModel.GameUpdate >> GameAction >> PageAction)) Model.NoOp
--     |> Signal.sampleOn clock
--     |> Signal.dropRepeats


-- gameActions : Signal Action
-- gameActions =
--   Signal.map (GameDecoders.decodeAction >> GameAction >> PageAction) gameActionsInput


-- clock : Signal GameInputs.Clock
-- clock =
--   Signal.map (\( time, delta ) -> { time = time, delta = delta }) (timestamp (fps 30))



-- -- Outputs


-- port playerOutput : Signal (Maybe GameOutputs.PlayerOutput)
-- port playerOutput =
--   Signal.map2 GameOutputs.extractPlayerOutput app.model raceUpdateActions
--     |> Signal.dropRepeats


-- port activeTrack : Signal (Maybe String)
-- port activeTrack =
--   Signal.map GameOutputs.getActiveTrack app.model
--     |> Signal.dropRepeats


-- port serverActions : Signal Json.Value
-- port serverActions =
--   Signal.map GameOutputs.encodeServerAction serverMailbox.signal

-- -- port ghostMessages : Signal Json.Value
-- -- port ghostMessages =
-- --   Signal.filterMap GameOutputs.ghosts JsonEncode.null appActionsMailbox.signal


-- -- port chatOutput : Signal String
-- -- port chatOutput =
-- --   chat.signal


-- port chatScrollDown : Signal ()
-- port chatScrollDown =
--   Signal.filterMap GameOutputs.needChatScrollDown () gameActions

-- port title : Signal String
-- port title =
--   Signal.map View.pageTitle app.model
