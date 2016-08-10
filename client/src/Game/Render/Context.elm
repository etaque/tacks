module Game.Render.Context exposing (..)

import Dict exposing (Dict)
import Html.App as Html
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model.Shared exposing (..)
import Game.Models exposing (GameState, Timers, isStarted, raceTime)
import CoreExtra
import View.Utils as Utils


raceStatus : GameState -> msg -> msg -> List (Html msg)
raceStatus ({ timers, playerState } as gameState) startMsg exitMsg =
  case timers.startTime of
    Just startTime ->
      let
        timer =
          playerState.nextGate
            |> Maybe.map (\_ -> startTime - timers.serverTime)
            |> Maybe.withDefault (List.head playerState.crossedGates |> Maybe.withDefault 0)

        hasFinished =
          CoreExtra.isNothing playerState.nextGate
      in
        [ div
            [ classList
                [ ( "timer", True )
                , ( "is-started", isStarted gameState )
                ]
            ]
            [ span
                [ style [ ( "opacity", toString (timerOpacity gameState) ) ]
                ]
                [ text (Utils.formatTimer hasFinished timer) ]
            , if List.isEmpty playerState.crossedGates then
                text ""
              else
                a
                  [ onClick exitMsg
                  , class "exit-race"
                  , title "Exit race"
                  ]
                  [ Utils.mIcon "cancel" []
                  ]
            ]
        ]

    Nothing ->
      [ a
          [ onClick startMsg
          , class "btn-floating btn-warn start-race"
          , title "Start race"
          ]
          [ Utils.mIcon "play_arrow" []
          ]
      ]


timerOpacity : GameState -> Float
timerOpacity gameState =
  if isStarted gameState then
    0.6
  else
    let
      ms =
        floor (raceTime gameState) % 1000
    in
      if ms < 500 then
        1
      else
        (1000 - toFloat ms) / 500


rankingsBlock : Dict String Player -> (Ranking -> msg) -> (Ranking -> msg) -> TrackMeta -> Html msg
rankingsBlock ghostRuns doAdd doRemove meta =
  div
    [ class "aside-module module-rankings" ]
    [ ul
        [ class "list-unstyled list-rankings" ]
        (List.map (rankingItem (\runId -> Dict.member runId ghostRuns) doAdd doRemove) meta.rankings)
    , if Dict.isEmpty ghostRuns then
        div
          [ class "empty" ]
          [ text "Click on a player to add its ghost run." ]
      else
        text ""
    ]


rankingItem : (String -> Bool) -> (Ranking -> msg) -> (Ranking -> msg) -> Ranking -> Html msg
rankingItem isGhost doAdd doRemove ranking =
  let
    attrs =
      if isGhost ranking.runId then
        [ class "ranking remove-ghost"
        , onClick (doRemove ranking)
        , title "Remove from ghosts"
        ]
      else
        [ class "ranking add-ghost"
        , onClick (doAdd ranking)
        , title "Add to ghosts"
        ]
  in
    li
      attrs
      [ span [ class "rank" ] [ text (toString ranking.rank) ]
      , span [ class "time" ] [ text (Utils.formatTimer True ranking.finishTime) ]
      , Utils.playerWithAvatar ranking.player
      ]


helpBlock : Html msg
helpBlock =
  div
    [ class "aside-module module-help" ]
    [ dl [] helpItems ]


helpItems : List (Html msg)
helpItems =
  let
    items =
      [ ( "left/right", "turn" )
      , ( "left/right + shift", "adjust" )
      , ( "up", "lock angle to wind" )
      , ( "space", "tack or jibe" )
      ]
  in
    List.concatMap helpItem items


helpItem : ( String, String ) -> List (Html msg)
helpItem ( keys, role ) =
  [ dt [] [ text role ], dd [] [ text keys ] ]
