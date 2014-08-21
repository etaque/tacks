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
   var Render = Elm.Render.make(_elm);
   var Signal = Elm.Signal.make(_elm);
   var Steps = Elm.Steps.make(_elm);
   var String = Elm.String.make(_elm);
   var Text = Elm.Text.make(_elm);
   var Time = Elm.Time.make(_elm);
   var WebSocket = Elm.WebSocket.make(_elm);
   var Window = Elm.Window.make(_elm);
   var _op = {};
   var clock = A2(Signal._op["<~"],
   Time.inSeconds,
   Time.fps(30));
   var raceInput = Native.Ports.portIn("raceInput",
   Native.Ports.incomingSignal(function (v) {
      return typeof v === "object" && "now" in v && "startTime" in v && "opponents" in v ? {_: {}
                                                                                           ,now: typeof v.now === "number" ? v.now : _E.raise("invalid input, expecting JSNumber but got " + v.now)
                                                                                           ,startTime: typeof v.startTime === "number" ? v.startTime : _E.raise("invalid input, expecting JSNumber but got " + v.startTime)
                                                                                           ,opponents: _U.isJSArray(v.opponents) ? _L.fromArray(v.opponents.map(function (v) {
                                                                                              return typeof v === "object" && "position" in v && "direction" in v && "velocity" in v && "passedGates" in v ? {_: {}
                                                                                                                                                                                                             ,position: typeof v.position === "object" && "x" in v.position && "y" in v.position ? {_: {}
                                                                                                                                                                                                                                                                                                   ,x: typeof v.position.x === "number" ? v.position.x : _E.raise("invalid input, expecting JSNumber but got " + v.position.x)
                                                                                                                                                                                                                                                                                                   ,y: typeof v.position.y === "number" ? v.position.y : _E.raise("invalid input, expecting JSNumber but got " + v.position.y)} : _E.raise("invalid input, expecting JSObject [\"x\",\"y\"] but got " + v.position)
                                                                                                                                                                                                             ,direction: typeof v.direction === "number" ? v.direction : _E.raise("invalid input, expecting JSNumber but got " + v.direction)
                                                                                                                                                                                                             ,velocity: typeof v.velocity === "number" ? v.velocity : _E.raise("invalid input, expecting JSNumber but got " + v.velocity)
                                                                                                                                                                                                             ,passedGates: _U.isJSArray(v.passedGates) ? _L.fromArray(v.passedGates.map(function (v) {
                                                                                                                                                                                                                return typeof v === "number" ? v : _E.raise("invalid input, expecting JSNumber but got " + v);
                                                                                                                                                                                                             })) : _E.raise("invalid input, expecting JSArray but got " + v.passedGates)} : _E.raise("invalid input, expecting JSObject [\"position\",\"direction\",\"velocity\",\"passedGates\"] but got " + v);
                                                                                           })) : _E.raise("invalid input, expecting JSArray but got " + v.opponents)} : _E.raise("invalid input, expecting JSObject [\"now\",\"startTime\",\"opponents\"] but got " + v);
   }));
   var input = A2(Signal.sampleOn,
   clock,
   A8(Signal.lift7,
   Inputs.Input,
   clock,
   Inputs.chrono,
   Inputs.keyboardInput,
   Inputs.otherKeyboardInput,
   Inputs.mouseInput,
   Window.dimensions,
   raceInput));
   var gameState = A3(Signal.foldp,
   Steps.stepGame,
   Game.defaultGame,
   input);
   var raceOutput = Native.Ports.portOut("raceOutput",
   Native.Ports.outgoingSignal(function (v) {
      return {position: {x: v.position.x
                        ,y: v.position.y}
             ,direction: v.direction
             ,velocity: v.velocity
             ,passedGates: _L.toArray(v.passedGates).map(function (v) {
                return v;
             })};
   }),
   A2(Signal.lift,
   function ($) {
      return Game.boatToOpponent(function (_) {
         return _.boat;
      }($));
   },
   gameState));
   var main = A3(Signal.lift2,
   Render.render,
   Window.dimensions,
   gameState);
   _elm.ShiftMaster.values = {_op: _op
                             ,clock: clock
                             ,input: input
                             ,gameState: gameState
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
                           ,["countdown"
                            ,Maybe.Just(_v0.startTime - _v0.now)]],
         gameState);
      }();
   });
   var updateWindForBoat = F2(function (wind,
   boat) {
      return function () {
         var gustsOnBoat = List.reverse(List.sortBy(function (_) {
            return _.speedImpact;
         })(A2(List.filter,
         function (g) {
            return _U.cmp(A2(Geo.distance,
            boat.position,
            g.position),
            g.radius) < 1;
         },
         wind.gusts)));
         var windOrigin = List.isEmpty(gustsOnBoat) ? wind.origin : function () {
            var gust = List.head(gustsOnBoat);
            var factor = List.minimum(_L.fromArray([(gust.radius - A2(Geo.distance,
                                                   boat.position,
                                                   gust.position)) / (gust.radius * 0.1)
                                                   ,1]));
            var newDelta = gust.originDelta * factor;
            return Core.ensure360(wind.origin + newDelta);
         }();
         return _U.replace([["windOrigin"
                            ,windOrigin]],
         boat);
      }();
   });
   var gustInBounds = F2(function (bounds,
   gust) {
      return A2(Geo.inBox,
      gust.position,
      bounds);
   });
   var randInWindow = F3(function (t,
   w,
   i) {
      return A2(Basics.mod,
      Math.pow(t,i) + t * i * 1000,
      w);
   });
   var spawnGustX = F3(function (t,
   w,
   spawnIndex) {
      return A3(randInWindow,
      t,
      Basics.round(w),
      spawnIndex) - Basics.round(w / 2);
   });
   var spawnGustY = F3(function (t,
   h,
   spawnIndex) {
      return A3(randInWindow,
      t,
      Basics.round(h),
      spawnIndex);
   });
   var spawnGust = F3(function (timestamp,
   _v2,
   spawnIndex) {
      return function () {
         switch (_v2.ctor)
         {case "_Tuple2":
            switch (_v2._0.ctor)
              {case "_Tuple2":
                 switch (_v2._1.ctor)
                   {case "_Tuple2":
                      return function () {
                           var speedImpact = 0;
                           var t = Basics.round(timestamp);
                           var x = A3(spawnGustX,
                           t,
                           _v2._0._0 - _v2._1._0,
                           spawnIndex + 1);
                           var y = _U.eq(spawnIndex,
                           0) ? Basics.round(_v2._0._1) - 1 : A3(spawnGustY,
                           t,
                           _v2._0._1 - _v2._1._1,
                           spawnIndex);
                           var radius = Basics.toFloat(A3(randInWindow,
                           t,
                           100,
                           spawnIndex + 1) + 100);
                           var originDelta = Basics.toFloat(A3(randInWindow,
                           t,
                           20,
                           spawnIndex + 1) - 10);
                           return {_: {}
                                  ,originDelta: originDelta
                                  ,position: Geo.floatify({ctor: "_Tuple2"
                                                          ,_0: x
                                                          ,_1: y})
                                  ,radius: radius
                                  ,speedImpact: speedImpact};
                        }();}
                   break;}
              break;}
         _E.Case($moduleName,
         "between lines 201 and 209");
      }();
   });
   var updateGusts = F4(function (timestamp,
   delta,
   bounds,
   wind) {
      return function () {
         var moveGust = F2(function (w,
         g) {
            return _U.replace([["position"
                               ,A4(Geo.movePoint,
                               g.position,
                               delta,
                               w.speed,
                               Core.ensure360(180 + wind.origin + g.originDelta))]],
            g);
         });
         var gusts = List.map(moveGust(wind))(A2(List.filter,
         gustInBounds(bounds),
         wind.gusts));
         return List.isEmpty(wind.gusts) ? A2(List.map,
         A2(spawnGust,timestamp,bounds),
         _L.range(1,
         wind.gustsCount)) : _U.cmp(List.length(gusts),
         wind.gustsCount) < 0 ? {ctor: "::"
                                ,_0: A3(spawnGust,
                                timestamp,
                                bounds,
                                0)
                                ,_1: gusts} : gusts;
      }();
   });
   var windStep = F3(function (delta,
   now,
   _v10) {
      return function () {
         return function () {
            var otherBoatWindWind = A2(Core.mapMaybe,
            updateWindForBoat(_v10.wind),
            _v10.otherBoat);
            var boatWithWind = A2(updateWindForBoat,
            _v10.wind,
            _v10.boat);
            var newGusts = A4(updateGusts,
            now,
            delta,
            _v10.bounds,
            _v10.wind);
            var o2 = Basics.cos(Time.inSeconds(now) / 5) * 5;
            var o1 = Basics.cos(Time.inSeconds(now) / 10) * 15;
            var newOrigin = Core.ensure360(o1 + o2);
            var newWind = _U.replace([["origin"
                                      ,newOrigin]
                                     ,["gusts",newGusts]],
            _v10.wind);
            return _U.replace([["wind"
                               ,newWind]
                              ,["boat",boatWithWind]
                              ,["otherBoat"
                               ,otherBoatWindWind]],
            _v10);
         }();
      }();
   });
   var getCenterAfterMove = F4(function (_v12,
   _v13,
   _v14,
   _v15) {
      return function () {
         switch (_v15.ctor)
         {case "_Tuple2":
            return function () {
                 switch (_v14.ctor)
                 {case "_Tuple2":
                    return function () {
                         switch (_v13.ctor)
                         {case "_Tuple2":
                            return function () {
                                 switch (_v12.ctor)
                                 {case "_Tuple2":
                                    return function () {
                                         var refocus = F5(function (n,
                                         n$,
                                         cn,
                                         dn,
                                         margin) {
                                            return function () {
                                               var max = cn + dn / 2 - margin;
                                               var min = cn - dn / 2 + margin;
                                               return _U.cmp(n,
                                               min) < 0 || _U.cmp(n,
                                               max) > 0 ? cn : _U.cmp(n$,
                                               min) < 0 ? cn - (n - n$) : _U.cmp(n$,
                                               max) > 0 ? cn + (n$ - n) : cn;
                                            }();
                                         });
                                         return {ctor: "_Tuple2"
                                                ,_0: A5(refocus,
                                                _v12._0,
                                                _v13._0,
                                                _v14._0,
                                                _v15._0,
                                                _v15._0 * 0.2)
                                                ,_1: A5(refocus,
                                                _v12._1,
                                                _v13._1,
                                                _v14._1,
                                                _v15._1,
                                                _v15._1 * 0.4)};
                                      }();}
                                 _E.Case($moduleName,
                                 "between lines 150 and 159");
                              }();}
                         _E.Case($moduleName,
                         "between lines 150 and 159");
                      }();}
                 _E.Case($moduleName,
                 "between lines 150 and 159");
              }();}
         _E.Case($moduleName,
         "between lines 150 and 159");
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
         gameState.islands);
         var outOfBounds = Basics.not(A2(Geo.inBox,
         p,
         gameState.bounds));
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
   _v28) {
      return function () {
         switch (_v28.ctor)
         {case "_Tuple2":
            switch (_v28._0.ctor)
              {case "_Tuple2":
                 switch (_v28._1.ctor)
                   {case "_Tuple2":
                      return function () {
                           var a = (_v28._0._1 - _v28._1._1) / (_v28._0._0 - _v28._1._0);
                           var b = _v28._0._1 - a * _v28._0._0;
                           var xGate = (gate.y - b) / a;
                           return _U.cmp(Basics.abs(xGate),
                           gate.width / 2) < 1;
                        }();}
                   break;}
              break;}
         _E.Case($moduleName,
         "between lines 99 and 103");
      }();
   });
   var gatePassedFromNorth = F2(function (gate,
   _v36) {
      return function () {
         switch (_v36.ctor)
         {case "_Tuple2":
            return _U.cmp(Basics.snd(_v36._0),
              gate.y) > 0 && (_U.cmp(Basics.snd(_v36._1),
              gate.y) < 1 && A2(gatePassedInX,
              gate,
              {ctor: "_Tuple2"
              ,_0: _v36._0
              ,_1: _v36._1}));}
         _E.Case($moduleName,
         "on line 107, column 4 to 72");
      }();
   });
   var gatePassedFromSouth = F2(function (gate,
   _v40) {
      return function () {
         switch (_v40.ctor)
         {case "_Tuple2":
            return _U.cmp(Basics.snd(_v40._0),
              gate.y) < 0 && (_U.cmp(Basics.snd(_v40._1),
              gate.y) > -1 && A2(gatePassedInX,
              gate,
              {ctor: "_Tuple2"
              ,_0: _v40._0
              ,_1: _v40._1}));}
         _E.Case($moduleName,
         "on line 111, column 4 to 72");
      }();
   });
   var getPassedGates = F4(function (boat,
   timestamp,
   _v44,
   step) {
      return function () {
         return function () {
            var _v46 = {ctor: "_Tuple2"
                       ,_0: A2(Game.findNextGate,
                       boat,
                       Game.course.laps)
                       ,_1: List.isEmpty(boat.passedGates)};
            switch (_v46.ctor)
            {case "_Tuple2":
               switch (_v46._1)
                 {case true:
                    return A2(gatePassedFromSouth,
                      _v44.downwind,
                      step) ? {ctor: "::"
                              ,_0: {ctor: "_Tuple2"
                                   ,_0: Game.Downwind
                                   ,_1: timestamp}
                              ,_1: boat.passedGates} : boat.passedGates;}
                 switch (_v46._0.ctor)
                 {case "Just":
                    switch (_v46._0._0.ctor)
                      {case "Downwind":
                         return A2(gatePassedFromNorth,
                           _v44.downwind,
                           step) ? {ctor: "::"
                                   ,_0: {ctor: "_Tuple2"
                                        ,_0: Game.Downwind
                                        ,_1: timestamp}
                                   ,_1: boat.passedGates} : A2(gatePassedFromNorth,
                           _v44.upwind,
                           step) ? List.tail(boat.passedGates) : boat.passedGates;
                         case "Upwind":
                         return A2(gatePassedFromSouth,
                           _v44.upwind,
                           step) ? {ctor: "::"
                                   ,_0: {ctor: "_Tuple2"
                                        ,_0: Game.Upwind
                                        ,_1: timestamp}
                                   ,_1: boat.passedGates} : A2(gatePassedFromSouth,
                           _v44.downwind,
                           step) ? List.tail(boat.passedGates) : boat.passedGates;}
                      break;
                    case "Nothing":
                    return boat.passedGates;}
                 break;}
            _E.Case($moduleName,
            "between lines 115 and 128");
         }();
      }();
   });
   var moveBoat = F5(function (now,
   delta,
   gameState,
   dimensions,
   boat) {
      return function () {
         var $ = boat,
         position = $.position,
         direction = $.direction,
         velocity = $.velocity,
         windAngle = $.windAngle,
         passedGates = $.passedGates;
         var newVelocity = A2(Core.boatVelocity,
         boat.windAngle,
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
         var newPassedGates = A3(Maybe.maybe,
         false,
         function (c) {
            return _U.cmp(c,0) < 1;
         },
         gameState.countdown) ? A4(getPassedGates,
         boat,
         now,
         gameState.course,
         {ctor: "_Tuple2"
         ,_0: position
         ,_1: newPosition}) : boat.passedGates;
         var newCenter = A4(getCenterAfterMove,
         position,
         newPosition,
         boat.center,
         Geo.floatify(dimensions));
         return _U.replace([["position"
                            ,newPosition]
                           ,["velocity"
                            ,stuck ? 0 : newVelocity]
                           ,["center",newCenter]
                           ,["passedGates"
                            ,newPassedGates]],
         boat);
      }();
   });
   var moveStep = F4(function (now,
   delta,
   _v50,
   gameState) {
      return function () {
         switch (_v50.ctor)
         {case "_Tuple2":
            return function () {
                 var dims = Maybe.isJust(gameState.otherBoat) ? {ctor: "_Tuple2"
                                                                ,_0: A2(Basics.div,
                                                                _v50._0,
                                                                2)
                                                                ,_1: _v50._1} : {ctor: "_Tuple2"
                                                                                ,_0: _v50._0
                                                                                ,_1: _v50._1};
                 var boatMoved = A5(moveBoat,
                 now,
                 delta,
                 gameState,
                 dims,
                 gameState.boat);
                 var otherBoatMoved = A2(Core.mapMaybe,
                 A4(moveBoat,
                 now,
                 delta,
                 gameState,
                 dims),
                 gameState.otherBoat);
                 return _U.replace([["boat"
                                    ,boatMoved]
                                   ,["otherBoat",otherBoatMoved]],
                 gameState);
              }();}
         _E.Case($moduleName,
         "between lines 180 and 185");
      }();
   });
   var getTurn = F3(function (tackTarget,
   boat,
   arrows) {
      return function () {
         var _v54 = {ctor: "_Tuple4"
                    ,_0: tackTarget
                    ,_1: boat.controlMode
                    ,_2: arrows.x
                    ,_3: arrows.y};
         switch (_v54.ctor)
         {case "_Tuple4":
            switch (_v54._0.ctor)
              {case "Just":
                 return function () {
                      var _v60 = boat.controlMode;
                      switch (_v60.ctor)
                      {case "FixedDirection":
                         return function () {
                              var maxTurn = List.minimum(_L.fromArray([2
                                                                      ,Basics.abs(boat.direction - _v54._0._0)]));
                              return _U.cmp(Core.ensure360(boat.direction - _v54._0._0),
                              180) > 0 ? maxTurn : 0 - maxTurn;
                           }();
                         case "FixedWindAngle":
                         return function () {
                              var maxTurn = List.minimum(_L.fromArray([2
                                                                      ,Basics.abs(boat.windAngle - _v54._0._0)]));
                              return _U.cmp(_v54._0._0,
                              90) > 0 || _U.cmp(_v54._0._0,
                              0) < 0 && _U.cmp(_v54._0._0,
                              -90) > -1 ? 0 - maxTurn : maxTurn;
                           }();}
                      _E.Case($moduleName,
                      "between lines 58 and 68");
                   }();
                 case "Nothing":
                 switch (_v54._1.ctor)
                   {case "FixedDirection":
                      switch (_v54._2)
                        {case 0: switch (_v54._3)
                             {case 0: return 0;}
                             break;}
                        break;
                      case "FixedWindAngle":
                      switch (_v54._2)
                        {case 0: switch (_v54._3)
                             {case 0:
                                return boat.windOrigin + boat.windAngle - boat.direction;}
                             break;}
                        break;}
                   return _U.cmp(_v54._3,
                   0) < 0 ? _v54._2 : _v54._2 * 3;}
              break;}
         _E.Case($moduleName,
         "between lines 55 and 71");
      }();
   });
   var tackTargetReached = F2(function (boat,
   targetMaybe) {
      return function () {
         var _v61 = {ctor: "_Tuple2"
                    ,_0: targetMaybe
                    ,_1: boat.controlMode};
         switch (_v61.ctor)
         {case "_Tuple2":
            switch (_v61._0.ctor)
              {case "Just":
                 switch (_v61._1.ctor)
                   {case "FixedDirection":
                      return _U.cmp(Basics.abs(_v61._0._0 - boat.direction),
                        0.1) < 0;
                      case "FixedWindAngle":
                      return _U.cmp(Basics.abs(_v61._0._0 - boat.windAngle),
                        0.1) < 0;}
                   break;
                 case "Nothing": return false;}
              break;}
         _E.Case($moduleName,
         "between lines 31 and 34");
      }();
   });
   var getTackTarget = F2(function (boat,
   spaceKey) {
      return function () {
         var _v65 = {ctor: "_Tuple2"
                    ,_0: boat.tackTarget
                    ,_1: spaceKey};
         switch (_v65.ctor)
         {case "_Tuple2":
            switch (_v65._0.ctor)
              {case "Just":
                 return A2(tackTargetReached,
                   boat,
                   boat.tackTarget) ? Maybe.Nothing : boat.tackTarget;
                 case "Nothing": switch (_v65._1)
                   {case false:
                      return Maybe.Nothing;
                      case true: return function () {
                           var _v69 = boat.controlMode;
                           switch (_v69.ctor)
                           {case "FixedDirection":
                              return Maybe.Just(Core.ensure360(boat.windOrigin - boat.windAngle));
                              case "FixedWindAngle":
                              return Maybe.Just(0 - boat.windAngle);}
                           _E.Case($moduleName,
                           "between lines 45 and 49");
                        }();}
                   break;}
              break;}
         _E.Case($moduleName,
         "between lines 38 and 49");
      }();
   });
   var keysForBoatStep = F2(function (_v70,
   boat) {
      return function () {
         return function () {
            var forceTurn = !_U.eq(_v70.arrows.x,
            0);
            var tackTarget = forceTurn ? Maybe.Nothing : A2(getTackTarget,
            boat,
            _v70.tack);
            var turn = A3(getTurn,
            tackTarget,
            boat,
            _v70.arrows);
            var direction = Core.ensure360(boat.direction + turn);
            var windAngle = A2(Core.angleToWind,
            direction,
            boat.windOrigin);
            var turnedBoat = _U.replace([["direction"
                                         ,direction]
                                        ,["windAngle",windAngle]],
            boat);
            var tackTargetAfterTurn = A2(tackTargetReached,
            turnedBoat,
            tackTarget) ? Maybe.Nothing : tackTarget;
            var controlMode = forceTurn ? Game.FixedDirection : _U.cmp(_v70.arrows.y,
            0) > 0 || _v70.lockAngle ? Game.FixedWindAngle : turnedBoat.controlMode;
            return _U.replace([["controlMode"
                               ,controlMode]
                              ,["tackTarget"
                               ,tackTargetAfterTurn]],
            turnedBoat);
         }();
      }();
   });
   var keysStep = F3(function (keyboardInput,
   otherKeyboardInput,
   gameState) {
      return function () {
         var otherBoatUpdated = A2(Core.mapMaybe,
         keysForBoatStep(otherKeyboardInput),
         gameState.otherBoat);
         var boatUpdated = A2(keysForBoatStep,
         keyboardInput,
         gameState.boat);
         return _U.replace([["boat"
                            ,boatUpdated]
                           ,["otherBoat"
                            ,otherBoatUpdated]],
         gameState);
      }();
   });
   var mouseStep = F2(function (_v72,
   gameState) {
      return function () {
         return function () {
            var boat = gameState.boat;
            var center = function () {
               var _v74 = _v72.drag;
               switch (_v74.ctor)
               {case "Just":
                  switch (_v74._0.ctor)
                    {case "_Tuple2":
                       return function () {
                            var $ = _v72.mouse,
                            x = $._0,
                            y = $._1;
                            return A2(Geo.sub,
                            Geo.floatify({ctor: "_Tuple2"
                                         ,_0: x - _v74._0._0
                                         ,_1: _v74._0._1 - y}),
                            boat.center);
                         }();}
                    break;
                  case "Nothing":
                  return boat.center;}
               _E.Case($moduleName,
               "between lines 23 and 26");
            }();
            return _U.replace([["boat"
                               ,_U.replace([["center",center]],
                               boat)]],
            gameState);
         }();
      }();
   });
   var stepGame = F2(function (input,
   gameState) {
      return mouseStep(input.mouseInput)(A3(moveStep,
      input.raceInput.now,
      input.delta,
      input.windowInput)(A2(keysStep,
      input.keyboardInput,
      input.otherKeyboardInput)(A2(windStep,
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
                       ,keysForBoatStep: keysForBoatStep
                       ,keysStep: keysStep
                       ,gatePassedInX: gatePassedInX
                       ,gatePassedFromNorth: gatePassedFromNorth
                       ,gatePassedFromSouth: gatePassedFromSouth
                       ,getPassedGates: getPassedGates
                       ,getGatesMarks: getGatesMarks
                       ,isStuck: isStuck
                       ,getCenterAfterMove: getCenterAfterMove
                       ,moveBoat: moveBoat
                       ,moveStep: moveStep
                       ,randInWindow: randInWindow
                       ,spawnGustX: spawnGustX
                       ,spawnGustY: spawnGustY
                       ,spawnGust: spawnGust
                       ,gustInBounds: gustInBounds
                       ,updateGusts: updateGusts
                       ,updateWindForBoat: updateWindForBoat
                       ,windStep: windStep
                       ,raceInputStep: raceInputStep
                       ,stepGame: stepGame};
   return _elm.Steps.values;
};Elm.Render = Elm.Render || {};
Elm.Render.make = function (_elm) {
   "use strict";
   _elm.Render = _elm.Render || {};
   if (_elm.Render.values)
   return _elm.Render.values;
   var _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _A = _N.Array.make(_elm),
   _E = _N.Error.make(_elm),
   $moduleName = "Render";
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
   var Signal = Elm.Signal.make(_elm);
   var String = Elm.String.make(_elm);
   var Text = Elm.Text.make(_elm);
   var Time = Elm.Time.make(_elm);
   var _op = {};
   var renderControlWheel = F3(function (wind,
   boat,
   _v0) {
      return function () {
         switch (_v0.ctor)
         {case "_Tuple2":
            return function () {
                 var boatAngle = Core.toRadians(boat.direction);
                 var windAngle = Core.toRadians(boat.windOrigin);
                 var r = 25;
                 var c = Graphics.Collage.outlined(Graphics.Collage.solid(Color.white))(Graphics.Collage.circle(r));
                 var boatWindMarker = Graphics.Collage.traced(Graphics.Collage.solid(Color.white))(A2(Graphics.Collage.segment,
                 Basics.fromPolar({ctor: "_Tuple2"
                                  ,_0: r
                                  ,_1: windAngle}),
                 Basics.fromPolar({ctor: "_Tuple2"
                                  ,_0: r + 8
                                  ,_1: windAngle})));
                 var boatMarker = Graphics.Collage.move(Basics.fromPolar({ctor: "_Tuple2"
                                                                         ,_0: r - 4
                                                                         ,_1: boatAngle}))(Graphics.Collage.rotate(boatAngle - Basics.pi / 2)(Graphics.Collage.filled(Color.white)(Graphics.Collage.polygon(_L.fromArray([{ctor: "_Tuple2"
                                                                                                                                                                                                                          ,_0: 0
                                                                                                                                                                                                                          ,_1: 4}
                                                                                                                                                                                                                         ,{ctor: "_Tuple2"
                                                                                                                                                                                                                          ,_0: -4
                                                                                                                                                                                                                          ,_1: -4}
                                                                                                                                                                                                                         ,{ctor: "_Tuple2"
                                                                                                                                                                                                                          ,_0: 4
                                                                                                                                                                                                                          ,_1: -4}])))));
                 return Graphics.Collage.alpha(0.8)(Graphics.Collage.move({ctor: "_Tuple2"
                                                                          ,_0: _v0._0 / 2 - 50
                                                                          ,_1: _v0._1 / 2 - 80})(Graphics.Collage.group(_L.fromArray([c
                                                                                                                                     ,boatWindMarker
                                                                                                                                     ,boatMarker]))));
              }();}
         _E.Case($moduleName,
         "between lines 216 and 227");
      }();
   });
   var renderIslands = function (gameState) {
      return function () {
         var renderIsland = function (i) {
            return Graphics.Collage.move(i.location)(Graphics.Collage.filled(A3(Color.rgb,
            239,
            210,
            121))(Graphics.Collage.circle(i.radius)));
         };
         return Graphics.Collage.group(A2(List.map,
         renderIsland,
         gameState.islands));
      }();
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
   var hasFinished = F2(function (course,
   boat) {
      return _U.eq(List.length(boat.passedGates),
      course.laps * 2 + 1);
   });
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
                                      ,_1: ch})(Graphics.Collage.filled(A3(Color.rgb,
         10,
         105,
         148))(A2(Graphics.Collage.rect,
         w,
         h)));
      }();
   };
   var renderEqualityLine = F2(function (_v4,
   windOrigin) {
      return function () {
         switch (_v4.ctor)
         {case "_Tuple2":
            return function () {
                 var right = Basics.fromPolar({ctor: "_Tuple2"
                                              ,_0: 50
                                              ,_1: Core.toRadians(windOrigin + 90)});
                 var left = Basics.fromPolar({ctor: "_Tuple2"
                                             ,_0: 50
                                             ,_1: Core.toRadians(windOrigin - 90)});
                 return Graphics.Collage.move({ctor: "_Tuple2"
                                              ,_0: _v4._0
                                              ,_1: _v4._1})(Graphics.Collage.alpha(0.2)(Graphics.Collage.traced(Graphics.Collage.dotted(Color.white))(A2(Graphics.Collage.segment,
                 left,
                 right))));
              }();}
         _E.Case($moduleName,
         "between lines 114 and 117");
      }();
   });
   var renderOpponent = function (opponent) {
      return Graphics.Collage.move({ctor: "_Tuple2"
                                   ,_0: opponent.position.x
                                   ,_1: opponent.position.y})(Graphics.Collage.rotate(Core.toRadians(opponent.direction + 90))(Graphics.Collage.alpha(0.3)(Graphics.Collage.toForm(A3(Graphics.Element.image,
      8,
      19,
      "/assets/images/icon-boat-white.png")))));
   };
   var renderGate = F3(function (gate,
   markRadius,
   nextGate) {
      return function () {
         var isNext = _U.eq(nextGate,
         Maybe.Just(gate.location));
         var markStyle = isNext ? Graphics.Collage.filled(Color.orange) : Graphics.Collage.filled(Color.white);
         var $ = Game.getGateMarks(gate),
         left = $._0,
         right = $._1;
         var line = Graphics.Collage.traced(Graphics.Collage.dotted(Color.orange))(A2(Graphics.Collage.segment,
         left,
         right));
         var leftMark = Graphics.Collage.move(left)(markStyle(Graphics.Collage.circle(markRadius)));
         var rightMark = Graphics.Collage.move(right)(markStyle(Graphics.Collage.circle(markRadius)));
         var marks = _L.fromArray([leftMark
                                  ,rightMark]);
         return isNext ? Graphics.Collage.group({ctor: "::"
                                                ,_0: line
                                                ,_1: marks}) : Graphics.Collage.group(marks);
      }();
   });
   var baseText = function (s) {
      return Text.monospace(Text.color(Color.white)(Text.height(13)(Text.toText(s))));
   };
   var renderHiddenGate = F4(function (gate,
   _v8,
   _v9,
   nextGate) {
      return function () {
         switch (_v9.ctor)
         {case "_Tuple2":
            return function () {
                 switch (_v8.ctor)
                 {case "_Tuple2":
                    return function () {
                         var distance = function (isOver) {
                            return Graphics.Collage.toForm(Text.centered(baseText(String.show(Basics.round(Basics.abs(gate.y + (isOver ? 0 - _v8._1 : _v8._1) / 2 - _v9._1))))));
                         };
                         var c = 5;
                         var over = _U.cmp(_v9._1 + _v8._1 / 2 + c,
                         gate.y) < 0;
                         var under = _U.cmp(_v9._1 - _v8._1 / 2 - c,
                         gate.y) > 0;
                         var isNext = _U.eq(nextGate,
                         Maybe.Just(gate.location));
                         var markStyle = isNext ? Graphics.Collage.filled(Color.orange) : Graphics.Collage.filled(Color.white);
                         var $ = Game.getGateMarks(gate),
                         left = $._0,
                         right = $._1;
                         return function () {
                            var _v16 = {ctor: "_Tuple2"
                                       ,_0: over
                                       ,_1: under};
                            switch (_v16.ctor)
                            {case "_Tuple2":
                               switch (_v16._0)
                                 {case true: return function () {
                                         var d = Graphics.Collage.move({ctor: "_Tuple2"
                                                                       ,_0: 0 - _v9._0
                                                                       ,_1: _v8._1 / 2 - c * 3})(distance(true));
                                         var m = Graphics.Collage.move({ctor: "_Tuple2"
                                                                       ,_0: 0 - _v9._0
                                                                       ,_1: _v8._1 / 2})(markStyle(Graphics.Collage.polygon(_L.fromArray([{ctor: "_Tuple2"
                                                                                                                                          ,_0: 0
                                                                                                                                          ,_1: 0}
                                                                                                                                         ,{ctor: "_Tuple2"
                                                                                                                                          ,_0: 0 - c
                                                                                                                                          ,_1: 0 - c}
                                                                                                                                         ,{ctor: "_Tuple2"
                                                                                                                                          ,_0: c
                                                                                                                                          ,_1: 0 - c}]))));
                                         return Graphics.Collage.group(_L.fromArray([m
                                                                                    ,d]));
                                      }();}
                                 switch (_v16._1)
                                 {case true: return function () {
                                         var d = Graphics.Collage.move({ctor: "_Tuple2"
                                                                       ,_0: 0 - _v9._0
                                                                       ,_1: (0 - _v8._1) / 2 + c * 3})(distance(false));
                                         var m = Graphics.Collage.move({ctor: "_Tuple2"
                                                                       ,_0: 0 - _v9._0
                                                                       ,_1: (0 - _v8._1) / 2})(markStyle(Graphics.Collage.polygon(_L.fromArray([{ctor: "_Tuple2"
                                                                                                                                                ,_0: 0
                                                                                                                                                ,_1: 0}
                                                                                                                                               ,{ctor: "_Tuple2"
                                                                                                                                                ,_0: 0 - c
                                                                                                                                                ,_1: c}
                                                                                                                                               ,{ctor: "_Tuple2"
                                                                                                                                                ,_0: c
                                                                                                                                                ,_1: c}]))));
                                         return Graphics.Collage.group(_L.fromArray([m
                                                                                    ,d]));
                                      }();}
                                 return Graphics.Collage.group(_L.fromArray([]));}
                            _E.Case($moduleName,
                            "between lines 60 and 74");
                         }();
                      }();}
                 _E.Case($moduleName,
                 "between lines 52 and 74");
              }();}
         _E.Case($moduleName,
         "between lines 52 and 74");
      }();
   });
   var renderBoatAngles = function (boat) {
      return function () {
         var windAngleText = Graphics.Collage.alpha(0.8)(Graphics.Collage.move(Basics.fromPolar({ctor: "_Tuple2"
                                                                                                ,_0: 40
                                                                                                ,_1: Core.toRadians(boat.direction - boat.windAngle / 2)}))(Graphics.Collage.toForm(Text.centered((_U.eq(boat.controlMode,
         Game.FixedWindAngle) ? Text.line(Text.Under) : Basics.id)(baseText(_L.append(String.show(Basics.abs(boat.windAngle)),
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
         var directionLine = Graphics.Collage.alpha(0.8)(drawLine(Core.toRadians(boat.direction)));
         var windLine = Graphics.Collage.alpha(0.3)(drawLine(Core.toRadians(boat.direction - boat.windAngle)));
         return Graphics.Collage.group(_L.fromArray([directionLine
                                                    ,windLine
                                                    ,windAngleText]));
      }();
   };
   var renderBoat = function (boat) {
      return function () {
         var angles = renderBoatAngles(boat);
         var hull = Graphics.Collage.rotate(Core.toRadians(boat.direction + 90))(Graphics.Collage.toForm(A3(Graphics.Element.image,
         8,
         19,
         "/assets/images/icon-boat-white.png")));
         return Graphics.Collage.move(boat.position)(Graphics.Collage.group(_L.fromArray([angles
                                                                                         ,hull])));
      }();
   };
   var renderRelative = F3(function (gameState,
   boat,
   opponents) {
      return function () {
         var gusts = renderGusts(gameState.wind);
         var islands = renderIslands(gameState);
         var equalityLine = A2(renderEqualityLine,
         boat.position,
         gameState.wind.origin);
         var opponentsPics = Graphics.Collage.group(A2(List.map,
         function (b) {
            return renderOpponent(b);
         },
         opponents));
         var boatPic = renderBoat(boat);
         var bounds = renderBounds(gameState.bounds);
         var course = gameState.course;
         var nextGate = A2(Game.findNextGate,
         boat,
         course.laps);
         var downwindGate = A3(renderGate,
         course.downwind,
         course.markRadius,
         nextGate);
         var upwindGate = A3(renderGate,
         course.upwind,
         course.markRadius,
         nextGate);
         return Graphics.Collage.move(Geo.neg(boat.center))(Graphics.Collage.group(_L.fromArray([bounds
                                                                                                ,islands
                                                                                                ,gusts
                                                                                                ,downwindGate
                                                                                                ,upwindGate
                                                                                                ,opponentsPics
                                                                                                ,equalityLine
                                                                                                ,boatPic])));
      }();
   });
   var renderLapsCount = F3(function (_v19,
   course,
   boat) {
      return function () {
         switch (_v19.ctor)
         {case "_Tuple2":
            return function () {
                 var count = List.minimum(_L.fromArray([A2(Basics.div,
                                                       List.length(boat.passedGates) + 1,
                                                       2)
                                                       ,course.laps]));
                 var msg = _L.append("LAP ",
                 _L.append(String.show(count),
                 _L.append("/",
                 String.show(course.laps))));
                 return Graphics.Collage.move({ctor: "_Tuple2"
                                              ,_0: _v19._0 / 2 - 50
                                              ,_1: _v19._1 / 2 - 30})(Graphics.Collage.toForm(Text.rightAligned(baseText(msg))));
              }();}
         _E.Case($moduleName,
         "between lines 188 and 194");
      }();
   });
   var renderPolar = F2(function (boat,
   _v23) {
      return function () {
         switch (_v23.ctor)
         {case "_Tuple2":
            return function () {
                 var anglePoint = function (a) {
                    return Basics.fromPolar({ctor: "_Tuple2"
                                            ,_0: Core.polarVelocity(a) * 5
                                            ,_1: Core.toRadians(a)});
                 };
                 var points = A2(List.map,
                 anglePoint,
                 _L.range(0,180));
                 var maxSpeed = List.maximum(A2(List.map,
                 Basics.fst,
                 points)) + 10;
                 var yAxis = Graphics.Collage.alpha(0.5)(Graphics.Collage.traced(Graphics.Collage.solid(Color.white))(A2(Graphics.Collage.segment,
                 {ctor: "_Tuple2"
                 ,_0: 0
                 ,_1: maxSpeed},
                 {ctor: "_Tuple2"
                 ,_0: 0
                 ,_1: 0 - maxSpeed})));
                 var xAxis = Graphics.Collage.alpha(0.5)(Graphics.Collage.traced(Graphics.Collage.solid(Color.white))(A2(Graphics.Collage.segment,
                 {ctor: "_Tuple2",_0: 0,_1: 0},
                 {ctor: "_Tuple2"
                 ,_0: maxSpeed
                 ,_1: 0})));
                 var legend = Graphics.Collage.move({ctor: "_Tuple2"
                                                    ,_0: maxSpeed / 2
                                                    ,_1: maxSpeed * 0.8})(Graphics.Collage.toForm(Text.centered(baseText("VMG"))));
                 var polar = Graphics.Collage.traced(Graphics.Collage.solid(Color.white))(Graphics.Collage.path(points));
                 var boatPoint = anglePoint(Basics.abs(boat.windAngle));
                 var boatMark = Graphics.Collage.move(boatPoint)(Graphics.Collage.filled(Color.red)(Graphics.Collage.circle(2)));
                 var boatProjection = Graphics.Collage.traced(Graphics.Collage.dotted(Color.white))(A2(Graphics.Collage.segment,
                 boatPoint,
                 {ctor: "_Tuple2"
                 ,_0: 0
                 ,_1: Basics.snd(boatPoint)}));
                 return Graphics.Collage.move({ctor: "_Tuple2"
                                              ,_0: (0 - _v23._0) / 2 + 20
                                              ,_1: _v23._1 / 2 - maxSpeed - 20})(Graphics.Collage.group(_L.fromArray([yAxis
                                                                                                                     ,xAxis
                                                                                                                     ,polar
                                                                                                                     ,boatProjection
                                                                                                                     ,boatMark
                                                                                                                     ,legend])));
              }();}
         _E.Case($moduleName,
         "between lines 199 and 212");
      }();
   });
   var fullScreenMessage = function (msg) {
      return Graphics.Collage.alpha(0.3)(Graphics.Collage.toForm(Text.centered(Text.monospace(Text.color(Color.white)(Text.height(100)(Text.toText(String.toUpper(msg))))))));
   };
   var renderCountdown = F2(function (gameState,
   boat) {
      return function () {
         var _v27 = gameState.countdown;
         switch (_v27.ctor)
         {case "Just":
            return _U.cmp(_v27._0,
              0) > 0 ? function () {
                 var cs = Basics.round(Time.inSeconds(_v27._0));
                 var m = cs / 60 | 0;
                 var s = A2(Basics.rem,cs,60);
                 var msg = _L.append(String.show(m),
                 _L.append("\'",
                 _L.append(String.show(s),
                 "\"")));
                 return fullScreenMessage(msg);
              }() : List.isEmpty(boat.passedGates) ? fullScreenMessage("Go!") : fullScreenMessage(" ");
            case "Nothing":
            return Graphics.Collage.toForm(Graphics.Element.empty);}
         _E.Case($moduleName,
         "between lines 131 and 140");
      }();
   });
   var renderWinner = F3(function (course,
   boat,
   opponents) {
      return function () {
         var me = Game.boatToOpponent(boat);
         return A2(hasFinished,
         course,
         me) ? function () {
            var finishTime = function (o) {
               return List.head(o.passedGates);
            };
            var othersTime = List.map(finishTime)(A2(List.filter,
            hasFinished(course),
            opponents));
            var myTime = finishTime(me);
            var othersAfterMe = A2(List.all,
            function (t) {
               return _U.cmp(t,myTime) > 0;
            },
            othersTime);
            return List.isEmpty(othersTime) || othersAfterMe ? fullScreenMessage("WINNER") : Graphics.Collage.toForm(Graphics.Element.empty);
         }() : Graphics.Collage.toForm(Graphics.Element.empty);
      }();
   });
   var renderAbsolute = F4(function (gameState,
   boat,
   opponents,
   dims) {
      return function () {
         var controlWheel = A3(renderControlWheel,
         Game.wind,
         boat,
         dims);
         var polar = A2(renderPolar,
         boat,
         dims);
         var lapsCount = A3(renderLapsCount,
         dims,
         gameState.course,
         boat);
         var winner = A3(renderWinner,
         gameState.course,
         boat,
         opponents);
         var countdown = A2(renderCountdown,
         gameState,
         boat);
         var course = gameState.course;
         var nextGate = function () {
            var _v29 = gameState.countdown;
            switch (_v29.ctor)
            {case "Just":
               return _U.cmp(_v29._0,
                 0) < 1 ? A2(Game.findNextGate,
                 boat,
                 course.laps) : Maybe.Nothing;
               case "Nothing":
               return Maybe.Nothing;}
            _E.Case($moduleName,
            "between lines 248 and 251");
         }();
         var downwindHiddenGate = A4(renderHiddenGate,
         course.downwind,
         dims,
         boat.center,
         nextGate);
         var upwindHiddenGate = A4(renderHiddenGate,
         course.upwind,
         dims,
         boat.center,
         nextGate);
         return Graphics.Collage.group(_L.fromArray([polar
                                                    ,controlWheel
                                                    ,upwindHiddenGate
                                                    ,downwindHiddenGate
                                                    ,lapsCount
                                                    ,countdown
                                                    ,winner]));
      }();
   });
   var renderRaceForBoat = F4(function (_v31,
   gameState,
   boat,
   opponents) {
      return function () {
         switch (_v31.ctor)
         {case "_Tuple2":
            return function () {
                 var relativeToCenter = A3(renderRelative,
                 gameState,
                 boat,
                 opponents);
                 var dims = Geo.floatify({ctor: "_Tuple2"
                                         ,_0: _v31._0
                                         ,_1: _v31._1});
                 var $ = dims,
                 w$ = $._0,
                 h$ = $._1;
                 var bg = Graphics.Collage.filled(A3(Color.rgb,
                 239,
                 210,
                 121))(A2(Graphics.Collage.rect,
                 w$,
                 h$));
                 var absolute = A4(renderAbsolute,
                 gameState,
                 boat,
                 opponents,
                 dims);
                 return Graphics.Element.layers(_L.fromArray([A3(Graphics.Collage.collage,
                 _v31._0,
                 _v31._1,
                 _L.fromArray([bg
                              ,Graphics.Collage.group(_L.fromArray([relativeToCenter
                                                                   ,absolute]))]))]));
              }();}
         _E.Case($moduleName,
         "between lines 263 and 269");
      }();
   });
   var render = F2(function (_v35,
   gameState) {
      return function () {
         switch (_v35.ctor)
         {case "_Tuple2":
            return function () {
                 var _v39 = gameState.otherBoat;
                 switch (_v39.ctor)
                 {case "Just":
                    return function () {
                         var w$ = A2(Basics.div,
                         _v35._0,
                         2) - 2;
                         var r1 = A4(renderRaceForBoat,
                         {ctor: "_Tuple2"
                         ,_0: w$
                         ,_1: _v35._1},
                         gameState,
                         gameState.boat,
                         A2(List.map,
                         Game.boatToOpponent,
                         _L.fromArray([_v39._0])));
                         var r2 = A4(renderRaceForBoat,
                         {ctor: "_Tuple2"
                         ,_0: w$
                         ,_1: _v35._1},
                         gameState,
                         _v39._0,
                         A2(List.map,
                         Game.boatToOpponent,
                         _L.fromArray([gameState.boat])));
                         return A2(Graphics.Element.flow,
                         Graphics.Element.left,
                         _L.fromArray([r1
                                      ,A2(Graphics.Element.spacer,4,1)
                                      ,r2]));
                      }();
                    case "Nothing":
                    return A4(renderRaceForBoat,
                      {ctor: "_Tuple2"
                      ,_0: _v35._0
                      ,_1: _v35._1},
                      gameState,
                      gameState.boat,
                      gameState.opponents);}
                 _E.Case($moduleName,
                 "between lines 273 and 278");
              }();}
         _E.Case($moduleName,
         "between lines 273 and 278");
      }();
   });
   _elm.Render.values = {_op: _op
                        ,fullScreenMessage: fullScreenMessage
                        ,baseText: baseText
                        ,renderGate: renderGate
                        ,renderHiddenGate: renderHiddenGate
                        ,renderBoatAngles: renderBoatAngles
                        ,renderBoat: renderBoat
                        ,renderOpponent: renderOpponent
                        ,renderEqualityLine: renderEqualityLine
                        ,renderBounds: renderBounds
                        ,renderCountdown: renderCountdown
                        ,hasFinished: hasFinished
                        ,renderWinner: renderWinner
                        ,renderGust: renderGust
                        ,renderGusts: renderGusts
                        ,renderIslands: renderIslands
                        ,renderLapsCount: renderLapsCount
                        ,renderPolar: renderPolar
                        ,renderControlWheel: renderControlWheel
                        ,renderRelative: renderRelative
                        ,renderAbsolute: renderAbsolute
                        ,renderRaceForBoat: renderRaceForBoat
                        ,render: render};
   return _elm.Render.values;
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
   var Input = F7(function (a,
   b,
   c,
   d,
   e,
   f,
   g) {
      return {_: {}
             ,chrono: b
             ,delta: a
             ,keyboardInput: c
             ,mouseInput: e
             ,otherKeyboardInput: d
             ,raceInput: g
             ,windowInput: f};
   });
   var chrono = A3(Signal.foldp,
   F2(function (x,y) {
      return x + y;
   }),
   0,
   Time.fps(1));
   var RaceInput = F3(function (a,
   b,
   c) {
      return {_: {}
             ,now: a
             ,opponents: c
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
   var KeyboardInput = F3(function (a,
   b,
   c) {
      return {_: {}
             ,arrows: a
             ,lockAngle: b
             ,tack: c};
   });
   var keyboardInput = A4(Signal.lift3,
   KeyboardInput,
   Keyboard.arrows,
   Keyboard.enter,
   Keyboard.space);
   var otherKeyboardInput = A4(Signal.lift3,
   KeyboardInput,
   A4(Keyboard.directions,
   90,
   83,
   81,
   68),
   Keyboard.shift,
   Keyboard.ctrl);
   var UserArrows = F2(function (a,
   b) {
      return {_: {},x: a,y: b};
   });
   _elm.Inputs.values = {_op: _op
                        ,mouseInput: mouseInput
                        ,keyboardInput: keyboardInput
                        ,otherKeyboardInput: otherKeyboardInput
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
   var boatToOpponent = function (_v0) {
      return function () {
         return function () {
            var gates = A2(List.map,
            Basics.snd,
            _v0.passedGates);
            var $ = _v0.position,
            x = $._0,
            y = $._1;
            return {_: {}
                   ,direction: _v0.direction
                   ,passedGates: gates
                   ,position: {_: {},x: x,y: y}
                   ,velocity: _v0.velocity};
         }();
      }();
   };
   var getGateMarks = function (gate) {
      return {ctor: "_Tuple2"
             ,_0: {ctor: "_Tuple2"
                  ,_0: (0 - gate.width) / 2
                  ,_1: gate.y}
             ,_1: {ctor: "_Tuple2"
                  ,_0: gate.width / 2
                  ,_1: gate.y}};
   };
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
   var wind = {_: {}
              ,gusts: _L.fromArray([])
              ,gustsCount: 0
              ,origin: 0
              ,speed: 10};
   var RaceState = function (a) {
      return {_: {},boats: a};
   };
   var GameState = F9(function (a,
   b,
   c,
   d,
   e,
   f,
   g,
   h,
   i) {
      return {_: {}
             ,boat: b
             ,bounds: f
             ,countdown: i
             ,course: e
             ,islands: g
             ,opponents: d
             ,otherBoat: c
             ,startDuration: h
             ,wind: a};
   });
   var Island = F2(function (a,b) {
      return {_: {}
             ,location: a
             ,radius: b};
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
   var Opponent = F4(function (a,
   b,
   c,
   d) {
      return {_: {}
             ,direction: b
             ,passedGates: d
             ,position: a
             ,velocity: c};
   });
   var Boat = function (a) {
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
                                        ,center: g
                                        ,controlMode: h
                                        ,direction: b
                                        ,passedGates: j
                                        ,position: a
                                        ,tackTarget: i
                                        ,velocity: c
                                        ,windAngle: d
                                        ,windOrigin: e
                                        ,windSpeed: f};
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
   var FixedWindAngle = {ctor: "FixedWindAngle"};
   var FixedDirection = {ctor: "FixedDirection"};
   var boat = {_: {}
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
   var otherBoat = _U.replace([["position"
                               ,{ctor: "_Tuple2"
                                ,_0: -50
                                ,_1: -200}]],
   boat);
   var Course = F4(function (a,
   b,
   c,
   d) {
      return {_: {}
             ,downwind: b
             ,laps: c
             ,markRadius: d
             ,upwind: a};
   });
   var Gate = F3(function (a,b,c) {
      return {_: {}
             ,location: c
             ,width: b
             ,y: a};
   });
   var Upwind = {ctor: "Upwind"};
   var upwindGate = {_: {}
                    ,location: Upwind
                    ,width: 100
                    ,y: 1000};
   var Downwind = {ctor: "Downwind"};
   var startLine = {_: {}
                   ,location: Downwind
                   ,width: 100
                   ,y: -100};
   var course = {_: {}
                ,downwind: startLine
                ,laps: 3
                ,markRadius: 5
                ,upwind: upwindGate};
   var defaultGame = {_: {}
                     ,boat: boat
                     ,bounds: {ctor: "_Tuple2"
                              ,_0: {ctor: "_Tuple2"
                                   ,_0: 800
                                   ,_1: 1200}
                              ,_1: {ctor: "_Tuple2"
                                   ,_0: -800
                                   ,_1: -400}}
                     ,countdown: Maybe.Nothing
                     ,course: course
                     ,islands: islands
                     ,opponents: _L.fromArray([])
                     ,otherBoat: Maybe.Nothing
                     ,startDuration: 30 * Time.second
                     ,wind: wind};
   var findNextGate = F2(function (boat,
   laps) {
      return function () {
         var c = List.length(boat.passedGates);
         var i = A2(Basics.mod,c,2);
         return _U.eq(c,
         laps * 2 + 1) ? Maybe.Nothing : _U.eq(i,
         0) ? Maybe.Just(Downwind) : Maybe.Just(Upwind);
      }();
   });
   _elm.Game.values = {_op: _op
                      ,startLine: startLine
                      ,upwindGate: upwindGate
                      ,course: course
                      ,boat: boat
                      ,otherBoat: otherBoat
                      ,wind: wind
                      ,islands: islands
                      ,defaultGame: defaultGame
                      ,getGateMarks: getGateMarks
                      ,findNextGate: findNextGate
                      ,boatToOpponent: boatToOpponent
                      ,Downwind: Downwind
                      ,Upwind: Upwind
                      ,FixedDirection: FixedDirection
                      ,FixedWindAngle: FixedWindAngle
                      ,Gate: Gate
                      ,Course: Course
                      ,Boat: Boat
                      ,Opponent: Opponent
                      ,Gust: Gust
                      ,Wind: Wind
                      ,Island: Island
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
         "between lines 30 and 33");
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
         "on line 26, column 4 to 42");
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
                           "on line 22, column 3 to 47");
                        }();}
                   break;}
              break;}
         _E.Case($moduleName,
         "on line 22, column 3 to 47");
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
                 "on line 18, column 3 to 34");
              }();}
         _E.Case($moduleName,
         "on line 18, column 3 to 34");
      }();
   });
   var neg = function (_v28) {
      return function () {
         switch (_v28.ctor)
         {case "_Tuple2":
            return {ctor: "_Tuple2"
                   ,_0: 0 - _v28._0
                   ,_1: 0 - _v28._1};}
         _E.Case($moduleName,
         "on line 14, column 14 to 19");
      }();
   };
   var sub = F2(function (_v32,
   _v33) {
      return function () {
         switch (_v33.ctor)
         {case "_Tuple2":
            return function () {
                 switch (_v32.ctor)
                 {case "_Tuple2":
                    return {ctor: "_Tuple2"
                           ,_0: _v33._0 - _v32._0
                           ,_1: _v33._1 - _v32._1};}
                 _E.Case($moduleName,
                 "on line 11, column 22 to 36");
              }();}
         _E.Case($moduleName,
         "on line 11, column 22 to 36");
      }();
   });
   var floatify = function (_v40) {
      return function () {
         switch (_v40.ctor)
         {case "_Tuple2":
            return {ctor: "_Tuple2"
                   ,_0: Basics.toFloat(_v40._0)
                   ,_1: Basics.toFloat(_v40._1)};}
         _E.Case($moduleName,
         "on line 8, column 19 to 39");
      }();
   };
   _elm.Geo.values = {_op: _op
                     ,floatify: floatify
                     ,sub: sub
                     ,neg: neg
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
   var average = function (items) {
      return List.sum(items) / Basics.toFloat(List.length(items));
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
         "between lines 45 and 47");
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
         return _U.cmp(v,0) < 0 ? v : v;
      }();
   };
   var boatVelocity = F2(function (windAngle,
   previousVelocity) {
      return function () {
         var v = polarVelocity(Basics.abs(windAngle)) * 5;
         var delta = v - previousVelocity;
         return previousVelocity + delta * 2.0e-2;
      }();
   });
   var angleToWind = F2(function (boatDirection,
   windOrigin) {
      return function () {
         var delta = boatDirection - windOrigin;
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
                      ,boatVelocity: boatVelocity
                      ,mapMaybe: mapMaybe
                      ,average: average};
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
};