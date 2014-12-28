var Elm = Elm || { Native: {} };
Elm.Basics = Elm.Basics || {};
Elm.Basics.make = function (_elm) {
   "use strict";
   _elm.Basics = _elm.Basics || {};
   if (_elm.Basics.values)
   return _elm.Basics.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _P = _N.Ports.make(_elm),
   $moduleName = "Basics",
   $Native$Basics = Elm.Native.Basics.make(_elm),
   $Native$Show = Elm.Native.Show.make(_elm),
   $Native$Utils = Elm.Native.Utils.make(_elm);
   var uncurry = F2(function (f,
   _v0) {
      return function () {
         switch (_v0.ctor)
         {case "_Tuple2": return A2(f,
              _v0._0,
              _v0._1);}
         _U.badCase($moduleName,
         "on line 458, column 19 to 24");
      }();
   });
   var curry = F3(function (f,
   a,
   b) {
      return f({ctor: "_Tuple2"
               ,_0: a
               ,_1: b});
   });
   var flip = F3(function (f,b,a) {
      return A2(f,a,b);
   });
   var snd = function (_v4) {
      return function () {
         switch (_v4.ctor)
         {case "_Tuple2": return _v4._1;}
         _U.badCase($moduleName,
         "on line 442, column 13 to 14");
      }();
   };
   var fst = function (_v8) {
      return function () {
         switch (_v8.ctor)
         {case "_Tuple2": return _v8._0;}
         _U.badCase($moduleName,
         "on line 438, column 13 to 14");
      }();
   };
   var always = F2(function (a,
   _v12) {
      return function () {
         return a;
      }();
   });
   var identity = function (x) {
      return x;
   };
   _op["<|"] = F2(function (f,x) {
      return f(x);
   });
   _op["|>"] = F2(function (x,f) {
      return f(x);
   });
   _op[">>"] = F3(function (f,
   g,
   x) {
      return g(f(x));
   });
   _op["<<"] = F3(function (g,
   f,
   x) {
      return g(f(x));
   });
   _op["++"] = $Native$Utils.append;
   var toString = $Native$Show.toString;
   var isInfinite = $Native$Basics.isInfinite;
   var isNaN = $Native$Basics.isNaN;
   var toFloat = $Native$Basics.toFloat;
   var ceiling = $Native$Basics.ceiling;
   var floor = $Native$Basics.floor;
   var truncate = $Native$Basics.truncate;
   var round = $Native$Basics.round;
   var otherwise = true;
   var not = $Native$Basics.not;
   var xor = $Native$Basics.xor;
   _op["||"] = $Native$Basics.or;
   _op["&&"] = $Native$Basics.and;
   var max = $Native$Basics.max;
   var min = $Native$Basics.min;
   var GT = {ctor: "GT"};
   var EQ = {ctor: "EQ"};
   var LT = {ctor: "LT"};
   var compare = $Native$Basics.compare;
   _op[">="] = $Native$Basics.ge;
   _op["<="] = $Native$Basics.le;
   _op[">"] = $Native$Basics.gt;
   _op["<"] = $Native$Basics.lt;
   _op["/="] = $Native$Basics.neq;
   _op["=="] = $Native$Basics.eq;
   var e = $Native$Basics.e;
   var pi = $Native$Basics.pi;
   var clamp = $Native$Basics.clamp;
   var logBase = $Native$Basics.logBase;
   var abs = $Native$Basics.abs;
   var negate = $Native$Basics.negate;
   var sqrt = $Native$Basics.sqrt;
   var atan2 = $Native$Basics.atan2;
   var atan = $Native$Basics.atan;
   var asin = $Native$Basics.asin;
   var acos = $Native$Basics.acos;
   var tan = $Native$Basics.tan;
   var sin = $Native$Basics.sin;
   var cos = $Native$Basics.cos;
   _op["^"] = $Native$Basics.exp;
   _op["%"] = $Native$Basics.mod;
   var rem = $Native$Basics.rem;
   _op["//"] = $Native$Basics.div;
   _op["/"] = $Native$Basics.floatDiv;
   _op["*"] = $Native$Basics.mul;
   _op["-"] = $Native$Basics.sub;
   _op["+"] = $Native$Basics.add;
   var toPolar = $Native$Basics.toPolar;
   var fromPolar = $Native$Basics.fromPolar;
   var turns = $Native$Basics.turns;
   var degrees = $Native$Basics.degrees;
   var radians = function (t) {
      return t;
   };
   _elm.Basics.values = {_op: _op
                        ,radians: radians
                        ,degrees: degrees
                        ,turns: turns
                        ,fromPolar: fromPolar
                        ,toPolar: toPolar
                        ,rem: rem
                        ,cos: cos
                        ,sin: sin
                        ,tan: tan
                        ,acos: acos
                        ,asin: asin
                        ,atan: atan
                        ,atan2: atan2
                        ,sqrt: sqrt
                        ,negate: negate
                        ,abs: abs
                        ,logBase: logBase
                        ,clamp: clamp
                        ,pi: pi
                        ,e: e
                        ,compare: compare
                        ,LT: LT
                        ,EQ: EQ
                        ,GT: GT
                        ,min: min
                        ,max: max
                        ,xor: xor
                        ,not: not
                        ,otherwise: otherwise
                        ,round: round
                        ,truncate: truncate
                        ,floor: floor
                        ,ceiling: ceiling
                        ,toFloat: toFloat
                        ,isNaN: isNaN
                        ,isInfinite: isInfinite
                        ,toString: toString
                        ,identity: identity
                        ,always: always
                        ,fst: fst
                        ,snd: snd
                        ,flip: flip
                        ,curry: curry
                        ,uncurry: uncurry};
   return _elm.Basics.values;
};
Elm.Char = Elm.Char || {};
Elm.Char.make = function (_elm) {
   "use strict";
   _elm.Char = _elm.Char || {};
   if (_elm.Char.values)
   return _elm.Char.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _P = _N.Ports.make(_elm),
   $moduleName = "Char",
   $Native$Char = Elm.Native.Char.make(_elm);
   var fromCode = $Native$Char.fromCode;
   var toCode = $Native$Char.toCode;
   var toLocaleLower = $Native$Char.toLocaleLower;
   var toLocaleUpper = $Native$Char.toLocaleUpper;
   var toLower = $Native$Char.toLower;
   var toUpper = $Native$Char.toUpper;
   var isHexDigit = $Native$Char.isHexDigit;
   var isOctDigit = $Native$Char.isOctDigit;
   var isDigit = $Native$Char.isDigit;
   var isLower = $Native$Char.isLower;
   var isUpper = $Native$Char.isUpper;
   _elm.Char.values = {_op: _op
                      ,isUpper: isUpper
                      ,isLower: isLower
                      ,isDigit: isDigit
                      ,isOctDigit: isOctDigit
                      ,isHexDigit: isHexDigit
                      ,toUpper: toUpper
                      ,toLower: toLower
                      ,toLocaleUpper: toLocaleUpper
                      ,toLocaleLower: toLocaleLower
                      ,toCode: toCode
                      ,fromCode: fromCode};
   return _elm.Char.values;
};
Elm.Color = Elm.Color || {};
Elm.Color.make = function (_elm) {
   "use strict";
   _elm.Color = _elm.Color || {};
   if (_elm.Color.values)
   return _elm.Color.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _P = _N.Ports.make(_elm),
   $moduleName = "Color",
   $Basics = Elm.Basics.make(_elm);
   var Radial = F5(function (a,
   b,
   c,
   d,
   e) {
      return {ctor: "Radial"
             ,_0: a
             ,_1: b
             ,_2: c
             ,_3: d
             ,_4: e};
   });
   var radial = Radial;
   var Linear = F3(function (a,
   b,
   c) {
      return {ctor: "Linear"
             ,_0: a
             ,_1: b
             ,_2: c};
   });
   var linear = Linear;
   var fmod = F2(function (f,n) {
      return function () {
         var integer = $Basics.floor(f);
         return $Basics.toFloat(A2($Basics._op["%"],
         integer,
         n)) + f - $Basics.toFloat(integer);
      }();
   });
   var rgbToHsl = F3(function (red,
   green,
   blue) {
      return function () {
         var b = $Basics.toFloat(blue) / 255;
         var g = $Basics.toFloat(green) / 255;
         var r = $Basics.toFloat(red) / 255;
         var cMax = A2($Basics.max,
         A2($Basics.max,r,g),
         b);
         var cMin = A2($Basics.min,
         A2($Basics.min,r,g),
         b);
         var c = cMax - cMin;
         var lightness = (cMax + cMin) / 2;
         var saturation = _U.eq(lightness,
         0) ? 0 : c / (1 - $Basics.abs(2 * lightness - 1));
         var hue = $Basics.degrees(60) * (_U.eq(cMax,
         r) ? A2(fmod,
         (g - b) / c,
         6) : _U.eq(cMax,
         g) ? (b - r) / c + 2 : _U.eq(cMax,
         b) ? (r - g) / c + 4 : _U.badIf($moduleName,
         "between lines 141 and 143"));
         return {ctor: "_Tuple3"
                ,_0: hue
                ,_1: saturation
                ,_2: lightness};
      }();
   });
   var hslToRgb = F3(function (hue,
   saturation,
   lightness) {
      return function () {
         var hue$ = hue / $Basics.degrees(60);
         var chroma = (1 - $Basics.abs(2 * lightness - 1)) * saturation;
         var x = chroma * (1 - $Basics.abs(A2(fmod,
         hue$,
         2) - 1));
         var $ = _U.cmp(hue$,
         0) < 0 ? {ctor: "_Tuple3"
                  ,_0: 0
                  ,_1: 0
                  ,_2: 0} : _U.cmp(hue$,
         1) < 0 ? {ctor: "_Tuple3"
                  ,_0: chroma
                  ,_1: x
                  ,_2: 0} : _U.cmp(hue$,
         2) < 0 ? {ctor: "_Tuple3"
                  ,_0: x
                  ,_1: chroma
                  ,_2: 0} : _U.cmp(hue$,
         3) < 0 ? {ctor: "_Tuple3"
                  ,_0: 0
                  ,_1: chroma
                  ,_2: x} : _U.cmp(hue$,
         4) < 0 ? {ctor: "_Tuple3"
                  ,_0: 0
                  ,_1: x
                  ,_2: chroma} : _U.cmp(hue$,
         5) < 0 ? {ctor: "_Tuple3"
                  ,_0: x
                  ,_1: 0
                  ,_2: chroma} : _U.cmp(hue$,
         6) < 0 ? {ctor: "_Tuple3"
                  ,_0: chroma
                  ,_1: 0
                  ,_2: x} : {ctor: "_Tuple3"
                            ,_0: 0
                            ,_1: 0
                            ,_2: 0},
         r = $._0,
         g = $._1,
         b = $._2;
         var m = lightness - chroma / 2;
         return {ctor: "_Tuple3"
                ,_0: r + m
                ,_1: g + m
                ,_2: b + m};
      }();
   });
   var toRgb = function (color) {
      return function () {
         switch (color.ctor)
         {case "HSLA":
            return function () {
                 var $ = A3(hslToRgb,
                 color._0,
                 color._1,
                 color._2),
                 r = $._0,
                 g = $._1,
                 b = $._2;
                 return {_: {}
                        ,alpha: color._3
                        ,blue: $Basics.round(255 * b)
                        ,green: $Basics.round(255 * g)
                        ,red: $Basics.round(255 * r)};
              }();
            case "RGBA": return {_: {}
                                ,alpha: color._3
                                ,blue: color._2
                                ,green: color._1
                                ,red: color._0};}
         _U.badCase($moduleName,
         "between lines 115 and 123");
      }();
   };
   var toHsl = function (color) {
      return function () {
         switch (color.ctor)
         {case "HSLA": return {_: {}
                              ,alpha: color._3
                              ,hue: color._0
                              ,lightness: color._2
                              ,saturation: color._1};
            case "RGBA":
            return function () {
                 var $ = A3(rgbToHsl,
                 color._0,
                 color._1,
                 color._2),
                 h = $._0,
                 s = $._1,
                 l = $._2;
                 return {_: {}
                        ,alpha: color._3
                        ,hue: h
                        ,lightness: l
                        ,saturation: s};
              }();}
         _U.badCase($moduleName,
         "between lines 105 and 112");
      }();
   };
   var HSLA = F4(function (a,
   b,
   c,
   d) {
      return {ctor: "HSLA"
             ,_0: a
             ,_1: b
             ,_2: c
             ,_3: d};
   });
   var hsla = F4(function (hue,
   saturation,
   lightness,
   alpha) {
      return A4(HSLA,
      hue - $Basics.turns($Basics.toFloat($Basics.floor(hue / (2 * $Basics.pi)))),
      saturation,
      lightness,
      alpha);
   });
   var hsl = F3(function (hue,
   saturation,
   lightness) {
      return A4(hsla,
      hue,
      saturation,
      lightness,
      1);
   });
   var complement = function (color) {
      return function () {
         switch (color.ctor)
         {case "HSLA": return A4(hsla,
              color._0 + $Basics.degrees(180),
              color._1,
              color._2,
              color._3);
            case "RGBA":
            return function () {
                 var $ = A3(rgbToHsl,
                 color._0,
                 color._1,
                 color._2),
                 h = $._0,
                 s = $._1,
                 l = $._2;
                 return A4(hsla,
                 h + $Basics.degrees(180),
                 s,
                 l,
                 color._3);
              }();}
         _U.badCase($moduleName,
         "between lines 96 and 102");
      }();
   };
   var grayscale = function (p) {
      return A4(HSLA,0,0,1 - p,1);
   };
   var greyscale = function (p) {
      return A4(HSLA,0,0,1 - p,1);
   };
   var RGBA = F4(function (a,
   b,
   c,
   d) {
      return {ctor: "RGBA"
             ,_0: a
             ,_1: b
             ,_2: c
             ,_3: d};
   });
   var rgba = RGBA;
   var rgb = F3(function (r,g,b) {
      return A4(RGBA,r,g,b,1);
   });
   var lightRed = A4(RGBA,
   239,
   41,
   41,
   1);
   var red = A4(RGBA,204,0,0,1);
   var darkRed = A4(RGBA,
   164,
   0,
   0,
   1);
   var lightOrange = A4(RGBA,
   252,
   175,
   62,
   1);
   var orange = A4(RGBA,
   245,
   121,
   0,
   1);
   var darkOrange = A4(RGBA,
   206,
   92,
   0,
   1);
   var lightYellow = A4(RGBA,
   255,
   233,
   79,
   1);
   var yellow = A4(RGBA,
   237,
   212,
   0,
   1);
   var darkYellow = A4(RGBA,
   196,
   160,
   0,
   1);
   var lightGreen = A4(RGBA,
   138,
   226,
   52,
   1);
   var green = A4(RGBA,
   115,
   210,
   22,
   1);
   var darkGreen = A4(RGBA,
   78,
   154,
   6,
   1);
   var lightBlue = A4(RGBA,
   114,
   159,
   207,
   1);
   var blue = A4(RGBA,
   52,
   101,
   164,
   1);
   var darkBlue = A4(RGBA,
   32,
   74,
   135,
   1);
   var lightPurple = A4(RGBA,
   173,
   127,
   168,
   1);
   var purple = A4(RGBA,
   117,
   80,
   123,
   1);
   var darkPurple = A4(RGBA,
   92,
   53,
   102,
   1);
   var lightBrown = A4(RGBA,
   233,
   185,
   110,
   1);
   var brown = A4(RGBA,
   193,
   125,
   17,
   1);
   var darkBrown = A4(RGBA,
   143,
   89,
   2,
   1);
   var black = A4(RGBA,0,0,0,1);
   var white = A4(RGBA,
   255,
   255,
   255,
   1);
   var lightGrey = A4(RGBA,
   238,
   238,
   236,
   1);
   var grey = A4(RGBA,
   211,
   215,
   207,
   1);
   var darkGrey = A4(RGBA,
   186,
   189,
   182,
   1);
   var lightGray = A4(RGBA,
   238,
   238,
   236,
   1);
   var gray = A4(RGBA,
   211,
   215,
   207,
   1);
   var darkGray = A4(RGBA,
   186,
   189,
   182,
   1);
   var lightCharcoal = A4(RGBA,
   136,
   138,
   133,
   1);
   var charcoal = A4(RGBA,
   85,
   87,
   83,
   1);
   var darkCharcoal = A4(RGBA,
   46,
   52,
   54,
   1);
   _elm.Color.values = {_op: _op
                       ,RGBA: RGBA
                       ,HSLA: HSLA
                       ,rgba: rgba
                       ,rgb: rgb
                       ,hsla: hsla
                       ,hsl: hsl
                       ,grayscale: grayscale
                       ,greyscale: greyscale
                       ,complement: complement
                       ,toHsl: toHsl
                       ,toRgb: toRgb
                       ,fmod: fmod
                       ,rgbToHsl: rgbToHsl
                       ,hslToRgb: hslToRgb
                       ,Linear: Linear
                       ,Radial: Radial
                       ,linear: linear
                       ,radial: radial
                       ,lightRed: lightRed
                       ,red: red
                       ,darkRed: darkRed
                       ,lightOrange: lightOrange
                       ,orange: orange
                       ,darkOrange: darkOrange
                       ,lightYellow: lightYellow
                       ,yellow: yellow
                       ,darkYellow: darkYellow
                       ,lightGreen: lightGreen
                       ,green: green
                       ,darkGreen: darkGreen
                       ,lightBlue: lightBlue
                       ,blue: blue
                       ,darkBlue: darkBlue
                       ,lightPurple: lightPurple
                       ,purple: purple
                       ,darkPurple: darkPurple
                       ,lightBrown: lightBrown
                       ,brown: brown
                       ,darkBrown: darkBrown
                       ,black: black
                       ,white: white
                       ,lightGrey: lightGrey
                       ,grey: grey
                       ,darkGrey: darkGrey
                       ,lightGray: lightGray
                       ,gray: gray
                       ,darkGray: darkGray
                       ,lightCharcoal: lightCharcoal
                       ,charcoal: charcoal
                       ,darkCharcoal: darkCharcoal};
   return _elm.Color.values;
};
Elm.Core = Elm.Core || {};
Elm.Core.make = function (_elm) {
   "use strict";
   _elm.Core = _elm.Core || {};
   if (_elm.Core.values)
   return _elm.Core.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _P = _N.Ports.make(_elm),
   $moduleName = "Core",
   $Basics = Elm.Basics.make(_elm),
   $List = Elm.List.make(_elm),
   $Maybe = Elm.Maybe.make(_elm),
   $Time = Elm.Time.make(_elm);
   var isNothing = function (m) {
      return function () {
         switch (m.ctor)
         {case "Nothing": return true;}
         return false;
      }();
   };
   var isJust = function (m) {
      return $Basics.not(isNothing(m));
   };
   var find = F2(function (f,
   list) {
      return function () {
         var filtered = A2($List.filter,
         f,
         list);
         return $List.isEmpty(filtered) ? $Maybe.Nothing : $Maybe.Just($List.head(filtered));
      }();
   });
   var average = function (items) {
      return $List.sum(items) / $Basics.toFloat($List.length(items));
   };
   var compact = function (maybes) {
      return function () {
         var folder = F2(function (m,
         list) {
            return function () {
               switch (m.ctor)
               {case "Just":
                  return A2($List._op["::"],
                    m._0,
                    list);
                  case "Nothing": return list;}
               _U.badCase($moduleName,
               "between lines 38 and 41");
            }();
         });
         return A3($List.foldl,
         folder,
         _L.fromArray([]),
         maybes);
      }();
   };
   var getCountdown = function (maybeCountdown) {
      return A2($Maybe.withDefault,
      0,
      maybeCountdown);
   };
   var isStarted = function (maybeCountdown) {
      return $Maybe.withDefault(false)(A2($Maybe.map,
      function (n) {
         return _U.cmp(n,0) < 1;
      },
      maybeCountdown));
   };
   var floatMod = F2(function (val,
   div) {
      return $Basics.toFloat(A2($Basics._op["%"],
      $Basics.floor(val),
      div));
   });
   var mpsToKnts = function (mps) {
      return mps * 3600 / 1.852 / 1000;
   };
   var toRadians = function (deg) {
      return $Basics.radians((90 - deg) * $Basics.pi / 180);
   };
   var getVmgValue = F2(function (windAngle,
   boatSpeed) {
      return function () {
         var windAngleRad = toRadians(windAngle);
         return $Basics.abs($Basics.sin(windAngleRad) * boatSpeed);
      }();
   });
   var ensure360 = function (val) {
      return function () {
         var rounded = $Basics.round(val);
         var excess = val - $Basics.toFloat(rounded);
         return $Basics.toFloat(A2($Basics._op["%"],
         rounded + 360,
         360)) + excess;
      }();
   };
   _elm.Core.values = {_op: _op
                      ,ensure360: ensure360
                      ,toRadians: toRadians
                      ,mpsToKnts: mpsToKnts
                      ,floatMod: floatMod
                      ,getVmgValue: getVmgValue
                      ,isStarted: isStarted
                      ,getCountdown: getCountdown
                      ,compact: compact
                      ,average: average
                      ,find: find
                      ,isNothing: isNothing
                      ,isJust: isJust};
   return _elm.Core.values;
};
Elm.Debug = Elm.Debug || {};
Elm.Debug.make = function (_elm) {
   "use strict";
   _elm.Debug = _elm.Debug || {};
   if (_elm.Debug.values)
   return _elm.Debug.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _P = _N.Ports.make(_elm),
   $moduleName = "Debug",
   $Graphics$Collage = Elm.Graphics.Collage.make(_elm),
   $Native$Debug = Elm.Native.Debug.make(_elm);
   var trace = $Native$Debug.tracePath;
   var watchSummary = $Native$Debug.watchSummary;
   var watch = $Native$Debug.watch;
   var crash = $Native$Debug.crash;
   var log = $Native$Debug.log;
   _elm.Debug.values = {_op: _op
                       ,log: log
                       ,crash: crash
                       ,watch: watch
                       ,watchSummary: watchSummary
                       ,trace: trace};
   return _elm.Debug.values;
};
Elm.Game = Elm.Game || {};
Elm.Game.make = function (_elm) {
   "use strict";
   _elm.Game = _elm.Game || {};
   if (_elm.Game.values)
   return _elm.Game.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _P = _N.Ports.make(_elm),
   $moduleName = "Game",
   $Basics = Elm.Basics.make(_elm),
   $Core = Elm.Core.make(_elm),
   $Geo = Elm.Geo.make(_elm),
   $List = Elm.List.make(_elm),
   $Maybe = Elm.Maybe.make(_elm),
   $Time = Elm.Time.make(_elm);
   var isInProgress = function (_v0) {
      return function () {
         return function () {
            var _v2 = {ctor: "_Tuple2"
                      ,_0: _v0.countdown
                      ,_1: _v0.playerState};
            switch (_v2.ctor)
            {case "_Tuple2":
               switch (_v2._0.ctor)
                 {case "Just":
                    switch (_v2._1.ctor)
                      {case "Just":
                         return _U.cmp(_v2._0._0,
                           0) < 1 && function () {
                              var _v7 = _v2._1._0.nextGate;
                              switch (_v7.ctor)
                              {case "Just": return true;
                                 case "Nothing": return false;}
                              _U.badCase($moduleName,
                              "between lines 196 and 199");
                           }();}
                      break;}
                 break;}
            return false;
         }();
      }();
   };
   var selfWatching = function (_v9) {
      return function () {
         return function () {
            var _v11 = _v9.watchMode;
            switch (_v11.ctor)
            {case "NotWatching":
               return false;
               case "Watching":
               return _U.eq(_v11._0,
                 _v9.playerId);}
            _U.badCase($moduleName,
            "between lines 189 and 191");
         }();
      }();
   };
   var findOpponent = F2(function (opponents,
   id) {
      return function () {
         var filtered = A2($List.filter,
         function (ps) {
            return _U.eq(ps.player.id,
            id);
         },
         opponents);
         return $List.isEmpty(filtered) ? $Maybe.Nothing : $Maybe.Just($List.head(filtered));
      }();
   });
   var areaCenters = function (_v13) {
      return function () {
         return function () {
            var $ = _v13.leftBottom,
            l = $._0,
            b = $._1;
            var $ = _v13.rightTop,
            r = $._0,
            t = $._1;
            var cx = (r + l) / 2;
            var cy = (t + b) / 2;
            return {ctor: "_Tuple2"
                   ,_0: cx
                   ,_1: cy};
         }();
      }();
   };
   var areaDims = function (_v15) {
      return function () {
         return function () {
            var $ = _v15.leftBottom,
            l = $._0,
            b = $._1;
            var $ = _v15.rightTop,
            r = $._0,
            t = $._1;
            return {ctor: "_Tuple2"
                   ,_0: r - l
                   ,_1: t - b};
         }();
      }();
   };
   var findPlayerGhost = F2(function (playerId,
   ghosts) {
      return A2($Core.find,
      function (g) {
         return _U.eq(g.id,playerId);
      },
      ghosts);
   });
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
   var defaultPlayer = {_: {}
                       ,handle: $Maybe.Nothing
                       ,id: ""
                       ,status: $Maybe.Nothing};
   var defaultVmg = {_: {}
                    ,angle: 0
                    ,speed: 0
                    ,value: 0};
   var defaultPlayerState = {_: {}
                            ,controlMode: ""
                            ,crossedGates: _L.fromArray([])
                            ,downwindVmg: defaultVmg
                            ,heading: 0
                            ,nextGate: $Maybe.Nothing
                            ,player: defaultPlayer
                            ,position: {ctor: "_Tuple2"
                                       ,_0: 0
                                       ,_1: 0}
                            ,shadowDirection: 0
                            ,tackTarget: $Maybe.Nothing
                            ,trail: _L.fromArray([])
                            ,upwindVmg: defaultVmg
                            ,velocity: 0
                            ,vmgValue: 0
                            ,windAngle: 0
                            ,windOrigin: 0
                            ,windSpeed: 0};
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
                                       return function (m) {
                                          return function (n) {
                                             return {_: {}
                                                    ,center: e
                                                    ,countdown: k
                                                    ,course: h
                                                    ,gameMode: n
                                                    ,ghosts: g
                                                    ,isMaster: l
                                                    ,leaderboard: i
                                                    ,now: j
                                                    ,opponents: f
                                                    ,playerId: b
                                                    ,playerState: c
                                                    ,wake: d
                                                    ,watchMode: m
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
      };
   };
   var TimeTrial = {ctor: "TimeTrial"};
   var Race = {ctor: "Race"};
   var Watching = function (a) {
      return {ctor: "Watching"
             ,_0: a};
   };
   var NotWatching = {ctor: "NotWatching"};
   var defaultGame = {_: {}
                     ,center: {ctor: "_Tuple2"
                              ,_0: 0
                              ,_1: 0}
                     ,countdown: $Maybe.Nothing
                     ,course: defaultCourse
                     ,gameMode: Race
                     ,ghosts: _L.fromArray([])
                     ,isMaster: false
                     ,leaderboard: _L.fromArray([])
                     ,now: 0
                     ,opponents: _L.fromArray([])
                     ,playerId: ""
                     ,playerState: $Maybe.Nothing
                     ,wake: _L.fromArray([])
                     ,watchMode: NotWatching
                     ,wind: defaultWind};
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
   var GhostState = F5(function (a,
   b,
   c,
   d,
   e) {
      return {_: {}
             ,gates: e
             ,handle: d
             ,heading: b
             ,id: c
             ,position: a};
   });
   var PlayerTally = F3(function (a,
   b,
   c) {
      return {_: {}
             ,gates: c
             ,playerHandle: b
             ,playerId: a};
   });
   var PlayerState = function (a) {
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
                                       return function (m) {
                                          return function (n) {
                                             return function (o) {
                                                return function (p) {
                                                   return {_: {}
                                                          ,controlMode: m
                                                          ,crossedGates: o
                                                          ,downwindVmg: i
                                                          ,heading: c
                                                          ,nextGate: p
                                                          ,player: a
                                                          ,position: b
                                                          ,shadowDirection: k
                                                          ,tackTarget: n
                                                          ,trail: l
                                                          ,upwindVmg: j
                                                          ,velocity: d
                                                          ,vmgValue: e
                                                          ,windAngle: f
                                                          ,windOrigin: g
                                                          ,windSpeed: h};
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
            };
         };
      };
   };
   var Player = F3(function (a,
   b,
   c) {
      return {_: {}
             ,handle: b
             ,id: a
             ,status: c};
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
   var Vmg = F3(function (a,b,c) {
      return {_: {}
             ,angle: a
             ,speed: b
             ,value: c};
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
                      ,Gate: Gate
                      ,Island: Island
                      ,RaceArea: RaceArea
                      ,Vmg: Vmg
                      ,Course: Course
                      ,Player: Player
                      ,PlayerState: PlayerState
                      ,PlayerTally: PlayerTally
                      ,GhostState: GhostState
                      ,Gust: Gust
                      ,Wind: Wind
                      ,NotWatching: NotWatching
                      ,Watching: Watching
                      ,Race: Race
                      ,TimeTrial: TimeTrial
                      ,GameState: GameState
                      ,defaultVmg: defaultVmg
                      ,defaultPlayer: defaultPlayer
                      ,defaultPlayerState: defaultPlayerState
                      ,defaultGate: defaultGate
                      ,defaultCourse: defaultCourse
                      ,defaultWind: defaultWind
                      ,defaultGame: defaultGame
                      ,getGateMarks: getGateMarks
                      ,findPlayerGhost: findPlayerGhost
                      ,areaDims: areaDims
                      ,areaCenters: areaCenters
                      ,findOpponent: findOpponent
                      ,selfWatching: selfWatching
                      ,isInProgress: isInProgress};
   return _elm.Game.values;
};
Elm.Geo = Elm.Geo || {};
Elm.Geo.make = function (_elm) {
   "use strict";
   _elm.Geo = _elm.Geo || {};
   if (_elm.Geo.values)
   return _elm.Geo.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _P = _N.Ports.make(_elm),
   $moduleName = "Geo",
   $Basics = Elm.Basics.make(_elm),
   $Core = Elm.Core.make(_elm),
   $Time = Elm.Time.make(_elm);
   var movePoint = F4(function (_v0,
   delta,
   velocity,
   direction) {
      return function () {
         switch (_v0.ctor)
         {case "_Tuple2":
            return function () {
                 var angle = $Core.toRadians(direction);
                 var x$ = _v0._0 + delta * 1.0e-3 * velocity * $Basics.cos(angle);
                 var y$ = _v0._1 + delta * 1.0e-3 * velocity * $Basics.sin(angle);
                 return {ctor: "_Tuple2"
                        ,_0: x$
                        ,_1: y$};
              }();}
         _U.badCase($moduleName,
         "between lines 38 and 41");
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
         _U.badCase($moduleName,
         "on line 34, column 4 to 42");
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
                           _U.badCase($moduleName,
                           "on line 30, column 3 to 47");
                        }();}
                   break;}
              break;}
         _U.badCase($moduleName,
         "on line 30, column 3 to 47");
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
                    return $Basics.sqrt(Math.pow(_v20._0 - _v21._0,
                      2) + Math.pow(_v20._1 - _v21._1,
                      2));}
                 _U.badCase($moduleName,
                 "on line 26, column 3 to 34");
              }();}
         _U.badCase($moduleName,
         "on line 26, column 3 to 34");
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
         _U.badCase($moduleName,
         "on line 22, column 18 to 26");
      }();
   });
   var neg = function (_v32) {
      return function () {
         switch (_v32.ctor)
         {case "_Tuple2":
            return {ctor: "_Tuple2"
                   ,_0: 0 - _v32._0
                   ,_1: 0 - _v32._1};}
         _U.badCase($moduleName,
         "on line 19, column 14 to 19");
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
                 _U.badCase($moduleName,
                 "on line 16, column 22 to 36");
              }();}
         _U.badCase($moduleName,
         "on line 16, column 22 to 36");
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
                 _U.badCase($moduleName,
                 "on line 13, column 22 to 36");
              }();}
         _U.badCase($moduleName,
         "on line 13, column 22 to 36");
      }();
   });
   var floatify = function (_v52) {
      return function () {
         switch (_v52.ctor)
         {case "_Tuple2":
            return {ctor: "_Tuple2"
                   ,_0: $Basics.toFloat(_v52._0)
                   ,_1: $Basics.toFloat(_v52._1)};}
         _U.badCase($moduleName,
         "on line 10, column 19 to 39");
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
};
Elm.Graphics = Elm.Graphics || {};
Elm.Graphics.Collage = Elm.Graphics.Collage || {};
Elm.Graphics.Collage.make = function (_elm) {
   "use strict";
   _elm.Graphics = _elm.Graphics || {};
   _elm.Graphics.Collage = _elm.Graphics.Collage || {};
   if (_elm.Graphics.Collage.values)
   return _elm.Graphics.Collage.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _P = _N.Ports.make(_elm),
   $moduleName = "Graphics.Collage",
   $Basics = Elm.Basics.make(_elm),
   $Color = Elm.Color.make(_elm),
   $Graphics$Element = Elm.Graphics.Element.make(_elm),
   $List = Elm.List.make(_elm),
   $Native$Graphics$Collage = Elm.Native.Graphics.Collage.make(_elm),
   $Transform2D = Elm.Transform2D.make(_elm);
   var ngon = F2(function (n,r) {
      return function () {
         var m = $Basics.toFloat(n);
         var t = 2 * $Basics.pi / m;
         var f = function (i) {
            return {ctor: "_Tuple2"
                   ,_0: r * $Basics.cos(t * i)
                   ,_1: r * $Basics.sin(t * i)};
         };
         return A2($List.map,
         f,
         _L.range(0,m - 1));
      }();
   });
   var oval = F2(function (w,h) {
      return function () {
         var hh = h / 2;
         var hw = w / 2;
         var n = 50;
         var t = 2 * $Basics.pi / n;
         var f = function (i) {
            return {ctor: "_Tuple2"
                   ,_0: hw * $Basics.cos(t * i)
                   ,_1: hh * $Basics.sin(t * i)};
         };
         return A2($List.map,
         f,
         _L.range(0,n - 1));
      }();
   });
   var circle = function (r) {
      return A2(oval,2 * r,2 * r);
   };
   var rect = F2(function (w,h) {
      return function () {
         var hh = h / 2;
         var hw = w / 2;
         return _L.fromArray([{ctor: "_Tuple2"
                              ,_0: 0 - hw
                              ,_1: 0 - hh}
                             ,{ctor: "_Tuple2"
                              ,_0: 0 - hw
                              ,_1: hh}
                             ,{ctor: "_Tuple2",_0: hw,_1: hh}
                             ,{ctor: "_Tuple2"
                              ,_0: hw
                              ,_1: 0 - hh}]);
      }();
   });
   var square = function (n) {
      return A2(rect,n,n);
   };
   var polygon = function (points) {
      return points;
   };
   var segment = F2(function (p1,
   p2) {
      return _L.fromArray([p1,p2]);
   });
   var path = function (ps) {
      return ps;
   };
   var collage = $Native$Graphics$Collage.collage;
   var alpha = F2(function (a,f) {
      return _U.replace([["alpha"
                         ,a]],
      f);
   });
   var rotate = F2(function (t,f) {
      return _U.replace([["theta"
                         ,f.theta + t]],
      f);
   });
   var scale = F2(function (s,f) {
      return _U.replace([["scale"
                         ,f.scale * s]],
      f);
   });
   var moveY = F2(function (y,f) {
      return _U.replace([["y"
                         ,f.y + y]],
      f);
   });
   var moveX = F2(function (x,f) {
      return _U.replace([["x"
                         ,f.x + x]],
      f);
   });
   var move = F2(function (_v0,f) {
      return function () {
         switch (_v0.ctor)
         {case "_Tuple2":
            return _U.replace([["x"
                               ,f.x + _v0._0]
                              ,["y",f.y + _v0._1]],
              f);}
         _U.badCase($moduleName,
         "on line 174, column 20 to 48");
      }();
   });
   var form = function (f) {
      return {_: {}
             ,alpha: 1
             ,form: f
             ,scale: 1
             ,theta: 0
             ,x: 0
             ,y: 0};
   };
   var Fill = function (a) {
      return {ctor: "Fill",_0: a};
   };
   var Line = function (a) {
      return {ctor: "Line",_0: a};
   };
   var FGroup = F2(function (a,b) {
      return {ctor: "FGroup"
             ,_0: a
             ,_1: b};
   });
   var group = function (fs) {
      return form(A2(FGroup,
      $Transform2D.identity,
      fs));
   };
   var groupTransform = F2(function (matrix,
   fs) {
      return form(A2(FGroup,
      matrix,
      fs));
   });
   var FElement = function (a) {
      return {ctor: "FElement"
             ,_0: a};
   };
   var toForm = function (e) {
      return form(FElement(e));
   };
   var FImage = F4(function (a,
   b,
   c,
   d) {
      return {ctor: "FImage"
             ,_0: a
             ,_1: b
             ,_2: c
             ,_3: d};
   });
   var sprite = F4(function (w,
   h,
   pos,
   src) {
      return form(A4(FImage,
      w,
      h,
      pos,
      src));
   });
   var FShape = F2(function (a,b) {
      return {ctor: "FShape"
             ,_0: a
             ,_1: b};
   });
   var fill = F2(function (style,
   shape) {
      return form(A2(FShape,
      Fill(style),
      shape));
   });
   var outlined = F2(function (style,
   shape) {
      return form(A2(FShape,
      Line(style),
      shape));
   });
   var FPath = F2(function (a,b) {
      return {ctor: "FPath"
             ,_0: a
             ,_1: b};
   });
   var traced = F2(function (style,
   path) {
      return form(A2(FPath,
      style,
      path));
   });
   var LineStyle = F6(function (a,
   b,
   c,
   d,
   e,
   f) {
      return {_: {}
             ,cap: c
             ,color: a
             ,dashOffset: f
             ,dashing: e
             ,join: d
             ,width: b};
   });
   var Clipped = {ctor: "Clipped"};
   var Sharp = function (a) {
      return {ctor: "Sharp",_0: a};
   };
   var Smooth = {ctor: "Smooth"};
   var Padded = {ctor: "Padded"};
   var Round = {ctor: "Round"};
   var Flat = {ctor: "Flat"};
   var defaultLine = {_: {}
                     ,cap: Flat
                     ,color: $Color.black
                     ,dashOffset: 0
                     ,dashing: _L.fromArray([])
                     ,join: Sharp(10)
                     ,width: 1};
   var solid = function (clr) {
      return _U.replace([["color"
                         ,clr]],
      defaultLine);
   };
   var dashed = function (clr) {
      return _U.replace([["color"
                         ,clr]
                        ,["dashing"
                         ,_L.fromArray([8,4])]],
      defaultLine);
   };
   var dotted = function (clr) {
      return _U.replace([["color"
                         ,clr]
                        ,["dashing"
                         ,_L.fromArray([3,3])]],
      defaultLine);
   };
   var Grad = function (a) {
      return {ctor: "Grad",_0: a};
   };
   var gradient = F2(function (grad,
   shape) {
      return A2(fill,
      Grad(grad),
      shape);
   });
   var Texture = function (a) {
      return {ctor: "Texture"
             ,_0: a};
   };
   var textured = F2(function (src,
   shape) {
      return A2(fill,
      Texture(src),
      shape);
   });
   var Solid = function (a) {
      return {ctor: "Solid",_0: a};
   };
   var filled = F2(function (color,
   shape) {
      return A2(fill,
      Solid(color),
      shape);
   });
   var Form = F6(function (a,
   b,
   c,
   d,
   e,
   f) {
      return {_: {}
             ,alpha: e
             ,form: f
             ,scale: b
             ,theta: a
             ,x: c
             ,y: d};
   });
   _elm.Graphics.Collage.values = {_op: _op
                                  ,Form: Form
                                  ,Solid: Solid
                                  ,Texture: Texture
                                  ,Grad: Grad
                                  ,Flat: Flat
                                  ,Round: Round
                                  ,Padded: Padded
                                  ,Smooth: Smooth
                                  ,Sharp: Sharp
                                  ,Clipped: Clipped
                                  ,LineStyle: LineStyle
                                  ,defaultLine: defaultLine
                                  ,solid: solid
                                  ,dashed: dashed
                                  ,dotted: dotted
                                  ,FPath: FPath
                                  ,FShape: FShape
                                  ,FImage: FImage
                                  ,FElement: FElement
                                  ,FGroup: FGroup
                                  ,Line: Line
                                  ,Fill: Fill
                                  ,form: form
                                  ,fill: fill
                                  ,filled: filled
                                  ,textured: textured
                                  ,gradient: gradient
                                  ,outlined: outlined
                                  ,traced: traced
                                  ,sprite: sprite
                                  ,toForm: toForm
                                  ,group: group
                                  ,groupTransform: groupTransform
                                  ,move: move
                                  ,moveX: moveX
                                  ,moveY: moveY
                                  ,scale: scale
                                  ,rotate: rotate
                                  ,alpha: alpha
                                  ,collage: collage
                                  ,path: path
                                  ,segment: segment
                                  ,polygon: polygon
                                  ,rect: rect
                                  ,square: square
                                  ,oval: oval
                                  ,circle: circle
                                  ,ngon: ngon};
   return _elm.Graphics.Collage.values;
};
Elm.Graphics = Elm.Graphics || {};
Elm.Graphics.Element = Elm.Graphics.Element || {};
Elm.Graphics.Element.make = function (_elm) {
   "use strict";
   _elm.Graphics = _elm.Graphics || {};
   _elm.Graphics.Element = _elm.Graphics.Element || {};
   if (_elm.Graphics.Element.values)
   return _elm.Graphics.Element.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _P = _N.Ports.make(_elm),
   $moduleName = "Graphics.Element",
   $Basics = Elm.Basics.make(_elm),
   $Color = Elm.Color.make(_elm),
   $List = Elm.List.make(_elm),
   $Maybe = Elm.Maybe.make(_elm),
   $Native$Graphics$Element = Elm.Native.Graphics.Element.make(_elm);
   var DOut = {ctor: "DOut"};
   var outward = DOut;
   var DIn = {ctor: "DIn"};
   var inward = DIn;
   var DRight = {ctor: "DRight"};
   var right = DRight;
   var DLeft = {ctor: "DLeft"};
   var left = DLeft;
   var DDown = {ctor: "DDown"};
   var down = DDown;
   var DUp = {ctor: "DUp"};
   var up = DUp;
   var Position = F4(function (a,
   b,
   c,
   d) {
      return {_: {}
             ,horizontal: a
             ,vertical: b
             ,x: c
             ,y: d};
   });
   var Relative = function (a) {
      return {ctor: "Relative"
             ,_0: a};
   };
   var relative = Relative;
   var Absolute = function (a) {
      return {ctor: "Absolute"
             ,_0: a};
   };
   var absolute = Absolute;
   var N = {ctor: "N"};
   var bottomLeftAt = F2(function (x,
   y) {
      return {_: {}
             ,horizontal: N
             ,vertical: N
             ,x: x
             ,y: y};
   });
   var Z = {ctor: "Z"};
   var middle = {_: {}
                ,horizontal: Z
                ,vertical: Z
                ,x: Relative(0.5)
                ,y: Relative(0.5)};
   var midLeft = _U.replace([["horizontal"
                             ,N]
                            ,["x",Absolute(0)]],
   middle);
   var middleAt = F2(function (x,
   y) {
      return {_: {}
             ,horizontal: Z
             ,vertical: Z
             ,x: x
             ,y: y};
   });
   var midLeftAt = F2(function (x,
   y) {
      return {_: {}
             ,horizontal: N
             ,vertical: Z
             ,x: x
             ,y: y};
   });
   var midBottomAt = F2(function (x,
   y) {
      return {_: {}
             ,horizontal: Z
             ,vertical: N
             ,x: x
             ,y: y};
   });
   var P = {ctor: "P"};
   var topLeft = {_: {}
                 ,horizontal: N
                 ,vertical: P
                 ,x: Absolute(0)
                 ,y: Absolute(0)};
   var bottomLeft = _U.replace([["vertical"
                                ,N]],
   topLeft);
   var topRight = _U.replace([["horizontal"
                              ,P]],
   topLeft);
   var bottomRight = _U.replace([["horizontal"
                                 ,P]],
   bottomLeft);
   var midRight = _U.replace([["horizontal"
                              ,P]],
   midLeft);
   var midTop = _U.replace([["vertical"
                            ,P]
                           ,["y",Absolute(0)]],
   middle);
   var midBottom = _U.replace([["vertical"
                               ,N]],
   midTop);
   var topLeftAt = F2(function (x,
   y) {
      return {_: {}
             ,horizontal: N
             ,vertical: P
             ,x: x
             ,y: y};
   });
   var topRightAt = F2(function (x,
   y) {
      return {_: {}
             ,horizontal: P
             ,vertical: P
             ,x: x
             ,y: y};
   });
   var bottomRightAt = F2(function (x,
   y) {
      return {_: {}
             ,horizontal: P
             ,vertical: N
             ,x: x
             ,y: y};
   });
   var midRightAt = F2(function (x,
   y) {
      return {_: {}
             ,horizontal: P
             ,vertical: Z
             ,x: x
             ,y: y};
   });
   var midTopAt = F2(function (x,
   y) {
      return {_: {}
             ,horizontal: Z
             ,vertical: P
             ,x: x
             ,y: y};
   });
   var Tiled = {ctor: "Tiled"};
   var Cropped = function (a) {
      return {ctor: "Cropped"
             ,_0: a};
   };
   var Fitted = {ctor: "Fitted"};
   var Plain = {ctor: "Plain"};
   var Custom = {ctor: "Custom"};
   var RawHtml = {ctor: "RawHtml"};
   var Spacer = {ctor: "Spacer"};
   var Flow = F2(function (a,b) {
      return {ctor: "Flow"
             ,_0: a
             ,_1: b};
   });
   var Container = F2(function (a,
   b) {
      return {ctor: "Container"
             ,_0: a
             ,_1: b};
   });
   var Image = F4(function (a,
   b,
   c,
   d) {
      return {ctor: "Image"
             ,_0: a
             ,_1: b
             ,_2: c
             ,_3: d};
   });
   var link = F2(function (href,
   e) {
      return function () {
         var p = e.props;
         return {_: {}
                ,element: e.element
                ,props: _U.replace([["href"
                                    ,href]],
                p)};
      }();
   });
   var tag = F2(function (name,e) {
      return function () {
         var p = e.props;
         return {_: {}
                ,element: e.element
                ,props: _U.replace([["tag"
                                    ,name]],
                p)};
      }();
   });
   var color = F2(function (c,e) {
      return function () {
         var p = e.props;
         return {_: {}
                ,element: e.element
                ,props: _U.replace([["color"
                                    ,$Maybe.Just(c)]],
                p)};
      }();
   });
   var opacity = F2(function (o,
   e) {
      return function () {
         var p = e.props;
         return {_: {}
                ,element: e.element
                ,props: _U.replace([["opacity"
                                    ,o]],
                p)};
      }();
   });
   var height = F2(function (nh,
   e) {
      return function () {
         var p = e.props;
         var props = function () {
            var _v0 = e.element;
            switch (_v0.ctor)
            {case "Image":
               return _U.replace([["width"
                                  ,$Basics.round($Basics.toFloat(_v0._1) / $Basics.toFloat(_v0._2) * $Basics.toFloat(nh))]],
                 p);}
            return p;
         }();
         return {_: {}
                ,element: e.element
                ,props: _U.replace([["height"
                                    ,nh]],
                p)};
      }();
   });
   var width = F2(function (nw,e) {
      return function () {
         var p = e.props;
         var props = function () {
            var _v5 = e.element;
            switch (_v5.ctor)
            {case "Image":
               return _U.replace([["height"
                                  ,$Basics.round($Basics.toFloat(_v5._2) / $Basics.toFloat(_v5._1) * $Basics.toFloat(nw))]],
                 p);
               case "RawHtml":
               return _U.replace([["height"
                                  ,$Basics.snd(A2($Native$Graphics$Element.htmlHeight,
                                  nw,
                                  e.element))]],
                 p);}
            return p;
         }();
         return {_: {}
                ,element: e.element
                ,props: _U.replace([["width"
                                    ,nw]],
                props)};
      }();
   });
   var size = F3(function (w,h,e) {
      return A2(height,
      h,
      A2(width,w,e));
   });
   var sizeOf = function (e) {
      return {ctor: "_Tuple2"
             ,_0: e.props.width
             ,_1: e.props.height};
   };
   var heightOf = function (e) {
      return e.props.height;
   };
   var widthOf = function (e) {
      return e.props.width;
   };
   var Element = F2(function (a,
   b) {
      return {_: {}
             ,element: b
             ,props: a};
   });
   var Properties = F9(function (a,
   b,
   c,
   d,
   e,
   f,
   g,
   h,
   i) {
      return {_: {}
             ,click: i
             ,color: e
             ,height: c
             ,hover: h
             ,href: f
             ,id: a
             ,opacity: d
             ,tag: g
             ,width: b};
   });
   var newElement = F3(function (w,
   h,
   e) {
      return {_: {}
             ,element: e
             ,props: A9(Properties,
             $Native$Graphics$Element.guid({ctor: "_Tuple0"}),
             w,
             h,
             1,
             $Maybe.Nothing,
             "",
             "",
             {ctor: "_Tuple0"},
             {ctor: "_Tuple0"})};
   });
   var image = F3(function (w,
   h,
   src) {
      return A3(newElement,
      w,
      h,
      A4(Image,Plain,w,h,src));
   });
   var fittedImage = F3(function (w,
   h,
   src) {
      return A3(newElement,
      w,
      h,
      A4(Image,Fitted,w,h,src));
   });
   var croppedImage = F4(function (pos,
   w,
   h,
   src) {
      return A3(newElement,
      w,
      h,
      A4(Image,Cropped(pos),w,h,src));
   });
   var tiledImage = F3(function (w,
   h,
   src) {
      return A3(newElement,
      w,
      h,
      A4(Image,Tiled,w,h,src));
   });
   var container = F4(function (w,
   h,
   pos,
   e) {
      return A3(newElement,
      w,
      h,
      A2(Container,pos,e));
   });
   var spacer = F2(function (w,h) {
      return A3(newElement,
      w,
      h,
      Spacer);
   });
   var empty = A2(spacer,0,0);
   var flow = F2(function (dir,
   es) {
      return function () {
         var newFlow = F2(function (w,
         h) {
            return A3(newElement,
            w,
            h,
            A2(Flow,dir,es));
         });
         var hs = A2($List.map,
         heightOf,
         es);
         var ws = A2($List.map,
         widthOf,
         es);
         return _U.eq(es,
         _L.fromArray([])) ? empty : function () {
            switch (dir.ctor)
            {case "DDown":
               return A2(newFlow,
                 $List.maximum(ws),
                 $List.sum(hs));
               case "DIn": return A2(newFlow,
                 $List.maximum(ws),
                 $List.maximum(hs));
               case "DLeft": return A2(newFlow,
                 $List.sum(ws),
                 $List.maximum(hs));
               case "DOut": return A2(newFlow,
                 $List.maximum(ws),
                 $List.maximum(hs));
               case "DRight":
               return A2(newFlow,
                 $List.sum(ws),
                 $List.maximum(hs));
               case "DUp": return A2(newFlow,
                 $List.maximum(ws),
                 $List.sum(hs));}
            _U.badCase($moduleName,
            "between lines 280 and 291");
         }();
      }();
   });
   var above = F2(function (hi,
   lo) {
      return A3(newElement,
      A2($Basics.max,
      widthOf(hi),
      widthOf(lo)),
      heightOf(hi) + heightOf(lo),
      A2(Flow,
      DDown,
      _L.fromArray([hi,lo])));
   });
   var below = F2(function (lo,
   hi) {
      return A3(newElement,
      A2($Basics.max,
      widthOf(hi),
      widthOf(lo)),
      heightOf(hi) + heightOf(lo),
      A2(Flow,
      DDown,
      _L.fromArray([hi,lo])));
   });
   var beside = F2(function (lft,
   rht) {
      return A3(newElement,
      widthOf(lft) + widthOf(rht),
      A2($Basics.max,
      heightOf(lft),
      heightOf(rht)),
      A2(Flow,
      right,
      _L.fromArray([lft,rht])));
   });
   var layers = function (es) {
      return function () {
         var hs = A2($List.map,
         heightOf,
         es);
         var ws = A2($List.map,
         widthOf,
         es);
         return A3(newElement,
         $List.maximum(ws),
         $List.maximum(hs),
         A2(Flow,DOut,es));
      }();
   };
   _elm.Graphics.Element.values = {_op: _op
                                  ,Properties: Properties
                                  ,Element: Element
                                  ,empty: empty
                                  ,widthOf: widthOf
                                  ,heightOf: heightOf
                                  ,sizeOf: sizeOf
                                  ,width: width
                                  ,height: height
                                  ,size: size
                                  ,opacity: opacity
                                  ,color: color
                                  ,tag: tag
                                  ,link: link
                                  ,newElement: newElement
                                  ,Image: Image
                                  ,Container: Container
                                  ,Flow: Flow
                                  ,Spacer: Spacer
                                  ,RawHtml: RawHtml
                                  ,Custom: Custom
                                  ,Plain: Plain
                                  ,Fitted: Fitted
                                  ,Cropped: Cropped
                                  ,Tiled: Tiled
                                  ,image: image
                                  ,fittedImage: fittedImage
                                  ,croppedImage: croppedImage
                                  ,tiledImage: tiledImage
                                  ,P: P
                                  ,Z: Z
                                  ,N: N
                                  ,Absolute: Absolute
                                  ,Relative: Relative
                                  ,Position: Position
                                  ,container: container
                                  ,spacer: spacer
                                  ,DUp: DUp
                                  ,DDown: DDown
                                  ,DLeft: DLeft
                                  ,DRight: DRight
                                  ,DIn: DIn
                                  ,DOut: DOut
                                  ,flow: flow
                                  ,above: above
                                  ,below: below
                                  ,beside: beside
                                  ,layers: layers
                                  ,absolute: absolute
                                  ,relative: relative
                                  ,middle: middle
                                  ,topLeft: topLeft
                                  ,topRight: topRight
                                  ,bottomLeft: bottomLeft
                                  ,bottomRight: bottomRight
                                  ,midLeft: midLeft
                                  ,midRight: midRight
                                  ,midTop: midTop
                                  ,midBottom: midBottom
                                  ,middleAt: middleAt
                                  ,topLeftAt: topLeftAt
                                  ,topRightAt: topRightAt
                                  ,bottomLeftAt: bottomLeftAt
                                  ,bottomRightAt: bottomRightAt
                                  ,midLeftAt: midLeftAt
                                  ,midRightAt: midRightAt
                                  ,midTopAt: midTopAt
                                  ,midBottomAt: midBottomAt
                                  ,up: up
                                  ,down: down
                                  ,left: left
                                  ,right: right
                                  ,inward: inward
                                  ,outward: outward};
   return _elm.Graphics.Element.values;
};
Elm.Graphics = Elm.Graphics || {};
Elm.Graphics.Input = Elm.Graphics.Input || {};
Elm.Graphics.Input.make = function (_elm) {
   "use strict";
   _elm.Graphics = _elm.Graphics || {};
   _elm.Graphics.Input = _elm.Graphics.Input || {};
   if (_elm.Graphics.Input.values)
   return _elm.Graphics.Input.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _P = _N.Ports.make(_elm),
   $moduleName = "Graphics.Input",
   $Graphics$Element = Elm.Graphics.Element.make(_elm),
   $Native$Graphics$Input = Elm.Native.Graphics.Input.make(_elm),
   $Signal = Elm.Signal.make(_elm);
   var clickable = $Native$Graphics$Input.clickable;
   var hoverable = $Native$Graphics$Input.hoverable;
   var dropDown = $Native$Graphics$Input.dropDown;
   var checkbox = $Native$Graphics$Input.checkbox;
   var customButton = $Native$Graphics$Input.customButton;
   var button = $Native$Graphics$Input.button;
   _elm.Graphics.Input.values = {_op: _op
                                ,button: button
                                ,customButton: customButton
                                ,checkbox: checkbox
                                ,dropDown: dropDown
                                ,hoverable: hoverable
                                ,clickable: clickable};
   return _elm.Graphics.Input.values;
};
Elm.Inputs = Elm.Inputs || {};
Elm.Inputs.make = function (_elm) {
   "use strict";
   _elm.Inputs = _elm.Inputs || {};
   if (_elm.Inputs.values)
   return _elm.Inputs.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _P = _N.Ports.make(_elm),
   $moduleName = "Inputs",
   $Char = Elm.Char.make(_elm),
   $Game = Elm.Game.make(_elm),
   $Keyboard = Elm.Keyboard.make(_elm),
   $Maybe = Elm.Maybe.make(_elm),
   $Signal = Elm.Signal.make(_elm),
   $Time = Elm.Time.make(_elm);
   var GameInput = F5(function (a,
   b,
   c,
   d,
   e) {
      return {_: {}
             ,delta: a
             ,keyboardInput: b
             ,raceInput: d
             ,watcherInput: e
             ,windowInput: c};
   });
   var WatcherInput = function (a) {
      return {_: {}
             ,watchedPlayerId: a};
   };
   var watchedPlayer = $Signal.channel($Maybe.Nothing);
   var watcherInput = A2($Signal._op["<~"],
   WatcherInput,
   $Signal.subscribe(watchedPlayer));
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
                                 return function (k) {
                                    return function (l) {
                                       return {_: {}
                                              ,course: d
                                              ,ghosts: h
                                              ,isMaster: j
                                              ,leaderboard: i
                                              ,now: b
                                              ,opponents: g
                                              ,playerId: a
                                              ,playerState: e
                                              ,startTime: c
                                              ,timeTrial: l
                                              ,watching: k
                                              ,wind: f};
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
   var KeyboardInput = F5(function (a,
   b,
   c,
   d,
   e) {
      return {_: {}
             ,arrows: a
             ,lock: b
             ,startCountdown: e
             ,subtleTurn: d
             ,tack: c};
   });
   var keyboardInput = A6($Signal.map5,
   KeyboardInput,
   $Keyboard.arrows,
   $Keyboard.enter,
   $Keyboard.space,
   $Keyboard.shift,
   $Keyboard.isDown($Char.toCode(_U.chr("C"))));
   var UserArrows = F2(function (a,
   b) {
      return {_: {},x: a,y: b};
   });
   _elm.Inputs.values = {_op: _op
                        ,UserArrows: UserArrows
                        ,KeyboardInput: KeyboardInput
                        ,RaceInput: RaceInput
                        ,keyboardInput: keyboardInput
                        ,watchedPlayer: watchedPlayer
                        ,WatcherInput: WatcherInput
                        ,watcherInput: watcherInput
                        ,GameInput: GameInput};
   return _elm.Inputs.values;
};
Elm.Keyboard = Elm.Keyboard || {};
Elm.Keyboard.make = function (_elm) {
   "use strict";
   _elm.Keyboard = _elm.Keyboard || {};
   if (_elm.Keyboard.values)
   return _elm.Keyboard.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _P = _N.Ports.make(_elm),
   $moduleName = "Keyboard",
   $Native$Keyboard = Elm.Native.Keyboard.make(_elm),
   $Signal = Elm.Signal.make(_elm);
   var lastPressed = $Native$Keyboard.lastPressed;
   var keysDown = $Native$Keyboard.keysDown;
   var meta = $Native$Keyboard.meta;
   var alt = $Native$Keyboard.alt;
   var isDown = $Native$Keyboard.isDown;
   var ctrl = isDown(17);
   var shift = isDown(16);
   var space = isDown(32);
   var enter = isDown(13);
   var directions = $Native$Keyboard.directions;
   var arrows = A4(directions,
   38,
   40,
   37,
   39);
   var wasd = A4(directions,
   87,
   83,
   65,
   68);
   _elm.Keyboard.values = {_op: _op
                          ,directions: directions
                          ,arrows: arrows
                          ,wasd: wasd
                          ,isDown: isDown
                          ,alt: alt
                          ,ctrl: ctrl
                          ,meta: meta
                          ,shift: shift
                          ,space: space
                          ,enter: enter
                          ,keysDown: keysDown
                          ,lastPressed: lastPressed};
   return _elm.Keyboard.values;
};
Elm.Layout = Elm.Layout || {};
Elm.Layout.make = function (_elm) {
   "use strict";
   _elm.Layout = _elm.Layout || {};
   if (_elm.Layout.values)
   return _elm.Layout.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _P = _N.Ports.make(_elm),
   $moduleName = "Layout",
   $Basics = Elm.Basics.make(_elm),
   $Graphics$Collage = Elm.Graphics.Collage.make(_elm),
   $Graphics$Element = Elm.Graphics.Element.make(_elm),
   $List = Elm.List.make(_elm);
   var centerElements = function (elements) {
      return function () {
         var maxWidth = $List.maximum(A2($List.map,
         $Graphics$Element.widthOf,
         elements));
         return A2($List.map,
         function (e) {
            return A4($Graphics$Element.container,
            maxWidth,
            $Graphics$Element.heightOf(e),
            $Graphics$Element.midTop,
            e);
         },
         elements);
      }();
   };
   var assembleDashboardLayout = F2(function (_v0,
   _v1) {
      return function () {
         return function () {
            switch (_v0.ctor)
            {case "_Tuple2":
               return _L.fromArray([A3($Graphics$Element.container,
                                   _v0._0,
                                   _v0._1,
                                   A2($Graphics$Element.topLeftAt,
                                   $Graphics$Element.Absolute(20),
                                   $Graphics$Element.Absolute(20)))(A2($Graphics$Element.flow,
                                   $Graphics$Element.down,
                                   _v1.topLeft))
                                   ,A3($Graphics$Element.container,
                                   _v0._0,
                                   _v0._1,
                                   A2($Graphics$Element.midTopAt,
                                   $Graphics$Element.Relative(0.5),
                                   $Graphics$Element.Absolute(20)))(A2($Graphics$Element.flow,
                                   $Graphics$Element.down,
                                   centerElements(_v1.topCenter)))
                                   ,A3($Graphics$Element.container,
                                   _v0._0,
                                   _v0._1,
                                   A2($Graphics$Element.topRightAt,
                                   $Graphics$Element.Absolute(20),
                                   $Graphics$Element.Absolute(20)))(A2($Graphics$Element.flow,
                                   $Graphics$Element.down,
                                   _v1.topRight))]);}
            _U.badCase($moduleName,
            "between lines 29 and 32");
         }();
      }();
   });
   var assembleLayout = F3(function (_v6,
   _v7,
   _v8) {
      return function () {
         return function () {
            switch (_v7.ctor)
            {case "_Tuple2":
               return function () {
                    switch (_v6.ctor)
                    {case "_Tuple2":
                       return function () {
                            var dashboardElements = A2(assembleDashboardLayout,
                            {ctor: "_Tuple2"
                            ,_0: _v6._0
                            ,_1: _v6._1},
                            _v8.dashboard);
                            var absStackElements = A3($Graphics$Collage.collage,
                            _v6._0,
                            _v6._1,
                            _v8.absStack);
                            var relStackElements = A3($Graphics$Collage.collage,
                            _v6._0,
                            _v6._1,
                            A2($List.map,
                            $Graphics$Collage.move({ctor: "_Tuple2"
                                                   ,_0: 0 - _v7._0
                                                   ,_1: 0 - _v7._1}),
                            _v8.relStack));
                            return $Graphics$Element.layers(A2($List.append,
                            _L.fromArray([relStackElements
                                         ,absStackElements]),
                            dashboardElements));
                         }();}
                    _U.badCase($moduleName,
                    "between lines 36 and 41");
                 }();}
            _U.badCase($moduleName,
            "between lines 36 and 41");
         }();
      }();
   });
   var Layout = F3(function (a,
   b,
   c) {
      return {_: {}
             ,absStack: c
             ,dashboard: a
             ,relStack: b};
   });
   var DashboardLayout = F4(function (a,
   b,
   c,
   d) {
      return {_: {}
             ,bottomCenter: d
             ,topCenter: c
             ,topLeft: a
             ,topRight: b};
   });
   _elm.Layout.values = {_op: _op
                        ,DashboardLayout: DashboardLayout
                        ,Layout: Layout
                        ,centerElements: centerElements
                        ,assembleDashboardLayout: assembleDashboardLayout
                        ,assembleLayout: assembleLayout};
   return _elm.Layout.values;
};
Elm.List = Elm.List || {};
Elm.List.make = function (_elm) {
   "use strict";
   _elm.List = _elm.List || {};
   if (_elm.List.values)
   return _elm.List.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _P = _N.Ports.make(_elm),
   $moduleName = "List",
   $Basics = Elm.Basics.make(_elm),
   $Maybe = Elm.Maybe.make(_elm),
   $Native$List = Elm.Native.List.make(_elm);
   var sortWith = $Native$List.sortWith;
   var sortBy = $Native$List.sortBy;
   var sort = $Native$List.sort;
   var repeat = $Native$List.repeat;
   var drop = $Native$List.drop;
   var take = $Native$List.take;
   var map5 = $Native$List.map5;
   var map4 = $Native$List.map4;
   var map3 = $Native$List.map3;
   var map2 = $Native$List.map2;
   var append = $Native$List.append;
   var any = $Native$List.any;
   var all = $Native$List.all;
   var reverse = $Native$List.reverse;
   var length = $Native$List.length;
   var filter = $Native$List.filter;
   var scanl1 = $Native$List.scanl1;
   var scanl = $Native$List.scanl;
   var foldr1 = $Native$List.foldr1;
   var foldl1 = $Native$List.foldl1;
   var maximum = foldl1($Basics.max);
   var minimum = foldl1($Basics.min);
   var foldr = $Native$List.foldr;
   var concat = function (lists) {
      return A3(foldr,
      append,
      _L.fromArray([]),
      lists);
   };
   var foldl = $Native$List.foldl;
   var sum = function (numbers) {
      return A3(foldl,
      F2(function (x,y) {
         return x + y;
      }),
      0,
      numbers);
   };
   var product = function (numbers) {
      return A3(foldl,
      F2(function (x,y) {
         return x * y;
      }),
      1,
      numbers);
   };
   var indexedMap = F2(function (f,
   xs) {
      return A3(map2,
      f,
      _L.range(0,length(xs) - 1),
      xs);
   });
   var map = $Native$List.map;
   var concatMap = F2(function (f,
   list) {
      return concat(A2(map,
      f,
      list));
   });
   var member = $Native$List.member;
   var isEmpty = function (xs) {
      return function () {
         switch (xs.ctor)
         {case "[]": return true;}
         return false;
      }();
   };
   var tail = $Native$List.tail;
   var head = $Native$List.head;
   _op["::"] = $Native$List.cons;
   var maybeCons = F3(function (f,
   mx,
   xs) {
      return function () {
         var _v1 = f(mx);
         switch (_v1.ctor)
         {case "Just":
            return A2(_op["::"],_v1._0,xs);
            case "Nothing": return xs;}
         _U.badCase($moduleName,
         "between lines 162 and 169");
      }();
   });
   var filterMap = F2(function (f,
   xs) {
      return A3(foldr,
      maybeCons(f),
      _L.fromArray([]),
      xs);
   });
   var partition = F2(function (pred,
   list) {
      return function () {
         var step = F2(function (x,
         _v3) {
            return function () {
               switch (_v3.ctor)
               {case "_Tuple2":
                  return pred(x) ? {ctor: "_Tuple2"
                                   ,_0: A2(_op["::"],x,_v3._0)
                                   ,_1: _v3._1} : {ctor: "_Tuple2"
                                                  ,_0: _v3._0
                                                  ,_1: A2(_op["::"],x,_v3._1)};}
               _U.badCase($moduleName,
               "between lines 270 and 272");
            }();
         });
         return A3(foldr,
         step,
         {ctor: "_Tuple2"
         ,_0: _L.fromArray([])
         ,_1: _L.fromArray([])},
         list);
      }();
   });
   var unzip = function (pairs) {
      return function () {
         var step = F2(function (_v7,
         _v8) {
            return function () {
               switch (_v8.ctor)
               {case "_Tuple2":
                  return function () {
                       switch (_v7.ctor)
                       {case "_Tuple2":
                          return {ctor: "_Tuple2"
                                 ,_0: A2(_op["::"],_v7._0,_v8._0)
                                 ,_1: A2(_op["::"],
                                 _v7._1,
                                 _v8._1)};}
                       _U.badCase($moduleName,
                       "on line 308, column 12 to 28");
                    }();}
               _U.badCase($moduleName,
               "on line 308, column 12 to 28");
            }();
         });
         return A3(foldr,
         step,
         {ctor: "_Tuple2"
         ,_0: _L.fromArray([])
         ,_1: _L.fromArray([])},
         pairs);
      }();
   };
   var intersperse = F2(function (sep,
   xs) {
      return function () {
         switch (xs.ctor)
         {case "::": return function () {
                 var step = F2(function (x,
                 rest) {
                    return A2(_op["::"],
                    sep,
                    A2(_op["::"],x,rest));
                 });
                 var spersed = A3(foldr,
                 step,
                 _L.fromArray([]),
                 xs._1);
                 return A2(_op["::"],
                 xs._0,
                 spersed);
              }();
            case "[]":
            return _L.fromArray([]);}
         _U.badCase($moduleName,
         "between lines 319 and 330");
      }();
   });
   _elm.List.values = {_op: _op
                      ,head: head
                      ,tail: tail
                      ,isEmpty: isEmpty
                      ,member: member
                      ,map: map
                      ,indexedMap: indexedMap
                      ,foldl: foldl
                      ,foldr: foldr
                      ,foldl1: foldl1
                      ,foldr1: foldr1
                      ,scanl: scanl
                      ,scanl1: scanl1
                      ,filter: filter
                      ,filterMap: filterMap
                      ,maybeCons: maybeCons
                      ,length: length
                      ,reverse: reverse
                      ,all: all
                      ,any: any
                      ,append: append
                      ,concat: concat
                      ,concatMap: concatMap
                      ,sum: sum
                      ,product: product
                      ,maximum: maximum
                      ,minimum: minimum
                      ,partition: partition
                      ,map2: map2
                      ,map3: map3
                      ,map4: map4
                      ,map5: map5
                      ,unzip: unzip
                      ,intersperse: intersperse
                      ,take: take
                      ,drop: drop
                      ,repeat: repeat
                      ,sort: sort
                      ,sortBy: sortBy
                      ,sortWith: sortWith};
   return _elm.List.values;
};
Elm.Main = Elm.Main || {};
Elm.Main.make = function (_elm) {
   "use strict";
   _elm.Main = _elm.Main || {};
   if (_elm.Main.values)
   return _elm.Main.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _P = _N.Ports.make(_elm),
   $moduleName = "Main",
   $Basics = Elm.Basics.make(_elm),
   $Game = Elm.Game.make(_elm),
   $Graphics$Element = Elm.Graphics.Element.make(_elm),
   $Inputs = Elm.Inputs.make(_elm),
   $Render$All = Elm.Render.All.make(_elm),
   $Render$Utils = Elm.Render.Utils.make(_elm),
   $Signal = Elm.Signal.make(_elm),
   $Steps = Elm.Steps.make(_elm),
   $Time = Elm.Time.make(_elm),
   $Window = Elm.Window.make(_elm);
   var clock = A2($Signal._op["<~"],
   $Time.inSeconds,
   $Time.fps(30));
   var raceInput = _P.portIn("raceInput",
   _P.incomingSignal(function (v) {
      return typeof v === "object" && "playerId" in v && "now" in v && "startTime" in v && "course" in v && "playerState" in v && "wind" in v && "opponents" in v && "ghosts" in v && "leaderboard" in v && "isMaster" in v && "watching" in v && "timeTrial" in v ? {_: {}
                                                                                                                                                                                                                                                                     ,playerId: typeof v.playerId === "string" || typeof v.playerId === "object" && v.playerId instanceof String ? v.playerId : _U.badPort("a string",
                                                                                                                                                                                                                                                                     v.playerId)
                                                                                                                                                                                                                                                                     ,now: typeof v.now === "number" ? v.now : _U.badPort("a number",
                                                                                                                                                                                                                                                                     v.now)
                                                                                                                                                                                                                                                                     ,startTime: v.startTime === null ? Elm.Maybe.make(_elm).Nothing : Elm.Maybe.make(_elm).Just(typeof v.startTime === "number" ? v.startTime : _U.badPort("a number",
                                                                                                                                                                                                                                                                     v.startTime))
                                                                                                                                                                                                                                                                     ,course: v.course === null ? Elm.Maybe.make(_elm).Nothing : Elm.Maybe.make(_elm).Just(typeof v.course === "object" && "upwind" in v.course && "downwind" in v.course && "laps" in v.course && "markRadius" in v.course && "islands" in v.course && "area" in v.course && "windShadowLength" in v.course && "boatWidth" in v.course ? {_: {}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          ,upwind: typeof v.course.upwind === "object" && "y" in v.course.upwind && "width" in v.course.upwind ? {_: {}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 ,y: typeof v.course.upwind.y === "number" ? v.course.upwind.y : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 v.course.upwind.y)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 ,width: typeof v.course.upwind.width === "number" ? v.course.upwind.width : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 v.course.upwind.width)} : _U.badPort("an object with fields \'y\', \'width\'",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          v.course.upwind)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          ,downwind: typeof v.course.downwind === "object" && "y" in v.course.downwind && "width" in v.course.downwind ? {_: {}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         ,y: typeof v.course.downwind.y === "number" ? v.course.downwind.y : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         v.course.downwind.y)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         ,width: typeof v.course.downwind.width === "number" ? v.course.downwind.width : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         v.course.downwind.width)} : _U.badPort("an object with fields \'y\', \'width\'",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          v.course.downwind)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          ,laps: typeof v.course.laps === "number" ? v.course.laps : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          v.course.laps)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          ,markRadius: typeof v.course.markRadius === "number" ? v.course.markRadius : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          v.course.markRadius)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          ,islands: typeof v.course.islands === "object" && v.course.islands instanceof Array ? Elm.Native.List.make(_elm).fromArray(v.course.islands.map(function (v) {
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             return typeof v === "object" && "location" in v && "radius" in v ? {_: {}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                ,location: typeof v.location === "object" && v.location instanceof Array ? {ctor: "_Tuple2"
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           ,_0: typeof v.location[0] === "number" ? v.location[0] : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           v.location[0])
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           ,_1: typeof v.location[1] === "number" ? v.location[1] : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           v.location[1])} : _U.badPort("an array",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                v.location)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                ,radius: typeof v.radius === "number" ? v.radius : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                v.radius)} : _U.badPort("an object with fields \'location\', \'radius\'",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             v);
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          })) : _U.badPort("an array",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          v.course.islands)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          ,area: typeof v.course.area === "object" && "rightTop" in v.course.area && "leftBottom" in v.course.area ? {_: {}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     ,rightTop: typeof v.course.area.rightTop === "object" && v.course.area.rightTop instanceof Array ? {ctor: "_Tuple2"
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        ,_0: typeof v.course.area.rightTop[0] === "number" ? v.course.area.rightTop[0] : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        v.course.area.rightTop[0])
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        ,_1: typeof v.course.area.rightTop[1] === "number" ? v.course.area.rightTop[1] : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        v.course.area.rightTop[1])} : _U.badPort("an array",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     v.course.area.rightTop)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     ,leftBottom: typeof v.course.area.leftBottom === "object" && v.course.area.leftBottom instanceof Array ? {ctor: "_Tuple2"
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ,_0: typeof v.course.area.leftBottom[0] === "number" ? v.course.area.leftBottom[0] : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              v.course.area.leftBottom[0])
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ,_1: typeof v.course.area.leftBottom[1] === "number" ? v.course.area.leftBottom[1] : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              v.course.area.leftBottom[1])} : _U.badPort("an array",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     v.course.area.leftBottom)} : _U.badPort("an object with fields \'rightTop\', \'leftBottom\'",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          v.course.area)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          ,windShadowLength: typeof v.course.windShadowLength === "number" ? v.course.windShadowLength : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          v.course.windShadowLength)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          ,boatWidth: typeof v.course.boatWidth === "number" ? v.course.boatWidth : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          v.course.boatWidth)} : _U.badPort("an object with fields \'upwind\', \'downwind\', \'laps\', \'markRadius\', \'islands\', \'area\', \'windShadowLength\', \'boatWidth\'",
                                                                                                                                                                                                                                                                     v.course))
                                                                                                                                                                                                                                                                     ,playerState: v.playerState === null ? Elm.Maybe.make(_elm).Nothing : Elm.Maybe.make(_elm).Just(typeof v.playerState === "object" && "player" in v.playerState && "position" in v.playerState && "heading" in v.playerState && "velocity" in v.playerState && "vmgValue" in v.playerState && "windAngle" in v.playerState && "windOrigin" in v.playerState && "windSpeed" in v.playerState && "downwindVmg" in v.playerState && "upwindVmg" in v.playerState && "shadowDirection" in v.playerState && "trail" in v.playerState && "controlMode" in v.playerState && "tackTarget" in v.playerState && "crossedGates" in v.playerState && "nextGate" in v.playerState ? {_: {}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           ,player: typeof v.playerState.player === "object" && "id" in v.playerState.player && "handle" in v.playerState.player && "status" in v.playerState.player ? {_: {}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       ,id: typeof v.playerState.player.id === "string" || typeof v.playerState.player.id === "object" && v.playerState.player.id instanceof String ? v.playerState.player.id : _U.badPort("a string",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       v.playerState.player.id)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       ,handle: v.playerState.player.handle === null ? Elm.Maybe.make(_elm).Nothing : Elm.Maybe.make(_elm).Just(typeof v.playerState.player.handle === "string" || typeof v.playerState.player.handle === "object" && v.playerState.player.handle instanceof String ? v.playerState.player.handle : _U.badPort("a string",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       v.playerState.player.handle))
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       ,status: v.playerState.player.status === null ? Elm.Maybe.make(_elm).Nothing : Elm.Maybe.make(_elm).Just(typeof v.playerState.player.status === "string" || typeof v.playerState.player.status === "object" && v.playerState.player.status instanceof String ? v.playerState.player.status : _U.badPort("a string",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       v.playerState.player.status))} : _U.badPort("an object with fields \'id\', \'handle\', \'status\'",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           v.playerState.player)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           ,position: typeof v.playerState.position === "object" && v.playerState.position instanceof Array ? {ctor: "_Tuple2"
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ,_0: typeof v.playerState.position[0] === "number" ? v.playerState.position[0] : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              v.playerState.position[0])
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ,_1: typeof v.playerState.position[1] === "number" ? v.playerState.position[1] : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              v.playerState.position[1])} : _U.badPort("an array",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           v.playerState.position)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           ,heading: typeof v.playerState.heading === "number" ? v.playerState.heading : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           v.playerState.heading)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           ,velocity: typeof v.playerState.velocity === "number" ? v.playerState.velocity : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           v.playerState.velocity)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           ,vmgValue: typeof v.playerState.vmgValue === "number" ? v.playerState.vmgValue : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           v.playerState.vmgValue)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           ,windAngle: typeof v.playerState.windAngle === "number" ? v.playerState.windAngle : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           v.playerState.windAngle)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           ,windOrigin: typeof v.playerState.windOrigin === "number" ? v.playerState.windOrigin : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           v.playerState.windOrigin)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           ,windSpeed: typeof v.playerState.windSpeed === "number" ? v.playerState.windSpeed : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           v.playerState.windSpeed)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           ,downwindVmg: typeof v.playerState.downwindVmg === "object" && "angle" in v.playerState.downwindVmg && "speed" in v.playerState.downwindVmg && "value" in v.playerState.downwindVmg ? {_: {}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 ,angle: typeof v.playerState.downwindVmg.angle === "number" ? v.playerState.downwindVmg.angle : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 v.playerState.downwindVmg.angle)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 ,speed: typeof v.playerState.downwindVmg.speed === "number" ? v.playerState.downwindVmg.speed : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 v.playerState.downwindVmg.speed)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 ,value: typeof v.playerState.downwindVmg.value === "number" ? v.playerState.downwindVmg.value : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 v.playerState.downwindVmg.value)} : _U.badPort("an object with fields \'angle\', \'speed\', \'value\'",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           v.playerState.downwindVmg)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           ,upwindVmg: typeof v.playerState.upwindVmg === "object" && "angle" in v.playerState.upwindVmg && "speed" in v.playerState.upwindVmg && "value" in v.playerState.upwindVmg ? {_: {}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       ,angle: typeof v.playerState.upwindVmg.angle === "number" ? v.playerState.upwindVmg.angle : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       v.playerState.upwindVmg.angle)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       ,speed: typeof v.playerState.upwindVmg.speed === "number" ? v.playerState.upwindVmg.speed : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       v.playerState.upwindVmg.speed)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       ,value: typeof v.playerState.upwindVmg.value === "number" ? v.playerState.upwindVmg.value : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       v.playerState.upwindVmg.value)} : _U.badPort("an object with fields \'angle\', \'speed\', \'value\'",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           v.playerState.upwindVmg)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           ,shadowDirection: typeof v.playerState.shadowDirection === "number" ? v.playerState.shadowDirection : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           v.playerState.shadowDirection)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           ,trail: typeof v.playerState.trail === "object" && v.playerState.trail instanceof Array ? Elm.Native.List.make(_elm).fromArray(v.playerState.trail.map(function (v) {
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              return typeof v === "object" && v instanceof Array ? {ctor: "_Tuple2"
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   ,_0: typeof v[0] === "number" ? v[0] : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   v[0])
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   ,_1: typeof v[1] === "number" ? v[1] : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   v[1])} : _U.badPort("an array",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              v);
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           })) : _U.badPort("an array",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           v.playerState.trail)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           ,controlMode: typeof v.playerState.controlMode === "string" || typeof v.playerState.controlMode === "object" && v.playerState.controlMode instanceof String ? v.playerState.controlMode : _U.badPort("a string",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           v.playerState.controlMode)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           ,tackTarget: v.playerState.tackTarget === null ? Elm.Maybe.make(_elm).Nothing : Elm.Maybe.make(_elm).Just(typeof v.playerState.tackTarget === "number" ? v.playerState.tackTarget : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           v.playerState.tackTarget))
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           ,crossedGates: typeof v.playerState.crossedGates === "object" && v.playerState.crossedGates instanceof Array ? Elm.Native.List.make(_elm).fromArray(v.playerState.crossedGates.map(function (v) {
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              return typeof v === "number" ? v : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              v);
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           })) : _U.badPort("an array",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           v.playerState.crossedGates)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           ,nextGate: v.playerState.nextGate === null ? Elm.Maybe.make(_elm).Nothing : Elm.Maybe.make(_elm).Just(typeof v.playerState.nextGate === "string" || typeof v.playerState.nextGate === "object" && v.playerState.nextGate instanceof String ? v.playerState.nextGate : _U.badPort("a string",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           v.playerState.nextGate))} : _U.badPort("an object with fields \'player\', \'position\', \'heading\', \'velocity\', \'vmgValue\', \'windAngle\', \'windOrigin\', \'windSpeed\', \'downwindVmg\', \'upwindVmg\', \'shadowDirection\', \'trail\', \'controlMode\', \'tackTarget\', \'crossedGates\', \'nextGate\'",
                                                                                                                                                                                                                                                                     v.playerState))
                                                                                                                                                                                                                                                                     ,wind: typeof v.wind === "object" && "origin" in v.wind && "speed" in v.wind && "gusts" in v.wind ? {_: {}
                                                                                                                                                                                                                                                                                                                                                                         ,origin: typeof v.wind.origin === "number" ? v.wind.origin : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                         v.wind.origin)
                                                                                                                                                                                                                                                                                                                                                                         ,speed: typeof v.wind.speed === "number" ? v.wind.speed : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                         v.wind.speed)
                                                                                                                                                                                                                                                                                                                                                                         ,gusts: typeof v.wind.gusts === "object" && v.wind.gusts instanceof Array ? Elm.Native.List.make(_elm).fromArray(v.wind.gusts.map(function (v) {
                                                                                                                                                                                                                                                                                                                                                                            return typeof v === "object" && "position" in v && "angle" in v && "speed" in v && "radius" in v ? {_: {}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                               ,position: typeof v.position === "object" && v.position instanceof Array ? {ctor: "_Tuple2"
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          ,_0: typeof v.position[0] === "number" ? v.position[0] : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          v.position[0])
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          ,_1: typeof v.position[1] === "number" ? v.position[1] : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          v.position[1])} : _U.badPort("an array",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                               v.position)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                               ,angle: typeof v.angle === "number" ? v.angle : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                               v.angle)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                               ,speed: typeof v.speed === "number" ? v.speed : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                               v.speed)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                               ,radius: typeof v.radius === "number" ? v.radius : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                               v.radius)} : _U.badPort("an object with fields \'position\', \'angle\', \'speed\', \'radius\'",
                                                                                                                                                                                                                                                                                                                                                                            v);
                                                                                                                                                                                                                                                                                                                                                                         })) : _U.badPort("an array",
                                                                                                                                                                                                                                                                                                                                                                         v.wind.gusts)} : _U.badPort("an object with fields \'origin\', \'speed\', \'gusts\'",
                                                                                                                                                                                                                                                                     v.wind)
                                                                                                                                                                                                                                                                     ,opponents: typeof v.opponents === "object" && v.opponents instanceof Array ? Elm.Native.List.make(_elm).fromArray(v.opponents.map(function (v) {
                                                                                                                                                                                                                                                                        return typeof v === "object" && "player" in v && "position" in v && "heading" in v && "velocity" in v && "vmgValue" in v && "windAngle" in v && "windOrigin" in v && "windSpeed" in v && "downwindVmg" in v && "upwindVmg" in v && "shadowDirection" in v && "trail" in v && "controlMode" in v && "tackTarget" in v && "crossedGates" in v && "nextGate" in v ? {_: {}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         ,player: typeof v.player === "object" && "id" in v.player && "handle" in v.player && "status" in v.player ? {_: {}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     ,id: typeof v.player.id === "string" || typeof v.player.id === "object" && v.player.id instanceof String ? v.player.id : _U.badPort("a string",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     v.player.id)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     ,handle: v.player.handle === null ? Elm.Maybe.make(_elm).Nothing : Elm.Maybe.make(_elm).Just(typeof v.player.handle === "string" || typeof v.player.handle === "object" && v.player.handle instanceof String ? v.player.handle : _U.badPort("a string",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     v.player.handle))
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     ,status: v.player.status === null ? Elm.Maybe.make(_elm).Nothing : Elm.Maybe.make(_elm).Just(typeof v.player.status === "string" || typeof v.player.status === "object" && v.player.status instanceof String ? v.player.status : _U.badPort("a string",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     v.player.status))} : _U.badPort("an object with fields \'id\', \'handle\', \'status\'",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         v.player)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         ,position: typeof v.position === "object" && v.position instanceof Array ? {ctor: "_Tuple2"
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    ,_0: typeof v.position[0] === "number" ? v.position[0] : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    v.position[0])
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    ,_1: typeof v.position[1] === "number" ? v.position[1] : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    v.position[1])} : _U.badPort("an array",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         v.position)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         ,heading: typeof v.heading === "number" ? v.heading : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         v.heading)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         ,velocity: typeof v.velocity === "number" ? v.velocity : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         v.velocity)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         ,vmgValue: typeof v.vmgValue === "number" ? v.vmgValue : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         v.vmgValue)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         ,windAngle: typeof v.windAngle === "number" ? v.windAngle : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         v.windAngle)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         ,windOrigin: typeof v.windOrigin === "number" ? v.windOrigin : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         v.windOrigin)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         ,windSpeed: typeof v.windSpeed === "number" ? v.windSpeed : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         v.windSpeed)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         ,downwindVmg: typeof v.downwindVmg === "object" && "angle" in v.downwindVmg && "speed" in v.downwindVmg && "value" in v.downwindVmg ? {_: {}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               ,angle: typeof v.downwindVmg.angle === "number" ? v.downwindVmg.angle : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               v.downwindVmg.angle)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               ,speed: typeof v.downwindVmg.speed === "number" ? v.downwindVmg.speed : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               v.downwindVmg.speed)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               ,value: typeof v.downwindVmg.value === "number" ? v.downwindVmg.value : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               v.downwindVmg.value)} : _U.badPort("an object with fields \'angle\', \'speed\', \'value\'",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         v.downwindVmg)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         ,upwindVmg: typeof v.upwindVmg === "object" && "angle" in v.upwindVmg && "speed" in v.upwindVmg && "value" in v.upwindVmg ? {_: {}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     ,angle: typeof v.upwindVmg.angle === "number" ? v.upwindVmg.angle : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     v.upwindVmg.angle)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     ,speed: typeof v.upwindVmg.speed === "number" ? v.upwindVmg.speed : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     v.upwindVmg.speed)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     ,value: typeof v.upwindVmg.value === "number" ? v.upwindVmg.value : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     v.upwindVmg.value)} : _U.badPort("an object with fields \'angle\', \'speed\', \'value\'",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         v.upwindVmg)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         ,shadowDirection: typeof v.shadowDirection === "number" ? v.shadowDirection : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         v.shadowDirection)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         ,trail: typeof v.trail === "object" && v.trail instanceof Array ? Elm.Native.List.make(_elm).fromArray(v.trail.map(function (v) {
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            return typeof v === "object" && v instanceof Array ? {ctor: "_Tuple2"
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 ,_0: typeof v[0] === "number" ? v[0] : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 v[0])
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 ,_1: typeof v[1] === "number" ? v[1] : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 v[1])} : _U.badPort("an array",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            v);
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         })) : _U.badPort("an array",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         v.trail)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         ,controlMode: typeof v.controlMode === "string" || typeof v.controlMode === "object" && v.controlMode instanceof String ? v.controlMode : _U.badPort("a string",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         v.controlMode)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         ,tackTarget: v.tackTarget === null ? Elm.Maybe.make(_elm).Nothing : Elm.Maybe.make(_elm).Just(typeof v.tackTarget === "number" ? v.tackTarget : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         v.tackTarget))
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         ,crossedGates: typeof v.crossedGates === "object" && v.crossedGates instanceof Array ? Elm.Native.List.make(_elm).fromArray(v.crossedGates.map(function (v) {
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            return typeof v === "number" ? v : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            v);
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         })) : _U.badPort("an array",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         v.crossedGates)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         ,nextGate: v.nextGate === null ? Elm.Maybe.make(_elm).Nothing : Elm.Maybe.make(_elm).Just(typeof v.nextGate === "string" || typeof v.nextGate === "object" && v.nextGate instanceof String ? v.nextGate : _U.badPort("a string",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         v.nextGate))} : _U.badPort("an object with fields \'player\', \'position\', \'heading\', \'velocity\', \'vmgValue\', \'windAngle\', \'windOrigin\', \'windSpeed\', \'downwindVmg\', \'upwindVmg\', \'shadowDirection\', \'trail\', \'controlMode\', \'tackTarget\', \'crossedGates\', \'nextGate\'",
                                                                                                                                                                                                                                                                        v);
                                                                                                                                                                                                                                                                     })) : _U.badPort("an array",
                                                                                                                                                                                                                                                                     v.opponents)
                                                                                                                                                                                                                                                                     ,ghosts: typeof v.ghosts === "object" && v.ghosts instanceof Array ? Elm.Native.List.make(_elm).fromArray(v.ghosts.map(function (v) {
                                                                                                                                                                                                                                                                        return typeof v === "object" && "position" in v && "heading" in v && "id" in v && "handle" in v && "gates" in v ? {_: {}
                                                                                                                                                                                                                                                                                                                                                                                          ,position: typeof v.position === "object" && v.position instanceof Array ? {ctor: "_Tuple2"
                                                                                                                                                                                                                                                                                                                                                                                                                                                                     ,_0: typeof v.position[0] === "number" ? v.position[0] : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                     v.position[0])
                                                                                                                                                                                                                                                                                                                                                                                                                                                                     ,_1: typeof v.position[1] === "number" ? v.position[1] : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                     v.position[1])} : _U.badPort("an array",
                                                                                                                                                                                                                                                                                                                                                                                          v.position)
                                                                                                                                                                                                                                                                                                                                                                                          ,heading: typeof v.heading === "number" ? v.heading : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                          v.heading)
                                                                                                                                                                                                                                                                                                                                                                                          ,id: typeof v.id === "string" || typeof v.id === "object" && v.id instanceof String ? v.id : _U.badPort("a string",
                                                                                                                                                                                                                                                                                                                                                                                          v.id)
                                                                                                                                                                                                                                                                                                                                                                                          ,handle: v.handle === null ? Elm.Maybe.make(_elm).Nothing : Elm.Maybe.make(_elm).Just(typeof v.handle === "string" || typeof v.handle === "object" && v.handle instanceof String ? v.handle : _U.badPort("a string",
                                                                                                                                                                                                                                                                                                                                                                                          v.handle))
                                                                                                                                                                                                                                                                                                                                                                                          ,gates: typeof v.gates === "object" && v.gates instanceof Array ? Elm.Native.List.make(_elm).fromArray(v.gates.map(function (v) {
                                                                                                                                                                                                                                                                                                                                                                                             return typeof v === "number" ? v : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                             v);
                                                                                                                                                                                                                                                                                                                                                                                          })) : _U.badPort("an array",
                                                                                                                                                                                                                                                                                                                                                                                          v.gates)} : _U.badPort("an object with fields \'position\', \'heading\', \'id\', \'handle\', \'gates\'",
                                                                                                                                                                                                                                                                        v);
                                                                                                                                                                                                                                                                     })) : _U.badPort("an array",
                                                                                                                                                                                                                                                                     v.ghosts)
                                                                                                                                                                                                                                                                     ,leaderboard: typeof v.leaderboard === "object" && v.leaderboard instanceof Array ? Elm.Native.List.make(_elm).fromArray(v.leaderboard.map(function (v) {
                                                                                                                                                                                                                                                                        return typeof v === "object" && "playerId" in v && "playerHandle" in v && "gates" in v ? {_: {}
                                                                                                                                                                                                                                                                                                                                                                 ,playerId: typeof v.playerId === "string" || typeof v.playerId === "object" && v.playerId instanceof String ? v.playerId : _U.badPort("a string",
                                                                                                                                                                                                                                                                                                                                                                 v.playerId)
                                                                                                                                                                                                                                                                                                                                                                 ,playerHandle: v.playerHandle === null ? Elm.Maybe.make(_elm).Nothing : Elm.Maybe.make(_elm).Just(typeof v.playerHandle === "string" || typeof v.playerHandle === "object" && v.playerHandle instanceof String ? v.playerHandle : _U.badPort("a string",
                                                                                                                                                                                                                                                                                                                                                                 v.playerHandle))
                                                                                                                                                                                                                                                                                                                                                                 ,gates: typeof v.gates === "object" && v.gates instanceof Array ? Elm.Native.List.make(_elm).fromArray(v.gates.map(function (v) {
                                                                                                                                                                                                                                                                                                                                                                    return typeof v === "number" ? v : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                    v);
                                                                                                                                                                                                                                                                                                                                                                 })) : _U.badPort("an array",
                                                                                                                                                                                                                                                                                                                                                                 v.gates)} : _U.badPort("an object with fields \'playerId\', \'playerHandle\', \'gates\'",
                                                                                                                                                                                                                                                                        v);
                                                                                                                                                                                                                                                                     })) : _U.badPort("an array",
                                                                                                                                                                                                                                                                     v.leaderboard)
                                                                                                                                                                                                                                                                     ,isMaster: typeof v.isMaster === "boolean" ? v.isMaster : _U.badPort("a boolean (true or false)",
                                                                                                                                                                                                                                                                     v.isMaster)
                                                                                                                                                                                                                                                                     ,watching: typeof v.watching === "boolean" ? v.watching : _U.badPort("a boolean (true or false)",
                                                                                                                                                                                                                                                                     v.watching)
                                                                                                                                                                                                                                                                     ,timeTrial: typeof v.timeTrial === "boolean" ? v.timeTrial : _U.badPort("a boolean (true or false)",
                                                                                                                                                                                                                                                                     v.timeTrial)} : _U.badPort("an object with fields \'playerId\', \'now\', \'startTime\', \'course\', \'playerState\', \'wind\', \'opponents\', \'ghosts\', \'leaderboard\', \'isMaster\', \'watching\', \'timeTrial\'",
      v);
   }));
   var input = $Signal.sampleOn(clock)(A6($Signal.map5,
   $Inputs.GameInput,
   clock,
   $Inputs.keyboardInput,
   $Window.dimensions,
   raceInput,
   $Inputs.watcherInput));
   var gameState = A3($Signal.foldp,
   $Steps.stepGame,
   $Game.defaultGame,
   input);
   var title = _P.portOut("title",
   _P.outgoingSignal(function (v) {
      return v;
   }),
   A2($Signal._op["<~"],
   $Render$Utils.gameTitle,
   gameState));
   var main = A3($Signal.map2,
   $Render$All.render,
   $Window.dimensions,
   gameState);
   var playerOutput = _P.portOut("playerOutput",
   _P.outgoingSignal(function (v) {
      return {arrows: {x: v.arrows.x
                      ,y: v.arrows.y}
             ,lock: v.lock
             ,tack: v.tack
             ,subtleTurn: v.subtleTurn
             ,startCountdown: v.startCountdown};
   }),
   A2($Signal._op["<~"],
   function (_) {
      return _.keyboardInput;
   },
   input));
   var watcherOutput = _P.portOut("watcherOutput",
   _P.outgoingSignal(function (v) {
      return {watchedPlayerId: v.watchedPlayerId.ctor === "Nothing" ? null : v.watchedPlayerId._0};
   }),
   A2($Signal._op["<~"],
   function (_) {
      return _.watcherInput;
   },
   input));
   _elm.Main.values = {_op: _op
                      ,clock: clock
                      ,input: input
                      ,gameState: gameState
                      ,main: main};
   return _elm.Main.values;
};
Elm.Maybe = Elm.Maybe || {};
Elm.Maybe.make = function (_elm) {
   "use strict";
   _elm.Maybe = _elm.Maybe || {};
   if (_elm.Maybe.values)
   return _elm.Maybe.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _P = _N.Ports.make(_elm),
   $moduleName = "Maybe";
   var withDefault = F2(function ($default,
   maybe) {
      return function () {
         switch (maybe.ctor)
         {case "Just": return maybe._0;
            case "Nothing":
            return $default;}
         _U.badCase($moduleName,
         "between lines 45 and 56");
      }();
   });
   var Nothing = {ctor: "Nothing"};
   var oneOf = function (maybes) {
      return function () {
         switch (maybes.ctor)
         {case "::": return function () {
                 switch (maybes._0.ctor)
                 {case "Just": return maybes._0;
                    case "Nothing":
                    return oneOf(maybes._1);}
                 _U.badCase($moduleName,
                 "between lines 64 and 73");
              }();
            case "[]": return Nothing;}
         _U.badCase($moduleName,
         "between lines 59 and 73");
      }();
   };
   var andThen = F2(function (maybeValue,
   callback) {
      return function () {
         switch (maybeValue.ctor)
         {case "Just":
            return callback(maybeValue._0);
            case "Nothing": return Nothing;}
         _U.badCase($moduleName,
         "between lines 110 and 112");
      }();
   });
   var Just = function (a) {
      return {ctor: "Just",_0: a};
   };
   var map = F2(function (f,
   maybe) {
      return function () {
         switch (maybe.ctor)
         {case "Just":
            return Just(f(maybe._0));
            case "Nothing": return Nothing;}
         _U.badCase($moduleName,
         "between lines 76 and 107");
      }();
   });
   _elm.Maybe.values = {_op: _op
                       ,andThen: andThen
                       ,map: map
                       ,withDefault: withDefault
                       ,oneOf: oneOf
                       ,Just: Just
                       ,Nothing: Nothing};
   return _elm.Maybe.values;
};

