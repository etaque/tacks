module Page.Explore.View (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Dialog
import Model.Shared exposing (..)
import Page.Explore.Model exposing (..)
import Page.Explore.Update exposing (addr)
import View.Layout as Layout
import View.Track as Track
import View.Utils as Utils


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
        [ class "white inside manage-tracks" ]
        [ liveTracks ctx.liveStatus.liveTracks ]
    , Dialog.view
        (Signal.forwardTo addr DialogAction)
        model.dialog
        (dialogContent model)
    ]


dialogContent : Model -> Dialog.Layout
dialogContent model =
  model.showTrackRanking
    |> Maybe.map Track.rankingDialog
    |> Maybe.withDefault Dialog.emptyLayout


liveTracks : List LiveTrack -> Html
liveTracks liveTracks =
  div
    [ class "live-tracks" ]
    [ div [ class "row" ] (List.map (Track.liveTrackBlock rankingClickHandler) liveTracks)
    ]


rankingClickHandler : LiveTrack -> Attribute
rankingClickHandler liveTrack =
  Utils.onButtonClick addr (ShowTrackRanking liveTrack)
