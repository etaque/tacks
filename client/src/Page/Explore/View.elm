module Page.Explore.View (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model.Shared exposing (..)
import Page.Explore.Model exposing (..)
import View.Layout as Layout
import View.Track as Track


view : Context -> Model -> Html
view ctx model =
  Layout.siteLayout
    "explore"
    ctx
    (Just Layout.Explore)
    [ Layout.header
        ctx
        []
        [ h1 [] [ text "All tracks" ] ]
    , Layout.section
        [ class "white manage-tracks" ]
        [ liveTracks ctx.liveStatus.liveTracks ]
    ]


liveTracks : List LiveTrack -> Html
liveTracks liveTracks =
  div
    [ class "live-tracks" ]
    [ div [ class "row" ] (List.map Track.liveTrackBlock liveTracks)
    ]