Elm.Native.Basics = {};
Elm.Native.Basics.make = function(elm) {
  elm.Native = elm.Native || {};
  elm.Native.Basics = elm.Native.Basics || {};
  if (elm.Native.Basics.values) return elm.Native.Basics.values;

  var Utils = Elm.Native.Utils.make(elm);

  function div(a, b) {
      return (a/b)|0;
  }
  function rem(a, b) {
      return a % b;
  }
  function mod(a, b) {
        if (b === 0) {
            throw new Error("Cannot perform mod 0. Division by zero error.");
        }
        var r = a % b;
        var m = a === 0 ? 0 : (b > 0 ? (a >= 0 ? r : r+b) : -mod(-a,-b));

        return m === b ? 0 : m;
  }
  function logBase(base, n) {
      return Math.log(n) / Math.log(base);
  }
  function negate(n) {
      return -n;
  }
  function abs(n) {
      return n < 0 ? -n : n;
  }

  function min(a, b) {
      return Utils.cmp(a,b) < 0 ? a : b;
  }
  function max(a, b) {
      return Utils.cmp(a,b) > 0 ? a : b;
  }
  function clamp(lo, hi, n) {
      return Utils.cmp(n,lo) < 0 ? lo : Utils.cmp(n,hi) > 0 ? hi : n;
  }

  function xor(a, b) {
      return a !== b;
  }
  function not(b) {
      return !b;
  }
  function isInfinite(n) {
      return n === Infinity || n === -Infinity
  }

  function truncate(n) {
      return n|0;
  }

  function degrees(d) {
      return d * Math.PI / 180;
  }
  function turns(t) {
      return 2 * Math.PI * t;
  }
  function fromPolar(point) {
      var r = point._0;
      var t = point._1;
      return Utils.Tuple2(r * Math.cos(t), r * Math.sin(t));
  }
  function toPolar(point) {
      var x = point._0;
      var y = point._1;
      return Utils.Tuple2(Math.sqrt(x * x + y * y), Math.atan2(y,x));
  }

  var basics = {
      div: F2(div),
      rem: F2(rem),
      mod: F2(mod),

      pi: Math.PI,
      e: Math.E,
      cos: Math.cos,
      sin: Math.sin,
      tan: Math.tan,
      acos: Math.acos,
      asin: Math.asin,
      atan: Math.atan,
      atan2: F2(Math.atan2),

      degrees:  degrees,
      turns:  turns,
      fromPolar:  fromPolar,
      toPolar:  toPolar,

      sqrt: Math.sqrt,
      logBase: F2(logBase),
      negate: negate,
      abs: abs,
      min: F2(min),
      max: F2(max),
      clamp: F3(clamp),
      compare: Utils.compare,

      xor: F2(xor),
      not: not,

      truncate: truncate,
      ceiling: Math.ceil,
      floor: Math.floor,
      round: Math.round,
      toFloat: function(x) { return x; },
      isNaN: isNaN,
      isInfinite: isInfinite
  };

  return elm.Native.Basics.values = basics;
};

