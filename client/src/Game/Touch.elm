module Game.Touch exposing (..)


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


update : Msg -> Touch -> Touch
update msg touch =
    case msg of
        Turn x ->
            Touch x
