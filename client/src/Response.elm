module Response exposing (..)

import Model.Event exposing (Event)


type alias Response model msg =
    { model : model
    , cmd : Cmd msg
    , event : Maybe Event
    }


type alias Res model msg =
    Response model msg


updateWithEvent : (Event -> msg) -> (msg -> model -> Response model msg) -> msg -> model -> ( model, Cmd msg )
updateWithEvent eventMsg responseUpdate msg model =
    let
        msgResponse =
            responseUpdate msg model

        eventResponse =
            case msgResponse.event of
                Just event ->
                    responseUpdate (eventMsg event) msgResponse.model

                Nothing ->
                    res msgResponse.model Cmd.none
    in
        ( eventResponse.model, Cmd.batch [ msgResponse.cmd, eventResponse.cmd ] )


res : model -> Cmd msg -> Response model msg
res model cmd =
    Response model cmd Nothing


mapModel : (m -> m_) -> Response m a -> Response m_ a
mapModel onModel =
    mapBoth onModel identity


mapCmd : (a -> a_) -> Response m a -> Response m a_
mapCmd onCmd =
    mapBoth identity onCmd


mapBoth : (m -> m_) -> (a -> a_) -> Response m a -> Response m_ a_
mapBoth onModel onCmd ({ model, cmd } as r) =
    { r
        | model = onModel model
        , cmd = Cmd.map onCmd cmd
    }


addCmd : Cmd a -> Response m a -> Response m a
addCmd cmd r =
    let
        batched =
            Cmd.batch [ cmd, r.cmd ]
    in
        { r | cmd = batched }


withEvent : Event -> Response m a -> Response m a
withEvent event r =
    { r | event = Just event }


toResponse : ( model, Cmd msg ) -> Response model msg
toResponse ( model, cmd ) =
    res model cmd