Elm.Native.Char = {};
Elm.Native.Char.make = function(elm) {
    elm.Native = elm.Native || {};
    elm.Native.Char = elm.Native.Char || {};
    if (elm.Native.Char.values) return elm.Native.Char.values;

    var Utils = Elm.Native.Utils.make(elm);

    function isBetween(lo,hi) { return function(chr) {
	var c = chr.charCodeAt(0);
	return lo <= c && c <= hi;
    };
                              }
    var isDigit = isBetween('0'.charCodeAt(0),'9'.charCodeAt(0));
    var chk1 = isBetween('a'.charCodeAt(0),'f'.charCodeAt(0));
    var chk2 = isBetween('A'.charCodeAt(0),'F'.charCodeAt(0));

    return elm.Native.Char.values = {
        fromCode : function(c) { return String.fromCharCode(c); },
        toCode   : function(c) { return c.toUpperCase().charCodeAt(0); },
        toUpper  : function(c) { return Utils.chr(c.toUpperCase()); },
        toLower  : function(c) { return Utils.chr(c.toLowerCase()); },
        toLocaleUpper : function(c) { return Utils.chr(c.toLocaleUpperCase()); },
        toLocaleLower : function(c) { return Utils.chr(c.toLocaleLowerCase()); },
        isLower    : isBetween('a'.charCodeAt(0),'z'.charCodeAt(0)),
        isUpper    : isBetween('A'.charCodeAt(0),'Z'.charCodeAt(0)),
        isDigit    : isDigit,
        isOctDigit : isBetween('0'.charCodeAt(0),'7'.charCodeAt(0)),
        isHexDigit : function(c) { return isDigit(c) || chk1(c) || chk2(c); }
    };
};

Elm.Native.Color = {};
Elm.Native.Color.make = function(elm) {
    elm.Native = elm.Native || {};
    elm.Native.Color = elm.Native.Color || {};
    if (elm.Native.Color.values) return elm.Native.Color.values;

    function toCss(c) {
        var format = '';
        var colors = '';
        if (c.ctor === 'RGBA') {
            format = 'rgb';
            colors = c._0 + ', ' + c._1 + ', ' + c._2;
        } else {
            format = 'hsl';
            colors = (c._0 * 180 / Math.PI) + ', ' +
                     (c._1 * 100) + '%, ' +
                     (c._2 * 100) + '%';
        }
        if (c._3 === 1) {
            return format + '(' + colors + ')';
        } else {
            return format + 'a(' + colors + ', ' + c._3 + ')';
        }
    }

    return elm.Native.Color.values = {
        toCss:toCss
    };

};

Elm.Native.Debug = {};
Elm.Native.Debug.make = function(elm) {
    elm.Native = elm.Native || {};
    elm.Native.Debug = elm.Native.Debug || {};
    if (elm.Native.Debug.values) return elm.Native.Debug.values;
    if ('values' in Elm.Native.Debug)
        return elm.Native.Debug.values = Elm.Native.Debug.values;

    var toString = Elm.Native.Show.make(elm).toString;
    var replace = Elm.Native.Utils.make(elm).replace;

    function log(tag, value) {
        var msg = tag + ': ' + toString(value);
        var process = process || {};
        if (process.stdout) {
            process.stdout.write(msg);
        } else {
            console.log(msg);
        }
        return value;
    }

    function crash(message) {
        throw new Error(message);
    }

    function tracePath(debugId, form) {
        return replace([["debugTracePathId",debugId]], form);
    }

    function WatchTracker() {
        this.frames = [{}];
        this.clear = function() {
            this.watches = {};
        };
        this.pushFrame = function() {
            var lastFrame = this.frames[this.frames.length - 1];
            this.frames.push(lastFrame);
        }
        this.notify = function(tag, value) {
            this.frames[this.frames.length - 1][tag] = value;
        };
    }
    var watchTracker = new WatchTracker();

    function watch(tag, value) {
        watchTracker.notify(tag, value);
        return value;
    }

    function watchSummary(tag, f, value) {
        watchTracker.notify(tag, f(value));
        return value;
    }

    Elm.Native.Debug.values = {
        crash: crash,
        tracePath: F2(tracePath),
        log: F2(log),
        watch: F2(watch),
        watchSummary:F3(watchSummary),
        watchTracker: watchTracker
    };
    return elm.Native.Debug.values = Elm.Native.Debug.values;
};


// setup
Elm.Native = Elm.Native || {};
Elm.Native.Graphics = Elm.Native.Graphics || {};
Elm.Native.Graphics.Collage = Elm.Native.Graphics.Collage || {};

