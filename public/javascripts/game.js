Elm.Main = Elm.Main || {};
Elm.Main.make = function (_elm) {
   "use strict";
   _elm.Main = _elm.Main || {};
   if (_elm.Main.values)
   return _elm.Main.values;
   var _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _A = _N.Array.make(_elm),
   _E = _N.Error.make(_elm),
   $moduleName = "Main";
   var Basics = Elm.Basics.make(_elm);
   var Color = Elm.Color.make(_elm);
   var Game = Elm.Game.make(_elm);
   var Graphics = Graphics || {};
   Graphics.Collage = Elm.Graphics.Collage.make(_elm);
   var Graphics = Graphics || {};
   Graphics.Element = Elm.Graphics.Element.make(_elm);
   var Inputs = Elm.Inputs.make(_elm);
   var Json = Elm.Json.make(_elm);
   var Keyboard = Elm.Keyboard.make(_elm);
   var List = Elm.List.make(_elm);
   var Maybe = Elm.Maybe.make(_elm);
   var Native = Native || {};
   Native.Json = Elm.Native.Json.make(_elm);
   var Native = Native || {};
   Native.Ports = Elm.Native.Ports.make(_elm);
   var Render = Render || {};
   Render.All = Elm.Render.All.make(_elm);
   var Signal = Elm.Signal.make(_elm);
   var Steps = Elm.Steps.make(_elm);
   var String = Elm.String.make(_elm);
   var Text = Elm.Text.make(_elm);
   var Time = Elm.Time.make(_elm);
   var Window = Elm.Window.make(_elm);
   var _op = {};
   var clock = A2(Signal._op["<~"],
   Time.inSeconds,
   Time.fps(30));
   var raceInput = Native.Ports.portIn("raceInput",
   Native.Ports.incomingSignal(function (v) {
      return typeof v === "object" && "now" in v && "startTime" in v && "course" in v && "player" in v && "wind" in v && "opponents" in v && "buoys" in v && "leaderboard" in v && "triggeredSpells" in v && "isMaster" in v ? {_: {}
                                                                                                                                                                                                                               ,now: typeof v.now === "number" ? v.now : _E.raise("invalid input, expecting JSNumber but got " + v.now)
                                                                                                                                                                                                                               ,startTime: v.startTime === null ? Maybe.Nothing : Maybe.Just(typeof v.startTime === "number" ? v.startTime : _E.raise("invalid input, expecting JSNumber but got " + v.startTime))
                                                                                                                                                                                                                               ,course: v.course === null ? Maybe.Nothing : Maybe.Just(typeof v.course === "object" && "upwind" in v.course && "downwind" in v.course && "laps" in v.course && "markRadius" in v.course && "islands" in v.course && "area" in v.course && "windShadowLength" in v.course && "boatWidth" in v.course ? {_: {}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      ,upwind: typeof v.course.upwind === "object" && "y" in v.course.upwind && "width" in v.course.upwind ? {_: {}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             ,y: typeof v.course.upwind.y === "number" ? v.course.upwind.y : _E.raise("invalid input, expecting JSNumber but got " + v.course.upwind.y)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             ,width: typeof v.course.upwind.width === "number" ? v.course.upwind.width : _E.raise("invalid input, expecting JSNumber but got " + v.course.upwind.width)} : _E.raise("invalid input, expecting JSObject [\"y\",\"width\"] but got " + v.course.upwind)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      ,downwind: typeof v.course.downwind === "object" && "y" in v.course.downwind && "width" in v.course.downwind ? {_: {}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     ,y: typeof v.course.downwind.y === "number" ? v.course.downwind.y : _E.raise("invalid input, expecting JSNumber but got " + v.course.downwind.y)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     ,width: typeof v.course.downwind.width === "number" ? v.course.downwind.width : _E.raise("invalid input, expecting JSNumber but got " + v.course.downwind.width)} : _E.raise("invalid input, expecting JSObject [\"y\",\"width\"] but got " + v.course.downwind)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      ,laps: typeof v.course.laps === "number" ? v.course.laps : _E.raise("invalid input, expecting JSNumber but got " + v.course.laps)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      ,markRadius: typeof v.course.markRadius === "number" ? v.course.markRadius : _E.raise("invalid input, expecting JSNumber but got " + v.course.markRadius)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      ,islands: _U.isJSArray(v.course.islands) ? _L.fromArray(v.course.islands.map(function (v) {
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         return typeof v === "object" && "location" in v && "radius" in v ? {_: {}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            ,location: _U.isJSArray(v.location) ? {ctor: "_Tuple2"
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  ,_0: typeof v.location[0] === "number" ? v.location[0] : _E.raise("invalid input, expecting JSNumber but got " + v.location[0])
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  ,_1: typeof v.location[1] === "number" ? v.location[1] : _E.raise("invalid input, expecting JSNumber but got " + v.location[1])} : _E.raise("invalid input, expecting JSArray but got " + v.location)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            ,radius: typeof v.radius === "number" ? v.radius : _E.raise("invalid input, expecting JSNumber but got " + v.radius)} : _E.raise("invalid input, expecting JSObject [\"location\",\"radius\"] but got " + v);
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      })) : _E.raise("invalid input, expecting JSArray but got " + v.course.islands)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      ,area: typeof v.course.area === "object" && "rightTop" in v.course.area && "leftBottom" in v.course.area ? {_: {}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 ,rightTop: _U.isJSArray(v.course.area.rightTop) ? {ctor: "_Tuple2"
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   ,_0: typeof v.course.area.rightTop[0] === "number" ? v.course.area.rightTop[0] : _E.raise("invalid input, expecting JSNumber but got " + v.course.area.rightTop[0])
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   ,_1: typeof v.course.area.rightTop[1] === "number" ? v.course.area.rightTop[1] : _E.raise("invalid input, expecting JSNumber but got " + v.course.area.rightTop[1])} : _E.raise("invalid input, expecting JSArray but got " + v.course.area.rightTop)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 ,leftBottom: _U.isJSArray(v.course.area.leftBottom) ? {ctor: "_Tuple2"
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       ,_0: typeof v.course.area.leftBottom[0] === "number" ? v.course.area.leftBottom[0] : _E.raise("invalid input, expecting JSNumber but got " + v.course.area.leftBottom[0])
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       ,_1: typeof v.course.area.leftBottom[1] === "number" ? v.course.area.leftBottom[1] : _E.raise("invalid input, expecting JSNumber but got " + v.course.area.leftBottom[1])} : _E.raise("invalid input, expecting JSArray but got " + v.course.area.leftBottom)} : _E.raise("invalid input, expecting JSObject [\"rightTop\",\"leftBottom\"] but got " + v.course.area)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      ,windShadowLength: typeof v.course.windShadowLength === "number" ? v.course.windShadowLength : _E.raise("invalid input, expecting JSNumber but got " + v.course.windShadowLength)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      ,boatWidth: typeof v.course.boatWidth === "number" ? v.course.boatWidth : _E.raise("invalid input, expecting JSNumber but got " + v.course.boatWidth)} : _E.raise("invalid input, expecting JSObject [\"upwind\",\"downwind\",\"laps\",\"markRadius\",\"islands\",\"area\",\"windShadowLength\",\"boatWidth\"] but got " + v.course))
                                                                                                                                                                                                                               ,player: v.player === null ? Maybe.Nothing : Maybe.Just(typeof v.player === "object" && "position" in v.player && "heading" in v.player && "velocity" in v.player && "windAngle" in v.player && "windOrigin" in v.player && "windSpeed" in v.player && "downwindVmg" in v.player && "upwindVmg" in v.player && "trail" in v.player && "controlMode" in v.player && "tackTarget" in v.player && "crossedGates" in v.player && "nextGate" in v.player && "ownSpell" in v.player ? {_: {}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               ,position: _U.isJSArray(v.player.position) ? {ctor: "_Tuple2"
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            ,_0: typeof v.player.position[0] === "number" ? v.player.position[0] : _E.raise("invalid input, expecting JSNumber but got " + v.player.position[0])
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            ,_1: typeof v.player.position[1] === "number" ? v.player.position[1] : _E.raise("invalid input, expecting JSNumber but got " + v.player.position[1])} : _E.raise("invalid input, expecting JSArray but got " + v.player.position)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               ,heading: typeof v.player.heading === "number" ? v.player.heading : _E.raise("invalid input, expecting JSNumber but got " + v.player.heading)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               ,velocity: typeof v.player.velocity === "number" ? v.player.velocity : _E.raise("invalid input, expecting JSNumber but got " + v.player.velocity)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               ,windAngle: typeof v.player.windAngle === "number" ? v.player.windAngle : _E.raise("invalid input, expecting JSNumber but got " + v.player.windAngle)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               ,windOrigin: typeof v.player.windOrigin === "number" ? v.player.windOrigin : _E.raise("invalid input, expecting JSNumber but got " + v.player.windOrigin)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               ,windSpeed: typeof v.player.windSpeed === "number" ? v.player.windSpeed : _E.raise("invalid input, expecting JSNumber but got " + v.player.windSpeed)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               ,downwindVmg: typeof v.player.downwindVmg === "number" ? v.player.downwindVmg : _E.raise("invalid input, expecting JSNumber but got " + v.player.downwindVmg)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               ,upwindVmg: typeof v.player.upwindVmg === "number" ? v.player.upwindVmg : _E.raise("invalid input, expecting JSNumber but got " + v.player.upwindVmg)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               ,trail: _U.isJSArray(v.player.trail) ? _L.fromArray(v.player.trail.map(function (v) {
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  return _U.isJSArray(v) ? {ctor: "_Tuple2"
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           ,_0: typeof v[0] === "number" ? v[0] : _E.raise("invalid input, expecting JSNumber but got " + v[0])
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           ,_1: typeof v[1] === "number" ? v[1] : _E.raise("invalid input, expecting JSNumber but got " + v[1])} : _E.raise("invalid input, expecting JSArray but got " + v);
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               })) : _E.raise("invalid input, expecting JSArray but got " + v.player.trail)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               ,controlMode: typeof v.player.controlMode === "string" || typeof v.player.controlMode === "object" && v.player.controlMode instanceof String ? v.player.controlMode : _E.raise("invalid input, expecting JSString but got " + v.player.controlMode)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               ,tackTarget: v.player.tackTarget === null ? Maybe.Nothing : Maybe.Just(typeof v.player.tackTarget === "number" ? v.player.tackTarget : _E.raise("invalid input, expecting JSNumber but got " + v.player.tackTarget))
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               ,crossedGates: _U.isJSArray(v.player.crossedGates) ? _L.fromArray(v.player.crossedGates.map(function (v) {
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  return typeof v === "number" ? v : _E.raise("invalid input, expecting JSNumber but got " + v);
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               })) : _E.raise("invalid input, expecting JSArray but got " + v.player.crossedGates)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               ,nextGate: v.player.nextGate === null ? Maybe.Nothing : Maybe.Just(typeof v.player.nextGate === "string" || typeof v.player.nextGate === "object" && v.player.nextGate instanceof String ? v.player.nextGate : _E.raise("invalid input, expecting JSString but got " + v.player.nextGate))
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               ,ownSpell: v.player.ownSpell === null ? Maybe.Nothing : Maybe.Just(typeof v.player.ownSpell === "object" && "kind" in v.player.ownSpell ? {_: {}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         ,kind: typeof v.player.ownSpell.kind === "string" || typeof v.player.ownSpell.kind === "object" && v.player.ownSpell.kind instanceof String ? v.player.ownSpell.kind : _E.raise("invalid input, expecting JSString but got " + v.player.ownSpell.kind)} : _E.raise("invalid input, expecting JSObject [\"kind\"] but got " + v.player.ownSpell))} : _E.raise("invalid input, expecting JSObject [\"position\",\"heading\",\"velocity\",\"windAngle\",\"windOrigin\",\"windSpeed\",\"downwindVmg\",\"upwindVmg\",\"trail\",\"controlMode\",\"tackTarget\",\"crossedGates\",\"nextGate\",\"ownSpell\"] but got " + v.player))
                                                                                                                                                                                                                               ,wind: typeof v.wind === "object" && "origin" in v.wind && "speed" in v.wind && "gusts" in v.wind ? {_: {}
                                                                                                                                                                                                                                                                                                                                   ,origin: typeof v.wind.origin === "number" ? v.wind.origin : _E.raise("invalid input, expecting JSNumber but got " + v.wind.origin)
                                                                                                                                                                                                                                                                                                                                   ,speed: typeof v.wind.speed === "number" ? v.wind.speed : _E.raise("invalid input, expecting JSNumber but got " + v.wind.speed)
                                                                                                                                                                                                                                                                                                                                   ,gusts: _U.isJSArray(v.wind.gusts) ? _L.fromArray(v.wind.gusts.map(function (v) {
                                                                                                                                                                                                                                                                                                                                      return typeof v === "object" && "position" in v && "angle" in v && "speed" in v && "radius" in v ? {_: {}
                                                                                                                                                                                                                                                                                                                                                                                                                                         ,position: _U.isJSArray(v.position) ? {ctor: "_Tuple2"
                                                                                                                                                                                                                                                                                                                                                                                                                                                                               ,_0: typeof v.position[0] === "number" ? v.position[0] : _E.raise("invalid input, expecting JSNumber but got " + v.position[0])
                                                                                                                                                                                                                                                                                                                                                                                                                                                                               ,_1: typeof v.position[1] === "number" ? v.position[1] : _E.raise("invalid input, expecting JSNumber but got " + v.position[1])} : _E.raise("invalid input, expecting JSArray but got " + v.position)
                                                                                                                                                                                                                                                                                                                                                                                                                                         ,angle: typeof v.angle === "number" ? v.angle : _E.raise("invalid input, expecting JSNumber but got " + v.angle)
                                                                                                                                                                                                                                                                                                                                                                                                                                         ,speed: typeof v.speed === "number" ? v.speed : _E.raise("invalid input, expecting JSNumber but got " + v.speed)
                                                                                                                                                                                                                                                                                                                                                                                                                                         ,radius: typeof v.radius === "number" ? v.radius : _E.raise("invalid input, expecting JSNumber but got " + v.radius)} : _E.raise("invalid input, expecting JSObject [\"position\",\"angle\",\"speed\",\"radius\"] but got " + v);
                                                                                                                                                                                                                                                                                                                                   })) : _E.raise("invalid input, expecting JSArray but got " + v.wind.gusts)} : _E.raise("invalid input, expecting JSObject [\"origin\",\"speed\",\"gusts\"] but got " + v.wind)
                                                                                                                                                                                                                               ,opponents: _U.isJSArray(v.opponents) ? _L.fromArray(v.opponents.map(function (v) {
                                                                                                                                                                                                                                  return typeof v === "object" && "position" in v && "heading" in v && "velocity" in v && "windAngle" in v && "windOrigin" in v && "windSpeed" in v && "player" in v ? {_: {}
                                                                                                                                                                                                                                                                                                                                                                                                       ,position: _U.isJSArray(v.position) ? {ctor: "_Tuple2"
                                                                                                                                                                                                                                                                                                                                                                                                                                             ,_0: typeof v.position[0] === "number" ? v.position[0] : _E.raise("invalid input, expecting JSNumber but got " + v.position[0])
                                                                                                                                                                                                                                                                                                                                                                                                                                             ,_1: typeof v.position[1] === "number" ? v.position[1] : _E.raise("invalid input, expecting JSNumber but got " + v.position[1])} : _E.raise("invalid input, expecting JSArray but got " + v.position)
                                                                                                                                                                                                                                                                                                                                                                                                       ,heading: typeof v.heading === "number" ? v.heading : _E.raise("invalid input, expecting JSNumber but got " + v.heading)
                                                                                                                                                                                                                                                                                                                                                                                                       ,velocity: typeof v.velocity === "number" ? v.velocity : _E.raise("invalid input, expecting JSNumber but got " + v.velocity)
                                                                                                                                                                                                                                                                                                                                                                                                       ,windAngle: typeof v.windAngle === "number" ? v.windAngle : _E.raise("invalid input, expecting JSNumber but got " + v.windAngle)
                                                                                                                                                                                                                                                                                                                                                                                                       ,windOrigin: typeof v.windOrigin === "number" ? v.windOrigin : _E.raise("invalid input, expecting JSNumber but got " + v.windOrigin)
                                                                                                                                                                                                                                                                                                                                                                                                       ,windSpeed: typeof v.windSpeed === "number" ? v.windSpeed : _E.raise("invalid input, expecting JSNumber but got " + v.windSpeed)
                                                                                                                                                                                                                                                                                                                                                                                                       ,player: typeof v.player === "object" && "name" in v.player ? {_: {}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                     ,name: typeof v.player.name === "string" || typeof v.player.name === "object" && v.player.name instanceof String ? v.player.name : _E.raise("invalid input, expecting JSString but got " + v.player.name)} : _E.raise("invalid input, expecting JSObject [\"name\"] but got " + v.player)} : _E.raise("invalid input, expecting JSObject [\"position\",\"heading\",\"velocity\",\"windAngle\",\"windOrigin\",\"windSpeed\",\"player\"] but got " + v);
                                                                                                                                                                                                                               })) : _E.raise("invalid input, expecting JSArray but got " + v.opponents)
                                                                                                                                                                                                                               ,buoys: _U.isJSArray(v.buoys) ? _L.fromArray(v.buoys.map(function (v) {
                                                                                                                                                                                                                                  return typeof v === "object" && "position" in v && "radius" in v && "spell" in v ? {_: {}
                                                                                                                                                                                                                                                                                                                     ,position: _U.isJSArray(v.position) ? {ctor: "_Tuple2"
                                                                                                                                                                                                                                                                                                                                                           ,_0: typeof v.position[0] === "number" ? v.position[0] : _E.raise("invalid input, expecting JSNumber but got " + v.position[0])
                                                                                                                                                                                                                                                                                                                                                           ,_1: typeof v.position[1] === "number" ? v.position[1] : _E.raise("invalid input, expecting JSNumber but got " + v.position[1])} : _E.raise("invalid input, expecting JSArray but got " + v.position)
                                                                                                                                                                                                                                                                                                                     ,radius: typeof v.radius === "number" ? v.radius : _E.raise("invalid input, expecting JSNumber but got " + v.radius)
                                                                                                                                                                                                                                                                                                                     ,spell: typeof v.spell === "object" && "kind" in v.spell ? {_: {}
                                                                                                                                                                                                                                                                                                                                                                                ,kind: typeof v.spell.kind === "string" || typeof v.spell.kind === "object" && v.spell.kind instanceof String ? v.spell.kind : _E.raise("invalid input, expecting JSString but got " + v.spell.kind)} : _E.raise("invalid input, expecting JSObject [\"kind\"] but got " + v.spell)} : _E.raise("invalid input, expecting JSObject [\"position\",\"radius\",\"spell\"] but got " + v);
                                                                                                                                                                                                                               })) : _E.raise("invalid input, expecting JSArray but got " + v.buoys)
                                                                                                                                                                                                                               ,leaderboard: _U.isJSArray(v.leaderboard) ? _L.fromArray(v.leaderboard.map(function (v) {
                                                                                                                                                                                                                                  return typeof v === "string" || typeof v === "object" && v instanceof String ? v : _E.raise("invalid input, expecting JSString but got " + v);
                                                                                                                                                                                                                               })) : _E.raise("invalid input, expecting JSArray but got " + v.leaderboard)
                                                                                                                                                                                                                               ,triggeredSpells: _U.isJSArray(v.triggeredSpells) ? _L.fromArray(v.triggeredSpells.map(function (v) {
                                                                                                                                                                                                                                  return typeof v === "object" && "kind" in v ? {_: {}
                                                                                                                                                                                                                                                                                ,kind: typeof v.kind === "string" || typeof v.kind === "object" && v.kind instanceof String ? v.kind : _E.raise("invalid input, expecting JSString but got " + v.kind)} : _E.raise("invalid input, expecting JSObject [\"kind\"] but got " + v);
                                                                                                                                                                                                                               })) : _E.raise("invalid input, expecting JSArray but got " + v.triggeredSpells)
                                                                                                                                                                                                                               ,isMaster: typeof v.isMaster === "boolean" ? v.isMaster : _E.raise("invalid input, expecting JSBoolean but got " + v.isMaster)} : _E.raise("invalid input, expecting JSObject [\"now\",\"startTime\",\"course\",\"player\",\"wind\",\"opponents\",\"buoys\",\"leaderboard\",\"triggeredSpells\",\"isMaster\"] but got " + v);
   }));
   var input = A2(Signal.sampleOn,
   clock,
   A7(Signal.lift6,
   Inputs.Input,
   clock,
   Inputs.chrono,
   Inputs.keyboardInput,
   Inputs.mouseInput,
   Window.dimensions,
   raceInput));
   var gameState = A3(Signal.foldp,
   Steps.stepGame,
   Game.defaultGame,
   input);
   var main = A3(Signal.lift2,
   Render.All.renderAll,
   Window.dimensions,
   gameState);
   var playerOutput = Native.Ports.portOut("playerOutput",
   Native.Ports.outgoingSignal(function (v) {
      return {arrows: {x: v.arrows.x
                      ,y: v.arrows.y}
             ,lock: v.lock
             ,tack: v.tack
             ,subtleTurn: v.subtleTurn
             ,spellCast: v.spellCast
             ,startCountdown: v.startCountdown};
   }),
   A2(Signal.lift,
   function (_) {
      return _.keyboardInput;
   },
   input));
   _elm.Main.values = {_op: _op
                      ,clock: clock
                      ,input: input
                      ,gameState: gameState
                      ,main: main};
   return _elm.Main.values;
};Elm.Steps = Elm.Steps || {};
Elm.Steps.make = function (_elm) {
   "use strict";
   _elm.Steps = _elm.Steps || {};
   if (_elm.Steps.values)
   return _elm.Steps.values;
   var _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _A = _N.Array.make(_elm),
   _E = _N.Error.make(_elm),
   $moduleName = "Steps";
   var Basics = Elm.Basics.make(_elm);
   var Color = Elm.Color.make(_elm);
   var Core = Elm.Core.make(_elm);
   var Debug = Elm.Debug.make(_elm);
   var Game = Elm.Game.make(_elm);
   var Geo = Elm.Geo.make(_elm);
   var Graphics = Graphics || {};
   Graphics.Collage = Elm.Graphics.Collage.make(_elm);
   var Graphics = Graphics || {};
   Graphics.Element = Elm.Graphics.Element.make(_elm);
   var Inputs = Elm.Inputs.make(_elm);
   var List = Elm.List.make(_elm);
   var Maybe = Elm.Maybe.make(_elm);
   var Native = Native || {};
   Native.Json = Elm.Native.Json.make(_elm);
   var Native = Native || {};
   Native.Ports = Elm.Native.Ports.make(_elm);
   var Signal = Elm.Signal.make(_elm);
   var String = Elm.String.make(_elm);
   var Text = Elm.Text.make(_elm);
   var Time = Elm.Time.make(_elm);
   var _op = {};
   var raceInputStep = F2(function (raceInput,
   _v0) {
      return function () {
         return function () {
            var $ = raceInput,
            now = $.now,
            startTime = $.startTime,
            course = $.course,
            player = $.player,
            opponents = $.opponents,
            buoys = $.buoys,
            wind = $.wind,
            triggeredSpells = $.triggeredSpells,
            leaderboard = $.leaderboard,
            isMaster = $.isMaster;
            return _U.replace([["opponents"
                               ,opponents]
                              ,["player"
                               ,A3(Maybe.maybe,
                               _v0.player,
                               Basics.id,
                               player)]
                              ,["course"
                               ,A3(Maybe.maybe,
                               _v0.course,
                               Basics.id,
                               course)]
                              ,["wind",wind]
                              ,["buoys",buoys]
                              ,["triggeredSpells"
                               ,triggeredSpells]
                              ,["leaderboard",leaderboard]
                              ,["now",now]
                              ,["countdown"
                               ,A2(Core.mapMaybe,
                               function (st) {
                                  return st - now;
                               },
                               startTime)]
                              ,["isMaster",isMaster]],
            _v0);
         }();
      }();
   });
   var getCenterAfterMove = F4(function (_v2,
   _v3,
   _v4,
   _v5) {
      return function () {
         switch (_v5.ctor)
         {case "_Tuple2":
            return function () {
                 switch (_v4.ctor)
                 {case "_Tuple2":
                    return function () {
                         switch (_v3.ctor)
                         {case "_Tuple2":
                            return function () {
                                 switch (_v2.ctor)
                                 {case "_Tuple2":
                                    return function () {
                                         var refocus = F5(function (n,
                                         n$,
                                         c,
                                         d,
                                         margin) {
                                            return function () {
                                               var max = c + d / 2;
                                               var mmax = max - margin;
                                               var min = c - d / 2;
                                               var mmin = min + margin;
                                               return _U.cmp(n,
                                               min) < 0 || _U.cmp(n,
                                               max) > 0 ? c : _U.cmp(n,
                                               mmin) < 0 ? _U.cmp(n$,
                                               n) < 0 ? c - (n - n$) : c : _U.cmp(n,
                                               mmax) > 0 ? _U.cmp(n$,
                                               n) > 0 ? c + (n$ - n) : c : _U.cmp(n$,
                                               mmin) < 0 ? c - (n - n$) : _U.cmp(n$,
                                               mmax) > 0 ? c + (n$ - n) : c;
                                            }();
                                         });
                                         return {ctor: "_Tuple2"
                                                ,_0: A5(refocus,
                                                _v2._0,
                                                _v3._0,
                                                _v4._0,
                                                _v5._0,
                                                _v5._0 * 0.2)
                                                ,_1: A5(refocus,
                                                _v2._1,
                                                _v3._1,
                                                _v4._1,
                                                _v5._1,
                                                _v5._1 * 0.4)};
                                      }();}
                                 _E.Case($moduleName,
                                 "between lines 19 and 32");
                              }();}
                         _E.Case($moduleName,
                         "between lines 19 and 32");
                      }();}
                 _E.Case($moduleName,
                 "between lines 19 and 32");
              }();}
         _E.Case($moduleName,
         "between lines 19 and 32");
      }();
   });
   var moveStep = F5(function (frozen,
   delta,
   _v18,
   dims,
   _v19) {
      return function () {
         return function () {
            return function () {
               var newPosition = frozen ? A4(Geo.movePoint,
               _v18.position,
               delta,
               _v18.velocity,
               _v18.heading) : _v19.player.position;
               var movedPlayer = _U.replace([["position"
                                             ,newPosition]],
               _v19.player);
               var newCenter = A4(getCenterAfterMove,
               _v18.position,
               newPosition,
               _v19.center,
               Geo.floatify(dims));
               return _U.replace([["player"
                                  ,movedPlayer]
                                 ,["center",newCenter]],
               _v19);
            }();
         }();
      }();
   });
   var mouseStep = F2(function (_v22,
   _v23) {
      return function () {
         return function () {
            return function () {
               var newCenter = function () {
                  var _v26 = _v22.drag;
                  switch (_v26.ctor)
                  {case "Just":
                     switch (_v26._0.ctor)
                       {case "_Tuple2":
                          return function () {
                               var $ = _v22.mouse,
                               x = $._0,
                               y = $._1;
                               return A2(Geo.sub,
                               Geo.floatify({ctor: "_Tuple2"
                                            ,_0: x - _v26._0._0
                                            ,_1: _v26._0._1 - y}),
                               _v23.center);
                            }();}
                       break;
                     case "Nothing":
                     return _v23.center;}
                  _E.Case($moduleName,
                  "between lines 12 and 15");
               }();
               return _U.replace([["center"
                                  ,newCenter]],
               _v23);
            }();
         }();
      }();
   });
   var stepGame = F2(function (input,
   gameState) {
      return function () {
         var previousState = gameState.player;
         var frozen = _U.eq(input.raceInput.now,
         gameState.now);
         return mouseStep(input.mouseInput)(A4(moveStep,
         frozen,
         input.delta,
         previousState,
         input.windowInput)(A2(raceInputStep,
         input.raceInput,
         gameState)));
      }();
   });
   _elm.Steps.values = {_op: _op
                       ,mouseStep: mouseStep
                       ,getCenterAfterMove: getCenterAfterMove
                       ,moveStep: moveStep
                       ,raceInputStep: raceInputStep
                       ,stepGame: stepGame};
   return _elm.Steps.values;
};Elm.Render = Elm.Render || {};
Elm.Render.All = Elm.Render.All || {};
Elm.Render.All.make = function (_elm) {
   "use strict";
   _elm.Render = _elm.Render || {};
   _elm.Render.All = _elm.Render.All || {};
   if (_elm.Render.All.values)
   return _elm.Render.All.values;
   var _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _A = _N.Array.make(_elm),
   _E = _N.Error.make(_elm),
   $moduleName = "Render.All";
   var Basics = Elm.Basics.make(_elm);
   var Color = Elm.Color.make(_elm);
   var Core = Elm.Core.make(_elm);
   var Game = Elm.Game.make(_elm);
   var Geo = Elm.Geo.make(_elm);
   var Graphics = Graphics || {};
   Graphics.Collage = Elm.Graphics.Collage.make(_elm);
   var Graphics = Graphics || {};
   Graphics.Element = Elm.Graphics.Element.make(_elm);
   var List = Elm.List.make(_elm);
   var Maybe = Elm.Maybe.make(_elm);
   var Native = Native || {};
   Native.Json = Elm.Native.Json.make(_elm);
   var Native = Native || {};
   Native.Ports = Elm.Native.Ports.make(_elm);
   var Render = Render || {};
   Render.Controls = Elm.Render.Controls.make(_elm);
   var Render = Render || {};
   Render.Race = Elm.Render.Race.make(_elm);
   var Render = Render || {};
   Render.Utils = Elm.Render.Utils.make(_elm);
   var Signal = Elm.Signal.make(_elm);
   var String = Elm.String.make(_elm);
   var Text = Elm.Text.make(_elm);
   var Time = Elm.Time.make(_elm);
   var _op = {};
   var renderAll = F2(function (_v0,
   gameState) {
      return function () {
         switch (_v0.ctor)
         {case "_Tuple2":
            return function () {
                 var relativeForms = Render.Race.renderRace(gameState);
                 var dims = Geo.floatify({ctor: "_Tuple2"
                                         ,_0: _v0._0
                                         ,_1: _v0._1});
                 var $ = dims,
                 w$ = $._0,
                 h$ = $._1;
                 var bg = Graphics.Collage.filled(Render.Utils.colors.seaBlue)(A2(Graphics.Collage.rect,
                 w$,
                 h$));
                 var absoluteForms = A2(Render.Controls.renderControls,
                 gameState,
                 dims);
                 return Graphics.Element.layers(_L.fromArray([A3(Graphics.Collage.collage,
                 _v0._0,
                 _v0._1,
                 _L.fromArray([bg
                              ,Graphics.Collage.group(_L.fromArray([relativeForms
                                                                   ,absoluteForms]))]))]));
              }();}
         _E.Case($moduleName,
         "between lines 15 and 20");
      }();
   });
   _elm.Render.All.values = {_op: _op
                            ,renderAll: renderAll};
   return _elm.Render.All.values;
};Elm.Render = Elm.Render || {};
Elm.Render.Race = Elm.Render.Race || {};
Elm.Render.Race.make = function (_elm) {
   "use strict";
   _elm.Render = _elm.Render || {};
   _elm.Render.Race = _elm.Render.Race || {};
   if (_elm.Render.Race.values)
   return _elm.Render.Race.values;
   var _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _A = _N.Array.make(_elm),
   _E = _N.Error.make(_elm),
   $moduleName = "Render.Race";
   var Basics = Elm.Basics.make(_elm);
   var Color = Elm.Color.make(_elm);
   var Core = Elm.Core.make(_elm);
   var Game = Elm.Game.make(_elm);
   var Geo = Elm.Geo.make(_elm);
   var Graphics = Graphics || {};
   Graphics.Collage = Elm.Graphics.Collage.make(_elm);
   var Graphics = Graphics || {};
   Graphics.Element = Elm.Graphics.Element.make(_elm);
   var List = Elm.List.make(_elm);
   var Maybe = Elm.Maybe.make(_elm);
   var Native = Native || {};
   Native.Json = Elm.Native.Json.make(_elm);
   var Native = Native || {};
   Native.Ports = Elm.Native.Ports.make(_elm);
   var Render = Render || {};
   Render.Utils = Elm.Render.Utils.make(_elm);
   var Signal = Elm.Signal.make(_elm);
   var String = Elm.String.make(_elm);
   var Text = Elm.Text.make(_elm);
   var Time = Elm.Time.make(_elm);
   var _op = {};
   var renderFinished = F2(function (course,
   player) {
      return function () {
         var _v0 = player.nextGate;
         switch (_v0.ctor)
         {case "Nothing":
            return Maybe.Just(Graphics.Collage.move({ctor: "_Tuple2"
                                                    ,_0: 0
                                                    ,_1: course.downwind.y + 40})(Graphics.Collage.toForm(Text.centered(Render.Utils.baseText("Finished!")))));}
         return Maybe.Nothing;
      }();
   });
   var formatCountdown = function (c) {
      return function () {
         var cs = Basics.ceiling(Time.inSeconds(c));
         var m = cs / 60 | 0;
         var s = A2(Basics.rem,cs,60);
         return _L.append("Start in ",
         _L.append(String.show(m),
         _L.append("\'",
         _L.append(String.show(s),
         "\"..."))));
      }();
   };
   var renderCountdown = F2(function (gameState,
   player) {
      return function () {
         var messageBuilder = function (msg) {
            return Graphics.Collage.move({ctor: "_Tuple2"
                                         ,_0: 0
                                         ,_1: gameState.course.downwind.y + 40})(Graphics.Collage.toForm(Text.centered(Render.Utils.baseText(msg))));
         };
         return function () {
            var _v1 = gameState.countdown;
            switch (_v1.ctor)
            {case "Just":
               return _U.cmp(_v1._0,
                 0) > 0 ? Maybe.Just(messageBuilder(formatCountdown(Core.getCountdown(gameState.countdown)))) : _U.eq(player.nextGate,
                 Maybe.Just("StartLine")) ? Maybe.Just(messageBuilder("Go!")) : Maybe.Nothing;
               case "Nothing":
               return gameState.isMaster ? Maybe.Just(messageBuilder(Render.Utils.startCountdownMessage)) : Maybe.Nothing;}
            _E.Case($moduleName,
            "between lines 184 and 194");
         }();
      }();
   });
   var renderGateLaylines = F3(function (vmg,
   windOrigin,
   gate) {
      return function () {
         var drawLine = function (_v3) {
            return function () {
               switch (_v3.ctor)
               {case "_Tuple2":
                  return Graphics.Collage.traced(Graphics.Collage.solid(Color.white))(A2(Graphics.Collage.segment,
                    _v3._0,
                    _v3._1));}
               _E.Case($moduleName,
               "on line 164, column 26 to 62");
            }();
         };
         var windAngleRad = Core.toRadians(windOrigin);
         var $ = Game.getGateMarks(gate),
         leftMark = $._0,
         rightMark = $._1;
         var vmgRad = Core.toRadians(vmg);
         var leftLineEnd = A2(Geo.add,
         leftMark,
         Basics.fromPolar({ctor: "_Tuple2"
                          ,_0: 1000
                          ,_1: windAngleRad + vmgRad + Basics.pi / 2}));
         var rightLineEnd = A2(Geo.add,
         rightMark,
         Basics.fromPolar({ctor: "_Tuple2"
                          ,_0: 1000
                          ,_1: windAngleRad - vmgRad - Basics.pi / 2}));
         return Graphics.Collage.alpha(0.3)(Graphics.Collage.group(A2(List.map,
         drawLine,
         _L.fromArray([{ctor: "_Tuple2"
                       ,_0: leftMark
                       ,_1: leftLineEnd}
                      ,{ctor: "_Tuple2"
                       ,_0: rightMark
                       ,_1: rightLineEnd}]))));
      }();
   });
   var renderLaylines = F2(function (player,
   course) {
      return function () {
         var _v7 = player.nextGate;
         switch (_v7.ctor)
         {case "Just": switch (_v7._0)
              {case "DownwindGate":
                 return Maybe.Just(A3(renderGateLaylines,
                   player.downwindVmg,
                   player.windOrigin,
                   course.downwind));
                 case "UpwindGate":
                 return Maybe.Just(A3(renderGateLaylines,
                   player.upwindVmg,
                   player.windOrigin,
                   course.upwind));}
              break;}
         return Maybe.Nothing;
      }();
   });
   var renderBuoy = F2(function (timer,
   _v9) {
      return function () {
         return function () {
            var a = 0.4 + 0.2 * Basics.cos(timer * 5.0e-3);
            return Graphics.Collage.alpha(a)(Graphics.Collage.move(_v9.position)(Graphics.Collage.filled(Render.Utils.colors.buoy)(Graphics.Collage.circle(_v9.radius))));
         }();
      }();
   });
   var renderIsland = function (_v11) {
      return function () {
         return Graphics.Collage.move(_v11.location)(Graphics.Collage.filled(Render.Utils.colors.sand)(Graphics.Collage.circle(_v11.radius)));
      }();
   };
   var renderIslands = function (gameState) {
      return Graphics.Collage.group(A2(List.map,
      renderIsland,
      gameState.course.islands));
   };
   var renderGust = F2(function (wind,
   gust) {
      return function () {
         var color = _U.cmp(gust.speed,
         0) > 0 ? Color.black : Color.white;
         var a = 0.3 * Basics.abs(gust.speed) / 10;
         return Graphics.Collage.move(gust.position)(Graphics.Collage.alpha(a)(Graphics.Collage.filled(color)(Graphics.Collage.circle(gust.radius))));
      }();
   });
   var renderGusts = function (wind) {
      return Graphics.Collage.group(A2(List.map,
      renderGust(wind),
      wind.gusts));
   };
   var renderBounds = function (area) {
      return function () {
         var $ = area,
         rightTop = $.rightTop,
         leftBottom = $.leftBottom;
         var w = Basics.fst(rightTop) - Basics.fst(leftBottom);
         var h = Basics.snd(rightTop) - Basics.snd(leftBottom);
         var cw = (Basics.fst(rightTop) + Basics.fst(leftBottom)) / 2;
         var ch = (Basics.snd(rightTop) + Basics.snd(leftBottom)) / 2;
         return Graphics.Collage.move({ctor: "_Tuple2"
                                      ,_0: cw
                                      ,_1: ch})(Graphics.Collage.alpha(0.3)(Graphics.Collage.outlined(Graphics.Collage.dashed(Color.white))(A2(Graphics.Collage.rect,
         w,
         h))));
      }();
   };
   var renderBoatIcon = F2(function (boat,
   name) {
      return Graphics.Collage.rotate(Core.toRadians(boat.heading + 90))(Graphics.Collage.toForm(A3(Graphics.Element.image,
      12,
      20,
      _L.append("/assets/images/",
      _L.append(name,".png")))));
   });
   var renderWindShadow = F2(function (shadowLength,
   boat) {
      return function () {
         var arcAngles = _L.fromArray([-15
                                      ,-10
                                      ,-5
                                      ,0
                                      ,5
                                      ,10
                                      ,15]);
         var shadowDirection = Core.ensure360(boat.windOrigin + 180 + boat.windAngle / 3);
         var endPoints = A2(List.map,
         function (a) {
            return A2(Geo.add,
            boat.position,
            Basics.fromPolar({ctor: "_Tuple2"
                             ,_0: shadowLength
                             ,_1: Core.toRadians(shadowDirection + a)}));
         },
         arcAngles);
         return Graphics.Collage.alpha(0.1)(Graphics.Collage.filled(Color.white)(Graphics.Collage.path({ctor: "::"
                                                                                                       ,_0: boat.position
                                                                                                       ,_1: endPoints})));
      }();
   });
   var renderOpponent = F2(function (shadowLength,
   opponent) {
      return function () {
         var name = Graphics.Collage.alpha(0.3)(Graphics.Collage.move(A2(Geo.add,
         opponent.position,
         {ctor: "_Tuple2"
         ,_0: 0
         ,_1: -25}))(Graphics.Collage.toForm(Text.centered(Render.Utils.baseText(opponent.player.name)))));
         var shadow = A2(renderWindShadow,
         shadowLength,
         opponent);
         var hull = Graphics.Collage.alpha(0.5)(Graphics.Collage.move(opponent.position)(A2(renderBoatIcon,
         opponent,
         "49er")));
         return Graphics.Collage.group(_L.fromArray([shadow
                                                    ,hull
                                                    ,name]));
      }();
   });
   var renderWake = function (wake) {
      return function () {
         var opacityForIndex = function (i) {
            return 0.3 - 0.3 * Basics.toFloat(i) / Basics.toFloat(List.length(wake));
         };
         var style = _U.replace([["color"
                                 ,Color.white]
                                ,["width",3]],
         Graphics.Collage.defaultLine);
         var renderSegment = function (_v13) {
            return function () {
               switch (_v13.ctor)
               {case "_Tuple2":
                  switch (_v13._1.ctor)
                    {case "_Tuple2":
                       return Graphics.Collage.alpha(opacityForIndex(_v13._0))(Graphics.Collage.traced(style)(A2(Graphics.Collage.segment,
                         _v13._1._0,
                         _v13._1._1)));}
                    break;}
               _E.Case($moduleName,
               "on line 77, column 33 to 88");
            }();
         };
         var pairs = List.isEmpty(wake) ? _L.fromArray([]) : Core.indexedMap(F2(function (v0,
         v1) {
            return {ctor: "_Tuple2"
                   ,_0: v0
                   ,_1: v1};
         }))(A2(List.zip,
         wake,
         List.tail(wake)));
         return Graphics.Collage.group(A2(List.map,
         renderSegment,
         pairs));
      }();
   };
   var renderEqualityLine = F2(function (_v19,
   windOrigin) {
      return function () {
         switch (_v19.ctor)
         {case "_Tuple2":
            return function () {
                 var right = Basics.fromPolar({ctor: "_Tuple2"
                                              ,_0: 50
                                              ,_1: Core.toRadians(windOrigin + 90)});
                 var left = Basics.fromPolar({ctor: "_Tuple2"
                                             ,_0: 50
                                             ,_1: Core.toRadians(windOrigin - 90)});
                 return Graphics.Collage.alpha(0.2)(Graphics.Collage.traced(Graphics.Collage.dotted(Color.white))(A2(Graphics.Collage.segment,
                 left,
                 right)));
              }();}
         _E.Case($moduleName,
         "between lines 68 and 70");
      }();
   });
   var vmgColorAndShape = function (player) {
      return function () {
         var s = 4;
         var bad = {ctor: "_Tuple2"
                   ,_0: Color.red
                   ,_1: A2(Graphics.Collage.rect,
                   s * 2,
                   s * 2)};
         var good = {ctor: "_Tuple2"
                    ,_0: Color.green
                    ,_1: Graphics.Collage.circle(s)};
         var warn = {ctor: "_Tuple2"
                    ,_0: Color.orange
                    ,_1: Graphics.Collage.polygon(_L.fromArray([{ctor: "_Tuple2"
                                                                ,_0: 0 - s
                                                                ,_1: 0 - s}
                                                               ,{ctor: "_Tuple2"
                                                                ,_0: s
                                                                ,_1: 0 - s}
                                                               ,{ctor: "_Tuple2"
                                                                ,_0: 0
                                                                ,_1: s}]))};
         var margin = 3;
         var a = Basics.abs(player.windAngle);
         return _U.cmp(a,
         90) < 0 ? _U.cmp(a,
         player.upwindVmg - margin) < 0 ? bad : _U.cmp(a,
         player.upwindVmg + margin) > 0 ? warn : good : _U.cmp(a,
         player.downwindVmg + margin) > 0 ? bad : _U.cmp(a,
         player.downwindVmg - margin) < 0 ? warn : good;
      }();
   };
   var renderPlayerAngles = function (player) {
      return function () {
         var $ = vmgColorAndShape(player),
         vmgColor = $._0,
         vmgShape = $._1;
         var windOriginRadians = Core.toRadians(player.heading - player.windAngle);
         var windMarker = Graphics.Collage.alpha(0.5)(Graphics.Collage.move(Basics.fromPolar({ctor: "_Tuple2"
                                                                                             ,_0: 25
                                                                                             ,_1: windOriginRadians}))(Graphics.Collage.rotate(windOriginRadians + Basics.pi / 2)(Graphics.Collage.filled(Color.white)(Graphics.Collage.polygon(_L.fromArray([{ctor: "_Tuple2"
                                                                                                                                                                                                                                                              ,_0: 0
                                                                                                                                                                                                                                                              ,_1: 4}
                                                                                                                                                                                                                                                             ,{ctor: "_Tuple2"
                                                                                                                                                                                                                                                              ,_0: -4
                                                                                                                                                                                                                                                              ,_1: -4}
                                                                                                                                                                                                                                                             ,{ctor: "_Tuple2"
                                                                                                                                                                                                                                                              ,_0: 4
                                                                                                                                                                                                                                                              ,_1: -4}]))))));
         var windAngleText = Graphics.Collage.alpha(0.5)(Graphics.Collage.move(Basics.fromPolar({ctor: "_Tuple2"
                                                                                                ,_0: 25
                                                                                                ,_1: windOriginRadians + Basics.pi}))(Graphics.Collage.toForm(Text.centered((_U.eq(player.controlMode,
         "FixedAngle") ? Text.line(Text.Under) : Basics.id)(Render.Utils.baseText(_L.append(String.show(Basics.abs(Basics.round(player.windAngle))),
         "&deg;")))))));
         var vmgIndicator = Graphics.Collage.move(Basics.fromPolar({ctor: "_Tuple2"
                                                                   ,_0: 25
                                                                   ,_1: windOriginRadians + Basics.pi / 2}))(Graphics.Collage.group(_L.fromArray([Graphics.Collage.filled(vmgColor)(vmgShape)
                                                                                                                                                 ,Graphics.Collage.outlined(Graphics.Collage.solid(Color.white))(vmgShape)])));
         return Graphics.Collage.group(_L.fromArray([windMarker
                                                    ,windAngleText
                                                    ,vmgIndicator]));
      }();
   };
   var renderPlayer = F3(function (player,
   spells,
   shadowLength) {
      return function () {
         var wake = renderWake(player.trail);
         var fog2 = Graphics.Collage.alpha(0.8)(Graphics.Collage.rotate(Basics.fst(player.position) / 41 + 220)(Graphics.Collage.filled(Color.white)(A2(Graphics.Collage.oval,
         170,
         230))));
         var fog1 = Graphics.Collage.rotate(Basics.snd(player.position) / 60)(Graphics.Collage.filled(Color.grey)(A2(Graphics.Collage.oval,
         190,
         250)));
         var fog = A2(Game.containsSpell,
         "Fog",
         spells) ? _L.fromArray([fog1
                                ,fog2]) : _L.fromArray([]);
         var eqLine = A2(renderEqualityLine,
         player.position,
         player.windOrigin);
         var angles = renderPlayerAngles(player);
         var windShadow = A2(renderWindShadow,
         shadowLength,
         player);
         var boatPath = A2(Game.containsSpell,
         "PoleInversion",
         spells) ? "49er-black" : "49er";
         var hull = A2(renderBoatIcon,
         player,
         boatPath);
         var movingPart = Graphics.Collage.move(player.position)(Graphics.Collage.group(_L.append(_L.fromArray([angles
                                                                                                               ,eqLine
                                                                                                               ,hull]),
         fog)));
         return Graphics.Collage.group(_L.fromArray([wake
                                                    ,windShadow
                                                    ,movingPart]));
      }();
   });
   var renderGate = F3(function (gate,
   markRadius,
   isNext) {
      return function () {
         var lineStyle = isNext ? Graphics.Collage.traced(Graphics.Collage.dotted(Render.Utils.colors.gateLine)) : Graphics.Collage.traced(Graphics.Collage.solid(Render.Utils.colors.seaBlue));
         var $ = Game.getGateMarks(gate),
         left = $._0,
         right = $._1;
         var line = lineStyle(A2(Graphics.Collage.segment,
         left,
         right));
         var leftMark = Graphics.Collage.move(left)(Graphics.Collage.filled(Render.Utils.colors.gateMark)(Graphics.Collage.circle(markRadius)));
         var rightMark = Graphics.Collage.move(right)(Graphics.Collage.filled(Render.Utils.colors.gateMark)(Graphics.Collage.circle(markRadius)));
         return Graphics.Collage.group(_L.fromArray([line
                                                    ,leftMark
                                                    ,rightMark]));
      }();
   });
   var renderStartLine = F4(function (gate,
   markRadius,
   started,
   timer) {
      return function () {
         var a = started ? 0.5 + 0.5 * Basics.cos(timer * 5.0e-3) : 1;
         var $ = Game.getGateMarks(gate),
         left = $._0,
         right = $._1;
         var marks = A2(List.map,
         function (g) {
            return Graphics.Collage.move(g)(Graphics.Collage.filled(Render.Utils.colors.gateMark)(Graphics.Collage.circle(markRadius)));
         },
         _L.fromArray([left,right]));
         var lineStyle = started ? Graphics.Collage.dotted(Color.green) : Graphics.Collage.solid(Color.orange);
         var line = Graphics.Collage.alpha(a)(Graphics.Collage.traced(lineStyle)(A2(Graphics.Collage.segment,
         left,
         right)));
         return Graphics.Collage.group({ctor: "::"
                                       ,_0: line
                                       ,_1: marks});
      }();
   });
   var renderRace = function (_v23) {
      return function () {
         return function () {
            var maybeForms = _L.fromArray([A2(renderCountdown,
                                          _v23,
                                          _v23.player)
                                          ,A2(Core.mapMaybe,
                                          function (c) {
                                             return Graphics.Collage.group(A2(List.map,
                                             renderBuoy(c),
                                             _v23.buoys));
                                          },
                                          _v23.countdown)
                                          ,A2(renderLaylines,
                                          _v23.player,
                                          _v23.course)
                                          ,A2(renderFinished,
                                          _v23.course,
                                          _v23.player)]);
            var downwindOrStartLine = List.isEmpty(_v23.player.crossedGates) ? A4(renderStartLine,
            _v23.course.downwind,
            _v23.course.markRadius,
            Core.isStarted(_v23.countdown),
            _v23.now) : A3(renderGate,
            _v23.course.downwind,
            _v23.course.markRadius,
            _U.eq(_v23.player.nextGate,
            Maybe.Just("DownwindGate")));
            var justForms = _L.fromArray([renderBounds(_v23.course.area)
                                         ,renderIslands(_v23)
                                         ,downwindOrStartLine
                                         ,A3(renderGate,
                                         _v23.course.upwind,
                                         _v23.course.markRadius,
                                         _U.eq(_v23.player.nextGate,
                                         Maybe.Just("UpwindGate")))
                                         ,Graphics.Collage.group(A2(List.map,
                                         renderOpponent(_v23.course.windShadowLength),
                                         _v23.opponents))
                                         ,renderGusts(_v23.wind)
                                         ,A3(renderPlayer,
                                         _v23.player,
                                         _v23.triggeredSpells,
                                         _v23.course.windShadowLength)]);
            return Graphics.Collage.move(Geo.neg(_v23.center))(Graphics.Collage.group(_L.append(justForms,
            Core.compact(maybeForms))));
         }();
      }();
   };
   _elm.Render.Race.values = {_op: _op
                             ,renderStartLine: renderStartLine
                             ,renderGate: renderGate
                             ,vmgColorAndShape: vmgColorAndShape
                             ,renderPlayerAngles: renderPlayerAngles
                             ,renderEqualityLine: renderEqualityLine
                             ,renderWake: renderWake
                             ,renderWindShadow: renderWindShadow
                             ,renderBoatIcon: renderBoatIcon
                             ,renderPlayer: renderPlayer
                             ,renderOpponent: renderOpponent
                             ,renderBounds: renderBounds
                             ,renderGust: renderGust
                             ,renderGusts: renderGusts
                             ,renderIsland: renderIsland
                             ,renderIslands: renderIslands
                             ,renderBuoy: renderBuoy
                             ,renderGateLaylines: renderGateLaylines
                             ,renderLaylines: renderLaylines
                             ,formatCountdown: formatCountdown
                             ,renderCountdown: renderCountdown
                             ,renderFinished: renderFinished
                             ,renderRace: renderRace};
   return _elm.Render.Race.values;
};Elm.Render = Elm.Render || {};
Elm.Render.Controls = Elm.Render.Controls || {};
Elm.Render.Controls.make = function (_elm) {
   "use strict";
   _elm.Render = _elm.Render || {};
   _elm.Render.Controls = _elm.Render.Controls || {};
   if (_elm.Render.Controls.values)
   return _elm.Render.Controls.values;
   var _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _A = _N.Array.make(_elm),
   _E = _N.Error.make(_elm),
   $moduleName = "Render.Controls";
   var Basics = Elm.Basics.make(_elm);
   var Color = Elm.Color.make(_elm);
   var Core = Elm.Core.make(_elm);
   var Game = Elm.Game.make(_elm);
   var Geo = Elm.Geo.make(_elm);
   var Graphics = Graphics || {};
   Graphics.Collage = Elm.Graphics.Collage.make(_elm);
   var Graphics = Graphics || {};
   Graphics.Element = Elm.Graphics.Element.make(_elm);
   var List = Elm.List.make(_elm);
   var Maybe = Elm.Maybe.make(_elm);
   var Native = Native || {};
   Native.Json = Elm.Native.Json.make(_elm);
   var Native = Native || {};
   Native.Ports = Elm.Native.Ports.make(_elm);
   var Render = Render || {};
   Render.Utils = Elm.Render.Utils.make(_elm);
   var Signal = Elm.Signal.make(_elm);
   var String = Elm.String.make(_elm);
   var Text = Elm.Text.make(_elm);
   var Time = Elm.Time.make(_elm);
   var _op = {};
   var renderHelp = F2(function (countdownMaybe,
   _v0) {
      return function () {
         switch (_v0.ctor)
         {case "_Tuple2":
            return A3(Maybe.maybe,
              true,
              function (c) {
                 return _U.cmp(c,0) > 0;
              },
              countdownMaybe) ? function () {
                 var text = Graphics.Collage.alpha(0.8)(Graphics.Collage.move({ctor: "_Tuple2"
                                                                              ,_0: 0
                                                                              ,_1: (0 - _v0._1) / 2 + 50})(Graphics.Collage.toForm(Text.centered(Render.Utils.baseText(Render.Utils.helpMessage)))));
                 return Maybe.Just(text);
              }() : Maybe.Nothing;}
         _E.Case($moduleName,
         "between lines 147 and 151");
      }();
   });
   var renderLeaderboard = F2(function (leaderboard,
   _v4) {
      return function () {
         switch (_v4.ctor)
         {case "_Tuple2":
            return List.isEmpty(leaderboard) ? Maybe.Nothing : Maybe.Just(Graphics.Collage.move({ctor: "_Tuple2"
                                                                                                ,_0: (0 - _v4._0) / 2 + 50
                                                                                                ,_1: 0})(Graphics.Collage.toForm(Text.leftAligned(Render.Utils.baseText(List.concat(A2(Core.indexedMap,
              F2(function (i,n) {
                 return _L.append(String.show(i + 1),
                 _L.append(". ",
                 _L.append(n,"\n")));
              }),
              leaderboard)))))));}
         _E.Case($moduleName,
         "between lines 137 and 143");
      }();
   });
   var getArrow = _L.fromArray([{ctor: "_Tuple2"
                                ,_0: -3
                                ,_1: 1}
                               ,{ctor: "_Tuple2",_0: 1,_1: 1}
                               ,{ctor: "_Tuple2",_0: 1,_1: 2}
                               ,{ctor: "_Tuple2",_0: 3,_1: 0}
                               ,{ctor: "_Tuple2",_0: 1,_1: -2}
                               ,{ctor: "_Tuple2",_0: 1,_1: -1}
                               ,{ctor: "_Tuple2"
                                ,_0: -3
                                ,_1: -1}]);
   var renderFog = function () {
      var upLine = Graphics.Collage.alpha(0.6)(Graphics.Collage.traced(_U.replace([["width"
                                                                                   ,5]
                                                                                  ,["color"
                                                                                   ,Color.white]],
      Graphics.Collage.defaultLine))(A2(Graphics.Collage.segment,
      {ctor: "_Tuple2"
      ,_0: -12
      ,_1: -8},
      {ctor: "_Tuple2"
      ,_0: 12
      ,_1: -8})));
      var midLine = Graphics.Collage.move({ctor: "_Tuple2"
                                          ,_0: 0
                                          ,_1: 8})(upLine);
      var botLine = Graphics.Collage.move({ctor: "_Tuple2"
                                          ,_0: 0
                                          ,_1: 16})(upLine);
      return Graphics.Collage.group(_L.fromArray([upLine
                                                 ,midLine
                                                 ,botLine]));
   }();
   var renderPoleInversion = function () {
      var arrow = Graphics.Collage.filled(Color.white)(Graphics.Collage.polygon(A2(List.map,
      Geo.scale(3),
      getArrow)));
      var leftArrow = Graphics.Collage.move({ctor: "_Tuple2"
                                            ,_0: -1
                                            ,_1: 6})(arrow);
      var rightArrow = Graphics.Collage.move({ctor: "_Tuple2"
                                             ,_0: 1
                                             ,_1: -6})(Graphics.Collage.rotate(Basics.degrees(180))(arrow));
      return Graphics.Collage.group(_L.fromArray([leftArrow
                                                 ,rightArrow]));
   }();
   var getSpellStockGraphic = function (kind) {
      return function () {
         switch (kind)
         {case "Fog": return renderFog;
            case "PoleInversion":
            return renderPoleInversion;}
         _E.Case($moduleName,
         "between lines 120 and 122");
      }();
   };
   var renderStockSpell = F2(function (spell,
   _v9) {
      return function () {
         switch (_v9.ctor)
         {case "_Tuple2":
            return function () {
                 var spellGraphics = getSpellStockGraphic(spell.kind);
                 var outlineSquare = Graphics.Collage.outlined(Graphics.Collage.solid(Color.white))(Graphics.Collage.square(35));
                 var spellLabel = Graphics.Collage.move({ctor: "_Tuple2"
                                                        ,_0: 0
                                                        ,_1: 35})(Graphics.Collage.toForm(Text.centered(Render.Utils.baseText("SPELL"))));
                 return Graphics.Collage.move({ctor: "_Tuple2"
                                              ,_0: _v9._0 / 2 - 45
                                              ,_1: _v9._1 / 2 - 250})(Graphics.Collage.group(_L.fromArray([spellLabel
                                                                                                          ,outlineSquare
                                                                                                          ,spellGraphics])));
              }();}
         _E.Case($moduleName,
         "between lines 87 and 96");
      }();
   });
   var renderWindWheel = F3(function (wind,
   player,
   _v13) {
      return function () {
         switch (_v13.ctor)
         {case "_Tuple2":
            return function () {
                 var legend = Graphics.Collage.move({ctor: "_Tuple2"
                                                    ,_0: 0
                                                    ,_1: -50})(Graphics.Collage.toForm(Text.centered(Render.Utils.baseText("WIND"))));
                 var windSpeedText = Graphics.Collage.toForm(Text.centered(Render.Utils.baseText(_L.append(String.show(Basics.round(wind.speed)),
                 "kn"))));
                 var windOriginRadians = Core.toRadians(wind.origin);
                 var r = 25 + wind.speed * 0.5;
                 var c = Graphics.Collage.outlined(Graphics.Collage.solid(Color.white))(Graphics.Collage.circle(r));
                 var windMarker = Graphics.Collage.move(Basics.fromPolar({ctor: "_Tuple2"
                                                                         ,_0: r + 4
                                                                         ,_1: windOriginRadians}))(Graphics.Collage.rotate(windOriginRadians + Basics.pi / 2)(Graphics.Collage.filled(Color.white)(Graphics.Collage.polygon(_L.fromArray([{ctor: "_Tuple2"
                                                                                                                                                                                                                                          ,_0: 0
                                                                                                                                                                                                                                          ,_1: 4}
                                                                                                                                                                                                                                         ,{ctor: "_Tuple2"
                                                                                                                                                                                                                                          ,_0: -4
                                                                                                                                                                                                                                          ,_1: -4}
                                                                                                                                                                                                                                         ,{ctor: "_Tuple2"
                                                                                                                                                                                                                                          ,_0: 4
                                                                                                                                                                                                                                          ,_1: -4}])))));
                 var windOriginText = Graphics.Collage.move({ctor: "_Tuple2"
                                                            ,_0: 0
                                                            ,_1: r + 20})(Graphics.Collage.toForm(Text.centered(Render.Utils.baseText(_L.append(String.show(Basics.round(wind.origin)),
                 "&deg;")))));
                 return Graphics.Collage.alpha(0.8)(Graphics.Collage.move({ctor: "_Tuple2"
                                                                          ,_0: _v13._0 / 2 - 50
                                                                          ,_1: _v13._1 / 2 - 80})(Graphics.Collage.group(_L.fromArray([c
                                                                                                                                      ,windMarker
                                                                                                                                      ,windOriginText
                                                                                                                                      ,windSpeedText
                                                                                                                                      ,legend]))));
              }();}
         _E.Case($moduleName,
         "between lines 69 and 83");
      }();
   });
   var renderLapsCount = F3(function (_v17,
   course,
   player) {
      return function () {
         switch (_v17.ctor)
         {case "_Tuple2":
            return function () {
                 var count = List.minimum(_L.fromArray([A2(Basics.div,
                                                       List.length(player.crossedGates) + 1,
                                                       2)
                                                       ,course.laps]));
                 var msg = _L.append("LAP ",
                 _L.append(String.show(count),
                 _L.append("/",
                 String.show(course.laps))));
                 return Graphics.Collage.move({ctor: "_Tuple2"
                                              ,_0: (0 - _v17._0) / 2 + 50
                                              ,_1: _v17._1 / 2 - 30})(Graphics.Collage.toForm(Text.leftAligned(Render.Utils.baseText(msg))));
              }();}
         _E.Case($moduleName,
         "between lines 37 and 43");
      }();
   });
   var gateHintLabel = function (d) {
      return Graphics.Collage.toForm(Text.centered(Render.Utils.baseText(_L.append("Next gate in ",
      _L.append(String.show(d),
      "m")))));
   };
   var renderGateHint = F4(function (gate,
   _v21,
   _v22,
   timer) {
      return function () {
         switch (_v22.ctor)
         {case "_Tuple2":
            return function () {
                 switch (_v21.ctor)
                 {case "_Tuple2":
                    return function () {
                         var distance = function (isOver) {
                            return Basics.round(Basics.abs(gate.y + (isOver ? 0 - _v21._1 : _v21._1) / 2 - _v22._1) / 2);
                         };
                         var a = 1 + 0.5 * Basics.cos(timer * 5.0e-3);
                         var markStyle = Graphics.Collage.filled(Color.orange);
                         var c = 5;
                         var isOver = _U.cmp(_v22._1 + _v21._1 / 2 + c,
                         gate.y) < 0;
                         var isUnder = _U.cmp(_v22._1 - _v21._1 / 2 - c,
                         gate.y) > 0;
                         var side = isOver ? _v21._1 / 2 : isUnder ? (0 - _v21._1) / 2 : 0;
                         var $ = Game.getGateMarks(gate),
                         left = $._0,
                         right = $._1;
                         return isOver || isUnder ? Maybe.Just(function () {
                            var textY = _U.cmp(side,
                            0) > 0 ? 0 - c : c;
                            var d = Graphics.Collage.alpha(a)(Graphics.Collage.move({ctor: "_Tuple2"
                                                                                    ,_0: 0 - _v22._0
                                                                                    ,_1: side + textY * 4})(gateHintLabel(distance(_U.cmp(side,
                            0) > 0))));
                            var mr = Graphics.Collage.move({ctor: "_Tuple2"
                                                           ,_0: 0 - _v22._0 + gate.width / 2
                                                           ,_1: side})(markStyle(A2(Render.Utils.triangle,
                            c,
                            _U.cmp(side,0) > 0)));
                            var ml = Graphics.Collage.move({ctor: "_Tuple2"
                                                           ,_0: 0 - _v22._0 - gate.width / 2
                                                           ,_1: side})(markStyle(A2(Render.Utils.triangle,
                            c,
                            _U.cmp(side,0) > 0)));
                            return Graphics.Collage.group(_L.fromArray([ml
                                                                       ,mr
                                                                       ,d]));
                         }()) : Maybe.Nothing;
                      }();}
                 _E.Case($moduleName,
                 "between lines 16 and 33");
              }();}
         _E.Case($moduleName,
         "between lines 16 and 33");
      }();
   });
   var renderControls = F2(function (_v29,
   dims) {
      return function () {
         return function () {
            var upwindHint = _U.eq(_v29.player.nextGate,
            Maybe.Just("UpwindGate")) ? A4(renderGateHint,
            _v29.course.upwind,
            dims,
            _v29.center,
            _v29.now) : Maybe.Nothing;
            var downwindHint = _U.eq(_v29.player.nextGate,
            Maybe.Just("DownwindGate")) ? A4(renderGateHint,
            _v29.course.downwind,
            dims,
            _v29.center,
            _v29.now) : Maybe.Nothing;
            var maybeForms = _L.fromArray([downwindHint
                                          ,upwindHint
                                          ,A2(renderHelp,
                                          _v29.countdown,
                                          dims)
                                          ,A2(renderLeaderboard,
                                          _v29.leaderboard,
                                          dims)
                                          ,function () {
                                             var _v31 = _v29.player.ownSpell;
                                             switch (_v31.ctor)
                                             {case "Just":
                                                return Maybe.Just(A2(renderStockSpell,
                                                  _v31._0,
                                                  dims));
                                                case "Nothing":
                                                return Maybe.Nothing;}
                                             _E.Case($moduleName,
                                             "between lines 171 and 174");
                                          }()]);
            var justForms = _L.fromArray([A3(renderLapsCount,
                                         dims,
                                         _v29.course,
                                         _v29.player)
                                         ,A3(renderWindWheel,
                                         _v29.wind,
                                         _v29.player,
                                         dims)]);
            return Graphics.Collage.group(_L.append(justForms,
            Core.compact(maybeForms)));
         }();
      }();
   });
   _elm.Render.Controls.values = {_op: _op
                                 ,gateHintLabel: gateHintLabel
                                 ,renderGateHint: renderGateHint
                                 ,renderLapsCount: renderLapsCount
                                 ,renderWindWheel: renderWindWheel
                                 ,renderStockSpell: renderStockSpell
                                 ,renderPoleInversion: renderPoleInversion
                                 ,renderFog: renderFog
                                 ,getSpellStockGraphic: getSpellStockGraphic
                                 ,getArrow: getArrow
                                 ,renderLeaderboard: renderLeaderboard
                                 ,renderHelp: renderHelp
                                 ,renderControls: renderControls};
   return _elm.Render.Controls.values;
};Elm.Inputs = Elm.Inputs || {};
Elm.Inputs.make = function (_elm) {
   "use strict";
   _elm.Inputs = _elm.Inputs || {};
   if (_elm.Inputs.values)
   return _elm.Inputs.values;
   var _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _A = _N.Array.make(_elm),
   _E = _N.Error.make(_elm),
   $moduleName = "Inputs";
   var Basics = Elm.Basics.make(_elm);
   var Char = Elm.Char.make(_elm);
   var Color = Elm.Color.make(_elm);
   var Drag = Elm.Drag.make(_elm);
   var Game = Elm.Game.make(_elm);
   var Graphics = Graphics || {};
   Graphics.Collage = Elm.Graphics.Collage.make(_elm);
   var Graphics = Graphics || {};
   Graphics.Element = Elm.Graphics.Element.make(_elm);
   var Keyboard = Elm.Keyboard.make(_elm);
   var List = Elm.List.make(_elm);
   var Maybe = Elm.Maybe.make(_elm);
   var Mouse = Elm.Mouse.make(_elm);
   var Native = Native || {};
   Native.Json = Elm.Native.Json.make(_elm);
   var Native = Native || {};
   Native.Ports = Elm.Native.Ports.make(_elm);
   var Signal = Elm.Signal.make(_elm);
   var String = Elm.String.make(_elm);
   var Text = Elm.Text.make(_elm);
   var Time = Elm.Time.make(_elm);
   var _op = {};
   var Input = F6(function (a,
   b,
   c,
   d,
   e,
   f) {
      return {_: {}
             ,chrono: b
             ,delta: a
             ,keyboardInput: c
             ,mouseInput: d
             ,raceInput: f
             ,windowInput: e};
   });
   var chrono = A3(Signal.foldp,
   F2(function (x,y) {
      return x + y;
   }),
   0,
   Time.fps(1));
   var RaceInput = function (a) {
      return function (b) {
         return function (c) {
            return function (d) {
               return function (e) {
                  return function (f) {
                     return function (g) {
                        return function (h) {
                           return function (i) {
                              return function (j) {
                                 return {_: {}
                                        ,buoys: g
                                        ,course: c
                                        ,isMaster: j
                                        ,leaderboard: i
                                        ,now: a
                                        ,opponents: f
                                        ,player: d
                                        ,startTime: b
                                        ,triggeredSpells: h
                                        ,wind: e};
                              };
                           };
                        };
                     };
                  };
               };
            };
         };
      };
   };
   var MouseInput = F2(function (a,
   b) {
      return {_: {}
             ,drag: a
             ,mouse: b};
   });
   var mouseInput = A3(Signal.lift2,
   MouseInput,
   Drag.lastPosition(20 * Time.millisecond),
   Mouse.position);
   var KeyboardInput = F6(function (a,
   b,
   c,
   d,
   e,
   f) {
      return {_: {}
             ,arrows: a
             ,lock: b
             ,spellCast: e
             ,startCountdown: f
             ,subtleTurn: d
             ,tack: c};
   });
   var keyboardInput = A7(Signal.lift6,
   KeyboardInput,
   Keyboard.arrows,
   Keyboard.enter,
   Keyboard.space,
   Keyboard.shift,
   Keyboard.isDown(Char.toCode(_U.chr("S"))),
   Keyboard.isDown(Char.toCode(_U.chr("C"))));
   var UserArrows = F2(function (a,
   b) {
      return {_: {},x: a,y: b};
   });
   _elm.Inputs.values = {_op: _op
                        ,mouseInput: mouseInput
                        ,keyboardInput: keyboardInput
                        ,chrono: chrono
                        ,UserArrows: UserArrows
                        ,KeyboardInput: KeyboardInput
                        ,MouseInput: MouseInput
                        ,RaceInput: RaceInput
                        ,Input: Input};
   return _elm.Inputs.values;
};Elm.Game = Elm.Game || {};
Elm.Game.make = function (_elm) {
   "use strict";
   _elm.Game = _elm.Game || {};
   if (_elm.Game.values)
   return _elm.Game.values;
   var _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _A = _N.Array.make(_elm),
   _E = _N.Error.make(_elm),
   $moduleName = "Game";
   var Basics = Elm.Basics.make(_elm);
   var Color = Elm.Color.make(_elm);
   var Dict = Elm.Dict.make(_elm);
   var Geo = Elm.Geo.make(_elm);
   var Graphics = Graphics || {};
   Graphics.Collage = Elm.Graphics.Collage.make(_elm);
   var Graphics = Graphics || {};
   Graphics.Element = Elm.Graphics.Element.make(_elm);
   var Json = Elm.Json.make(_elm);
   var List = Elm.List.make(_elm);
   var Maybe = Elm.Maybe.make(_elm);
   var Native = Native || {};
   Native.Json = Elm.Native.Json.make(_elm);
   var Native = Native || {};
   Native.Ports = Elm.Native.Ports.make(_elm);
   var Signal = Elm.Signal.make(_elm);
   var String = Elm.String.make(_elm);
   var Text = Elm.Text.make(_elm);
   var Time = Elm.Time.make(_elm);
   var _op = {};
   var getGateMarks = function (gate) {
      return {ctor: "_Tuple2"
             ,_0: {ctor: "_Tuple2"
                  ,_0: (0 - gate.width) / 2
                  ,_1: gate.y}
             ,_1: {ctor: "_Tuple2"
                  ,_0: gate.width / 2
                  ,_1: gate.y}};
   };
   var defaultWind = {_: {}
                     ,gusts: _L.fromArray([])
                     ,origin: 0
                     ,speed: 0};
   var defaultPlayer = {_: {}
                       ,controlMode: "FixedHeading"
                       ,crossedGates: _L.fromArray([])
                       ,downwindVmg: 0
                       ,heading: 0
                       ,nextGate: Maybe.Nothing
                       ,ownSpell: Maybe.Nothing
                       ,position: {ctor: "_Tuple2"
                                  ,_0: 0
                                  ,_1: 0}
                       ,tackTarget: Maybe.Nothing
                       ,trail: _L.fromArray([])
                       ,upwindVmg: 0
                       ,velocity: 0
                       ,windAngle: 0
                       ,windOrigin: 0
                       ,windSpeed: 0};
   var defaultGate = {_: {}
                     ,width: 0
                     ,y: 0};
   var defaultCourse = {_: {}
                       ,area: {_: {}
                              ,leftBottom: {ctor: "_Tuple2"
                                           ,_0: 0
                                           ,_1: 0}
                              ,rightTop: {ctor: "_Tuple2"
                                         ,_0: 0
                                         ,_1: 0}}
                       ,boatWidth: 0
                       ,downwind: defaultGate
                       ,islands: _L.fromArray([])
                       ,laps: 0
                       ,markRadius: 0
                       ,upwind: defaultGate
                       ,windShadowLength: 0};
   var defaultGame = {_: {}
                     ,buoys: _L.fromArray([])
                     ,center: {ctor: "_Tuple2"
                              ,_0: 0
                              ,_1: 0}
                     ,countdown: Maybe.Nothing
                     ,course: defaultCourse
                     ,isMaster: false
                     ,leaderboard: _L.fromArray([])
                     ,now: 0
                     ,opponents: _L.fromArray([])
                     ,player: defaultPlayer
                     ,triggeredSpells: _L.fromArray([])
                     ,wake: _L.fromArray([])
                     ,wind: defaultWind};
   var RaceState = function (a) {
      return {_: {},players: a};
   };
   var GameState = function (a) {
      return function (b) {
         return function (c) {
            return function (d) {
               return function (e) {
                  return function (f) {
                     return function (g) {
                        return function (h) {
                           return function (i) {
                              return function (j) {
                                 return function (k) {
                                    return function (l) {
                                       return {_: {}
                                              ,buoys: f
                                              ,center: d
                                              ,countdown: j
                                              ,course: g
                                              ,isMaster: l
                                              ,leaderboard: h
                                              ,now: i
                                              ,opponents: e
                                              ,player: b
                                              ,triggeredSpells: k
                                              ,wake: c
                                              ,wind: a};
                                    };
                                 };
                              };
                           };
                        };
                     };
                  };
               };
            };
         };
      };
   };
   var Wind = F3(function (a,b,c) {
      return {_: {}
             ,gusts: c
             ,origin: a
             ,speed: b};
   });
   var Gust = F4(function (a,
   b,
   c,
   d) {
      return {_: {}
             ,angle: b
             ,position: a
             ,radius: d
             ,speed: c};
   });
   var Buoy = F3(function (a,b,c) {
      return {_: {}
             ,position: a
             ,radius: b
             ,spell: c};
   });
   var containsSpell = F2(function (spellName,
   spells) {
      return function () {
         var filtredSpells = A2(List.filter,
         function (spell) {
            return _U.eq(spell.kind,
            spellName);
         },
         spells);
         return _U.cmp(List.length(filtredSpells),
         0) > 0;
      }();
   });
   var Spell = function (a) {
      return {_: {},kind: a};
   };
   var Boat = F7(function (a,
   b,
   c,
   d,
   e,
   f,
   g) {
      return _U.insert("windSpeed",
      f,
      _U.insert("windOrigin",
      e,
      _U.insert("windAngle",
      d,
      _U.insert("velocity",
      c,
      _U.insert("heading",
      b,
      _U.insert("position",a,g))))));
   });
   var Course = F8(function (a,
   b,
   c,
   d,
   e,
   f,
   g,
   h) {
      return {_: {}
             ,area: f
             ,boatWidth: h
             ,downwind: b
             ,islands: e
             ,laps: c
             ,markRadius: d
             ,upwind: a
             ,windShadowLength: g};
   });
   var RaceArea = F2(function (a,
   b) {
      return {_: {}
             ,leftBottom: b
             ,rightTop: a};
   });
   var Island = F2(function (a,b) {
      return {_: {}
             ,location: a
             ,radius: b};
   });
   var Gate = F2(function (a,b) {
      return {_: {},width: b,y: a};
   });
   _elm.Game.values = {_op: _op
                      ,containsSpell: containsSpell
                      ,defaultGate: defaultGate
                      ,defaultCourse: defaultCourse
                      ,defaultPlayer: defaultPlayer
                      ,defaultWind: defaultWind
                      ,defaultGame: defaultGame
                      ,getGateMarks: getGateMarks
                      ,Gate: Gate
                      ,Island: Island
                      ,RaceArea: RaceArea
                      ,Course: Course
                      ,Boat: Boat
                      ,Spell: Spell
                      ,Buoy: Buoy
                      ,Gust: Gust
                      ,Wind: Wind
                      ,GameState: GameState
                      ,RaceState: RaceState};
   return _elm.Game.values;
};Elm.Geo = Elm.Geo || {};
Elm.Geo.make = function (_elm) {
   "use strict";
   _elm.Geo = _elm.Geo || {};
   if (_elm.Geo.values)
   return _elm.Geo.values;
   var _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _A = _N.Array.make(_elm),
   _E = _N.Error.make(_elm),
   $moduleName = "Geo";
   var Basics = Elm.Basics.make(_elm);
   var Color = Elm.Color.make(_elm);
   var Core = Elm.Core.make(_elm);
   var Graphics = Graphics || {};
   Graphics.Collage = Elm.Graphics.Collage.make(_elm);
   var Graphics = Graphics || {};
   Graphics.Element = Elm.Graphics.Element.make(_elm);
   var List = Elm.List.make(_elm);
   var Maybe = Elm.Maybe.make(_elm);
   var Native = Native || {};
   Native.Json = Elm.Native.Json.make(_elm);
   var Native = Native || {};
   Native.Ports = Elm.Native.Ports.make(_elm);
   var Signal = Elm.Signal.make(_elm);
   var String = Elm.String.make(_elm);
   var Text = Elm.Text.make(_elm);
   var Time = Elm.Time.make(_elm);
   var _op = {};
   var movePoint = F4(function (_v0,
   delta,
   velocity,
   direction) {
      return function () {
         switch (_v0.ctor)
         {case "_Tuple2":
            return function () {
                 var angle = Core.toRadians(direction);
                 var x$ = _v0._0 + delta * 1.0e-3 * velocity * Basics.cos(angle);
                 var y$ = _v0._1 + delta * 1.0e-3 * velocity * Basics.sin(angle);
                 return {ctor: "_Tuple2"
                        ,_0: x$
                        ,_1: y$};
              }();}
         _E.Case($moduleName,
         "between lines 36 and 39");
      }();
   });
   var toBox = F3(function (_v4,
   w,
   h) {
      return function () {
         switch (_v4.ctor)
         {case "_Tuple2":
            return {ctor: "_Tuple2"
                   ,_0: {ctor: "_Tuple2"
                        ,_0: _v4._0 + w / 2
                        ,_1: _v4._1 + h / 2}
                   ,_1: {ctor: "_Tuple2"
                        ,_0: _v4._0 - w / 2
                        ,_1: _v4._1 - h / 2}};}
         _E.Case($moduleName,
         "on line 32, column 4 to 42");
      }();
   });
   var inBox = F2(function (_v8,
   _v9) {
      return function () {
         switch (_v9.ctor)
         {case "_Tuple2":
            switch (_v9._0.ctor)
              {case "_Tuple2":
                 switch (_v9._1.ctor)
                   {case "_Tuple2":
                      return function () {
                           switch (_v8.ctor)
                           {case "_Tuple2":
                              return _U.cmp(_v8._0,
                                _v9._1._0) > 0 && (_U.cmp(_v8._0,
                                _v9._0._0) < 0 && (_U.cmp(_v8._1,
                                _v9._1._1) > 0 && _U.cmp(_v8._1,
                                _v9._0._1) < 0));}
                           _E.Case($moduleName,
                           "on line 28, column 3 to 47");
                        }();}
                   break;}
              break;}
         _E.Case($moduleName,
         "on line 28, column 3 to 47");
      }();
   });
   var distance = F2(function (_v20,
   _v21) {
      return function () {
         switch (_v21.ctor)
         {case "_Tuple2":
            return function () {
                 switch (_v20.ctor)
                 {case "_Tuple2":
                    return Basics.sqrt(Math.pow(_v20._0 - _v21._0,
                      2) + Math.pow(_v20._1 - _v21._1,
                      2));}
                 _E.Case($moduleName,
                 "on line 24, column 3 to 34");
              }();}
         _E.Case($moduleName,
         "on line 24, column 3 to 34");
      }();
   });
   var scale = F2(function (s,
   _v28) {
      return function () {
         switch (_v28.ctor)
         {case "_Tuple2":
            return {ctor: "_Tuple2"
                   ,_0: _v28._0 * s
                   ,_1: _v28._1 * s};}
         _E.Case($moduleName,
         "on line 20, column 18 to 26");
      }();
   });
   var neg = function (_v32) {
      return function () {
         switch (_v32.ctor)
         {case "_Tuple2":
            return {ctor: "_Tuple2"
                   ,_0: 0 - _v32._0
                   ,_1: 0 - _v32._1};}
         _E.Case($moduleName,
         "on line 17, column 14 to 19");
      }();
   };
   var sub = F2(function (_v36,
   _v37) {
      return function () {
         switch (_v37.ctor)
         {case "_Tuple2":
            return function () {
                 switch (_v36.ctor)
                 {case "_Tuple2":
                    return {ctor: "_Tuple2"
                           ,_0: _v37._0 - _v36._0
                           ,_1: _v37._1 - _v36._1};}
                 _E.Case($moduleName,
                 "on line 14, column 22 to 36");
              }();}
         _E.Case($moduleName,
         "on line 14, column 22 to 36");
      }();
   });
   var add = F2(function (_v44,
   _v45) {
      return function () {
         switch (_v45.ctor)
         {case "_Tuple2":
            return function () {
                 switch (_v44.ctor)
                 {case "_Tuple2":
                    return {ctor: "_Tuple2"
                           ,_0: _v45._0 + _v44._0
                           ,_1: _v45._1 + _v44._1};}
                 _E.Case($moduleName,
                 "on line 11, column 22 to 36");
              }();}
         _E.Case($moduleName,
         "on line 11, column 22 to 36");
      }();
   });
   var floatify = function (_v52) {
      return function () {
         switch (_v52.ctor)
         {case "_Tuple2":
            return {ctor: "_Tuple2"
                   ,_0: Basics.toFloat(_v52._0)
                   ,_1: Basics.toFloat(_v52._1)};}
         _E.Case($moduleName,
         "on line 8, column 19 to 39");
      }();
   };
   _elm.Geo.values = {_op: _op
                     ,floatify: floatify
                     ,add: add
                     ,sub: sub
                     ,neg: neg
                     ,scale: scale
                     ,distance: distance
                     ,inBox: inBox
                     ,toBox: toBox
                     ,movePoint: movePoint};
   return _elm.Geo.values;
};Elm.Core = Elm.Core || {};
Elm.Core.make = function (_elm) {
   "use strict";
   _elm.Core = _elm.Core || {};
   if (_elm.Core.values)
   return _elm.Core.values;
   var _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _A = _N.Array.make(_elm),
   _E = _N.Error.make(_elm),
   $moduleName = "Core";
   var Basics = Elm.Basics.make(_elm);
   var Color = Elm.Color.make(_elm);
   var Graphics = Graphics || {};
   Graphics.Collage = Elm.Graphics.Collage.make(_elm);
   var Graphics = Graphics || {};
   Graphics.Element = Elm.Graphics.Element.make(_elm);
   var List = Elm.List.make(_elm);
   var Maybe = Elm.Maybe.make(_elm);
   var Native = Native || {};
   Native.Json = Elm.Native.Json.make(_elm);
   var Native = Native || {};
   Native.Ports = Elm.Native.Ports.make(_elm);
   var Signal = Elm.Signal.make(_elm);
   var String = Elm.String.make(_elm);
   var Text = Elm.Text.make(_elm);
   var Time = Elm.Time.make(_elm);
   var _op = {};
   var indexedMap = F2(function (f,
   xs) {
      return A3(List.zipWith,
      f,
      _L.range(0,List.length(xs) - 1),
      xs);
   });
   var average = function (items) {
      return List.sum(items) / Basics.toFloat(List.length(items));
   };
   var compact = function (maybes) {
      return function () {
         var folder = F2(function (m,
         list) {
            return function () {
               switch (m.ctor)
               {case "Just": return {ctor: "::"
                                    ,_0: m._0
                                    ,_1: list};
                  case "Nothing": return list;}
               _E.Case($moduleName,
               "between lines 82 and 85");
            }();
         });
         return A3(List.foldl,
         folder,
         _L.fromArray([]),
         maybes);
      }();
   };
   var mapMaybe = F2(function (f,
   maybe) {
      return function () {
         switch (maybe.ctor)
         {case "Just":
            return Maybe.Just(f(maybe._0));
            case "Nothing":
            return Maybe.Nothing;}
         _E.Case($moduleName,
         "between lines 75 and 77");
      }();
   });
   var getCountdown = function (maybeCountdown) {
      return A3(Maybe.maybe,
      0,
      Basics.id,
      maybeCountdown);
   };
   var isStarted = function (maybeCountdown) {
      return A3(Maybe.maybe,
      false,
      function (n) {
         return _U.cmp(n,0) < 1;
      },
      maybeCountdown);
   };
   var mpsToKnts = function (mps) {
      return mps * 3600 / 1.852 / 1000;
   };
   var toRadians = function (deg) {
      return Basics.radians((90 - deg) * Basics.pi / 180);
   };
   var ensure360 = function (val) {
      return function () {
         var rounded = Basics.round(val);
         var excess = val - Basics.toFloat(rounded);
         return Basics.toFloat(A2(Basics.mod,
         rounded + 360,
         360)) + excess;
      }();
   };
   _elm.Core.values = {_op: _op
                      ,ensure360: ensure360
                      ,toRadians: toRadians
                      ,mpsToKnts: mpsToKnts
                      ,isStarted: isStarted
                      ,getCountdown: getCountdown
                      ,mapMaybe: mapMaybe
                      ,compact: compact
                      ,average: average
                      ,indexedMap: indexedMap};
   return _elm.Core.values;
};Elm.Drag = Elm.Drag || {};
Elm.Drag.make = function (_elm) {
   "use strict";
   _elm.Drag = _elm.Drag || {};
   if (_elm.Drag.values)
   return _elm.Drag.values;
   var _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _A = _N.Array.make(_elm),
   _E = _N.Error.make(_elm),
   $moduleName = "Drag";
   var Basics = Elm.Basics.make(_elm);
   var Color = Elm.Color.make(_elm);
   var Graphics = Graphics || {};
   Graphics.Collage = Elm.Graphics.Collage.make(_elm);
   var Graphics = Graphics || {};
   Graphics.Element = Elm.Graphics.Element.make(_elm);
   var List = Elm.List.make(_elm);
   var Maybe = Elm.Maybe.make(_elm);
   var Mouse = Elm.Mouse.make(_elm);
   var Native = Native || {};
   Native.Json = Elm.Native.Json.make(_elm);
   var Native = Native || {};
   Native.Ports = Elm.Native.Ports.make(_elm);
   var Signal = Elm.Signal.make(_elm);
   var String = Elm.String.make(_elm);
   var Text = Elm.Text.make(_elm);
   var Time = Elm.Time.make(_elm);
   var _op = {};
   var joinMaybe = A2(Maybe.maybe,
   Maybe.Nothing,
   Basics.id);
   var justWhen = F2(function (b,
   s) {
      return A2(Signal._op["~"],
      A2(Signal._op["<~"],
      F2(function (b,x) {
         return b ? Maybe.Just(x) : Maybe.Nothing;
      }),
      b),
      s);
   });
   var lastPosition = function (delay) {
      return F2(function (x,y) {
         return A2(Signal._op["<~"],
         x,
         y);
      })(joinMaybe)(justWhen(Mouse.isDown)(Time.delay(delay)(justWhen(Mouse.isDown)(Mouse.position))));
   };
   var start = justWhen(Mouse.isDown)(Signal.sampleOn(Signal.dropRepeats(Mouse.isDown))(Mouse.position));
   var drop = function () {
      var stop = Mouse.position;
      var start = A2(Signal.keepWhen,
      Mouse.isDown,
      {ctor: "_Tuple2"
      ,_0: 0
      ,_1: 0})(Signal.sampleOn(Signal.dropRepeats(Mouse.isDown))(Mouse.position));
      return justWhen(A2(Signal._op["<~"],
      Basics.not,
      Mouse.isDown))(Signal.sampleOn(Signal.dropRepeats(Mouse.isDown))(A2(Signal._op["~"],
      A2(Signal._op["<~"],
      F2(function (v0,v1) {
         return {ctor: "_Tuple2"
                ,_0: v0
                ,_1: v1};
      }),
      start),
      stop)));
   }();
   _elm.Drag.values = {_op: _op
                      ,justWhen: justWhen
                      ,joinMaybe: joinMaybe
                      ,lastPosition: lastPosition
                      ,start: start
                      ,drop: drop};
   return _elm.Drag.values;
};Elm.Render = Elm.Render || {};
Elm.Render.Utils = Elm.Render.Utils || {};
Elm.Render.Utils.make = function (_elm) {
   "use strict";
   _elm.Render = _elm.Render || {};
   _elm.Render.Utils = _elm.Render.Utils || {};
   if (_elm.Render.Utils.values)
   return _elm.Render.Utils.values;
   var _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _A = _N.Array.make(_elm),
   _E = _N.Error.make(_elm),
   $moduleName = "Render.Utils";
   var Basics = Elm.Basics.make(_elm);
   var Color = Elm.Color.make(_elm);
   var Graphics = Graphics || {};
   Graphics.Collage = Elm.Graphics.Collage.make(_elm);
   var Graphics = Graphics || {};
   Graphics.Element = Elm.Graphics.Element.make(_elm);
   var List = Elm.List.make(_elm);
   var Maybe = Elm.Maybe.make(_elm);
   var Native = Native || {};
   Native.Json = Elm.Native.Json.make(_elm);
   var Native = Native || {};
   Native.Ports = Elm.Native.Ports.make(_elm);
   var Signal = Elm.Signal.make(_elm);
   var String = Elm.String.make(_elm);
   var Text = Elm.Text.make(_elm);
   var Time = Elm.Time.make(_elm);
   var _op = {};
   var triangle = F2(function (s,
   isUpward) {
      return isUpward ? Graphics.Collage.polygon(_L.fromArray([{ctor: "_Tuple2"
                                                               ,_0: 0
                                                               ,_1: 0}
                                                              ,{ctor: "_Tuple2"
                                                               ,_0: 0 - s
                                                               ,_1: 0 - s}
                                                              ,{ctor: "_Tuple2"
                                                               ,_0: s
                                                               ,_1: 0 - s}])) : Graphics.Collage.polygon(_L.fromArray([{ctor: "_Tuple2"
                                                                                                                       ,_0: 0
                                                                                                                       ,_1: 0}
                                                                                                                      ,{ctor: "_Tuple2"
                                                                                                                       ,_0: 0 - s
                                                                                                                       ,_1: s}
                                                                                                                      ,{ctor: "_Tuple2"
                                                                                                                       ,_0: s
                                                                                                                       ,_1: s}]));
   });
   var baseText = function (s) {
      return Text.typeface(_L.fromArray(["Inconsolata"
                                        ,"monospace"]))(Text.height(15)(Text.toText(s)));
   };
   var fullScreenMessage = function (msg) {
      return Graphics.Collage.alpha(0.3)(Graphics.Collage.toForm(Text.centered(Text.color(Color.white)(Text.height(60)(Text.toText(String.toUpper(msg)))))));
   };
   var colors = {_: {}
                ,buoy: Color.white
                ,gateLine: Color.orange
                ,gateMark: Color.orange
                ,sand: A3(Color.rgb,239,210,121)
                ,seaBlue: A3(Color.rgb,
                10,
                105,
                148)};
   var startCountdownMessage = "press C to start countdown (30s)";
   var helpMessage = _L.append("←/→ to turn left/right, SHIFT + ←/→ to fine tune direction, \n",
   "ENTER to lock angle to wind, SPACE to tack/jibe, S to cast a spell");
   _elm.Render.Utils.values = {_op: _op
                              ,helpMessage: helpMessage
                              ,startCountdownMessage: startCountdownMessage
                              ,colors: colors
                              ,fullScreenMessage: fullScreenMessage
                              ,baseText: baseText
                              ,triangle: triangle};
   return _elm.Render.Utils.values;
};