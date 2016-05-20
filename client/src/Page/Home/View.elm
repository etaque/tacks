module Page.Home.View exposing (..)

import Html.App exposing (map)
import Html exposing (..)
import Html.Attributes exposing (..)
import Model.Shared exposing (..)
import Route exposing (..)
import Page.Home.Model exposing (..)
import View.Utils as Utils exposing (..)
import View.Layout as Layout
import View.Race as Race
import View.Track as Track
import Dialog


pageTitle : LiveStatus -> Model -> String
pageTitle liveStatus model =
  let
    playersCount =
      List.concatMap liveTrackPlayers liveStatus.liveTracks |> List.length
  in
    if playersCount > 0 then
      "(" ++ toString playersCount ++ ") Home"
    else
      "Home"


view : Context -> Model -> Layout.Site Msg
view ctx model =
  Layout.Site
    "home"
    (Just Layout.Home)
    [ Layout.header
        ctx
        []
        [ h1 [] [ text "Sailing tactics from the sofa" ]
        , p
            [ class "subtitle" ]
            [ text "Tacks is a free regatta simulation game. Engage yourself in a realtime multiplayer race or attempt to break your best time to climb the rankings." ]
        ]
    , Layout.section
        [ class "white inside" ]
        [ div
            [ class "row live-center" ]
            [ div [ class "col-md-9" ] [ liveTracks ctx.player ctx.liveStatus ]
            , div [ class "col-md-3" ] [ activePlayers ctx.liveStatus.liveTracks ]
            ]
        ]
    , Layout.section
        [ class "grey" ]
        [ h2 [] [ text "Recent races" ]
        , Race.reports True reportClickHandler model.raceReports
        ]
    , map DialogMsg (Dialog.view model.dialog (dialogContent model))
    ]


dialogContent : Model -> Dialog.Layout
dialogContent model =
  case model.showDialog of
    Empty ->
      Dialog.emptyLayout

    RankingDialog liveTrack ->
      Track.rankingDialog liveTrack

    ReportDialog raceReport ->
      Race.reportDialog raceReport


liveTracks : Player -> LiveStatus -> Html Msg
liveTracks player { liveTracks } =
  let
    featuredTracks =
      List.filter (.track >> .featured) liveTracks
  in
    div
      [ class "live-tracks" ]
      [ h2 [] [ text "Featured tracks" ]
      , div [ class "row" ] (List.map (Track.liveTrackBlock rankingClickHandler) featuredTracks)
      ]


rankingClickHandler : LiveTrack -> Attribute Msg
rankingClickHandler liveTrack =
  onButtonClick (ShowDialog (RankingDialog liveTrack))


reportClickHandler : RaceReport -> Attribute Msg
reportClickHandler report =
  onButtonClick (ShowDialog (ReportDialog report))


activePlayers : List LiveTrack -> Html Msg
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


activeTrackPlayers : LiveTrack -> Html Msg
activeTrackPlayers { track, players } =
  linkTo
    (PlayTrack track.id)
    [ class "active-track-players" ]
    [ h4 [] [ text track.name ]
    , playersList players
    ]


playersList : List Player -> Html Msg
playersList players =
  ul
    [ class "list-unstyled live-players" ]
    (List.map playerItem players)


playerItem : Player -> Html Msg
playerItem player =
  li
    [ class "player" ]
    [ Utils.playerWithAvatar player ]