// definition
Elm.Native.Graphics.Collage.make = function(localRuntime) {
    'use strict';

    // attempt to short-circuit
    if ('values' in Elm.Native.Graphics.Collage) {
        return Elm.Native.Graphics.Collage.values;
    }

    // okay, we cannot short-ciruit, so now we define everything
    var Color = Elm.Native.Color.make(localRuntime);
    var List = Elm.Native.List.make(localRuntime);
    var Transform = Elm.Transform2D.make(localRuntime);

    var Element = Elm.Graphics.Element.make(localRuntime);
    var NativeElement = Elm.Native.Graphics.Element.make(localRuntime);


    function trace(ctx, path) {
        var points = List.toArray(path);
        var i = points.length - 1;
        if (i <= 0) {
            return;
        }
        ctx.moveTo(points[i]._0, points[i]._1);
        while (i--) {
            ctx.lineTo(points[i]._0, points[i]._1);
        }
        if (path.closed) {
            i = points.length - 1;
            ctx.lineTo(points[i]._0, points[i]._1);
        }
    }

    function line(ctx,style,path) {
        (style.dashing.ctor === '[]')
            ? trace(ctx, path)
            : customLineHelp(ctx, style, path);
        ctx.scale(1,-1);
        ctx.stroke();
    }

    function customLineHelp(ctx, style, path) {
        var points = List.toArray(path);
        if (path.closed) {
            points.push(points[0]);
        }
        var pattern = List.toArray(style.dashing);
        var i = points.length - 1;
        if (i <= 0) {
            return;
        }
        var x0 = points[i]._0, y0 = points[i]._1;
        var x1=0, y1=0, dx=0, dy=0, remaining=0, nx=0, ny=0;
        var pindex = 0, plen = pattern.length;
        var draw = true, segmentLength = pattern[0];
        ctx.moveTo(x0,y0);
        while (i--) {
            x1 = points[i]._0; y1 = points[i]._1;
            dx = x1 - x0; dy = y1 - y0;
            remaining = Math.sqrt(dx * dx + dy * dy);
            while (segmentLength <= remaining) {
                x0 += dx * segmentLength / remaining;
                y0 += dy * segmentLength / remaining;
                ctx[draw ? 'lineTo' : 'moveTo'](x0, y0);
                // update starting position
                dx = x1 - x0; dy = y1 - y0;
                remaining = Math.sqrt(dx * dx + dy * dy);
                // update pattern
                draw = !draw;
                pindex = (pindex + 1) % plen;
                segmentLength = pattern[pindex];
            }
            if (remaining > 0) {
                ctx[draw ? 'lineTo' : 'moveTo'](x1, y1);
                segmentLength -= remaining;
            }
            x0 = x1; y0 = y1;
        }
    }

    function drawLine(ctx, style, path) {
        ctx.lineWidth = style.width;

        var cap = style.cap.ctor;
        ctx.lineCap = cap === 'Flat'
            ? 'butt'
            : cap === 'Round'
                ? 'round'
                : 'square';

        var join = style.join.ctor;
        ctx.lineJoin = join === 'Smooth'
            ? 'round'
            : join === 'Sharp'
                ? 'miter'
                : 'bevel';

        ctx.miterLimit = style.join._0 || 10;
        ctx.strokeStyle = Color.toCss(style.color);

        return line(ctx, style, path);
    }

    function texture(redo, ctx, src) {
        var img = new Image();
        img.src = src;
        img.onload = redo;
        return ctx.createPattern(img, 'repeat');
    }

    function gradient(ctx, grad) {
        var g;
        var stops = [];
        if (grad.ctor === 'Linear') {
            var p0 = grad._0, p1 = grad._1;
            g = ctx.createLinearGradient(p0._0, -p0._1, p1._0, -p1._1);
            stops = List.toArray(grad._2);
        } else {
            var p0 = grad._0, p2 = grad._2;
            g = ctx.createRadialGradient(p0._0, -p0._1, grad._1, p2._0, -p2._1, grad._3);
            stops = List.toArray(grad._4);
        }
        var len = stops.length;
        for (var i = 0; i < len; ++i) {
            var stop = stops[i];
            g.addColorStop(stop._0, Color.toCss(stop._1));
        }
        return g;
    }

    function drawShape(redo, ctx, style, path) {
        trace(ctx, path);
        var sty = style.ctor;
        ctx.fillStyle = sty === 'Solid'
            ? Color.toCss(style._0)
            : sty === 'Texture'
                ? texture(redo, ctx, style._0)
                : gradient(ctx, style._0);

        ctx.scale(1,-1);
        ctx.fill();
    }

    function drawImage(redo, ctx, form) {
        var img = new Image();
        img.onload = redo;
        img.src = form._3;
        var w = form._0,
            h = form._1,
            pos = form._2,
            srcX = pos._0,
            srcY = pos._1,
            srcW = w,
            srcH = h,
            destX = -w/2,
            destY = -h/2,
            destW = w,
            destH = h;

        ctx.scale(1,-1);
        ctx.drawImage(img, srcX, srcY, srcW, srcH, destX, destY, destW, destH);
    }

    function renderForm(redo, ctx, form) {
        ctx.save();
        var x = form.x, y = form.y, theta = form.theta, scale = form.scale;
        if (x !== 0 || y !== 0) ctx.translate(x, y);
        if (theta !== 0) ctx.rotate(theta);
        if (scale !== 1) ctx.scale(scale,scale);
        if (form.alpha !== 1) ctx.globalAlpha = ctx.globalAlpha * form.alpha;
        ctx.beginPath();
        var f = form.form;
        switch(f.ctor) {
        case 'FPath' : drawLine(ctx, f._0, f._1); break;
        case 'FImage': drawImage(redo, ctx, f); break;
        case 'FShape':
          if (f._0.ctor === 'Line') {
            f._1.closed = true;
            drawLine(ctx, f._0._0, f._1);
          } else {
            drawShape(redo, ctx, f._0._0, f._1);
          }
        break;
        }
        ctx.restore();
    }

    function formToMatrix(form) {
       var scale = form.scale;
       var matrix = A6( Transform.matrix, scale, 0, 0, scale, form.x, form.y );

       var theta = form.theta
       if (theta !== 0) {
           matrix = A2( Transform.multiply, matrix, Transform.rotation(theta) );
       }

       return matrix;
    }

    function str(n) {
        if (n < 0.00001 && n > -0.00001) return 0;
        return n;
    }

    function makeTransform(w, h, form, matrices) {
        var props = form.form._0.props;
        var m = A6( Transform.matrix, 1, 0, 0, -1,
                    (w - props.width ) / 2,
                    (h - props.height) / 2 );
        var len = matrices.length;
        for (var i = 0; i < len; ++i) {
            m = A2( Transform.multiply, m, matrices[i] );
        }
        m = A2( Transform.multiply, m, formToMatrix(form) );

        return 'matrix(' + str( m[0]) + ', ' + str( m[3]) + ', ' +
                           str(-m[1]) + ', ' + str(-m[4]) + ', ' +
                           str( m[2]) + ', ' + str( m[5]) + ')';
    }

    function stepperHelp(list) {
        var arr = List.toArray(list);
        var i = 0;
        function peekNext() {
            return i < arr.length ? arr[i].form.ctor : '';
        }
        // assumes that there is a next element
        function next() {
            var out = arr[i];
            ++i;
            return out;
        }
        return {
            peekNext:peekNext,
            next:next
        };
    }

    function formStepper(forms) {
        var ps = [stepperHelp(forms)];
        var matrices = [];
        var alphas = [];
        function peekNext() {
            var len = ps.length;
            var formType = '';
            for (var i = 0; i < len; ++i ) {
                if (formType = ps[i].peekNext()) return formType;
            }
            return '';
        }
        // assumes that there is a next element
        function next(ctx) {
            while (!ps[0].peekNext()) {
                ps.shift();
                matrices.pop();
                alphas.shift();
                if (ctx) { ctx.restore(); }
            }
            var out = ps[0].next();
            var f = out.form;
            if (f.ctor === 'FGroup') {
                ps.unshift(stepperHelp(f._1));
                var m = A2(Transform.multiply, f._0, formToMatrix(out));
                ctx.save();
                ctx.transform(m[0], m[3], m[1], m[4], m[2], m[5]);
                matrices.push(m);

                var alpha = (alphas[0] || 1) * out.alpha;
                alphas.unshift(alpha);
                ctx.globalAlpha = alpha;
            }
            return out;
        }
        function transforms() { return matrices; }
        function alpha() { return alphas[0] || 1; }
        return {
            peekNext:peekNext,
            next:next,
            transforms:transforms,
            alpha:alpha
        };
    }

    function makeCanvas(w,h) {
        var canvas = NativeElement.createNode('canvas');
        canvas.style.width  = w + 'px';
        canvas.style.height = h + 'px';
        canvas.style.display = "block";
        canvas.style.position = "absolute";
        canvas.width  = w;
        canvas.height = h;
        return canvas;
    }

    function render(model) {
        var div = NativeElement.createNode('div');
        div.style.overflow = 'hidden';
        div.style.position = 'relative';
        update(div, model, model);
        return div;
    }

    function nodeStepper(w,h,div) {
        var kids = div.childNodes;
        var i = 0;
        function transform(transforms, ctx) {
            ctx.translate(w/2, h/2);
            ctx.scale(1,-1);
            var len = transforms.length;
            for (var i = 0; i < len; ++i) {
                var m = transforms[i];
                ctx.save();
                ctx.transform(m[0], m[3], m[1], m[4], m[2], m[5]);
            }
            return ctx;
        }
        function nextContext(transforms) {
            while (i < kids.length) {
                var node = kids[i];
                if (node.getContext) {
                    node.width = w;
                    node.height = h;
                    node.style.width = w + 'px';
                    node.style.height = h + 'px';
                    ++i;
                    return transform(transforms, node.getContext('2d'));
                }
                div.removeChild(node);
            }
            var canvas = makeCanvas(w,h);
            div.appendChild(canvas);
            // we have added a new node, so we must step our position
            ++i;
            return transform(transforms, canvas.getContext('2d'));
        }
        function addElement(matrices, alpha, form) {
            var kid = kids[i];
            var elem = form.form._0;

            var node = (!kid || kid.getContext)
                ? NativeElement.render(elem)
                : NativeElement.update(kid, kid.oldElement, elem);

            node.style.position = 'absolute';
            node.style.opacity = alpha * form.alpha * elem.props.opacity;
            NativeElement.addTransform(node.style, makeTransform(w, h, form, matrices));
            node.oldElement = elem;
            ++i;
            if (!kid) {
                div.appendChild(node);
            } else if (kid.getContext) {
                div.insertBefore(node, kid);
            }
        }
        function clearRest() {
            while (i < kids.length) {
                div.removeChild(kids[i]);
            }
        }
        return { nextContext:nextContext, addElement:addElement, clearRest:clearRest };
    }


    function update(div, _, model) {
        var w = model.w;
        var h = model.h;

        var forms = formStepper(model.forms);
        var nodes = nodeStepper(w,h,div);
        var ctx = null;
        var formType = '';

        while (formType = forms.peekNext()) {
            // make sure we have context if we need it
            if (ctx === null && formType !== 'FElement') {
                ctx = nodes.nextContext(forms.transforms());
                ctx.globalAlpha = forms.alpha();
            }

            var form = forms.next(ctx);
            // if it is FGroup, all updates are made within formStepper when next is called.
            if (formType === 'FElement') {
                // update or insert an element, get a new context
                nodes.addElement(forms.transforms(), forms.alpha(), form);
                ctx = null;
            } else if (formType !== 'FGroup') {
                renderForm(function() { update(div, model, model); }, ctx, form);
            }
        }
        nodes.clearRest();
        return div;
    }


    function collage(w,h,forms) {
        return A3(Element.newElement, w, h, {
            ctor: 'Custom',
            type: 'Collage',
            render: render,
            update: update,
            model: {w:w, h:h, forms:forms}
      	});
    }

    return Elm.Native.Graphics.Collage.values = {
        collage:F3(collage)
    };
};

// setup
Elm.Native = Elm.Native || {};
Elm.Native.Graphics = Elm.Native.Graphics || {};
Elm.Native.Graphics.Element = Elm.Native.Graphics.Element || {};

// definition
Elm.Native.Graphics.Element.make = function(localRuntime) {
    'use strict';

    // attempt to short-circuit
    if ('values' in Elm.Native.Graphics.Element) {
        return Elm.Native.Graphics.Element.values;
    }

    var Color = Elm.Native.Color.make(localRuntime);
    var List = Elm.Native.List.make(localRuntime);
    var Utils = Elm.Native.Utils.make(localRuntime);


    function createNode(elementType) {
        var node = document.createElement(elementType);
        node.style.padding = "0";
        node.style.margin = "0";
        return node;
    }

    function setProps(elem, node) {
        var props = elem.props;

        var element = elem.element;
        var width = props.width - (element.adjustWidth || 0);
        var height = props.height - (element.adjustHeight || 0);
        node.style.width  = (width |0) + 'px';
        node.style.height = (height|0) + 'px';

        if (props.opacity !== 1) {
            node.style.opacity = props.opacity;
        }

        if (props.color.ctor === 'Just') {
            node.style.backgroundColor = Color.toCss(props.color._0);
        }

        if (props.tag !== '') {
            node.id = props.tag;
        }

        if (props.hover.ctor !== '_Tuple0') {
            addHover(node, props.hover);
        }

        if (props.click.ctor !== '_Tuple0') {
            addClick(node, props.click);
        }

        if (props.href !== '') {
            var anchor = createNode('a');
            anchor.href = props.href;
            anchor.style.display = 'block';
            anchor.style.pointerEvents = 'auto';
            anchor.appendChild(node);
            node = anchor;
        }

        return node;
    }

    function addClick(e, handler) {
        e.style.pointerEvents = 'auto';
        e.elm_click_handler = handler;
        function trigger(ev) {
            e.elm_click_handler(Utils.Tuple0);
            ev.stopPropagation();
        }
        e.elm_click_trigger = trigger;
        e.addEventListener('click', trigger);
    }

    function removeClick(e, handler) {
        if (e.elm_click_trigger) {
            e.removeEventListener('click', e.elm_click_trigger);
            e.elm_click_trigger = null;
            e.elm_click_handler = null;
        }
    }

    function addHover(e, handler) {
        e.style.pointerEvents = 'auto';
        e.elm_hover_handler = handler;
        e.elm_hover_count = 0;

        function over(evt) {
            if (e.elm_hover_count++ > 0) return;
            e.elm_hover_handler(true);
            evt.stopPropagation();
        }
        function out(evt) {
            if (e.contains(evt.toElement || evt.relatedTarget)) return;
            e.elm_hover_count = 0;
            e.elm_hover_handler(false);
            evt.stopPropagation();
        }
        e.elm_hover_over = over;
        e.elm_hover_out = out;
        e.addEventListener('mouseover', over);
        e.addEventListener('mouseout', out);
    }

    function removeHover(e) {
        e.elm_hover_handler = null;
        if (e.elm_hover_over) {
            e.removeEventListener('mouseover', e.elm_hover_over);
            e.elm_hover_over = null;
        }
        if (e.elm_hover_out) {
            e.removeEventListener('mouseout', e.elm_hover_out);
            e.elm_hover_out = null;
        }
    }

    function image(props, img) {
        switch (img._0.ctor) {
        case 'Plain':   return plainImage(img._3);
        case 'Fitted':  return fittedImage(props.width, props.height, img._3);
        case 'Cropped': return croppedImage(img,props.width,props.height,img._3);
        case 'Tiled':   return tiledImage(img._3);
        }
    }

    function plainImage(src) {
        var img = createNode('img');
        img.src = src;
        img.name = src;
        img.style.display = "block";
        return img;
    }

    function tiledImage(src) {
        var div = createNode('div');
        div.style.backgroundImage = 'url(' + src + ')';
        return div;
    }

    function fittedImage(w, h, src) {
        var div = createNode('div');
        div.style.background = 'url(' + src + ') no-repeat center';
        div.style.webkitBackgroundSize = 'cover';
        div.style.MozBackgroundSize = 'cover';
        div.style.OBackgroundSize = 'cover';
        div.style.backgroundSize = 'cover';
        return div;
    }

    function croppedImage(elem, w, h, src) {
        var pos = elem._0._0;
        var e = createNode('div');
        e.style.overflow = "hidden";

        var img = createNode('img');
        img.onload = function() {
            var sw = w / elem._1, sh = h / elem._2;
            img.style.width = ((this.width * sw)|0) + 'px';
            img.style.height = ((this.height * sh)|0) + 'px';
            img.style.marginLeft = ((- pos._0 * sw)|0) + 'px';
            img.style.marginTop = ((- pos._1 * sh)|0) + 'px';
        };
        img.src = src;
        img.name = src;
        e.appendChild(img);
        return e;
    }

    function goOut(node) {
        node.style.position = 'absolute';
        return node;
    }
    function goDown(node) {
        return node;
    }
    function goRight(node) {
        node.style.styleFloat = 'left';
        node.style.cssFloat = 'left';
        return node;
    }

    var directionTable = {
        DUp    : goDown,
        DDown  : goDown,
        DLeft  : goRight,
        DRight : goRight,
        DIn    : goOut,
        DOut   : goOut
    };
    function needsReversal(dir) {
        return dir == 'DUp' || dir == 'DLeft' || dir == 'DIn';
    }

    function flow(dir,elist) {
        var array = List.toArray(elist);
        var container = createNode('div');
        var goDir = directionTable[dir];
        if (goDir == goOut) {
            container.style.pointerEvents = 'none';
        }
        if (needsReversal(dir)) {
            array.reverse();
        }
        var len = array.length;
        for (var i = 0; i < len; ++i) {
            container.appendChild(goDir(render(array[i])));
        }
        return container;
    }

    function toPos(pos) {
        switch(pos.ctor) {
        case "Absolute": return  pos._0 + "px";
        case "Relative": return (pos._0 * 100) + "%";
        }
    }

    // must clear right, left, top, bottom, and transform
    // before calling this function
    function setPos(pos,elem,e) {
        var element = elem.element;
        var props = elem.props;
        var w = props.width + (element.adjustWidth ? element.adjustWidth : 0);
        var h = props.height + (element.adjustHeight ? element.adjustHeight : 0);

        e.style.position = 'absolute';
        e.style.margin = 'auto';
        var transform = '';
        switch(pos.horizontal.ctor) {
        case 'P': e.style.right = toPos(pos.x); e.style.removeProperty('left'); break;
        case 'Z': transform = 'translateX(' + ((-w/2)|0) + 'px) ';
        case 'N': e.style.left = toPos(pos.x); e.style.removeProperty('right'); break;
        }
        switch(pos.vertical.ctor) {
        case 'N': e.style.bottom = toPos(pos.y); e.style.removeProperty('top'); break;
        case 'Z': transform += 'translateY(' + ((-h/2)|0) + 'px)';
        case 'P': e.style.top = toPos(pos.y); e.style.removeProperty('bottom'); break;
        }
        if (transform !== '') {
            addTransform(e.style, transform);
        }
        return e;
    }

    function addTransform(style, transform) {
        style.transform       = transform;
        style.msTransform     = transform;
        style.MozTransform    = transform;
        style.webkitTransform = transform;
        style.OTransform      = transform;
    }

    function container(pos,elem) {
        var e = render(elem);
        setPos(pos, elem, e);
        var div = createNode('div');
        div.style.position = 'relative';
        div.style.overflow = 'hidden';
        div.appendChild(e);
        return div;
    }

    function rawHtml(elem) {
        var html = elem.html;
        var guid = elem.guid;
        var align = elem.align;

        var div = createNode('div');
        div.innerHTML = html;
        div.style.visibility = "hidden";
        if (align) {
            div.style.textAlign = align;
        }
        div.style.visibility = 'visible';
        div.style.pointerEvents = 'auto';
        return div;
    }

    function render(elem) {
        return setProps(elem, makeElement(elem));
    }
    function makeElement(e) {
        var elem = e.element;
        switch(elem.ctor) {
        case 'Image':     return image(e.props, elem);
        case 'Flow':      return flow(elem._0.ctor, elem._1);
        case 'Container': return container(elem._0, elem._1);
        case 'Spacer':    return createNode('div');
        case 'RawHtml':   return rawHtml(elem);
        case 'Custom':    return elem.render(elem.model);
        }
    }

    function updateAndReplace(node, curr, next) {
        var newNode = update(node, curr, next);
        if (newNode !== node) {
            node.parentNode.replaceChild(newNode, node);
        }
        return newNode;
    }

    function update(node, curr, next) {
        var rootNode = node;
        if (node.tagName === 'A') {
            node = node.firstChild;
        }
        if (curr.props.id === next.props.id) {
            updateProps(node, curr, next);
            return rootNode;
        }
        if (curr.element.ctor !== next.element.ctor) {
            return render(next);
        }
        var nextE = next.element;
        var currE = curr.element;
        switch(nextE.ctor) {
        case "Spacer":
            updateProps(node, curr, next);
            return rootNode;

        case "RawHtml":
            // only markdown blocks have guids, so this must be a text block
            if (nextE.guid === null) {
                if(currE.html.valueOf() !== nextE.html.valueOf()) {
                    node.innerHTML = nextE.html;
                }
                updateProps(node, curr, next);
                return rootNode;
            }
            if (nextE.guid !== currE.guid) {
                return render(next);
            }
            updateProps(node, curr, next);
            return rootNode;

        case "Image":
            if (nextE._0.ctor === 'Plain') {
                if (nextE._3 !== currE._3) {
                    node.src = nextE._3;
                }
            } else if (!Utils.eq(nextE,currE) ||
                       next.props.width !== curr.props.width ||
                       next.props.height !== curr.props.height) {
                return render(next);
            }
            updateProps(node, curr, next);
            return rootNode;

        case "Flow":
            var arr = List.toArray(nextE._1);
            for (var i = arr.length; i--; ) {
                arr[i] = arr[i].element.ctor;
            }
            if (nextE._0.ctor !== currE._0.ctor) {
                return render(next);
            }
            var nexts = List.toArray(nextE._1);
            var kids = node.childNodes;
            if (nexts.length !== kids.length) {
                return render(next);
            }
            var currs = List.toArray(currE._1);
            var dir = nextE._0.ctor;
            var goDir = directionTable[dir];
            var toReverse = needsReversal(dir);
            var len = kids.length;
            for (var i = len; i-- ;) {
                var subNode = kids[toReverse ? len - i - 1 : i];
                goDir(updateAndReplace(subNode, currs[i], nexts[i]));
            }
            updateProps(node, curr, next);
            return rootNode;

        case "Container":
            var subNode = node.firstChild;
            var newSubNode = updateAndReplace(subNode, currE._1, nextE._1);
            setPos(nextE._0, nextE._1, newSubNode);
            updateProps(node, curr, next);
            return rootNode;

        case "Custom":
            if (currE.type === nextE.type) {
                var updatedNode = nextE.update(node, currE.model, nextE.model);
                updateProps(updatedNode, curr, next);
                return updatedNode;
            } else {
                return render(next);
            }
        }
    }

    function updateProps(node, curr, next) {
        var nextProps = next.props;
        var currProps = curr.props;

        var element = next.element;
        var width = nextProps.width - (element.adjustWidth || 0);
        var height = nextProps.height - (element.adjustHeight || 0);
        if (width !== currProps.width) {
            node.style.width = (width|0) + 'px';
        }
        if (height !== currProps.height) {
            node.style.height = (height|0) + 'px';
        }

        if (nextProps.opacity !== currProps.opacity) {
            node.style.opacity = nextProps.opacity;
        }

        var nextColor = nextProps.color.ctor === 'Just'
            ? Color.toCss(nextProps.color._0)
            : '';
        if (node.style.backgroundColor !== nextColor) {
            node.style.backgroundColor = nextColor;
        }

        if (nextProps.tag !== currProps.tag) {
            node.id = nextProps.tag;
        }

        if (nextProps.href !== currProps.href) {
            if (currProps.href === '') {
                // add a surrounding href
                var anchor = createNode('a');
                anchor.href = nextProps.href;
                anchor.style.display = 'block';
                anchor.style.pointerEvents = 'auto';

                node.parentNode.replaceChild(anchor, node);
                anchor.appendChild(node);
            } else if (nextProps.href === '') {
                // remove the surrounding href
                var anchor = node.parentNode;
                anchor.parentNode.replaceChild(node, anchor);
            } else {
                // just update the link
                node.parentNode.href = nextProps.href;
            }
        }

        // update click and hover handlers
        var removed = false;

        // update hover handlers
        if (currProps.hover.ctor === '_Tuple0') {
            if (nextProps.hover.ctor !== '_Tuple0') {
                addHover(node, nextProps.hover);
            }
        }
        else {
            if (nextProps.hover.ctor === '_Tuple0') {
                removed = true;
                removeHover(node);
            }
            else {
                node.elm_hover_handler = nextProps.hover;
            }
        }

        // update click handlers
        if (currProps.click.ctor === '_Tuple0') {
            if (nextProps.click.ctor !== '_Tuple0') {
                addClick(node, nextProps.click);
            }
        }
        else {
            if (nextProps.click.ctor === '_Tuple0') {
                removed = true;
                removeClick(node);
            } else {
                node.elm_click_handler = nextProps.click;
            }
        }

        // stop capturing clicks if 
        if (removed
            && nextProps.hover.ctor === '_Tuple0'
            && nextProps.click.ctor === '_Tuple0')
        {
            node.style.pointerEvents = 'none';
        }
    }


    function htmlHeight(width, rawHtml) {
        // create dummy node
        var temp = document.createElement('div');
        temp.innerHTML = rawHtml.html;
        if (width > 0) {
            temp.style.width = width + "px";
        }
        temp.style.visibility = "hidden";
        temp.style.styleFloat = "left";
        temp.style.cssFloat   = "left";

        document.body.appendChild(temp);

        // get dimensions
        var style = window.getComputedStyle(temp, null);
        var w = Math.ceil(style.getPropertyValue("width").slice(0,-2) - 0);
        var h = Math.ceil(style.getPropertyValue("height").slice(0,-2) - 0);
        document.body.removeChild(temp);
        return Utils.Tuple2(w,h);
    }


    return Elm.Native.Graphics.Element.values = {
        render: render,
        update: update,
        updateAndReplace: updateAndReplace,

        createNode: createNode,
        addTransform: addTransform,
        htmlHeight: F2(htmlHeight),
        guid: Utils.guid
    };

};

// setup
Elm.Native = Elm.Native || {};
Elm.Native.Graphics = Elm.Native.Graphics || {};
Elm.Native.Graphics.Input = Elm.Native.Graphics.Input || {};

// definition
Elm.Native.Graphics.Input.make = function(localRuntime) {
    'use strict';

    // attempt to short-circuit
    if ('values' in Elm.Native.Graphics.Input) {
        return Elm.Native.Graphics.Input.values;
    }

    var Color = Elm.Native.Color.make(localRuntime);
    var List = Elm.Native.List.make(localRuntime);
    var Text = Elm.Native.Text.make(localRuntime);
    var Utils = Elm.Native.Utils.make(localRuntime);

    var Element = Elm.Graphics.Element.make(localRuntime);
    var NativeElement = Elm.Native.Graphics.Element.make(localRuntime);


    function renderDropDown(model) {
        var drop = NativeElement.createNode('select');
        drop.style.border = '0 solid';
        drop.style.pointerEvents = 'auto';
        drop.style.display = 'block';

        drop.elm_values = List.toArray(model.values);
        drop.elm_handler = model.handler;
        var values = drop.elm_values;

        for (var i = 0; i < values.length; ++i) {
            var option = NativeElement.createNode('option');
            var name = values[i]._0;
            option.value = name;
            option.innerHTML = name;
            drop.appendChild(option);
        }
        drop.addEventListener('change', function() {
            drop.elm_handler(drop.elm_values[drop.selectedIndex]._1)();
        });

        return drop;
    }

    function updateDropDown(node, oldModel, newModel) {
        node.elm_values = List.toArray(newModel.values);
        node.elm_handler = newModel.handler;

        var values = node.elm_values;
        var kids = node.childNodes;
        var kidsLength = kids.length;

        var i = 0;
        for (; i < kidsLength && i < values.length; ++i) {
            var option = kids[i];
            var name = values[i]._0;
            option.value = name;
            option.innerHTML = name;
        }
        for (; i < kidsLength; ++i) {
            node.removeChild(node.lastChild);
        }
        for (; i < values.length; ++i) {
            var option = NativeElement.createNode('option');
            var name = values[i]._0;
            option.value = name;
            option.innerHTML = name;
            node.appendChild(option);
        }
        return node;
    }

    function dropDown(handler, values) {
        return A3(Element.newElement, 100, 24, {
            ctor: 'Custom',
            type: 'DropDown',
            render: renderDropDown,
            update: updateDropDown,
            model: {
                values: values,
                handler: handler
            }
        });
    }

    function renderButton(model) {
        var node = NativeElement.createNode('button');
        node.style.display = 'block';
        node.style.pointerEvents = 'auto';
        node.elm_message = model.message;
        function click() {
            node.elm_message();
        }
        node.addEventListener('click', click);
        node.innerHTML = model.text;
        return node;
    }

    function updateButton(node, oldModel, newModel) {
        node.elm_message = newModel.message;
        var txt = newModel.text;
        if (oldModel.text !== txt) {
            node.innerHTML = txt;
        }
        return node;
    }

    function button(message, text) {
        return A3(Element.newElement, 100, 40, {
            ctor: 'Custom',
            type: 'Button',
            render: renderButton,
            update: updateButton,
            model: {
                message: message,
                text:text
            }
        });
    }

    function renderCustomButton(model) {
        var btn = NativeElement.createNode('div');
        btn.style.pointerEvents = 'auto';
        btn.elm_message = model.message;

        btn.elm_up    = NativeElement.render(model.up);
        btn.elm_hover = NativeElement.render(model.hover);
        btn.elm_down  = NativeElement.render(model.down);

        btn.elm_up.style.display = 'block';
        btn.elm_hover.style.display = 'none';
        btn.elm_down.style.display = 'none';
  
        btn.appendChild(btn.elm_up);
        btn.appendChild(btn.elm_hover);
        btn.appendChild(btn.elm_down);

        function swap(visibleNode, hiddenNode1, hiddenNode2) {
            visibleNode.style.display = 'block';
            hiddenNode1.style.display = 'none';
            hiddenNode2.style.display = 'none';
        }

        var overCount = 0;
        function over(e) {
            if (overCount++ > 0) return;
            swap(btn.elm_hover, btn.elm_down, btn.elm_up);
        }
        function out(e) {
            if (btn.contains(e.toElement || e.relatedTarget)) return;
            overCount = 0;
            swap(btn.elm_up, btn.elm_down, btn.elm_hover);
        }
        function up() {
            swap(btn.elm_hover, btn.elm_down, btn.elm_up);
            btn.elm_message();
        }
        function down() {
            swap(btn.elm_down, btn.elm_hover, btn.elm_up);
        }

        btn.addEventListener('mouseover', over);
        btn.addEventListener('mouseout' , out);
        btn.addEventListener('mousedown', down);
        btn.addEventListener('mouseup'  , up);

        return btn;
    }

    function updateCustomButton(node, oldModel, newModel) {
        node.elm_message = newModel.message;

        var kids = node.childNodes;
        var styleUp    = kids[0].style.display;
        var styleHover = kids[1].style.display;
        var styleDown  = kids[2].style.display;

        NativeElement.updateAndReplace(kids[0], oldModel.up, newModel.up);
        NativeElement.updateAndReplace(kids[1], oldModel.hover, newModel.hover);
        NativeElement.updateAndReplace(kids[2], oldModel.down, newModel.down);

        var kids = node.childNodes;
        kids[0].style.display = styleUp;
        kids[1].style.display = styleHover;
        kids[2].style.display = styleDown;

        return node;
    }

    function max3(a,b,c) {
        var ab = a > b ? a : b;
        return ab > c ? ab : c;
    }

    function customButton(message, up, hover, down) {
        return A3(Element.newElement,
                  max3(up.props.width, hover.props.width, down.props.width),
                  max3(up.props.height, hover.props.height, down.props.height),
                  { ctor: 'Custom',
                    type: 'CustomButton',
                    render: renderCustomButton,
                    update: updateCustomButton,
                    model: {
                        message: message,
                        up: up,
                        hover: hover,
                        down: down
                    }
                  });
    }

    function renderCheckbox(model) {
        var node = NativeElement.createNode('input');
        node.type = 'checkbox';
        node.checked = model.checked;
        node.style.display = 'block';
        node.style.pointerEvents = 'auto';
        node.elm_handler = model.handler;
        function change() {
            node.elm_handler(node.checked)();
        }
        node.addEventListener('change', change);
        return node;
    }

    function updateCheckbox(node, oldModel, newModel) {
        node.elm_handler = newModel.handler;
        node.checked = newModel.checked;
        return node;
    }

    function checkbox(handler, checked) {
        return A3(Element.newElement, 13, 13, {
            ctor: 'Custom',
            type: 'CheckBox',
            render: renderCheckbox,
            update: updateCheckbox,
            model: { handler:handler, checked:checked }
        });
    }

    function setRange(node, start, end, dir) {
        if (node.parentNode) {
            node.setSelectionRange(start, end, dir);
        } else {
            setTimeout(function(){node.setSelectionRange(start, end, dir);}, 0);
        }
    }

    function updateIfNeeded(css, attribute, latestAttribute) {
        if (css[attribute] !== latestAttribute) {
            css[attribute] = latestAttribute;
        }
    }
    function cssDimensions(dimensions) {
        return dimensions.top    + 'px ' +
               dimensions.right  + 'px ' +
               dimensions.bottom + 'px ' +
               dimensions.left   + 'px';
    }
    function updateFieldStyle(css, style) {
        updateIfNeeded(css, 'padding', cssDimensions(style.padding));

        var outline = style.outline;
        updateIfNeeded(css, 'border-width', cssDimensions(outline.width));
        updateIfNeeded(css, 'border-color', Color.toCss(outline.color));
        updateIfNeeded(css, 'border-radius', outline.radius + 'px');

        var highlight = style.highlight;
        if (highlight.width === 0) {
            css.outline = 'none';
        } else {
            updateIfNeeded(css, 'outline-width', highlight.width + 'px');
            updateIfNeeded(css, 'outline-color', Color.toCss(highlight.color));
        }

        var textStyle = style.style;
        updateIfNeeded(css, 'color', Color.toCss(textStyle.color));
        if (textStyle.typeface.ctor !== '[]') {
            updateIfNeeded(css, 'font-family', Text.toTypefaces(textStyle.typeface));
        }
        if (textStyle.height.ctor !== "Nothing") {
            updateIfNeeded(css, 'font-size', textStyle.height._0 + 'px');
        }
        updateIfNeeded(css, 'font-weight', textStyle.bold ? 'bold' : 'normal');
        updateIfNeeded(css, 'font-style', textStyle.italic ? 'italic' : 'normal');
        if (textStyle.line.ctor !== 'Nothing') {
            updateIfNeeded(css, 'text-decoration', Text.toLine(textStyle.line._0));
        }
    }

    function renderField(model) {
        var field = NativeElement.createNode('input');
        updateFieldStyle(field.style, model.style);
        field.style.borderStyle = 'solid';
        field.style.pointerEvents = 'auto';

        field.type = model.type;
        field.placeholder = model.placeHolder;
        field.value = model.content.string;

        field.elm_handler = model.handler;
        field.elm_old_value = field.value;

        function inputUpdate(event) {
            var curr = field.elm_old_value;
            var next = field.value;
            if (curr === next) {
                return;
            }

            var direction = field.selectionDirection === 'forward' ? 'Forward' : 'Backward';
            var start = field.selectionStart;
            var end = field.selectionEnd;
            field.value = field.elm_old_value;

            field.elm_handler({
                _:{},
                string: next,
                selection: {
                    _:{},
                    start: start,
                    end: end,
                    direction: { ctor: direction }
                }
            })();
        }

        field.addEventListener('input', inputUpdate);
        field.addEventListener('focus', function() {
            field.elm_hasFocus = true;
        });
        field.addEventListener('blur', function() {
            field.elm_hasFocus = false;
        });

        return field;
    }

    function updateField(field, oldModel, newModel) {
        if (oldModel.style !== newModel.style) {
            updateFieldStyle(field.style, newModel.style);
        }
        field.elm_handler = newModel.handler;

        field.type = newModel.type;
        field.placeholder = newModel.placeHolder;
        var value = newModel.content.string;
        field.value = value;
        field.elm_old_value = value;
        if (field.elm_hasFocus) {
            var selection = newModel.content.selection;
            var direction = selection.direction.ctor === 'Forward' ? 'forward' : 'backward';
            setRange(field, selection.start, selection.end, direction);
        }
        return field;
    }

    function mkField(type) {
        function field(style, handler, placeHolder, content) {
            var padding = style.padding;
            var outline = style.outline.width;
            var adjustWidth = padding.left + padding.right + outline.left + outline.right;
            var adjustHeight = padding.top + padding.bottom + outline.top + outline.bottom;
            return A3(Element.newElement, 200, 30, {
                ctor: 'Custom',
                type: type + 'Field',
                adjustWidth: adjustWidth,
                adjustHeight: adjustHeight,
                render: renderField,
                update: updateField,
                model: {
                    handler:handler,
                    placeHolder:placeHolder,
                    content:content,
                    style:style,
                    type:type
                }
            });
        }
        return F4(field);
    }

    function hoverable(handler, elem) {
        function onHover(bool) {
            handler(bool)();
        }
        var props = Utils.replace([['hover',onHover]], elem.props);
        return { props:props, element:elem.element };
    }

    function clickable(message, elem) {
        function onClick() {
            message();
        }
        var props = Utils.replace([['click',onClick]], elem.props);
        return { props:props, element:elem.element };
    }

    return Elm.Native.Graphics.Input.values = {
        button: F2(button),
        customButton: F4(customButton),
        checkbox: F2(checkbox),
        dropDown: F2(dropDown),
        field: mkField('text'),
        email: mkField('email'),
        password: mkField('password'),
        hoverable: F2(hoverable),
        clickable: F2(clickable)
    };

};

Elm.Native.Keyboard = {};
Elm.Native.Keyboard.make = function(elm) {

    elm.Native = elm.Native || {};
    elm.Native.Keyboard = elm.Native.Keyboard || {};
    if (elm.Native.Keyboard.values) return elm.Native.Keyboard.values;

    // Duplicated from Native.Signal
    function send(node, timestep, changed) {
        var kids = node.kids;
        for (var i = kids.length; i--; ) {
            kids[i].recv(timestep, changed, node.id);
        }
    }

    var Signal = Elm.Signal.make(elm);
    var NList = Elm.Native.List.make(elm);
    var Utils = Elm.Native.Utils.make(elm);

    var downEvents = Signal.constant(null);
    var upEvents = Signal.constant(null);
    var blurEvents = Signal.constant(null);

    elm.addListener([downEvents.id], document, 'keydown', function down(e) {
        elm.notify(downEvents.id, e);
    });

    elm.addListener([upEvents.id], document, 'keyup', function up(e) {
        elm.notify(upEvents.id, e);
    });

    elm.addListener([blurEvents.id], window, 'blur', function blur(e) {
        elm.notify(blurEvents.id, null);
    });

    function state(alt, meta, keyCodes) {
        return {
            alt: alt,
            meta: meta,
            keyCodes: keyCodes
        };
    }
    var emptyState = state(false, false, NList.Nil);

    function KeyMerge(down, up, blur) {
        var args = [down,up,blur];
        this.id = Utils.guid();
        // Ignore starting values here
        this.value = emptyState;
        this.kids = [];
        
        var n = args.length;
        var count = 0;
        var isChanged = false;

        this.recv = function(timestep, changed, parentID) {
            ++count;
            if (changed) { 
                // We know this a change must only be one of the following cases
                if (parentID === down.id && !A2(NList.member, down.value.keyCode, this.value.keyCodes)) {
                    isChanged = true;
                    var v = down.value;
                    var newCodes = NList.Cons(v.keyCode, this.value.keyCodes);
                    this.value = state(v.altKey, v.metaKey, newCodes);
                }
                else if (parentID === up.id) {
                    isChanged = true;
                    var v = up.value;
                    var notEq = function(kc) { return kc !== v.keyCode };
                    var newCodes = A2(NList.filter, notEq, this.value.keyCodes);
                    this.value = state(v.altKey, v.metaKey, newCodes);
                }
                else if (parentID === blur.id) {
                    isChanged = true;
                    this.value = emptyState;
                }
            }
            if (count == n) {
                send(this, timestep, isChanged);
                isChanged = false;
                count = 0;
            }
        };

        for (var i = n; i--; ) {
            args[i].kids.push(this);
            args[i].defaultNumberOfKids += 1;
        }
    }

    var keyMerge = new KeyMerge(downEvents,upEvents,blurEvents);

    // select a part of a keyMerge and dropRepeats the result
    function keySignal(f) {
        var signal = A2(Signal.map, f, keyMerge);
        // must set the default number of kids to make it possible to filter
        // these signals if they are not actually used.
        keyMerge.defaultNumberOfKids += 1;
        signal.defaultNumberOfKids = 1;
        var filtered = Signal.dropRepeats(signal);
        filtered.defaultNumberOfKids = 0;
        return filtered;
    }

    // break keyMerge into parts
    var keysDown = keySignal(function getKeyCodes(v) {
        return v.keyCodes;
    });
    var alt = keySignal(function getKeyCodes(v) {
        return v.alt;
    });
    var meta = keySignal(function getKeyCodes(v) {
        return v.meta;
    });

    function dir(up, down, left, right) {
        function toDirections(state) {
            var keyCodes = state.keyCodes;
            var x = 0, y = 0;
            while (keyCodes.ctor === "::") {
                switch (keyCodes._0) {
                case left : --x; break;
                case right: ++x; break;
                case up   : ++y; break;
                case down : --y; break;
                }
                keyCodes = keyCodes._1;
            }
            return { _:{}, x:x, y:y };
        }
        return keySignal(toDirections);
    }

    function is(key) {
        return keySignal(function(v) {
            return A2( NList.member, key, v.keyCodes );
        });
    }

    var lastPressed = A2(Signal.map, function(e) {
        return e ? e.keyCode : 0;
    }, downEvents);
    downEvents.defaultNumberOfKids += 1;

    return elm.Native.Keyboard.values = {
        isDown:is,
        alt: alt,
        meta: meta,
        directions:F4(dir),
        keysDown:keysDown,
        lastPressed:lastPressed
    };

};

