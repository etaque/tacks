module View.HexBg exposing (..)

import Dict exposing (Dict)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Extra.Hexagons as Hexagons
import Constants
import Model.Shared exposing (..)
import Game.Render.Tiles as Tiles
import Html.Lazy as Lazy


render : Size -> Svg msg
render size =
    Lazy.lazy renderRaw size


renderRaw : Size -> Svg msg
renderRaw size =
    let
        grid =
            Hexagons.makeRect Constants.hexRadius size.width size.height
                |> List.map (\c -> ( c, Water ))
                |> Dict.fromList
    in
        svg
            [ width (toString size.width)
            , height (toString size.height)
            , class "hex-bg"
            ]
            [ Tiles.renderTiles grid ]
