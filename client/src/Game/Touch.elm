module Game.Touch exposing (..)


type alias Touch =
    { left : Bool
    , right : Bool
    }


initial : Touch
initial =
    Touch False False


asArrows : Touch -> { x : Int, y : Int }
asArrows { left, right } =
    { x =
        if left then
            -1
        else if right then
            1
        else
            0
    , y = 0
    }


type Msg
    = Left Bool
    | Right Bool


update : Msg -> Touch -> Touch
update msg touch =
    case msg of
        Left b ->
            Touch b False

        Right b ->
            Touch False b