Elm.Native.List = {};
Elm.Native.List.make = function(elm) {
    elm.Native = elm.Native || {};
    elm.Native.List = elm.Native.List || {};
    if (elm.Native.List.values) return elm.Native.List.values;
    if ('values' in Elm.Native.List)
        return elm.Native.List.values = Elm.Native.List.values;

    var Utils = Elm.Native.Utils.make(elm);

    var Nil = Utils.Nil;
    var Cons = Utils.Cons;

    function throwError(f) {
        throw new Error("Function '" + f + "' expects a non-empty list!");
    }

    function toArray(xs) {
        var out = [];
        while (xs.ctor !== '[]') {
            out.push(xs._0);
            xs = xs._1;
        }
        return out;
    }

    function fromArray(arr) {
        var out = Nil;
        for (var i = arr.length; i--; ) {
            out = Cons(arr[i], out);
        }
        return out;
    }

    function range(lo,hi) {
        var lst = Nil;
        if (lo <= hi) {
            do { lst = Cons(hi,lst) } while (hi-->lo);
        }
        return lst
    }

    function head(v) {
        return v.ctor === '[]' ? throwError('head') : v._0;
    }
    function tail(v) {
        return v.ctor === '[]' ? throwError('tail') : v._1;
    }

    function last(xs) {
        if (xs.ctor === '[]') { throwError('last'); }
        var out = xs._0;
        while (xs.ctor !== '[]') {
            out = xs._0;
            xs = xs._1;
        }
        return out;
    }

    function map(f, xs) {
        var arr = [];
        while (xs.ctor !== '[]') {
            arr.push(f(xs._0));
            xs = xs._1;
        }
        return fromArray(arr);
    }

    // f defined similarly for both foldl and foldr (NB: different from Haskell)
    // ie, foldl : (a -> b -> b) -> b -> [a] -> b
    function foldl(f, b, xs) {
        var acc = b;
        while (xs.ctor !== '[]') {
            acc = A2(f, xs._0, acc);
            xs = xs._1;
        }
        return acc;
    }

    function foldr(f, b, xs) {
        var arr = toArray(xs);
        var acc = b;
        for (var i = arr.length; i--; ) {
            acc = A2(f, arr[i], acc);
        }
        return acc;
    }

    function foldl1(f, xs) {
        return xs.ctor === '[]' ? throwError('foldl1') : foldl(f, xs._0, xs._1);
    }

    function foldr1(f, xs) {
        if (xs.ctor === '[]') { throwError('foldr1'); }
        var arr = toArray(xs);
        var acc = arr.pop();
        for (var i = arr.length; i--; ) {
            acc = A2(f, arr[i], acc);
        }
        return acc;
    }

    function scanl(f, b, xs) {
        var arr = toArray(xs);
        arr.unshift(b);
        var len = arr.length;
        for (var i = 1; i < len; ++i) {
            arr[i] = A2(f, arr[i], arr[i-1]);
        }
        return fromArray(arr);
    }

    function scanl1(f, xs) {
        return xs.ctor === '[]' ? throwError('scanl1') : scanl(f, xs._0, xs._1);
    }

    function filter(pred, xs) {
        var arr = [];
        while (xs.ctor !== '[]') {
            if (pred(xs._0)) { arr.push(xs._0); }
            xs = xs._1;
        }
        return fromArray(arr);
    }

    function length(xs) {
        var out = 0;
        while (xs.ctor !== '[]') {
            out += 1;
            xs = xs._1;
        }
        return out;
    }

    function member(x, xs) {
        while (xs.ctor !== '[]') {
            if (Utils.eq(x,xs._0)) return true;
            xs = xs._1;
        }
        return false;
    }

    function reverse(xs) {
        return fromArray(toArray(xs).reverse());
    }

    function append(xs, ys) {
        if (xs.ctor === '[]') {
            return ys;
        }
        var root = Cons(xs._0, Nil);
        var curr = root;
        xs = xs._1;
        while (xs.ctor !== '[]') {
            curr._1 = Cons(xs._0, Nil);
            xs = xs._1;
            curr = curr._1;
        }
        curr._1 = ys;
        return root;
    }

    function all(pred, xs) {
        while (xs.ctor !== '[]') {
            if (!pred(xs._0)) return false;
            xs = xs._1;
        }
        return true;
    }

    function any(pred, xs) {
        while (xs.ctor !== '[]') {
            if (pred(xs._0)) return true;
            xs = xs._1;
        }
        return false;
    }

    function map2(f, xs, ys) {
        var arr = [];
        while (xs.ctor !== '[]' && ys.ctor !== '[]') {
            arr.push(A2(f, xs._0, ys._0));
            xs = xs._1;
            ys = ys._1;
        }
        return fromArray(arr);
    }

    function map3(f, xs, ys, zs) {
        var arr = [];
        while (xs.ctor !== '[]' && ys.ctor !== '[]' && zs.ctor !== '[]') {
            arr.push(A3(f, xs._0, ys._0, zs._0));
            xs = xs._1;
            ys = ys._1;
            zs = zs._1;
        }
        return fromArray(arr);
    }

    function map4(f, ws, xs, ys, zs) {
        var arr = [];
        while (   ws.ctor !== '[]'
               && xs.ctor !== '[]'
               && ys.ctor !== '[]'
               && zs.ctor !== '[]')
        {
            arr.push(A4(f, ws._0, xs._0, ys._0, zs._0));
            ws = ws._1;
            xs = xs._1;
            ys = ys._1;
            zs = zs._1;
        }
        return fromArray(arr);
    }

    function map5(f, vs, ws, xs, ys, zs) {
        var arr = [];
        while (   vs.ctor !== '[]'
               && ws.ctor !== '[]'
               && xs.ctor !== '[]'
               && ys.ctor !== '[]'
               && zs.ctor !== '[]')
        {
            arr.push(A5(f, vs._0, ws._0, xs._0, ys._0, zs._0));
            vs = vs._1;
            ws = ws._1;
            xs = xs._1;
            ys = ys._1;
            zs = zs._1;
        }
        return fromArray(arr);
    }

    function sort(xs) {
        return fromArray(toArray(xs).sort(Utils.cmp));
    }

    function sortBy(f, xs) {
        return fromArray(toArray(xs).sort(function(a,b){
            return Utils.cmp(f(a), f(b));
        }));
    }

    function sortWith(f, xs) {
        return fromArray(toArray(xs).sort(function(a,b){
            var ord = f(a)(b).ctor;
            return ord === 'EQ' ? 0 : ord === 'LT' ? -1 : 1;
        }));
    }

    function nth(xs, n) {
        return toArray(xs)[n];
    }

    function take(n, xs) {
        var arr = [];
        while (xs.ctor !== '[]' && n > 0) {
            arr.push(xs._0);
            xs = xs._1;
            --n;
        }
        return fromArray(arr);
    }

    function drop(n, xs) {
        while (xs.ctor !== '[]' && n > 0) {
            xs = xs._1;
            --n;
        }
        return xs;
    }

    function repeat(n, x) {
        var arr = [];
        var pattern = [x];
        while (n > 0) {
            if (n & 1) arr = arr.concat(pattern);
            n >>= 1, pattern = pattern.concat(pattern);
        }
        return fromArray(arr);
    }


    Elm.Native.List.values = {
        Nil:Nil,
        Cons:Cons,
        cons:F2(Cons),
        toArray:toArray,
        fromArray:fromArray,
        range:range,
        append: F2(append),

        head:head,
        tail:tail,
        last:last,

        map:F2(map),
        foldl:F3(foldl),
        foldr:F3(foldr),

        foldl1:F2(foldl1),
        foldr1:F2(foldr1),
        scanl:F3(scanl),
        scanl1:F2(scanl1),
        filter:F2(filter),
        length:length,
        member:F2(member),
        reverse:reverse,

        all:F2(all),
        any:F2(any),
        map2:F3(map2),
        map3:F4(map3),
        map4:F5(map4),
        map5:F6(map5),
        sort:sort,
        sortBy:F2(sortBy),
        sortWith:F2(sortWith),
        nth:F2(nth),
        take:F2(take),
        drop:F2(drop),
        repeat:F2(repeat)
    };
    return elm.Native.List.values = Elm.Native.List.values;

};

Elm.Native.Ports = {};
Elm.Native.Ports.make = function(localRuntime) {
    localRuntime.Native = localRuntime.Native || {};
    localRuntime.Native.Ports = localRuntime.Native.Ports || {};
    if (localRuntime.Native.Ports.values) {
        return localRuntime.Native.Ports.values;
    }

    var Signal;

    function incomingSignal(converter) {
        converter.isSignal = true;
        return converter;
    }

    function outgoingSignal(converter) {
        if (!Signal) {
            Signal = Elm.Signal.make(localRuntime);
        }
        return function(signal) {
            var subscribers = []
            function subscribe(handler) {
                subscribers.push(handler);
            }
            function unsubscribe(handler) {
                subscribers.pop(subscribers.indexOf(handler));
            }
            A2( Signal.map, function(value) {
                var val = converter(value);
                var len = subscribers.length;
                for (var i = 0; i < len; ++i) {
                    subscribers[i](val);
                }
            }, signal);
            return { subscribe:subscribe, unsubscribe:unsubscribe };
        }
    }

    function portIn(name, converter) {
        var jsValue = localRuntime.ports.incoming[name];
        if (jsValue === undefined) {
            throw new Error("Initialization Error: port '" + name +
                            "' was not given an input!");
        }
        localRuntime.ports.uses[name] += 1;
        try {
            var elmValue = converter(jsValue);
        } catch(e) {
            throw new Error("Initialization Error on port '" + name + "': \n" + e.message);
        }

        // just return a static value if it is not a signal
        if (!converter.isSignal) {
            return elmValue;
        }

        // create a signal if necessary
        if (!Signal) {
            Signal = Elm.Signal.make(localRuntime);
        }
        var signal = Signal.constant(elmValue);
        function send(jsValue) {
            try {
                var elmValue = converter(jsValue);
            } catch(e) {
                throw new Error("Error sending to port '" + name + "': \n" + e.message);
            }
            setTimeout(function() {
                localRuntime.notify(signal.id, elmValue);
            }, 0);
        }
        localRuntime.ports.outgoing[name] = { send:send };
        return signal;
    }

    function portOut(name, converter, value) {
        try {
            localRuntime.ports.outgoing[name] = converter(value);
        } catch(e) {
            throw new Error("Initialization Error on port '" + name + "': \n" + e.message);
        }
        return value;
    }

    return localRuntime.Native.Ports.values = {
        incomingSignal: incomingSignal,
        outgoingSignal: outgoingSignal,
        portOut: portOut,
        portIn: portIn
    };
};



