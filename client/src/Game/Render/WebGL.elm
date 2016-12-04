module Game.Render.WebGL exposing (..)

import Html exposing (Html)
import Html.Attributes exposing (width, height, style)
import Math.Vector2 as Vec2 exposing (Vec2, vec2)
import Math.Vector3 as Vec3 exposing (Vec3, vec3)
import WebGL
import Hexagons
import Window
import Constants exposing (rgbColors)
import Model.Shared as Shared exposing (Point, Grid, Tile, TileKind(..))
import Game.Geo as Geo


type alias Viewport =
    { size : Window.Size
    , devicePixelRatio : Float
    , offset : ( Float, Float )
    }


type alias Attribute =
    { position : Vec2 }


type alias Uniform u =
    { u
        | color : Vec3
        , offset : Vec2
        , windowSize : Vec2
        , hexSize : Vec2
    }


type alias Varying =
    { vColor : Vec3 }


renderGrid : Viewport -> List Tile -> Html msg
renderGrid { size, devicePixelRatio, offset } tiles =
    let
        ( dx, dy ) =
            offset

        w =
            toFloat size.width + Constants.hexRadius * 2

        h =
            toFloat size.height + Constants.hexRadius * 2

        viewBox =
            ( ( w / 2 - dx, h / 2 + dy ), ( w / 2 + dy, h / 2 - dy ) )
    in
        WebGL.toHtml
            [ width <| round (toFloat size.width * devicePixelRatio)
            , height <| round (toFloat size.height * devicePixelRatio)
            , style
                [ ( "transform-origin", "0 0" )
                , ( "transform", "scale(" ++ toString (1 / devicePixelRatio) ++ ")" )
                ]
            ]
            (List.filterMap (renderCell viewBox size offset) tiles)


renderCell : ( Point, Point ) -> Window.Size -> ( Float, Float ) -> Tile -> Maybe WebGL.Renderable
renderCell viewBox { width, height } ( dx, dy ) tile =
    let
        ( tx, ty ) =
            Hexagons.axialToPoint Constants.hexRadius tile.coords
    in
        if Geo.inBox ( tx, ty ) viewBox then
            let
                uniform =
                    { color = rgbToVec3 (cellColor tile.kind)
                    , offset = vec2 (tx + dx) (-ty - dy)
                    , windowSize = vec2 (toFloat width) (toFloat height)
                    , hexSize = Vec2.fromTuple (Hexagons.dims Constants.hexRadius)
                    }
            in
                Just (WebGL.render vertexShader fragmentShader mesh uniform)
        else
            Nothing


cellColor : TileKind -> ( Int, Int, Int )
cellColor kind =
    case kind of
        Grass ->
            rgbColors.grass

        Rock ->
            rgbColors.rock

        Water ->
            rgbColors.water


rgbToVec3 : ( Int, Int, Int ) -> Vec3
rgbToVec3 ( r, g, b ) =
    vec3 (toFloat r / 255) (toFloat g / 255) (toFloat b / 255)


vertexShader : WebGL.Shader Attribute (Uniform u) Varying
vertexShader =
    [glsl|
  attribute vec2 position;
  uniform vec3 color;
  uniform vec2 offset;
  uniform vec2 hexSize;
  uniform vec2 windowSize;
  varying vec3 vColor;

  void main () {
      vec2 clipSpace = position * vec2(hexSize.y, hexSize.y) / windowSize;
      vec2 offsetClipSpace = offset / windowSize * 2.0;
      gl_Position = vec4(vec2(clipSpace.x + offsetClipSpace.x, clipSpace.y - offsetClipSpace.y), 0, 1);
      vColor = color;
  }
|]


fragmentShader : WebGL.Shader {} u Varying
fragmentShader =
    [glsl|
  precision mediump float;
  varying vec3 vColor;

  void main () {
      gl_FragColor = vec4(vColor, 1);
  }
|]


mesh : WebGL.Drawable Attribute
mesh =
    let
        ( w, h ) =
            Hexagons.dims 1

        w2 =
            w / 2

        h2 =
            h / 2

        h4 =
            h / 4
    in
        WebGL.TriangleFan
            [ Attribute (vec2 0 0)
            , Attribute (vec2 -w2 -h4)
            , Attribute (vec2 0 -h2)
            , Attribute (vec2 w2 -h4)
            , Attribute (vec2 w2 h4)
            , Attribute (vec2 0 h2)
            , Attribute (vec2 -w2 h4)
            ]
