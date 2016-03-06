module Page.Home.View (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model.Shared exposing (..)
import Route exposing (..)
import Page.Home.Model exposing (..)
import Page.Home.Update exposing (addr)
import View.Utils exposing (..)
import View.Layout as Layout


view : Context -> Model -> Html
view ctx model =
  Layout.layoutWithNav
    "home"
    ctx
    [ container
        ""
        [ intro
        , welcomeForm ctx.player model.handle
        , div
            [ class "row live-center" ]
            [ div [ class "col-md-9" ] [ liveTracks ctx.player model.liveStatus model.trackFocus ]
            , div [ class "col-md-3" ] [ activePlayers model.liveStatus.liveTracks ]
            ]
        ]
    ]


intro : Html
intro =
  fullWidth
    [ h1 [ class "align-center" ] [ text "Sailing tactics from the sofa" ]
    , p [ class "subtitle align-center" ] [ text "Tracks is a free regatta simulation game. Engage yourself in a realtime multiplayer race or attempt to break your best time to climb the rankings." ]
    ]


welcomeForm : Player -> String -> Html
welcomeForm player handle =
  if player.guest then
    setHandleBlock handle
  else
    div [] []


setHandleBlock : String -> Html
setHandleBlock handle =
  div
    [ class "form-inline form-set-handle align-center" ]
    [ formGroup
        False
        [ textInput
            [ placeholder "Got a nickname?"
            , value handle
            , onInput addr SetHandle
            , onEnter addr SubmitHandle
            ]
        ]
    , button
        [ class "btn btn-primary"
        , onClick addr SubmitHandle
        ]
        [ text "submit" ]
    , linkTo Login [ class "btn btn-default" ] [ text "or log in" ]
    ]


liveTracks : Player -> LiveStatus -> Maybe TrackId -> Html
liveTracks player { liveTracks } maybeTrackId =
  div
    [ class "live-tracks" ]
    [ h2 [] [ text "Sailing tracks" ]
    , div [ class "row" ] (List.map (liveTrackBlock maybeTrackId) liveTracks)
    ]


liveTrackBlock : Maybe TrackId -> LiveTrack -> Html
liveTrackBlock maybeTrackId ({ track, meta, players } as lt) =
  let
    hasFocus =
      maybeTrackId == Just track.id

    empty =
      List.length players == 0
  in
    div
      [ class "col-md-6" ]
      [ div
          [ classList [ ( "live-track", True ), ( "has-focus", hasFocus ), ( "is-empty", empty ) ] ]
          [ h3
              []
              [ linkTo (ShowTrack track.id) [ class "name", title track.name ] [ text track.name ]
              ]
          , div
              [ class "info" ]
              [ rankingsExtract meta.rankings
              , div
                  [ class "rankings-size" ]
                  [ text <| toString (List.length meta.rankings) ++ " entries" ]
              , linkTo
                  (PlayTrack track.id)
                  [ class
                      <| "btn btn-block btn-join btn-"
                      ++ if empty then
                          "default"
                         else
                          "warning"
                  , onMouseOver addr (FocusTrack (Just track.id))
                  , onMouseOut addr (FocusTrack Nothing)
                  ]
                  [ text
                      (if empty then
                        "play"
                       else
                        "join (" ++ toString (List.length players) ++ ")"
                      )
                  ]
              ]
          ]
      ]


rankingsExtract : List Ranking -> Html
rankingsExtract rankings =
  ul [ class "list-unstyled list-rankings" ] (List.map rankingItem rankings)


activePlayers : List LiveTrack -> Html
activePlayers liveTracks =
  let
    activeLiveTracks =
      liveTracks
        |> List.filter (\lt -> not (List.isEmpty lt.players))
        |> List.sortBy (\lt -> List.length lt.players)
        |> List.reverse

    content =
      if List.isEmpty activeLiveTracks then
        [ div [ class "empty" ] [ text "Nobody's playing right now." ] ]
      else
        List.map activeTrackPlayers activeLiveTracks
  in
    div [ class "active-players" ]
      <| h2 [] [ text "Online players" ]
      :: content


activeTrackPlayers : LiveTrack -> Html
activeTrackPlayers { track, players } =
  linkTo
    (PlayTrack track.id)
    [ class "active-track-players" ]
    [ h4 [] [ text track.name ]
    , playersList players
    ]


playersList : List Player -> Html
playersList players =
  ul [ class "list-unstyled live-players" ] (List.map playerItem players)


playerItem : Player -> Html
playerItem player =
  li [ class "player" ] [ text (playerHandle player) ]
