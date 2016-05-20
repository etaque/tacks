module View.Track exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model.Shared exposing (..)
import Route
import View.Utils as Utils
import Dialog


liveTrackBlock : (LiveTrack -> Attribute msg) -> LiveTrack -> Html msg
liveTrackBlock rankingClickHandler ({ track, meta, players } as lt) =
  let
    empty =
      List.length players == 0
  in
    div
      [ class "col-md-6" ]
      [ div
          ([ classList
              [ ( "live-track", True )
              , ( "is-empty", empty )
              ]
           ]
            ++ (Utils.linkAttrs (Route.PlayTrack track.id))
          )
          [ div
              [ class "live-track-header" ]
              [ h3
                  [ class "name", title track.name ]
                  [ text track.name ]
              , div
                  [ class "creator" ]
                  [ text ("by " ++ (Maybe.withDefault "" meta.creator.handle)) ]
              , if empty then
                  text ""
                else
                  span [ class "live-players" ] [ text (toString (List.length players)) ]
              ]
          , div
              [ class "live-track-body"
              ]
              [ rankingsExtract meta.rankings
              ]
          , div
              [ class "live-track-actions" ]
              [ a
                  [ class "btn-flat"
                  , rankingClickHandler lt
                  ]
                  [ text <| "See all (" ++ toString (List.length meta.rankings) ++ ")"
                  ]
              ]
          ]
      ]


rankingsExtract : List Ranking -> Html msg
rankingsExtract rankings =
  ul
    [ class "list-unstyled list-rankings"
    ]
    (List.take 3 rankings |> List.map Utils.rankingItem)


rankingDialog : LiveTrack -> Dialog.Layout
rankingDialog liveTrack =
  { header = [ Dialog.title liveTrack.track.name ]
  , body =
      [ ul
          [ class "list-unstyled list-rankings" ]
          (List.map Utils.rankingItem liveTrack.meta.rankings)
      ]
  , footer = []
  }
