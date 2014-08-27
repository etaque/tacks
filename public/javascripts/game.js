Elm.ShiftMaster = Elm.ShiftMaster || {};
Elm.ShiftMaster.make = function (_elm) {
   "use strict";
   _elm.ShiftMaster = _elm.ShiftMaster || {};
   if (_elm.ShiftMaster.values)
   return _elm.ShiftMaster.values;
   var _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _A = _N.Array.make(_elm),
   _E = _N.Error.make(_elm),
   $moduleName = "ShiftMaster";
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
   var WebSocket = Elm.WebSocket.make(_elm);
   var Window = Elm.Window.make(_elm);
   var _op = {};
   var playerToRaceOutput = function (_v0) {
      return function () {
         return {_: {}
                ,direction: _v0.direction
                ,passedGates: _v0.passedGates
                ,position: _v0.position
                ,velocity: _v0.velocity};
      }();
   };
   var clock = A2(Signal._op["<~"],
   Time.inSeconds,
   Time.fps(30));
   var raceInput = Native.Ports.portIn("raceInput",
   Native.Ports.incomingSignal(function (v) {
      return typeof v === "object" && "now" in v && "startTime" in v && "course" in v && "opponents" in v && "leaderboard" in v ? {_: {}
                                                                                                                                  ,now: typeof v.now === "number" ? v.now : _E.raise("invalid input, expecting JSNumber but got " + v.now)
                                                                                                                                  ,startTime: typeof v.startTime === "number" ? v.startTime : _E.raise("invalid input, expecting JSNumber but got " + v.startTime)
                                                                                                                                  ,course: v.course === null ? Maybe.Nothing : Maybe.Just(typeof v.course === "object" && "upwind" in v.course && "downwind" in v.course && "laps" in v.course && "markRadius" in v.course && "islands" in v.course && "bounds" in v.course ? {_: {}
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
                                                                                                                                                                                                                                                                                                                                                                              ,bounds: _U.isJSArray(v.course.bounds) ? {ctor: "_Tuple2"
                                                                                                                                                                                                                                                                                                                                                                                                                       ,_0: _U.isJSArray(v.course.bounds[0]) ? {ctor: "_Tuple2"
                                                                                                                                                                                                                                                                                                                                                                                                                                                               ,_0: typeof v.course.bounds[0][0] === "number" ? v.course.bounds[0][0] : _E.raise("invalid input, expecting JSNumber but got " + v.course.bounds[0][0])
                                                                                                                                                                                                                                                                                                                                                                                                                                                               ,_1: typeof v.course.bounds[0][1] === "number" ? v.course.bounds[0][1] : _E.raise("invalid input, expecting JSNumber but got " + v.course.bounds[0][1])} : _E.raise("invalid input, expecting JSArray but got " + v.course.bounds[0])
                                                                                                                                                                                                                                                                                                                                                                                                                       ,_1: _U.isJSArray(v.course.bounds[1]) ? {ctor: "_Tuple2"
                                                                                                                                                                                                                                                                                                                                                                                                                                                               ,_0: typeof v.course.bounds[1][0] === "number" ? v.course.bounds[1][0] : _E.raise("invalid input, expecting JSNumber but got " + v.course.bounds[1][0])
                                                                                                                                                                                                                                                                                                                                                                                                                                                               ,_1: typeof v.course.bounds[1][1] === "number" ? v.course.bounds[1][1] : _E.raise("invalid input, expecting JSNumber but got " + v.course.bounds[1][1])} : _E.raise("invalid input, expecting JSArray but got " + v.course.bounds[1])} : _E.raise("invalid input, expecting JSArray but got " + v.course.bounds)} : _E.raise("invalid input, expecting JSObject [\"upwind\",\"downwind\",\"laps\",\"markRadius\",\"islands\",\"bounds\"] but got " + v.course))
                                                                                                                                  ,opponents: _U.isJSArray(v.opponents) ? _L.fromArray(v.opponents.map(function (v) {
                                                                                                                                     return typeof v === "object" && "position" in v && "direction" in v && "velocity" in v && "passedGates" in v ? {_: {}
                                                                                                                                                                                                                                                    ,position: _U.isJSArray(v.position) ? {ctor: "_Tuple2"
                                                                                                                                                                                                                                                                                          ,_0: typeof v.position[0] === "number" ? v.position[0] : _E.raise("invalid input, expecting JSNumber but got " + v.position[0])
                                                                                                                                                                                                                                                                                          ,_1: typeof v.position[1] === "number" ? v.position[1] : _E.raise("invalid input, expecting JSNumber but got " + v.position[1])} : _E.raise("invalid input, expecting JSArray but got " + v.position)
                                                                                                                                                                                                                                                    ,direction: typeof v.direction === "number" ? v.direction : _E.raise("invalid input, expecting JSNumber but got " + v.direction)
                                                                                                                                                                                                                                                    ,velocity: typeof v.velocity === "number" ? v.velocity : _E.raise("invalid input, expecting JSNumber but got " + v.velocity)
                                                                                                                                                                                                                                                    ,passedGates: _U.isJSArray(v.passedGates) ? _L.fromArray(v.passedGates.map(function (v) {
                                                                                                                                                                                                                                                       return typeof v === "number" ? v : _E.raise("invalid input, expecting JSNumber but got " + v);
                                                                                                                                                                                                                                                    })) : _E.raise("invalid input, expecting JSArray but got " + v.passedGates)} : _E.raise("invalid input, expecting JSObject [\"position\",\"direction\",\"velocity\",\"passedGates\"] but got " + v);
                                                                                                                                  })) : _E.raise("invalid input, expecting JSArray but got " + v.opponents)
                                                                                                                                  ,leaderboard: _U.isJSArray(v.leaderboard) ? _L.fromArray(v.leaderboard.map(function (v) {
                                                                                                                                     return typeof v === "string" || typeof v === "object" && v instanceof String ? v : _E.raise("invalid input, expecting JSString but got " + v);
                                                                                                                                  })) : _E.raise("invalid input, expecting JSArray but got " + v.leaderboard)} : _E.raise("invalid input, expecting JSObject [\"now\",\"startTime\",\"course\",\"opponents\",\"leaderboard\"] but got " + v);
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
   var raceOutput = Native.Ports.portOut("raceOutput",
   Native.Ports.outgoingSignal(function (v) {
      return {position: [v.position._0
                        ,v.position._1]
             ,direction: v.direction
             ,velocity: v.velocity
             ,passedGates: _L.toArray(v.passedGates).map(function (v) {
                return v;
             })};
   }),
   A2(Signal.lift,
   function ($) {
      return playerToRaceOutput(function (_) {
         return _.player;
      }($));
   },
   gameState));
   var main = A3(Signal.lift2,
   Render.All.renderAll,
   Window.dimensions,
   gameState);
   _elm.ShiftMaster.values = {_op: _op
                             ,clock: clock
                             ,input: input
                             ,gameState: gameState
                             ,playerToRaceOutput: playerToRaceOutput
                             ,main: main};
   return _elm.ShiftMaster.values;
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
   var raceInputStep = F2(function (_v0,
   gameState) {
      return function () {
         return _U.replace([["opponents"
                            ,_v0.opponents]
                           ,["course"
                            ,A3(Maybe.maybe,
                            gameState.course,
                            Basics.id,
                            _v0.course)]
                           ,["leaderboard",_v0.leaderboard]
                           ,["countdown"
                            ,_v0.startTime - _v0.now]],
         gameState);
      }();
   });
   var updateWindForPlayer = F2(function (wind,
   player) {
      return function () {
         var gustsOnPlayer = List.reverse(List.sortBy(function (_) {
            return _.speedImpact;
         })(A2(List.filter,
         function (g) {
            return _U.cmp(A2(Geo.distance,
            player.position,
            g.position),
            g.radius) < 1;
         },
         wind.gusts)));
         var windOrigin = List.isEmpty(gustsOnPlayer) ? wind.origin : function () {
            var gust = List.head(gustsOnPlayer);
            var factor = List.minimum(_L.fromArray([(gust.radius - A2(Geo.distance,
                                                   player.position,
                                                   gust.position)) / (gust.radius * 0.1)
                                                   ,1]));
            var newDelta = gust.originDelta * factor;
            return Core.ensure360(wind.origin + newDelta);
         }();
         return _U.replace([["windOrigin"
                            ,windOrigin]],
         player);
      }();
   });
   var windStep = F3(function (delta,
   now,
   _v2) {
      return function () {
         return function () {
            var playerWithWind = A2(updateWindForPlayer,
            _v2.wind,
            _v2.player);
            var o2 = Basics.cos(Time.inSeconds(now) / 5) * 5;
            var o1 = Basics.cos(Time.inSeconds(now) / 8) * 10;
            var newOrigin = Core.ensure360(o1 + o2);
            var newWind = _U.replace([["origin"
                                      ,newOrigin]],
            _v2.wind);
            return _U.replace([["wind"
                               ,newWind]
                              ,["player",playerWithWind]],
            _v2);
         }();
      }();
   });
   var getCenterAfterMove = F4(function (_v4,
   _v5,
   _v6,
   _v7) {
      return function () {
         switch (_v7.ctor)
         {case "_Tuple2":
            return function () {
                 switch (_v6.ctor)
                 {case "_Tuple2":
                    return function () {
                         switch (_v5.ctor)
                         {case "_Tuple2":
                            return function () {
                                 switch (_v4.ctor)
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
                                                _v4._0,
                                                _v5._0,
                                                _v6._0,
                                                _v7._0,
                                                _v7._0 * 0.2)
                                                ,_1: A5(refocus,
                                                _v4._1,
                                                _v5._1,
                                                _v6._1,
                                                _v7._1,
                                                _v7._1 * 0.4)};
                                      }();}
                                 _E.Case($moduleName,
                                 "between lines 148 and 161");
                              }();}
                         _E.Case($moduleName,
                         "between lines 148 and 161");
                      }();}
                 _E.Case($moduleName,
                 "between lines 148 and 161");
              }();}
         _E.Case($moduleName,
         "between lines 148 and 161");
      }();
   });
   var getGatesMarks = function (course) {
      return _L.fromArray([{ctor: "_Tuple2"
                           ,_0: course.upwind.width / -2
                           ,_1: course.upwind.y}
                          ,{ctor: "_Tuple2"
                           ,_0: course.upwind.width / 2
                           ,_1: course.upwind.y}
                          ,{ctor: "_Tuple2"
                           ,_0: course.downwind.width / -2
                           ,_1: course.downwind.y}
                          ,{ctor: "_Tuple2"
                           ,_0: course.downwind.width / 2
                           ,_1: course.downwind.y}]);
   };
   var isStuck = F2(function (p,
   gameState) {
      return function () {
         var onIsland = A2(List.any,
         function (i) {
            return _U.cmp(A2(Geo.distance,
            i.location,
            p),
            i.radius) < 1;
         },
         gameState.course.islands);
         var outOfBounds = Basics.not(A2(Geo.inBox,
         p,
         gameState.course.bounds));
         var gatesMarks = getGatesMarks(gameState.course);
         var stuckOnMark = A2(List.any,
         function (m) {
            return _U.cmp(A2(Geo.distance,
            m,
            p),
            gameState.course.markRadius) < 1;
         },
         gatesMarks);
         return outOfBounds || (stuckOnMark || onIsland);
      }();
   });
   var gatePassedInX = F2(function (gate,
   _v20) {
      return function () {
         switch (_v20.ctor)
         {case "_Tuple2":
            switch (_v20._0.ctor)
              {case "_Tuple2":
                 switch (_v20._1.ctor)
                   {case "_Tuple2":
                      return function () {
                           var a = (_v20._0._1 - _v20._1._1) / (_v20._0._0 - _v20._1._0);
                           var b = _v20._0._1 - a * _v20._0._0;
                           var xGate = (gate.y - b) / a;
                           return _U.cmp(Basics.abs(xGate),
                           gate.width / 2) < 1;
                        }();}
                   break;}
              break;}
         _E.Case($moduleName,
         "between lines 97 and 101");
      }();
   });
   var gatePassedFromNorth = F2(function (gate,
   _v28) {
      return function () {
         switch (_v28.ctor)
         {case "_Tuple2":
            return _U.cmp(Basics.snd(_v28._0),
              gate.y) > 0 && (_U.cmp(Basics.snd(_v28._1),
              gate.y) < 1 && A2(gatePassedInX,
              gate,
              {ctor: "_Tuple2"
              ,_0: _v28._0
              ,_1: _v28._1}));}
         _E.Case($moduleName,
         "on line 105, column 4 to 70");
      }();
   });
   var gatePassedFromSouth = F2(function (gate,
   _v32) {
      return function () {
         switch (_v32.ctor)
         {case "_Tuple2":
            return _U.cmp(Basics.snd(_v32._0),
              gate.y) < 0 && (_U.cmp(Basics.snd(_v32._1),
              gate.y) > -1 && A2(gatePassedInX,
              gate,
              {ctor: "_Tuple2"
              ,_0: _v32._0
              ,_1: _v32._1}));}
         _E.Case($moduleName,
         "on line 109, column 4 to 70");
      }();
   });
   var getPassedGates = F4(function (player,
   timestamp,
   _v36,
   step) {
      return function () {
         return function () {
            var _v38 = A2(Game.findNextGate,
            player,
            Game.course.laps);
            switch (_v38.ctor)
            {case "Just":
               switch (_v38._0.ctor)
                 {case "Downwind":
                    return A2(gatePassedFromNorth,
                      _v36.downwind,
                      step) ? {ctor: "::"
                              ,_0: timestamp
                              ,_1: player.passedGates} : A2(gatePassedFromNorth,
                      _v36.upwind,
                      step) ? List.tail(player.passedGates) : player.passedGates;
                    case "StartLine":
                    return A2(gatePassedFromSouth,
                      _v36.downwind,
                      step) ? {ctor: "::"
                              ,_0: timestamp
                              ,_1: player.passedGates} : player.passedGates;
                    case "Upwind":
                    return A2(gatePassedFromSouth,
                      _v36.upwind,
                      step) ? {ctor: "::"
                              ,_0: timestamp
                              ,_1: player.passedGates} : A2(gatePassedFromSouth,
                      _v36.downwind,
                      step) ? List.tail(player.passedGates) : player.passedGates;}
                 break;
               case "Nothing":
               return player.passedGates;}
            _E.Case($moduleName,
            "between lines 113 and 126");
         }();
      }();
   });
   var movePlayer = F5(function (now,
   delta,
   gameState,
   dimensions,
   player) {
      return function () {
         var $ = player,
         position = $.position,
         direction = $.direction,
         velocity = $.velocity,
         windAngle = $.windAngle,
         passedGates = $.passedGates;
         var newVelocity = A2(Core.playerVelocity,
         player.windAngle,
         velocity);
         var nextPosition = A4(Geo.movePoint,
         position,
         delta,
         newVelocity,
         direction);
         var stuck = A2(isStuck,
         nextPosition,
         gameState);
         var newPosition = stuck ? position : nextPosition;
         var newPassedGates = _U.cmp(gameState.countdown,
         0) < 1 ? A4(getPassedGates,
         player,
         now,
         gameState.course,
         {ctor: "_Tuple2"
         ,_0: position
         ,_1: newPosition}) : player.passedGates;
         var newCenter = A4(getCenterAfterMove,
         position,
         newPosition,
         player.center,
         Geo.floatify(dimensions));
         return _U.replace([["position"
                            ,newPosition]
                           ,["velocity"
                            ,stuck ? 0 : newVelocity]
                           ,["center",newCenter]
                           ,["passedGates"
                            ,newPassedGates]],
         player);
      }();
   });
   var moveStep = F4(function (now,
   delta,
   dims,
   gameState) {
      return function () {
         var playerMoved = A5(movePlayer,
         now,
         delta,
         gameState,
         dims,
         gameState.player);
         return _U.replace([["player"
                            ,playerMoved]],
         gameState);
      }();
   });
   var getTurn = F4(function (tackTarget,
   player,
   arrows,
   fineTurn) {
      return function () {
         var _v40 = {ctor: "_Tuple4"
                    ,_0: tackTarget
                    ,_1: player.controlMode
                    ,_2: arrows.x
                    ,_3: arrows.y};
         switch (_v40.ctor)
         {case "_Tuple4":
            switch (_v40._0.ctor)
              {case "Just":
                 return function () {
                      var _v46 = player.controlMode;
                      switch (_v46.ctor)
                      {case "FixedDirection":
                         return function () {
                              var maxTurn = List.minimum(_L.fromArray([2
                                                                      ,Basics.abs(player.direction - _v40._0._0)]));
                              return _U.cmp(Core.ensure360(player.direction - _v40._0._0),
                              180) > 0 ? maxTurn : 0 - maxTurn;
                           }();
                         case "FixedWindAngle":
                         return function () {
                              var maxTurn = List.minimum(_L.fromArray([2
                                                                      ,Basics.abs(player.windAngle - _v40._0._0)]));
                              return _U.cmp(_v40._0._0,
                              90) > 0 || _U.cmp(_v40._0._0,
                              0) < 0 && _U.cmp(_v40._0._0,
                              -90) > -1 ? 0 - maxTurn : maxTurn;
                           }();}
                      _E.Case($moduleName,
                      "between lines 58 and 68");
                   }();
                 case "Nothing":
                 switch (_v40._1.ctor)
                   {case "FixedDirection":
                      switch (_v40._2)
                        {case 0: switch (_v40._3)
                             {case 0: return 0;}
                             break;}
                        break;
                      case "FixedWindAngle":
                      switch (_v40._2)
                        {case 0: switch (_v40._3)
                             {case 0:
                                return player.windOrigin + player.windAngle - player.direction;}
                             break;}
                        break;}
                   return fineTurn ? _v40._2 : _v40._2 * 3;}
              break;}
         _E.Case($moduleName,
         "between lines 55 and 71");
      }();
   });
   var tackTargetReached = F2(function (player,
   targetMaybe) {
      return function () {
         var _v47 = {ctor: "_Tuple2"
                    ,_0: targetMaybe
                    ,_1: player.controlMode};
         switch (_v47.ctor)
         {case "_Tuple2":
            switch (_v47._0.ctor)
              {case "Just":
                 switch (_v47._1.ctor)
                   {case "FixedDirection":
                      return _U.cmp(Basics.abs(_v47._0._0 - player.direction),
                        0.1) < 0;
                      case "FixedWindAngle":
                      return _U.cmp(Basics.abs(_v47._0._0 - player.windAngle),
                        0.1) < 0;}
                   break;
                 case "Nothing": return false;}
              break;}
         _E.Case($moduleName,
         "between lines 31 and 34");
      }();
   });
   var getTackTarget = F2(function (player,
   spaceKey) {
      return function () {
         var _v51 = {ctor: "_Tuple2"
                    ,_0: player.tackTarget
                    ,_1: spaceKey};
         switch (_v51.ctor)
         {case "_Tuple2":
            switch (_v51._0.ctor)
              {case "Just":
                 return A2(tackTargetReached,
                   player,
                   player.tackTarget) ? Maybe.Nothing : player.tackTarget;
                 case "Nothing": switch (_v51._1)
                   {case false:
                      return Maybe.Nothing;
                      case true: return function () {
                           var _v55 = player.controlMode;
                           switch (_v55.ctor)
                           {case "FixedDirection":
                              return Maybe.Just(Core.ensure360(player.windOrigin - player.windAngle));
                              case "FixedWindAngle":
                              return Maybe.Just(0 - player.windAngle);}
                           _E.Case($moduleName,
                           "between lines 45 and 49");
                        }();}
                   break;}
              break;}
         _E.Case($moduleName,
         "between lines 38 and 49");
      }();
   });
   var keysForPlayerStep = F2(function (_v56,
   player) {
      return function () {
         return function () {
            var forceTurn = !_U.eq(_v56.arrows.x,
            0);
            var tackTarget = forceTurn ? Maybe.Nothing : A2(getTackTarget,
            player,
            _v56.tack);
            var turn = A4(getTurn,
            tackTarget,
            player,
            _v56.arrows,
            _v56.fineTurn);
            var direction = Core.ensure360(player.direction + turn);
            var windAngle = A2(Core.angleToWind,
            direction,
            player.windOrigin);
            var turnedPlayer = _U.replace([["direction"
                                           ,direction]
                                          ,["windAngle",windAngle]],
            player);
            var tackTargetAfterTurn = A2(tackTargetReached,
            turnedPlayer,
            tackTarget) ? Maybe.Nothing : tackTarget;
            var controlMode = forceTurn ? Game.FixedDirection : _U.cmp(_v56.arrows.y,
            0) > 0 || _v56.lockAngle ? Game.FixedWindAngle : turnedPlayer.controlMode;
            return _U.replace([["controlMode"
                               ,controlMode]
                              ,["tackTarget"
                               ,tackTargetAfterTurn]],
            turnedPlayer);
         }();
      }();
   });
   var keysStep = F2(function (keyboardInput,
   gameState) {
      return function () {
         var playerUpdated = A2(keysForPlayerStep,
         keyboardInput,
         gameState.player);
         return _U.replace([["player"
                            ,playerUpdated]],
         gameState);
      }();
   });
   var mouseStep = F2(function (_v58,
   gameState) {
      return function () {
         return function () {
            var player = gameState.player;
            var center = function () {
               var _v60 = _v58.drag;
               switch (_v60.ctor)
               {case "Just":
                  switch (_v60._0.ctor)
                    {case "_Tuple2":
                       return function () {
                            var $ = _v58.mouse,
                            x = $._0,
                            y = $._1;
                            return A2(Geo.sub,
                            Geo.floatify({ctor: "_Tuple2"
                                         ,_0: x - _v60._0._0
                                         ,_1: _v60._0._1 - y}),
                            player.center);
                         }();}
                    break;
                  case "Nothing":
                  return player.center;}
               _E.Case($moduleName,
               "between lines 23 and 26");
            }();
            return _U.replace([["player"
                               ,_U.replace([["center",center]],
                               player)]],
            gameState);
         }();
      }();
   });
   var stepGame = F2(function (input,
   gameState) {
      return mouseStep(input.mouseInput)(A3(moveStep,
      input.raceInput.now,
      input.delta,
      input.windowInput)(keysStep(input.keyboardInput)(A2(windStep,
      input.delta,
      input.raceInput.now)(A2(raceInputStep,
      input.raceInput,
      gameState)))));
   });
   _elm.Steps.values = {_op: _op
                       ,mouseStep: mouseStep
                       ,tackTargetReached: tackTargetReached
                       ,getTackTarget: getTackTarget
                       ,getTurn: getTurn
                       ,keysForPlayerStep: keysForPlayerStep
                       ,keysStep: keysStep
                       ,gatePassedInX: gatePassedInX
                       ,gatePassedFromNorth: gatePassedFromNorth
                       ,gatePassedFromSouth: gatePassedFromSouth
                       ,getPassedGates: getPassedGates
                       ,getGatesMarks: getGatesMarks
                       ,isStuck: isStuck
                       ,getCenterAfterMove: getCenterAfterMove
                       ,movePlayer: movePlayer
                       ,moveStep: moveStep
                       ,updateWindForPlayer: updateWindForPlayer
                       ,windStep: windStep
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
   Render.Absolute = Elm.Render.Absolute.make(_elm);
   var Render = Render || {};
   Render.Relative = Elm.Render.Relative.make(_elm);
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
                 var relativeForms = Render.Relative.renderRelative(gameState);
                 var dims = Geo.floatify({ctor: "_Tuple2"
                                         ,_0: _v0._0
                                         ,_1: _v0._1});
                 var $ = dims,
                 w$ = $._0,
                 h$ = $._1;
                 var bg = Graphics.Collage.filled(Render.Utils.colors.sand)(A2(Graphics.Collage.rect,
                 w$,
                 h$));
                 var absoluteForms = A2(Render.Absolute.renderAbsolute,
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
Elm.Render.Relative = Elm.Render.Relative || {};
Elm.Render.Relative.make = function (_elm) {
   "use strict";
   _elm.Render = _elm.Render || {};
   _elm.Render.Relative = _elm.Render.Relative || {};
   if (_elm.Render.Relative.values)
   return _elm.Render.Relative.values;
   var _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _A = _N.Array.make(_elm),
   _E = _N.Error.make(_elm),
   $moduleName = "Render.Relative";
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
   var renderCountdown = F2(function (gameState,
   player) {
      return function () {
         var messageBuilder = function (msg) {
            return Graphics.Collage.move({ctor: "_Tuple2"
                                         ,_0: 0
                                         ,_1: gameState.course.downwind.y + 50})(Graphics.Collage.toForm(Text.centered(Render.Utils.baseText(msg))));
         };
         return _U.cmp(gameState.countdown,
         0) > 0 ? function () {
            var cs = Basics.ceiling(Time.inSeconds(gameState.countdown));
            var m = cs / 60 | 0;
            var s = A2(Basics.rem,cs,60);
            var msg = _L.append("Start in ",
            _L.append(String.show(m),
            _L.append("\'",
            _L.append(String.show(s),
            "\"..."))));
            return Maybe.Just(messageBuilder(msg));
         }() : List.isEmpty(player.passedGates) ? Maybe.Just(messageBuilder("Go!")) : Maybe.Nothing;
      }();
   });
   var renderLaylines = F2(function (player,
   course) {
      return function () {
         var windAngleR = Core.toRadians(player.windOrigin);
         var upwindMark = course.upwind;
         var $ = Game.getGateMarks(upwindMark),
         left = $._0,
         right = $._1;
         var upwindVmgAngleR = Core.toRadians(Core.upwindVmg);
         var leftLL = A2(Geo.add,
         left,
         Basics.fromPolar({ctor: "_Tuple2"
                          ,_0: 500
                          ,_1: windAngleR + upwindVmgAngleR - Basics.pi}));
         var l1 = Graphics.Collage.traced(Graphics.Collage.solid(Color.white))(A2(Graphics.Collage.segment,
         left,
         leftLL));
         return Graphics.Collage.alpha(0.3)(Graphics.Collage.group(_L.fromArray([l1])));
      }();
   });
   var renderIsland = function (_v0) {
      return function () {
         return function () {
            var ground = Graphics.Collage.filled(Render.Utils.colors.sand)(Graphics.Collage.circle(_v0.radius));
            return Graphics.Collage.move(_v0.location)(Graphics.Collage.group(_L.fromArray([ground])));
         }();
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
         var c = Graphics.Collage.alpha(5.0e-2 + gust.speedImpact / 2)(Graphics.Collage.filled(Color.black)(Graphics.Collage.circle(gust.radius)));
         return Graphics.Collage.move(gust.position)(Graphics.Collage.group(_L.fromArray([c])));
      }();
   });
   var renderGusts = function (wind) {
      return Graphics.Collage.group(A2(List.map,
      renderGust(wind),
      wind.gusts));
   };
   var renderBounds = function (box) {
      return function () {
         var $ = box,
         ne = $._0,
         sw = $._1;
         var w = Basics.fst(ne) - Basics.fst(sw);
         var h = Basics.snd(ne) - Basics.snd(sw);
         var cw = (Basics.fst(ne) + Basics.fst(sw)) / 2;
         var ch = (Basics.snd(ne) + Basics.snd(sw)) / 2;
         return Graphics.Collage.move({ctor: "_Tuple2"
                                      ,_0: cw
                                      ,_1: ch})(Graphics.Collage.filled(Render.Utils.colors.seaBlue)(A2(Graphics.Collage.rect,
         w,
         h)));
      }();
   };
   var renderOpponent = function (opponent) {
      return Graphics.Collage.move(opponent.position)(Graphics.Collage.rotate(Core.toRadians(opponent.direction + 90))(Graphics.Collage.alpha(0.3)(Graphics.Collage.toForm(A3(Graphics.Element.image,
      8,
      19,
      "/assets/images/icon-boat-white.png")))));
   };
   var renderEqualityLine = F2(function (_v2,
   windOrigin) {
      return function () {
         switch (_v2.ctor)
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
         "between lines 55 and 57");
      }();
   });
   var renderPlayerAngles = function (player) {
      return function () {
         var windAngleText = Graphics.Collage.alpha(0.8)(Graphics.Collage.move(Basics.fromPolar({ctor: "_Tuple2"
                                                                                                ,_0: 40
                                                                                                ,_1: Core.toRadians(player.direction - player.windAngle / 2)}))(Graphics.Collage.toForm(Text.centered((_U.eq(player.controlMode,
         Game.FixedWindAngle) ? Text.line(Text.Under) : Basics.id)(Render.Utils.baseText(_L.append(String.show(Basics.abs(player.windAngle)),
         "&deg;")))))));
         var drawLine = function (a) {
            return Graphics.Collage.traced(Graphics.Collage.solid(Color.white))(A2(Graphics.Collage.segment,
            Basics.fromPolar({ctor: "_Tuple2"
                             ,_0: 15
                             ,_1: a}),
            Basics.fromPolar({ctor: "_Tuple2"
                             ,_0: 25
                             ,_1: a})));
         };
         var directionLine = Graphics.Collage.alpha(0.8)(drawLine(Core.toRadians(player.direction)));
         var windLine = Graphics.Collage.alpha(0.3)(drawLine(Core.toRadians(player.direction - player.windAngle)));
         return Graphics.Collage.group(_L.fromArray([directionLine
                                                    ,windLine
                                                    ,windAngleText]));
      }();
   };
   var renderPlayer = function (player) {
      return function () {
         var eqLine = A2(renderEqualityLine,
         player.position,
         player.windOrigin);
         var angles = renderPlayerAngles(player);
         var hull = Graphics.Collage.rotate(Core.toRadians(player.direction + 90))(Graphics.Collage.toForm(A3(Graphics.Element.image,
         8,
         19,
         "/assets/images/icon-boat-white.png")));
         return Graphics.Collage.move(player.position)(Graphics.Collage.group(_L.fromArray([angles
                                                                                           ,eqLine
                                                                                           ,hull])));
      }();
   };
   var renderGate = F3(function (gate,
   markRadius,
   isNext) {
      return function () {
         var $ = isNext ? {ctor: "_Tuple2"
                          ,_0: Graphics.Collage.filled(Color.orange)
                          ,_1: Graphics.Collage.traced(Graphics.Collage.dotted(Color.orange))} : {ctor: "_Tuple2"
                                                                                                 ,_0: Graphics.Collage.filled(Color.white)
                                                                                                 ,_1: Graphics.Collage.traced(Graphics.Collage.solid(Render.Utils.colors.seaBlue))},
         markStyle = $._0,
         lineStyle = $._1;
         var $ = Game.getGateMarks(gate),
         left = $._0,
         right = $._1;
         var line = lineStyle(A2(Graphics.Collage.segment,
         left,
         right));
         var leftMark = Graphics.Collage.move(left)(markStyle(Graphics.Collage.circle(markRadius)));
         var rightMark = Graphics.Collage.move(right)(markStyle(Graphics.Collage.circle(markRadius)));
         return Graphics.Collage.group(_L.fromArray([line
                                                    ,leftMark
                                                    ,rightMark]));
      }();
   });
   var renderStartLine = F3(function (gate,
   markRadius,
   started) {
      return function () {
         var $ = Game.getGateMarks(gate),
         left = $._0,
         right = $._1;
         var markColor = started ? Color.green : Color.red;
         var marks = A2(List.map,
         function (g) {
            return Graphics.Collage.move(g)(Graphics.Collage.filled(markColor)(Graphics.Collage.circle(markRadius)));
         },
         _L.fromArray([left,right]));
         var lineStyle = started ? Graphics.Collage.dotted(Color.white) : Graphics.Collage.solid(Color.white);
         var line = Graphics.Collage.traced(lineStyle)(A2(Graphics.Collage.segment,
         left,
         right));
         return Graphics.Collage.group({ctor: "::"
                                       ,_0: line
                                       ,_1: marks});
      }();
   });
   var renderRelative = function (_v6) {
      return function () {
         return function () {
            var maybeForms = _L.fromArray([A2(renderCountdown,
            _v6,
            _v6.player)]);
            var nextGate = A2(Game.findNextGate,
            _v6.player,
            _v6.course.laps);
            var downwindOrStartLine = List.isEmpty(_v6.player.passedGates) ? A3(renderStartLine,
            _v6.course.downwind,
            _v6.course.markRadius,
            _U.cmp(_v6.countdown,
            0) < 1) : A3(renderGate,
            _v6.course.downwind,
            _v6.course.markRadius,
            _U.eq(nextGate,
            Maybe.Just(Game.Downwind)));
            var justForms = _L.fromArray([renderBounds(_v6.course.bounds)
                                         ,renderIslands(_v6)
                                         ,downwindOrStartLine
                                         ,A3(renderGate,
                                         _v6.course.upwind,
                                         _v6.course.markRadius,
                                         _U.eq(nextGate,
                                         Maybe.Just(Game.Upwind)))
                                         ,renderPlayer(_v6.player)
                                         ,Graphics.Collage.group(A2(List.map,
                                         renderOpponent,
                                         _v6.opponents))
                                         ,renderGusts(_v6.wind)]);
            return Graphics.Collage.move(Geo.neg(_v6.player.center))(Graphics.Collage.group(_L.append(justForms,
            Core.compact(maybeForms))));
         }();
      }();
   };
   _elm.Render.Relative.values = {_op: _op
                                 ,renderStartLine: renderStartLine
                                 ,renderGate: renderGate
                                 ,renderPlayerAngles: renderPlayerAngles
                                 ,renderEqualityLine: renderEqualityLine
                                 ,renderPlayer: renderPlayer
                                 ,renderOpponent: renderOpponent
                                 ,renderBounds: renderBounds
                                 ,renderGust: renderGust
                                 ,renderGusts: renderGusts
                                 ,renderIsland: renderIsland
                                 ,renderIslands: renderIslands
                                 ,renderLaylines: renderLaylines
                                 ,renderCountdown: renderCountdown
                                 ,renderRelative: renderRelative};
   return _elm.Render.Relative.values;
};Elm.Render = Elm.Render || {};
Elm.Render.Absolute = Elm.Render.Absolute || {};
Elm.Render.Absolute.make = function (_elm) {
   "use strict";
   _elm.Render = _elm.Render || {};
   _elm.Render.Absolute = _elm.Render.Absolute || {};
   if (_elm.Render.Absolute.values)
   return _elm.Render.Absolute.values;
   var _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _A = _N.Array.make(_elm),
   _E = _N.Error.make(_elm),
   $moduleName = "Render.Absolute";
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
   var renderHelp = F2(function (countdown,
   _v0) {
      return function () {
         switch (_v0.ctor)
         {case "_Tuple2":
            return _U.cmp(countdown,
              0) > 0 ? function () {
                 var text = Graphics.Collage.alpha(0.8)(Graphics.Collage.move({ctor: "_Tuple2"
                                                                              ,_0: 0
                                                                              ,_1: (0 - _v0._1) / 2 + 50})(Graphics.Collage.toForm(Text.centered(Render.Utils.baseText(Render.Utils.helpMessage)))));
                 return Maybe.Just(text);
              }() : Maybe.Nothing;}
         _E.Case($moduleName,
         "between lines 121 and 125");
      }();
   });
   var renderControlWheel = F3(function (wind,
   player,
   _v4) {
      return function () {
         switch (_v4.ctor)
         {case "_Tuple2":
            return function () {
                 var playerAngle = Core.toRadians(player.direction);
                 var windAngle = Core.toRadians(player.windOrigin);
                 var r = 35;
                 var c = Graphics.Collage.outlined(Graphics.Collage.solid(Color.white))(Graphics.Collage.circle(r));
                 var playerWindMarker = Graphics.Collage.traced(Graphics.Collage.solid(Color.white))(A2(Graphics.Collage.segment,
                 Basics.fromPolar({ctor: "_Tuple2"
                                  ,_0: r
                                  ,_1: windAngle}),
                 Basics.fromPolar({ctor: "_Tuple2"
                                  ,_0: r + 8
                                  ,_1: windAngle})));
                 var playerMarker = Graphics.Collage.move(Basics.fromPolar({ctor: "_Tuple2"
                                                                           ,_0: r - 4
                                                                           ,_1: playerAngle}))(Graphics.Collage.rotate(playerAngle - Basics.pi / 2)(Graphics.Collage.filled(Color.white)(Graphics.Collage.polygon(_L.fromArray([{ctor: "_Tuple2"
                                                                                                                                                                                                                                ,_0: 0
                                                                                                                                                                                                                                ,_1: 4}
                                                                                                                                                                                                                               ,{ctor: "_Tuple2"
                                                                                                                                                                                                                                ,_0: -4
                                                                                                                                                                                                                                ,_1: -4}
                                                                                                                                                                                                                               ,{ctor: "_Tuple2"
                                                                                                                                                                                                                                ,_0: 4
                                                                                                                                                                                                                                ,_1: -4}])))));
                 var windOriginText = Graphics.Collage.move(Basics.fromPolar({ctor: "_Tuple2"
                                                                             ,_0: r + 20
                                                                             ,_1: windAngle}))(Graphics.Collage.rotate(windAngle - Basics.pi / 2)(Graphics.Collage.toForm(Text.centered(Render.Utils.baseText(_L.append(String.show(player.windOrigin),
                 "&deg;"))))));
                 return Graphics.Collage.alpha(0.8)(Graphics.Collage.move({ctor: "_Tuple2"
                                                                          ,_0: _v4._0 / 2 - 50
                                                                          ,_1: _v4._1 / 2 - 120})(Graphics.Collage.group(_L.fromArray([c
                                                                                                                                      ,playerWindMarker
                                                                                                                                      ,playerMarker
                                                                                                                                      ,windOriginText]))));
              }();}
         _E.Case($moduleName,
         "between lines 84 and 100");
      }();
   });
   var renderPolar = F2(function (player,
   _v8) {
      return function () {
         switch (_v8.ctor)
         {case "_Tuple2":
            return function () {
                 var anglePoint = function (a) {
                    return Basics.fromPolar({ctor: "_Tuple2"
                                            ,_0: Core.polarVelocity(a) * 2
                                            ,_1: Core.toRadians(a)});
                 };
                 var points = A2(List.map,
                 anglePoint,
                 _L.range(0,180));
                 var maxSpeed = List.maximum(A2(List.map,
                 Basics.fst,
                 points)) + 10;
                 var yAxis = Graphics.Collage.alpha(0.6)(Graphics.Collage.traced(Graphics.Collage.solid(Color.white))(A2(Graphics.Collage.segment,
                 {ctor: "_Tuple2"
                 ,_0: 0
                 ,_1: maxSpeed},
                 {ctor: "_Tuple2"
                 ,_0: 0
                 ,_1: 0 - maxSpeed})));
                 var xAxis = Graphics.Collage.alpha(0.6)(Graphics.Collage.traced(Graphics.Collage.solid(Color.white))(A2(Graphics.Collage.segment,
                 {ctor: "_Tuple2",_0: 0,_1: 0},
                 {ctor: "_Tuple2"
                 ,_0: maxSpeed
                 ,_1: 0})));
                 var legend = Graphics.Collage.move({ctor: "_Tuple2"
                                                    ,_0: maxSpeed / 2
                                                    ,_1: maxSpeed * 0.8})(Graphics.Collage.toForm(Text.centered(Render.Utils.baseText("VMG"))));
                 var polar = Graphics.Collage.traced(Graphics.Collage.solid(Color.white))(Graphics.Collage.path(points));
                 var absWindAngle = Basics.abs(player.windAngle);
                 var playerPoint = anglePoint(absWindAngle);
                 var playerMark = Graphics.Collage.move(playerPoint)(Graphics.Collage.filled(Color.red)(Graphics.Collage.circle(2)));
                 var playerSegment = Graphics.Collage.alpha(0.3)(Graphics.Collage.traced(Graphics.Collage.solid(Color.white))(A2(Graphics.Collage.segment,
                 {ctor: "_Tuple2",_0: 0,_1: 0},
                 playerPoint)));
                 var playerProjection = Graphics.Collage.traced(Graphics.Collage.dotted(Color.white))(A2(Graphics.Collage.segment,
                 playerPoint,
                 {ctor: "_Tuple2"
                 ,_0: 0
                 ,_1: Basics.snd(playerPoint)}));
                 var windOriginText = Graphics.Collage.alpha(0.6)(Graphics.Collage.move(A2(Geo.add,
                 playerPoint,
                 Basics.fromPolar({ctor: "_Tuple2"
                                  ,_0: 20
                                  ,_1: Core.toRadians(absWindAngle)})))(Graphics.Collage.toForm(Text.centered(Render.Utils.baseText(_L.append(String.show(absWindAngle),
                 "&deg;"))))));
                 return Graphics.Collage.move({ctor: "_Tuple2"
                                              ,_0: (0 - _v8._0) / 2 + 20
                                              ,_1: _v8._1 / 2 - maxSpeed - 20})(Graphics.Collage.group(_L.fromArray([yAxis
                                                                                                                    ,xAxis
                                                                                                                    ,polar
                                                                                                                    ,playerProjection
                                                                                                                    ,playerMark
                                                                                                                    ,playerSegment
                                                                                                                    ,windOriginText
                                                                                                                    ,legend])));
              }();}
         _E.Case($moduleName,
         "between lines 62 and 80");
      }();
   });
   var renderLapsCount = F3(function (_v12,
   course,
   player) {
      return function () {
         switch (_v12.ctor)
         {case "_Tuple2":
            return function () {
                 var count = List.minimum(_L.fromArray([A2(Basics.div,
                                                       List.length(player.passedGates) + 1,
                                                       2)
                                                       ,course.laps]));
                 var msg = _L.append("LAP ",
                 _L.append(String.show(count),
                 _L.append("/",
                 String.show(course.laps))));
                 return Graphics.Collage.move({ctor: "_Tuple2"
                                              ,_0: _v12._0 / 2 - 50
                                              ,_1: _v12._1 / 2 - 30})(Graphics.Collage.toForm(Text.rightAligned(Render.Utils.baseText(msg))));
              }();}
         _E.Case($moduleName,
         "between lines 52 and 58");
      }();
   });
   var renderWinner = F3(function (course,
   player,
   opponents) {
      return Maybe.Nothing;
   });
   var hasFinished = F2(function (course,
   player) {
      return _U.eq(List.length(player.passedGates),
      course.laps * 2 + 1);
   });
   var renderHiddenGate = F4(function (gate,
   _v16,
   _v17,
   isNext) {
      return function () {
         switch (_v17.ctor)
         {case "_Tuple2":
            return function () {
                 switch (_v16.ctor)
                 {case "_Tuple2":
                    return function () {
                         var distance = function (isOver) {
                            return Graphics.Collage.toForm(Text.centered(Render.Utils.baseText(String.show(Basics.round(Basics.abs(gate.y + (isOver ? 0 - _v16._1 : _v16._1) / 2 - _v17._1))))));
                         };
                         var markStyle = isNext ? Graphics.Collage.filled(Color.orange) : Graphics.Collage.filled(Color.white);
                         var c = 5;
                         var over = _U.cmp(_v17._1 + _v16._1 / 2 + c,
                         gate.y) < 0;
                         var under = _U.cmp(_v17._1 - _v16._1 / 2 - c,
                         gate.y) > 0;
                         var $ = Game.getGateMarks(gate),
                         left = $._0,
                         right = $._1;
                         return function () {
                            var _v24 = {ctor: "_Tuple2"
                                       ,_0: over
                                       ,_1: under};
                            switch (_v24.ctor)
                            {case "_Tuple2":
                               switch (_v24._0)
                                 {case true: return function () {
                                         var d = Graphics.Collage.move({ctor: "_Tuple2"
                                                                       ,_0: 0 - _v17._0
                                                                       ,_1: _v16._1 / 2 - c * 3})(distance(true));
                                         var m = Graphics.Collage.move({ctor: "_Tuple2"
                                                                       ,_0: 0 - _v17._0
                                                                       ,_1: _v16._1 / 2})(markStyle(Graphics.Collage.polygon(_L.fromArray([{ctor: "_Tuple2"
                                                                                                                                           ,_0: 0
                                                                                                                                           ,_1: 0}
                                                                                                                                          ,{ctor: "_Tuple2"
                                                                                                                                           ,_0: 0 - c
                                                                                                                                           ,_1: 0 - c}
                                                                                                                                          ,{ctor: "_Tuple2"
                                                                                                                                           ,_0: c
                                                                                                                                           ,_1: 0 - c}]))));
                                         return Maybe.Just(Graphics.Collage.group(_L.fromArray([m
                                                                                               ,d])));
                                      }();}
                                 switch (_v24._1)
                                 {case true: return function () {
                                         var d = Graphics.Collage.move({ctor: "_Tuple2"
                                                                       ,_0: 0 - _v17._0
                                                                       ,_1: (0 - _v16._1) / 2 + c * 3})(distance(false));
                                         var m = Graphics.Collage.move({ctor: "_Tuple2"
                                                                       ,_0: 0 - _v17._0
                                                                       ,_1: (0 - _v16._1) / 2})(markStyle(Graphics.Collage.polygon(_L.fromArray([{ctor: "_Tuple2"
                                                                                                                                                 ,_0: 0
                                                                                                                                                 ,_1: 0}
                                                                                                                                                ,{ctor: "_Tuple2"
                                                                                                                                                 ,_0: 0 - c
                                                                                                                                                 ,_1: c}
                                                                                                                                                ,{ctor: "_Tuple2"
                                                                                                                                                 ,_0: c
                                                                                                                                                 ,_1: c}]))));
                                         return Maybe.Just(Graphics.Collage.group(_L.fromArray([m
                                                                                               ,d])));
                                      }();}
                                 return Maybe.Nothing;}
                            _E.Case($moduleName,
                            "between lines 19 and 26");
                         }();
                      }();}
                 _E.Case($moduleName,
                 "between lines 12 and 26");
              }();}
         _E.Case($moduleName,
         "between lines 12 and 26");
      }();
   });
   var renderAbsolute = F2(function (_v27,
   dims) {
      return function () {
         return function () {
            var justForms = _L.fromArray([A3(renderLapsCount,
                                         dims,
                                         _v27.course,
                                         _v27.player)
                                         ,A2(renderPolar,
                                         _v27.player,
                                         dims)
                                         ,A3(renderControlWheel,
                                         Game.wind,
                                         _v27.player,
                                         dims)]);
            var nextGate = _U.cmp(_v27.countdown,
            0) < 1 ? A2(Game.findNextGate,
            _v27.player,
            _v27.course.laps) : Maybe.Nothing;
            var maybeForms = _L.fromArray([A4(renderHiddenGate,
                                          _v27.course.downwind,
                                          dims,
                                          _v27.player.center,
                                          _U.eq(nextGate,
                                          Maybe.Just(Game.Downwind)))
                                          ,A4(renderHiddenGate,
                                          _v27.course.upwind,
                                          dims,
                                          _v27.player.center,
                                          _U.eq(nextGate,
                                          Maybe.Just(Game.Upwind)))
                                          ,A3(renderWinner,
                                          _v27.course,
                                          _v27.player,
                                          _v27.opponents)
                                          ,A2(renderHelp,
                                          _v27.countdown,
                                          dims)]);
            return Graphics.Collage.group(_L.append(justForms,
            Core.compact(maybeForms)));
         }();
      }();
   });
   _elm.Render.Absolute.values = {_op: _op
                                 ,renderHiddenGate: renderHiddenGate
                                 ,hasFinished: hasFinished
                                 ,renderWinner: renderWinner
                                 ,renderLapsCount: renderLapsCount
                                 ,renderPolar: renderPolar
                                 ,renderControlWheel: renderControlWheel
                                 ,renderHelp: renderHelp
                                 ,renderAbsolute: renderAbsolute};
   return _elm.Render.Absolute.values;
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
   var RaceInput = F5(function (a,
   b,
   c,
   d,
   e) {
      return {_: {}
             ,course: c
             ,leaderboard: e
             ,now: a
             ,opponents: d
             ,startTime: b};
   });
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
   var KeyboardInput = F4(function (a,
   b,
   c,
   d) {
      return {_: {}
             ,arrows: a
             ,fineTurn: d
             ,lockAngle: b
             ,tack: c};
   });
   var keyboardInput = A5(Signal.lift4,
   KeyboardInput,
   Keyboard.arrows,
   Keyboard.enter,
   Keyboard.space,
   Keyboard.shift);
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
   var wind = {_: {}
              ,gusts: _L.fromArray([])
              ,gustsCount: 0
              ,origin: 0
              ,speed: 10};
   var islands = _L.fromArray([{_: {}
                               ,location: {ctor: "_Tuple2"
                                          ,_0: 250
                                          ,_1: 300}
                               ,radius: 100}
                              ,{_: {}
                               ,location: {ctor: "_Tuple2"
                                          ,_0: 50
                                          ,_1: 700}
                               ,radius: 80}
                              ,{_: {}
                               ,location: {ctor: "_Tuple2"
                                          ,_0: -200
                                          ,_1: 500}
                               ,radius: 60}]);
   var upwindGate = {_: {}
                    ,width: 100
                    ,y: 1000};
   var startLine = {_: {}
                   ,width: 100
                   ,y: -100};
   var course = {_: {}
                ,bounds: {ctor: "_Tuple2"
                         ,_0: {ctor: "_Tuple2"
                              ,_0: 800
                              ,_1: 1200}
                         ,_1: {ctor: "_Tuple2"
                              ,_0: -800
                              ,_1: -400}}
                ,downwind: startLine
                ,islands: islands
                ,laps: 3
                ,markRadius: 5
                ,upwind: upwindGate};
   var RaceState = function (a) {
      return {_: {},players: a};
   };
   var GameState = F7(function (a,
   b,
   c,
   d,
   e,
   f,
   g) {
      return {_: {}
             ,countdown: g
             ,course: d
             ,leaderboard: e
             ,opponents: c
             ,player: b
             ,startDuration: f
             ,wind: a};
   });
   var Wind = F4(function (a,
   b,
   c,
   d) {
      return {_: {}
             ,gusts: d
             ,gustsCount: c
             ,origin: a
             ,speed: b};
   });
   var Gust = F4(function (a,
   b,
   c,
   d) {
      return {_: {}
             ,originDelta: d
             ,position: a
             ,radius: b
             ,speedImpact: c};
   });
   var Sailing = F5(function (a,
   b,
   c,
   d,
   e) {
      return _U.insert("passedGates",
      d,
      _U.insert("velocity",
      c,
      _U.insert("direction",
      b,
      _U.insert("position",a,e))));
   });
   var FixedWindAngle = {ctor: "FixedWindAngle"};
   var FixedDirection = {ctor: "FixedDirection"};
   var player = {_: {}
                ,center: {ctor: "_Tuple2"
                         ,_0: 0
                         ,_1: 0}
                ,controlMode: FixedDirection
                ,direction: 0
                ,passedGates: _L.fromArray([])
                ,position: {ctor: "_Tuple2"
                           ,_0: 0
                           ,_1: -200}
                ,tackTarget: Maybe.Nothing
                ,velocity: 0
                ,windAngle: 0
                ,windOrigin: 0
                ,windSpeed: 0};
   var defaultGame = {_: {}
                     ,countdown: 0
                     ,course: course
                     ,leaderboard: _L.fromArray([])
                     ,opponents: _L.fromArray([])
                     ,player: player
                     ,startDuration: 30 * Time.second
                     ,wind: wind};
   var Course = F6(function (a,
   b,
   c,
   d,
   e,
   f) {
      return {_: {}
             ,bounds: f
             ,downwind: b
             ,islands: e
             ,laps: c
             ,markRadius: d
             ,upwind: a};
   });
   var Island = F2(function (a,b) {
      return {_: {}
             ,location: a
             ,radius: b};
   });
   var Gate = F2(function (a,b) {
      return {_: {},width: b,y: a};
   });
   var Upwind = {ctor: "Upwind"};
   var Downwind = {ctor: "Downwind"};
   var StartLine = {ctor: "StartLine"};
   var findNextGate = F2(function (player,
   laps) {
      return function () {
         var c = List.length(player.passedGates);
         var i = A2(Basics.mod,c,2);
         return _U.eq(c,
         laps * 2 + 1) ? Maybe.Nothing : _U.eq(c,
         0) ? Maybe.Just(StartLine) : _U.eq(i,
         0) ? Maybe.Just(Downwind) : Maybe.Just(Upwind);
      }();
   });
   _elm.Game.values = {_op: _op
                      ,startLine: startLine
                      ,upwindGate: upwindGate
                      ,islands: islands
                      ,course: course
                      ,player: player
                      ,wind: wind
                      ,defaultGame: defaultGame
                      ,getGateMarks: getGateMarks
                      ,findNextGate: findNextGate
                      ,StartLine: StartLine
                      ,Downwind: Downwind
                      ,Upwind: Upwind
                      ,FixedDirection: FixedDirection
                      ,FixedWindAngle: FixedWindAngle
                      ,Gate: Gate
                      ,Island: Island
                      ,Course: Course
                      ,Sailing: Sailing
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
                 var x$ = _v0._0 + delta * velocity * Basics.cos(angle);
                 var y$ = _v0._1 + delta * velocity * Basics.sin(angle);
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
   var scale = F2(function (_v28,
   s) {
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
               "between lines 64 and 67");
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
         "between lines 57 and 59");
      }();
   });
   var polarVelocity = function (delta) {
      return function () {
         var x = delta;
         var v = 1.084556812 * Math.pow(10,
         -6) * Math.pow(x,
         3) - 1.058704484 * Math.pow(10,
         -3) * Math.pow(x,
         2) + 0.195782694 * x - 7.136475544 * Math.pow(10,
         -1);
         return v * 4;
      }();
   };
   var playerVelocity = F2(function (windAngle,
   previousVelocity) {
      return function () {
         var v = polarVelocity(Basics.abs(windAngle));
         var delta = v - previousVelocity;
         return previousVelocity + delta * 2.0e-2;
      }();
   });
   var angleToWind = F2(function (playerDirection,
   windOrigin) {
      return function () {
         var delta = playerDirection - windOrigin;
         return _U.cmp(delta,
         180) > 0 ? delta - 360 : _U.cmp(delta,
         -180) < 1 ? delta + 360 : delta;
      }();
   });
   var mpsToKnts = function (mps) {
      return mps * 3600 / 1.852 / 1000;
   };
   var toRadians = function (deg) {
      return Basics.radians((90 - deg) * Basics.pi / 180);
   };
   var vmgValue = function (a) {
      return Basics.abs(Basics.cos(toRadians(a)) * polarVelocity(a));
   };
   var upwindVmg = Basics.fst(List.last(List.sortBy(Basics.snd)(A2(List.map,
   function (a) {
      return {ctor: "_Tuple2"
             ,_0: a
             ,_1: vmgValue(a)};
   },
   _L.range(30,60)))));
   var downwindVmg = Basics.fst(List.last(List.sortBy(Basics.snd)(A2(List.map,
   function (a) {
      return {ctor: "_Tuple2"
             ,_0: a
             ,_1: vmgValue(a)};
   },
   _L.range(130,180)))));
   var ensure360 = function (val) {
      return Basics.toFloat(A2(Basics.mod,
      Basics.round(val) + 360,
      360));
   };
   _elm.Core.values = {_op: _op
                      ,ensure360: ensure360
                      ,toRadians: toRadians
                      ,mpsToKnts: mpsToKnts
                      ,angleToWind: angleToWind
                      ,polarVelocity: polarVelocity
                      ,vmgValue: vmgValue
                      ,upwindVmg: upwindVmg
                      ,downwindVmg: downwindVmg
                      ,playerVelocity: playerVelocity
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
   var baseText = function (s) {
      return Text.monospace(Text.color(Color.white)(Text.height(14)(Text.toText(s))));
   };
   var fullScreenMessage = function (msg) {
      return Graphics.Collage.alpha(0.3)(Graphics.Collage.toForm(Text.centered(Text.color(Color.white)(Text.height(60)(Text.toText(String.toUpper(msg)))))));
   };
   var colors = {_: {}
                ,sand: A3(Color.rgb,239,210,121)
                ,seaBlue: A3(Color.rgb,
                10,
                105,
                148)};
   var helpMessage = "←/→ to turn left/right, ↓←/↓→ to fine tune direction, ↑ or ENTER to lock angle to wind, SPACE to tack/jibe";
   _elm.Render.Utils.values = {_op: _op
                              ,helpMessage: helpMessage
                              ,colors: colors
                              ,fullScreenMessage: fullScreenMessage
                              ,baseText: baseText};
   return _elm.Render.Utils.values;
};