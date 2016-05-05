module View.Track (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model.Shared exposing (..)
import Route exposing (..)
import Page.Home.Model exposing (..)
import Page.Home.Update exposing (addr)
import View.Utils as Utils exposing (..)


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
          ([ classList
              [ ( "live-track", True )
              , ( "has-focus", hasFocus )
              , ( "is-empty", empty )
              ]
           , onMouseOver addr (FocusTrack (Just track.id))
           , onMouseOut addr (FocusTrack Nothing)
           ]
            ++ (linkAttrs (PlayTrack track.id))
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
              [ linkTo
                  (ShowTrack track.id)
                  [ class "btn-flat" ]
                  [ text <| "See " ++ toString (List.length meta.rankings) ++ " entries"
                  ]
              ]
          ]
      ]


rankingsExtract : List Ranking -> Html
rankingsExtract rankings =
  ul
    [ class "list-unstyled list-rankings"
    ]
    (List.take 3 rankings |> List.map rankingItem)
