module Game.Outputs exposing (..)

import Json.Encode as Js
import Model.Shared exposing (..)
import Game.Models exposing (..)
import WebSocket
import ServerApi


type ServerMsg
  = ServerNoOp
  | UpdatePlayer PlayerOutput
  | SendMessage String
  | AddGhost String Player
  | RemoveGhost String
  | StartRace
  | EscapeRace


type LocalMsg
  = LocalNoOp
  | ChatScrollDown


type alias PlayerOutput =
  { state : OpponentState
  , localTime : Float
  }


playerOutput : GameState -> PlayerOutput
playerOutput gameState =
  { state = asOpponentState gameState.playerState
  , localTime = gameState.timers.localTime
  }


sendToServer : String -> Maybe LiveTrack -> ServerMsg -> Cmd msg
sendToServer host maybeLiveTrack serverMsg =
  case maybeLiveTrack of
    Just {track} ->
      WebSocket.send (ServerApi.gameSocket host track.id) (Js.encode 0 (encodeServerMsg serverMsg))

    Nothing ->
      Cmd.none


encodeServerMsg : ServerMsg -> Js.Value
encodeServerMsg msg =
  case msg of
    ServerNoOp ->
      tag "ServerNoOp" []

    UpdatePlayer output ->
      tag "PlayerInput" [ ( "playerInput", encodePlayerOutput output ) ]

    SendMessage s ->
      tag "SendMessage" [ ( "content", Js.string s ) ]

    AddGhost runId _ ->
      tag "AddGhost" [ ( "runId", Js.string runId ) ]

    RemoveGhost runId ->
      tag "RemoveGhost" [ ( "runId", Js.string runId ) ]

    StartRace ->
      tag "StartRace" []

    EscapeRace ->
      tag "EscapeRace" []


tag : String -> List ( String, Js.Value ) -> Js.Value
tag name fields =
  Js.object <| ( "tag", Js.string name ) :: fields


encodePlayerOutput : PlayerOutput -> Js.Value
encodePlayerOutput output =
  Js.object
    [ ( "state", encodeOpponentState output.state )
    , ( "localTime" , Js.float output.localTime )
    ]


encodeOpponentState : OpponentState -> Js.Value
encodeOpponentState o =
  Js.object
    [ ( "time", Js.float o.time )
    , ( "position", Js.list [ Js.float (fst o.position), Js.float (snd o.position) ])
    , ( "heading", Js.float o.heading )
    , ( "velocity", Js.float o.velocity )
    , ( "windAngle", Js.float o.windAngle )
    , ( "windOrigin", Js.float o.windOrigin )
    , ( "shadowDirection", Js.float o.shadowDirection )
    , ( "crossedGates", Js.list (List.map Js.float o.crossedGates))
    ]