if (!Elm.fullscreen) {

    (function() {
        'use strict';

        var Display = { FULLSCREEN: 0, COMPONENT: 1, NONE: 2 };

        Elm.fullscreen = function(module, ports) {
            var container = document.createElement('div');
            document.body.appendChild(container);
            return init(Display.FULLSCREEN, container, module, ports || {});
        };

        Elm.embed = function(module, container, ports) {
            var tag = container.tagName;
            if (tag !== 'DIV') {
                throw new Error('Elm.node must be given a DIV, not a ' + tag + '.');
            } else if (container.hasChildNodes()) {
                throw new Error('Elm.node must be given an empty DIV. No children allowed!');
            }
            return init(Display.COMPONENT, container, module, ports || {});
        };

        Elm.worker = function(module, ports) {
            return init(Display.NONE, {}, module, ports || {});
        };

        function init(display, container, module, ports, moduleToReplace) {
            // defining state needed for an instance of the Elm RTS
            var inputs = [];

            /* OFFSET
             * Elm's time traveling debugger lets you interrupt the smooth flow of time
             * by pausing and continuing program execution. To ensure the user sees a
             * program that moves smoothly through the pause/continue time gap,
             * we need to adjsut the value of Date.now().
             */
            var timer = function() {
                var inducedDelay = 0;

                var now = function() {
                    return Date.now() - inducedDelay;
                };

                var addDelay = function(d) {
                    inducedDelay += d;
                    return inducedDelay;
                };

                return {
                    now : now,
                    addDelay : addDelay
                }
            }();

            var updateInProgress = false;
            function notify(id, v) {
                if (updateInProgress) {
                    throw new Error(
                        'The notify function has been called synchronously!\n' +
                        'This can lead to frames being dropped.\n' +
                        'Definitely report this to <https://github.com/elm-lang/Elm/issues>\n');
                }
                updateInProgress = true;
                var timestep = timer.now();
                for (var i = inputs.length; i--; ) {
                    inputs[i].recv(timestep, id, v);
                }
                updateInProgress = false;
            }
            function setTimeout(func, delay) {
                window.setTimeout(func, delay);
            }

            var listeners = [];
            function addListener(relevantInputs, domNode, eventName, func) {
                domNode.addEventListener(eventName, func);
                var listener = {
                    relevantInputs: relevantInputs,
                    domNode: domNode,
                    eventName: eventName,
                    func: func
                };
                listeners.push(listener);
            }

            var portUses = {}
            for (var key in ports) {
                portUses[key] = 0;
            }
            // create the actual RTS. Any impure modules will attach themselves to this
            // object. This permits many Elm programs to be embedded per document.
            var elm = {
                notify: notify,
                setTimeout: setTimeout,
                node: container,
                addListener: addListener,
                inputs: inputs,
                timer: timer,
                ports: { incoming:ports, outgoing:{}, uses:portUses },

                isFullscreen: function() { return display === Display.FULLSCREEN; },
                isEmbed: function() { return display === Display.COMPONENT; },
                isWorker: function() { return display === Display.NONE; }
            };

            function swap(newModule) {
                removeListeners(listeners);
                var div = document.createElement('div');
                var newElm = init(display, div, newModule, ports, elm);
                inputs = [];
                // elm.swap = newElm.swap;
                return newElm;
            }

            function dispose() {
                removeListeners(listeners);
                inputs = [];
            }

            var Module = {};
            try {
                Module = module.make(elm);
                checkPorts(elm);
            } catch(e) {
                var code = document.createElement('code');

                var lines = e.message.split('\n');
                code.appendChild(document.createTextNode(lines[0]));
                code.appendChild(document.createElement('br'));
                code.appendChild(document.createElement('br'));
                for (var i = 1; i < lines.length; ++i) {
                    code.appendChild(document.createTextNode('\u00A0 \u00A0 ' + lines[i]));
                    code.appendChild(document.createElement('br'));
                }
                code.appendChild(document.createElement('br'));
                code.appendChild(document.createTextNode("Open the developer console for more details."));

                container.appendChild(code);
                throw e;
            }
            inputs = filterDeadInputs(inputs);
            filterListeners(inputs, listeners);
            addReceivers(elm.ports.outgoing);
            if (display !== Display.NONE) {
                var graphicsNode = initGraphics(elm, Module);
            }
            if (typeof moduleToReplace !== 'undefined') {
                hotSwap(moduleToReplace, elm);

                // rerender scene if graphics are enabled.
                if (typeof graphicsNode !== 'undefined') {
                    graphicsNode.recv(0, true, 0);
                }
            }

            return {
                swap:swap,
                ports:elm.ports.outgoing,
                dispose:dispose
            };
        };

        function checkPorts(elm) {
            var portUses = elm.ports.uses;
            for (var key in portUses) {
                var uses = portUses[key]
                if (uses === 0) {
                    throw new Error(
                        "Initialization Error: provided port '" + key +
                        "' to a module that does not take it as in input.\n" +
                        "Remove '" + key + "' from the module initialization code.");
                } else if (uses > 1) {
                    throw new Error(
                        "Initialization Error: port '" + key +
                        "' has been declared multiple times in the Elm code.\n" +
                        "Remove declarations until there is exactly one.");
                }
            }
        }


        //// FILTER SIGNALS ////

        // TODO: move this code into the signal module and create a function
        // Signal.initializeGraph that actually instantiates everything.

        function filterListeners(inputs, listeners) {
            loop:
            for (var i = listeners.length; i--; ) {
                var listener = listeners[i];
                for (var j = inputs.length; j--; ) {
                    if (listener.relevantInputs.indexOf(inputs[j].id) >= 0) {
                        continue loop;
                    }
                }
                listener.domNode.removeEventListener(listener.eventName, listener.func);
            }
        }

        function removeListeners(listeners) {
            for (var i = listeners.length; i--; ) {
                var listener = listeners[i];
                listener.domNode.removeEventListener(listener.eventName, listener.func);
            }
        }

        // add receivers for built-in ports if they are defined
        function addReceivers(ports) {
            if ('log' in ports) {
                ports.log.subscribe(function(v) { console.log(v) });
            }
            if ('stdout' in ports) {
                var process = process || {};
                var handler = process.stdout
                    ? function(v) { process.stdout.write(v); }
                    : function(v) { console.log(v); };
                ports.stdout.subscribe(handler);
            }
            if ('stderr' in ports) {
                var process = process || {};
                var handler = process.stderr
                    ? function(v) { process.stderr.write(v); }
                    : function(v) { console.log('Error:' + v); };
                ports.stderr.subscribe(handler);
            }
            if ('title' in ports) {
                if (typeof ports.title === 'string') {
                    document.title = ports.title;
                } else {
                    ports.title.subscribe(function(v) { document.title = v; });
                }
            }
            if ('redirect' in ports) {
                ports.redirect.subscribe(function(v) {
                    if (v.length > 0) window.location = v;
                });
            }
            if ('favicon' in ports) {
                if (typeof ports.favicon === 'string') {
                    changeFavicon(ports.favicon);
                } else {
                    ports.favicon.subscribe(changeFavicon);
                }
            }
            function changeFavicon(src) {
                var link = document.createElement('link');
                var oldLink = document.getElementById('elm-favicon');
                link.id = 'elm-favicon';
                link.rel = 'shortcut icon';
                link.href = src;
                if (oldLink) {
                    document.head.removeChild(oldLink);
                }
                document.head.appendChild(link);
            }
        }


        function filterDeadInputs(inputs) {
            var temp = [];
            for (var i = inputs.length; i--; ) {
                if (isAlive(inputs[i])) temp.push(inputs[i]);
            }
            return temp;
        }


        function isAlive(input) {
            if (!('defaultNumberOfKids' in input)) return true;
            var len = input.kids.length;
            if (len === 0) return false;
            if (len > input.defaultNumberOfKids) return true;
            var alive = false;
            for (var i = len; i--; ) {
                alive = alive || isAlive(input.kids[i]);
            }
            return alive;
        }


        ////  RENDERING  ////

        function initGraphics(elm, Module) {
            if (!('main' in Module)) {
                throw new Error("'main' is missing! What do I display?!");
            }

            var signalGraph = Module.main;

            // make sure the signal graph is actually a signal & extract the visual model
            var Signal = Elm.Signal.make(elm);
            if (!('recv' in signalGraph)) {
                signalGraph = Signal.constant(signalGraph);
            }
            var initialScene = signalGraph.value;

            // Add the initialScene to the DOM
            var Element = Elm.Native.Graphics.Element.make(elm);
            elm.node.appendChild(Element.render(initialScene));

            var _requestAnimationFrame =
                typeof requestAnimationFrame !== 'undefined'
                    ? requestAnimationFrame
                    : function(cb) { setTimeout(cb, 1000/60); }
                    ;

            // domUpdate is called whenever the main Signal changes.
            //
            // domUpdate and drawCallback implement a small state machine in order
            // to schedule only 1 draw per animation frame. This enforces that
            // once draw has been called, it will not be called again until the
            // next frame.
            //
            // drawCallback is scheduled whenever
            // 1. The state transitions from PENDING_REQUEST to EXTRA_REQUEST, or
            // 2. The state transitions from NO_REQUEST to PENDING_REQUEST
            //
            // Invariants:
            // 1. In the NO_REQUEST state, there is never a scheduled drawCallback.
            // 2. In the PENDING_REQUEST and EXTRA_REQUEST states, there is always exactly 1
            //    scheduled drawCallback.
            var NO_REQUEST = 0;
            var PENDING_REQUEST = 1;
            var EXTRA_REQUEST = 2;
            var state = NO_REQUEST;
            var savedScene = initialScene;
            var scheduledScene = initialScene;

            function domUpdate(newScene) {
                scheduledScene = newScene;

                switch (state) {
                    case NO_REQUEST:
                        _requestAnimationFrame(drawCallback);
                        state = PENDING_REQUEST;
                        return;
                    case PENDING_REQUEST:
                        state = PENDING_REQUEST;
                        return;
                    case EXTRA_REQUEST:
                        state = PENDING_REQUEST;
                        return;
                }
            }

            function drawCallback() {
                switch (state) {
                    case NO_REQUEST:
                        // This state should not be possible. How can there be no
                        // request, yet somehow we are actively fulfilling a
                        // request?
                        throw new Error(
                            "Unexpected draw callback.\n" +
                            "Please report this to <https://github.com/elm-lang/core/issues>."
                        );

                    case PENDING_REQUEST:
                        // At this point, we do not *know* that another frame is
                        // needed, but we make an extra request to rAF just in
                        // case. It's possible to drop a frame if rAF is called
                        // too late, so we just do it preemptively.
                        _requestAnimationFrame(drawCallback);
                        state = EXTRA_REQUEST;

                        // There's also stuff we definitely need to draw.
                        draw();
                        return;

                    case EXTRA_REQUEST:
                        // Turns out the extra request was not needed, so we will
                        // stop calling rAF. No reason to call it all the time if
                        // no one needs it.
                        state = NO_REQUEST;
                        return;
                }
            }

            function draw() {
                Element.updateAndReplace(elm.node.firstChild, savedScene, scheduledScene);
                if (elm.Native.Window) {
                    elm.Native.Window.values.resizeIfNeeded();
                }
                savedScene = scheduledScene;
            }

            var renderer = A2(Signal.map, domUpdate, signalGraph);

            // must check for resize after 'renderer' is created so
            // that changes show up.
            if (elm.Native.Window) {
                elm.Native.Window.values.resizeIfNeeded();
            }

            return renderer;
        }

        //// HOT SWAPPING ////

        // Returns boolean indicating if the swap was successful.
        // Requires that the two signal graphs have exactly the same
        // structure.
        function hotSwap(from, to) {
            function similar(nodeOld,nodeNew) {
                var idOkay = nodeOld.id === nodeNew.id;
                var lengthOkay = nodeOld.kids.length === nodeNew.kids.length;
                return idOkay && lengthOkay;
            }
            function swap(nodeOld,nodeNew) {
                nodeNew.value = nodeOld.value;
                return true;
            }
            var canSwap = depthFirstTraversals(similar, from.inputs, to.inputs);
            if (canSwap) {
                depthFirstTraversals(swap, from.inputs, to.inputs);
            }
            from.node.parentNode.replaceChild(to.node, from.node);

            return canSwap;
        }

        // Returns false if the node operation f ever fails.
        function depthFirstTraversals(f, queueOld, queueNew) {
            if (queueOld.length !== queueNew.length) return false;
            queueOld = queueOld.slice(0);
            queueNew = queueNew.slice(0);

            var seen = [];
            while (queueOld.length > 0 && queueNew.length > 0) {
                var nodeOld = queueOld.pop();
                var nodeNew = queueNew.pop();
                if (seen.indexOf(nodeOld.id) < 0) {
                    if (!f(nodeOld, nodeNew)) return false;
                    queueOld = queueOld.concat(nodeOld.kids);
                    queueNew = queueNew.concat(nodeNew.kids);
                    seen.push(nodeOld.id);
                }
            }
            return true;
        }
    }());

    function F2(fun) {
        function wrapper(a) { return function(b) { return fun(a,b) } }
        wrapper.arity = 2;
        wrapper.func = fun;
        return wrapper;
    }

    function F3(fun) {
        function wrapper(a) {
            return function(b) { return function(c) { return fun(a,b,c) }}
        }
        wrapper.arity = 3;
        wrapper.func = fun;
        return wrapper;
    }

    function F4(fun) {
        function wrapper(a) { return function(b) { return function(c) {
            return function(d) { return fun(a,b,c,d) }}}
        }
        wrapper.arity = 4;
        wrapper.func = fun;
        return wrapper;
    }

    function F5(fun) {
        function wrapper(a) { return function(b) { return function(c) {
            return function(d) { return function(e) { return fun(a,b,c,d,e) }}}}
        }
        wrapper.arity = 5;
        wrapper.func = fun;
        return wrapper;
    }

    function F6(fun) {
        function wrapper(a) { return function(b) { return function(c) {
            return function(d) { return function(e) { return function(f) {
            return fun(a,b,c,d,e,f) }}}}}
        }
        wrapper.arity = 6;
        wrapper.func = fun;
        return wrapper;
    }

    function F7(fun) {
        function wrapper(a) { return function(b) { return function(c) {
            return function(d) { return function(e) { return function(f) {
            return function(g) { return fun(a,b,c,d,e,f,g) }}}}}}
        }
        wrapper.arity = 7;
        wrapper.func = fun;
        return wrapper;
    }

    function F8(fun) {
        function wrapper(a) { return function(b) { return function(c) {
            return function(d) { return function(e) { return function(f) {
            return function(g) { return function(h) {
            return fun(a,b,c,d,e,f,g,h)}}}}}}}
        }
        wrapper.arity = 8;
        wrapper.func = fun;
        return wrapper;
    }

    function F9(fun) {
        function wrapper(a) { return function(b) { return function(c) {
            return function(d) { return function(e) { return function(f) {
            return function(g) { return function(h) { return function(i) {
            return fun(a,b,c,d,e,f,g,h,i) }}}}}}}}
        }
        wrapper.arity = 9;
        wrapper.func = fun;
        return wrapper;
    }

    function A2(fun,a,b) {
        return fun.arity === 2
            ? fun.func(a,b)
            : fun(a)(b);
    }
    function A3(fun,a,b,c) {
        return fun.arity === 3
            ? fun.func(a,b,c)
            : fun(a)(b)(c);
    }
    function A4(fun,a,b,c,d) {
        return fun.arity === 4
            ? fun.func(a,b,c,d)
            : fun(a)(b)(c)(d);
    }
    function A5(fun,a,b,c,d,e) {
        return fun.arity === 5
            ? fun.func(a,b,c,d,e)
            : fun(a)(b)(c)(d)(e);
    }
    function A6(fun,a,b,c,d,e,f) {
        return fun.arity === 6
            ? fun.func(a,b,c,d,e,f)
            : fun(a)(b)(c)(d)(e)(f);
    }
    function A7(fun,a,b,c,d,e,f,g) {
        return fun.arity === 7
            ? fun.func(a,b,c,d,e,f,g)
            : fun(a)(b)(c)(d)(e)(f)(g);
    }
    function A8(fun,a,b,c,d,e,f,g,h) {
        return fun.arity === 8
            ? fun.func(a,b,c,d,e,f,g,h)
            : fun(a)(b)(c)(d)(e)(f)(g)(h);
    }
    function A9(fun,a,b,c,d,e,f,g,h,i) {
        return fun.arity === 9
            ? fun.func(a,b,c,d,e,f,g,h,i)
            : fun(a)(b)(c)(d)(e)(f)(g)(h)(i);
    }
}
Elm.Native.Show = {};
Elm.Native.Show.make = function(elm) {
    elm.Native = elm.Native || {};
    elm.Native.Show = elm.Native.Show || {};
    if (elm.Native.Show.values) return elm.Native.Show.values;

    var _Array;
    var Dict;
    var List;
    var Utils = Elm.Native.Utils.make(elm);

    var toString = function(v) {
        var type = typeof v;
        if (type === "function") {
            var name = v.func ? v.func.name : v.name;
            return '<function' + (name === '' ? '' : ': ') + name + '>';
        }
        else if (type === "boolean") {
            return v ? "True" : "False";
        }
        else if (type === "number") {
            return v + "";
        }
        else if ((v instanceof String) && v.isChar) {
            return "'" + addSlashes(v) + "'";
        }
        else if (type === "string") {
            return '"' + addSlashes(v) + '"';
        }
        else if (type === "object" && '_' in v && probablyPublic(v)) {
            var output = [];
            for (var k in v._) {
                for (var i = v._[k].length; i--; ) {
                    output.push(k + " = " + toString(v._[k][i]));
                }
            }
            for (var k in v) {
                if (k === '_') continue;
                output.push(k + " = " + toString(v[k]));
            }
            if (output.length === 0) {
                return "{}";
            }
            return "{ " + output.join(", ") + " }";
        }
        else if (type === "object" && 'ctor' in v) {
            if (v.ctor.substring(0,6) === "_Tuple") {
                var output = [];
                for (var k in v) {
                    if (k === 'ctor') continue;
                    output.push(toString(v[k]));
                }
                return "(" + output.join(",") + ")";
            }
            else if (v.ctor === "_Array") {
                if (!_Array) {
                    _Array = Elm.Array.make(elm);
                }
                var list = _Array.toList(v);
                return "Array.fromList " + toString(list);
            }
            else if (v.ctor === "::") {
                var output = '[' + toString(v._0);
                v = v._1;
                while (v.ctor === "::") {
                    output += "," + toString(v._0);
                    v = v._1;
                }
                return output + ']';
            }
            else if (v.ctor === "[]") {
                return "[]";
            }
            else if (v.ctor === "RBNode" || v.ctor === "RBEmpty") {
                if (!Dict) {
                    Dict = Elm.Dict.make(elm);
                }
                if (!List) {
                    List = Elm.List.make(elm);
                }
                var list = Dict.toList(v);
                var name = "Dict";
                if (list.ctor === "::" && list._0._1.ctor === "_Tuple0") {
                    name = "Set";
                    list = A2(List.map, function(x){return x._0}, list);
                }
                return name + ".fromList " + toString(list);
            }
            else {
                var output = "";
                for (var i in v) {
                    if (i === 'ctor') continue;
                    var str = toString(v[i]);
                    var parenless = str[0] === '{' || str[0] === '<' || str.indexOf(' ') < 0;
                    output += ' ' + (parenless ? str : '(' + str + ')');
                }
                return v.ctor + output;
            }
        }
        if (type === 'object' && 'recv' in v) {
            return '<signal>';
        }
        return "<internal structure>";
    };

    function addSlashes(str) {
        return str.replace(/\\/g, '\\\\')
                  .replace(/\n/g, '\\n')
                  .replace(/\t/g, '\\t')
                  .replace(/\r/g, '\\r')
                  .replace(/\v/g, '\\v')
                  .replace(/\0/g, '\\0')
                  .replace(/\'/g, "\\'")
                  .replace(/\"/g, '\\"');
    }

    function probablyPublic(v) {
        var keys = Object.keys(v);
        var len = keys.length;
        if (len === 3
            && 'props' in v
            && 'element' in v)
        {
            return false;
        }
        else if (len === 5
            && 'horizontal' in v
            && 'vertical' in v
            && 'x' in v
            && 'y' in v)
        {
            return false;
        }
        else if (len === 7
            && 'theta' in v
            && 'scale' in v
            && 'x' in v
            && 'y' in v
            && 'alpha' in v
            && 'form' in v)
        {
            return false;
        }
        return true;
    }

    return elm.Native.Show.values = {
        toString: toString
    };
};


Elm.Native.Signal = {};
Elm.Native.Signal.make = function(localRuntime) {

  localRuntime.Native = localRuntime.Native || {};
  localRuntime.Native.Signal = localRuntime.Native.Signal || {};
  if (localRuntime.Native.Signal.values) {
      return localRuntime.Native.Signal.values;
  }

  var Utils = Elm.Native.Utils.make(localRuntime);

  function broadcastToKids(node, timestep, changed) {
    var kids = node.kids;
    for (var i = kids.length; i--; ) {
      kids[i].recv(timestep, changed, node.id);
    }
  }

  function Input(base) {
    this.id = Utils.guid();
    this.value = base;
    this.kids = [];
    this.defaultNumberOfKids = 0;
    this.recv = function(timestep, eid, v) {
      var changed = eid === this.id;
      if (changed) {
        this.value = v;
      }
      broadcastToKids(this, timestep, changed);
      return changed;
    };
    localRuntime.inputs.push(this);
  }

  function LiftN(update, args) {
    this.id = Utils.guid();
    this.value = update();
    this.kids = [];

    var n = args.length;
    var count = 0;
    var isChanged = false;

    this.recv = function(timestep, changed, parentID) {
      ++count;
      if (changed) { isChanged = true; }
      if (count == n) {
        if (isChanged) { this.value = update(); }
        broadcastToKids(this, timestep, isChanged);
        isChanged = false;
        count = 0;
      }
    };
    for (var i = n; i--; ) { args[i].kids.push(this); }
  }

  function map(func, a) {
    function update() { return func(a.value); }
    return new LiftN(update, [a]);
  }
  function map2(func, a, b) {
    function update() { return A2( func, a.value, b.value ); }
    return new LiftN(update, [a,b]);
  }
  function map3(func, a, b, c) {
    function update() { return A3( func, a.value, b.value, c.value ); }
    return new LiftN(update, [a,b,c]);
  }
  function map4(func, a, b, c, d) {
    function update() { return A4( func, a.value, b.value, c.value, d.value ); }
    return new LiftN(update, [a,b,c,d]);
  }
  function map5(func, a, b, c, d, e) {
    function update() { return A5( func, a.value, b.value, c.value, d.value, e.value ); }
    return new LiftN(update, [a,b,c,d,e]);
  }

  function Foldp(step, state, input) {
    this.id = Utils.guid();
    this.value = state;
    this.kids = [];

    this.recv = function(timestep, changed, parentID) {
      if (changed) {
          this.value = A2( step, input.value, this.value );
      }
      broadcastToKids(this, timestep, changed);
    };
    input.kids.push(this);
  }

  function foldp(step, state, input) {
      return new Foldp(step, state, input);
  }

  function DropIf(pred,base,input) {
    this.id = Utils.guid();
    this.value = pred(input.value) ? base : input.value;
    this.kids = [];
    this.recv = function(timestep, changed, parentID) {
      var chng = changed && !pred(input.value);
      if (chng) { this.value = input.value; }
      broadcastToKids(this, timestep, chng);
    };
    input.kids.push(this);
  }

  function DropRepeats(input) {
    this.id = Utils.guid();
    this.value = input.value;
    this.kids = [];
    this.recv = function(timestep, changed, parentID) {
      var chng = changed && !Utils.eq(this.value,input.value);
      if (chng) { this.value = input.value; }
      broadcastToKids(this, timestep, chng);
    };
    input.kids.push(this);
  }

  function timestamp(a) {
    function update() { return Utils.Tuple2(localRuntime.timer.now(), a.value); }
    return new LiftN(update, [a]);
  }

  function SampleOn(s1,s2) {
    this.id = Utils.guid();
    this.value = s2.value;
    this.kids = [];

    var count = 0;
    var isChanged = false;

    this.recv = function(timestep, changed, parentID) {
      if (parentID === s1.id) isChanged = changed;
      ++count;
      if (count == 2) {
        if (isChanged) { this.value = s2.value; }
        broadcastToKids(this, timestep, isChanged);
        count = 0;
        isChanged = false;
      }
    };
    s1.kids.push(this);
    s2.kids.push(this);
  }

  function sampleOn(s1,s2) { return new SampleOn(s1,s2); }

  function delay(t,s) {
      var delayed = new Input(s.value);
      var firstEvent = true;
      function update(v) {
        if (firstEvent) {
            firstEvent = false; return;
        }
        setTimeout(function() {
            localRuntime.notify(delayed.id, v);
        }, t);
      }
      function first(a,b) { return a; }
      return new SampleOn(delayed, map2(F2(first), delayed, map(update,s)));
  }

  function Merge(s1,s2) {
      this.id = Utils.guid();
      this.value = s1.value;
      this.kids = [];

      var next = null;
      var count = 0;
      var isChanged = false;

      this.recv = function(timestep, changed, parentID) {
        ++count;
        if (changed) {
            isChanged = true;
            if (parentID == s2.id && next === null) { next = s2.value; }
            if (parentID == s1.id) { next = s1.value; }
        }

        if (count == 2) {
            if (isChanged) { this.value = next; next = null; }
            broadcastToKids(this, timestep, isChanged);
            isChanged = false;
            count = 0;
        }
      };
      s1.kids.push(this);
      s2.kids.push(this);
  }

  function merge(s1,s2) {
      return new Merge(s1,s2);
  }


    // SIGNAL INPUTS

    function input(initialValue) {
        return new Input(initialValue);
    }

    function send(input, value) {
        return function() {
            localRuntime.notify(input.id, value);
        };
    }

    function subscribe(input) {
        return input;
    }


  return localRuntime.Native.Signal.values = {
    constant : function(v) { return new Input(v); },
    map  : F2(map ),
    map2 : F3(map2),
    map3 : F4(map3),
    map4 : F5(map4),
    map5 : F6(map5),
    foldp : F3(foldp),
    delay : F2(delay),
    merge : F2(merge),
    keepIf : F3(function(pred,base,sig) {
      return new DropIf(function(x) {return !pred(x);},base,sig); }),
    dropIf : F3(function(pred,base,sig) { return new DropIf(pred,base,sig); }),
    dropRepeats : function(s) { return new DropRepeats(s);},
    sampleOn : F2(sampleOn),
    timestamp : timestamp,
    input: input,
    send: F2(send),
    subscribe: subscribe
  };
};

Elm.Native.String = {};
Elm.Native.String.make = function(elm) {
    elm.Native = elm.Native || {};
    elm.Native.String = elm.Native.String || {};
    if (elm.Native.String.values) return elm.Native.String.values;
    if ('values' in Elm.Native.String) {
        return elm.Native.String.values = Elm.Native.String.values;
    }

    var Char = Elm.Char.make(elm);
    var List = Elm.Native.List.make(elm);
    var Maybe = Elm.Maybe.make(elm);
    var Result = Elm.Result.make(elm);
    var Utils = Elm.Native.Utils.make(elm);

    function isEmpty(str) {
        return str.length === 0;
    }
    function cons(chr,str) {
        return chr + str;
    }
    function uncons(str) {
        var hd;
        return (hd = str[0])
            ? Maybe.Just(Utils.Tuple2(Utils.chr(hd), str.slice(1)))
            : Maybe.Nothing;
    }
    function append(a,b) {
        return a + b;
    }
    function concat(strs) {
        return List.toArray(strs).join('');
    }
    function length(str) {
        return str.length;
    }
    function map(f,str) {
        var out = str.split('');
        for (var i = out.length; i--; ) {
            out[i] = f(Utils.chr(out[i]));
        }
        return out.join('');
    }
    function filter(pred,str) {
        return str.split('').map(Utils.chr).filter(pred).join('');
    }
    function reverse(str) {
        return str.split('').reverse().join('');
    }
    function foldl(f,b,str) {
        var len = str.length;
        for (var i = 0; i < len; ++i) {
            b = A2(f, Utils.chr(str[i]), b);
        }
        return b;
    }
    function foldr(f,b,str) {
        for (var i = str.length; i--; ) {
            b = A2(f, Utils.chr(str[i]), b);
        }
        return b;
    }

    function split(sep, str) {
        return List.fromArray(str.split(sep));
    }
    function join(sep, strs) {
        return List.toArray(strs).join(sep);
    }
    function repeat(n, str) {
        var result = '';
        while (n > 0) {
            if (n & 1) result += str;
            n >>= 1, str += str;
        }
        return result;
    }

    function slice(start, end, str) {
        return str.slice(start,end);
    }
    function left(n, str) {
        return n < 1 ? "" : str.slice(0,n);
    }
    function right(n, str) {
        return n < 1 ? "" : str.slice(-n);
    }
    function dropLeft(n, str) {
        return n < 1 ? str : str.slice(n);
    }
    function dropRight(n, str) {
        return n < 1 ? str : str.slice(0,-n);
    }

    function pad(n,chr,str) {
        var half = (n - str.length) / 2;
        return repeat(Math.ceil(half),chr) + str + repeat(half|0,chr);
    }
    function padRight(n,chr,str) {
        return str + repeat(n - str.length, chr);
    }
    function padLeft(n,chr,str) {
        return repeat(n - str.length, chr) + str;
    }

    function trim(str) {
        return str.trim();
    }
    function trimLeft(str) {
        return str.trimLeft();
    }
    function trimRight(str) {
        return str.trimRight();
    }

    function words(str) {
        return List.fromArray(str.trim().split(/\s+/g));
    }
    function lines(str) {
        return List.fromArray(str.split(/\r\n|\r|\n/g));
    }

    function toUpper(str) {
        return str.toUpperCase();
    }
    function toLower(str) {
        return str.toLowerCase();
    }

    function any(pred, str) {
        for (var i = str.length; i--; ) {
            if (pred(Utils.chr(str[i]))) return true;
        }
        return false;
    }
    function all(pred, str) {
        for (var i = str.length; i--; ) {
            if (!pred(Utils.chr(str[i]))) return false;
        }
        return true;
    }

    function contains(sub, str) {
        return str.indexOf(sub) > -1;
    }
    function startsWith(sub, str) {
        return str.indexOf(sub) === 0;
    }
    function endsWith(sub, str) {
        return str.length >= sub.length &&
               str.lastIndexOf(sub) === str.length - sub.length;
    }
    function indexes(sub, str) {
        var subLen = sub.length;
        var i = 0;
        var is = [];
        while ((i = str.indexOf(sub, i)) > -1) {
            is.push(i);
            i = i + subLen;
        }
        return List.fromArray(is);
    }

    function toInt(s) {
        var len = s.length;
        if (len === 0) {
            return Result.Err("could not convert string '" + s + "' to an Int" );
        }
        var start = 0;
        if (s[0] == '-') {
            if (len === 1) {
                return Result.Err("could not convert string '" + s + "' to an Int" );
            }
            start = 1;
        }
        for (var i = start; i < len; ++i) {
            if (!Char.isDigit(s[i])) {
                return Result.Err("could not convert string '" + s + "' to an Int" );
            }
        }
        return Result.Ok(parseInt(s, 10));
    }

    function toFloat(s) {
        var len = s.length;
        if (len === 0) {
            return Result.Err("could not convert string '" + s + "' to a Float" );
        }
        var start = 0;
        if (s[0] == '-') {
            if (len === 1) {
                return Result.Err("could not convert string '" + s + "' to a Float" );
            }
            start = 1;
        }
        var dotCount = 0;
        for (var i = start; i < len; ++i) {
            if (Char.isDigit(s[i])) {
                continue;
            }
            if (s[i] === '.') {
                dotCount += 1;
                if (dotCount <= 1) {
                    continue;
                }
            }
            return Result.Err("could not convert string '" + s + "' to a Float" );
        }
        return Result.Ok(parseFloat(s));
    }

    function toList(str) {
        return List.fromArray(str.split('').map(Utils.chr));
    }
    function fromList(chars) {
        return List.toArray(chars).join('');
    }

    return Elm.Native.String.values = {
        isEmpty: isEmpty,
        cons: F2(cons),
        uncons: uncons,
        append: F2(append),
        concat: concat,
        length: length,
        map: F2(map),
        filter: F2(filter),
        reverse: reverse,
        foldl: F3(foldl),
        foldr: F3(foldr),

        split: F2(split),
        join: F2(join),
        repeat: F2(repeat),

        slice: F3(slice),
        left: F2(left),
        right: F2(right),
        dropLeft: F2(dropLeft),
        dropRight: F2(dropRight),

        pad: F3(pad),
        padLeft: F3(padLeft),
        padRight: F3(padRight),

        trim: trim,
        trimLeft: trimLeft,
        trimRight: trimRight,

        words: words,
        lines: lines,

        toUpper: toUpper,
        toLower: toLower,

        any: F2(any),
        all: F2(all),

        contains: F2(contains),
        startsWith: F2(startsWith),
        endsWith: F2(endsWith),
        indexes: F2(indexes),

        toInt: toInt,
        toFloat: toFloat,
        toList: toList,
        fromList: fromList
    };
};

Elm.Native.Text = {};
Elm.Native.Text.make = function(elm) {
    elm.Native = elm.Native || {};
    elm.Native.Text = elm.Native.Text || {};
    if (elm.Native.Text.values) return elm.Native.Text.values;

    var toCss = Elm.Native.Color.make(elm).toCss;
    var Element = Elm.Graphics.Element.make(elm);
    var NativeElement = Elm.Native.Graphics.Element.make(elm);
    var List = Elm.Native.List.make(elm);
    var Utils = Elm.Native.Utils.make(elm);

    function makeSpaces(s) {
        if (s.length == 0) { return s; }
        var arr = s.split('');
        if (arr[0] == ' ') { arr[0] = "&nbsp;" }      
        for (var i = arr.length; --i; ) {
            if (arr[i][0] == ' ' && arr[i-1] == ' ') {
                arr[i-1] = arr[i-1] + arr[i];
                arr[i] = '';
            }
        }
        for (var i = arr.length; i--; ) {
            if (arr[i].length > 1 && arr[i][0] == ' ') {
                var spaces = arr[i].split('');
                for (var j = spaces.length - 2; j >= 0; j -= 2) {
                    spaces[j] = '&nbsp;';
                }
                arr[i] = spaces.join('');
            }
        }
        arr = arr.join('');
        if (arr[arr.length-1] === " ") {
            return arr.slice(0,-1) + '&nbsp;';
        }
        return arr;
    }

    function properEscape(str) {
        if (str.length == 0) return str;
        str = str //.replace(/&/g,  "&#38;")
            .replace(/"/g,  '&#34;')
            .replace(/'/g,  "&#39;")
            .replace(/</g,  "&#60;")
            .replace(/>/g,  "&#62;")
            .replace(/\n/g, "<br/>");
        var arr = str.split('<br/>');
        for (var i = arr.length; i--; ) {
            arr[i] = makeSpaces(arr[i]);
        }
        return arr.join('<br/>');
    }

    function fromString(str) {
        return Utils.txt(properEscape(str));
    }

    function append(xs, ys) {
        return Utils.txt(Utils.makeText(xs) + Utils.makeText(ys));
    }

    // conversions from Elm values to CSS
    function toTypefaces(list) {
        var typefaces = List.toArray(list);
        for (var i = typefaces.length; i--; ) {
            var typeface = typefaces[i];
            if (typeface.indexOf(' ') > -1) {
                typefaces[i] = "'" + typeface + "'";
            }
        }
        return typefaces.join(',');
    }
    function toLine(line) {
        var ctor = line.ctor;
        return ctor === 'Under' ? 'underline' :
               ctor === 'Over'  ? 'overline'  : 'line-through';
    }

    // setting styles of Text
    function style(style, text) {
        var newText = '<span style="color:' + toCss(style.color) + ';'
        if (style.typeface.ctor !== '[]') {
            newText += 'font-family:' + toTypefaces(style.typeface) + ';'
        }
        if (style.height.ctor !== "Nothing") {
            newText += 'font-size:' + style.height._0 + 'px;';
        }
        if (style.bold) {
            newText += 'font-weight:bold;';
        }
        if (style.italic) {
            newText += 'font-style:italic;';
        }
        if (style.line.ctor !== 'Nothing') {
            newText += 'text-decoration:' + toLine(style.line._0) + ';';
        }
        newText += '">' + Utils.makeText(text) + '</span>'
        return Utils.txt(newText);
    }
    function height(px, text) {
        return { style: 'font-size:' + px + 'px;', text:text }
    }
    function typeface(names, text) {
        return { style: 'font-family:' + toTypefaces(names) + ';', text:text }
    }
    function monospace(text) {
        return { style: 'font-family:monospace;', text:text }
    }
    function italic(text) {
        return { style: 'font-style:italic;', text:text }
    }
    function bold(text) {
        return { style: 'font-weight:bold;', text:text }
    }
    function link(href, text) {
        return { href: fromString(href), text:text };
    }
    function line(line, text) {
        return { style: 'text-decoration:' + toLine(line) + ';', text:text };
    }

    function color(color, text) {
        return { style: 'color:' + toCss(color) + ';', text:text };
    }

    function block(align) {
        return function(text) {
            var raw = {
                ctor :'RawHtml',
                html : Utils.makeText(text),
                align: align,
                guid : null
            };
            var pos = A2(NativeElement.htmlHeight, 0, raw);
            return A3(Element.newElement, pos._0, pos._1, raw);
        }
    }

    function markdown(text, guid) {
        var raw = {
            ctor:'RawHtml',
            html: text,
            align: null,
            guid: guid
        };
        var pos = A2(NativeElement.htmlHeight, 0, raw);
        return A3(Element.newElement, pos._0, pos._1, raw);
    }

    return elm.Native.Text.values = {
        fromString: fromString,
        append: F2(append),

        height : F2(height),
        italic : italic,
        bold : bold,
        line : F2(line),
        monospace : monospace,
        typeface : F2(typeface),
        color : F2(color),
        link : F2(link),
        style : F2(style),

        leftAligned  : block('left'),
        rightAligned : block('right'),
        centered     : block('center'),
        justified    : block('justify'),
        markdown     : markdown,

        toTypefaces:toTypefaces,
        toLine:toLine
    };
};

Elm.Native.Time = {};
Elm.Native.Time.make = function(elm) {

  elm.Native = elm.Native || {};
  elm.Native.Time = elm.Native.Time || {};
  if (elm.Native.Time.values) return elm.Native.Time.values;

  var Signal = Elm.Signal.make(elm);
  var NS = Elm.Native.Signal.make(elm);
  var Maybe = Elm.Maybe.make(elm);
  var Utils = Elm.Native.Utils.make(elm);

  function fpsWhen(desiredFPS, isOn) {
    var msPerFrame = 1000 / desiredFPS;
    var prev = elm.timer.now(), curr = prev, diff = 0, wasOn = true;
    var ticker = NS.input(diff);
    function tick(zero) {
      return function() {
        curr = elm.timer.now();
        diff = zero ? 0 : curr - prev;
        if (prev > curr) {
          diff = 0;
        }
        prev = curr;
        elm.notify(ticker.id, diff);
      };
    }
    var timeoutID = 0;
    function f(isOn, t) {
      if (isOn) {
        timeoutID = elm.setTimeout(tick(!wasOn && isOn), msPerFrame);
      } else if (wasOn) {
        clearTimeout(timeoutID);
      }
      wasOn = isOn;
      return t;
    }
    return A3( Signal.map2, F2(f), isOn, ticker );
  }

  function every(t) {
    var clock = NS.input(elm.timer.now());
    function tellTime() {
        elm.notify(clock.id, elm.timer.now());
    }
    setInterval(tellTime, t);
    return clock;
  }

  function read(s) {
      var t = Date.parse(s);
      return isNaN(t) ? Maybe.Nothing : Maybe.Just(t);
  }
  return elm.Native.Time.values = {
      fpsWhen : F2(fpsWhen),
      fps : function(t) { return fpsWhen(t, Signal.constant(true)); },
      every : every,
      delay : NS.delay,
      timestamp : NS.timestamp,
      toDate : function(t) { return new window.Date(t); },
      read   : read
  };

};

Elm.Native.Transform2D = {};
Elm.Native.Transform2D.make = function(elm) {

 elm.Native = elm.Native || {};
 elm.Native.Transform2D = elm.Native.Transform2D || {};
 if (elm.Native.Transform2D.values) return elm.Native.Transform2D.values;

 var A;
 if (typeof Float32Array === 'undefined') {
     A = function(arr) {
         this.length = arr.length;
         this[0] = arr[0];
         this[1] = arr[1];
         this[2] = arr[2];
         this[3] = arr[3];
         this[4] = arr[4];
         this[5] = arr[5];
     };
 } else {
     A = Float32Array;
 }

 // layout of matrix in an array is
 //
 //   | m11 m12 dx |
 //   | m21 m22 dy |
 //   |  0   0   1 |
 //
 //  new A([ m11, m12, dx, m21, m22, dy ])

 var identity = new A([1,0,0,0,1,0]);
 function matrix(m11, m12, m21, m22, dx, dy) {
     return new A([m11, m12, dx, m21, m22, dy]);
 }
 function rotation(t) {
     var c = Math.cos(t);
     var s = Math.sin(t);
     return new A([c, -s, 0, s, c, 0]);
 }
 function rotate(t,m) {
     var c = Math.cos(t);
     var s = Math.sin(t);
     var m11 = m[0], m12 = m[1], m21 = m[3], m22 = m[4];
     return new A([m11*c + m12*s, -m11*s + m12*c, m[2],
                   m21*c + m22*s, -m21*s + m22*c, m[5]]);
 }
 /*
 function move(xy,m) {
     var x = xy._0;
     var y = xy._1;
     var m11 = m[0], m12 = m[1], m21 = m[3], m22 = m[4];
     return new A([m11, m12, m11*x + m12*y + m[2],
                   m21, m22, m21*x + m22*y + m[5]]);
 }
 function scale(s,m) { return new A([m[0]*s, m[1]*s, m[2], m[3]*s, m[4]*s, m[5]]); }
 function scaleX(x,m) { return new A([m[0]*x, m[1], m[2], m[3]*x, m[4], m[5]]); }
 function scaleY(y,m) { return new A([m[0], m[1]*y, m[2], m[3], m[4]*y, m[5]]); }
 function reflectX(m) { return new A([-m[0], m[1], m[2], -m[3], m[4], m[5]]); }
 function reflectY(m) { return new A([m[0], -m[1], m[2], m[3], -m[4], m[5]]); }

 function transform(m11, m21, m12, m22, mdx, mdy, n) {
     var n11 = n[0], n12 = n[1], n21 = n[3], n22 = n[4], ndx = n[2], ndy = n[5];
     return new A([m11*n11 + m12*n21,
                   m11*n12 + m12*n22,
                   m11*ndx + m12*ndy + mdx,
                   m21*n11 + m22*n21,
                   m21*n12 + m22*n22,
                   m21*ndx + m22*ndy + mdy]);
 }
 */
 function multiply(m, n) {
     var m11 = m[0], m12 = m[1], m21 = m[3], m22 = m[4], mdx = m[2], mdy = m[5];
     var n11 = n[0], n12 = n[1], n21 = n[3], n22 = n[4], ndx = n[2], ndy = n[5];
     return new A([m11*n11 + m12*n21,
                   m11*n12 + m12*n22,
                   m11*ndx + m12*ndy + mdx,
                   m21*n11 + m22*n21,
                   m21*n12 + m22*n22,
                   m21*ndx + m22*ndy + mdy]);
 }

 return elm.Native.Transform2D.values = {
     identity:identity,
     matrix:F6(matrix),
     rotation:rotation,
     multiply:F2(multiply)
     /*
     transform:F7(transform),
     rotate:F2(rotate),
     move:F2(move),
     scale:F2(scale),
     scaleX:F2(scaleX),
     scaleY:F2(scaleY),
     reflectX:reflectX,
     reflectY:reflectY
     */
 };

};

Elm.Native = Elm.Native || {};
Elm.Native.Utils = {};
Elm.Native.Utils.make = function(localRuntime) {

    localRuntime.Native = localRuntime.Native || {};
    localRuntime.Native.Utils = localRuntime.Native.Utils || {};
    if (localRuntime.Native.Utils.values) {
        return localRuntime.Native.Utils.values;
    }

    function eq(l,r) {
        var stack = [{'x': l, 'y': r}]
        while (stack.length > 0) {
            var front = stack.pop();
            var x = front.x;
            var y = front.y;
            if (x === y) continue;
            if (typeof x === "object") {
                var c = 0;
                for (var i in x) {
                    ++c;
                    if (i in y) {
                        if (i !== 'ctor') {
                            stack.push({ 'x': x[i], 'y': y[i] });
                        }
                    } else {
                        return false;
                    }
                }
                if ('ctor' in x) {
                    stack.push({'x': x.ctor, 'y': y.ctor});
                }
                if (c !== Object.keys(y).length) {
                    return false;
                };
            } else if (typeof x === 'function') {
                throw new Error('Equality error: general function equality is ' +
                                'undecidable, and therefore, unsupported');
            } else {
                return false;
            }
        }
        return true;
    }

    // code in Generate/JavaScript.hs depends on the particular
    // integer values assigned to LT, EQ, and GT
    var LT = -1, EQ = 0, GT = 1, ord = ['LT','EQ','GT'];
    function compare(x,y) { return { ctor: ord[cmp(x,y)+1] } }
    function cmp(x,y) {
        var ord;
        if (typeof x !== 'object'){
            return x === y ? EQ : x < y ? LT : GT;
        }
        else if (x.isChar){
            var a = x.toString();
            var b = y.toString();
            return a === b ? EQ : a < b ? LT : GT;
        }
        else if (x.ctor === "::" || x.ctor === "[]") {
            while (true) {
                if (x.ctor === "[]" && y.ctor === "[]") return EQ;
                if (x.ctor !== y.ctor) return x.ctor === '[]' ? LT : GT;
                ord = cmp(x._0, y._0);
                if (ord !== EQ) return ord;
                x = x._1;
                y = y._1;
            }
        }
        else if (x.ctor.slice(0,6) === '_Tuple') {
            var n = x.ctor.slice(6) - 0;
            var err = 'cannot compare tuples with more than 6 elements.';
            if (n === 0) return EQ;
            if (n >= 1) { ord = cmp(x._0, y._0); if (ord !== EQ) return ord;
            if (n >= 2) { ord = cmp(x._1, y._1); if (ord !== EQ) return ord;
            if (n >= 3) { ord = cmp(x._2, y._2); if (ord !== EQ) return ord;
            if (n >= 4) { ord = cmp(x._3, y._3); if (ord !== EQ) return ord;
            if (n >= 5) { ord = cmp(x._4, y._4); if (ord !== EQ) return ord;
            if (n >= 6) { ord = cmp(x._5, y._5); if (ord !== EQ) return ord;
            if (n >= 7) throw new Error('Comparison error: ' + err); } } } } } }
            return EQ;
        }
        else {
            throw new Error('Comparison error: comparison is only defined on ints, ' +
                            'floats, times, chars, strings, lists of comparable values, ' +
                            'and tuples of comparable values.');
        }
    }


    var Tuple0 = { ctor: "_Tuple0" };
    function Tuple2(x,y) {
        return {
            ctor: "_Tuple2",
            _0: x,
            _1: y
        };
    }

    function chr(c) {
        var x = new String(c);
        x.isChar = true;
        return x;
    }

    function txt(str) {
        var t = new String(str);
        t.text = true;
        return t;
    }

    function makeText(text) {
        var style = '';
        var href = '';
        while (true) {
            if (text.style) {
                style += text.style;
                text = text.text;
                continue;
            }
            if (text.href) {
                href = text.href;
                text = text.text;
                continue;
            }
            if (href) {
                text = '<a href="' + href + '">' + text + '</a>';
            }
            if (style) {
                text = '<span style="' + style + '">' + text + '</span>';
            }
            return text;
        }
    }

    var count = 0;
    function guid(_) {
        return count++
    }

    function copy(oldRecord) {
        var newRecord = {};
        for (var key in oldRecord) {
            var value = key === '_'
                ? copy(oldRecord._)
                : oldRecord[key]
                ;
            newRecord[key] = value;
        }
        return newRecord;
    }

    function remove(key, oldRecord) {
        var record = copy(oldRecord);
        if (key in record._) {
            record[key] = record._[key][0];
            record._[key] = record._[key].slice(1);
            if (record._[key].length === 0) {
                delete record._[key];
            }
        } else {
            delete record[key];
        }
        return record;
    }

    function replace(keyValuePairs, oldRecord) {
        var record = copy(oldRecord);
        for (var i = keyValuePairs.length; i--; ) {
            var pair = keyValuePairs[i];
            record[pair[0]] = pair[1];
        }
        return record;
    }

    function insert(key, value, oldRecord) {
        var newRecord = copy(oldRecord);
        if (key in newRecord) {
            var values = newRecord._[key];
            var copiedValues = values ? values.slice(0) : [];
            newRecord._[key] = [newRecord[key]].concat(copiedValues);
        }
        newRecord[key] = value;
        return newRecord;
    }

    function getXY(e) {
        var posx = 0;
        var posy = 0;
        if (e.pageX || e.pageY) {
            posx = e.pageX;
            posy = e.pageY;
        } else if (e.clientX || e.clientY) {
            posx = e.clientX + document.body.scrollLeft + document.documentElement.scrollLeft;
            posy = e.clientY + document.body.scrollTop + document.documentElement.scrollTop;
        }

        if (localRuntime.isEmbed()) {
            var rect = localRuntime.node.getBoundingClientRect();
            var relx = rect.left + document.body.scrollLeft + document.documentElement.scrollLeft;
            var rely = rect.top + document.body.scrollTop + document.documentElement.scrollTop;
            // TODO: figure out if there is a way to avoid rounding here
            posx = posx - Math.round(relx) - localRuntime.node.clientLeft;
            posy = posy - Math.round(rely) - localRuntime.node.clientTop;
        }
        return Tuple2(posx, posy);
    }


    //// LIST STUFF ////

    var Nil = { ctor:'[]' };

    function Cons(hd,tl) {
        return {
            ctor: "::",
            _0: hd,
            _1: tl
        };
    }

    function append(xs,ys) {
        // append Text
        if (xs.text || ys.text) {
            return txt(makeText(xs) + makeText(ys));
        }

        // append Strings
        if (typeof xs === "string") {
            return xs + ys;
        }

        // append Lists
        if (xs.ctor === '[]') {
            return ys;
        }
        var root = Cons(xs._0, Nil);
        var curr = root;
        xs = xs._1;
        while (xs.ctor !== '[]') {
            curr._1 = Cons(xs._0, Nil);
            xs = xs._1;
            curr = curr._1;
        }
        curr._1 = ys;
        return root;
    }

    //// RUNTIME ERRORS ////

    function indent(lines) {
        return '\n' + lines.join('\n');
    }

    function badCase(moduleName, span) { 
        var msg = indent([
            'Non-exhaustive pattern match in case-expression.',
            'Make sure your patterns cover every case!'
        ]);
        throw new Error('Runtime error in module ' + moduleName + ' (' + span + ')' + msg);
    }

    function badIf(moduleName, span) { 
        var msg = indent([
            'Non-exhaustive pattern match in multi-way-if expression.',
            'It is best to use \'otherwise\' as the last branch of multi-way-if.'
        ]);
        throw new Error('Runtime error in module ' + moduleName + ' (' + span + ')' + msg);
    }


    function badPort(expected, received) { 
        var msg = indent([
            'Expecting ' + expected + ' but was given ',
            JSON.stringify(received)
        ]);
        throw new Error('Runtime error when sending values through a port.' + msg);
    }


    return localRuntime.Native.Utils.values = {
        eq:eq,
        cmp:cmp,
        compare:F2(compare),
        Tuple0:Tuple0,
        Tuple2:Tuple2,
        chr:chr,
        txt:txt,
        makeText:makeText,
        copy: copy,
        remove: remove,
        replace: replace,
        insert: insert,
        guid: guid,
        getXY: getXY,

        Nil: Nil,
        Cons: Cons,
        append: F2(append),

        badCase: badCase,
        badIf: badIf,
        badPort: badPort
    };
};

Elm.Native = Elm.Native || {};
Elm.Native.Window = {};
Elm.Native.Window.make = function(localRuntime) {

    localRuntime.Native = localRuntime.Native || {};
    localRuntime.Native.Window = localRuntime.Native.Window || {};
    if (localRuntime.Native.Window.values) {
        return localRuntime.Native.Window.values;
    }

    var Signal = Elm.Signal.make(localRuntime);
    var NS = Elm.Native.Signal.make(localRuntime);
    var Tuple2 = Elm.Native.Utils.make(localRuntime).Tuple2;

    function getWidth() {
        return localRuntime.node.clientWidth;
    }
    function getHeight() {
        if (localRuntime.isFullscreen()) {
            return window.innerHeight;
        }
        return localRuntime.node.clientHeight;
    }

    var dimensions = NS.input(Tuple2(getWidth(), getHeight()));
    dimensions.defaultNumberOfKids = 2;

    // Do not move width and height into Elm. By setting the default number of kids,
    // the resize listener can be detached.
    var width  = A2(Signal.map, function(p){return p._0;}, dimensions);
    width.defaultNumberOfKids = 0;

    var height = A2(Signal.map, function(p){return p._1;}, dimensions);
    height.defaultNumberOfKids = 0;

    function resizeIfNeeded() {
        // Do not trigger event if the dimensions have not changed.
        // This should be most of the time.
        var w = getWidth();
        var h = getHeight();
        if (dimensions.value._0 === w && dimensions.value._1 === h) return;

        setTimeout(function () {
            // Check again to see if the dimensions have changed.
            // It is conceivable that the dimensions have changed
            // again while some other event was being processed.
            var w = getWidth();
            var h = getHeight();
            if (dimensions.value._0 === w && dimensions.value._1 === h) return;
            localRuntime.notify(dimensions.id, Tuple2(w,h));
        }, 0);
    }
    localRuntime.addListener([dimensions.id], window, 'resize', resizeIfNeeded);

    return localRuntime.Native.Window.values = {
        dimensions: dimensions,
        width: width,
        height: height,
        resizeIfNeeded: resizeIfNeeded
    };

};

Elm.Render = Elm.Render || {};
Elm.Render.All = Elm.Render.All || {};
Elm.Render.All.make = function (_elm) {
   "use strict";
   _elm.Render = _elm.Render || {};
   _elm.Render.All = _elm.Render.All || {};
   if (_elm.Render.All.values)
   return _elm.Render.All.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _P = _N.Ports.make(_elm),
   $moduleName = "Render.All",
   $Basics = Elm.Basics.make(_elm),
   $Game = Elm.Game.make(_elm),
   $Graphics$Element = Elm.Graphics.Element.make(_elm),
   $Layout = Elm.Layout.make(_elm),
   $Maybe = Elm.Maybe.make(_elm),
   $Render$Controls = Elm.Render.Controls.make(_elm),
   $Render$Course = Elm.Render.Course.make(_elm),
   $Render$Dashboard = Elm.Render.Dashboard.make(_elm),
   $Render$Players = Elm.Render.Players.make(_elm),
   $Render$Utils = Elm.Render.Utils.make(_elm);
   var render = F2(function (_v0,
   gameState) {
      return function () {
         switch (_v0.ctor)
         {case "_Tuple2":
            return function () {
                 var controlsForm = $Maybe.withDefault($Render$Utils.emptyForm)(A2($Maybe.map,
                 A2($Render$Controls.renderControls,
                 gameState,
                 {ctor: "_Tuple2"
                 ,_0: _v0._0
                 ,_1: _v0._1}),
                 gameState.playerState));
                 var playersForm = $Render$Players.renderPlayers(gameState);
                 var courseForm = $Render$Course.renderCourse(gameState);
                 var layout = {_: {}
                              ,absStack: _L.fromArray([controlsForm])
                              ,dashboard: A2($Render$Dashboard.buildDashboard,
                              gameState,
                              {ctor: "_Tuple2"
                              ,_0: _v0._0
                              ,_1: _v0._1})
                              ,relStack: _L.fromArray([courseForm
                                                      ,playersForm])};
                 return A3($Layout.assembleLayout,
                 {ctor: "_Tuple2"
                 ,_0: _v0._0
                 ,_1: _v0._1},
                 gameState.center,
                 layout);
              }();}
         _U.badCase($moduleName,
         "between lines 35 and 47");
      }();
   });
   _elm.Render.All.values = {_op: _op
                            ,render: render};
   return _elm.Render.All.values;
};
Elm.Render = Elm.Render || {};
Elm.Render.Controls = Elm.Render.Controls || {};
Elm.Render.Controls.make = function (_elm) {
   "use strict";
   _elm.Render = _elm.Render || {};
   _elm.Render.Controls = _elm.Render.Controls || {};
   if (_elm.Render.Controls.values)
   return _elm.Render.Controls.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _P = _N.Ports.make(_elm),
   $moduleName = "Render.Controls",
   $Basics = Elm.Basics.make(_elm),
   $Core = Elm.Core.make(_elm),
   $Game = Elm.Game.make(_elm),
   $Geo = Elm.Geo.make(_elm),
   $Graphics$Collage = Elm.Graphics.Collage.make(_elm),
   $Maybe = Elm.Maybe.make(_elm),
   $Render$Utils = Elm.Render.Utils.make(_elm),
   $Text = Elm.Text.make(_elm);
   var gateHintTriangle = F2(function (s,
   isUpward) {
      return isUpward ? $Graphics$Collage.polygon(_L.fromArray([{ctor: "_Tuple2"
                                                                ,_0: 0
                                                                ,_1: 0}
                                                               ,{ctor: "_Tuple2"
                                                                ,_0: 0 - s
                                                                ,_1: (0 - s) * 1.5}
                                                               ,{ctor: "_Tuple2"
                                                                ,_0: s
                                                                ,_1: (0 - s) * 1.5}])) : $Graphics$Collage.polygon(_L.fromArray([{ctor: "_Tuple2"
                                                                                                                                 ,_0: 0
                                                                                                                                 ,_1: 0}
                                                                                                                                ,{ctor: "_Tuple2"
                                                                                                                                 ,_0: 0 - s
                                                                                                                                 ,_1: s * 1.5}
                                                                                                                                ,{ctor: "_Tuple2"
                                                                                                                                 ,_0: s
                                                                                                                                 ,_1: s * 1.5}]));
   });
   var topHint = A2(gateHintTriangle,
   5,
   true);
   var bottomHint = A2(gateHintTriangle,
   5,
   false);
   var gateHintLabel = function (d) {
      return $Graphics$Collage.toForm($Text.centered($Render$Utils.baseText(A2($Basics._op["++"],
      $Basics.toString(d),
      "m"))));
   };
   var renderGateHint = F4(function (gate,
   _v0,
   _v1,
   timer) {
      return function () {
         switch (_v1.ctor)
         {case "_Tuple2":
            return function () {
                 switch (_v0.ctor)
                 {case "_Tuple2":
                    return function () {
                         var distance = function (isOver) {
                            return $Basics.round($Basics.abs(gate.y + (isOver ? 0 - _v0._1 : _v0._1) / 2 - _v1._1) / 2);
                         };
                         var a = 1 + 0.5 * $Basics.cos(timer * 5.0e-3);
                         var lineStyle = _U.replace([["width"
                                                     ,2]
                                                    ,["color"
                                                     ,$Render$Utils.colors.green]
                                                    ,["dashing"
                                                     ,_L.fromArray([3,3])]],
                         $Graphics$Collage.defaultLine);
                         var markStyle = $Graphics$Collage.filled($Render$Utils.colors.orange);
                         var c = 3;
                         var isOver = _U.cmp(_v1._1 + _v0._1 / 2 + c,
                         gate.y) < 0;
                         var isUnder = _U.cmp(_v1._1 - _v0._1 / 2 - c,
                         gate.y) > 0;
                         var side = isOver ? _v0._1 / 2 : isUnder ? (0 - _v0._1) / 2 : 0;
                         var $ = $Game.getGateMarks(gate),
                         left = $._0,
                         right = $._1;
                         return isOver || isUnder ? function () {
                            var textY = _U.cmp(side,
                            0) > 0 ? 0 - c : c;
                            var d = $Graphics$Collage.alpha(0.5)($Graphics$Collage.move({ctor: "_Tuple2"
                                                                                        ,_0: 0 - _v1._0
                                                                                        ,_1: side + textY * 4})(gateHintLabel(distance(_U.cmp(side,
                            0) > 0))));
                            var triangle = $Graphics$Collage.alpha(a)($Graphics$Collage.filled($Render$Utils.colors.orange)(_U.cmp(side,
                            0) > 0 ? topHint : bottomHint));
                            var right = {ctor: "_Tuple2"
                                        ,_0: 0 - _v1._0 + gate.width / 2
                                        ,_1: side};
                            var rightMark = $Graphics$Collage.move(right)(triangle);
                            var left = {ctor: "_Tuple2"
                                       ,_0: 0 - _v1._0 - gate.width / 2
                                       ,_1: side};
                            var leftMark = $Graphics$Collage.move(left)(triangle);
                            var line = $Graphics$Collage.alpha(a)($Graphics$Collage.traced(lineStyle)(A2($Graphics$Collage.segment,
                            left,
                            right)));
                            return $Maybe.Just($Graphics$Collage.group(_L.fromArray([line
                                                                                    ,leftMark
                                                                                    ,rightMark
                                                                                    ,d])));
                         }() : $Maybe.Nothing;
                      }();}
                 _U.badCase($moduleName,
                 "between lines 33 and 59");
              }();}
         _U.badCase($moduleName,
         "between lines 33 and 59");
      }();
   });
   var renderControls = F3(function (_v8,
   intDims,
   playerState) {
      return function () {
         return function () {
            var dims = $Geo.floatify(intDims);
            var downwindHint = _U.eq(playerState.nextGate,
            $Maybe.Just("DownwindGate")) ? A4(renderGateHint,
            _v8.course.downwind,
            dims,
            _v8.center,
            _v8.now) : $Maybe.Nothing;
            var upwindHint = _U.eq(playerState.nextGate,
            $Maybe.Just("UpwindGate")) ? A4(renderGateHint,
            _v8.course.upwind,
            dims,
            _v8.center,
            _v8.now) : $Maybe.Nothing;
            return $Graphics$Collage.group($Core.compact(_L.fromArray([downwindHint
                                                                      ,upwindHint])));
         }();
      }();
   });
   _elm.Render.Controls.values = {_op: _op
                                 ,gateHintLabel: gateHintLabel
                                 ,gateHintTriangle: gateHintTriangle
                                 ,topHint: topHint
                                 ,bottomHint: bottomHint
                                 ,renderGateHint: renderGateHint
                                 ,renderControls: renderControls};
   return _elm.Render.Controls.values;
};
Elm.Render = Elm.Render || {};
Elm.Render.Course = Elm.Render.Course || {};
Elm.Render.Course.make = function (_elm) {
   "use strict";
   _elm.Render = _elm.Render || {};
   _elm.Render.Course = _elm.Render.Course || {};
   if (_elm.Render.Course.values)
   return _elm.Render.Course.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _P = _N.Ports.make(_elm),
   $moduleName = "Render.Course",
   $Basics = Elm.Basics.make(_elm),
   $Color = Elm.Color.make(_elm),
   $Core = Elm.Core.make(_elm),
   $Game = Elm.Game.make(_elm),
   $Geo = Elm.Geo.make(_elm),
   $Graphics$Collage = Elm.Graphics.Collage.make(_elm),
   $List = Elm.List.make(_elm),
   $Maybe = Elm.Maybe.make(_elm),
   $Render$Utils = Elm.Render.Utils.make(_elm),
   $Time = Elm.Time.make(_elm);
   var renderGateLaylines = F4(function (vmg,
   windOrigin,
   area,
   gate) {
      return function () {
         var drawLine = function (_v0) {
            return function () {
               switch (_v0.ctor)
               {case "_Tuple2":
                  return $Graphics$Collage.traced($Graphics$Collage.dotted($Color.white))(A2($Graphics$Collage.segment,
                    _v0._0,
                    _v0._1));}
               _U.badCase($moduleName,
               "on line 195, column 24 to 61");
            }();
         };
         var windAngleRad = $Core.toRadians(windOrigin);
         var $ = $Game.getGateMarks(gate),
         leftMark = $._0,
         rightMark = $._1;
         var vmgRad = $Core.toRadians(vmg.angle);
         var $ = $Game.areaDims(area),
         w = $._0,
         h = $._1;
         var lineLength = w / 2;
         var leftLineEnd = A2($Geo.add,
         leftMark,
         $Basics.fromPolar({ctor: "_Tuple2"
                           ,_0: lineLength
                           ,_1: windAngleRad + vmgRad + $Basics.pi / 2}));
         var rightLineEnd = A2($Geo.add,
         rightMark,
         $Basics.fromPolar({ctor: "_Tuple2"
                           ,_0: lineLength
                           ,_1: windAngleRad - vmgRad - $Basics.pi / 2}));
         return $Graphics$Collage.alpha(0.3)($Graphics$Collage.group(A2($List.map,
         drawLine,
         _L.fromArray([{ctor: "_Tuple2"
                       ,_0: leftMark
                       ,_1: leftLineEnd}
                      ,{ctor: "_Tuple2"
                       ,_0: rightMark
                       ,_1: rightLineEnd}]))));
      }();
   });
   var renderLaylines = F2(function (_v4,
   playerState) {
      return function () {
         return function () {
            var _v6 = playerState.nextGate;
            switch (_v6.ctor)
            {case "Just": switch (_v6._0)
                 {case "DownwindGate":
                    return A4(renderGateLaylines,
                      playerState.downwindVmg,
                      _v4.wind.origin,
                      _v4.course.area,
                      _v4.course.downwind);
                    case "UpwindGate":
                    return A4(renderGateLaylines,
                      playerState.upwindVmg,
                      _v4.wind.origin,
                      _v4.course.area,
                      _v4.course.upwind);}
                 break;}
            return $Render$Utils.emptyForm;
         }();
      }();
   });
   var renderIslands = function (gameState) {
      return function () {
         var renderIsland = function (_v8) {
            return function () {
               return $Graphics$Collage.move(_v8.location)($Graphics$Collage.filled($Render$Utils.colors.sand)($Graphics$Collage.circle(_v8.radius)));
            }();
         };
         return $Graphics$Collage.group(A2($List.map,
         renderIsland,
         gameState.course.islands));
      }();
   };
   var renderGust = F2(function (wind,
   gust) {
      return function () {
         var color = _U.cmp(gust.speed,
         0) > 0 ? $Color.black : $Color.white;
         var a = 0.3 * $Basics.abs(gust.speed) / 10;
         return $Graphics$Collage.move(gust.position)($Graphics$Collage.alpha(a)($Graphics$Collage.filled(color)($Graphics$Collage.circle(gust.radius))));
      }();
   });
   var renderGusts = function (wind) {
      return $Graphics$Collage.group(A2($List.map,
      renderGust(wind),
      wind.gusts));
   };
   var renderBounds = function (area) {
      return function () {
         var $ = $Game.areaCenters(area),
         cw = $._0,
         ch = $._1;
         var $ = $Game.areaDims(area),
         w = $._0,
         h = $._1;
         var fill = $Graphics$Collage.filled($Render$Utils.colors.seaBlue)(A2($Graphics$Collage.rect,
         w,
         h));
         var stroke = $Graphics$Collage.alpha(0.8)($Graphics$Collage.outlined(_U.replace([["width"
                                                                                          ,1]
                                                                                         ,["color"
                                                                                          ,$Color.white]
                                                                                         ,["cap"
                                                                                          ,$Graphics$Collage.Round]
                                                                                         ,["join"
                                                                                          ,$Graphics$Collage.Smooth]],
         $Graphics$Collage.defaultLine))(A2($Graphics$Collage.rect,
         w,
         h)));
         return $Graphics$Collage.move({ctor: "_Tuple2"
                                       ,_0: cw
                                       ,_1: ch})($Graphics$Collage.group(_L.fromArray([fill
                                                                                      ,stroke])));
      }();
   };
   var Downwind = {ctor: "Downwind"};
   var Upwind = {ctor: "Upwind"};
   var renderGateLine = F2(function (gate,
   lineStyle) {
      return function () {
         var $ = $Game.getGateMarks(gate),
         left = $._0,
         right = $._1;
         return $Graphics$Collage.traced(lineStyle)(A2($Graphics$Collage.segment,
         left,
         right));
      }();
   });
   var renderGateMark = F2(function (radius,
   position) {
      return function () {
         var outer = $Graphics$Collage.outlined($Graphics$Collage.solid($Color.white))($Graphics$Collage.circle(radius));
         var inner = $Graphics$Collage.filled($Render$Utils.colors.orange)($Graphics$Collage.circle(radius));
         return $Graphics$Collage.move(position)($Graphics$Collage.group(_L.fromArray([inner
                                                                                      ,outer])));
      }();
   });
   var renderGateMarks = F2(function (gate,
   markRadius) {
      return function () {
         var $ = $Game.getGateMarks(gate),
         left = $._0,
         right = $._1;
         return $Graphics$Collage.group(A2($List.map,
         renderGateMark(markRadius),
         _L.fromArray([left,right])));
      }();
   });
   var gateLineOpacity = function (timer) {
      return 0.7 + 0.3 * $Basics.cos(timer * 5.0e-3);
   };
   var arrowLineStyle = _U.replace([["width"
                                    ,2]
                                   ,["color",$Color.white]
                                   ,["cap",$Graphics$Collage.Round]
                                   ,["join"
                                    ,$Graphics$Collage.Smooth]],
   $Graphics$Collage.defaultLine);
   var renderStraightArrow = F3(function (markRadius,
   bottomUp,
   timer) {
      return function () {
         var arrowY = A2($Core.floatMod,
         timer * 2.0e-2,
         30);
         var way = bottomUp ? 1 : -1;
         var l = markRadius;
         var tipShape = bottomUp ? _L.fromArray([{ctor: "_Tuple2"
                                                 ,_0: 0 - l
                                                 ,_1: 0 - l}
                                                ,{ctor: "_Tuple2",_0: 0,_1: 0}
                                                ,{ctor: "_Tuple2"
                                                 ,_0: l
                                                 ,_1: 0 - l}]) : _L.fromArray([{ctor: "_Tuple2"
                                                                               ,_0: 0 - l
                                                                               ,_1: l}
                                                                              ,{ctor: "_Tuple2"
                                                                               ,_0: 0
                                                                               ,_1: 0}
                                                                              ,{ctor: "_Tuple2"
                                                                               ,_0: l
                                                                               ,_1: l}]);
         var tip = $Graphics$Collage.traced(arrowLineStyle)($Graphics$Collage.path(tipShape));
         var lineLength = $Basics.toFloat(markRadius * 4);
         var bodyShape = bottomUp ? _L.fromArray([{ctor: "_Tuple2"
                                                  ,_0: 0
                                                  ,_1: 0 - lineLength}
                                                 ,{ctor: "_Tuple2"
                                                  ,_0: 0
                                                  ,_1: 0}]) : _L.fromArray([{ctor: "_Tuple2"
                                                                            ,_0: 0
                                                                            ,_1: 0}
                                                                           ,{ctor: "_Tuple2"
                                                                            ,_0: 0
                                                                            ,_1: lineLength}]);
         var body = $Graphics$Collage.traced(arrowLineStyle)($Graphics$Collage.path(bodyShape));
         return $Graphics$Collage.alpha(arrowY * way / 30 * 0.2)($Graphics$Collage.move({ctor: "_Tuple2"
                                                                                        ,_0: 0
                                                                                        ,_1: arrowY * way})($Graphics$Collage.group(_L.fromArray([body
                                                                                                                                                 ,tip]))));
      }();
   });
   var nextLineStyle = _U.replace([["width"
                                   ,2]
                                  ,["color"
                                   ,$Render$Utils.colors.green]
                                  ,["dashing"
                                   ,_L.fromArray([3,3])]],
   $Graphics$Collage.defaultLine);
   var renderStartLine = F4(function (gate,
   markRadius,
   started,
   timer) {
      return function () {
         var helper = started ? $Graphics$Collage.move({ctor: "_Tuple2"
                                                       ,_0: 0
                                                       ,_1: gate.y - markRadius * 3})(A3(renderStraightArrow,
         markRadius,
         true,
         timer)) : $Render$Utils.emptyForm;
         var marks = A2(renderGateMarks,
         gate,
         markRadius);
         var a = started ? gateLineOpacity(timer) : 1;
         var lineStyle = started ? nextLineStyle : _U.replace([["width"
                                                               ,2]
                                                              ,["color"
                                                               ,$Render$Utils.colors.orange]],
         $Graphics$Collage.defaultLine);
         var line = $Graphics$Collage.alpha(a)(A2(renderGateLine,
         gate,
         lineStyle));
         return $Graphics$Collage.group(_L.fromArray([helper
                                                     ,line
                                                     ,marks]));
      }();
   });
   var renderFinishLine = F3(function (gate,
   markRadius,
   timer) {
      return function () {
         var marks = A2(renderGateMarks,
         gate,
         markRadius);
         var a = gateLineOpacity(timer);
         var line = $Graphics$Collage.alpha(a)(A2(renderGateLine,
         gate,
         nextLineStyle));
         var helper = $Graphics$Collage.alpha(a * 0.5)($Graphics$Collage.move({ctor: "_Tuple2"
                                                                              ,_0: 0
                                                                              ,_1: gate.y + markRadius * 3})(A3(renderStraightArrow,
         markRadius,
         false,
         timer)));
         return $Graphics$Collage.group(_L.fromArray([helper
                                                     ,line
                                                     ,marks]));
      }();
   });
   var counterClockwiseArrowTip = function (l) {
      return _L.fromArray([{ctor: "_Tuple2"
                           ,_0: l
                           ,_1: l}
                          ,{ctor: "_Tuple2",_0: 0,_1: 0}
                          ,{ctor: "_Tuple2"
                           ,_0: l
                           ,_1: 0 - l}]);
   };
   var clockwiseArrowTip = function (l) {
      return _L.fromArray([{ctor: "_Tuple2"
                           ,_0: 0 - l
                           ,_1: l}
                          ,{ctor: "_Tuple2",_0: 0,_1: 0}
                          ,{ctor: "_Tuple2"
                           ,_0: 0 - l
                           ,_1: 0 - l}]);
   };
   var arcShape = F4(function (r,
   start,
   length,
   way) {
      return function () {
         var steps = _L.range(0,
         length / 10 | 0);
         var realSteps = A2($List.map,
         function (s) {
            return $Basics.toFloat(start + s * 10 * (0 - way));
         },
         steps);
         var radSteps = A2($List.map,
         $Core.toRadians,
         realSteps);
         return A2($List.map,
         function (t) {
            return $Basics.fromPolar({ctor: "_Tuple2"
                                     ,_0: r
                                     ,_1: t});
         },
         radSteps);
      }();
   });
   var renderAroundArrow = F4(function (headAngle,
   clockwise,
   markRadius,
   timer) {
      return function () {
         var arrowTip = clockwise ? clockwiseArrowTip : counterClockwiseArrowTip;
         var way = clockwise ? 1 : -1;
         var arcAngle = 60;
         var slidingAngle = 135;
         var timedAngle = A2($Core.floatMod,
         timer / 15,
         slidingAngle);
         var currentSlidingAngle = ($Basics.round(timedAngle) - slidingAngle) * way;
         var arrowRad = $Core.toRadians($Basics.toFloat(currentSlidingAngle + headAngle));
         var r = markRadius * 4;
         var arc = $Graphics$Collage.traced(arrowLineStyle)($Graphics$Collage.path(A4(arcShape,
         r,
         headAngle + currentSlidingAngle,
         arcAngle,
         way)));
         var arrow = $Graphics$Collage.move($Basics.fromPolar({ctor: "_Tuple2"
                                                              ,_0: r
                                                              ,_1: arrowRad}))($Graphics$Collage.rotate(arrowRad - $Basics.pi / 2)($Graphics$Collage.traced(arrowLineStyle)($Graphics$Collage.path(arrowTip(markRadius)))));
         return $Graphics$Collage.alpha(timedAngle / $Basics.toFloat(slidingAngle) * 0.2)($Graphics$Collage.group(_L.fromArray([arc
                                                                                                                               ,arrow])));
      }();
   });
   var aroundLeftUpwind = A2(renderAroundArrow,
   -45,
   false);
   var aroundRightUpwind = A2(renderAroundArrow,
   45,
   true);
   var aroundLeftDownwind = A2(renderAroundArrow,
   225,
   true);
   var aroundRightDownwind = A2(renderAroundArrow,
   135,
   false);
   var renderGateHelpers = F4(function (gate,
   markRadius,
   gateLoc,
   timer) {
      return function () {
         var $ = function () {
            switch (gateLoc.ctor)
            {case "Downwind":
               return {ctor: "_Tuple2"
                      ,_0: A2(aroundLeftDownwind,
                      markRadius,
                      timer)
                      ,_1: A2(aroundRightDownwind,
                      markRadius,
                      timer)};
               case "Upwind":
               return {ctor: "_Tuple2"
                      ,_0: A2(aroundLeftUpwind,
                      markRadius,
                      timer)
                      ,_1: A2(aroundRightUpwind,
                      markRadius,
                      timer)};}
            _U.badCase($moduleName,
            "between lines 116 and 119");
         }(),
         leftHelper = $._0,
         rightHelper = $._1;
         var $ = $Game.getGateMarks(gate),
         left = $._0,
         right = $._1;
         return $Graphics$Collage.group(_L.fromArray([A2($Graphics$Collage.move,
                                                     left,
                                                     leftHelper)
                                                     ,A2($Graphics$Collage.move,
                                                     right,
                                                     rightHelper)]));
      }();
   });
   var renderGate = F5(function (gate,
   markRadius,
   timer,
   isNext,
   gateType) {
      return function () {
         var helpers = isNext ? A4(renderGateHelpers,
         gate,
         markRadius,
         gateType,
         timer) : $Render$Utils.emptyForm;
         var marks = A2(renderGateMarks,
         gate,
         markRadius);
         var a = gateLineOpacity(timer);
         var line = isNext ? $Graphics$Collage.alpha(a)(A2(renderGateLine,
         gate,
         nextLineStyle)) : $Render$Utils.emptyForm;
         return $Graphics$Collage.group(_L.fromArray([line
                                                     ,marks
                                                     ,helpers]));
      }();
   });
   var renderDownwind = function (_v11) {
      return function () {
         return function () {
            var isNext = $Maybe.withDefault(false)(A2($Maybe.map,
            function (ps) {
               return _U.eq(ps.nextGate,
               $Maybe.Just("DownwindGate"));
            },
            _v11.playerState));
            var isLastGate = $Maybe.withDefault(false)(A2($Maybe.map,
            function (ps) {
               return _U.eq($List.length(ps.crossedGates),
               _v11.course.laps * 2);
            },
            _v11.playerState));
            var isFirstGate = $Maybe.withDefault(false)(A2($Maybe.map,
            function (ps) {
               return $List.isEmpty(ps.crossedGates);
            },
            _v11.playerState));
            return isFirstGate ? A4(renderStartLine,
            _v11.course.downwind,
            _v11.course.markRadius,
            $Core.isStarted(_v11.countdown),
            _v11.now) : isLastGate ? A3(renderFinishLine,
            _v11.course.downwind,
            _v11.course.markRadius,
            _v11.now) : A5(renderGate,
            _v11.course.downwind,
            _v11.course.markRadius,
            _v11.now,
            isNext,
            Downwind);
         }();
      }();
   };
   var renderUpwind = function (_v13) {
      return function () {
         return function () {
            var isNext = $Maybe.withDefault(false)(A2($Maybe.map,
            function (ps) {
               return _U.eq(ps.nextGate,
               $Maybe.Just("UpwindGate"));
            },
            _v13.playerState));
            return A5(renderGate,
            _v13.course.upwind,
            _v13.course.markRadius,
            _v13.now,
            isNext,
            Upwind);
         }();
      }();
   };
   var renderCourse = function (_v15) {
      return function () {
         return function () {
            var forms = _L.fromArray([renderBounds(_v15.course.area)
                                     ,$Maybe.withDefault($Render$Utils.emptyForm)(A2($Maybe.map,
                                     renderLaylines(_v15),
                                     _v15.playerState))
                                     ,renderIslands(_v15)
                                     ,renderDownwind(_v15)
                                     ,renderUpwind(_v15)
                                     ,renderGusts(_v15.wind)]);
            return $Graphics$Collage.group(forms);
         }();
      }();
   };
   _elm.Render.Course.values = {_op: _op
                               ,arcShape: arcShape
                               ,clockwiseArrowTip: clockwiseArrowTip
                               ,counterClockwiseArrowTip: counterClockwiseArrowTip
                               ,nextLineStyle: nextLineStyle
                               ,arrowLineStyle: arrowLineStyle
                               ,renderAroundArrow: renderAroundArrow
                               ,aroundLeftUpwind: aroundLeftUpwind
                               ,aroundRightUpwind: aroundRightUpwind
                               ,aroundLeftDownwind: aroundLeftDownwind
                               ,aroundRightDownwind: aroundRightDownwind
                               ,renderStraightArrow: renderStraightArrow
                               ,gateLineOpacity: gateLineOpacity
                               ,renderGateMark: renderGateMark
                               ,renderGateMarks: renderGateMarks
                               ,renderGateLine: renderGateLine
                               ,Upwind: Upwind
                               ,Downwind: Downwind
                               ,renderGateHelpers: renderGateHelpers
                               ,renderStartLine: renderStartLine
                               ,renderGate: renderGate
                               ,renderFinishLine: renderFinishLine
                               ,renderBounds: renderBounds
                               ,renderGust: renderGust
                               ,renderGusts: renderGusts
                               ,renderIslands: renderIslands
                               ,renderGateLaylines: renderGateLaylines
                               ,renderLaylines: renderLaylines
                               ,renderDownwind: renderDownwind
                               ,renderUpwind: renderUpwind
                               ,renderCourse: renderCourse};
   return _elm.Render.Course.values;
};
Elm.Render = Elm.Render || {};
Elm.Render.Dashboard = Elm.Render.Dashboard || {};
Elm.Render.Dashboard.make = function (_elm) {
   "use strict";
   _elm.Render = _elm.Render || {};
   _elm.Render.Dashboard = _elm.Render.Dashboard || {};
   if (_elm.Render.Dashboard.values)
   return _elm.Render.Dashboard.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _P = _N.Ports.make(_elm),
   $moduleName = "Render.Dashboard",
   $Basics = Elm.Basics.make(_elm),
   $Color = Elm.Color.make(_elm),
   $Core = Elm.Core.make(_elm),
   $Game = Elm.Game.make(_elm),
   $Graphics$Collage = Elm.Graphics.Collage.make(_elm),
   $Graphics$Element = Elm.Graphics.Element.make(_elm),
   $Graphics$Input = Elm.Graphics.Input.make(_elm),
   $Inputs = Elm.Inputs.make(_elm),
   $Layout = Elm.Layout.make(_elm),
   $List = Elm.List.make(_elm),
   $Maybe = Elm.Maybe.make(_elm),
   $Render$Utils = Elm.Render.Utils.make(_elm),
   $Signal = Elm.Signal.make(_elm),
   $String = Elm.String.make(_elm),
   $Text = Elm.Text.make(_elm),
   $Time = Elm.Time.make(_elm);
   var getVmgBar = function (_v0) {
      return function () {
         return function () {
            var theoricVmgValue = _U.cmp($Basics.abs(_v0.windAngle),
            90) < 0 ? _v0.upwindVmg.value : _v0.downwindVmg.value;
            var boundedVmgValue = _U.cmp(_v0.vmgValue,
            theoricVmgValue) > 0 ? theoricVmgValue : _U.cmp(_v0.vmgValue,
            0) < 0 ? 0 : _v0.vmgValue;
            var barWidth = 8;
            var barHeight = 120;
            var contour = $Graphics$Collage.alpha(0.5)($Graphics$Collage.outlined(_U.replace([["width"
                                                                                              ,2]
                                                                                             ,["color"
                                                                                              ,$Color.white]
                                                                                             ,["cap"
                                                                                              ,$Graphics$Collage.Round]
                                                                                             ,["join"
                                                                                              ,$Graphics$Collage.Smooth]],
            $Graphics$Collage.defaultLine))(A2($Graphics$Collage.rect,
            barWidth + 6,
            barHeight + 6)));
            var height = barHeight * boundedVmgValue / theoricVmgValue;
            var level = $Graphics$Collage.alpha(0.8)($Graphics$Collage.move({ctor: "_Tuple2"
                                                                            ,_0: 0
                                                                            ,_1: (height - barHeight) / 2})($Graphics$Collage.filled($Color.white)(A2($Graphics$Collage.rect,
            barWidth,
            height))));
            var bar = $Graphics$Collage.move({ctor: "_Tuple2"
                                             ,_0: 0
                                             ,_1: 10})($Graphics$Collage.group(_L.fromArray([level
                                                                                            ,contour])));
            var legend = $Graphics$Collage.move({ctor: "_Tuple2"
                                                ,_0: 0
                                                ,_1: 0 - barHeight / 2 - 10})($Graphics$Collage.toForm($Text.centered($Render$Utils.baseText("VMG"))));
            return A3($Graphics$Collage.collage,
            80,
            barHeight + 40,
            _L.fromArray([bar,legend]));
         }();
      }();
   };
   var getWindWheel = function (wind) {
      return function () {
         var legend = $Graphics$Collage.move({ctor: "_Tuple2"
                                             ,_0: 0
                                             ,_1: -50})($Graphics$Collage.toForm($Text.centered($Render$Utils.baseText("WIND"))));
         var windSpeedText = $Graphics$Collage.toForm($Text.centered($Render$Utils.baseText(A2($Basics._op["++"],
         $Basics.toString($Basics.round(wind.speed)),
         "kn"))));
         var windOriginRadians = $Core.toRadians(wind.origin);
         var r = 30;
         var c = $Graphics$Collage.outlined($Graphics$Collage.solid($Color.white))($Graphics$Collage.circle(r));
         var windMarker = $Graphics$Collage.move($Basics.fromPolar({ctor: "_Tuple2"
                                                                   ,_0: r + 4
                                                                   ,_1: windOriginRadians}))($Graphics$Collage.rotate(windOriginRadians + $Basics.pi / 2)($Graphics$Collage.filled($Color.white)($Graphics$Collage.polygon(_L.fromArray([{ctor: "_Tuple2"
                                                                                                                                                                                                                                         ,_0: 0
                                                                                                                                                                                                                                         ,_1: 4}
                                                                                                                                                                                                                                        ,{ctor: "_Tuple2"
                                                                                                                                                                                                                                         ,_0: -4
                                                                                                                                                                                                                                         ,_1: -4}
                                                                                                                                                                                                                                        ,{ctor: "_Tuple2"
                                                                                                                                                                                                                                         ,_0: 4
                                                                                                                                                                                                                                         ,_1: -4}])))));
         var windOriginText = $Graphics$Collage.move({ctor: "_Tuple2"
                                                     ,_0: 0
                                                     ,_1: r + 25})($Graphics$Collage.toForm($Text.centered($Render$Utils.baseText(A2($Basics._op["++"],
         $Basics.toString($Basics.round(wind.origin)),
         "&deg;")))));
         return A3($Graphics$Collage.collage,
         80,
         120,
         _L.fromArray([c
                      ,windMarker
                      ,windOriginText
                      ,windSpeedText
                      ,legend]));
      }();
   };
   var topRightElements = F2(function (_v2,
   playerState) {
      return function () {
         return _L.fromArray([getWindWheel(_v2.wind)
                             ,$Maybe.withDefault($Graphics$Element.empty)(A2($Maybe.map,
                             getVmgBar,
                             playerState))]);
      }();
   });
   var getTimeTrialFinishingStatus = F2(function (_v4,
   _v5) {
      return function () {
         return function () {
            return function () {
               var _v8 = A2($Game.findPlayerGhost,
               _v4.playerId,
               _v4.ghosts);
               switch (_v8.ctor)
               {case "Just":
                  return function () {
                       var newTime = $List.head(_v5.crossedGates);
                       var previousTime = $List.head(_v8._0.gates);
                       return _U.cmp(newTime,
                       previousTime) < 0 ? A2($Basics._op["++"],
                       $Basics.toString(newTime - previousTime),
                       "ms\nnew best time!") : A2($Basics._op["++"],
                       "+",
                       A2($Basics._op["++"],
                       $Basics.toString(newTime - previousTime),
                       "ms\ntry again?"));
                    }();
                  case "Nothing":
                  return function () {
                       var _v10 = _v5.player.handle;
                       switch (_v10.ctor)
                       {case "Just":
                          return "you did it!";
                          case "Nothing":
                          return "please create an account to save your run";}
                       _U.badCase($moduleName,
                       "between lines 206 and 208");
                    }();}
               _U.badCase($moduleName,
               "between lines 196 and 208");
            }();
         }();
      }();
   });
   var getGatesCount = F2(function (course,
   player) {
      return A2($Basics._op["++"],
      "gate ",
      A2($Basics._op["++"],
      $Basics.toString($List.length(player.crossedGates)),
      A2($Basics._op["++"],
      "/",
      $Basics.toString(1 + course.laps * 2))));
   });
   var getFinishingStatus = F2(function (_v12,
   playerState) {
      return function () {
         return function () {
            var _v14 = playerState.nextGate;
            switch (_v14.ctor)
            {case "Just": switch (_v14._0)
                 {case "StartLine":
                    return "go!";}
                 break;
               case "Nothing":
               return function () {
                    var _v16 = _v12.gameMode;
                    switch (_v16.ctor)
                    {case "Race": return "finished";
                       case "TimeTrial":
                       return A2(getTimeTrialFinishingStatus,
                         _v12,
                         playerState);}
                    _U.badCase($moduleName,
                    "between lines 184 and 187");
                 }();}
            return A2(getGatesCount,
            _v12.course,
            playerState);
         }();
      }();
   });
   var getSubStatus = function (_v17) {
      return function () {
         return function () {
            var s = function () {
               var _v19 = _v17.countdown;
               switch (_v19.ctor)
               {case "Just":
                  return _U.cmp(_v19._0,
                    0) > 0 ? "be ready" : $Maybe.withDefault("")(A2($Maybe.map,
                    getFinishingStatus(_v17),
                    _v17.playerState));
                  case "Nothing":
                  return _v17.isMaster ? $Render$Utils.startCountdownMessage : "";}
               _U.badCase($moduleName,
               "between lines 168 and 177");
            }();
            var op = 1;
            return $Graphics$Element.opacity(op)($Text.centered($Render$Utils.baseText(s)));
         }();
      }();
   };
   var getRaceTimer = function (_v21) {
      return function () {
         return function () {
            var _v23 = {ctor: "_Tuple2"
                       ,_0: _v21.countdown
                       ,_1: _v21.playerState};
            switch (_v23.ctor)
            {case "_Tuple2":
               switch (_v23._0.ctor)
                 {case "Just":
                    switch (_v23._1.ctor)
                      {case "Just":
                         return function () {
                              var t = $Core.isNothing(_v23._1._0.nextGate) ? $List.head(_v23._1._0.crossedGates) : _v23._0._0;
                              return A2($Render$Utils.formatTimer,
                              t,
                              $Core.isNothing(_v23._1._0.nextGate));
                           }();}
                      break;}
                 break;}
            return "start pending";
         }();
      }();
   };
   var getTrialTimer = function (_v28) {
      return function () {
         return function () {
            var _v30 = {ctor: "_Tuple2"
                       ,_0: _v28.countdown
                       ,_1: _v28.playerState};
            switch (_v30.ctor)
            {case "_Tuple2":
               switch (_v30._0.ctor)
                 {case "Just":
                    switch (_v30._1.ctor)
                      {case "Just":
                         return function () {
                              var t = $Core.isNothing(_v30._1._0.nextGate) ? $List.head(_v30._1._0.crossedGates) : _v30._0._0;
                              return A2($Render$Utils.formatTimer,
                              t,
                              $Core.isNothing(_v30._1._0.nextGate));
                           }();}
                      break;}
                 break;}
            return "";
         }();
      }();
   };
   var getMainStatus = function (_v35) {
      return function () {
         return function () {
            var s = function () {
               var _v37 = _v35.gameMode;
               switch (_v37.ctor)
               {case "Race":
                  return getRaceTimer(_v35);
                  case "TimeTrial":
                  return getTrialTimer(_v35);}
               _U.badCase($moduleName,
               "between lines 135 and 138");
            }();
            var op = $Game.isInProgress(_v35) ? 0.5 : 1;
            return $Graphics$Element.opacity(op)($Text.centered($Render$Utils.bigText(s)));
         }();
      }();
   };
   var topCenterElements = F2(function (gameState,
   playerState) {
      return _L.fromArray([getMainStatus(gameState)
                          ,getSubStatus(gameState)]);
   });
   var getHelp = function (gameState) {
      return function () {
         var _v38 = gameState.gameMode;
         switch (_v38.ctor)
         {case "Race":
            return $Graphics$Element.empty;
            case "TimeTrial":
            return $Graphics$Element.opacity(0.8)($Text.leftAligned($Render$Utils.baseText($Render$Utils.helpMessage)));}
         _U.badCase($moduleName,
         "between lines 120 and 126");
      }();
   };
   var getMode = function (gameState) {
      return $Core.isNothing(gameState.playerState) ? $Text.leftAligned($Render$Utils.baseText("SPECTATOR MODE")) : $Graphics$Element.empty;
   };
   var buildBoardLine = F2(function (watching,
   _v39) {
      return function () {
         return function () {
            var deltaText = $Maybe.withDefault("-")(A2($Maybe.map,
            function (d) {
               return A2($Basics._op["++"],
               "+",
               $Basics.toString(d / 1000));
            },
            _v39.delta));
            var handleText = $Render$Utils.fixedLength(12)(A2($Maybe.withDefault,
            "Anonymous",
            _v39.handle));
            var positionText = $Maybe.withDefault("  ")(A2($Maybe.map,
            function (p) {
               return A2($Basics._op["++"],
               $Basics.toString(p),
               ".");
            },
            _v39.position));
            var watchingText = watching ? _v39.watched ? "* " : "  " : "";
            var el = $Text.leftAligned($Render$Utils.baseText(A2($Basics._op["++"],
            watchingText,
            A2($String.join,
            " ",
            _L.fromArray([positionText
                         ,handleText
                         ,deltaText])))));
            return watching ? A4($Graphics$Input.customButton,
            A2($Signal.send,
            $Inputs.watchedPlayer,
            $Maybe.Just(_v39.id)),
            el,
            el,
            el) : el;
         }();
      }();
   });
   var getOpponent = F3(function (watching,
   watchMode,
   _v41) {
      return function () {
         return function () {
            var watched = function () {
               switch (watchMode.ctor)
               {case "NotWatching":
                  return false;
                  case "Watching":
                  return _U.eq(watchMode._0,
                    _v41.player.id);}
               _U.badCase($moduleName,
               "between lines 51 and 54");
            }();
            var line = {_: {}
                       ,delta: $Maybe.Nothing
                       ,handle: _v41.player.handle
                       ,id: _v41.player.id
                       ,position: $Maybe.Nothing
                       ,watched: watched};
            return A2(buildBoardLine,
            watching,
            line);
         }();
      }();
   });
   var getOpponents = function (_v45) {
      return function () {
         return function () {
            var allOpponents = $Maybe.withDefault(_v45.opponents)(A2($Maybe.map,
            function (ps) {
               return A2($List._op["::"],
               ps,
               _v45.opponents);
            },
            _v45.playerState));
            var watching = function () {
               var _v47 = _v45.playerState;
               switch (_v47.ctor)
               {case "Nothing": return true;}
               return false;
            }();
            return $Graphics$Element.flow($Graphics$Element.down)(A2($List.map,
            A2(getOpponent,
            watching,
            _v45.watchMode),
            allOpponents));
         }();
      }();
   };
   var getLeaderboardLine = F5(function (watching,
   watchMode,
   leaderTally,
   position,
   tally) {
      return function () {
         var delta = _U.eq($List.length(tally.gates),
         $List.length(leaderTally.gates)) ? $Maybe.Just($List.head(tally.gates) - $List.head(leaderTally.gates)) : $Maybe.Nothing;
         var watched = function () {
            switch (watchMode.ctor)
            {case "NotWatching":
               return false;
               case "Watching":
               return _U.eq(watchMode._0,
                 tally.playerId);}
            _U.badCase($moduleName,
            "between lines 78 and 81");
         }();
         var line = {_: {}
                    ,delta: delta
                    ,handle: tally.playerHandle
                    ,id: tally.playerId
                    ,position: $Maybe.Just(position + 1)
                    ,watched: watched};
         return A2(buildBoardLine,
         watching,
         line);
      }();
   });
   var getLeaderboard = function (_v50) {
      return function () {
         return $List.isEmpty(_v50.leaderboard) ? $Graphics$Element.empty : function () {
            var watching = $Core.isNothing(_v50.playerState);
            var leader = $List.head(_v50.leaderboard);
            return $Graphics$Element.flow($Graphics$Element.down)(A2($List.indexedMap,
            A3(getLeaderboardLine,
            watching,
            _v50.watchMode,
            leader),
            _v50.leaderboard));
         }();
      }();
   };
   var getBoard = function (gameState) {
      return _U.eq(gameState.gameMode,
      $Game.TimeTrial) ? $Graphics$Element.empty : $List.isEmpty(gameState.leaderboard) ? getOpponents(gameState) : getLeaderboard(gameState);
   };
   var topLeftElements = F2(function (gameState,
   playerState) {
      return _L.fromArray([getMode(gameState)
                          ,getBoard(gameState)
                          ,getHelp(gameState)]);
   });
   var buildDashboard = F2(function (_v52,
   _v53) {
      return function () {
         switch (_v53.ctor)
         {case "_Tuple2":
            return function () {
                 return function () {
                    var displayedPlayerState = function () {
                       var _v58 = _v52.watchMode;
                       switch (_v58.ctor)
                       {case "NotWatching":
                          return _v52.playerState;
                          case "Watching":
                          return $Game.selfWatching(_v52) ? A2($Game.findOpponent,
                            _v52.opponents,
                            _v58._0) : $Maybe.Nothing;}
                       _U.badCase($moduleName,
                       "between lines 281 and 284");
                    }();
                    return {_: {}
                           ,bottomCenter: _L.fromArray([])
                           ,topCenter: A2(topCenterElements,
                           _v52,
                           displayedPlayerState)
                           ,topLeft: A2(topLeftElements,
                           _v52,
                           displayedPlayerState)
                           ,topRight: A2(topRightElements,
                           _v52,
                           displayedPlayerState)};
                 }();
              }();}
         _U.badCase($moduleName,
         "between lines 280 and 289");
      }();
   });
   var BoardLine = F5(function (a,
   b,
   c,
   d,
   e) {
      return {_: {}
             ,delta: d
             ,handle: b
             ,id: a
             ,position: c
             ,watched: e};
   });
   var xs = A2($Graphics$Element.spacer,
   5,
   5);
   var s = A2($Graphics$Element.spacer,
   20,
   20);
   _elm.Render.Dashboard.values = {_op: _op
                                  ,s: s
                                  ,xs: xs
                                  ,BoardLine: BoardLine
                                  ,buildBoardLine: buildBoardLine
                                  ,getOpponent: getOpponent
                                  ,getOpponents: getOpponents
                                  ,getLeaderboardLine: getLeaderboardLine
                                  ,getLeaderboard: getLeaderboard
                                  ,getBoard: getBoard
                                  ,getMode: getMode
                                  ,getHelp: getHelp
                                  ,getMainStatus: getMainStatus
                                  ,getTrialTimer: getTrialTimer
                                  ,getRaceTimer: getRaceTimer
                                  ,getSubStatus: getSubStatus
                                  ,getFinishingStatus: getFinishingStatus
                                  ,getGatesCount: getGatesCount
                                  ,getTimeTrialFinishingStatus: getTimeTrialFinishingStatus
                                  ,getWindWheel: getWindWheel
                                  ,getVmgBar: getVmgBar
                                  ,topLeftElements: topLeftElements
                                  ,topCenterElements: topCenterElements
                                  ,topRightElements: topRightElements
                                  ,buildDashboard: buildDashboard};
   return _elm.Render.Dashboard.values;
};
Elm.Render = Elm.Render || {};
Elm.Render.Players = Elm.Render.Players || {};
Elm.Render.Players.make = function (_elm) {
   "use strict";
   _elm.Render = _elm.Render || {};
   _elm.Render.Players = _elm.Render.Players || {};
   if (_elm.Render.Players.values)
   return _elm.Render.Players.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _P = _N.Ports.make(_elm),
   $moduleName = "Render.Players",
   $Basics = Elm.Basics.make(_elm),
   $Color = Elm.Color.make(_elm),
   $Core = Elm.Core.make(_elm),
   $Game = Elm.Game.make(_elm),
   $Geo = Elm.Geo.make(_elm),
   $Graphics$Collage = Elm.Graphics.Collage.make(_elm),
   $Graphics$Element = Elm.Graphics.Element.make(_elm),
   $List = Elm.List.make(_elm),
   $Maybe = Elm.Maybe.make(_elm),
   $Render$Utils = Elm.Render.Utils.make(_elm),
   $Text = Elm.Text.make(_elm);
   var rotateHull = function (heading) {
      return $Graphics$Collage.rotate($Core.toRadians(heading + 90));
   };
   var baseHull = $Graphics$Collage.toForm(A3($Graphics$Element.image,
   12,
   20,
   "/assets/images/49er.png"));
   var renderGhost = function (_v0) {
      return function () {
         return function () {
            var name = $Graphics$Collage.alpha(0.3)($Graphics$Collage.move(A2($Geo.add,
            _v0.position,
            {ctor: "_Tuple2"
            ,_0: 0
            ,_1: -25}))($Graphics$Collage.toForm($Text.centered($Render$Utils.baseText(A2($Maybe.withDefault,
            "Anonymous",
            _v0.handle))))));
            var hull = $Graphics$Collage.alpha(0.5)($Graphics$Collage.move(_v0.position)(A2(rotateHull,
            _v0.heading,
            baseHull)));
            return $Graphics$Collage.group(_L.fromArray([hull
                                                        ,name]));
         }();
      }();
   };
   var renderGhosts = function (ghosts) {
      return $Graphics$Collage.group(A2($List.map,
      renderGhost,
      ghosts));
   };
   var renderWindShadow = F2(function (shadowLength,
   _v2) {
      return function () {
         return function () {
            var arcAngles = _L.fromArray([-15
                                         ,-10
                                         ,-5
                                         ,0
                                         ,5
                                         ,10
                                         ,15]);
            var endPoints = A2($List.map,
            function (a) {
               return A2($Geo.add,
               _v2.position,
               $Basics.fromPolar({ctor: "_Tuple2"
                                 ,_0: shadowLength
                                 ,_1: $Core.toRadians(_v2.shadowDirection + a)}));
            },
            arcAngles);
            return $Graphics$Collage.alpha(0.1)($Graphics$Collage.filled($Color.white)($Graphics$Collage.path(A2($List._op["::"],
            _v2.position,
            endPoints))));
         }();
      }();
   });
   var renderOpponent = F2(function (shadowLength,
   opponent) {
      return function () {
         var name = $Graphics$Collage.alpha(0.3)($Graphics$Collage.move(A2($Geo.add,
         opponent.position,
         {ctor: "_Tuple2"
         ,_0: 0
         ,_1: -25}))($Graphics$Collage.toForm($Text.centered($Render$Utils.baseText(A2($Maybe.withDefault,
         "Anonymous",
         opponent.player.handle))))));
         var shadow = A2(renderWindShadow,
         shadowLength,
         opponent);
         var hull = $Graphics$Collage.alpha(0.5)($Graphics$Collage.move(opponent.position)(A2(rotateHull,
         opponent.heading,
         baseHull)));
         return $Graphics$Collage.group(_L.fromArray([shadow
                                                     ,hull
                                                     ,name]));
      }();
   });
   var renderOpponents = F2(function (course,
   opponents) {
      return $Graphics$Collage.group(A2($List.map,
      renderOpponent(course.windShadowLength),
      opponents));
   });
   var renderWake = function (wake) {
      return function () {
         var opacityForIndex = function (i) {
            return 0.3 - 0.3 * $Basics.toFloat(i) / $Basics.toFloat($List.length(wake));
         };
         var style = _U.replace([["color"
                                 ,$Color.white]
                                ,["width",3]],
         $Graphics$Collage.defaultLine);
         var renderSegment = function (_v4) {
            return function () {
               switch (_v4.ctor)
               {case "_Tuple2":
                  switch (_v4._1.ctor)
                    {case "_Tuple2":
                       return $Graphics$Collage.alpha(opacityForIndex(_v4._0))($Graphics$Collage.traced(style)(A2($Graphics$Collage.segment,
                         _v4._1._0,
                         _v4._1._1)));}
                    break;}
               _U.badCase($moduleName,
               "on line 82, column 31 to 86");
            }();
         };
         var pairs = $List.isEmpty(wake) ? _L.fromArray([]) : $List.indexedMap(F2(function (v0,
         v1) {
            return {ctor: "_Tuple2"
                   ,_0: v0
                   ,_1: v1};
         }))(A3($List.map2,
         F2(function (v0,v1) {
            return {ctor: "_Tuple2"
                   ,_0: v0
                   ,_1: v1};
         }),
         wake,
         $List.tail(wake)));
         return $Graphics$Collage.group(A2($List.map,
         renderSegment,
         pairs));
      }();
   };
   var renderEqualityLine = F2(function (_v10,
   windOrigin) {
      return function () {
         switch (_v10.ctor)
         {case "_Tuple2":
            return function () {
                 var right = $Basics.fromPolar({ctor: "_Tuple2"
                                               ,_0: 100
                                               ,_1: $Core.toRadians(windOrigin + 90)});
                 var left = $Basics.fromPolar({ctor: "_Tuple2"
                                              ,_0: 100
                                              ,_1: $Core.toRadians(windOrigin - 90)});
                 return $Graphics$Collage.alpha(0.1)($Graphics$Collage.traced($Graphics$Collage.dotted($Color.white))(A2($Graphics$Collage.segment,
                 left,
                 right)));
              }();}
         _U.badCase($moduleName,
         "between lines 68 and 72");
      }();
   });
   var renderPlayerAngles = function (player) {
      return function () {
         var windOriginRadians = $Core.toRadians(player.heading - player.windAngle);
         var windMarker = $Graphics$Collage.alpha(0.5)($Graphics$Collage.move($Basics.fromPolar({ctor: "_Tuple2"
                                                                                                ,_0: 30
                                                                                                ,_1: windOriginRadians}))($Graphics$Collage.rotate(windOriginRadians + $Basics.pi / 2)($Graphics$Collage.filled($Color.white)($Graphics$Collage.polygon(_L.fromArray([{ctor: "_Tuple2"
                                                                                                                                                                                                                                                                      ,_0: 0
                                                                                                                                                                                                                                                                      ,_1: 4}
                                                                                                                                                                                                                                                                     ,{ctor: "_Tuple2"
                                                                                                                                                                                                                                                                      ,_0: -3
                                                                                                                                                                                                                                                                      ,_1: -5}
                                                                                                                                                                                                                                                                     ,{ctor: "_Tuple2"
                                                                                                                                                                                                                                                                      ,_0: 3
                                                                                                                                                                                                                                                                      ,_1: -5}]))))));
         var windLine = $Graphics$Collage.alpha(0.1)($Graphics$Collage.traced($Graphics$Collage.solid($Color.white))(A2($Graphics$Collage.segment,
         {ctor: "_Tuple2",_0: 0,_1: 0},
         $Basics.fromPolar({ctor: "_Tuple2"
                           ,_0: 60
                           ,_1: windOriginRadians}))));
         var windAngleText = $Graphics$Collage.alpha(0.5)($Graphics$Collage.move($Basics.fromPolar({ctor: "_Tuple2"
                                                                                                   ,_0: 30
                                                                                                   ,_1: windOriginRadians + $Basics.pi}))($Graphics$Collage.toForm($Text.centered((_U.eq(player.controlMode,
         "FixedAngle") ? $Text.line($Text.Under) : $Basics.identity)($Render$Utils.baseText(A2($Basics._op["++"],
         $Basics.toString($Basics.abs($Basics.round(player.windAngle))),
         "&deg;")))))));
         return $Graphics$Collage.group(_L.fromArray([windLine
                                                     ,windMarker
                                                     ,windAngleText]));
      }();
   };
   var vmgColorAndShape = function (player) {
      return function () {
         var s = 4;
         var bad = {ctor: "_Tuple2"
                   ,_0: $Color.red
                   ,_1: A2($Graphics$Collage.rect,
                   s * 2,
                   s * 2)};
         var good = {ctor: "_Tuple2"
                    ,_0: $Render$Utils.colors.green
                    ,_1: $Graphics$Collage.circle(s)};
         var warn = {ctor: "_Tuple2"
                    ,_0: $Color.orange
                    ,_1: $Graphics$Collage.polygon(_L.fromArray([{ctor: "_Tuple2"
                                                                 ,_0: 0 - s
                                                                 ,_1: 0 - s}
                                                                ,{ctor: "_Tuple2"
                                                                 ,_0: s
                                                                 ,_1: 0 - s}
                                                                ,{ctor: "_Tuple2"
                                                                 ,_0: 0
                                                                 ,_1: s}]))};
         var margin = 3;
         var a = $Basics.abs(player.windAngle);
         return _U.cmp(a,
         90) < 0 ? _U.cmp(a,
         player.upwindVmg.angle - margin) < 0 ? bad : _U.cmp(a,
         player.upwindVmg.angle + margin) > 0 ? warn : good : _U.cmp(a,
         player.downwindVmg.angle + margin) > 0 ? bad : _U.cmp(a,
         player.downwindVmg.angle - margin) < 0 ? warn : good;
      }();
   };
   var renderVmgSign = function (player) {
      return function () {
         var $ = vmgColorAndShape(player),
         vmgColor = $._0,
         vmgShape = $._1;
         var windOriginRadians = $Core.toRadians(player.heading - player.windAngle);
         return $Graphics$Collage.move($Basics.fromPolar({ctor: "_Tuple2"
                                                         ,_0: 30
                                                         ,_1: windOriginRadians + $Basics.pi / 2}))($Graphics$Collage.group(_L.fromArray([$Graphics$Collage.filled(vmgColor)(vmgShape)
                                                                                                                                         ,$Graphics$Collage.outlined($Graphics$Collage.solid($Color.white))(vmgShape)])));
      }();
   };
   var renderPlayer = F3(function (gameMode,
   shadowLength,
   player) {
      return function () {
         var wake = renderWake(player.trail);
         var eqLine = A2(renderEqualityLine,
         player.position,
         player.windOrigin);
         var vmgSign = renderVmgSign(player);
         var angles = renderPlayerAngles(player);
         var windShadow = function () {
            switch (gameMode.ctor)
            {case "Race":
               return A2(renderWindShadow,
                 shadowLength,
                 player);
               case "TimeTrial":
               return $Render$Utils.emptyForm;}
            _U.badCase($moduleName,
            "between lines 106 and 109");
         }();
         var hull = A2(rotateHull,
         player.heading,
         baseHull);
         var movingPart = $Graphics$Collage.move(player.position)($Graphics$Collage.group(_L.fromArray([angles
                                                                                                       ,vmgSign
                                                                                                       ,eqLine
                                                                                                       ,hull])));
         return $Graphics$Collage.group(_L.fromArray([wake
                                                     ,windShadow
                                                     ,movingPart]));
      }();
   });
   var renderPlayers = function (_v15) {
      return function () {
         return function () {
            var filteredOpponents = function () {
               var _v17 = _v15.watchMode;
               switch (_v17.ctor)
               {case "NotWatching":
                  return _v15.opponents;
                  case "Watching":
                  return A2($List.filter,
                    function (o) {
                       return !_U.eq(o.player.id,
                       _v17._0);
                    },
                    _v15.opponents);}
               _U.badCase($moduleName,
               "between lines 162 and 165");
            }();
            var mainPlayer = function () {
               var _v19 = _v15.playerState;
               switch (_v19.ctor)
               {case "Just":
                  return A3(renderPlayer,
                    _v15.gameMode,
                    _v15.course.windShadowLength,
                    _v19._0);
                  case "Nothing":
                  return function () {
                       var _v21 = _v15.watchMode;
                       switch (_v21.ctor)
                       {case "NotWatching":
                          return $Render$Utils.emptyForm;
                          case "Watching":
                          return $Maybe.withDefault($Render$Utils.emptyForm)(A2($Maybe.map,
                            A2(renderPlayer,
                            _v15.gameMode,
                            _v15.course.windShadowLength),
                            A2($Game.findOpponent,
                            _v15.opponents,
                            _v21._0)));}
                       _U.badCase($moduleName,
                       "between lines 157 and 162");
                    }();}
               _U.badCase($moduleName,
               "between lines 154 and 162");
            }();
            var forms = _L.fromArray([A2(renderOpponents,
                                     _v15.course,
                                     filteredOpponents)
                                     ,renderGhosts(_v15.ghosts)
                                     ,mainPlayer]);
            return $Graphics$Collage.group(forms);
         }();
      }();
   };
   _elm.Render.Players.values = {_op: _op
                                ,vmgColorAndShape: vmgColorAndShape
                                ,renderVmgSign: renderVmgSign
                                ,renderPlayerAngles: renderPlayerAngles
                                ,renderEqualityLine: renderEqualityLine
                                ,renderWake: renderWake
                                ,renderWindShadow: renderWindShadow
                                ,baseHull: baseHull
                                ,rotateHull: rotateHull
                                ,renderPlayer: renderPlayer
                                ,renderOpponent: renderOpponent
                                ,renderOpponents: renderOpponents
                                ,renderGhost: renderGhost
                                ,renderGhosts: renderGhosts
                                ,renderPlayers: renderPlayers};
   return _elm.Render.Players.values;
};
Elm.Render = Elm.Render || {};
Elm.Render.Utils = Elm.Render.Utils || {};
Elm.Render.Utils.make = function (_elm) {
   "use strict";
   _elm.Render = _elm.Render || {};
   _elm.Render.Utils = _elm.Render.Utils || {};
   if (_elm.Render.Utils.values)
   return _elm.Render.Utils.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _P = _N.Ports.make(_elm),
   $moduleName = "Render.Utils",
   $Basics = Elm.Basics.make(_elm),
   $Color = Elm.Color.make(_elm),
   $Game = Elm.Game.make(_elm),
   $Graphics$Collage = Elm.Graphics.Collage.make(_elm),
   $Graphics$Element = Elm.Graphics.Element.make(_elm),
   $List = Elm.List.make(_elm),
   $Maybe = Elm.Maybe.make(_elm),
   $String = Elm.String.make(_elm),
   $Text = Elm.Text.make(_elm),
   $Time = Elm.Time.make(_elm);
   var formatTimer = F2(function (t,
   showMs) {
      return function () {
         var t$ = $Basics.abs($Basics.ceiling(t));
         var totalSeconds = t$ / 1000 | 0;
         var minutes = totalSeconds / 60 | 0;
         var sMinutes = $Basics.toString(minutes);
         var seconds = showMs || _U.cmp(t,
         0) < 1 ? A2($Basics.rem,
         totalSeconds,
         60) : A2($Basics.rem,
         totalSeconds,
         60) + 1;
         var sSeconds = A3($String.padLeft,
         2,
         _U.chr("0"),
         $Basics.toString(seconds));
         var millis = A2($Basics.rem,
         t$,
         1000);
         var sMillis = showMs ? A2($Basics._op["++"],
         ".",
         A3($String.padLeft,
         3,
         _U.chr("0"),
         $Basics.toString(millis))) : "";
         return A2($Basics._op["++"],
         sMinutes,
         A2($Basics._op["++"],
         ":",
         A2($Basics._op["++"],
         sSeconds,
         sMillis)));
      }();
   });
   var gameTitle = function (_v0) {
      return function () {
         return function () {
            var _v2 = _v0.countdown;
            switch (_v2.ctor)
            {case "Just":
               return _U.cmp(_v2._0,
                 0) > 0 ? A2(formatTimer,
                 _v2._0,
                 false) : "Started";
               case "Nothing":
               return function () {
                    var _v4 = _v0.watchMode;
                    switch (_v4.ctor)
                    {case "NotWatching":
                       return A2($Basics._op["++"],
                         "(",
                         A2($Basics._op["++"],
                         $Basics.toString(1 + $List.length(_v0.opponents)),
                         ") Waiting..."));
                       case "Watching":
                       return "Waiting...";}
                    _U.badCase($moduleName,
                    "between lines 73 and 75");
                 }();}
            _U.badCase($moduleName,
            "between lines 70 and 75");
         }();
      }();
   };
   var fixedLength = F2(function (l,
   txt) {
      return _U.cmp($String.length(txt),
      l) < 0 ? A3($String.padRight,
      l,
      _U.chr(" "),
      txt) : A2($Basics._op["++"],
      A2($String.left,l - 3,txt),
      "...");
   });
   var bigText = function (s) {
      return $Text.typeface(_L.fromArray(["Inconsolata"
                                         ,"monospace"]))($Text.height(32)($Text.fromString(s)));
   };
   var baseText = function (s) {
      return $Text.typeface(_L.fromArray(["Inconsolata"
                                         ,"monospace"]))($Text.height(15)($Text.fromString(s)));
   };
   var colors = {_: {}
                ,gateLine: A3($Color.rgb,
                234,
                99,
                68)
                ,gateMark: $Color.white
                ,green: A3($Color.rgb,
                100,
                180,
                106)
                ,orange: A3($Color.rgb,
                234,
                99,
                68)
                ,sand: A3($Color.rgb,224,163,73)
                ,seaBlue: A3($Color.rgb,
                35,
                57,
                92)};
   var emptyForm = $Graphics$Collage.toForm($Graphics$Element.empty);
   var startCountdownMessage = "press C to start countdown (60s)";
   var helpMessage = A2($Basics._op["++"],
   "ARROWS: turn left/right\n",
   A2($Basics._op["++"],
   "ENTER:  lock angle to wind\n",
   "SPACE:  tack or jibe"));
   _elm.Render.Utils.values = {_op: _op
                              ,helpMessage: helpMessage
                              ,startCountdownMessage: startCountdownMessage
                              ,emptyForm: emptyForm
                              ,colors: colors
                              ,baseText: baseText
                              ,bigText: bigText
                              ,fixedLength: fixedLength
                              ,formatTimer: formatTimer
                              ,gameTitle: gameTitle};
   return _elm.Render.Utils.values;
};
Elm.Result = Elm.Result || {};
Elm.Result.make = function (_elm) {
   "use strict";
   _elm.Result = _elm.Result || {};
   if (_elm.Result.values)
   return _elm.Result.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _P = _N.Ports.make(_elm),
   $moduleName = "Result",
   $Maybe = Elm.Maybe.make(_elm);
   var toMaybe = function (result) {
      return function () {
         switch (result.ctor)
         {case "Err":
            return $Maybe.Nothing;
            case "Ok":
            return $Maybe.Just(result._0);}
         _U.badCase($moduleName,
         "between lines 110 and 123");
      }();
   };
   var Err = function (a) {
      return {ctor: "Err",_0: a};
   };
   var andThen = F2(function (result,
   callback) {
      return function () {
         switch (result.ctor)
         {case "Err":
            return Err(result._0);
            case "Ok":
            return callback(result._0);}
         _U.badCase($moduleName,
         "between lines 72 and 91");
      }();
   });
   var Ok = function (a) {
      return {ctor: "Ok",_0: a};
   };
   var map = F2(function (f,
   result) {
      return function () {
         switch (result.ctor)
         {case "Err":
            return Err(result._0);
            case "Ok":
            return Ok(f(result._0));}
         _U.badCase($moduleName,
         "between lines 32 and 69");
      }();
   });
   var formatError = F2(function (f,
   result) {
      return function () {
         switch (result.ctor)
         {case "Err":
            return Err(f(result._0));
            case "Ok":
            return Ok(result._0);}
         _U.badCase($moduleName,
         "between lines 94 and 107");
      }();
   });
   var fromMaybe = F2(function (err,
   maybe) {
      return function () {
         switch (maybe.ctor)
         {case "Just":
            return Ok(maybe._0);
            case "Nothing":
            return Err(err);}
         _U.badCase($moduleName,
         "between lines 126 and 128");
      }();
   });
   _elm.Result.values = {_op: _op
                        ,Ok: Ok
                        ,Err: Err
                        ,map: map
                        ,andThen: andThen
                        ,formatError: formatError
                        ,toMaybe: toMaybe
                        ,fromMaybe: fromMaybe};
   return _elm.Result.values;
};
Elm.Signal = Elm.Signal || {};
Elm.Signal.make = function (_elm) {
   "use strict";
   _elm.Signal = _elm.Signal || {};
   if (_elm.Signal.values)
   return _elm.Signal.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _P = _N.Ports.make(_elm),
   $moduleName = "Signal",
   $Basics = Elm.Basics.make(_elm),
   $List = Elm.List.make(_elm),
   $Native$Signal = Elm.Native.Signal.make(_elm);
   var subscribe = $Native$Signal.subscribe;
   var send = $Native$Signal.send;
   var channel = $Native$Signal.input;
   var Message = {ctor: "Message"};
   var Channel = {ctor: "Channel"};
   _op["~"] = F2(function (sf,s) {
      return A3($Native$Signal.map2,
      F2(function (f,x) {
         return f(x);
      }),
      sf,
      s);
   });
   _op["<~"] = F2(function (f,s) {
      return A2($Native$Signal.map,
      f,
      s);
   });
   var sampleOn = $Native$Signal.sampleOn;
   var dropRepeats = $Native$Signal.dropRepeats;
   var dropIf = $Native$Signal.dropIf;
   var keepIf = $Native$Signal.keepIf;
   var keepWhen = F3(function (bs,
   def,
   sig) {
      return A2(_op["<~"],
      $Basics.snd,
      A3(keepIf,
      $Basics.fst,
      {ctor: "_Tuple2"
      ,_0: false
      ,_1: def},
      A2(_op["~"],
      A2(_op["<~"],
      F2(function (v0,v1) {
         return {ctor: "_Tuple2"
                ,_0: v0
                ,_1: v1};
      }),
      A2(sampleOn,sig,bs)),
      sig)));
   });
   var dropWhen = function (bs) {
      return keepWhen(A2(_op["<~"],
      $Basics.not,
      bs));
   };
   var merge = $Native$Signal.merge;
   var mergeMany = function (signals) {
      return A2($List.foldr1,
      merge,
      signals);
   };
   var foldp = $Native$Signal.foldp;
   var map5 = $Native$Signal.map5;
   var map4 = $Native$Signal.map4;
   var map3 = $Native$Signal.map3;
   var map2 = $Native$Signal.map2;
   var map = $Native$Signal.map;
   var constant = $Native$Signal.constant;
   var Signal = {ctor: "Signal"};
   _elm.Signal.values = {_op: _op
                        ,Signal: Signal
                        ,constant: constant
                        ,map: map
                        ,map2: map2
                        ,map3: map3
                        ,map4: map4
                        ,map5: map5
                        ,foldp: foldp
                        ,merge: merge
                        ,mergeMany: mergeMany
                        ,keepIf: keepIf
                        ,dropIf: dropIf
                        ,keepWhen: keepWhen
                        ,dropWhen: dropWhen
                        ,dropRepeats: dropRepeats
                        ,sampleOn: sampleOn
                        ,Channel: Channel
                        ,Message: Message
                        ,channel: channel
                        ,send: send
                        ,subscribe: subscribe};
   return _elm.Signal.values;
};
Elm.Steps = Elm.Steps || {};
Elm.Steps.make = function (_elm) {
   "use strict";
   _elm.Steps = _elm.Steps || {};
   if (_elm.Steps.values)
   return _elm.Steps.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _P = _N.Ports.make(_elm),
   $moduleName = "Steps",
   $Basics = Elm.Basics.make(_elm),
   $Game = Elm.Game.make(_elm),
   $Inputs = Elm.Inputs.make(_elm),
   $Maybe = Elm.Maybe.make(_elm);
   var watchStep = F2(function (input,
   gameState) {
      return function () {
         var watchMode = function () {
            var _v0 = {ctor: "_Tuple2"
                      ,_0: input.watchedPlayerId
                      ,_1: gameState.watchMode};
            switch (_v0.ctor)
            {case "_Tuple2":
               switch (_v0._0.ctor)
                 {case "Just":
                    return $Game.Watching(_v0._0._0);
                    case "Nothing":
                    switch (_v0._1.ctor)
                      {case "NotWatching":
                         return $Game.Watching(gameState.playerId);}
                      break;}
                 break;}
            return gameState.watchMode;
         }();
         return _U.replace([["watchMode"
                            ,watchMode]],
         gameState);
      }();
   });
   var raceInputStep = F2(function (raceInput,
   gameState) {
      return function () {
         var $ = raceInput,
         playerId = $.playerId,
         playerState = $.playerState,
         now = $.now,
         startTime = $.startTime,
         course = $.course,
         opponents = $.opponents,
         ghosts = $.ghosts,
         wind = $.wind,
         leaderboard = $.leaderboard,
         isMaster = $.isMaster,
         watching = $.watching,
         timeTrial = $.timeTrial;
         var gameMode = timeTrial ? $Game.TimeTrial : $Game.Race;
         return _U.replace([["opponents"
                            ,opponents]
                           ,["ghosts",ghosts]
                           ,["playerId",playerId]
                           ,["playerState",playerState]
                           ,["course"
                            ,A2($Maybe.withDefault,
                            gameState.course,
                            course)]
                           ,["wind",wind]
                           ,["leaderboard",leaderboard]
                           ,["now",now]
                           ,["countdown"
                            ,A2($Maybe.map,
                            function (st) {
                               return st - now;
                            },
                            startTime)]
                           ,["gameMode",gameMode]
                           ,["isMaster",isMaster]],
         gameState);
      }();
   });
   var centerStep = function (gameState) {
      return function () {
         var newCenter = function () {
            var _v4 = gameState.watchMode;
            switch (_v4.ctor)
            {case "NotWatching":
               return function () {
                    var _v6 = gameState.playerState;
                    switch (_v6.ctor)
                    {case "Just":
                       return _v6._0.position;
                       case "Nothing":
                       return gameState.center;}
                    _U.badCase($moduleName,
                    "between lines 18 and 21");
                 }();
               case "Watching":
               return function () {
                    var _v8 = A2($Game.findOpponent,
                    gameState.opponents,
                    _v4._0);
                    switch (_v8.ctor)
                    {case "Just":
                       return _v8._0.position;
                       case "Nothing":
                       return gameState.center;}
                    _U.badCase($moduleName,
                    "between lines 14 and 17");
                 }();}
            _U.badCase($moduleName,
            "between lines 12 and 21");
         }();
         return _U.replace([["center"
                            ,newCenter]],
         gameState);
      }();
   };
   var stepGame = F2(function (_v10,
   gameState) {
      return function () {
         return centerStep((_v10.raceInput.watching ? watchStep(_v10.watcherInput) : $Basics.identity)(A2(raceInputStep,
         _v10.raceInput,
         gameState)));
      }();
   });
   _elm.Steps.values = {_op: _op
                       ,centerStep: centerStep
                       ,raceInputStep: raceInputStep
                       ,watchStep: watchStep
                       ,stepGame: stepGame};
   return _elm.Steps.values;
};
Elm.String = Elm.String || {};
Elm.String.make = function (_elm) {
   "use strict";
   _elm.String = _elm.String || {};
   if (_elm.String.values)
   return _elm.String.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _P = _N.Ports.make(_elm),
   $moduleName = "String",
   $Maybe = Elm.Maybe.make(_elm),
   $Native$String = Elm.Native.String.make(_elm),
   $Result = Elm.Result.make(_elm);
   var fromList = $Native$String.fromList;
   var toList = $Native$String.toList;
   var toFloat = $Native$String.toFloat;
   var toInt = $Native$String.toInt;
   var indices = $Native$String.indexes;
   var indexes = $Native$String.indexes;
   var endsWith = $Native$String.endsWith;
   var startsWith = $Native$String.startsWith;
   var contains = $Native$String.contains;
   var all = $Native$String.all;
   var any = $Native$String.any;
   var toLower = $Native$String.toLower;
   var toUpper = $Native$String.toUpper;
   var lines = $Native$String.lines;
   var words = $Native$String.words;
   var trimRight = $Native$String.trimRight;
   var trimLeft = $Native$String.trimLeft;
   var trim = $Native$String.trim;
   var padRight = $Native$String.padRight;
   var padLeft = $Native$String.padLeft;
   var pad = $Native$String.pad;
   var dropRight = $Native$String.dropRight;
   var dropLeft = $Native$String.dropLeft;
   var right = $Native$String.right;
   var left = $Native$String.left;
   var slice = $Native$String.slice;
   var repeat = $Native$String.repeat;
   var join = $Native$String.join;
   var split = $Native$String.split;
   var foldr = $Native$String.foldr;
   var foldl = $Native$String.foldl;
   var reverse = $Native$String.reverse;
   var filter = $Native$String.filter;
   var map = $Native$String.map;
   var length = $Native$String.length;
   var concat = $Native$String.concat;
   var append = $Native$String.append;
   var uncons = $Native$String.uncons;
   var cons = $Native$String.cons;
   var fromChar = function ($char) {
      return A2(cons,$char,"");
   };
   var isEmpty = $Native$String.isEmpty;
   _elm.String.values = {_op: _op
                        ,isEmpty: isEmpty
                        ,cons: cons
                        ,fromChar: fromChar
                        ,uncons: uncons
                        ,append: append
                        ,concat: concat
                        ,length: length
                        ,map: map
                        ,filter: filter
                        ,reverse: reverse
                        ,foldl: foldl
                        ,foldr: foldr
                        ,split: split
                        ,join: join
                        ,repeat: repeat
                        ,slice: slice
                        ,left: left
                        ,right: right
                        ,dropLeft: dropLeft
                        ,dropRight: dropRight
                        ,pad: pad
                        ,padLeft: padLeft
                        ,padRight: padRight
                        ,trim: trim
                        ,trimLeft: trimLeft
                        ,trimRight: trimRight
                        ,words: words
                        ,lines: lines
                        ,toUpper: toUpper
                        ,toLower: toLower
                        ,any: any
                        ,all: all
                        ,contains: contains
                        ,startsWith: startsWith
                        ,endsWith: endsWith
                        ,indexes: indexes
                        ,indices: indices
                        ,toInt: toInt
                        ,toFloat: toFloat
                        ,toList: toList
                        ,fromList: fromList};
   return _elm.String.values;
};
Elm.Text = Elm.Text || {};
Elm.Text.make = function (_elm) {
   "use strict";
   _elm.Text = _elm.Text || {};
   if (_elm.Text.values)
   return _elm.Text.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _P = _N.Ports.make(_elm),
   $moduleName = "Text",
   $Basics = Elm.Basics.make(_elm),
   $Color = Elm.Color.make(_elm),
   $Graphics$Element = Elm.Graphics.Element.make(_elm),
   $List = Elm.List.make(_elm),
   $Maybe = Elm.Maybe.make(_elm),
   $Native$Text = Elm.Native.Text.make(_elm);
   var markdown = $Native$Text.markdown;
   var justified = $Native$Text.justified;
   var centered = $Native$Text.centered;
   var rightAligned = $Native$Text.rightAligned;
   var leftAligned = $Native$Text.leftAligned;
   var line = $Native$Text.line;
   var italic = $Native$Text.italic;
   var bold = $Native$Text.bold;
   var color = $Native$Text.color;
   var height = $Native$Text.height;
   var link = $Native$Text.link;
   var monospace = $Native$Text.monospace;
   var typeface = $Native$Text.typeface;
   var style = $Native$Text.style;
   var append = $Native$Text.append;
   var fromString = $Native$Text.fromString;
   var empty = fromString("");
   var concat = function (texts) {
      return A3($List.foldr,
      append,
      empty,
      texts);
   };
   var join = F2(function (seperator,
   texts) {
      return concat(A2($List.intersperse,
      seperator,
      texts));
   });
   var plainText = function (str) {
      return leftAligned(fromString(str));
   };
   var asText = function (value) {
      return leftAligned(monospace(fromString($Basics.toString(value))));
   };
   var defaultStyle = {_: {}
                      ,bold: false
                      ,color: $Color.black
                      ,height: $Maybe.Nothing
                      ,italic: false
                      ,line: $Maybe.Nothing
                      ,typeface: _L.fromArray([])};
   var Style = F6(function (a,
   b,
   c,
   d,
   e,
   f) {
      return {_: {}
             ,bold: d
             ,color: c
             ,height: b
             ,italic: e
             ,line: f
             ,typeface: a};
   });
   var Through = {ctor: "Through"};
   var Over = {ctor: "Over"};
   var Under = {ctor: "Under"};
   var Text = {ctor: "Text"};
   _elm.Text.values = {_op: _op
                      ,Text: Text
                      ,Under: Under
                      ,Over: Over
                      ,Through: Through
                      ,Style: Style
                      ,defaultStyle: defaultStyle
                      ,fromString: fromString
                      ,empty: empty
                      ,append: append
                      ,concat: concat
                      ,join: join
                      ,style: style
                      ,typeface: typeface
                      ,monospace: monospace
                      ,link: link
                      ,height: height
                      ,color: color
                      ,bold: bold
                      ,italic: italic
                      ,line: line
                      ,leftAligned: leftAligned
                      ,rightAligned: rightAligned
                      ,centered: centered
                      ,justified: justified
                      ,plainText: plainText
                      ,markdown: markdown
                      ,asText: asText};
   return _elm.Text.values;
};
Elm.Time = Elm.Time || {};
Elm.Time.make = function (_elm) {
   "use strict";
   _elm.Time = _elm.Time || {};
   if (_elm.Time.values)
   return _elm.Time.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _P = _N.Ports.make(_elm),
   $moduleName = "Time",
   $Basics = Elm.Basics.make(_elm),
   $Native$Time = Elm.Native.Time.make(_elm),
   $Signal = Elm.Signal.make(_elm);
   var delay = $Native$Time.delay;
   var timestamp = $Native$Time.timestamp;
   var since = F2(function (t,s) {
      return function () {
         var stop = A2($Signal.map,
         $Basics.always(-1),
         A2(delay,t,s));
         var start = A2($Signal.map,
         $Basics.always(1),
         s);
         var delaydiff = A3($Signal.foldp,
         F2(function (x,y) {
            return x + y;
         }),
         0,
         A2($Signal.merge,start,stop));
         return A2($Signal.map,
         F2(function (x,y) {
            return !_U.eq(x,y);
         })(0),
         delaydiff);
      }();
   });
   var every = $Native$Time.every;
   var fpsWhen = $Native$Time.fpsWhen;
   var fps = $Native$Time.fps;
   var inMilliseconds = function (t) {
      return t;
   };
   var millisecond = 1;
   var second = 1000 * millisecond;
   var minute = 60 * second;
   var hour = 60 * minute;
   var inHours = function (t) {
      return t / hour;
   };
   var inMinutes = function (t) {
      return t / minute;
   };
   var inSeconds = function (t) {
      return t / second;
   };
   _elm.Time.values = {_op: _op
                      ,millisecond: millisecond
                      ,second: second
                      ,minute: minute
                      ,hour: hour
                      ,inMilliseconds: inMilliseconds
                      ,inSeconds: inSeconds
                      ,inMinutes: inMinutes
                      ,inHours: inHours
                      ,fps: fps
                      ,fpsWhen: fpsWhen
                      ,every: every
                      ,since: since
                      ,timestamp: timestamp
                      ,delay: delay};
   return _elm.Time.values;
};
Elm.Transform2D = Elm.Transform2D || {};
Elm.Transform2D.make = function (_elm) {
   "use strict";
   _elm.Transform2D = _elm.Transform2D || {};
   if (_elm.Transform2D.values)
   return _elm.Transform2D.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _P = _N.Ports.make(_elm),
   $moduleName = "Transform2D",
   $Native$Transform2D = Elm.Native.Transform2D.make(_elm);
   var multiply = $Native$Transform2D.multiply;
   var rotation = $Native$Transform2D.rotation;
   var matrix = $Native$Transform2D.matrix;
   var translation = F2(function (x,
   y) {
      return A6(matrix,
      1,
      0,
      0,
      1,
      x,
      y);
   });
   var scale = function (s) {
      return A6(matrix,
      s,
      0,
      0,
      s,
      0,
      0);
   };
   var scaleX = function (x) {
      return A6(matrix,
      x,
      0,
      0,
      1,
      0,
      0);
   };
   var scaleY = function (y) {
      return A6(matrix,
      1,
      0,
      0,
      y,
      0,
      0);
   };
   var identity = $Native$Transform2D.identity;
   var Transform2D = {ctor: "Transform2D"};
   _elm.Transform2D.values = {_op: _op
                             ,identity: identity
                             ,matrix: matrix
                             ,multiply: multiply
                             ,rotation: rotation
                             ,translation: translation
                             ,scale: scale
                             ,scaleX: scaleX
                             ,scaleY: scaleY};
   return _elm.Transform2D.values;
};
Elm.Window = Elm.Window || {};
Elm.Window.make = function (_elm) {
   "use strict";
   _elm.Window = _elm.Window || {};
   if (_elm.Window.values)
   return _elm.Window.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _P = _N.Ports.make(_elm),
   $moduleName = "Window",
   $Native$Window = Elm.Native.Window.make(_elm),
   $Signal = Elm.Signal.make(_elm);
   var height = $Native$Window.height;
   var width = $Native$Window.width;
   var dimensions = $Native$Window.dimensions;
   _elm.Window.values = {_op: _op
                        ,dimensions: dimensions
                        ,width: width
                        ,height: height};
   return _elm.Window.values;
};
