module Game.Touch exposing (..)

import Game.Utils as Utils


type alias DeviceOrientation =
    { alpha : Float
    , beta : Float
    , gamma : Float
    }


type alias Touch =
    { turn : Int }


initial : Touch
initial =
    Touch 0


asArrows : Touch -> { x : Int, y : Int }
asArrows touch =
    { x = touch.turn
    , y = 0
    }


type Msg
    = Turn Int
    | Orientation DeviceOrientation


update : Msg -> Touch -> Touch
update msg touch =
    case msg of
        Turn x ->
            Touch x

        Orientation o ->
            if abs o.gamma > 6 then
                Touch (Utils.sign o.gamma)
            else
                Touch 0
