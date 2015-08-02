var Elm = Elm || { Native: {} };
Elm.Array = Elm.Array || {};
Elm.Array.make = function (_elm) {
   "use strict";
   _elm.Array = _elm.Array || {};
   if (_elm.Array.values)
   return _elm.Array.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   $moduleName = "Array",
   $Basics = Elm.Basics.make(_elm),
   $List = Elm.List.make(_elm),
   $Maybe = Elm.Maybe.make(_elm),
   $Native$Array = Elm.Native.Array.make(_elm);
   var append = $Native$Array.append;
   var length = $Native$Array.length;
   var isEmpty = function (array) {
      return _U.eq(length(array),
      0);
   };
   var slice = $Native$Array.slice;
   var set = $Native$Array.set;
   var get = F2(function (i,
   array) {
      return _U.cmp(0,
      i) < 1 && _U.cmp(i,
      $Native$Array.length(array)) < 0 ? $Maybe.Just(A2($Native$Array.get,
      i,
      array)) : $Maybe.Nothing;
   });
   var push = $Native$Array.push;
   var empty = $Native$Array.empty;
   var filter = F2(function (isOkay,
   arr) {
      return function () {
         var update = F2(function (x,
         xs) {
            return isOkay(x) ? A2($Native$Array.push,
            x,
            xs) : xs;
         });
         return A3($Native$Array.foldl,
         update,
         $Native$Array.empty,
         arr);
      }();
   });
   var foldr = $Native$Array.foldr;
   var foldl = $Native$Array.foldl;
   var indexedMap = $Native$Array.indexedMap;
   var map = $Native$Array.map;
   var toIndexedList = function (array) {
      return A3($List.map2,
      F2(function (v0,v1) {
         return {ctor: "_Tuple2"
                ,_0: v0
                ,_1: v1};
      }),
      _L.range(0,
      $Native$Array.length(array) - 1),
      $Native$Array.toList(array));
   };
   var toList = $Native$Array.toList;
   var fromList = $Native$Array.fromList;
   var initialize = $Native$Array.initialize;
   var repeat = F2(function (n,e) {
      return A2(initialize,
      n,
      $Basics.always(e));
   });
   var Array = {ctor: "Array"};
   _elm.Array.values = {_op: _op
                       ,empty: empty
                       ,repeat: repeat
                       ,initialize: initialize
                       ,fromList: fromList
                       ,isEmpty: isEmpty
                       ,length: length
                       ,push: push
                       ,append: append
                       ,get: get
                       ,set: set
                       ,slice: slice
                       ,toList: toList
                       ,toIndexedList: toIndexedList
                       ,map: map
                       ,indexedMap: indexedMap
                       ,filter: filter
                       ,foldl: foldl
                       ,foldr: foldr};
   return _elm.Array.values;
};
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
         "on line 595, column 3 to 8");
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
         "on line 573, column 3 to 4");
      }();
   };
   var fst = function (_v8) {
      return function () {
         switch (_v8.ctor)
         {case "_Tuple2": return _v8._0;}
         _U.badCase($moduleName,
         "on line 567, column 3 to 4");
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
                        ,max: max
                        ,min: min
                        ,compare: compare
                        ,not: not
                        ,xor: xor
                        ,otherwise: otherwise
                        ,rem: rem
                        ,negate: negate
                        ,abs: abs
                        ,sqrt: sqrt
                        ,clamp: clamp
                        ,logBase: logBase
                        ,e: e
                        ,pi: pi
                        ,cos: cos
                        ,sin: sin
                        ,tan: tan
                        ,acos: acos
                        ,asin: asin
                        ,atan: atan
                        ,atan2: atan2
                        ,round: round
                        ,floor: floor
                        ,ceiling: ceiling
                        ,truncate: truncate
                        ,toFloat: toFloat
                        ,degrees: degrees
                        ,radians: radians
                        ,turns: turns
                        ,toPolar: toPolar
                        ,fromPolar: fromPolar
                        ,isNaN: isNaN
                        ,isInfinite: isInfinite
                        ,toString: toString
                        ,fst: fst
                        ,snd: snd
                        ,identity: identity
                        ,always: always
                        ,flip: flip
                        ,curry: curry
                        ,uncurry: uncurry
                        ,LT: LT
                        ,EQ: EQ
                        ,GT: GT};
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
   $moduleName = "Char",
   $Basics = Elm.Basics.make(_elm),
   $Native$Char = Elm.Native.Char.make(_elm);
   var fromCode = $Native$Char.fromCode;
   var toCode = $Native$Char.toCode;
   var toLocaleLower = $Native$Char.toLocaleLower;
   var toLocaleUpper = $Native$Char.toLocaleUpper;
   var toLower = $Native$Char.toLower;
   var toUpper = $Native$Char.toUpper;
   var isBetween = F3(function (low,
   high,
   $char) {
      return function () {
         var code = toCode($char);
         return _U.cmp(code,
         toCode(low)) > -1 && _U.cmp(code,
         toCode(high)) < 1;
      }();
   });
   var isUpper = A2(isBetween,
   _U.chr("A"),
   _U.chr("Z"));
   var isLower = A2(isBetween,
   _U.chr("a"),
   _U.chr("z"));
   var isDigit = A2(isBetween,
   _U.chr("0"),
   _U.chr("9"));
   var isOctDigit = A2(isBetween,
   _U.chr("0"),
   _U.chr("7"));
   var isHexDigit = function ($char) {
      return isDigit($char) || (A3(isBetween,
      _U.chr("a"),
      _U.chr("f"),
      $char) || A3(isBetween,
      _U.chr("A"),
      _U.chr("F"),
      $char));
   };
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
         "between lines 150 and 152"));
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
         "between lines 124 and 132");
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
         "between lines 114 and 118");
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
         "between lines 105 and 108");
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
                       ,rgb: rgb
                       ,rgba: rgba
                       ,hsl: hsl
                       ,hsla: hsla
                       ,greyscale: greyscale
                       ,grayscale: grayscale
                       ,complement: complement
                       ,linear: linear
                       ,radial: radial
                       ,toRgb: toRgb
                       ,toHsl: toHsl
                       ,red: red
                       ,orange: orange
                       ,yellow: yellow
                       ,green: green
                       ,blue: blue
                       ,purple: purple
                       ,brown: brown
                       ,lightRed: lightRed
                       ,lightOrange: lightOrange
                       ,lightYellow: lightYellow
                       ,lightGreen: lightGreen
                       ,lightBlue: lightBlue
                       ,lightPurple: lightPurple
                       ,lightBrown: lightBrown
                       ,darkRed: darkRed
                       ,darkOrange: darkOrange
                       ,darkYellow: darkYellow
                       ,darkGreen: darkGreen
                       ,darkBlue: darkBlue
                       ,darkPurple: darkPurple
                       ,darkBrown: darkBrown
                       ,white: white
                       ,lightGrey: lightGrey
                       ,grey: grey
                       ,darkGrey: darkGrey
                       ,lightCharcoal: lightCharcoal
                       ,charcoal: charcoal
                       ,darkCharcoal: darkCharcoal
                       ,black: black
                       ,lightGray: lightGray
                       ,gray: gray
                       ,darkGray: darkGray};
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
   $moduleName = "Core",
   $Basics = Elm.Basics.make(_elm),
   $List = Elm.List.make(_elm),
   $Maybe = Elm.Maybe.make(_elm),
   $Result = Elm.Result.make(_elm),
   $Signal = Elm.Signal.make(_elm),
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
   var floatRange = F2(function (from,
   to) {
      return A2($List.map,
      $Basics.toFloat,
      _L.range(from,to));
   });
   var find = F2(function (f,
   list) {
      return $List.head(A2($List.filter,
      f,
      list));
   });
   var exists = F2(function (f,
   list) {
      return isJust(A2(find,
      f,
      list));
   });
   var lift = F2(function (n,
   items) {
      return $List.head(A2($List.drop,
      n,
      items));
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
               "between lines 35 and 38");
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
   var floatMod = F2(function (val,
   div) {
      return function () {
         var flooredQuotient = $Basics.toFloat($Basics.floor(val / div));
         return val - flooredQuotient * div;
      }();
   });
   var toDegrees = function (rad) {
      return (0 - rad) * 180 / $Basics.pi + 90;
   };
   var toRadians = function (deg) {
      return $Basics.radians((90 - deg) * $Basics.pi / 180);
   };
   _elm.Core.values = {_op: _op
                      ,toRadians: toRadians
                      ,toDegrees: toDegrees
                      ,floatMod: floatMod
                      ,getCountdown: getCountdown
                      ,compact: compact
                      ,average: average
                      ,lift: lift
                      ,find: find
                      ,exists: exists
                      ,floatRange: floatRange
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
Elm.Decoders = Elm.Decoders || {};
Elm.Decoders.make = function (_elm) {
   "use strict";
   _elm.Decoders = _elm.Decoders || {};
   if (_elm.Decoders.values)
   return _elm.Decoders.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   $moduleName = "Decoders",
   $Basics = Elm.Basics.make(_elm),
   $Game = Elm.Game.make(_elm),
   $Geo = Elm.Geo.make(_elm),
   $Json$Decode = Elm.Json.Decode.make(_elm),
   $List = Elm.List.make(_elm),
   $Maybe = Elm.Maybe.make(_elm),
   $Result = Elm.Result.make(_elm),
   $Signal = Elm.Signal.make(_elm),
   $State = Elm.State.make(_elm);
   var windGeneratorDecoder = A5($Json$Decode.object4,
   $Game.WindGenerator,
   A2($Json$Decode._op[":="],
   "wavelength1",
   $Json$Decode.$float),
   A2($Json$Decode._op[":="],
   "amplitude1",
   $Json$Decode.$float),
   A2($Json$Decode._op[":="],
   "wavelength2",
   $Json$Decode.$float),
   A2($Json$Decode._op[":="],
   "amplitude2",
   $Json$Decode.$float));
   var gateDecoder = A3($Json$Decode.object2,
   $Game.Gate,
   A2($Json$Decode._op[":="],
   "y",
   $Json$Decode.$float),
   A2($Json$Decode._op[":="],
   "width",
   $Json$Decode.$float));
   var pointDecoder = A3($Json$Decode.tuple2,
   F2(function (v0,v1) {
      return {ctor: "_Tuple2"
             ,_0: v0
             ,_1: v1};
   }),
   $Json$Decode.$float,
   $Json$Decode.$float);
   var islandDecoder = A3($Json$Decode.object2,
   $Game.Island,
   A2($Json$Decode._op[":="],
   "location",
   pointDecoder),
   A2($Json$Decode._op[":="],
   "radius",
   $Json$Decode.$float));
   var raceAreaDecoder = A3($Json$Decode.object2,
   $Game.RaceArea,
   A2($Json$Decode._op[":="],
   "rightTop",
   pointDecoder),
   A2($Json$Decode._op[":="],
   "leftBottom",
   pointDecoder));
   var courseDecoder = A7($Json$Decode.object6,
   $Game.Course,
   A2($Json$Decode._op[":="],
   "upwind",
   gateDecoder),
   A2($Json$Decode._op[":="],
   "downwind",
   gateDecoder),
   A2($Json$Decode._op[":="],
   "laps",
   $Json$Decode.$int),
   A2($Json$Decode._op[":="],
   "islands",
   $Json$Decode.list(islandDecoder)),
   A2($Json$Decode._op[":="],
   "area",
   raceAreaDecoder),
   A2($Json$Decode._op[":="],
   "windGenerator",
   windGeneratorDecoder));
   var opponentStateDecoder = A9($Json$Decode.object8,
   $Game.OpponentState,
   A2($Json$Decode._op[":="],
   "time",
   $Json$Decode.$float),
   A2($Json$Decode._op[":="],
   "position",
   pointDecoder),
   A2($Json$Decode._op[":="],
   "heading",
   $Json$Decode.$float),
   A2($Json$Decode._op[":="],
   "velocity",
   $Json$Decode.$float),
   A2($Json$Decode._op[":="],
   "windAngle",
   $Json$Decode.$float),
   A2($Json$Decode._op[":="],
   "windOrigin",
   $Json$Decode.$float),
   A2($Json$Decode._op[":="],
   "shadowDirection",
   $Json$Decode.$float),
   A2($Json$Decode._op[":="],
   "crossedGates",
   $Json$Decode.list($Json$Decode.$float)));
   var playerDecoder = A8($Json$Decode.object7,
   $Game.Player,
   A2($Json$Decode._op[":="],
   "id",
   $Json$Decode.string),
   $Json$Decode.maybe(A2($Json$Decode._op[":="],
   "handle",
   $Json$Decode.string)),
   $Json$Decode.maybe(A2($Json$Decode._op[":="],
   "status",
   $Json$Decode.string)),
   $Json$Decode.maybe(A2($Json$Decode._op[":="],
   "avatarId",
   $Json$Decode.string)),
   A2($Json$Decode._op[":="],
   "vmgMagnet",
   $Json$Decode.$int),
   A2($Json$Decode._op[":="],
   "guest",
   $Json$Decode.bool),
   A2($Json$Decode._op[":="],
   "user",
   $Json$Decode.bool));
   var opponentDecoder = A3($Json$Decode.object2,
   $Game.Opponent,
   A2($Json$Decode._op[":="],
   "player",
   playerDecoder),
   A2($Json$Decode._op[":="],
   "state",
   opponentStateDecoder));
   var raceCourseDecoder = A6($Json$Decode.object5,
   $State.RaceCourse,
   A2($Json$Decode._op[":="],
   "_id",
   $Json$Decode.string),
   A2($Json$Decode._op[":="],
   "slug",
   $Json$Decode.string),
   A2($Json$Decode._op[":="],
   "course",
   courseDecoder),
   A2($Json$Decode._op[":="],
   "countdown",
   $Json$Decode.$int),
   A2($Json$Decode._op[":="],
   "startCycle",
   $Json$Decode.$int));
   var raceCourseStatusDecoder = A3($Json$Decode.object2,
   $State.RaceCourseStatus,
   A2($Json$Decode._op[":="],
   "raceCourse",
   raceCourseDecoder),
   A2($Json$Decode._op[":="],
   "opponents",
   $Json$Decode.list(opponentDecoder)));
   _elm.Decoders.values = {_op: _op
                          ,raceCourseStatusDecoder: raceCourseStatusDecoder
                          ,raceCourseDecoder: raceCourseDecoder
                          ,opponentDecoder: opponentDecoder
                          ,playerDecoder: playerDecoder
                          ,opponentStateDecoder: opponentStateDecoder
                          ,pointDecoder: pointDecoder
                          ,courseDecoder: courseDecoder
                          ,gateDecoder: gateDecoder
                          ,islandDecoder: islandDecoder
                          ,raceAreaDecoder: raceAreaDecoder
                          ,windGeneratorDecoder: windGeneratorDecoder};
   return _elm.Decoders.values;
};
Elm.Dict = Elm.Dict || {};
Elm.Dict.make = function (_elm) {
   "use strict";
   _elm.Dict = _elm.Dict || {};
   if (_elm.Dict.values)
   return _elm.Dict.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   $moduleName = "Dict",
   $Basics = Elm.Basics.make(_elm),
   $List = Elm.List.make(_elm),
   $Maybe = Elm.Maybe.make(_elm),
   $Native$Debug = Elm.Native.Debug.make(_elm),
   $String = Elm.String.make(_elm);
   var foldr = F3(function (f,
   acc,
   t) {
      return function () {
         switch (t.ctor)
         {case "RBEmpty":
            switch (t._0.ctor)
              {case "LBlack": return acc;}
              break;
            case "RBNode": return A3(foldr,
              f,
              A3(f,
              t._1,
              t._2,
              A3(foldr,f,acc,t._4)),
              t._3);}
         _U.badCase($moduleName,
         "between lines 417 and 421");
      }();
   });
   var keys = function (dict) {
      return A3(foldr,
      F3(function (key,
      value,
      keyList) {
         return A2($List._op["::"],
         key,
         keyList);
      }),
      _L.fromArray([]),
      dict);
   };
   var values = function (dict) {
      return A3(foldr,
      F3(function (key,
      value,
      valueList) {
         return A2($List._op["::"],
         value,
         valueList);
      }),
      _L.fromArray([]),
      dict);
   };
   var toList = function (dict) {
      return A3(foldr,
      F3(function (key,value,list) {
         return A2($List._op["::"],
         {ctor: "_Tuple2"
         ,_0: key
         ,_1: value},
         list);
      }),
      _L.fromArray([]),
      dict);
   };
   var foldl = F3(function (f,
   acc,
   dict) {
      return function () {
         switch (dict.ctor)
         {case "RBEmpty":
            switch (dict._0.ctor)
              {case "LBlack": return acc;}
              break;
            case "RBNode": return A3(foldl,
              f,
              A3(f,
              dict._1,
              dict._2,
              A3(foldl,f,acc,dict._3)),
              dict._4);}
         _U.badCase($moduleName,
         "between lines 406 and 410");
      }();
   });
   var isBBlack = function (dict) {
      return function () {
         switch (dict.ctor)
         {case "RBEmpty":
            switch (dict._0.ctor)
              {case "LBBlack": return true;}
              break;
            case "RBNode":
            switch (dict._0.ctor)
              {case "BBlack": return true;}
              break;}
         return false;
      }();
   };
   var showFlag = function (f) {
      return function () {
         switch (f.ctor)
         {case "Insert": return "Insert";
            case "Remove": return "Remove";
            case "Same": return "Same";}
         _U.badCase($moduleName,
         "between lines 182 and 185");
      }();
   };
   var Same = {ctor: "Same"};
   var Remove = {ctor: "Remove"};
   var Insert = {ctor: "Insert"};
   var get = F2(function (targetKey,
   dict) {
      return function () {
         switch (dict.ctor)
         {case "RBEmpty":
            switch (dict._0.ctor)
              {case "LBlack":
                 return $Maybe.Nothing;}
              break;
            case "RBNode":
            return function () {
                 var _v29 = A2($Basics.compare,
                 targetKey,
                 dict._1);
                 switch (_v29.ctor)
                 {case "EQ":
                    return $Maybe.Just(dict._2);
                    case "GT": return A2(get,
                      targetKey,
                      dict._4);
                    case "LT": return A2(get,
                      targetKey,
                      dict._3);}
                 _U.badCase($moduleName,
                 "between lines 129 and 132");
              }();}
         _U.badCase($moduleName,
         "between lines 124 and 132");
      }();
   });
   var member = F2(function (key,
   dict) {
      return function () {
         var _v30 = A2(get,key,dict);
         switch (_v30.ctor)
         {case "Just": return true;
            case "Nothing": return false;}
         _U.badCase($moduleName,
         "between lines 138 and 140");
      }();
   });
   var max = function (dict) {
      return function () {
         switch (dict.ctor)
         {case "RBEmpty":
            return $Native$Debug.crash("(max Empty) is not defined");
            case "RBNode":
            switch (dict._4.ctor)
              {case "RBEmpty":
                 return {ctor: "_Tuple2"
                        ,_0: dict._1
                        ,_1: dict._2};}
              return max(dict._4);}
         _U.badCase($moduleName,
         "between lines 100 and 108");
      }();
   };
   var min = function (dict) {
      return function () {
         switch (dict.ctor)
         {case "RBEmpty":
            switch (dict._0.ctor)
              {case "LBlack":
                 return $Native$Debug.crash("(min Empty) is not defined");}
              break;
            case "RBNode":
            switch (dict._3.ctor)
              {case "RBEmpty":
                 switch (dict._3._0.ctor)
                   {case "LBlack":
                      return {ctor: "_Tuple2"
                             ,_0: dict._1
                             ,_1: dict._2};}
                   break;}
              return min(dict._3);}
         _U.badCase($moduleName,
         "between lines 87 and 95");
      }();
   };
   var RBEmpty = function (a) {
      return {ctor: "RBEmpty"
             ,_0: a};
   };
   var RBNode = F5(function (a,
   b,
   c,
   d,
   e) {
      return {ctor: "RBNode"
             ,_0: a
             ,_1: b
             ,_2: c
             ,_3: d
             ,_4: e};
   });
   var showLColor = function (color) {
      return function () {
         switch (color.ctor)
         {case "LBBlack":
            return "LBBlack";
            case "LBlack": return "LBlack";}
         _U.badCase($moduleName,
         "between lines 70 and 72");
      }();
   };
   var LBBlack = {ctor: "LBBlack"};
   var LBlack = {ctor: "LBlack"};
   var empty = RBEmpty(LBlack);
   var isEmpty = function (dict) {
      return _U.eq(dict,empty);
   };
   var map = F2(function (f,dict) {
      return function () {
         switch (dict.ctor)
         {case "RBEmpty":
            switch (dict._0.ctor)
              {case "LBlack":
                 return RBEmpty(LBlack);}
              break;
            case "RBNode": return A5(RBNode,
              dict._0,
              dict._1,
              A2(f,dict._1,dict._2),
              A2(map,f,dict._3),
              A2(map,f,dict._4));}
         _U.badCase($moduleName,
         "between lines 394 and 399");
      }();
   });
   var showNColor = function (c) {
      return function () {
         switch (c.ctor)
         {case "BBlack": return "BBlack";
            case "Black": return "Black";
            case "NBlack": return "NBlack";
            case "Red": return "Red";}
         _U.badCase($moduleName,
         "between lines 56 and 60");
      }();
   };
   var reportRemBug = F4(function (msg,
   c,
   lgot,
   rgot) {
      return $Native$Debug.crash($String.concat(_L.fromArray(["Internal red-black tree invariant violated, expected "
                                                             ,msg
                                                             ," and got "
                                                             ,showNColor(c)
                                                             ,"/"
                                                             ,lgot
                                                             ,"/"
                                                             ,rgot
                                                             ,"\nPlease report this bug to <https://github.com/elm-lang/Elm/issues>"])));
   });
   var NBlack = {ctor: "NBlack"};
   var BBlack = {ctor: "BBlack"};
   var Black = {ctor: "Black"};
   var ensureBlackRoot = function (dict) {
      return function () {
         switch (dict.ctor)
         {case "RBEmpty":
            switch (dict._0.ctor)
              {case "LBlack": return dict;}
              break;
            case "RBNode":
            switch (dict._0.ctor)
              {case "Black": return dict;
                 case "Red": return A5(RBNode,
                   Black,
                   dict._1,
                   dict._2,
                   dict._3,
                   dict._4);}
              break;}
         _U.badCase($moduleName,
         "between lines 154 and 162");
      }();
   };
   var blackish = function (t) {
      return function () {
         switch (t.ctor)
         {case "RBEmpty": return true;
            case "RBNode":
            return _U.eq(t._0,
              Black) || _U.eq(t._0,BBlack);}
         _U.badCase($moduleName,
         "between lines 339 and 341");
      }();
   };
   var blacken = function (t) {
      return function () {
         switch (t.ctor)
         {case "RBEmpty":
            return RBEmpty(LBlack);
            case "RBNode": return A5(RBNode,
              Black,
              t._1,
              t._2,
              t._3,
              t._4);}
         _U.badCase($moduleName,
         "between lines 378 and 380");
      }();
   };
   var Red = {ctor: "Red"};
   var moreBlack = function (color) {
      return function () {
         switch (color.ctor)
         {case "BBlack":
            return $Native$Debug.crash("Can\'t make a double black node more black!");
            case "Black": return BBlack;
            case "NBlack": return Red;
            case "Red": return Black;}
         _U.badCase($moduleName,
         "between lines 244 and 248");
      }();
   };
   var lessBlack = function (color) {
      return function () {
         switch (color.ctor)
         {case "BBlack": return Black;
            case "Black": return Red;
            case "NBlack":
            return $Native$Debug.crash("Can\'t make a negative black node less black!");
            case "Red": return NBlack;}
         _U.badCase($moduleName,
         "between lines 253 and 257");
      }();
   };
   var lessBlackTree = function (dict) {
      return function () {
         switch (dict.ctor)
         {case "RBEmpty":
            switch (dict._0.ctor)
              {case "LBBlack":
                 return RBEmpty(LBlack);}
              break;
            case "RBNode": return A5(RBNode,
              lessBlack(dict._0),
              dict._1,
              dict._2,
              dict._3,
              dict._4);}
         _U.badCase($moduleName,
         "between lines 262 and 264");
      }();
   };
   var redden = function (t) {
      return function () {
         switch (t.ctor)
         {case "RBEmpty":
            return $Native$Debug.crash("can\'t make a Leaf red");
            case "RBNode": return A5(RBNode,
              Red,
              t._1,
              t._2,
              t._3,
              t._4);}
         _U.badCase($moduleName,
         "between lines 386 and 388");
      }();
   };
   var balance_node = function (t) {
      return function () {
         var assemble = function (col) {
            return function (xk) {
               return function (xv) {
                  return function (yk) {
                     return function (yv) {
                        return function (zk) {
                           return function (zv) {
                              return function (a) {
                                 return function (b) {
                                    return function (c) {
                                       return function (d) {
                                          return A5(RBNode,
                                          lessBlack(col),
                                          yk,
                                          yv,
                                          A5(RBNode,Black,xk,xv,a,b),
                                          A5(RBNode,Black,zk,zv,c,d));
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
         return blackish(t) ? function () {
            switch (t.ctor)
            {case "RBNode":
               switch (t._3.ctor)
                 {case "RBNode":
                    switch (t._3._0.ctor)
                      {case "Red":
                         switch (t._3._3.ctor)
                           {case "RBNode":
                              switch (t._3._3._0.ctor)
                                {case "Red":
                                   return assemble(t._0)(t._3._3._1)(t._3._3._2)(t._3._1)(t._3._2)(t._1)(t._2)(t._3._3._3)(t._3._3._4)(t._3._4)(t._4);}
                                break;}
                           switch (t._3._4.ctor)
                           {case "RBNode":
                              switch (t._3._4._0.ctor)
                                {case "Red":
                                   return assemble(t._0)(t._3._1)(t._3._2)(t._3._4._1)(t._3._4._2)(t._1)(t._2)(t._3._3)(t._3._4._3)(t._3._4._4)(t._4);}
                                break;}
                           break;}
                      break;}
                 switch (t._4.ctor)
                 {case "RBNode":
                    switch (t._4._0.ctor)
                      {case "Red":
                         switch (t._4._3.ctor)
                           {case "RBNode":
                              switch (t._4._3._0.ctor)
                                {case "Red":
                                   return assemble(t._0)(t._1)(t._2)(t._4._3._1)(t._4._3._2)(t._4._1)(t._4._2)(t._3)(t._4._3._3)(t._4._3._4)(t._4._4);}
                                break;}
                           switch (t._4._4.ctor)
                           {case "RBNode":
                              switch (t._4._4._0.ctor)
                                {case "Red":
                                   return assemble(t._0)(t._1)(t._2)(t._4._1)(t._4._2)(t._4._4._1)(t._4._4._2)(t._3)(t._4._3)(t._4._4._3)(t._4._4._4);}
                                break;}
                           break;}
                      break;}
                 switch (t._0.ctor)
                 {case "BBlack":
                    switch (t._4.ctor)
                      {case "RBNode":
                         switch (t._4._0.ctor)
                           {case "NBlack":
                              switch (t._4._3.ctor)
                                {case "RBNode":
                                   switch (t._4._3._0.ctor)
                                     {case "Black":
                                        return function () {
                                             switch (t._4._4.ctor)
                                             {case "RBNode":
                                                switch (t._4._4._0.ctor)
                                                  {case "Black":
                                                     return A5(RBNode,
                                                       Black,
                                                       t._4._3._1,
                                                       t._4._3._2,
                                                       A5(RBNode,
                                                       Black,
                                                       t._1,
                                                       t._2,
                                                       t._3,
                                                       t._4._3._3),
                                                       A5(balance,
                                                       Black,
                                                       t._4._1,
                                                       t._4._2,
                                                       t._4._3._4,
                                                       redden(t._4._4)));}
                                                  break;}
                                             return t;
                                          }();}
                                     break;}
                                break;}
                           break;}
                      switch (t._3.ctor)
                      {case "RBNode":
                         switch (t._3._0.ctor)
                           {case "NBlack":
                              switch (t._3._4.ctor)
                                {case "RBNode":
                                   switch (t._3._4._0.ctor)
                                     {case "Black":
                                        return function () {
                                             switch (t._3._3.ctor)
                                             {case "RBNode":
                                                switch (t._3._3._0.ctor)
                                                  {case "Black":
                                                     return A5(RBNode,
                                                       Black,
                                                       t._3._4._1,
                                                       t._3._4._2,
                                                       A5(balance,
                                                       Black,
                                                       t._3._1,
                                                       t._3._2,
                                                       redden(t._3._3),
                                                       t._3._4._3),
                                                       A5(RBNode,
                                                       Black,
                                                       t._1,
                                                       t._2,
                                                       t._3._4._4,
                                                       t._4));}
                                                  break;}
                                             return t;
                                          }();}
                                     break;}
                                break;}
                           break;}
                      break;}
                 break;}
            return t;
         }() : t;
      }();
   };
   var balance = F5(function (c,
   k,
   v,
   l,
   r) {
      return balance_node(A5(RBNode,
      c,
      k,
      v,
      l,
      r));
   });
   var bubble = F5(function (c,
   k,
   v,
   l,
   r) {
      return isBBlack(l) || isBBlack(r) ? A5(balance,
      moreBlack(c),
      k,
      v,
      lessBlackTree(l),
      lessBlackTree(r)) : A5(RBNode,
      c,
      k,
      v,
      l,
      r);
   });
   var remove_max = F5(function (c,
   k,
   v,
   l,
   r) {
      return function () {
         switch (r.ctor)
         {case "RBEmpty": return A3(rem,
              c,
              l,
              r);
            case "RBNode": return A5(bubble,
              c,
              k,
              v,
              l,
              A5(remove_max,
              r._0,
              r._1,
              r._2,
              r._3,
              r._4));}
         _U.badCase($moduleName,
         "between lines 323 and 328");
      }();
   });
   var rem = F3(function (c,l,r) {
      return function () {
         var _v169 = {ctor: "_Tuple2"
                     ,_0: l
                     ,_1: r};
         switch (_v169.ctor)
         {case "_Tuple2":
            switch (_v169._0.ctor)
              {case "RBEmpty":
                 switch (_v169._1.ctor)
                   {case "RBEmpty":
                      return function () {
                           switch (c.ctor)
                           {case "Black":
                              return RBEmpty(LBBlack);
                              case "Red":
                              return RBEmpty(LBlack);}
                           _U.badCase($moduleName,
                           "between lines 282 and 286");
                        }();
                      case "RBNode":
                      return function () {
                           var _v191 = {ctor: "_Tuple3"
                                       ,_0: c
                                       ,_1: _v169._0._0
                                       ,_2: _v169._1._0};
                           switch (_v191.ctor)
                           {case "_Tuple3":
                              switch (_v191._0.ctor)
                                {case "Black":
                                   switch (_v191._1.ctor)
                                     {case "LBlack":
                                        switch (_v191._2.ctor)
                                          {case "Red": return A5(RBNode,
                                               Black,
                                               _v169._1._1,
                                               _v169._1._2,
                                               _v169._1._3,
                                               _v169._1._4);}
                                          break;}
                                     break;}
                                break;}
                           return A4(reportRemBug,
                           "Black/LBlack/Red",
                           c,
                           showLColor(_v169._0._0),
                           showNColor(_v169._1._0));
                        }();}
                   break;
                 case "RBNode":
                 switch (_v169._1.ctor)
                   {case "RBEmpty":
                      return function () {
                           var _v195 = {ctor: "_Tuple3"
                                       ,_0: c
                                       ,_1: _v169._0._0
                                       ,_2: _v169._1._0};
                           switch (_v195.ctor)
                           {case "_Tuple3":
                              switch (_v195._0.ctor)
                                {case "Black":
                                   switch (_v195._1.ctor)
                                     {case "Red":
                                        switch (_v195._2.ctor)
                                          {case "LBlack":
                                             return A5(RBNode,
                                               Black,
                                               _v169._0._1,
                                               _v169._0._2,
                                               _v169._0._3,
                                               _v169._0._4);}
                                          break;}
                                     break;}
                                break;}
                           return A4(reportRemBug,
                           "Black/Red/LBlack",
                           c,
                           showNColor(_v169._0._0),
                           showLColor(_v169._1._0));
                        }();
                      case "RBNode":
                      return function () {
                           var l$ = A5(remove_max,
                           _v169._0._0,
                           _v169._0._1,
                           _v169._0._2,
                           _v169._0._3,
                           _v169._0._4);
                           var r = A5(RBNode,
                           _v169._1._0,
                           _v169._1._1,
                           _v169._1._2,
                           _v169._1._3,
                           _v169._1._4);
                           var l = A5(RBNode,
                           _v169._0._0,
                           _v169._0._1,
                           _v169._0._2,
                           _v169._0._3,
                           _v169._0._4);
                           var $ = max(l),
                           k = $._0,
                           v = $._1;
                           return A5(bubble,c,k,v,l$,r);
                        }();}
                   break;}
              break;}
         _U.badCase($moduleName,
         "between lines 280 and 309");
      }();
   });
   var update = F3(function (k,
   alter,
   dict) {
      return function () {
         var up = function (dict) {
            return function () {
               switch (dict.ctor)
               {case "RBEmpty":
                  switch (dict._0.ctor)
                    {case "LBlack":
                       return function () {
                            var _v206 = alter($Maybe.Nothing);
                            switch (_v206.ctor)
                            {case "Just":
                               return {ctor: "_Tuple2"
                                      ,_0: Insert
                                      ,_1: A5(RBNode,
                                      Red,
                                      k,
                                      _v206._0,
                                      empty,
                                      empty)};
                               case "Nothing":
                               return {ctor: "_Tuple2"
                                      ,_0: Same
                                      ,_1: empty};}
                            _U.badCase($moduleName,
                            "between lines 194 and 198");
                         }();}
                    break;
                  case "RBNode":
                  return function () {
                       var _v208 = A2($Basics.compare,
                       k,
                       dict._1);
                       switch (_v208.ctor)
                       {case "EQ": return function () {
                               var _v209 = alter($Maybe.Just(dict._2));
                               switch (_v209.ctor)
                               {case "Just":
                                  return {ctor: "_Tuple2"
                                         ,_0: Same
                                         ,_1: A5(RBNode,
                                         dict._0,
                                         dict._1,
                                         _v209._0,
                                         dict._3,
                                         dict._4)};
                                  case "Nothing":
                                  return {ctor: "_Tuple2"
                                         ,_0: Remove
                                         ,_1: A3(rem,
                                         dict._0,
                                         dict._3,
                                         dict._4)};}
                               _U.badCase($moduleName,
                               "between lines 201 and 206");
                            }();
                          case "GT": return function () {
                               var $ = up(dict._4),
                               flag = $._0,
                               newRight = $._1;
                               return function () {
                                  switch (flag.ctor)
                                  {case "Insert":
                                     return {ctor: "_Tuple2"
                                            ,_0: Insert
                                            ,_1: A5(balance,
                                            dict._0,
                                            dict._1,
                                            dict._2,
                                            dict._3,
                                            newRight)};
                                     case "Remove":
                                     return {ctor: "_Tuple2"
                                            ,_0: Remove
                                            ,_1: A5(bubble,
                                            dict._0,
                                            dict._1,
                                            dict._2,
                                            dict._3,
                                            newRight)};
                                     case "Same":
                                     return {ctor: "_Tuple2"
                                            ,_0: Same
                                            ,_1: A5(RBNode,
                                            dict._0,
                                            dict._1,
                                            dict._2,
                                            dict._3,
                                            newRight)};}
                                  _U.badCase($moduleName,
                                  "between lines 215 and 220");
                               }();
                            }();
                          case "LT": return function () {
                               var $ = up(dict._3),
                               flag = $._0,
                               newLeft = $._1;
                               return function () {
                                  switch (flag.ctor)
                                  {case "Insert":
                                     return {ctor: "_Tuple2"
                                            ,_0: Insert
                                            ,_1: A5(balance,
                                            dict._0,
                                            dict._1,
                                            dict._2,
                                            newLeft,
                                            dict._4)};
                                     case "Remove":
                                     return {ctor: "_Tuple2"
                                            ,_0: Remove
                                            ,_1: A5(bubble,
                                            dict._0,
                                            dict._1,
                                            dict._2,
                                            newLeft,
                                            dict._4)};
                                     case "Same":
                                     return {ctor: "_Tuple2"
                                            ,_0: Same
                                            ,_1: A5(RBNode,
                                            dict._0,
                                            dict._1,
                                            dict._2,
                                            newLeft,
                                            dict._4)};}
                                  _U.badCase($moduleName,
                                  "between lines 208 and 213");
                               }();
                            }();}
                       _U.badCase($moduleName,
                       "between lines 199 and 220");
                    }();}
               _U.badCase($moduleName,
               "between lines 192 and 220");
            }();
         };
         var $ = up(dict),
         flag = $._0,
         updatedDict = $._1;
         return function () {
            switch (flag.ctor)
            {case "Insert":
               return ensureBlackRoot(updatedDict);
               case "Remove":
               return blacken(updatedDict);
               case "Same":
               return updatedDict;}
            _U.badCase($moduleName,
            "between lines 222 and 225");
         }();
      }();
   });
   var insert = F3(function (key,
   value,
   dict) {
      return A3(update,
      key,
      $Basics.always($Maybe.Just(value)),
      dict);
   });
   var singleton = F2(function (key,
   value) {
      return A3(insert,
      key,
      value,
      empty);
   });
   var union = F2(function (t1,
   t2) {
      return A3(foldl,
      insert,
      t2,
      t1);
   });
   var fromList = function (assocs) {
      return A3($List.foldl,
      F2(function (_v214,dict) {
         return function () {
            switch (_v214.ctor)
            {case "_Tuple2":
               return A3(insert,
                 _v214._0,
                 _v214._1,
                 dict);}
            _U.badCase($moduleName,
            "on line 466, column 38 to 59");
         }();
      }),
      empty,
      assocs);
   };
   var filter = F2(function (predicate,
   dictionary) {
      return function () {
         var add = F3(function (key,
         value,
         dict) {
            return A2(predicate,
            key,
            value) ? A3(insert,
            key,
            value,
            dict) : dict;
         });
         return A3(foldl,
         add,
         empty,
         dictionary);
      }();
   });
   var intersect = F2(function (t1,
   t2) {
      return A2(filter,
      F2(function (k,_v218) {
         return function () {
            return A2(member,k,t2);
         }();
      }),
      t1);
   });
   var partition = F2(function (predicate,
   dict) {
      return function () {
         var add = F3(function (key,
         value,
         _v220) {
            return function () {
               switch (_v220.ctor)
               {case "_Tuple2":
                  return A2(predicate,
                    key,
                    value) ? {ctor: "_Tuple2"
                             ,_0: A3(insert,
                             key,
                             value,
                             _v220._0)
                             ,_1: _v220._1} : {ctor: "_Tuple2"
                                              ,_0: _v220._0
                                              ,_1: A3(insert,
                                              key,
                                              value,
                                              _v220._1)};}
               _U.badCase($moduleName,
               "between lines 487 and 489");
            }();
         });
         return A3(foldl,
         add,
         {ctor: "_Tuple2"
         ,_0: empty
         ,_1: empty},
         dict);
      }();
   });
   var remove = F2(function (key,
   dict) {
      return A3(update,
      key,
      $Basics.always($Maybe.Nothing),
      dict);
   });
   var diff = F2(function (t1,t2) {
      return A3(foldl,
      F3(function (k,v,t) {
         return A2(remove,k,t);
      }),
      t1,
      t2);
   });
   _elm.Dict.values = {_op: _op
                      ,empty: empty
                      ,singleton: singleton
                      ,insert: insert
                      ,update: update
                      ,isEmpty: isEmpty
                      ,get: get
                      ,remove: remove
                      ,member: member
                      ,filter: filter
                      ,partition: partition
                      ,foldl: foldl
                      ,foldr: foldr
                      ,map: map
                      ,union: union
                      ,intersect: intersect
                      ,diff: diff
                      ,keys: keys
                      ,values: values
                      ,toList: toList
                      ,fromList: fromList};
   return _elm.Dict.values;
};
Elm.Forms = Elm.Forms || {};
Elm.Forms.Model = Elm.Forms.Model || {};
Elm.Forms.Model.make = function (_elm) {
   "use strict";
   _elm.Forms = _elm.Forms || {};
   _elm.Forms.Model = _elm.Forms.Model || {};
   if (_elm.Forms.Model.values)
   return _elm.Forms.Model.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   $moduleName = "Forms.Model",
   $Basics = Elm.Basics.make(_elm),
   $List = Elm.List.make(_elm),
   $Maybe = Elm.Maybe.make(_elm),
   $Result = Elm.Result.make(_elm),
   $Signal = Elm.Signal.make(_elm);
   var SubmitLogout = {ctor: "SubmitLogout"};
   var SubmitLogin = function (a) {
      return {ctor: "SubmitLogin"
             ,_0: a};
   };
   var SubmitSetHandle = function (a) {
      return {ctor: "SubmitSetHandle"
             ,_0: a};
   };
   var NoSubmit = {ctor: "NoSubmit"};
   var UpdateLoginForm = function (a) {
      return {ctor: "UpdateLoginForm"
             ,_0: a};
   };
   var UpdateSetHandleForm = function (a) {
      return {ctor: "UpdateSetHandleForm"
             ,_0: a};
   };
   var LoginForm = F3(function (a,
   b,
   c) {
      return {_: {}
             ,email: a
             ,error: c
             ,password: b};
   });
   var SetHandleForm = function (a) {
      return {_: {},handle: a};
   };
   var Forms = F2(function (a,b) {
      return {_: {}
             ,login: b
             ,setHandle: a};
   });
   _elm.Forms.Model.values = {_op: _op
                             ,Forms: Forms
                             ,SetHandleForm: SetHandleForm
                             ,LoginForm: LoginForm
                             ,UpdateSetHandleForm: UpdateSetHandleForm
                             ,UpdateLoginForm: UpdateLoginForm
                             ,NoSubmit: NoSubmit
                             ,SubmitSetHandle: SubmitSetHandle
                             ,SubmitLogin: SubmitLogin
                             ,SubmitLogout: SubmitLogout};
   return _elm.Forms.Model.values;
};
Elm.Forms = Elm.Forms || {};
Elm.Forms.Update = Elm.Forms.Update || {};
Elm.Forms.Update.make = function (_elm) {
   "use strict";
   _elm.Forms = _elm.Forms || {};
   _elm.Forms.Update = _elm.Forms.Update || {};
   if (_elm.Forms.Update.values)
   return _elm.Forms.Update.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   $moduleName = "Forms.Update",
   $Basics = Elm.Basics.make(_elm),
   $Decoders = Elm.Decoders.make(_elm),
   $Forms$Model = Elm.Forms.Model.make(_elm),
   $Http = Elm.Http.make(_elm),
   $Inputs = Elm.Inputs.make(_elm),
   $Json$Decode = Elm.Json.Decode.make(_elm),
   $Json$Encode = Elm.Json.Encode.make(_elm),
   $List = Elm.List.make(_elm),
   $Maybe = Elm.Maybe.make(_elm),
   $Result = Elm.Result.make(_elm),
   $Signal = Elm.Signal.make(_elm),
   $Task = Elm.Task.make(_elm);
   var jsonToBody = function (jsValue) {
      return $Http.string(A2($Json$Encode.encode,
      0,
      jsValue));
   };
   var postJson = F3(function (decoder,
   url,
   jsonBody) {
      return $Http.fromJson(decoder)(A2($Http.send,
      $Http.defaultSettings,
      {_: {}
      ,body: jsonToBody(jsonBody)
      ,headers: _L.fromArray([{ctor: "_Tuple2"
                              ,_0: "Content-Type"
                              ,_1: "application/json"}])
      ,url: url
      ,verb: "POST"}));
   });
   var postLogout = A3(postJson,
   A2($Json$Decode.map,
   $Inputs.PlayerUpdate,
   $Decoders.playerDecoder),
   "/api/logout",
   $Json$Encode.$null);
   var postLogin = function (f) {
      return A2(postJson,
      A2($Json$Decode.map,
      $Inputs.PlayerUpdate,
      $Decoders.playerDecoder),
      "/api/login")($Json$Encode.object(_L.fromArray([{ctor: "_Tuple2"
                                                      ,_0: "email"
                                                      ,_1: $Json$Encode.string(f.email)}
                                                     ,{ctor: "_Tuple2"
                                                      ,_0: "password"
                                                      ,_1: $Json$Encode.string(f.password)}])));
   };
   var postHandle = function (f) {
      return A2(postJson,
      A2($Json$Decode.map,
      $Inputs.PlayerUpdate,
      $Decoders.playerDecoder),
      "/api/setHandle")($Json$Encode.object(_L.fromArray([{ctor: "_Tuple2"
                                                          ,_0: "handle"
                                                          ,_1: $Json$Encode.string(f.handle)}])));
   };
   var submitFormTask = function (sf) {
      return function () {
         var t = function () {
            switch (sf.ctor)
            {case "SubmitLogin":
               return postLogin(sf._0);
               case "SubmitLogout":
               return postLogout;
               case "SubmitSetHandle":
               return postHandle(sf._0);}
            return $Task.succeed($Inputs.NoOp);
         }();
         return A2($Task.andThen,
         t,
         $Signal.send($Inputs.actionsMailbox.address));
      }();
   };
   var updateForms = F2(function (u,
   forms) {
      return function () {
         switch (u.ctor)
         {case "UpdateLoginForm":
            return _U.replace([["login"
                               ,u._0(forms.login)]],
              forms);
            case "UpdateSetHandleForm":
            return _U.replace([["setHandle"
                               ,u._0(forms.setHandle)]],
              forms);}
         _U.badCase($moduleName,
         "between lines 20 and 24");
      }();
   });
   var submitMailbox = $Signal.mailbox($Forms$Model.NoSubmit);
   _elm.Forms.Update.values = {_op: _op
                              ,submitMailbox: submitMailbox
                              ,updateForms: updateForms
                              ,submitFormTask: submitFormTask
                              ,postHandle: postHandle
                              ,postLogin: postLogin
                              ,postLogout: postLogout
                              ,jsonToBody: jsonToBody
                              ,postJson: postJson};
   return _elm.Forms.Update.values;
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
   $moduleName = "Game",
   $Basics = Elm.Basics.make(_elm),
   $Core = Elm.Core.make(_elm),
   $Geo = Elm.Geo.make(_elm),
   $List = Elm.List.make(_elm),
   $Maybe = Elm.Maybe.make(_elm),
   $Result = Elm.Result.make(_elm),
   $Signal = Elm.Signal.make(_elm),
   $Time = Elm.Time.make(_elm);
   var isStarted = function (_v0) {
      return function () {
         return function () {
            var _v2 = _v0.startTime;
            switch (_v2.ctor)
            {case "Just":
               return _U.cmp(_v0.now,
                 _v2._0) > -1;
               case "Nothing": return false;}
            _U.badCase($moduleName,
            "between lines 337 and 339");
         }();
      }();
   };
   var raceTime = function (_v4) {
      return function () {
         return function () {
            var _v6 = _v4.startTime;
            switch (_v6.ctor)
            {case "Just":
               return _v4.now - _v6._0;
               case "Nothing": return 0;}
            _U.badCase($moduleName,
            "between lines 331 and 333");
         }();
      }();
   };
   var findOpponent = F2(function (opponents,
   id) {
      return A2($Core.find,
      function (ps) {
         return _U.eq(ps.player.id,
         id);
      },
      opponents);
   });
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
                     ,gustCounter: 0
                     ,gusts: _L.fromArray([])
                     ,origin: 0
                     ,speed: 0};
   var defaultGate = {_: {}
                     ,width: 0
                     ,y: 0};
   var defaultVmg = {_: {}
                    ,angle: 0
                    ,speed: 0
                    ,value: 0};
   var asOpponentState = function (_v8) {
      return function () {
         return {_: {}
                ,crossedGates: _v8.crossedGates
                ,heading: _v8.heading
                ,position: _v8.position
                ,shadowDirection: _v8.shadowDirection
                ,time: _v8.time
                ,velocity: _v8.velocity
                ,windAngle: _v8.windAngle
                ,windOrigin: _v8.windOrigin};
      }();
   };
   var upwind = function (s) {
      return _U.cmp($Basics.abs(s.windAngle),
      90) < 0;
   };
   var closestVmgAngle = function (s) {
      return upwind(s) ? s.upwindVmg.angle : s.downwindVmg.angle;
   };
   var windAngleOnVmg = function (s) {
      return _U.cmp(s.windAngle,
      0) < 0 ? 0 - closestVmgAngle(s) : closestVmgAngle(s);
   };
   var deltaToVmg = function (s) {
      return s.windAngle - windAngleOnVmg(s);
   };
   var headingOnVmg = function (s) {
      return $Geo.ensure360(s.windOrigin + closestVmgAngle(s));
   };
   var areaCenters = function (_v10) {
      return function () {
         return function () {
            var $ = _v10.leftBottom,
            l = $._0,
            b = $._1;
            var $ = _v10.rightTop,
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
   var areaBottom = function (_v12) {
      return function () {
         return $Basics.snd(_v12.leftBottom);
      }();
   };
   var areaTop = function (_v14) {
      return function () {
         return $Basics.snd(_v14.rightTop);
      }();
   };
   var areaDims = function (_v16) {
      return function () {
         return function () {
            var $ = _v16.leftBottom,
            l = $._0,
            b = $._1;
            var $ = _v16.rightTop,
            r = $._0,
            t = $._1;
            return {ctor: "_Tuple2"
                   ,_0: r - l
                   ,_1: t - b};
         }();
      }();
   };
   var areaWidth = function ($) {
      return $Basics.fst(areaDims($));
   };
   var genX = F3(function (seed,
   margin,
   area) {
      return function () {
         var _ = areaCenters(area);
         var cx = function () {
            switch (_.ctor)
            {case "_Tuple2": return _._0;}
            _U.badCase($moduleName,
            "on line 208, column 14 to 30");
         }();
         var effectiveWidth = areaWidth(area) - margin * 2;
         return A2($Core.floatMod,
         seed,
         effectiveWidth) - effectiveWidth / 2 + cx;
      }();
   });
   var areaHeight = function ($) {
      return $Basics.snd(areaDims($));
   };
   var areaBox = function (_v21) {
      return function () {
         return {ctor: "_Tuple2"
                ,_0: _v21.rightTop
                ,_1: _v21.leftBottom};
      }();
   };
   var WindGenerator = F4(function (a,
   b,
   c,
   d) {
      return {_: {}
             ,amplitude1: b
             ,amplitude2: d
             ,wavelength1: a
             ,wavelength2: c};
   });
   var StartLine = {ctor: "StartLine"};
   var UpwindGate = {ctor: "UpwindGate"};
   var DownwindGate = {ctor: "DownwindGate"};
   var Course = F6(function (a,
   b,
   c,
   d,
   e,
   f) {
      return {_: {}
             ,area: e
             ,downwind: b
             ,islands: d
             ,laps: c
             ,upwind: a
             ,windGenerator: f};
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
   var OpponentState = F8(function (a,
   b,
   c,
   d,
   e,
   f,
   g,
   h) {
      return {_: {}
             ,crossedGates: h
             ,heading: c
             ,position: b
             ,shadowDirection: g
             ,time: a
             ,velocity: d
             ,windAngle: e
             ,windOrigin: f};
   });
   var Opponent = F2(function (a,
   b) {
      return {_: {}
             ,player: a
             ,state: b};
   });
   var Vmg = F3(function (a,b,c) {
      return {_: {}
             ,angle: a
             ,speed: b
             ,value: c};
   });
   var Player = F7(function (a,
   b,
   c,
   d,
   e,
   f,
   g) {
      return {_: {}
             ,avatarId: d
             ,guest: f
             ,handle: b
             ,id: a
             ,status: c
             ,user: g
             ,vmgMagnet: e};
   });
   var FixedHeading = {ctor: "FixedHeading"};
   var defaultPlayerState = F2(function (player,
   now) {
      return {_: {}
             ,controlMode: FixedHeading
             ,crossedGates: _L.fromArray([])
             ,downwindVmg: defaultVmg
             ,heading: 0
             ,isGrounded: false
             ,isTurning: false
             ,nextGate: $Maybe.Just(StartLine)
             ,player: player
             ,position: {ctor: "_Tuple2"
                        ,_0: 0
                        ,_1: 0}
             ,shadowDirection: 0
             ,tackTarget: $Maybe.Nothing
             ,time: now
             ,trail: _L.fromArray([])
             ,upwindVmg: defaultVmg
             ,velocity: 0
             ,vmgValue: 0
             ,windAngle: 0
             ,windOrigin: 0
             ,windSpeed: 0};
   });
   var defaultGame = F3(function (now,
   course,
   player) {
      return {_: {}
             ,center: {ctor: "_Tuple2"
                      ,_0: 0
                      ,_1: 0}
             ,countdown: 0
             ,course: course
             ,ghosts: _L.fromArray([])
             ,leaderboard: _L.fromArray([])
             ,live: false
             ,localTime: 0
             ,now: now
             ,opponents: _L.fromArray([])
             ,playerState: A2(defaultPlayerState,
             player,
             now)
             ,roundTripDelay: 0
             ,serverNow: now
             ,startTime: $Maybe.Nothing
             ,wake: _L.fromArray([])
             ,wind: defaultWind};
   });
   var FixedAngle = {ctor: "FixedAngle"};
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
                                                   return function (q) {
                                                      return function (r) {
                                                         return function (s) {
                                                            return {_: {}
                                                                   ,controlMode: p
                                                                   ,crossedGates: r
                                                                   ,downwindVmg: l
                                                                   ,heading: f
                                                                   ,isGrounded: d
                                                                   ,isTurning: e
                                                                   ,nextGate: s
                                                                   ,player: a
                                                                   ,position: c
                                                                   ,shadowDirection: n
                                                                   ,tackTarget: q
                                                                   ,time: b
                                                                   ,trail: o
                                                                   ,upwindVmg: m
                                                                   ,velocity: g
                                                                   ,vmgValue: h
                                                                   ,windAngle: i
                                                                   ,windOrigin: j
                                                                   ,windSpeed: k};
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
         };
      };
   };
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
   var Gust = F6(function (a,
   b,
   c,
   d,
   e,
   f) {
      return {_: {}
             ,angle: b
             ,maxRadius: e
             ,position: a
             ,radius: d
             ,spawnedAt: f
             ,speed: c};
   });
   var Wind = F4(function (a,
   b,
   c,
   d) {
      return {_: {}
             ,gustCounter: d
             ,gusts: c
             ,origin: a
             ,speed: b};
   });
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
                                             return function (o) {
                                                return {_: {}
                                                       ,center: d
                                                       ,countdown: k
                                                       ,course: g
                                                       ,ghosts: f
                                                       ,leaderboard: h
                                                       ,live: m
                                                       ,localTime: n
                                                       ,now: i
                                                       ,opponents: e
                                                       ,playerState: b
                                                       ,roundTripDelay: o
                                                       ,serverNow: j
                                                       ,startTime: l
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
         };
      };
   };
   var windShadowLength = 120;
   var boatWidth = 3;
   var markRadius = 5;
   _elm.Game.values = {_op: _op
                      ,markRadius: markRadius
                      ,boatWidth: boatWidth
                      ,windShadowLength: windShadowLength
                      ,GameState: GameState
                      ,Wind: Wind
                      ,Gust: Gust
                      ,Gate: Gate
                      ,Island: Island
                      ,RaceArea: RaceArea
                      ,PlayerState: PlayerState
                      ,FixedAngle: FixedAngle
                      ,FixedHeading: FixedHeading
                      ,Player: Player
                      ,Vmg: Vmg
                      ,Opponent: Opponent
                      ,OpponentState: OpponentState
                      ,PlayerTally: PlayerTally
                      ,GhostState: GhostState
                      ,Course: Course
                      ,DownwindGate: DownwindGate
                      ,UpwindGate: UpwindGate
                      ,StartLine: StartLine
                      ,WindGenerator: WindGenerator
                      ,areaBox: areaBox
                      ,areaDims: areaDims
                      ,areaTop: areaTop
                      ,areaBottom: areaBottom
                      ,areaWidth: areaWidth
                      ,areaHeight: areaHeight
                      ,areaCenters: areaCenters
                      ,genX: genX
                      ,upwind: upwind
                      ,closestVmgAngle: closestVmgAngle
                      ,windAngleOnVmg: windAngleOnVmg
                      ,headingOnVmg: headingOnVmg
                      ,deltaToVmg: deltaToVmg
                      ,asOpponentState: asOpponentState
                      ,defaultVmg: defaultVmg
                      ,defaultPlayerState: defaultPlayerState
                      ,defaultGate: defaultGate
                      ,defaultWind: defaultWind
                      ,defaultGame: defaultGame
                      ,getGateMarks: getGateMarks
                      ,findPlayerGhost: findPlayerGhost
                      ,findOpponent: findOpponent
                      ,raceTime: raceTime
                      ,isStarted: isStarted};
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
   $moduleName = "Geo",
   $Basics = Elm.Basics.make(_elm),
   $Core = Elm.Core.make(_elm),
   $List = Elm.List.make(_elm),
   $Maybe = Elm.Maybe.make(_elm),
   $Result = Elm.Result.make(_elm),
   $Signal = Elm.Signal.make(_elm),
   $Time = Elm.Time.make(_elm);
   var angleDelta = F2(function (a1,
   a2) {
      return function () {
         var delta = a1 - a2;
         return _U.cmp(delta,
         180) > 0 ? delta - 360 : _U.cmp(delta,
         -180) < 1 ? delta + 360 : delta;
      }();
   });
   var inSector = F3(function (b1,
   b2,
   angle) {
      return function () {
         var a2 = 0 - A2(angleDelta,
         angle,
         b2);
         var a1 = 0 - A2(angleDelta,
         b1,
         angle);
         return _U.cmp(a1,
         0) > -1 && _U.cmp(a2,0) > -1;
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
   var angleBetween = F2(function (_v0,
   _v1) {
      return function () {
         switch (_v1.ctor)
         {case "_Tuple2":
            return function () {
                 switch (_v0.ctor)
                 {case "_Tuple2":
                    return function () {
                         var yDelta = _v1._1 - _v0._1;
                         var xDelta = _v1._0 - _v0._0;
                         var rad = A2($Basics.atan2,
                         yDelta,
                         xDelta);
                         return ensure360($Core.toDegrees(rad));
                      }();}
                 _U.badCase($moduleName,
                 "between lines 60 and 65");
              }();}
         _U.badCase($moduleName,
         "between lines 60 and 65");
      }();
   });
   var movePoint = F4(function (_v8,
   delta,
   velocity,
   direction) {
      return function () {
         switch (_v8.ctor)
         {case "_Tuple2":
            return function () {
                 var angle = $Core.toRadians(direction);
                 var x$ = _v8._0 + delta * 1.0e-3 * velocity * $Basics.cos(angle);
                 var y$ = _v8._1 + delta * 1.0e-3 * velocity * $Basics.sin(angle);
                 return {ctor: "_Tuple2"
                        ,_0: x$
                        ,_1: y$};
              }();}
         _U.badCase($moduleName,
         "between lines 38 and 41");
      }();
   });
   var toBox = F3(function (_v12,
   w,
   h) {
      return function () {
         switch (_v12.ctor)
         {case "_Tuple2":
            return {ctor: "_Tuple2"
                   ,_0: {ctor: "_Tuple2"
                        ,_0: _v12._0 + w / 2
                        ,_1: _v12._1 + h / 2}
                   ,_1: {ctor: "_Tuple2"
                        ,_0: _v12._0 - w / 2
                        ,_1: _v12._1 - h / 2}};}
         _U.badCase($moduleName,
         "on line 34, column 4 to 42");
      }();
   });
   var inBox = F2(function (_v16,
   _v17) {
      return function () {
         switch (_v17.ctor)
         {case "_Tuple2":
            switch (_v17._0.ctor)
              {case "_Tuple2":
                 switch (_v17._1.ctor)
                   {case "_Tuple2":
                      return function () {
                           switch (_v16.ctor)
                           {case "_Tuple2":
                              return _U.cmp(_v16._0,
                                _v17._1._0) > 0 && (_U.cmp(_v16._0,
                                _v17._0._0) < 0 && (_U.cmp(_v16._1,
                                _v17._1._1) > 0 && _U.cmp(_v16._1,
                                _v17._0._1) < 0));}
                           _U.badCase($moduleName,
                           "on line 30, column 3 to 47");
                        }();}
                   break;}
              break;}
         _U.badCase($moduleName,
         "on line 30, column 3 to 47");
      }();
   });
   var distance = F2(function (_v28,
   _v29) {
      return function () {
         switch (_v29.ctor)
         {case "_Tuple2":
            return function () {
                 switch (_v28.ctor)
                 {case "_Tuple2":
                    return $Basics.sqrt(Math.pow(_v28._0 - _v29._0,
                      2) + Math.pow(_v28._1 - _v29._1,
                      2));}
                 _U.badCase($moduleName,
                 "on line 26, column 3 to 34");
              }();}
         _U.badCase($moduleName,
         "on line 26, column 3 to 34");
      }();
   });
   var scale = F2(function (s,
   _v36) {
      return function () {
         switch (_v36.ctor)
         {case "_Tuple2":
            return {ctor: "_Tuple2"
                   ,_0: _v36._0 * s
                   ,_1: _v36._1 * s};}
         _U.badCase($moduleName,
         "on line 22, column 18 to 26");
      }();
   });
   var neg = function (_v40) {
      return function () {
         switch (_v40.ctor)
         {case "_Tuple2":
            return {ctor: "_Tuple2"
                   ,_0: 0 - _v40._0
                   ,_1: 0 - _v40._1};}
         _U.badCase($moduleName,
         "on line 19, column 14 to 19");
      }();
   };
   var sub = F2(function (_v44,
   _v45) {
      return function () {
         switch (_v45.ctor)
         {case "_Tuple2":
            return function () {
                 switch (_v44.ctor)
                 {case "_Tuple2":
                    return {ctor: "_Tuple2"
                           ,_0: _v45._0 - _v44._0
                           ,_1: _v45._1 - _v44._1};}
                 _U.badCase($moduleName,
                 "on line 16, column 22 to 36");
              }();}
         _U.badCase($moduleName,
         "on line 16, column 22 to 36");
      }();
   });
   var add = F2(function (_v52,
   _v53) {
      return function () {
         switch (_v53.ctor)
         {case "_Tuple2":
            return function () {
                 switch (_v52.ctor)
                 {case "_Tuple2":
                    return {ctor: "_Tuple2"
                           ,_0: _v53._0 + _v52._0
                           ,_1: _v53._1 + _v52._1};}
                 _U.badCase($moduleName,
                 "on line 13, column 22 to 36");
              }();}
         _U.badCase($moduleName,
         "on line 13, column 22 to 36");
      }();
   });
   var floatify = function (_v60) {
      return function () {
         switch (_v60.ctor)
         {case "_Tuple2":
            return {ctor: "_Tuple2"
                   ,_0: $Basics.toFloat(_v60._0)
                   ,_1: $Basics.toFloat(_v60._1)};}
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
                     ,movePoint: movePoint
                     ,ensure360: ensure360
                     ,angleDelta: angleDelta
                     ,angleBetween: angleBetween
                     ,inSector: inSector};
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
   $moduleName = "Graphics.Collage",
   $Basics = Elm.Basics.make(_elm),
   $Color = Elm.Color.make(_elm),
   $Graphics$Element = Elm.Graphics.Element.make(_elm),
   $List = Elm.List.make(_elm),
   $Native$Graphics$Collage = Elm.Native.Graphics.Collage.make(_elm),
   $Text = Elm.Text.make(_elm),
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
         "on line 226, column 3 to 37");
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
   var FText = function (a) {
      return {ctor: "FText",_0: a};
   };
   var text = function (t) {
      return form(FText(t));
   };
   var FOutlinedText = F2(function (a,
   b) {
      return {ctor: "FOutlinedText"
             ,_0: a
             ,_1: b};
   });
   var outlinedText = F2(function (ls,
   t) {
      return form(A2(FOutlinedText,
      ls,
      t));
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
                                  ,collage: collage
                                  ,toForm: toForm
                                  ,filled: filled
                                  ,textured: textured
                                  ,gradient: gradient
                                  ,outlined: outlined
                                  ,traced: traced
                                  ,text: text
                                  ,outlinedText: outlinedText
                                  ,move: move
                                  ,moveX: moveX
                                  ,moveY: moveY
                                  ,scale: scale
                                  ,rotate: rotate
                                  ,alpha: alpha
                                  ,group: group
                                  ,groupTransform: groupTransform
                                  ,rect: rect
                                  ,oval: oval
                                  ,square: square
                                  ,circle: circle
                                  ,ngon: ngon
                                  ,polygon: polygon
                                  ,segment: segment
                                  ,path: path
                                  ,solid: solid
                                  ,dashed: dashed
                                  ,dotted: dotted
                                  ,defaultLine: defaultLine
                                  ,Form: Form
                                  ,LineStyle: LineStyle
                                  ,Flat: Flat
                                  ,Round: Round
                                  ,Padded: Padded
                                  ,Smooth: Smooth
                                  ,Sharp: Sharp
                                  ,Clipped: Clipped};
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
   $moduleName = "Graphics.Element",
   $Basics = Elm.Basics.make(_elm),
   $Color = Elm.Color.make(_elm),
   $List = Elm.List.make(_elm),
   $Maybe = Elm.Maybe.make(_elm),
   $Native$Graphics$Element = Elm.Native.Graphics.Element.make(_elm),
   $Text = Elm.Text.make(_elm);
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
   var justified = $Native$Graphics$Element.block("justify");
   var centered = $Native$Graphics$Element.block("center");
   var rightAligned = $Native$Graphics$Element.block("right");
   var leftAligned = $Native$Graphics$Element.block("left");
   var show = function (value) {
      return leftAligned($Text.monospace($Text.fromString($Basics.toString(value))));
   };
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
   var newElement = $Native$Graphics$Element.newElement;
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
         A2($Maybe.withDefault,
         0,
         $List.maximum(ws)),
         A2($Maybe.withDefault,
         0,
         $List.maximum(hs)),
         A2(Flow,DOut,es));
      }();
   };
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
         var maxOrZero = function (list) {
            return A2($Maybe.withDefault,
            0,
            $List.maximum(list));
         };
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
                 maxOrZero(ws),
                 $List.sum(hs));
               case "DIn": return A2(newFlow,
                 maxOrZero(ws),
                 maxOrZero(hs));
               case "DLeft": return A2(newFlow,
                 $List.sum(ws),
                 maxOrZero(hs));
               case "DOut": return A2(newFlow,
                 maxOrZero(ws),
                 maxOrZero(hs));
               case "DRight":
               return A2(newFlow,
                 $List.sum(ws),
                 maxOrZero(hs));
               case "DUp": return A2(newFlow,
                 maxOrZero(ws),
                 $List.sum(hs));}
            _U.badCase($moduleName,
            "between lines 362 and 368");
         }();
      }();
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
   var Element = F2(function (a,
   b) {
      return {_: {}
             ,element: b
             ,props: a};
   });
   _elm.Graphics.Element.values = {_op: _op
                                  ,image: image
                                  ,fittedImage: fittedImage
                                  ,croppedImage: croppedImage
                                  ,tiledImage: tiledImage
                                  ,leftAligned: leftAligned
                                  ,rightAligned: rightAligned
                                  ,centered: centered
                                  ,justified: justified
                                  ,show: show
                                  ,width: width
                                  ,height: height
                                  ,size: size
                                  ,color: color
                                  ,opacity: opacity
                                  ,link: link
                                  ,tag: tag
                                  ,widthOf: widthOf
                                  ,heightOf: heightOf
                                  ,sizeOf: sizeOf
                                  ,flow: flow
                                  ,up: up
                                  ,down: down
                                  ,left: left
                                  ,right: right
                                  ,inward: inward
                                  ,outward: outward
                                  ,layers: layers
                                  ,above: above
                                  ,below: below
                                  ,beside: beside
                                  ,empty: empty
                                  ,spacer: spacer
                                  ,container: container
                                  ,middle: middle
                                  ,midTop: midTop
                                  ,midBottom: midBottom
                                  ,midLeft: midLeft
                                  ,midRight: midRight
                                  ,topLeft: topLeft
                                  ,topRight: topRight
                                  ,bottomLeft: bottomLeft
                                  ,bottomRight: bottomRight
                                  ,absolute: absolute
                                  ,relative: relative
                                  ,middleAt: middleAt
                                  ,midTopAt: midTopAt
                                  ,midBottomAt: midBottomAt
                                  ,midLeftAt: midLeftAt
                                  ,midRightAt: midRightAt
                                  ,topLeftAt: topLeftAt
                                  ,topRightAt: topRightAt
                                  ,bottomLeftAt: bottomLeftAt
                                  ,bottomRightAt: bottomRightAt
                                  ,Element: Element
                                  ,Position: Position};
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
Elm.Html = Elm.Html || {};
Elm.Html.make = function (_elm) {
   "use strict";
   _elm.Html = _elm.Html || {};
   if (_elm.Html.values)
   return _elm.Html.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   $moduleName = "Html",
   $Basics = Elm.Basics.make(_elm),
   $Graphics$Element = Elm.Graphics.Element.make(_elm),
   $List = Elm.List.make(_elm),
   $Maybe = Elm.Maybe.make(_elm),
   $Result = Elm.Result.make(_elm),
   $Signal = Elm.Signal.make(_elm),
   $VirtualDom = Elm.VirtualDom.make(_elm);
   var fromElement = $VirtualDom.fromElement;
   var toElement = $VirtualDom.toElement;
   var text = $VirtualDom.text;
   var node = $VirtualDom.node;
   var body = node("body");
   var section = node("section");
   var nav = node("nav");
   var article = node("article");
   var aside = node("aside");
   var h1 = node("h1");
   var h2 = node("h2");
   var h3 = node("h3");
   var h4 = node("h4");
   var h5 = node("h5");
   var h6 = node("h6");
   var header = node("header");
   var footer = node("footer");
   var address = node("address");
   var main$ = node("main");
   var p = node("p");
   var hr = node("hr");
   var pre = node("pre");
   var blockquote = node("blockquote");
   var ol = node("ol");
   var ul = node("ul");
   var li = node("li");
   var dl = node("dl");
   var dt = node("dt");
   var dd = node("dd");
   var figure = node("figure");
   var figcaption = node("figcaption");
   var div = node("div");
   var a = node("a");
   var em = node("em");
   var strong = node("strong");
   var small = node("small");
   var s = node("s");
   var cite = node("cite");
   var q = node("q");
   var dfn = node("dfn");
   var abbr = node("abbr");
   var time = node("time");
   var code = node("code");
   var $var = node("var");
   var samp = node("samp");
   var kbd = node("kbd");
   var sub = node("sub");
   var sup = node("sup");
   var i = node("i");
   var b = node("b");
   var u = node("u");
   var mark = node("mark");
   var ruby = node("ruby");
   var rt = node("rt");
   var rp = node("rp");
   var bdi = node("bdi");
   var bdo = node("bdo");
   var span = node("span");
   var br = node("br");
   var wbr = node("wbr");
   var ins = node("ins");
   var del = node("del");
   var img = node("img");
   var iframe = node("iframe");
   var embed = node("embed");
   var object = node("object");
   var param = node("param");
   var video = node("video");
   var audio = node("audio");
   var source = node("source");
   var track = node("track");
   var canvas = node("canvas");
   var svg = node("svg");
   var math = node("math");
   var table = node("table");
   var caption = node("caption");
   var colgroup = node("colgroup");
   var col = node("col");
   var tbody = node("tbody");
   var thead = node("thead");
   var tfoot = node("tfoot");
   var tr = node("tr");
   var td = node("td");
   var th = node("th");
   var form = node("form");
   var fieldset = node("fieldset");
   var legend = node("legend");
   var label = node("label");
   var input = node("input");
   var button = node("button");
   var select = node("select");
   var datalist = node("datalist");
   var optgroup = node("optgroup");
   var option = node("option");
   var textarea = node("textarea");
   var keygen = node("keygen");
   var output = node("output");
   var progress = node("progress");
   var meter = node("meter");
   var details = node("details");
   var summary = node("summary");
   var menuitem = node("menuitem");
   var menu = node("menu");
   _elm.Html.values = {_op: _op
                      ,node: node
                      ,text: text
                      ,toElement: toElement
                      ,fromElement: fromElement
                      ,body: body
                      ,section: section
                      ,nav: nav
                      ,article: article
                      ,aside: aside
                      ,h1: h1
                      ,h2: h2
                      ,h3: h3
                      ,h4: h4
                      ,h5: h5
                      ,h6: h6
                      ,header: header
                      ,footer: footer
                      ,address: address
                      ,main$: main$
                      ,p: p
                      ,hr: hr
                      ,pre: pre
                      ,blockquote: blockquote
                      ,ol: ol
                      ,ul: ul
                      ,li: li
                      ,dl: dl
                      ,dt: dt
                      ,dd: dd
                      ,figure: figure
                      ,figcaption: figcaption
                      ,div: div
                      ,a: a
                      ,em: em
                      ,strong: strong
                      ,small: small
                      ,s: s
                      ,cite: cite
                      ,q: q
                      ,dfn: dfn
                      ,abbr: abbr
                      ,time: time
                      ,code: code
                      ,$var: $var
                      ,samp: samp
                      ,kbd: kbd
                      ,sub: sub
                      ,sup: sup
                      ,i: i
                      ,b: b
                      ,u: u
                      ,mark: mark
                      ,ruby: ruby
                      ,rt: rt
                      ,rp: rp
                      ,bdi: bdi
                      ,bdo: bdo
                      ,span: span
                      ,br: br
                      ,wbr: wbr
                      ,ins: ins
                      ,del: del
                      ,img: img
                      ,iframe: iframe
                      ,embed: embed
                      ,object: object
                      ,param: param
                      ,video: video
                      ,audio: audio
                      ,source: source
                      ,track: track
                      ,canvas: canvas
                      ,svg: svg
                      ,math: math
                      ,table: table
                      ,caption: caption
                      ,colgroup: colgroup
                      ,col: col
                      ,tbody: tbody
                      ,thead: thead
                      ,tfoot: tfoot
                      ,tr: tr
                      ,td: td
                      ,th: th
                      ,form: form
                      ,fieldset: fieldset
                      ,legend: legend
                      ,label: label
                      ,input: input
                      ,button: button
                      ,select: select
                      ,datalist: datalist
                      ,optgroup: optgroup
                      ,option: option
                      ,textarea: textarea
                      ,keygen: keygen
                      ,output: output
                      ,progress: progress
                      ,meter: meter
                      ,details: details
                      ,summary: summary
                      ,menuitem: menuitem
                      ,menu: menu};
   return _elm.Html.values;
};
Elm.Html = Elm.Html || {};
Elm.Html.Attributes = Elm.Html.Attributes || {};
Elm.Html.Attributes.make = function (_elm) {
   "use strict";
   _elm.Html = _elm.Html || {};
   _elm.Html.Attributes = _elm.Html.Attributes || {};
   if (_elm.Html.Attributes.values)
   return _elm.Html.Attributes.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   $moduleName = "Html.Attributes",
   $Basics = Elm.Basics.make(_elm),
   $Html = Elm.Html.make(_elm),
   $Json$Encode = Elm.Json.Encode.make(_elm),
   $List = Elm.List.make(_elm),
   $Maybe = Elm.Maybe.make(_elm),
   $Result = Elm.Result.make(_elm),
   $Signal = Elm.Signal.make(_elm),
   $String = Elm.String.make(_elm),
   $VirtualDom = Elm.VirtualDom.make(_elm);
   var attribute = $VirtualDom.attribute;
   var property = $VirtualDom.property;
   var stringProperty = F2(function (name,
   string) {
      return A2(property,
      name,
      $Json$Encode.string(string));
   });
   var $class = function (name) {
      return A2(stringProperty,
      "className",
      name);
   };
   var id = function (name) {
      return A2(stringProperty,
      "id",
      name);
   };
   var title = function (name) {
      return A2(stringProperty,
      "title",
      name);
   };
   var accesskey = function ($char) {
      return A2(stringProperty,
      "accesskey",
      $String.fromList(_L.fromArray([$char])));
   };
   var contextmenu = function (value) {
      return A2(stringProperty,
      "contextmenu",
      value);
   };
   var dir = function (value) {
      return A2(stringProperty,
      "dir",
      value);
   };
   var draggable = function (value) {
      return A2(stringProperty,
      "draggable",
      value);
   };
   var dropzone = function (value) {
      return A2(stringProperty,
      "dropzone",
      value);
   };
   var itemprop = function (value) {
      return A2(stringProperty,
      "itemprop",
      value);
   };
   var lang = function (value) {
      return A2(stringProperty,
      "lang",
      value);
   };
   var tabindex = function (n) {
      return A2(stringProperty,
      "tabIndex",
      $Basics.toString(n));
   };
   var charset = function (value) {
      return A2(stringProperty,
      "charset",
      value);
   };
   var content = function (value) {
      return A2(stringProperty,
      "content",
      value);
   };
   var httpEquiv = function (value) {
      return A2(stringProperty,
      "httpEquiv",
      value);
   };
   var language = function (value) {
      return A2(stringProperty,
      "language",
      value);
   };
   var src = function (value) {
      return A2(stringProperty,
      "src",
      value);
   };
   var height = function (value) {
      return A2(stringProperty,
      "height",
      $Basics.toString(value));
   };
   var width = function (value) {
      return A2(stringProperty,
      "width",
      $Basics.toString(value));
   };
   var alt = function (value) {
      return A2(stringProperty,
      "alt",
      value);
   };
   var preload = function (value) {
      return A2(stringProperty,
      "preload",
      value);
   };
   var poster = function (value) {
      return A2(stringProperty,
      "poster",
      value);
   };
   var kind = function (value) {
      return A2(stringProperty,
      "kind",
      value);
   };
   var srclang = function (value) {
      return A2(stringProperty,
      "srclang",
      value);
   };
   var sandbox = function (value) {
      return A2(stringProperty,
      "sandbox",
      value);
   };
   var srcdoc = function (value) {
      return A2(stringProperty,
      "srcdoc",
      value);
   };
   var type$ = function (value) {
      return A2(stringProperty,
      "type",
      value);
   };
   var value = function (value) {
      return A2(stringProperty,
      "value",
      value);
   };
   var placeholder = function (value) {
      return A2(stringProperty,
      "placeholder",
      value);
   };
   var accept = function (value) {
      return A2(stringProperty,
      "accept",
      value);
   };
   var acceptCharset = function (value) {
      return A2(stringProperty,
      "acceptCharset",
      value);
   };
   var action = function (value) {
      return A2(stringProperty,
      "action",
      value);
   };
   var autocomplete = function (bool) {
      return A2(stringProperty,
      "autocomplete",
      bool ? "on" : "off");
   };
   var autosave = function (value) {
      return A2(stringProperty,
      "autosave",
      value);
   };
   var enctype = function (value) {
      return A2(stringProperty,
      "enctype",
      value);
   };
   var formaction = function (value) {
      return A2(stringProperty,
      "formaction",
      value);
   };
   var list = function (value) {
      return A2(stringProperty,
      "list",
      value);
   };
   var minlength = function (n) {
      return A2(stringProperty,
      "minLength",
      $Basics.toString(n));
   };
   var maxlength = function (n) {
      return A2(stringProperty,
      "maxLength",
      $Basics.toString(n));
   };
   var method = function (value) {
      return A2(stringProperty,
      "method",
      value);
   };
   var name = function (value) {
      return A2(stringProperty,
      "name",
      value);
   };
   var pattern = function (value) {
      return A2(stringProperty,
      "pattern",
      value);
   };
   var size = function (n) {
      return A2(stringProperty,
      "size",
      $Basics.toString(n));
   };
   var $for = function (value) {
      return A2(stringProperty,
      "htmlFor",
      value);
   };
   var form = function (value) {
      return A2(stringProperty,
      "form",
      value);
   };
   var max = function (value) {
      return A2(stringProperty,
      "max",
      value);
   };
   var min = function (value) {
      return A2(stringProperty,
      "min",
      value);
   };
   var step = function (n) {
      return A2(stringProperty,
      "step",
      n);
   };
   var cols = function (n) {
      return A2(stringProperty,
      "cols",
      $Basics.toString(n));
   };
   var rows = function (n) {
      return A2(stringProperty,
      "rows",
      $Basics.toString(n));
   };
   var wrap = function (value) {
      return A2(stringProperty,
      "wrap",
      value);
   };
   var usemap = function (value) {
      return A2(stringProperty,
      "useMap",
      value);
   };
   var shape = function (value) {
      return A2(stringProperty,
      "shape",
      value);
   };
   var coords = function (value) {
      return A2(stringProperty,
      "coords",
      value);
   };
   var challenge = function (value) {
      return A2(stringProperty,
      "challenge",
      value);
   };
   var keytype = function (value) {
      return A2(stringProperty,
      "keytype",
      value);
   };
   var align = function (value) {
      return A2(stringProperty,
      "align",
      value);
   };
   var cite = function (value) {
      return A2(stringProperty,
      "cite",
      value);
   };
   var href = function (value) {
      return A2(stringProperty,
      "href",
      value);
   };
   var target = function (value) {
      return A2(stringProperty,
      "target",
      value);
   };
   var downloadAs = function (value) {
      return A2(stringProperty,
      "download",
      value);
   };
   var hreflang = function (value) {
      return A2(stringProperty,
      "hreflang",
      value);
   };
   var media = function (value) {
      return A2(stringProperty,
      "media",
      value);
   };
   var ping = function (value) {
      return A2(stringProperty,
      "ping",
      value);
   };
   var rel = function (value) {
      return A2(stringProperty,
      "rel",
      value);
   };
   var datetime = function (value) {
      return A2(stringProperty,
      "datetime",
      value);
   };
   var pubdate = function (value) {
      return A2(stringProperty,
      "pubdate",
      value);
   };
   var start = function (n) {
      return A2(stringProperty,
      "start",
      $Basics.toString(n));
   };
   var colspan = function (n) {
      return A2(stringProperty,
      "colSpan",
      $Basics.toString(n));
   };
   var headers = function (value) {
      return A2(stringProperty,
      "headers",
      value);
   };
   var rowspan = function (n) {
      return A2(stringProperty,
      "rowSpan",
      $Basics.toString(n));
   };
   var scope = function (value) {
      return A2(stringProperty,
      "scope",
      value);
   };
   var manifest = function (value) {
      return A2(stringProperty,
      "manifest",
      value);
   };
   var boolProperty = F2(function (name,
   bool) {
      return A2(property,
      name,
      $Json$Encode.bool(bool));
   });
   var hidden = function (bool) {
      return A2(boolProperty,
      "hidden",
      bool);
   };
   var contenteditable = function (bool) {
      return A2(boolProperty,
      "contentEditable",
      bool);
   };
   var spellcheck = function (bool) {
      return A2(boolProperty,
      "spellcheck",
      bool);
   };
   var async = function (bool) {
      return A2(boolProperty,
      "async",
      bool);
   };
   var defer = function (bool) {
      return A2(boolProperty,
      "defer",
      bool);
   };
   var scoped = function (bool) {
      return A2(boolProperty,
      "scoped",
      bool);
   };
   var autoplay = function (bool) {
      return A2(boolProperty,
      "autoplay",
      bool);
   };
   var controls = function (bool) {
      return A2(boolProperty,
      "controls",
      bool);
   };
   var loop = function (bool) {
      return A2(boolProperty,
      "loop",
      bool);
   };
   var $default = function (bool) {
      return A2(boolProperty,
      "default",
      bool);
   };
   var seamless = function (bool) {
      return A2(boolProperty,
      "seamless",
      bool);
   };
   var checked = function (bool) {
      return A2(boolProperty,
      "checked",
      bool);
   };
   var selected = function (bool) {
      return A2(boolProperty,
      "selected",
      bool);
   };
   var autofocus = function (bool) {
      return A2(boolProperty,
      "autofocus",
      bool);
   };
   var disabled = function (bool) {
      return A2(boolProperty,
      "disabled",
      bool);
   };
   var multiple = function (bool) {
      return A2(boolProperty,
      "multiple",
      bool);
   };
   var novalidate = function (bool) {
      return A2(boolProperty,
      "noValidate",
      bool);
   };
   var readonly = function (bool) {
      return A2(boolProperty,
      "readOnly",
      bool);
   };
   var required = function (bool) {
      return A2(boolProperty,
      "required",
      bool);
   };
   var ismap = function (value) {
      return A2(boolProperty,
      "isMap",
      value);
   };
   var download = function (bool) {
      return A2(boolProperty,
      "download",
      bool);
   };
   var reversed = function (bool) {
      return A2(boolProperty,
      "reversed",
      bool);
   };
   var classList = function (list) {
      return $class($String.join(" ")($List.map($Basics.fst)($List.filter($Basics.snd)(list))));
   };
   var style = function (props) {
      return property("style")($Json$Encode.object($List.map(function (_v0) {
         return function () {
            switch (_v0.ctor)
            {case "_Tuple2":
               return {ctor: "_Tuple2"
                      ,_0: _v0._0
                      ,_1: $Json$Encode.string(_v0._1)};}
            _U.badCase($moduleName,
            "on line 156, column 35 to 57");
         }();
      })(props)));
   };
   var key = function (k) {
      return A2(stringProperty,
      "key",
      k);
   };
   _elm.Html.Attributes.values = {_op: _op
                                 ,key: key
                                 ,style: style
                                 ,$class: $class
                                 ,classList: classList
                                 ,id: id
                                 ,title: title
                                 ,hidden: hidden
                                 ,type$: type$
                                 ,value: value
                                 ,checked: checked
                                 ,placeholder: placeholder
                                 ,selected: selected
                                 ,accept: accept
                                 ,acceptCharset: acceptCharset
                                 ,action: action
                                 ,autocomplete: autocomplete
                                 ,autofocus: autofocus
                                 ,autosave: autosave
                                 ,disabled: disabled
                                 ,enctype: enctype
                                 ,formaction: formaction
                                 ,list: list
                                 ,maxlength: maxlength
                                 ,minlength: minlength
                                 ,method: method
                                 ,multiple: multiple
                                 ,name: name
                                 ,novalidate: novalidate
                                 ,pattern: pattern
                                 ,readonly: readonly
                                 ,required: required
                                 ,size: size
                                 ,$for: $for
                                 ,form: form
                                 ,max: max
                                 ,min: min
                                 ,step: step
                                 ,cols: cols
                                 ,rows: rows
                                 ,wrap: wrap
                                 ,href: href
                                 ,target: target
                                 ,download: download
                                 ,downloadAs: downloadAs
                                 ,hreflang: hreflang
                                 ,media: media
                                 ,ping: ping
                                 ,rel: rel
                                 ,ismap: ismap
                                 ,usemap: usemap
                                 ,shape: shape
                                 ,coords: coords
                                 ,src: src
                                 ,height: height
                                 ,width: width
                                 ,alt: alt
                                 ,autoplay: autoplay
                                 ,controls: controls
                                 ,loop: loop
                                 ,preload: preload
                                 ,poster: poster
                                 ,$default: $default
                                 ,kind: kind
                                 ,srclang: srclang
                                 ,sandbox: sandbox
                                 ,seamless: seamless
                                 ,srcdoc: srcdoc
                                 ,reversed: reversed
                                 ,start: start
                                 ,align: align
                                 ,colspan: colspan
                                 ,rowspan: rowspan
                                 ,headers: headers
                                 ,scope: scope
                                 ,async: async
                                 ,charset: charset
                                 ,content: content
                                 ,defer: defer
                                 ,httpEquiv: httpEquiv
                                 ,language: language
                                 ,scoped: scoped
                                 ,accesskey: accesskey
                                 ,contenteditable: contenteditable
                                 ,contextmenu: contextmenu
                                 ,dir: dir
                                 ,draggable: draggable
                                 ,dropzone: dropzone
                                 ,itemprop: itemprop
                                 ,lang: lang
                                 ,spellcheck: spellcheck
                                 ,tabindex: tabindex
                                 ,challenge: challenge
                                 ,keytype: keytype
                                 ,cite: cite
                                 ,datetime: datetime
                                 ,pubdate: pubdate
                                 ,manifest: manifest
                                 ,property: property
                                 ,attribute: attribute};
   return _elm.Html.Attributes.values;
};
Elm.Html = Elm.Html || {};
Elm.Html.Events = Elm.Html.Events || {};
Elm.Html.Events.make = function (_elm) {
   "use strict";
   _elm.Html = _elm.Html || {};
   _elm.Html.Events = _elm.Html.Events || {};
   if (_elm.Html.Events.values)
   return _elm.Html.Events.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   $moduleName = "Html.Events",
   $Basics = Elm.Basics.make(_elm),
   $Html = Elm.Html.make(_elm),
   $Json$Decode = Elm.Json.Decode.make(_elm),
   $List = Elm.List.make(_elm),
   $Maybe = Elm.Maybe.make(_elm),
   $Result = Elm.Result.make(_elm),
   $Signal = Elm.Signal.make(_elm),
   $VirtualDom = Elm.VirtualDom.make(_elm);
   var keyCode = A2($Json$Decode._op[":="],
   "keyCode",
   $Json$Decode.$int);
   var targetChecked = A2($Json$Decode.at,
   _L.fromArray(["target"
                ,"checked"]),
   $Json$Decode.bool);
   var targetValue = A2($Json$Decode.at,
   _L.fromArray(["target"
                ,"value"]),
   $Json$Decode.string);
   var defaultOptions = $VirtualDom.defaultOptions;
   var Options = F2(function (a,
   b) {
      return {_: {}
             ,preventDefault: b
             ,stopPropagation: a};
   });
   var onWithOptions = $VirtualDom.onWithOptions;
   var on = $VirtualDom.on;
   var messageOn = F3(function (name,
   addr,
   msg) {
      return A3(on,
      name,
      $Json$Decode.value,
      function (_v0) {
         return function () {
            return A2($Signal.message,
            addr,
            msg);
         }();
      });
   });
   var onClick = messageOn("click");
   var onDoubleClick = messageOn("dblclick");
   var onMouseMove = messageOn("mousemove");
   var onMouseDown = messageOn("mousedown");
   var onMouseUp = messageOn("mouseup");
   var onMouseEnter = messageOn("mouseenter");
   var onMouseLeave = messageOn("mouseleave");
   var onMouseOver = messageOn("mouseover");
   var onMouseOut = messageOn("mouseout");
   var onBlur = messageOn("blur");
   var onFocus = messageOn("focus");
   var onSubmit = messageOn("submit");
   var onKey = F3(function (name,
   addr,
   handler) {
      return A3(on,
      name,
      keyCode,
      function (code) {
         return A2($Signal.message,
         addr,
         handler(code));
      });
   });
   var onKeyUp = onKey("keyup");
   var onKeyDown = onKey("keydown");
   var onKeyPress = onKey("keypress");
   _elm.Html.Events.values = {_op: _op
                             ,onBlur: onBlur
                             ,onFocus: onFocus
                             ,onSubmit: onSubmit
                             ,onKeyUp: onKeyUp
                             ,onKeyDown: onKeyDown
                             ,onKeyPress: onKeyPress
                             ,onClick: onClick
                             ,onDoubleClick: onDoubleClick
                             ,onMouseMove: onMouseMove
                             ,onMouseDown: onMouseDown
                             ,onMouseUp: onMouseUp
                             ,onMouseEnter: onMouseEnter
                             ,onMouseLeave: onMouseLeave
                             ,onMouseOver: onMouseOver
                             ,onMouseOut: onMouseOut
                             ,on: on
                             ,onWithOptions: onWithOptions
                             ,defaultOptions: defaultOptions
                             ,targetValue: targetValue
                             ,targetChecked: targetChecked
                             ,keyCode: keyCode
                             ,Options: Options};
   return _elm.Html.Events.values;
};
Elm.Http = Elm.Http || {};
Elm.Http.make = function (_elm) {
   "use strict";
   _elm.Http = _elm.Http || {};
   if (_elm.Http.values)
   return _elm.Http.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   $moduleName = "Http",
   $Basics = Elm.Basics.make(_elm),
   $Dict = Elm.Dict.make(_elm),
   $Json$Decode = Elm.Json.Decode.make(_elm),
   $List = Elm.List.make(_elm),
   $Maybe = Elm.Maybe.make(_elm),
   $Native$Http = Elm.Native.Http.make(_elm),
   $Result = Elm.Result.make(_elm),
   $Signal = Elm.Signal.make(_elm),
   $String = Elm.String.make(_elm),
   $Task = Elm.Task.make(_elm),
   $Time = Elm.Time.make(_elm);
   var send = $Native$Http.send;
   var BadResponse = F2(function (a,
   b) {
      return {ctor: "BadResponse"
             ,_0: a
             ,_1: b};
   });
   var UnexpectedPayload = function (a) {
      return {ctor: "UnexpectedPayload"
             ,_0: a};
   };
   var handleResponse = F2(function (handle,
   response) {
      return function () {
         var _v0 = _U.cmp(200,
         response.status) < 1 && _U.cmp(response.status,
         300) < 0;
         switch (_v0)
         {case false:
            return $Task.fail(A2(BadResponse,
              response.status,
              response.statusText));
            case true: return function () {
                 var _v1 = response.value;
                 switch (_v1.ctor)
                 {case "Text":
                    return handle(_v1._0);}
                 return $Task.fail(UnexpectedPayload("Response body is a blob, expecting a string."));
              }();}
         _U.badCase($moduleName,
         "between lines 419 and 426");
      }();
   });
   var NetworkError = {ctor: "NetworkError"};
   var Timeout = {ctor: "Timeout"};
   var promoteError = function (rawError) {
      return function () {
         switch (rawError.ctor)
         {case "RawNetworkError":
            return NetworkError;
            case "RawTimeout":
            return Timeout;}
         _U.badCase($moduleName,
         "between lines 431 and 433");
      }();
   };
   var fromJson = F2(function (decoder,
   response) {
      return function () {
         var decode = function (str) {
            return function () {
               var _v4 = A2($Json$Decode.decodeString,
               decoder,
               str);
               switch (_v4.ctor)
               {case "Err":
                  return $Task.fail(UnexpectedPayload(_v4._0));
                  case "Ok":
                  return $Task.succeed(_v4._0);}
               _U.badCase($moduleName,
               "between lines 409 and 412");
            }();
         };
         return A2($Task.andThen,
         A2($Task.mapError,
         promoteError,
         response),
         handleResponse(decode));
      }();
   });
   var RawNetworkError = {ctor: "RawNetworkError"};
   var RawTimeout = {ctor: "RawTimeout"};
   var Blob = function (a) {
      return {ctor: "Blob",_0: a};
   };
   var Text = function (a) {
      return {ctor: "Text",_0: a};
   };
   var Response = F5(function (a,
   b,
   c,
   d,
   e) {
      return {_: {}
             ,headers: c
             ,status: a
             ,statusText: b
             ,url: d
             ,value: e};
   });
   var defaultSettings = {_: {}
                         ,desiredResponseType: $Maybe.Nothing
                         ,onProgress: $Maybe.Nothing
                         ,onStart: $Maybe.Nothing
                         ,timeout: 0};
   var post = F3(function (decoder,
   url,
   body) {
      return function () {
         var request = {_: {}
                       ,body: body
                       ,headers: _L.fromArray([])
                       ,url: url
                       ,verb: "POST"};
         return A2(fromJson,
         decoder,
         A2(send,
         defaultSettings,
         request));
      }();
   });
   var Settings = F4(function (a,
   b,
   c,
   d) {
      return {_: {}
             ,desiredResponseType: d
             ,onProgress: c
             ,onStart: b
             ,timeout: a};
   });
   var multipart = $Native$Http.multipart;
   var FileData = F3(function (a,
   b,
   c) {
      return {ctor: "FileData"
             ,_0: a
             ,_1: b
             ,_2: c};
   });
   var BlobData = F3(function (a,
   b,
   c) {
      return {ctor: "BlobData"
             ,_0: a
             ,_1: b
             ,_2: c};
   });
   var blobData = BlobData;
   var StringData = F2(function (a,
   b) {
      return {ctor: "StringData"
             ,_0: a
             ,_1: b};
   });
   var stringData = StringData;
   var BodyBlob = function (a) {
      return {ctor: "BodyBlob"
             ,_0: a};
   };
   var BodyFormData = {ctor: "BodyFormData"};
   var ArrayBuffer = {ctor: "ArrayBuffer"};
   var BodyString = function (a) {
      return {ctor: "BodyString"
             ,_0: a};
   };
   var string = BodyString;
   var Empty = {ctor: "Empty"};
   var empty = Empty;
   var getString = function (url) {
      return function () {
         var request = {_: {}
                       ,body: empty
                       ,headers: _L.fromArray([])
                       ,url: url
                       ,verb: "GET"};
         return A2($Task.andThen,
         A2($Task.mapError,
         promoteError,
         A2(send,
         defaultSettings,
         request)),
         handleResponse($Task.succeed));
      }();
   };
   var get = F2(function (decoder,
   url) {
      return function () {
         var request = {_: {}
                       ,body: empty
                       ,headers: _L.fromArray([])
                       ,url: url
                       ,verb: "GET"};
         return A2(fromJson,
         decoder,
         A2(send,
         defaultSettings,
         request));
      }();
   });
   var Request = F4(function (a,
   b,
   c,
   d) {
      return {_: {}
             ,body: d
             ,headers: b
             ,url: c
             ,verb: a};
   });
   var uriDecode = $Native$Http.uriDecode;
   var uriEncode = $Native$Http.uriEncode;
   var queryEscape = function (string) {
      return A2($String.join,
      "+",
      A2($String.split,
      "%20",
      uriEncode(string)));
   };
   var queryPair = function (_v7) {
      return function () {
         switch (_v7.ctor)
         {case "_Tuple2":
            return A2($Basics._op["++"],
              queryEscape(_v7._0),
              A2($Basics._op["++"],
              "=",
              queryEscape(_v7._1)));}
         _U.badCase($moduleName,
         "on line 63, column 3 to 46");
      }();
   };
   var url = F2(function (domain,
   args) {
      return function () {
         switch (args.ctor)
         {case "[]": return domain;}
         return A2($Basics._op["++"],
         domain,
         A2($Basics._op["++"],
         "?",
         A2($String.join,
         "&",
         A2($List.map,queryPair,args))));
      }();
   });
   var TODO_implement_file_in_another_library = {ctor: "TODO_implement_file_in_another_library"};
   var TODO_implement_blob_in_another_library = {ctor: "TODO_implement_blob_in_another_library"};
   _elm.Http.values = {_op: _op
                      ,getString: getString
                      ,get: get
                      ,post: post
                      ,send: send
                      ,url: url
                      ,uriEncode: uriEncode
                      ,uriDecode: uriDecode
                      ,empty: empty
                      ,string: string
                      ,multipart: multipart
                      ,stringData: stringData
                      ,blobData: blobData
                      ,defaultSettings: defaultSettings
                      ,fromJson: fromJson
                      ,Request: Request
                      ,Settings: Settings
                      ,Response: Response
                      ,Text: Text
                      ,Blob: Blob
                      ,Timeout: Timeout
                      ,NetworkError: NetworkError
                      ,UnexpectedPayload: UnexpectedPayload
                      ,BadResponse: BadResponse
                      ,RawTimeout: RawTimeout
                      ,RawNetworkError: RawNetworkError};
   return _elm.Http.values;
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
   $moduleName = "Inputs",
   $Basics = Elm.Basics.make(_elm),
   $Char = Elm.Char.make(_elm),
   $Decoders = Elm.Decoders.make(_elm),
   $Forms$Model = Elm.Forms.Model.make(_elm),
   $Game = Elm.Game.make(_elm),
   $Http = Elm.Http.make(_elm),
   $Json$Decode = Elm.Json.Decode.make(_elm),
   $Keyboard = Elm.Keyboard.make(_elm),
   $List = Elm.List.make(_elm),
   $Maybe = Elm.Maybe.make(_elm),
   $Result = Elm.Result.make(_elm),
   $Set = Elm.Set.make(_elm),
   $Signal = Elm.Signal.make(_elm),
   $State = Elm.State.make(_elm),
   $Task = Elm.Task.make(_elm),
   $Time = Elm.Time.make(_elm);
   var toKeyboardInput = F2(function (arrows,
   keys) {
      return {_: {}
             ,arrows: arrows
             ,escapeRun: A2($Set.member,
             27,
             keys)
             ,lock: A2($Set.member,13,keys)
             ,startCountdown: A2($Set.member,
             $Char.toCode(_U.chr("C")),
             keys)
             ,subtleTurn: A2($Set.member,
             16,
             keys)
             ,tack: A2($Set.member,32,keys)};
   });
   var keyboardInput = A3($Signal.map2,
   toKeyboardInput,
   $Keyboard.arrows,
   $Keyboard.keysDown);
   var isLocking = function (ki) {
      return _U.cmp(ki.arrows.y,
      0) > 0 || ki.lock;
   };
   var manualTurn = function (ki) {
      return !_U.eq(ki.arrows.x,0);
   };
   var isTurning = function (ki) {
      return manualTurn(ki) && $Basics.not(ki.subtleTurn);
   };
   var isSubtleTurning = function (ki) {
      return manualTurn(ki) && ki.subtleTurn;
   };
   var initialRaceInput = {_: {}
                          ,clientTime: 0
                          ,ghosts: _L.fromArray([])
                          ,initial: true
                          ,leaderboard: _L.fromArray([])
                          ,opponents: _L.fromArray([])
                          ,serverNow: 0
                          ,startTime: $Maybe.Nothing
                          ,wind: $Game.defaultWind};
   var RaceInput = F8(function (a,
   b,
   c,
   d,
   e,
   f,
   g,
   h) {
      return {_: {}
             ,clientTime: h
             ,ghosts: e
             ,initial: g
             ,leaderboard: f
             ,opponents: d
             ,serverNow: a
             ,startTime: b
             ,wind: c};
   });
   var UserArrows = F2(function (a,
   b) {
      return {_: {},x: a,y: b};
   });
   var emptyKeyboardInput = {_: {}
                            ,arrows: {_: {},x: 0,y: 0}
                            ,escapeRun: false
                            ,lock: false
                            ,startCountdown: false
                            ,subtleTurn: false
                            ,tack: false};
   var KeyboardInput = F6(function (a,
   b,
   c,
   d,
   e,
   f) {
      return {_: {}
             ,arrows: a
             ,escapeRun: f
             ,lock: b
             ,startCountdown: e
             ,subtleTurn: d
             ,tack: c};
   });
   var Clock = F2(function (a,b) {
      return {_: {}
             ,delta: a
             ,time: b};
   });
   var GameInput = F4(function (a,
   b,
   c,
   d) {
      return {_: {}
             ,clock: a
             ,keyboardInput: b
             ,raceInput: d
             ,windowInput: c};
   });
   var extractGameInput = F4(function (clock,
   keyboardInput,
   dims,
   maybeRaceInput) {
      return A2($Maybe.map,
      A3(GameInput,
      clock,
      keyboardInput,
      dims),
      maybeRaceInput);
   });
   var LiveInput = F2(function (a,
   b) {
      return {_: {}
             ,onlinePlayers: b
             ,raceCourses: a};
   });
   var liveInputDecoder = A3($Json$Decode.object2,
   LiveInput,
   A2($Json$Decode._op[":="],
   "raceCourses",
   $Json$Decode.list($Decoders.raceCourseStatusDecoder)),
   A2($Json$Decode._op[":="],
   "onlinePlayers",
   $Json$Decode.list($Decoders.playerDecoder)));
   var FormAction = function (a) {
      return {ctor: "FormAction"
             ,_0: a};
   };
   var Navigate = function (a) {
      return {ctor: "Navigate"
             ,_0: a};
   };
   var PlayerUpdate = function (a) {
      return {ctor: "PlayerUpdate"
             ,_0: a};
   };
   var LiveUpdate = function (a) {
      return {ctor: "LiveUpdate"
             ,_0: a};
   };
   var fetchServerUpdate = A2($Http.get,
   A2($Json$Decode.map,
   LiveUpdate,
   liveInputDecoder),
   "/api/liveStatus");
   var NoOp = {ctor: "NoOp"};
   var actionsMailbox = $Signal.mailbox(NoOp);
   var navigate = function (screen) {
      return A2($Signal.message,
      actionsMailbox.address,
      Navigate(screen));
   };
   var runServerUpdate = A2($Task.andThen,
   fetchServerUpdate,
   $Signal.send(actionsMailbox.address));
   var AppInput = F3(function (a,
   b,
   c) {
      return {_: {}
             ,action: a
             ,clock: c
             ,gameInput: b};
   });
   _elm.Inputs.values = {_op: _op
                        ,AppInput: AppInput
                        ,NoOp: NoOp
                        ,LiveUpdate: LiveUpdate
                        ,PlayerUpdate: PlayerUpdate
                        ,Navigate: Navigate
                        ,FormAction: FormAction
                        ,LiveInput: LiveInput
                        ,actionsMailbox: actionsMailbox
                        ,navigate: navigate
                        ,fetchServerUpdate: fetchServerUpdate
                        ,runServerUpdate: runServerUpdate
                        ,GameInput: GameInput
                        ,Clock: Clock
                        ,KeyboardInput: KeyboardInput
                        ,emptyKeyboardInput: emptyKeyboardInput
                        ,UserArrows: UserArrows
                        ,RaceInput: RaceInput
                        ,initialRaceInput: initialRaceInput
                        ,extractGameInput: extractGameInput
                        ,manualTurn: manualTurn
                        ,isTurning: isTurning
                        ,isSubtleTurning: isSubtleTurning
                        ,isLocking: isLocking
                        ,toKeyboardInput: toKeyboardInput
                        ,keyboardInput: keyboardInput
                        ,liveInputDecoder: liveInputDecoder};
   return _elm.Inputs.values;
};
Elm.Json = Elm.Json || {};
Elm.Json.Decode = Elm.Json.Decode || {};
Elm.Json.Decode.make = function (_elm) {
   "use strict";
   _elm.Json = _elm.Json || {};
   _elm.Json.Decode = _elm.Json.Decode || {};
   if (_elm.Json.Decode.values)
   return _elm.Json.Decode.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   $moduleName = "Json.Decode",
   $Array = Elm.Array.make(_elm),
   $Dict = Elm.Dict.make(_elm),
   $Json$Encode = Elm.Json.Encode.make(_elm),
   $List = Elm.List.make(_elm),
   $Maybe = Elm.Maybe.make(_elm),
   $Native$Json = Elm.Native.Json.make(_elm),
   $Result = Elm.Result.make(_elm);
   var tuple8 = $Native$Json.decodeTuple8;
   var tuple7 = $Native$Json.decodeTuple7;
   var tuple6 = $Native$Json.decodeTuple6;
   var tuple5 = $Native$Json.decodeTuple5;
   var tuple4 = $Native$Json.decodeTuple4;
   var tuple3 = $Native$Json.decodeTuple3;
   var tuple2 = $Native$Json.decodeTuple2;
   var tuple1 = $Native$Json.decodeTuple1;
   var succeed = $Native$Json.succeed;
   var fail = $Native$Json.fail;
   var andThen = $Native$Json.andThen;
   var customDecoder = $Native$Json.customDecoder;
   var decodeValue = $Native$Json.runDecoderValue;
   var value = $Native$Json.decodeValue;
   var maybe = $Native$Json.decodeMaybe;
   var $null = $Native$Json.decodeNull;
   var array = $Native$Json.decodeArray;
   var list = $Native$Json.decodeList;
   var bool = $Native$Json.decodeBool;
   var $int = $Native$Json.decodeInt;
   var $float = $Native$Json.decodeFloat;
   var string = $Native$Json.decodeString;
   var oneOf = $Native$Json.oneOf;
   var keyValuePairs = $Native$Json.decodeKeyValuePairs;
   var object8 = $Native$Json.decodeObject8;
   var object7 = $Native$Json.decodeObject7;
   var object6 = $Native$Json.decodeObject6;
   var object5 = $Native$Json.decodeObject5;
   var object4 = $Native$Json.decodeObject4;
   var object3 = $Native$Json.decodeObject3;
   var object2 = $Native$Json.decodeObject2;
   var object1 = $Native$Json.decodeObject1;
   _op[":="] = $Native$Json.decodeField;
   var at = F2(function (fields,
   decoder) {
      return A3($List.foldr,
      F2(function (x,y) {
         return A2(_op[":="],x,y);
      }),
      decoder,
      fields);
   });
   var decodeString = $Native$Json.runDecoderString;
   var map = $Native$Json.decodeObject1;
   var dict = function (decoder) {
      return A2(map,
      $Dict.fromList,
      keyValuePairs(decoder));
   };
   var Decoder = {ctor: "Decoder"};
   _elm.Json.Decode.values = {_op: _op
                             ,decodeString: decodeString
                             ,decodeValue: decodeValue
                             ,string: string
                             ,$int: $int
                             ,$float: $float
                             ,bool: bool
                             ,$null: $null
                             ,list: list
                             ,array: array
                             ,tuple1: tuple1
                             ,tuple2: tuple2
                             ,tuple3: tuple3
                             ,tuple4: tuple4
                             ,tuple5: tuple5
                             ,tuple6: tuple6
                             ,tuple7: tuple7
                             ,tuple8: tuple8
                             ,at: at
                             ,object1: object1
                             ,object2: object2
                             ,object3: object3
                             ,object4: object4
                             ,object5: object5
                             ,object6: object6
                             ,object7: object7
                             ,object8: object8
                             ,keyValuePairs: keyValuePairs
                             ,dict: dict
                             ,maybe: maybe
                             ,oneOf: oneOf
                             ,map: map
                             ,fail: fail
                             ,succeed: succeed
                             ,andThen: andThen
                             ,value: value
                             ,customDecoder: customDecoder
                             ,Decoder: Decoder};
   return _elm.Json.Decode.values;
};
Elm.Json = Elm.Json || {};
Elm.Json.Encode = Elm.Json.Encode || {};
Elm.Json.Encode.make = function (_elm) {
   "use strict";
   _elm.Json = _elm.Json || {};
   _elm.Json.Encode = _elm.Json.Encode || {};
   if (_elm.Json.Encode.values)
   return _elm.Json.Encode.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   $moduleName = "Json.Encode",
   $Array = Elm.Array.make(_elm),
   $Native$Json = Elm.Native.Json.make(_elm);
   var list = $Native$Json.encodeList;
   var array = $Native$Json.encodeArray;
   var object = $Native$Json.encodeObject;
   var $null = $Native$Json.encodeNull;
   var bool = $Native$Json.identity;
   var $float = $Native$Json.identity;
   var $int = $Native$Json.identity;
   var string = $Native$Json.identity;
   var encode = $Native$Json.encode;
   var Value = {ctor: "Value"};
   _elm.Json.Encode.values = {_op: _op
                             ,encode: encode
                             ,string: string
                             ,$int: $int
                             ,$float: $float
                             ,bool: bool
                             ,$null: $null
                             ,list: list
                             ,array: array
                             ,object: object
                             ,Value: Value};
   return _elm.Json.Encode.values;
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
   $moduleName = "Keyboard",
   $Basics = Elm.Basics.make(_elm),
   $Native$Keyboard = Elm.Native.Keyboard.make(_elm),
   $Set = Elm.Set.make(_elm),
   $Signal = Elm.Signal.make(_elm);
   var presses = A2($Signal.map,
   function (_) {
      return _.keyCode;
   },
   $Native$Keyboard.presses);
   var toXY = F2(function (_v0,
   keyCodes) {
      return function () {
         return function () {
            var is = function (keyCode) {
               return A2($Set.member,
               keyCode,
               keyCodes) ? 1 : 0;
            };
            return {_: {}
                   ,x: is(_v0.right) - is(_v0.left)
                   ,y: is(_v0.up) - is(_v0.down)};
         }();
      }();
   });
   var Directions = F4(function (a,
   b,
   c,
   d) {
      return {_: {}
             ,down: b
             ,left: c
             ,right: d
             ,up: a};
   });
   var dropMap = F2(function (f,
   signal) {
      return $Signal.dropRepeats(A2($Signal.map,
      f,
      signal));
   });
   var EventInfo = F3(function (a,
   b,
   c) {
      return {_: {}
             ,alt: a
             ,keyCode: c
             ,meta: b};
   });
   var Blur = {ctor: "Blur"};
   var Down = function (a) {
      return {ctor: "Down",_0: a};
   };
   var Up = function (a) {
      return {ctor: "Up",_0: a};
   };
   var rawEvents = $Signal.mergeMany(_L.fromArray([A2($Signal.map,
                                                  Up,
                                                  $Native$Keyboard.ups)
                                                  ,A2($Signal.map,
                                                  Down,
                                                  $Native$Keyboard.downs)
                                                  ,A2($Signal.map,
                                                  $Basics.always(Blur),
                                                  $Native$Keyboard.blurs)]));
   var empty = {_: {}
               ,alt: false
               ,keyCodes: $Set.empty
               ,meta: false};
   var update = F2(function (event,
   model) {
      return function () {
         switch (event.ctor)
         {case "Blur": return empty;
            case "Down": return {_: {}
                                ,alt: event._0.alt
                                ,keyCodes: A2($Set.insert,
                                event._0.keyCode,
                                model.keyCodes)
                                ,meta: event._0.meta};
            case "Up": return {_: {}
                              ,alt: event._0.alt
                              ,keyCodes: A2($Set.remove,
                              event._0.keyCode,
                              model.keyCodes)
                              ,meta: event._0.meta};}
         _U.badCase($moduleName,
         "between lines 68 and 82");
      }();
   });
   var model = A3($Signal.foldp,
   update,
   empty,
   rawEvents);
   var alt = A2(dropMap,
   function (_) {
      return _.alt;
   },
   model);
   var meta = A2(dropMap,
   function (_) {
      return _.meta;
   },
   model);
   var keysDown = A2(dropMap,
   function (_) {
      return _.keyCodes;
   },
   model);
   var arrows = A2(dropMap,
   toXY({_: {}
        ,down: 40
        ,left: 37
        ,right: 39
        ,up: 38}),
   keysDown);
   var wasd = A2(dropMap,
   toXY({_: {}
        ,down: 83
        ,left: 65
        ,right: 68
        ,up: 87}),
   keysDown);
   var isDown = function (keyCode) {
      return A2(dropMap,
      $Set.member(keyCode),
      keysDown);
   };
   var ctrl = isDown(17);
   var shift = isDown(16);
   var space = isDown(32);
   var enter = isDown(13);
   var Model = F3(function (a,
   b,
   c) {
      return {_: {}
             ,alt: a
             ,keyCodes: c
             ,meta: b};
   });
   _elm.Keyboard.values = {_op: _op
                          ,arrows: arrows
                          ,wasd: wasd
                          ,enter: enter
                          ,space: space
                          ,ctrl: ctrl
                          ,shift: shift
                          ,alt: alt
                          ,meta: meta
                          ,isDown: isDown
                          ,keysDown: keysDown
                          ,presses: presses};
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
   $moduleName = "Layout",
   $Basics = Elm.Basics.make(_elm),
   $Graphics$Collage = Elm.Graphics.Collage.make(_elm),
   $Graphics$Element = Elm.Graphics.Element.make(_elm),
   $List = Elm.List.make(_elm),
   $Maybe = Elm.Maybe.make(_elm),
   $Result = Elm.Result.make(_elm),
   $Signal = Elm.Signal.make(_elm);
   var centerElements = function (elements) {
      return function () {
         var maxWidth = $Maybe.withDefault(0)($List.maximum(A2($List.map,
         $Graphics$Element.widthOf,
         elements)));
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
                                   $Graphics$Element.absolute(20),
                                   $Graphics$Element.absolute(20)))(A2($Graphics$Element.flow,
                                   $Graphics$Element.down,
                                   _v1.topLeft))
                                   ,A3($Graphics$Element.container,
                                   _v0._0,
                                   _v0._1,
                                   A2($Graphics$Element.midTopAt,
                                   $Graphics$Element.relative(0.5),
                                   $Graphics$Element.absolute(20)))(A2($Graphics$Element.flow,
                                   $Graphics$Element.down,
                                   centerElements(_v1.topCenter)))
                                   ,A3($Graphics$Element.container,
                                   _v0._0,
                                   _v0._1,
                                   A2($Graphics$Element.topRightAt,
                                   $Graphics$Element.absolute(20),
                                   $Graphics$Element.absolute(20)))(A2($Graphics$Element.flow,
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
   $moduleName = "List",
   $Basics = Elm.Basics.make(_elm),
   $Maybe = Elm.Maybe.make(_elm),
   $Native$List = Elm.Native.List.make(_elm);
   var sortWith = $Native$List.sortWith;
   var sortBy = $Native$List.sortBy;
   var sort = function (xs) {
      return A2(sortBy,
      $Basics.identity,
      xs);
   };
   var repeat = $Native$List.repeat;
   var drop = $Native$List.drop;
   var take = $Native$List.take;
   var map5 = $Native$List.map5;
   var map4 = $Native$List.map4;
   var map3 = $Native$List.map3;
   var map2 = $Native$List.map2;
   var any = $Native$List.any;
   var all = F2(function (pred,
   xs) {
      return $Basics.not(A2(any,
      function ($) {
         return $Basics.not(pred($));
      },
      xs));
   });
   var foldr = $Native$List.foldr;
   var foldl = $Native$List.foldl;
   var length = function (xs) {
      return A3(foldl,
      F2(function (_v0,i) {
         return function () {
            return i + 1;
         }();
      }),
      0,
      xs);
   };
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
   var maximum = function (list) {
      return function () {
         switch (list.ctor)
         {case "::":
            return $Maybe.Just(A3(foldl,
              $Basics.max,
              list._0,
              list._1));}
         return $Maybe.Nothing;
      }();
   };
   var minimum = function (list) {
      return function () {
         switch (list.ctor)
         {case "::":
            return $Maybe.Just(A3(foldl,
              $Basics.min,
              list._0,
              list._1));}
         return $Maybe.Nothing;
      }();
   };
   var indexedMap = F2(function (f,
   xs) {
      return A3(map2,
      f,
      _L.range(0,length(xs) - 1),
      xs);
   });
   var member = F2(function (x,
   xs) {
      return A2(any,
      function (a) {
         return _U.eq(a,x);
      },
      xs);
   });
   var isEmpty = function (xs) {
      return function () {
         switch (xs.ctor)
         {case "[]": return true;}
         return false;
      }();
   };
   var tail = function (list) {
      return function () {
         switch (list.ctor)
         {case "::":
            return $Maybe.Just(list._1);
            case "[]":
            return $Maybe.Nothing;}
         _U.badCase($moduleName,
         "between lines 87 and 89");
      }();
   };
   var head = function (list) {
      return function () {
         switch (list.ctor)
         {case "::":
            return $Maybe.Just(list._0);
            case "[]":
            return $Maybe.Nothing;}
         _U.badCase($moduleName,
         "between lines 75 and 77");
      }();
   };
   _op["::"] = $Native$List.cons;
   var map = F2(function (f,xs) {
      return A3(foldr,
      F2(function (x,acc) {
         return A2(_op["::"],
         f(x),
         acc);
      }),
      _L.fromArray([]),
      xs);
   });
   var filter = F2(function (pred,
   xs) {
      return function () {
         var conditionalCons = F2(function (x,
         xs$) {
            return pred(x) ? A2(_op["::"],
            x,
            xs$) : xs$;
         });
         return A3(foldr,
         conditionalCons,
         _L.fromArray([]),
         xs);
      }();
   });
   var maybeCons = F3(function (f,
   mx,
   xs) {
      return function () {
         var _v15 = f(mx);
         switch (_v15.ctor)
         {case "Just":
            return A2(_op["::"],_v15._0,xs);
            case "Nothing": return xs;}
         _U.badCase($moduleName,
         "between lines 179 and 181");
      }();
   });
   var filterMap = F2(function (f,
   xs) {
      return A3(foldr,
      maybeCons(f),
      _L.fromArray([]),
      xs);
   });
   var reverse = function (list) {
      return A3(foldl,
      F2(function (x,y) {
         return A2(_op["::"],x,y);
      }),
      _L.fromArray([]),
      list);
   };
   var scanl = F3(function (f,
   b,
   xs) {
      return function () {
         var scan1 = F2(function (x,
         accAcc) {
            return function () {
               switch (accAcc.ctor)
               {case "::": return A2(_op["::"],
                    A2(f,x,accAcc._0),
                    accAcc);
                  case "[]":
                  return _L.fromArray([]);}
               _U.badCase($moduleName,
               "between lines 148 and 151");
            }();
         });
         return reverse(A3(foldl,
         scan1,
         _L.fromArray([b]),
         xs));
      }();
   });
   var append = F2(function (xs,
   ys) {
      return function () {
         switch (ys.ctor)
         {case "[]": return xs;}
         return A3(foldr,
         F2(function (x,y) {
            return A2(_op["::"],x,y);
         }),
         ys,
         xs);
      }();
   });
   var concat = function (lists) {
      return A3(foldr,
      append,
      _L.fromArray([]),
      lists);
   };
   var concatMap = F2(function (f,
   list) {
      return concat(A2(map,
      f,
      list));
   });
   var partition = F2(function (pred,
   list) {
      return function () {
         var step = F2(function (x,
         _v21) {
            return function () {
               switch (_v21.ctor)
               {case "_Tuple2":
                  return pred(x) ? {ctor: "_Tuple2"
                                   ,_0: A2(_op["::"],x,_v21._0)
                                   ,_1: _v21._1} : {ctor: "_Tuple2"
                                                   ,_0: _v21._0
                                                   ,_1: A2(_op["::"],
                                                   x,
                                                   _v21._1)};}
               _U.badCase($moduleName,
               "between lines 301 and 303");
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
         var step = F2(function (_v25,
         _v26) {
            return function () {
               switch (_v26.ctor)
               {case "_Tuple2":
                  return function () {
                       switch (_v25.ctor)
                       {case "_Tuple2":
                          return {ctor: "_Tuple2"
                                 ,_0: A2(_op["::"],
                                 _v25._0,
                                 _v26._0)
                                 ,_1: A2(_op["::"],
                                 _v25._1,
                                 _v26._1)};}
                       _U.badCase($moduleName,
                       "on line 339, column 12 to 28");
                    }();}
               _U.badCase($moduleName,
               "on line 339, column 12 to 28");
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
         "between lines 350 and 356");
      }();
   });
   _elm.List.values = {_op: _op
                      ,isEmpty: isEmpty
                      ,length: length
                      ,reverse: reverse
                      ,member: member
                      ,head: head
                      ,tail: tail
                      ,filter: filter
                      ,take: take
                      ,drop: drop
                      ,repeat: repeat
                      ,append: append
                      ,concat: concat
                      ,intersperse: intersperse
                      ,partition: partition
                      ,unzip: unzip
                      ,map: map
                      ,map2: map2
                      ,map3: map3
                      ,map4: map4
                      ,map5: map5
                      ,filterMap: filterMap
                      ,concatMap: concatMap
                      ,indexedMap: indexedMap
                      ,foldr: foldr
                      ,foldl: foldl
                      ,sum: sum
                      ,product: product
                      ,maximum: maximum
                      ,minimum: minimum
                      ,all: all
                      ,any: any
                      ,scanl: scanl
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
   $moduleName = "Main",
   $Basics = Elm.Basics.make(_elm),
   $Core = Elm.Core.make(_elm),
   $Forms$Update = Elm.Forms.Update.make(_elm),
   $Game = Elm.Game.make(_elm),
   $Html = Elm.Html.make(_elm),
   $Http = Elm.Http.make(_elm),
   $Inputs = Elm.Inputs.make(_elm),
   $Json$Decode = Elm.Json.Decode.make(_elm),
   $List = Elm.List.make(_elm),
   $Maybe = Elm.Maybe.make(_elm),
   $Messages = Elm.Messages.make(_elm),
   $Outputs = Elm.Outputs.make(_elm),
   $Result = Elm.Result.make(_elm),
   $Signal = Elm.Signal.make(_elm),
   $State = Elm.State.make(_elm),
   $Steps = Elm.Steps.make(_elm),
   $Task = Elm.Task.make(_elm),
   $Time = Elm.Time.make(_elm),
   $Views$Main = Elm.Views.Main.make(_elm),
   $Window = Elm.Window.make(_elm);
   var clock = A2($Signal.map,
   function (_v0) {
      return function () {
         switch (_v0.ctor)
         {case "_Tuple2": return {_: {}
                                 ,delta: _v0._1
                                 ,time: _v0._0};}
         _U.badCase($moduleName,
         "on line 53, column 32 to 62");
      }();
   },
   $Time.timestamp($Time.fps(30)));
   var formSubmitsRunner = Elm.Native.Task.make(_elm).performSignal("formSubmitsRunner",
   A2($Signal.map,
   $Forms$Update.submitFormTask,
   $Forms$Update.submitMailbox.signal));
   var serverUpdateRunner = Elm.Native.Task.make(_elm).performSignal("serverUpdateRunner",
   A2($Signal.map,
   function (_v4) {
      return function () {
         return $Inputs.runServerUpdate;
      }();
   },
   $Time.every(5 * $Time.second)));
   var raceInput = Elm.Native.Port.make(_elm).inboundSignal("raceInput",
   "Maybe.Maybe Inputs.RaceInput",
   function (v) {
      return v === null ? Elm.Maybe.make(_elm).Nothing : Elm.Maybe.make(_elm).Just(typeof v === "object" && "serverNow" in v && "startTime" in v && "wind" in v && "opponents" in v && "ghosts" in v && "leaderboard" in v && "initial" in v && "clientTime" in v ? {_: {}
                                                                                                                                                                                                                                                                    ,serverNow: typeof v.serverNow === "number" ? v.serverNow : _U.badPort("a number",
                                                                                                                                                                                                                                                                    v.serverNow)
                                                                                                                                                                                                                                                                    ,startTime: v.startTime === null ? Elm.Maybe.make(_elm).Nothing : Elm.Maybe.make(_elm).Just(typeof v.startTime === "number" ? v.startTime : _U.badPort("a number",
                                                                                                                                                                                                                                                                    v.startTime))
                                                                                                                                                                                                                                                                    ,wind: typeof v.wind === "object" && "origin" in v.wind && "speed" in v.wind && "gusts" in v.wind && "gustCounter" in v.wind ? {_: {}
                                                                                                                                                                                                                                                                                                                                                                                                   ,origin: typeof v.wind.origin === "number" ? v.wind.origin : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                   v.wind.origin)
                                                                                                                                                                                                                                                                                                                                                                                                   ,speed: typeof v.wind.speed === "number" ? v.wind.speed : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                   v.wind.speed)
                                                                                                                                                                                                                                                                                                                                                                                                   ,gusts: typeof v.wind.gusts === "object" && v.wind.gusts instanceof Array ? Elm.Native.List.make(_elm).fromArray(v.wind.gusts.map(function (v) {
                                                                                                                                                                                                                                                                                                                                                                                                      return typeof v === "object" && "position" in v && "angle" in v && "speed" in v && "radius" in v && "maxRadius" in v && "spawnedAt" in v ? {_: {}
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
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 v.radius)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 ,maxRadius: typeof v.maxRadius === "number" ? v.maxRadius : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 v.maxRadius)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 ,spawnedAt: typeof v.spawnedAt === "number" ? v.spawnedAt : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 v.spawnedAt)} : _U.badPort("an object with fields `position`, `angle`, `speed`, `radius`, `maxRadius`, `spawnedAt`",
                                                                                                                                                                                                                                                                                                                                                                                                      v);
                                                                                                                                                                                                                                                                                                                                                                                                   })) : _U.badPort("an array",
                                                                                                                                                                                                                                                                                                                                                                                                   v.wind.gusts)
                                                                                                                                                                                                                                                                                                                                                                                                   ,gustCounter: typeof v.wind.gustCounter === "number" ? v.wind.gustCounter : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                   v.wind.gustCounter)} : _U.badPort("an object with fields `origin`, `speed`, `gusts`, `gustCounter`",
                                                                                                                                                                                                                                                                    v.wind)
                                                                                                                                                                                                                                                                    ,opponents: typeof v.opponents === "object" && v.opponents instanceof Array ? Elm.Native.List.make(_elm).fromArray(v.opponents.map(function (v) {
                                                                                                                                                                                                                                                                       return typeof v === "object" && "player" in v && "state" in v ? {_: {}
                                                                                                                                                                                                                                                                                                                                       ,player: typeof v.player === "object" && "id" in v.player && "handle" in v.player && "status" in v.player && "avatarId" in v.player && "vmgMagnet" in v.player && "guest" in v.player && "user" in v.player ? {_: {}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     ,id: typeof v.player.id === "string" || typeof v.player.id === "object" && v.player.id instanceof String ? v.player.id : _U.badPort("a string",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     v.player.id)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     ,handle: v.player.handle === null ? Elm.Maybe.make(_elm).Nothing : Elm.Maybe.make(_elm).Just(typeof v.player.handle === "string" || typeof v.player.handle === "object" && v.player.handle instanceof String ? v.player.handle : _U.badPort("a string",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     v.player.handle))
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     ,status: v.player.status === null ? Elm.Maybe.make(_elm).Nothing : Elm.Maybe.make(_elm).Just(typeof v.player.status === "string" || typeof v.player.status === "object" && v.player.status instanceof String ? v.player.status : _U.badPort("a string",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     v.player.status))
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     ,avatarId: v.player.avatarId === null ? Elm.Maybe.make(_elm).Nothing : Elm.Maybe.make(_elm).Just(typeof v.player.avatarId === "string" || typeof v.player.avatarId === "object" && v.player.avatarId instanceof String ? v.player.avatarId : _U.badPort("a string",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     v.player.avatarId))
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     ,vmgMagnet: typeof v.player.vmgMagnet === "number" ? v.player.vmgMagnet : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     v.player.vmgMagnet)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     ,guest: typeof v.player.guest === "boolean" ? v.player.guest : _U.badPort("a boolean (true or false)",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     v.player.guest)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     ,user: typeof v.player.user === "boolean" ? v.player.user : _U.badPort("a boolean (true or false)",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     v.player.user)} : _U.badPort("an object with fields `id`, `handle`, `status`, `avatarId`, `vmgMagnet`, `guest`, `user`",
                                                                                                                                                                                                                                                                                                                                       v.player)
                                                                                                                                                                                                                                                                                                                                       ,state: typeof v.state === "object" && "time" in v.state && "position" in v.state && "heading" in v.state && "velocity" in v.state && "windAngle" in v.state && "windOrigin" in v.state && "shadowDirection" in v.state && "crossedGates" in v.state ? {_: {}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ,time: typeof v.state.time === "number" ? v.state.time : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              v.state.time)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ,position: typeof v.state.position === "object" && v.state.position instanceof Array ? {ctor: "_Tuple2"
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     ,_0: typeof v.state.position[0] === "number" ? v.state.position[0] : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     v.state.position[0])
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     ,_1: typeof v.state.position[1] === "number" ? v.state.position[1] : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     v.state.position[1])} : _U.badPort("an array",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              v.state.position)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ,heading: typeof v.state.heading === "number" ? v.state.heading : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              v.state.heading)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ,velocity: typeof v.state.velocity === "number" ? v.state.velocity : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              v.state.velocity)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ,windAngle: typeof v.state.windAngle === "number" ? v.state.windAngle : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              v.state.windAngle)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ,windOrigin: typeof v.state.windOrigin === "number" ? v.state.windOrigin : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              v.state.windOrigin)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ,shadowDirection: typeof v.state.shadowDirection === "number" ? v.state.shadowDirection : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              v.state.shadowDirection)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ,crossedGates: typeof v.state.crossedGates === "object" && v.state.crossedGates instanceof Array ? Elm.Native.List.make(_elm).fromArray(v.state.crossedGates.map(function (v) {
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 return typeof v === "number" ? v : _U.badPort("a number",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 v);
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              })) : _U.badPort("an array",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              v.state.crossedGates)} : _U.badPort("an object with fields `time`, `position`, `heading`, `velocity`, `windAngle`, `windOrigin`, `shadowDirection`, `crossedGates`",
                                                                                                                                                                                                                                                                                                                                       v.state)} : _U.badPort("an object with fields `player`, `state`",
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
                                                                                                                                                                                                                                                                                                                                                                                         v.gates)} : _U.badPort("an object with fields `position`, `heading`, `id`, `handle`, `gates`",
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
                                                                                                                                                                                                                                                                                                                                                                v.gates)} : _U.badPort("an object with fields `playerId`, `playerHandle`, `gates`",
                                                                                                                                                                                                                                                                       v);
                                                                                                                                                                                                                                                                    })) : _U.badPort("an array",
                                                                                                                                                                                                                                                                    v.leaderboard)
                                                                                                                                                                                                                                                                    ,initial: typeof v.initial === "boolean" ? v.initial : _U.badPort("a boolean (true or false)",
                                                                                                                                                                                                                                                                    v.initial)
                                                                                                                                                                                                                                                                    ,clientTime: typeof v.clientTime === "number" ? v.clientTime : _U.badPort("a number",
                                                                                                                                                                                                                                                                    v.clientTime)} : _U.badPort("an object with fields `serverNow`, `startTime`, `wind`, `opponents`, `ghosts`, `leaderboard`, `initial`, `clientTime`",
      v));
   });
   var gameInput = $Signal.dropRepeats($Signal.sampleOn(clock)(A5($Signal.map4,
   $Inputs.extractGameInput,
   clock,
   $Inputs.keyboardInput,
   $Window.dimensions,
   raceInput)));
   var appInput = A4($Signal.map3,
   $Inputs.AppInput,
   $Inputs.actionsMailbox.signal,
   gameInput,
   clock);
   var currentPlayer = Elm.Native.Port.make(_elm).inbound("currentPlayer",
   "Game.Player",
   function (v) {
      return typeof v === "object" && "id" in v && "handle" in v && "status" in v && "avatarId" in v && "vmgMagnet" in v && "guest" in v && "user" in v ? {_: {}
                                                                                                                                                          ,id: typeof v.id === "string" || typeof v.id === "object" && v.id instanceof String ? v.id : _U.badPort("a string",
                                                                                                                                                          v.id)
                                                                                                                                                          ,handle: v.handle === null ? Elm.Maybe.make(_elm).Nothing : Elm.Maybe.make(_elm).Just(typeof v.handle === "string" || typeof v.handle === "object" && v.handle instanceof String ? v.handle : _U.badPort("a string",
                                                                                                                                                          v.handle))
                                                                                                                                                          ,status: v.status === null ? Elm.Maybe.make(_elm).Nothing : Elm.Maybe.make(_elm).Just(typeof v.status === "string" || typeof v.status === "object" && v.status instanceof String ? v.status : _U.badPort("a string",
                                                                                                                                                          v.status))
                                                                                                                                                          ,avatarId: v.avatarId === null ? Elm.Maybe.make(_elm).Nothing : Elm.Maybe.make(_elm).Just(typeof v.avatarId === "string" || typeof v.avatarId === "object" && v.avatarId instanceof String ? v.avatarId : _U.badPort("a string",
                                                                                                                                                          v.avatarId))
                                                                                                                                                          ,vmgMagnet: typeof v.vmgMagnet === "number" ? v.vmgMagnet : _U.badPort("a number",
                                                                                                                                                          v.vmgMagnet)
                                                                                                                                                          ,guest: typeof v.guest === "boolean" ? v.guest : _U.badPort("a boolean (true or false)",
                                                                                                                                                          v.guest)
                                                                                                                                                          ,user: typeof v.user === "boolean" ? v.user : _U.badPort("a boolean (true or false)",
                                                                                                                                                          v.user)} : _U.badPort("an object with fields `id`, `handle`, `status`, `avatarId`, `vmgMagnet`, `guest`, `user`",
      v);
   });
   var appState = A3($Signal.foldp,
   $Steps.mainStep,
   $State.initialAppState(currentPlayer),
   appInput);
   var playerOutput = Elm.Native.Port.make(_elm).outboundSignal("playerOutput",
   function (v) {
      return v.ctor === "Nothing" ? null : {state: {time: v._0.state.time
                                                   ,position: [v._0.state.position._0
                                                              ,v._0.state.position._1]
                                                   ,heading: v._0.state.heading
                                                   ,velocity: v._0.state.velocity
                                                   ,windAngle: v._0.state.windAngle
                                                   ,windOrigin: v._0.state.windOrigin
                                                   ,shadowDirection: v._0.state.shadowDirection
                                                   ,crossedGates: Elm.Native.List.make(_elm).toArray(v._0.state.crossedGates).map(function (v) {
                                                      return v;
                                                   })}
                                           ,input: {arrows: {x: v._0.input.arrows.x
                                                            ,y: v._0.input.arrows.y}
                                                   ,lock: v._0.input.lock
                                                   ,tack: v._0.input.tack
                                                   ,subtleTurn: v._0.input.subtleTurn
                                                   ,startCountdown: v._0.input.startCountdown
                                                   ,escapeRun: v._0.input.escapeRun}
                                           ,localTime: v._0.localTime};
   },
   A2($Signal.filter,
   $Core.isJust,
   $Maybe.Nothing)(A3($Signal.map2,
   $Outputs.extractPlayerOutput,
   appState,
   appInput)));
   var activeRaceCourse = Elm.Native.Port.make(_elm).outboundSignal("activeRaceCourse",
   function (v) {
      return v.ctor === "Nothing" ? null : v._0;
   },
   $Signal.dropRepeats(A2($Signal.map,
   $Outputs.getActiveRaceCourse,
   appState)));
   var messagesStore = Elm.Native.Port.make(_elm).inbound("messagesStore",
   "Json.Decode.Value",
   function (v) {
      return v;
   });
   var translator = $Messages.translator($Messages.fromJson(messagesStore));
   var main = A3($Signal.map2,
   $Views$Main.mainView(translator),
   $Window.dimensions,
   appState);
   _elm.Main.values = {_op: _op
                      ,main: main
                      ,translator: translator
                      ,clock: clock
                      ,gameInput: gameInput
                      ,appInput: appInput
                      ,appState: appState};
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
   $moduleName = "Maybe";
   var withDefault = F2(function ($default,
   maybe) {
      return function () {
         switch (maybe.ctor)
         {case "Just": return maybe._0;
            case "Nothing":
            return $default;}
         _U.badCase($moduleName,
         "between lines 45 and 47");
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
                 "between lines 64 and 66");
              }();
            case "[]": return Nothing;}
         _U.badCase($moduleName,
         "between lines 59 and 66");
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
         "between lines 76 and 78");
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
Elm.Messages = Elm.Messages || {};
Elm.Messages.make = function (_elm) {
   "use strict";
   _elm.Messages = _elm.Messages || {};
   if (_elm.Messages.values)
   return _elm.Messages.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   $moduleName = "Messages",
   $Basics = Elm.Basics.make(_elm),
   $Dict = Elm.Dict.make(_elm),
   $Json$Decode = Elm.Json.Decode.make(_elm),
   $List = Elm.List.make(_elm),
   $Maybe = Elm.Maybe.make(_elm),
   $Result = Elm.Result.make(_elm),
   $Signal = Elm.Signal.make(_elm);
   var translator = F2(function (messages,
   key) {
      return $Maybe.withDefault(key)(A2($Dict.get,
      key,
      messages));
   });
   var msg = F2(function (key,
   messages) {
      return $Maybe.withDefault(key)(A2($Dict.get,
      key,
      messages));
   });
   var fromList = function (l) {
      return $Dict.fromList(l);
   };
   var emptyMessages = $Dict.empty;
   var fromJson = function (value) {
      return $Maybe.withDefault(emptyMessages)($Result.toMaybe(A2($Json$Decode.decodeValue,
      $Json$Decode.dict($Json$Decode.string),
      value)));
   };
   _elm.Messages.values = {_op: _op
                          ,emptyMessages: emptyMessages
                          ,fromList: fromList
                          ,fromJson: fromJson
                          ,msg: msg
                          ,translator: translator};
   return _elm.Messages.values;
};
Elm.Native.Array = {};
Elm.Native.Array.make = function(localRuntime) {

	localRuntime.Native = localRuntime.Native || {};
	localRuntime.Native.Array = localRuntime.Native.Array || {};
	if (localRuntime.Native.Array.values)
	{
		return localRuntime.Native.Array.values;
	}
	if ('values' in Elm.Native.Array)
	{
		return localRuntime.Native.Array.values = Elm.Native.Array.values;
	}

	var List = Elm.Native.List.make(localRuntime);

	// A RRB-Tree has two distinct data types.
	// Leaf -> "height"  is always 0
	//         "table"   is an array of elements
	// Node -> "height"  is always greater than 0
	//         "table"   is an array of child nodes
	//         "lengths" is an array of accumulated lengths of the child nodes

	// M is the maximal table size. 32 seems fast. E is the allowed increase
	// of search steps when concatting to find an index. Lower values will
	// decrease balancing, but will increase search steps.
	var M = 32;
	var E = 2;

	// An empty array.
	var empty = {
		ctor: "_Array",
		height: 0,
		table: new Array()
	};


	function get(i, array)
	{
		if (i < 0 || i >= length(array))
		{
			throw new Error(
				"Index " + i + " is out of range. Check the length of " +
				"your array first or use getMaybe or getWithDefault.");
		}
		return unsafeGet(i, array);
	}


	function unsafeGet(i, array)
	{
		for (var x = array.height; x > 0; x--)
		{
			var slot = i >> (x * 5);
			while (array.lengths[slot] <= i)
			{
				slot++;
			}
			if (slot > 0)
			{
				i -= array.lengths[slot - 1];
			}
			array = array.table[slot];
		}
		return array.table[i];
	}


	// Sets the value at the index i. Only the nodes leading to i will get
	// copied and updated.
	function set(i, item, array)
	{
		if (i < 0 || length(array) <= i)
		{
			return array;
		}
		return unsafeSet(i, item, array);
	}


	function unsafeSet(i, item, array)
	{
		array = nodeCopy(array);

		if (array.height == 0)
		{
			array.table[i] = item;
		}
		else
		{
			var slot = getSlot(i, array);
			if (slot > 0)
			{
				i -= array.lengths[slot - 1];
			}
			array.table[slot] = unsafeSet(i, item, array.table[slot]);
		}
		return array;
	}


	function initialize(len, f)
	{
		if (len == 0)
		{
			return empty;
		}
		var h = Math.floor( Math.log(len) / Math.log(M) );
		return initialize_(f, h, 0, len);
	}

	function initialize_(f, h, from, to)
	{
		if (h == 0)
		{
			var table = new Array((to - from) % (M + 1));
			for (var i = 0; i < table.length; i++)
			{
			  table[i] = f(from + i);
			}
			return {
				ctor: "_Array",
				height: 0,
				table: table
			};
		}

		var step = Math.pow(M, h);
		var table = new Array(Math.ceil((to - from) / step));
		var lengths = new Array(table.length);
		for (var i = 0; i < table.length; i++)
		{
			table[i] = initialize_(f, h - 1, from + (i * step), Math.min(from + ((i + 1) * step), to));
			lengths[i] = length(table[i]) + (i > 0 ? lengths[i-1] : 0);
		}
		return {
			ctor: "_Array",
			height: h,
			table: table,
			lengths: lengths
		};
	}

	function fromList(list)
	{
		if (list == List.Nil)
		{
			return empty;
		}

		// Allocate M sized blocks (table) and write list elements to it.
		var table = new Array(M);
		var nodes = new Array();
		var i = 0;

		while (list.ctor !== '[]')
		{
			table[i] = list._0;
			list = list._1;
			i++;

			// table is full, so we can push a leaf containing it into the
			// next node.
			if (i == M)
			{
				var leaf = {
					ctor: "_Array",
					height: 0,
					table: table
				};
				fromListPush(leaf, nodes);
				table = new Array(M);
				i = 0;
			}
		}

		// Maybe there is something left on the table.
		if (i > 0)
		{
			var leaf = {
				ctor: "_Array",
				height: 0,
				table: table.splice(0,i)
			};
			fromListPush(leaf, nodes);
		}

		// Go through all of the nodes and eventually push them into higher nodes.
		for (var h = 0; h < nodes.length - 1; h++)
		{
			if (nodes[h].table.length > 0)
			{
				fromListPush(nodes[h], nodes);
			}
		}

		var head = nodes[nodes.length - 1];
		if (head.height > 0 && head.table.length == 1)
		{
			return head.table[0];
		}
		else
		{
			return head;
		}
	}

	// Push a node into a higher node as a child.
	function fromListPush(toPush, nodes)
	{
		var h = toPush.height;

		// Maybe the node on this height does not exist.
		if (nodes.length == h)
		{
			var node = {
				ctor: "_Array",
				height: h + 1,
				table: new Array(),
				lengths: new Array()
			};
			nodes.push(node);
		}

		nodes[h].table.push(toPush);
		var len = length(toPush);
		if (nodes[h].lengths.length > 0)
		{
			len += nodes[h].lengths[nodes[h].lengths.length - 1];
		}
		nodes[h].lengths.push(len);

		if (nodes[h].table.length == M)
		{
			fromListPush(nodes[h], nodes);
			nodes[h] = {
				ctor: "_Array",
				height: h + 1,
				table: new Array(),
				lengths: new Array()
			};
		}
	}

	// Pushes an item via push_ to the bottom right of a tree.
	function push(item, a)
	{
		var pushed = push_(item, a);
		if (pushed !== null)
		{
			return pushed;
		}

		var newTree = create(item, a.height);
		return siblise(a, newTree);
	}

	// Recursively tries to push an item to the bottom-right most
	// tree possible. If there is no space left for the item,
	// null will be returned.
	function push_(item, a)
	{
		// Handle resursion stop at leaf level.
		if (a.height == 0)
		{
			if (a.table.length < M)
			{
				var newA = {
					ctor: "_Array",
					height: 0,
					table: a.table.slice()
				};
				newA.table.push(item);
				return newA;
			}
			else
			{
			  return null;
			}
		}

		// Recursively push
		var pushed = push_(item, botRight(a));

		// There was space in the bottom right tree, so the slot will
		// be updated.
		if (pushed != null)
		{
			var newA = nodeCopy(a);
			newA.table[newA.table.length - 1] = pushed;
			newA.lengths[newA.lengths.length - 1]++;
			return newA;
		}

		// When there was no space left, check if there is space left
		// for a new slot with a tree which contains only the item
		// at the bottom.
		if (a.table.length < M)
		{
			var newSlot = create(item, a.height - 1);
			var newA = nodeCopy(a);
			newA.table.push(newSlot);
			newA.lengths.push(newA.lengths[newA.lengths.length - 1] + length(newSlot));
			return newA;
		}
		else
		{
			return null;
		}
	}

	// Converts an array into a list of elements.
	function toList(a)
	{
		return toList_(List.Nil, a);
	}

	function toList_(list, a)
	{
		for (var i = a.table.length - 1; i >= 0; i--)
		{
			list =
				a.height == 0
					? List.Cons(a.table[i], list)
					: toList_(list, a.table[i]);
		}
		return list;
	}

	// Maps a function over the elements of an array.
	function map(f, a)
	{
		var newA = {
			ctor: "_Array",
			height: a.height,
			table: new Array(a.table.length)
		};
		if (a.height > 0)
		{
			newA.lengths = a.lengths;
		}
		for (var i = 0; i < a.table.length; i++)
		{
			newA.table[i] =
				a.height == 0
					? f(a.table[i])
					: map(f, a.table[i]);
		}
		return newA;
	}

	// Maps a function over the elements with their index as first argument.
	function indexedMap(f, a)
	{
		return indexedMap_(f, a, 0);
	}

	function indexedMap_(f, a, from)
	{
		var newA = {
			ctor: "_Array",
			height: a.height,
			table: new Array(a.table.length)
		};
		if (a.height > 0)
		{
			newA.lengths = a.lengths;
		}
		for (var i = 0; i < a.table.length; i++)
		{
			newA.table[i] =
				a.height == 0
					? A2(f, from + i, a.table[i])
					: indexedMap_(f, a.table[i], i == 0 ? 0 : a.lengths[i - 1]);
		}
		return newA;
	}

	function foldl(f, b, a)
	{
		if (a.height == 0)
		{
			for (var i = 0; i < a.table.length; i++)
			{
				b = A2(f, a.table[i], b);
			}
		}
		else
		{
			for (var i = 0; i < a.table.length; i++)
			{
				b = foldl(f, b, a.table[i]);
			}
		}
		return b;
	}

	function foldr(f, b, a)
	{
		if (a.height == 0)
		{
			for (var i = a.table.length; i--; )
			{
				b = A2(f, a.table[i], b);
			}
		}
		else
		{
			for (var i = a.table.length; i--; )
			{
				b = foldr(f, b, a.table[i]);
			}
		}
		return b;
	}

	// TODO: currently, it slices the right, then the left. This can be
	// optimized.
	function slice(from, to, a)
	{
		if (from < 0)
		{
			from += length(a);
		}
		if (to < 0)
		{
			to += length(a);
		}
		return sliceLeft(from, sliceRight(to, a));
	}

	function sliceRight(to, a)
	{
		if (to == length(a))
		{
			return a;
		}

		// Handle leaf level.
		if (a.height == 0)
		{
			var newA = { ctor:"_Array", height:0 };
			newA.table = a.table.slice(0, to);
			return newA;
		}

		// Slice the right recursively.
		var right = getSlot(to, a);
		var sliced = sliceRight(to - (right > 0 ? a.lengths[right - 1] : 0), a.table[right]);

		// Maybe the a node is not even needed, as sliced contains the whole slice.
		if (right == 0)
		{
			return sliced;
		}

		// Create new node.
		var newA = {
			ctor: "_Array",
			height: a.height,
			table: a.table.slice(0, right),
			lengths: a.lengths.slice(0, right)
		};
		if (sliced.table.length > 0)
		{
			newA.table[right] = sliced;
			newA.lengths[right] = length(sliced) + (right > 0 ? newA.lengths[right - 1] : 0);
		}
		return newA;
	}

	function sliceLeft(from, a)
	{
		if (from == 0)
		{
			return a;
		}

		// Handle leaf level.
		if (a.height == 0)
		{
			var newA = { ctor:"_Array", height:0 };
			newA.table = a.table.slice(from, a.table.length + 1);
			return newA;
		}

		// Slice the left recursively.
		var left = getSlot(from, a);
		var sliced = sliceLeft(from - (left > 0 ? a.lengths[left - 1] : 0), a.table[left]);

		// Maybe the a node is not even needed, as sliced contains the whole slice.
		if (left == a.table.length - 1)
		{
			return sliced;
		}

		// Create new node.
		var newA = {
			ctor: "_Array",
			height: a.height,
			table: a.table.slice(left, a.table.length + 1),
			lengths: new Array(a.table.length - left)
		};
		newA.table[0] = sliced;
		var len = 0;
		for (var i = 0; i < newA.table.length; i++)
		{
			len += length(newA.table[i]);
			newA.lengths[i] = len;
		}

		return newA;
	}

	// Appends two trees.
	function append(a,b)
	{
		if (a.table.length === 0)
		{
			return b;
		}
		if (b.table.length === 0)
		{
			return a;
		}

		var c = append_(a, b);

		// Check if both nodes can be crunshed together.
		if (c[0].table.length + c[1].table.length <= M)
		{
			if (c[0].table.length === 0)
			{
				return c[1];
			}
			if (c[1].table.length === 0)
			{
				return c[0];
			}

			// Adjust .table and .lengths
			c[0].table = c[0].table.concat(c[1].table);
			if (c[0].height > 0)
			{
				var len = length(c[0]);
				for (var i = 0; i < c[1].lengths.length; i++)
				{
					c[1].lengths[i] += len;
				}
				c[0].lengths = c[0].lengths.concat(c[1].lengths);
			}

			return c[0];
		}

		if (c[0].height > 0)
		{
			var toRemove = calcToRemove(a, b);
			if (toRemove > E)
			{
				c = shuffle(c[0], c[1], toRemove);
			}
		}

		return siblise(c[0], c[1]);
	}

	// Returns an array of two nodes; right and left. One node _may_ be empty.
	function append_(a, b)
	{
		if (a.height === 0 && b.height === 0)
		{
			return [a, b];
		}

		if (a.height !== 1 || b.height !== 1)
		{
			if (a.height === b.height)
			{
				a = nodeCopy(a);
				b = nodeCopy(b);
				var appended = append_(botRight(a), botLeft(b));

				insertRight(a, appended[1]);
				insertLeft(b, appended[0]);
			}
			else if (a.height > b.height)
			{
				a = nodeCopy(a);
				var appended = append_(botRight(a), b);

				insertRight(a, appended[0]);
				b = parentise(appended[1], appended[1].height + 1);
			}
			else
			{
				b = nodeCopy(b);
				var appended = append_(a, botLeft(b));

				var left = appended[0].table.length === 0 ? 0 : 1;
				var right = left === 0 ? 1 : 0;
				insertLeft(b, appended[left]);
				a = parentise(appended[right], appended[right].height + 1);
			}
		}

		// Check if balancing is needed and return based on that.
		if (a.table.length === 0 || b.table.length === 0)
		{
			return [a,b];
		}

		var toRemove = calcToRemove(a, b);
		if (toRemove <= E)
		{
			return [a,b];
		}
		return shuffle(a, b, toRemove);
	}

	// Helperfunctions for append_. Replaces a child node at the side of the parent.
	function insertRight(parent, node)
	{
		var index = parent.table.length - 1;
		parent.table[index] = node;
		parent.lengths[index] = length(node)
		parent.lengths[index] += index > 0 ? parent.lengths[index - 1] : 0;
	}

	function insertLeft(parent, node)
	{
		if (node.table.length > 0)
		{
			parent.table[0] = node;
			parent.lengths[0] = length(node);

			var len = length(parent.table[0]);
			for (var i = 1; i < parent.lengths.length; i++)
			{
				len += length(parent.table[i]);
				parent.lengths[i] = len;
			}
		}
		else
		{
			parent.table.shift();
			for (var i = 1; i < parent.lengths.length; i++)
			{
				parent.lengths[i] = parent.lengths[i] - parent.lengths[0];
			}
			parent.lengths.shift();
		}
	}

	// Returns the extra search steps for E. Refer to the paper.
	function calcToRemove(a, b)
	{
		var subLengths = 0;
		for (var i = 0; i < a.table.length; i++)
		{
			subLengths += a.table[i].table.length;
		}
		for (var i = 0; i < b.table.length; i++)
		{
			subLengths += b.table[i].table.length;
		}

		var toRemove = a.table.length + b.table.length
		return toRemove - (Math.floor((subLengths - 1) / M) + 1);
	}

	// get2, set2 and saveSlot are helpers for accessing elements over two arrays.
	function get2(a, b, index)
	{
		return index < a.length
			? a[index]
			: b[index - a.length];
	}

	function set2(a, b, index, value)
	{
		if (index < a.length)
		{
			a[index] = value;
		}
		else
		{
			b[index - a.length] = value;
		}
	}

	function saveSlot(a, b, index, slot)
	{
		set2(a.table, b.table, index, slot);

		var l = (index == 0 || index == a.lengths.length)
			? 0
			: get2(a.lengths, a.lengths, index - 1);

		set2(a.lengths, b.lengths, index, l + length(slot));
	}

	// Creates a node or leaf with a given length at their arrays for perfomance.
	// Is only used by shuffle.
	function createNode(h, length)
	{
		if (length < 0)
		{
			length = 0;
		}
		var a = {
			ctor: "_Array",
			height: h,
			table: new Array(length)
		};
		if (h > 0)
		{
			a.lengths = new Array(length);
		}
		return a;
	}

	// Returns an array of two balanced nodes.
	function shuffle(a, b, toRemove)
	{
		var newA = createNode(a.height, Math.min(M, a.table.length + b.table.length - toRemove));
		var newB = createNode(a.height, newA.table.length - (a.table.length + b.table.length - toRemove));

		// Skip the slots with size M. More precise: copy the slot references
		// to the new node
		var read = 0;
		while (get2(a.table, b.table, read).table.length % M == 0)
		{
			set2(newA.table, newB.table, read, get2(a.table, b.table, read));
			set2(newA.lengths, newB.lengths, read, get2(a.lengths, b.lengths, read));
			read++;
		}

		// Pulling items from left to right, caching in a slot before writing
		// it into the new nodes.
		var write = read;
		var slot = new createNode(a.height - 1, 0);
		var from = 0;

		// If the current slot is still containing data, then there will be at
		// least one more write, so we do not break this loop yet.
		while (read - write - (slot.table.length > 0 ? 1 : 0) < toRemove)
		{
			// Find out the max possible items for copying.
			var source = get2(a.table, b.table, read);
			var to = Math.min(M - slot.table.length, source.table.length)

			// Copy and adjust size table.
			slot.table = slot.table.concat(source.table.slice(from, to));
			if (slot.height > 0)
			{
				var len = slot.lengths.length;
				for (var i = len; i < len + to - from; i++)
				{
					slot.lengths[i] = length(slot.table[i]);
					slot.lengths[i] += (i > 0 ? slot.lengths[i - 1] : 0);
				}
			}

			from += to;

			// Only proceed to next slots[i] if the current one was
			// fully copied.
			if (source.table.length <= to)
			{
				read++; from = 0;
			}

			// Only create a new slot if the current one is filled up.
			if (slot.table.length == M)
			{
				saveSlot(newA, newB, write, slot);
				slot = createNode(a.height - 1,0);
				write++;
			}
		}

		// Cleanup after the loop. Copy the last slot into the new nodes.
		if (slot.table.length > 0)
		{
			saveSlot(newA, newB, write, slot);
			write++;
		}

		// Shift the untouched slots to the left
		while (read < a.table.length + b.table.length )
		{
			saveSlot(newA, newB, write, get2(a.table, b.table, read));
			read++;
			write++;
		}

		return [newA, newB];
	}

	// Navigation functions
	function botRight(a)
	{
		return a.table[a.table.length - 1];
	}
	function botLeft(a)
	{
		return a.table[0];
	}

	// Copies a node for updating. Note that you should not use this if
	// only updating only one of "table" or "lengths" for performance reasons.
	function nodeCopy(a)
	{
		var newA = {
			ctor: "_Array",
			height: a.height,
			table: a.table.slice()
		};
		if (a.height > 0)
		{
			newA.lengths = a.lengths.slice();
		}
		return newA;
	}

	// Returns how many items are in the tree.
	function length(array)
	{
		if (array.height == 0)
		{
			return array.table.length;
		}
		else
		{
			return array.lengths[array.lengths.length - 1];
		}
	}

	// Calculates in which slot of "table" the item probably is, then
	// find the exact slot via forward searching in  "lengths". Returns the index.
	function getSlot(i, a)
	{
		var slot = i >> (5 * a.height);
		while (a.lengths[slot] <= i)
		{
			slot++;
		}
		return slot;
	}

	// Recursively creates a tree with a given height containing
	// only the given item.
	function create(item, h)
	{
		if (h == 0)
		{
			return {
				ctor: "_Array",
				height: 0,
				table: [item]
			};
		}
		return {
			ctor: "_Array",
			height: h,
			table: [create(item, h - 1)],
			lengths: [1]
		};
	}

	// Recursively creates a tree that contains the given tree.
	function parentise(tree, h)
	{
		if (h == tree.height)
		{
			return tree;
		}

		return {
			ctor: "_Array",
			height: h,
			table: [parentise(tree, h - 1)],
			lengths: [length(tree)]
		};
	}

	// Emphasizes blood brotherhood beneath two trees.
	function siblise(a, b)
	{
		return {
			ctor: "_Array",
			height: a.height + 1,
			table: [a, b],
			lengths: [length(a), length(a) + length(b)]
		};
	}

	function toJSArray(a)
	{
		var jsArray = new Array(length(a));
		toJSArray_(jsArray, 0, a);
		return jsArray;
	}

	function toJSArray_(jsArray, i, a)
	{
		for (var t = 0; t < a.table.length; t++)
		{
			if (a.height == 0)
			{
				jsArray[i + t] = a.table[t];
			}
			else
			{
				var inc = t == 0 ? 0 : a.lengths[t - 1];
				toJSArray_(jsArray, i + inc, a.table[t]);
			}
		}
	}

	function fromJSArray(jsArray)
	{
		if (jsArray.length == 0)
		{
			return empty;
		}
		var h = Math.floor(Math.log(jsArray.length) / Math.log(M));
		return fromJSArray_(jsArray, h, 0, jsArray.length);
	}

	function fromJSArray_(jsArray, h, from, to)
	{
		if (h == 0)
		{
			return {
				ctor: "_Array",
				height: 0,
				table: jsArray.slice(from, to)
			};
		}

		var step = Math.pow(M, h);
		var table = new Array(Math.ceil((to - from) / step));
		var lengths = new Array(table.length);
		for (var i = 0; i < table.length; i++)
		{
			table[i] = fromJSArray_(jsArray, h - 1, from + (i * step), Math.min(from + ((i + 1) * step), to));
			lengths[i] = length(table[i]) + (i > 0 ? lengths[i-1] : 0);
		}
		return {
			ctor: "_Array",
			height: h,
			table: table,
			lengths: lengths
		};
	}

	Elm.Native.Array.values = {
		empty: empty,
		fromList: fromList,
		toList: toList,
		initialize: F2(initialize),
		append: F2(append),
		push: F2(push),
		slice: F3(slice),
		get: F2(get),
		set: F3(set),
		map: F2(map),
		indexedMap: F2(indexedMap),
		foldl: F3(foldl),
		foldr: F3(foldr),
		length: length,

		toJSArray:toJSArray,
		fromJSArray:fromJSArray
	};

	return localRuntime.Native.Array.values = Elm.Native.Array.values;

}

Elm.Native.Basics = {};
Elm.Native.Basics.make = function(localRuntime) {

	localRuntime.Native = localRuntime.Native || {};
	localRuntime.Native.Basics = localRuntime.Native.Basics || {};
	if (localRuntime.Native.Basics.values)
	{
		return localRuntime.Native.Basics.values;
	}

	var Utils = Elm.Native.Utils.make(localRuntime);

	function div(a, b)
	{
		return (a/b)|0;
	}
	function rem(a, b)
	{
		return a % b;
	}
	function mod(a, b)
	{
		if (b === 0)
		{
			throw new Error("Cannot perform mod 0. Division by zero error.");
		}
		var r = a % b;
		var m = a === 0 ? 0 : (b > 0 ? (a >= 0 ? r : r+b) : -mod(-a,-b));

		return m === b ? 0 : m;
	}
	function logBase(base, n)
	{
		return Math.log(n) / Math.log(base);
	}
	function negate(n)
	{
		return -n;
	}
	function abs(n)
	{
		return n < 0 ? -n : n;
	}

	function min(a, b)
	{
		return Utils.cmp(a,b) < 0 ? a : b;
	}
	function max(a, b)
	{
		return Utils.cmp(a,b) > 0 ? a : b;
	}
	function clamp(lo, hi, n)
	{
		return Utils.cmp(n,lo) < 0 ? lo : Utils.cmp(n,hi) > 0 ? hi : n;
	}

	function xor(a, b)
	{
		return a !== b;
	}
	function not(b)
	{
		return !b;
	}
	function isInfinite(n)
	{
		return n === Infinity || n === -Infinity
	}

	function truncate(n)
	{
		return n|0;
	}

	function degrees(d)
	{
		return d * Math.PI / 180;
	}
	function turns(t)
	{
		return 2 * Math.PI * t;
	}
	function fromPolar(point)
	{
		var r = point._0;
		var t = point._1;
		return Utils.Tuple2(r * Math.cos(t), r * Math.sin(t));
	}
	function toPolar(point)
	{
		var x = point._0;
		var y = point._1;
		return Utils.Tuple2(Math.sqrt(x * x + y * y), Math.atan2(y,x));
	}

	return localRuntime.Native.Basics.values = {
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
};

Elm.Native.Char = {};
Elm.Native.Char.make = function(localRuntime) {
	localRuntime.Native = localRuntime.Native || {};
	localRuntime.Native.Char = localRuntime.Native.Char || {};
	if (localRuntime.Native.Char.values)
	{
		return localRuntime.Native.Char.values;
	}

	var Utils = Elm.Native.Utils.make(localRuntime);

	return localRuntime.Native.Char.values = {
		fromCode : function(c) { return Utils.chr(String.fromCharCode(c)); },
		toCode   : function(c) { return c.charCodeAt(0); },
		toUpper  : function(c) { return Utils.chr(c.toUpperCase()); },
		toLower  : function(c) { return Utils.chr(c.toLowerCase()); },
		toLocaleUpper : function(c) { return Utils.chr(c.toLocaleUpperCase()); },
		toLocaleLower : function(c) { return Utils.chr(c.toLocaleLowerCase()); },
	};
};

Elm.Native.Color = {};
Elm.Native.Color.make = function(localRuntime) {
	localRuntime.Native = localRuntime.Native || {};
	localRuntime.Native.Color = localRuntime.Native.Color || {};
	if (localRuntime.Native.Color.values)
	{
		return localRuntime.Native.Color.values;
	}

	function toCss(c)
	{
		var format = '';
		var colors = '';
		if (c.ctor === 'RGBA')
		{
			format = 'rgb';
			colors = c._0 + ', ' + c._1 + ', ' + c._2;
		}
		else
		{
			format = 'hsl';
			colors = (c._0 * 180 / Math.PI) + ', ' +
					 (c._1 * 100) + '%, ' +
					 (c._2 * 100) + '%';
		}
		if (c._3 === 1)
		{
			return format + '(' + colors + ')';
		}
		else
		{
			return format + 'a(' + colors + ', ' + c._3 + ')';
		}
	}

	return localRuntime.Native.Color.values = {
		toCss: toCss
	};

};

Elm.Native.Debug = {};
Elm.Native.Debug.make = function(localRuntime) {
	localRuntime.Native = localRuntime.Native || {};
	localRuntime.Native.Debug = localRuntime.Native.Debug || {};
	if (localRuntime.Native.Debug.values)
	{
		return localRuntime.Native.Debug.values;
	}

	var toString = Elm.Native.Show.make(localRuntime).toString;

	function log(tag, value)
	{
		var msg = tag + ': ' + toString(value);
		var process = process || {};
		if (process.stdout)
		{
			process.stdout.write(msg);
		}
		else
		{
			console.log(msg);
		}
		return value;
	}

	function crash(message)
	{
		throw new Error(message);
	}

	function tracePath(tag, form)
	{
		if (localRuntime.debug)
		{
			return localRuntime.debug.trace(tag, form);
		}
		return form;
	}

	function watch(tag, value)
	{
		if (localRuntime.debug)
		{
			localRuntime.debug.watch(tag, value);
		}
		return value;
	}

	function watchSummary(tag, summarize, value)
	{
		if (localRuntime.debug)
		{
			localRuntime.debug.watch(tag, summarize(value));
		}
		return value;
	}

	return localRuntime.Native.Debug.values = {
		crash: crash,
		tracePath: F2(tracePath),
		log: F2(log),
		watch: F2(watch),
		watchSummary:F3(watchSummary),
	};
};


// setup
Elm.Native = Elm.Native || {};
Elm.Native.Graphics = Elm.Native.Graphics || {};
Elm.Native.Graphics.Collage = Elm.Native.Graphics.Collage || {};

// definition
Elm.Native.Graphics.Collage.make = function(localRuntime) {
	'use strict';

	// attempt to short-circuit
	localRuntime.Native = localRuntime.Native || {};
	localRuntime.Native.Graphics = localRuntime.Native.Graphics || {};
	localRuntime.Native.Graphics.Collage = localRuntime.Native.Graphics.Collage || {};
	if ('values' in localRuntime.Native.Graphics.Collage)
	{
		return localRuntime.Native.Graphics.Collage.values;
	}

	// okay, we cannot short-ciruit, so now we define everything
	var Color = Elm.Native.Color.make(localRuntime);
	var List = Elm.Native.List.make(localRuntime);
	var NativeElement = Elm.Native.Graphics.Element.make(localRuntime);
	var Transform = Elm.Transform2D.make(localRuntime);
	var Utils = Elm.Native.Utils.make(localRuntime);

	function setStrokeStyle(ctx, style)
	{
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
	}

	function setFillStyle(ctx, style)
	{
		var sty = style.ctor;
		ctx.fillStyle = sty === 'Solid'
			? Color.toCss(style._0)
			: sty === 'Texture'
				? texture(redo, ctx, style._0)
				: gradient(ctx, style._0);
	}

	function trace(ctx, path)
	{
		var points = List.toArray(path);
		var i = points.length - 1;
		if (i <= 0)
		{
			return;
		}
		ctx.moveTo(points[i]._0, points[i]._1);
		while (i--)
		{
			ctx.lineTo(points[i]._0, points[i]._1);
		}
		if (path.closed)
		{
			i = points.length - 1;
			ctx.lineTo(points[i]._0, points[i]._1);
		}
	}

	function line(ctx,style,path)
	{
		(style.dashing.ctor === '[]')
			? trace(ctx, path)
			: customLineHelp(ctx, style, path);
		ctx.scale(1,-1);
		ctx.stroke();
	}

	function customLineHelp(ctx, style, path)
	{
		var points = List.toArray(path);
		if (path.closed)
		{
			points.push(points[0]);
		}
		var pattern = List.toArray(style.dashing);
		var i = points.length - 1;
		if (i <= 0)
		{
			return;
		}
		var x0 = points[i]._0, y0 = points[i]._1;
		var x1=0, y1=0, dx=0, dy=0, remaining=0, nx=0, ny=0;
		var pindex = 0, plen = pattern.length;
		var draw = true, segmentLength = pattern[0];
		ctx.moveTo(x0,y0);
		while (i--)
		{
			x1 = points[i]._0;
			y1 = points[i]._1;
			dx = x1 - x0;
			dy = y1 - y0;
			remaining = Math.sqrt(dx * dx + dy * dy);
			while (segmentLength <= remaining)
			{
				x0 += dx * segmentLength / remaining;
				y0 += dy * segmentLength / remaining;
				ctx[draw ? 'lineTo' : 'moveTo'](x0, y0);
				// update starting position
				dx = x1 - x0;
				dy = y1 - y0;
				remaining = Math.sqrt(dx * dx + dy * dy);
				// update pattern
				draw = !draw;
				pindex = (pindex + 1) % plen;
				segmentLength = pattern[pindex];
			}
			if (remaining > 0)
			{
				ctx[draw ? 'lineTo' : 'moveTo'](x1, y1);
				segmentLength -= remaining;
			}
			x0 = x1;
			y0 = y1;
		}
	}

	function drawLine(ctx, style, path)
	{
		setStrokeStyle(ctx, style);
		return line(ctx, style, path);
	}

	function texture(redo, ctx, src)
	{
		var img = new Image();
		img.src = src;
		img.onload = redo;
		return ctx.createPattern(img, 'repeat');
	}

	function gradient(ctx, grad)
	{
		var g;
		var stops = [];
		if (grad.ctor === 'Linear')
		{
			var p0 = grad._0, p1 = grad._1;
			g = ctx.createLinearGradient(p0._0, -p0._1, p1._0, -p1._1);
			stops = List.toArray(grad._2);
		}
		else
		{
			var p0 = grad._0, p2 = grad._2;
			g = ctx.createRadialGradient(p0._0, -p0._1, grad._1, p2._0, -p2._1, grad._3);
			stops = List.toArray(grad._4);
		}
		var len = stops.length;
		for (var i = 0; i < len; ++i)
		{
			var stop = stops[i];
			g.addColorStop(stop._0, Color.toCss(stop._1));
		}
		return g;
	}

	function drawShape(redo, ctx, style, path)
	{
		trace(ctx, path);
		setFillStyle(ctx, style);
		ctx.scale(1,-1);
		ctx.fill();
	}


	// TEXT RENDERING

	function fillText(redo, ctx, text)
	{
		drawText(ctx, text, ctx.fillText);
	}

	function strokeText(redo, ctx, style, text)
	{
		setStrokeStyle(ctx, style);
		// Use native canvas API for dashes only for text for now
		// Degrades to non-dashed on IE 9 + 10
		if (style.dashing.ctor !== '[]' && ctx.setLineDash)
		{
			var pattern = List.toArray(style.dashing);
			ctx.setLineDash(pattern);
		}
		drawText(ctx, text, ctx.strokeText);
	}

	function drawText(ctx, text, canvasDrawFn)
	{
		var textChunks = chunkText(defaultContext, text);

		var totalWidth = 0;
		var maxHeight = 0;
		var numChunks = textChunks.length;

		ctx.scale(1,-1);

		for (var i = numChunks; i--; )
		{
			var chunk = textChunks[i];
			ctx.font = chunk.font;
			var metrics = ctx.measureText(chunk.text);
			chunk.width = metrics.width;
			totalWidth += chunk.width;
			if (chunk.height > maxHeight)
			{
				maxHeight = chunk.height;
			}
		}

		var x = -totalWidth / 2.0;
		for (var i = 0; i < numChunks; ++i)
		{
			var chunk = textChunks[i];
			ctx.font = chunk.font;
			ctx.fillStyle = chunk.color;
			canvasDrawFn.call(ctx, chunk.text, x, maxHeight / 2);
			x += chunk.width;
		}
	}

	function toFont(props)
	{
		return [
			props['font-style'],
			props['font-variant'],
			props['font-weight'],
			props['font-size'],
			props['font-family']
		].join(' ');
	}


	// Convert the object returned by the text module
	// into something we can use for styling canvas text
	function chunkText(context, text)
	{
		var tag = text.ctor;
		if (tag === 'Text:Append')
		{
			var leftChunks = chunkText(context, text._0);
			var rightChunks = chunkText(context, text._1);
			return leftChunks.concat(rightChunks);
		}
		if (tag === 'Text:Text')
		{
			return [{
				text: text._0,
				color: context.color,
				height: context['font-size'].slice(0,-2) | 0,
				font: toFont(context)
			}];
		}
		if (tag === 'Text:Meta')
		{
			var newContext = freshContext(text._0, context);
			return chunkText(newContext, text._1);
		}
	}

	function freshContext(props, ctx)
	{
		return {
			'font-style': props['font-style'] || ctx['font-style'],
			'font-variant': props['font-variant'] || ctx['font-variant'],
			'font-weight': props['font-weight'] || ctx['font-weight'],
			'font-size': props['font-size'] || ctx['font-size'],
			'font-family': props['font-family'] || ctx['font-family'],
			'color': props['color'] || ctx['color']
		};
	}

	var defaultContext = {
		'font-style': 'normal',
		'font-variant': 'normal',
		'font-weight': 'normal',
		'font-size': '12px',
		'font-family': 'sans-serif',
		'color': 'black'
	};


	// IMAGES

	function drawImage(redo, ctx, form)
	{
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

	function renderForm(redo, ctx, form)
	{
		ctx.save();

		var x = form.x,
			y = form.y,
			theta = form.theta,
			scale = form.scale;

		if (x !== 0 || y !== 0)
		{
			ctx.translate(x, y);
		}
		if (theta !== 0)
		{
			ctx.rotate(theta);
		}
		if (scale !== 1)
		{
			ctx.scale(scale,scale);
		}
		if (form.alpha !== 1)
		{
			ctx.globalAlpha = ctx.globalAlpha * form.alpha;
		}

		ctx.beginPath();
		var f = form.form;
		switch (f.ctor)
		{
			case 'FPath':
				drawLine(ctx, f._0, f._1);
				break;

			case 'FImage':
				drawImage(redo, ctx, f);
				break;

			case 'FShape':
				if (f._0.ctor === 'Line')
				{
					f._1.closed = true;
					drawLine(ctx, f._0._0, f._1);
				}
				else
				{
					drawShape(redo, ctx, f._0._0, f._1);
				}
				break;

			case 'FText':
				fillText(redo, ctx, f._0);
				break;

			case 'FOutlinedText':
				strokeText(redo, ctx, f._0, f._1);
				break;
		}
		ctx.restore();
	}

	function formToMatrix(form)
	{
	   var scale = form.scale;
	   var matrix = A6( Transform.matrix, scale, 0, 0, scale, form.x, form.y );

	   var theta = form.theta
	   if (theta !== 0)
	   {
		   matrix = A2( Transform.multiply, matrix, Transform.rotation(theta) );
	   }

	   return matrix;
	}

	function str(n)
	{
		if (n < 0.00001 && n > -0.00001)
		{
			return 0;
		}
		return n;
	}

	function makeTransform(w, h, form, matrices)
	{
		var props = form.form._0.props;
		var m = A6( Transform.matrix, 1, 0, 0, -1,
					(w - props.width ) / 2,
					(h - props.height) / 2 );
		var len = matrices.length;
		for (var i = 0; i < len; ++i)
		{
			m = A2( Transform.multiply, m, matrices[i] );
		}
		m = A2( Transform.multiply, m, formToMatrix(form) );

		return 'matrix(' +
			str( m[0]) + ', ' + str( m[3]) + ', ' +
			str(-m[1]) + ', ' + str(-m[4]) + ', ' +
			str( m[2]) + ', ' + str( m[5]) + ')';
	}

	function stepperHelp(list)
	{
		var arr = List.toArray(list);
		var i = 0;
		function peekNext()
		{
			return i < arr.length ? arr[i].form.ctor : '';
		}
		// assumes that there is a next element
		function next()
		{
			var out = arr[i];
			++i;
			return out;
		}
		return {
			peekNext: peekNext,
			next: next
		};
	}

	function formStepper(forms)
	{
		var ps = [stepperHelp(forms)];
		var matrices = [];
		var alphas = [];
		function peekNext()
		{
			var len = ps.length;
			var formType = '';
			for (var i = 0; i < len; ++i )
			{
				if (formType = ps[i].peekNext()) return formType;
			}
			return '';
		}
		// assumes that there is a next element
		function next(ctx)
		{
			while (!ps[0].peekNext())
			{
				ps.shift();
				matrices.pop();
				alphas.shift();
				if (ctx)
				{
					ctx.restore();
				}
			}
			var out = ps[0].next();
			var f = out.form;
			if (f.ctor === 'FGroup')
			{
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
		function transforms()
		{
			return matrices;
		}
		function alpha()
		{
			return alphas[0] || 1;
		}
		return {
			peekNext: peekNext,
			next: next,
			transforms: transforms,
			alpha: alpha
		};
	}

	function makeCanvas(w,h)
	{
		var canvas = NativeElement.createNode('canvas');
		canvas.style.width  = w + 'px';
		canvas.style.height = h + 'px';
		canvas.style.display = "block";
		canvas.style.position = "absolute";
		var ratio = window.devicePixelRatio || 1;
		canvas.width  = w * ratio;
		canvas.height = h * ratio;
		return canvas;
	}

	function render(model)
	{
		var div = NativeElement.createNode('div');
		div.style.overflow = 'hidden';
		div.style.position = 'relative';
		update(div, model, model);
		return div;
	}

	function nodeStepper(w,h,div)
	{
		var kids = div.childNodes;
		var i = 0;
		var ratio = window.devicePixelRatio || 1;

		function transform(transforms, ctx)
		{
			ctx.translate( w / 2 * ratio, h / 2 * ratio );
			ctx.scale( ratio, -ratio );
			var len = transforms.length;
			for (var i = 0; i < len; ++i)
			{
				var m = transforms[i];
				ctx.save();
				ctx.transform(m[0], m[3], m[1], m[4], m[2], m[5]);
			}
			return ctx;
		}
		function nextContext(transforms)
		{
			while (i < kids.length)
			{
				var node = kids[i];
				if (node.getContext)
				{
					node.width = w * ratio;
					node.height = h * ratio;
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
		function addElement(matrices, alpha, form)
		{
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
			if (!kid)
			{
				div.appendChild(node);
			}
			else
			{
				div.insertBefore(node, kid);
			}
		}
		function clearRest()
		{
			while (i < kids.length)
			{
				div.removeChild(kids[i]);
			}
		}
		return {
			nextContext: nextContext,
			addElement: addElement,
			clearRest: clearRest
		};
	}


	function update(div, _, model)
	{
		var w = model.w;
		var h = model.h;

		var forms = formStepper(model.forms);
		var nodes = nodeStepper(w,h,div);
		var ctx = null;
		var formType = '';

		while (formType = forms.peekNext())
		{
			// make sure we have context if we need it
			if (ctx === null && formType !== 'FElement')
			{
				ctx = nodes.nextContext(forms.transforms());
				ctx.globalAlpha = forms.alpha();
			}

			var form = forms.next(ctx);
			// if it is FGroup, all updates are made within formStepper when next is called.
			if (formType === 'FElement')
			{
				// update or insert an element, get a new context
				nodes.addElement(forms.transforms(), forms.alpha(), form);
				ctx = null;
			}
			else if (formType !== 'FGroup')
			{
				renderForm(function() { update(div, model, model); }, ctx, form);
			}
		}
		nodes.clearRest();
		return div;
	}


	function collage(w,h,forms)
	{
		return A3(NativeElement.newElement, w, h, {
			ctor: 'Custom',
			type: 'Collage',
			render: render,
			update: update,
			model: {w:w, h:h, forms:forms}
		});
	}

	return localRuntime.Native.Graphics.Collage.values = {
		collage: F3(collage)
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
	localRuntime.Native = localRuntime.Native || {};
	localRuntime.Native.Graphics = localRuntime.Native.Graphics || {};
	localRuntime.Native.Graphics.Element = localRuntime.Native.Graphics.Element || {};
	if ('values' in localRuntime.Native.Graphics.Element)
	{
		return localRuntime.Native.Graphics.Element.values;
	}

	var Color = Elm.Native.Color.make(localRuntime);
	var List = Elm.Native.List.make(localRuntime);
	var Maybe = Elm.Maybe.make(localRuntime);
	var Text = Elm.Native.Text.make(localRuntime);
	var Utils = Elm.Native.Utils.make(localRuntime);


	// CREATION

	function createNode(elementType)
	{
		var node = document.createElement(elementType);
		node.style.padding = "0";
		node.style.margin = "0";
		return node;
	}


	function newElement(width, height, elementPrim)
	{
		return {
			_: {},
			element: elementPrim,
			props: {
				_: {},
				id: Utils.guid(),
				width: width,
				height: height,
				opacity: 1,
				color: Maybe.Nothing,
				href: "",
				tag: "",
				hover: Utils.Tuple0,
				click: Utils.Tuple0
			}
		};
	}


	// PROPERTIES

	function setProps(elem, node)
	{
		var props = elem.props;

		var element = elem.element;
		var width = props.width - (element.adjustWidth || 0);
		var height = props.height - (element.adjustHeight || 0);
		node.style.width  = (width |0) + 'px';
		node.style.height = (height|0) + 'px';

		if (props.opacity !== 1)
		{
			node.style.opacity = props.opacity;
		}

		if (props.color.ctor === 'Just')
		{
			node.style.backgroundColor = Color.toCss(props.color._0);
		}

		if (props.tag !== '')
		{
			node.id = props.tag;
		}

		if (props.hover.ctor !== '_Tuple0')
		{
			addHover(node, props.hover);
		}

		if (props.click.ctor !== '_Tuple0')
		{
			addClick(node, props.click);
		}

		if (props.href !== '')
		{
			var anchor = createNode('a');
			anchor.href = props.href;
			anchor.style.display = 'block';
			anchor.style.pointerEvents = 'auto';
			anchor.appendChild(node);
			node = anchor;
		}

		return node;
	}

	function addClick(e, handler)
	{
		e.style.pointerEvents = 'auto';
		e.elm_click_handler = handler;
		function trigger(ev)
		{
			e.elm_click_handler(Utils.Tuple0);
			ev.stopPropagation();
		}
		e.elm_click_trigger = trigger;
		e.addEventListener('click', trigger);
	}

	function removeClick(e, handler)
	{
		if (e.elm_click_trigger)
		{
			e.removeEventListener('click', e.elm_click_trigger);
			e.elm_click_trigger = null;
			e.elm_click_handler = null;
		}
	}

	function addHover(e, handler)
	{
		e.style.pointerEvents = 'auto';
		e.elm_hover_handler = handler;
		e.elm_hover_count = 0;

		function over(evt)
		{
			if (e.elm_hover_count++ > 0) return;
			e.elm_hover_handler(true);
			evt.stopPropagation();
		}
		function out(evt)
		{
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

	function removeHover(e)
	{
		e.elm_hover_handler = null;
		if (e.elm_hover_over)
		{
			e.removeEventListener('mouseover', e.elm_hover_over);
			e.elm_hover_over = null;
		}
		if (e.elm_hover_out)
		{
			e.removeEventListener('mouseout', e.elm_hover_out);
			e.elm_hover_out = null;
		}
	}


	// IMAGES

	function image(props, img)
	{
		switch (img._0.ctor)
		{
			case 'Plain':
				return plainImage(img._3);

			case 'Fitted':
				return fittedImage(props.width, props.height, img._3);

			case 'Cropped':
				return croppedImage(img,props.width,props.height,img._3);

			case 'Tiled':
				return tiledImage(img._3);
		}
	}

	function plainImage(src)
	{
		var img = createNode('img');
		img.src = src;
		img.name = src;
		img.style.display = "block";
		return img;
	}

	function tiledImage(src)
	{
		var div = createNode('div');
		div.style.backgroundImage = 'url(' + src + ')';
		return div;
	}

	function fittedImage(w, h, src)
	{
		var div = createNode('div');
		div.style.background = 'url(' + src + ') no-repeat center';
		div.style.webkitBackgroundSize = 'cover';
		div.style.MozBackgroundSize = 'cover';
		div.style.OBackgroundSize = 'cover';
		div.style.backgroundSize = 'cover';
		return div;
	}

	function croppedImage(elem, w, h, src)
	{
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


	// FLOW

	function goOut(node)
	{
		node.style.position = 'absolute';
		return node;
	}
	function goDown(node)
	{
		return node;
	}
	function goRight(node)
	{
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
	function needsReversal(dir)
	{
		return dir == 'DUp' || dir == 'DLeft' || dir == 'DIn';
	}

	function flow(dir,elist)
	{
		var array = List.toArray(elist);
		var container = createNode('div');
		var goDir = directionTable[dir];
		if (goDir == goOut)
		{
			container.style.pointerEvents = 'none';
		}
		if (needsReversal(dir))
		{
			array.reverse();
		}
		var len = array.length;
		for (var i = 0; i < len; ++i)
		{
			container.appendChild(goDir(render(array[i])));
		}
		return container;
	}


	// CONTAINER

	function toPos(pos)
	{
		return pos.ctor === "Absolute"
			? pos._0 + "px"
			: (pos._0 * 100) + "%";
	}

	// must clear right, left, top, bottom, and transform
	// before calling this function
	function setPos(pos,elem,e)
	{
		var element = elem.element;
		var props = elem.props;
		var w = props.width + (element.adjustWidth ? element.adjustWidth : 0);
		var h = props.height + (element.adjustHeight ? element.adjustHeight : 0);

		e.style.position = 'absolute';
		e.style.margin = 'auto';
		var transform = '';

		switch (pos.horizontal.ctor)
		{
			case 'P':
				e.style.right = toPos(pos.x);
				e.style.removeProperty('left');
				break;

			case 'Z':
				transform = 'translateX(' + ((-w/2)|0) + 'px) ';

			case 'N':
				e.style.left = toPos(pos.x);
				e.style.removeProperty('right');
				break;
		}
		switch (pos.vertical.ctor)
		{
			case 'N':
				e.style.bottom = toPos(pos.y);
				e.style.removeProperty('top');
				break;

			case 'Z':
				transform += 'translateY(' + ((-h/2)|0) + 'px)';

			case 'P':
				e.style.top = toPos(pos.y);
				e.style.removeProperty('bottom');
				break;
		}
		if (transform !== '')
		{
			addTransform(e.style, transform);
		}
		return e;
	}

	function addTransform(style, transform)
	{
		style.transform       = transform;
		style.msTransform     = transform;
		style.MozTransform    = transform;
		style.webkitTransform = transform;
		style.OTransform      = transform;
	}

	function container(pos,elem)
	{
		var e = render(elem);
		setPos(pos, elem, e);
		var div = createNode('div');
		div.style.position = 'relative';
		div.style.overflow = 'hidden';
		div.appendChild(e);
		return div;
	}


	function rawHtml(elem)
	{
		var html = elem.html;
		var guid = elem.guid;
		var align = elem.align;

		var div = createNode('div');
		div.innerHTML = html;
		div.style.visibility = "hidden";
		if (align)
		{
			div.style.textAlign = align;
		}
		div.style.visibility = 'visible';
		div.style.pointerEvents = 'auto';
		return div;
	}


	// RENDER

	function render(elem)
	{
		return setProps(elem, makeElement(elem));
	}
	function makeElement(e)
	{
		var elem = e.element;
		switch(elem.ctor)
		{
			case 'Image':
				return image(e.props, elem);

			case 'Flow':
				return flow(elem._0.ctor, elem._1);

			case 'Container':
				return container(elem._0, elem._1);

			case 'Spacer':
				return createNode('div');

			case 'RawHtml':
				return rawHtml(elem);

			case 'Custom':
				return elem.render(elem.model);
		}
	}

	function updateAndReplace(node, curr, next)
	{
		var newNode = update(node, curr, next);
		if (newNode !== node)
		{
			node.parentNode.replaceChild(newNode, node);
		}
		return newNode;
	}


	// UPDATE

	function update(node, curr, next)
	{
		var rootNode = node;
		if (node.tagName === 'A')
		{
			node = node.firstChild;
		}
		if (curr.props.id === next.props.id)
		{
			updateProps(node, curr, next);
			return rootNode;
		}
		if (curr.element.ctor !== next.element.ctor)
		{
			return render(next);
		}
		var nextE = next.element;
		var currE = curr.element;
		switch(nextE.ctor)
		{
			case "Spacer":
				updateProps(node, curr, next);
				return rootNode;

			case "RawHtml":
				if(currE.html.valueOf() !== nextE.html.valueOf())
				{
					node.innerHTML = nextE.html;
				}
				updateProps(node, curr, next);
				return rootNode;

			case "Image":
				if (nextE._0.ctor === 'Plain')
				{
					if (nextE._3 !== currE._3)
					{
						node.src = nextE._3;
					}
				}
				else if (!Utils.eq(nextE,currE)
					|| next.props.width !== curr.props.width
					|| next.props.height !== curr.props.height)
				{
					return render(next);
				}
				updateProps(node, curr, next);
				return rootNode;

			case "Flow":
				var arr = List.toArray(nextE._1);
				for (var i = arr.length; i--; )
				{
					arr[i] = arr[i].element.ctor;
				}
				if (nextE._0.ctor !== currE._0.ctor)
				{
					return render(next);
				}
				var nexts = List.toArray(nextE._1);
				var kids = node.childNodes;
				if (nexts.length !== kids.length)
				{
					return render(next);
				}
				var currs = List.toArray(currE._1);
				var dir = nextE._0.ctor;
				var goDir = directionTable[dir];
				var toReverse = needsReversal(dir);
				var len = kids.length;
				for (var i = len; i-- ;)
				{
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
				if (currE.type === nextE.type)
				{
					var updatedNode = nextE.update(node, currE.model, nextE.model);
					updateProps(updatedNode, curr, next);
					return updatedNode;
				}
				return render(next);
		}
	}

	function updateProps(node, curr, next)
	{
		var nextProps = next.props;
		var currProps = curr.props;

		var element = next.element;
		var width = nextProps.width - (element.adjustWidth || 0);
		var height = nextProps.height - (element.adjustHeight || 0);
		if (width !== currProps.width)
		{
			node.style.width = (width|0) + 'px';
		}
		if (height !== currProps.height)
		{
			node.style.height = (height|0) + 'px';
		}

		if (nextProps.opacity !== currProps.opacity)
		{
			node.style.opacity = nextProps.opacity;
		}

		var nextColor = nextProps.color.ctor === 'Just'
			? Color.toCss(nextProps.color._0)
			: '';
		if (node.style.backgroundColor !== nextColor)
		{
			node.style.backgroundColor = nextColor;
		}

		if (nextProps.tag !== currProps.tag)
		{
			node.id = nextProps.tag;
		}

		if (nextProps.href !== currProps.href)
		{
			if (currProps.href === '')
			{
				// add a surrounding href
				var anchor = createNode('a');
				anchor.href = nextProps.href;
				anchor.style.display = 'block';
				anchor.style.pointerEvents = 'auto';

				node.parentNode.replaceChild(anchor, node);
				anchor.appendChild(node);
			}
			else if (nextProps.href === '')
			{
				// remove the surrounding href
				var anchor = node.parentNode;
				anchor.parentNode.replaceChild(node, anchor);
			}
			else
			{
				// just update the link
				node.parentNode.href = nextProps.href;
			}
		}

		// update click and hover handlers
		var removed = false;

		// update hover handlers
		if (currProps.hover.ctor === '_Tuple0')
		{
			if (nextProps.hover.ctor !== '_Tuple0')
			{
				addHover(node, nextProps.hover);
			}
		}
		else
		{
			if (nextProps.hover.ctor === '_Tuple0')
			{
				removed = true;
				removeHover(node);
			}
			else
			{
				node.elm_hover_handler = nextProps.hover;
			}
		}

		// update click handlers
		if (currProps.click.ctor === '_Tuple0')
		{
			if (nextProps.click.ctor !== '_Tuple0')
			{
				addClick(node, nextProps.click);
			}
		}
		else
		{
			if (nextProps.click.ctor === '_Tuple0')
			{
				removed = true;
				removeClick(node);
			}
			else
			{
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


	// TEXT

	function block(align)
	{
		return function(text)
		{
			var raw = {
				ctor :'RawHtml',
				html : Text.renderHtml(text),
				align: align
			};
			var pos = htmlHeight(0, raw);
			return newElement(pos._0, pos._1, raw);
		}
	}

	function markdown(text)
	{
		var raw = {
			ctor:'RawHtml',
			html: text,
			align: null
		};
		var pos = htmlHeight(0, raw);
		return newElement(pos._0, pos._1, raw);
	}

	function htmlHeight(width, rawHtml)
	{
		// create dummy node
		var temp = document.createElement('div');
		temp.innerHTML = rawHtml.html;
		if (width > 0)
		{
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


	return localRuntime.Native.Graphics.Element.values = {
		render: render,
		update: update,
		updateAndReplace: updateAndReplace,

		createNode: createNode,
		newElement: F3(newElement),
		addTransform: addTransform,
		htmlHeight: F2(htmlHeight),
		guid: Utils.guid,

		block: block,
		markdown: markdown
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
	var Signal = Elm.Native.Signal.make(localRuntime);
	var Text = Elm.Native.Text.make(localRuntime);
	var Utils = Elm.Native.Utils.make(localRuntime);

	var Element = Elm.Native.Graphics.Element.make(localRuntime);


	function renderDropDown(model)
	{
		var drop = Element.createNode('select');
		drop.style.border = '0 solid';
		drop.style.pointerEvents = 'auto';
		drop.style.display = 'block';

		drop.elm_values = List.toArray(model.values);
		drop.elm_handler = model.handler;
		var values = drop.elm_values;

		for (var i = 0; i < values.length; ++i)
		{
			var option = Element.createNode('option');
			var name = values[i]._0;
			option.value = name;
			option.innerHTML = name;
			drop.appendChild(option);
		}
		drop.addEventListener('change', function() {
			Signal.sendMessage(drop.elm_handler(drop.elm_values[drop.selectedIndex]._1));
		});

		return drop;
	}

	function updateDropDown(node, oldModel, newModel)
	{
		node.elm_values = List.toArray(newModel.values);
		node.elm_handler = newModel.handler;

		var values = node.elm_values;
		var kids = node.childNodes;
		var kidsLength = kids.length;

		var i = 0;
		for (; i < kidsLength && i < values.length; ++i)
		{
			var option = kids[i];
			var name = values[i]._0;
			option.value = name;
			option.innerHTML = name;
		}
		for (; i < kidsLength; ++i)
		{
			node.removeChild(node.lastChild);
		}
		for (; i < values.length; ++i)
		{
			var option = Element.createNode('option');
			var name = values[i]._0;
			option.value = name;
			option.innerHTML = name;
			node.appendChild(option);
		}
		return node;
	}

	function dropDown(handler, values)
	{
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

	function renderButton(model)
	{
		var node = Element.createNode('button');
		node.style.display = 'block';
		node.style.pointerEvents = 'auto';
		node.elm_message = model.message;
		function click()
		{
			Signal.sendMessage(node.elm_message);
		}
		node.addEventListener('click', click);
		node.innerHTML = model.text;
		return node;
	}

	function updateButton(node, oldModel, newModel)
	{
		node.elm_message = newModel.message;
		var txt = newModel.text;
		if (oldModel.text !== txt)
		{
			node.innerHTML = txt;
		}
		return node;
	}

	function button(message, text)
	{
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

	function renderCustomButton(model)
	{
		var btn = Element.createNode('div');
		btn.style.pointerEvents = 'auto';
		btn.elm_message = model.message;

		btn.elm_up    = Element.render(model.up);
		btn.elm_hover = Element.render(model.hover);
		btn.elm_down  = Element.render(model.down);

		btn.elm_up.style.display = 'block';
		btn.elm_hover.style.display = 'none';
		btn.elm_down.style.display = 'none';

		btn.appendChild(btn.elm_up);
		btn.appendChild(btn.elm_hover);
		btn.appendChild(btn.elm_down);

		function swap(visibleNode, hiddenNode1, hiddenNode2)
		{
			visibleNode.style.display = 'block';
			hiddenNode1.style.display = 'none';
			hiddenNode2.style.display = 'none';
		}

		var overCount = 0;
		function over(e)
		{
			if (overCount++ > 0) return;
			swap(btn.elm_hover, btn.elm_down, btn.elm_up);
		}
		function out(e)
		{
			if (btn.contains(e.toElement || e.relatedTarget)) return;
			overCount = 0;
			swap(btn.elm_up, btn.elm_down, btn.elm_hover);
		}
		function up()
		{
			swap(btn.elm_hover, btn.elm_down, btn.elm_up);
			Signal.sendMessage(btn.elm_message);
		}
		function down()
		{
			swap(btn.elm_down, btn.elm_hover, btn.elm_up);
		}

		btn.addEventListener('mouseover', over);
		btn.addEventListener('mouseout' , out);
		btn.addEventListener('mousedown', down);
		btn.addEventListener('mouseup'  , up);

		return btn;
	}

	function updateCustomButton(node, oldModel, newModel)
	{
		node.elm_message = newModel.message;

		var kids = node.childNodes;
		var styleUp    = kids[0].style.display;
		var styleHover = kids[1].style.display;
		var styleDown  = kids[2].style.display;

		Element.updateAndReplace(kids[0], oldModel.up, newModel.up);
		Element.updateAndReplace(kids[1], oldModel.hover, newModel.hover);
		Element.updateAndReplace(kids[2], oldModel.down, newModel.down);

		var kids = node.childNodes;
		kids[0].style.display = styleUp;
		kids[1].style.display = styleHover;
		kids[2].style.display = styleDown;

		return node;
	}

	function max3(a,b,c)
	{
		var ab = a > b ? a : b;
		return ab > c ? ab : c;
	}

	function customButton(message, up, hover, down)
	{
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

	function renderCheckbox(model)
	{
		var node = Element.createNode('input');
		node.type = 'checkbox';
		node.checked = model.checked;
		node.style.display = 'block';
		node.style.pointerEvents = 'auto';
		node.elm_handler = model.handler;
		function change()
		{
			Signal.sendMessage(node.elm_handler(node.checked));
		}
		node.addEventListener('change', change);
		return node;
	}

	function updateCheckbox(node, oldModel, newModel)
	{
		node.elm_handler = newModel.handler;
		node.checked = newModel.checked;
		return node;
	}

	function checkbox(handler, checked)
	{
		return A3(Element.newElement, 13, 13, {
			ctor: 'Custom',
			type: 'CheckBox',
			render: renderCheckbox,
			update: updateCheckbox,
			model: { handler:handler, checked:checked }
		});
	}

	function setRange(node, start, end, dir)
	{
		if (node.parentNode)
		{
			node.setSelectionRange(start, end, dir);
		}
		else
		{
			setTimeout(function(){node.setSelectionRange(start, end, dir);}, 0);
		}
	}

	function updateIfNeeded(css, attribute, latestAttribute)
	{
		if (css[attribute] !== latestAttribute)
		{
			css[attribute] = latestAttribute;
		}
	}
	function cssDimensions(dimensions)
	{
		return dimensions.top    + 'px ' +
			   dimensions.right  + 'px ' +
			   dimensions.bottom + 'px ' +
			   dimensions.left   + 'px';
	}
	function updateFieldStyle(css, style)
	{
		updateIfNeeded(css, 'padding', cssDimensions(style.padding));

		var outline = style.outline;
		updateIfNeeded(css, 'border-width', cssDimensions(outline.width));
		updateIfNeeded(css, 'border-color', Color.toCss(outline.color));
		updateIfNeeded(css, 'border-radius', outline.radius + 'px');

		var highlight = style.highlight;
		if (highlight.width === 0)
		{
			css.outline = 'none';
		}
		else
		{
			updateIfNeeded(css, 'outline-width', highlight.width + 'px');
			updateIfNeeded(css, 'outline-color', Color.toCss(highlight.color));
		}

		var textStyle = style.style;
		updateIfNeeded(css, 'color', Color.toCss(textStyle.color));
		if (textStyle.typeface.ctor !== '[]')
		{
			updateIfNeeded(css, 'font-family', Text.toTypefaces(textStyle.typeface));
		}
		if (textStyle.height.ctor !== "Nothing")
		{
			updateIfNeeded(css, 'font-size', textStyle.height._0 + 'px');
		}
		updateIfNeeded(css, 'font-weight', textStyle.bold ? 'bold' : 'normal');
		updateIfNeeded(css, 'font-style', textStyle.italic ? 'italic' : 'normal');
		if (textStyle.line.ctor !== 'Nothing')
		{
			updateIfNeeded(css, 'text-decoration', Text.toLine(textStyle.line._0));
		}
	}

	function renderField(model)
	{
		var field = Element.createNode('input');
		updateFieldStyle(field.style, model.style);
		field.style.borderStyle = 'solid';
		field.style.pointerEvents = 'auto';

		field.type = model.type;
		field.placeholder = model.placeHolder;
		field.value = model.content.string;

		field.elm_handler = model.handler;
		field.elm_old_value = field.value;

		function inputUpdate(event)
		{
			var curr = field.elm_old_value;
			var next = field.value;
			if (curr === next)
			{
				return;
			}

			var direction = field.selectionDirection === 'forward' ? 'Forward' : 'Backward';
			var start = field.selectionStart;
			var end = field.selectionEnd;
			field.value = field.elm_old_value;

			Signal.sendMessage(field.elm_handler({
				_:{},
				string: next,
				selection: {
					_:{},
					start: start,
					end: end,
					direction: { ctor: direction }
				}
			}));
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

	function updateField(field, oldModel, newModel)
	{
		if (oldModel.style !== newModel.style)
		{
			updateFieldStyle(field.style, newModel.style);
		}
		field.elm_handler = newModel.handler;

		field.type = newModel.type;
		field.placeholder = newModel.placeHolder;
		var value = newModel.content.string;
		field.value = value;
		field.elm_old_value = value;
		if (field.elm_hasFocus)
		{
			var selection = newModel.content.selection;
			var direction = selection.direction.ctor === 'Forward' ? 'forward' : 'backward';
			setRange(field, selection.start, selection.end, direction);
		}
		return field;
	}

	function mkField(type)
	{
		function field(style, handler, placeHolder, content)
		{
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

	function hoverable(handler, elem)
	{
		function onHover(bool)
		{
			Signal.sendMessage(handler(bool));
		}
		var props = Utils.replace([['hover',onHover]], elem.props);
		return {
			props: props,
			element: elem.element
		};
	}

	function clickable(message, elem)
	{
		function onClick()
		{
			Signal.sendMessage(message);
		}
		var props = Utils.replace([['click',onClick]], elem.props);
		return {
			props: props,
			element: elem.element
		};
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

Elm.Native.Http = {};
Elm.Native.Http.make = function(localRuntime) {

	localRuntime.Native = localRuntime.Native || {};
	localRuntime.Native.Http = localRuntime.Native.Http || {};
	if (localRuntime.Native.Http.values)
	{
		return localRuntime.Native.Http.values;
	}

	var Dict = Elm.Dict.make(localRuntime);
	var List = Elm.List.make(localRuntime);
	var Maybe = Elm.Maybe.make(localRuntime);
	var Task = Elm.Native.Task.make(localRuntime);


	function send(settings, request)
	{
		return Task.asyncFunction(function(callback) {
			var req = new XMLHttpRequest();

			// start
			if (settings.onStart.ctor === 'Just')
			{
				req.addEventListener('loadStart', function() {
					var task = settings.onStart._0;
					Task.spawn(task);
				});
			}

			// progress
			if (settings.onProgress.ctor === 'Just')
			{
				req.addEventListener('progress', function(event) {
					var progress = !event.lengthComputable
						? Maybe.Nothing
						: Maybe.Just({
							_: {},
							loaded: event.loaded,
							total: event.total
						});
					var task = settings.onProgress._0(progress);
					Task.spawn(task);
				});
			}

			// end
			req.addEventListener('error', function() {
				return callback(Task.fail({ ctor: 'RawNetworkError' }));
			});

			req.addEventListener('timeout', function() {
				return callback(Task.fail({ ctor: 'RawTimeout' }));
			});

			req.addEventListener('load', function() {
				return callback(Task.succeed(toResponse(req)));
			});

			req.open(request.verb, request.url, true);

			// set all the headers
			function setHeader(pair) {
				req.setRequestHeader(pair._0, pair._1);
			}
			A2(List.map, setHeader, request.headers);

			// set the timeout
			req.timeout = settings.timeout;

			// ask for a specific MIME type for the response
			if (settings.desiredResponseType.ctor === 'Just')
			{
				req.overrideMimeType(settings.desiredResponseType._0);
			}

			req.send(request.body._0);
		});
	}


	// deal with responses

	function toResponse(req)
	{
		var tag = typeof req.response === 'string' ? 'Text' : 'Blob';
		return {
			_: {},
			status: req.status,
			statusText: req.statusText,
			headers: parseHeaders(req.getAllResponseHeaders()),
			url: req.responseURL,
			value: { ctor: tag, _0: req.response }
		};
	}


	function parseHeaders(rawHeaders)
	{
		var headers = Dict.empty;

		if (!rawHeaders)
		{
			return headers;
		}

		var headerPairs = rawHeaders.split('\u000d\u000a');
		for (var i = headerPairs.length; i--; )
		{
			var headerPair = headerPairs[i];
			var index = headerPair.indexOf('\u003a\u0020');
			if (index > 0)
			{
				var key = headerPair.substring(0, index);
				var value = headerPair.substring(index + 2);

				headers = A3(Dict.update, key, function(oldValue) {
					if (oldValue.ctor === 'Just')
					{
						return Maybe.Just(value + ', ' + oldValue._0);
					}
					return Maybe.Just(value);
				}, headers);
			}
		}

		return headers;
	}


	function multipart(dataList)
	{
		var formData = new FormData();

		while (dataList.ctor !== '[]')
		{
			var data = dataList._0;
			if (type === 'StringData')
			{
				formData.append(data._0, data._1);
			}
			else
			{
				var fileName = data._1.ctor === 'Nothing'
					? undefined
					: data._1._0;
				formData.append(data._0, data._2, fileName);
			}
			dataList = dataList._1;
		}

		return { ctor: 'FormData', formData: formData };
	}


	function uriEncode(string)
	{
		return encodeURIComponent(string);
	}

	function uriDecode(string)
	{
		return decodeURIComponent(string);
	}

	return localRuntime.Native.Http.values = {
		send: F2(send),
		multipart: multipart,
		uriEncode: uriEncode,
		uriDecode: uriDecode
	};
};

Elm.Native.Json = {};
Elm.Native.Json.make = function(localRuntime) {

	localRuntime.Native = localRuntime.Native || {};
	localRuntime.Native.Json = localRuntime.Native.Json || {};
	if (localRuntime.Native.Json.values) {
		return localRuntime.Native.Json.values;
	}

	var ElmArray = Elm.Native.Array.make(localRuntime);
	var List = Elm.Native.List.make(localRuntime);
	var Maybe = Elm.Maybe.make(localRuntime);
	var Result = Elm.Result.make(localRuntime);
	var Utils = Elm.Native.Utils.make(localRuntime);


	function crash(expected, actual) {
		throw new Error(
			'expecting ' + expected + ' but got ' + JSON.stringify(actual)
		);
	}


	// PRIMITIVE VALUES

	function decodeNull(successValue) {
		return function(value) {
			if (value === null) {
				return successValue;
			}
			crash('null', value);
		};
	}


	function decodeString(value) {
		if (typeof value === 'string' || value instanceof String) {
			return value;
		}
		crash('a String', value);
	}


	function decodeFloat(value) {
		if (typeof value === 'number') {
			return value;
		}
		crash('a Float', value);
	}


	function decodeInt(value) {
		if (typeof value === 'number' && (value|0) === value) {
			return value;
		}
		crash('an Int', value);
	}


	function decodeBool(value) {
		if (typeof value === 'boolean') {
			return value;
		}
		crash('a Bool', value);
	}


	// ARRAY

	function decodeArray(decoder) {
		return function(value) {
			if (value instanceof Array) {
				var len = value.length;
				var array = new Array(len);
				for (var i = len; i-- ; ) {
					array[i] = decoder(value[i]);
				}
				return ElmArray.fromJSArray(array);
			}
			crash('an Array', value);
		};
	}


	// LIST

	function decodeList(decoder) {
		return function(value) {
			if (value instanceof Array) {
				var len = value.length;
				var list = List.Nil;
				for (var i = len; i-- ; ) {
					list = List.Cons( decoder(value[i]), list );
				}
				return list;
			}
			crash('a List', value);
		};
	}


	// MAYBE

	function decodeMaybe(decoder) {
		return function(value) {
			try {
				return Maybe.Just(decoder(value));
			} catch(e) {
				return Maybe.Nothing;
			}
		};
	}


	// FIELDS

	function decodeField(field, decoder) {
		return function(value) {
			var subValue = value[field];
			if (subValue !== undefined) {
				return decoder(subValue);
			}
			crash("an object with field '" + field + "'", value);
		};
	}


	// OBJECTS

	function decodeKeyValuePairs(decoder) {
		return function(value) {
			var isObject =
				typeof value === 'object'
					&& value !== null
					&& !(value instanceof Array);

			if (isObject) {
				var keyValuePairs = List.Nil;
				for (var key in value) {
					var elmValue = decoder(value[key]);
					var pair = Utils.Tuple2(key, elmValue);
					keyValuePairs = List.Cons(pair, keyValuePairs);
				}
				return keyValuePairs;
			}

			crash("an object", value);
		};
	}

	function decodeObject1(f, d1) {
		return function(value) {
			return f(d1(value));
		};
	}

	function decodeObject2(f, d1, d2) {
		return function(value) {
			return A2( f, d1(value), d2(value) );
		};
	}

	function decodeObject3(f, d1, d2, d3) {
		return function(value) {
			return A3( f, d1(value), d2(value), d3(value) );
		};
	}

	function decodeObject4(f, d1, d2, d3, d4) {
		return function(value) {
			return A4( f, d1(value), d2(value), d3(value), d4(value) );
		};
	}

	function decodeObject5(f, d1, d2, d3, d4, d5) {
		return function(value) {
			return A5( f, d1(value), d2(value), d3(value), d4(value), d5(value) );
		};
	}

	function decodeObject6(f, d1, d2, d3, d4, d5, d6) {
		return function(value) {
			return A6( f,
				d1(value),
				d2(value),
				d3(value),
				d4(value),
				d5(value),
				d6(value)
			);
		};
	}

	function decodeObject7(f, d1, d2, d3, d4, d5, d6, d7) {
		return function(value) {
			return A7( f,
				d1(value),
				d2(value),
				d3(value),
				d4(value),
				d5(value),
				d6(value),
				d7(value)
			);
		};
	}

	function decodeObject8(f, d1, d2, d3, d4, d5, d6, d7, d8) {
		return function(value) {
			return A8( f,
				d1(value),
				d2(value),
				d3(value),
				d4(value),
				d5(value),
				d6(value),
				d7(value),
				d8(value)
			);
		};
	}


	// TUPLES

	function decodeTuple1(f, d1) {
		return function(value) {
			if ( !(value instanceof Array) || value.length !== 1 ) {
				crash('a Tuple of length 1', value);
			}
			return f( d1(value[0]) );
		};
	}

	function decodeTuple2(f, d1, d2) {
		return function(value) {
			if ( !(value instanceof Array) || value.length !== 2 ) {
				crash('a Tuple of length 2', value);
			}
			return A2( f, d1(value[0]), d2(value[1]) );
		};
	}

	function decodeTuple3(f, d1, d2, d3) {
		return function(value) {
			if ( !(value instanceof Array) || value.length !== 3 ) {
				crash('a Tuple of length 3', value);
			}
			return A3( f, d1(value[0]), d2(value[1]), d3(value[2]) );
		};
	}


	function decodeTuple4(f, d1, d2, d3, d4) {
		return function(value) {
			if ( !(value instanceof Array) || value.length !== 4 ) {
				crash('a Tuple of length 4', value);
			}
			return A4( f, d1(value[0]), d2(value[1]), d3(value[2]), d4(value[3]) );
		};
	}


	function decodeTuple5(f, d1, d2, d3, d4, d5) {
		return function(value) {
			if ( !(value instanceof Array) || value.length !== 5 ) {
				crash('a Tuple of length 5', value);
			}
			return A5( f,
				d1(value[0]),
				d2(value[1]),
				d3(value[2]),
				d4(value[3]),
				d5(value[4])
			);
		};
	}


	function decodeTuple6(f, d1, d2, d3, d4, d5, d6) {
		return function(value) {
			if ( !(value instanceof Array) || value.length !== 6 ) {
				crash('a Tuple of length 6', value);
			}
			return A6( f,
				d1(value[0]),
				d2(value[1]),
				d3(value[2]),
				d4(value[3]),
				d5(value[4]),
				d6(value[5])
			);
		};
	}

	function decodeTuple7(f, d1, d2, d3, d4, d5, d6, d7) {
		return function(value) {
			if ( !(value instanceof Array) || value.length !== 7 ) {
				crash('a Tuple of length 7', value);
			}
			return A7( f,
				d1(value[0]),
				d2(value[1]),
				d3(value[2]),
				d4(value[3]),
				d5(value[4]),
				d6(value[5]),
				d7(value[6])
			);
		};
	}


	function decodeTuple8(f, d1, d2, d3, d4, d5, d6, d7, d8) {
		return function(value) {
			if ( !(value instanceof Array) || value.length !== 8 ) {
				crash('a Tuple of length 8', value);
			}
			return A8( f,
				d1(value[0]),
				d2(value[1]),
				d3(value[2]),
				d4(value[3]),
				d5(value[4]),
				d6(value[5]),
				d7(value[6]),
				d8(value[7])
			);
		};
	}


	// CUSTOM DECODERS

	function decodeValue(value) {
		return value;
	}

	function runDecoderValue(decoder, value) {
		try {
			return Result.Ok(decoder(value));
		} catch(e) {
			return Result.Err(e.message);
		}
	}

	function customDecoder(decoder, callback) {
		return function(value) {
			var result = callback(decoder(value));
			if (result.ctor === 'Err') {
				throw new Error('custom decoder failed: ' + result._0);
			}
			return result._0;
		}
	}

	function andThen(decode, callback) {
		return function(value) {
			var result = decode(value);
			return callback(result)(value);
		}
	}

	function fail(msg) {
		return function(value) {
			throw new Error(msg);
		}
	}

	function succeed(successValue) {
		return function(value) {
			return successValue;
		}
	}


	// ONE OF MANY

	function oneOf(decoders) {
		return function(value) {
			var errors = [];
			var temp = decoders;
			while (temp.ctor !== '[]') {
				try {
					return temp._0(value);
				} catch(e) {
					errors.push(e.message);
				}
				temp = temp._1;
			}
			throw new Error('expecting one of the following:\n    ' + errors.join('\n    '));
		}
	}

	function get(decoder, value) {
		try {
			return Result.Ok(decoder(value));
		} catch(e) {
			return Result.Err(e.message);
		}
	}


	// ENCODE / DECODE

	function runDecoderString(decoder, string) {
		try {
			return Result.Ok(decoder(JSON.parse(string)));
		} catch(e) {
			return Result.Err(e.message);
		}
	}

	function encode(indentLevel, value) {
		return JSON.stringify(value, null, indentLevel);
	}

	function identity(value) {
		return value;
	}

	function encodeObject(keyValuePairs) {
		var obj = {};
		while (keyValuePairs.ctor !== '[]') {
			var pair = keyValuePairs._0;
			obj[pair._0] = pair._1;
			keyValuePairs = keyValuePairs._1;
		}
		return obj;
	}

	return localRuntime.Native.Json.values = {
		encode: F2(encode),
		runDecoderString: F2(runDecoderString),
		runDecoderValue: F2(runDecoderValue),

		get: F2(get),
		oneOf: oneOf,

		decodeNull: decodeNull,
		decodeInt: decodeInt,
		decodeFloat: decodeFloat,
		decodeString: decodeString,
		decodeBool: decodeBool,

		decodeMaybe: decodeMaybe,

		decodeList: decodeList,
		decodeArray: decodeArray,

		decodeField: F2(decodeField),

		decodeObject1: F2(decodeObject1),
		decodeObject2: F3(decodeObject2),
		decodeObject3: F4(decodeObject3),
		decodeObject4: F5(decodeObject4),
		decodeObject5: F6(decodeObject5),
		decodeObject6: F7(decodeObject6),
		decodeObject7: F8(decodeObject7),
		decodeObject8: F9(decodeObject8),
		decodeKeyValuePairs: decodeKeyValuePairs,

		decodeTuple1: F2(decodeTuple1),
		decodeTuple2: F3(decodeTuple2),
		decodeTuple3: F4(decodeTuple3),
		decodeTuple4: F5(decodeTuple4),
		decodeTuple5: F6(decodeTuple5),
		decodeTuple6: F7(decodeTuple6),
		decodeTuple7: F8(decodeTuple7),
		decodeTuple8: F9(decodeTuple8),

		andThen: F2(andThen),
		decodeValue: decodeValue,
		customDecoder: F2(customDecoder),
		fail: fail,
		succeed: succeed,

		identity: identity,
		encodeNull: null,
		encodeArray: ElmArray.toJSArray,
		encodeList: List.toArray,
		encodeObject: encodeObject

	};

};

Elm.Native.Keyboard = {};
Elm.Native.Keyboard.make = function(localRuntime) {

	localRuntime.Native = localRuntime.Native || {};
	localRuntime.Native.Keyboard = localRuntime.Native.Keyboard || {};
	if (localRuntime.Native.Keyboard.values)
	{
		return localRuntime.Native.Keyboard.values;
	}

	var NS = Elm.Native.Signal.make(localRuntime);


	function keyEvent(event)
	{
		return {
			_: {},
			alt: event.altKey,
			meta: event.metaKey,
			keyCode: event.keyCode
		};
	}


	function keyStream(node, eventName, handler)
	{
		var stream = NS.input(eventName, '\0');

		localRuntime.addListener([stream.id], node, eventName, function(e) {
			localRuntime.notify(stream.id, handler(e));
		});

		return stream;
	}

	var downs = keyStream(document, 'keydown', keyEvent);
	var ups = keyStream(document, 'keyup', keyEvent);
	var presses = keyStream(document, 'keypress', keyEvent);
	var blurs = keyStream(window, 'blur', function() { return null; });


	return localRuntime.Native.Keyboard.values = {
		downs: downs,
		ups: ups,
		blurs: blurs,
		presses: presses
	};

};

Elm.Native.List = {};
Elm.Native.List.make = function(localRuntime) {
	localRuntime.Native = localRuntime.Native || {};
	localRuntime.Native.List = localRuntime.Native.List || {};
	if (localRuntime.Native.List.values)
	{
		return localRuntime.Native.List.values;
	}
	if ('values' in Elm.Native.List)
	{
		return localRuntime.Native.List.values = Elm.Native.List.values;
	}

	var Utils = Elm.Native.Utils.make(localRuntime);

	var Nil = Utils.Nil;
	var Cons = Utils.Cons;

	function toArray(xs)
	{
		var out = [];
		while (xs.ctor !== '[]')
		{
			out.push(xs._0);
			xs = xs._1;
		}
		return out;
	}

	function fromArray(arr)
	{
		var out = Nil;
		for (var i = arr.length; i--; )
		{
			out = Cons(arr[i], out);
		}
		return out;
	}

	function range(lo,hi)
	{
		var lst = Nil;
		if (lo <= hi)
		{
			do { lst = Cons(hi,lst) } while (hi-->lo);
		}
		return lst
	}

	// f defined similarly for both foldl and foldr (NB: different from Haskell)
	// ie, foldl : (a -> b -> b) -> b -> [a] -> b
	function foldl(f, b, xs)
	{
		var acc = b;
		while (xs.ctor !== '[]')
		{
			acc = A2(f, xs._0, acc);
			xs = xs._1;
		}
		return acc;
	}

	function foldr(f, b, xs)
	{
		var arr = toArray(xs);
		var acc = b;
		for (var i = arr.length; i--; )
		{
			acc = A2(f, arr[i], acc);
		}
		return acc;
	}

	function any(pred, xs)
	{
		while (xs.ctor !== '[]')
		{
			if (pred(xs._0))
			{
				return true;
			}
			xs = xs._1;
		}
		return false;
	}

	function map2(f, xs, ys)
	{
		var arr = [];
		while (xs.ctor !== '[]' && ys.ctor !== '[]')
		{
			arr.push(A2(f, xs._0, ys._0));
			xs = xs._1;
			ys = ys._1;
		}
		return fromArray(arr);
	}

	function map3(f, xs, ys, zs)
	{
		var arr = [];
		while (xs.ctor !== '[]' && ys.ctor !== '[]' && zs.ctor !== '[]')
		{
			arr.push(A3(f, xs._0, ys._0, zs._0));
			xs = xs._1;
			ys = ys._1;
			zs = zs._1;
		}
		return fromArray(arr);
	}

	function map4(f, ws, xs, ys, zs)
	{
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

	function map5(f, vs, ws, xs, ys, zs)
	{
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

	function sortBy(f, xs)
	{
		return fromArray(toArray(xs).sort(function(a,b){
			return Utils.cmp(f(a), f(b));
		}));
	}

	function sortWith(f, xs)
	{
		return fromArray(toArray(xs).sort(function(a,b){
			var ord = f(a)(b).ctor;
			return ord === 'EQ' ? 0 : ord === 'LT' ? -1 : 1;
		}));
	}

	function take(n, xs)
	{
		var arr = [];
		while (xs.ctor !== '[]' && n > 0)
		{
			arr.push(xs._0);
			xs = xs._1;
			--n;
		}
		return fromArray(arr);
	}

	function drop(n, xs)
	{
		while (xs.ctor !== '[]' && n > 0)
		{
			xs = xs._1;
			--n;
		}
		return xs;
	}

	function repeat(n, x)
	{
		var arr = [];
		var pattern = [x];
		while (n > 0)
		{
			if (n & 1)
			{
				arr = arr.concat(pattern);
			}
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

		foldl:F3(foldl),
		foldr:F3(foldr),

		any:F2(any),
		map2:F3(map2),
		map3:F4(map3),
		map4:F5(map4),
		map5:F6(map5),
		sortBy:F2(sortBy),
		sortWith:F2(sortWith),
		take:F2(take),
		drop:F2(drop),
		repeat:F2(repeat)
	};
	return localRuntime.Native.List.values = Elm.Native.List.values;

};

Elm.Native.Port = {};
Elm.Native.Port.make = function(localRuntime) {

	localRuntime.Native = localRuntime.Native || {};
	localRuntime.Native.Port = localRuntime.Native.Port || {};
	if (localRuntime.Native.Port.values)
	{
		return localRuntime.Native.Port.values;
	}

	var NS;
	var Utils = Elm.Native.Utils.make(localRuntime);


	// INBOUND

	function inbound(name, type, converter)
	{
		if (!localRuntime.argsTracker[name])
		{
			throw new Error(
				"Port Error:\n" +
				"No argument was given for the port named '" + name + "' with type:\n\n" +
				"    " + type.split('\n').join('\n        ') + "\n\n" +
				"You need to provide an initial value!\n\n" +
				"Find out more about ports here <http://elm-lang.org/learn/Ports.elm>"
			);
		}
		var arg = localRuntime.argsTracker[name];
		arg.used = true;

		return jsToElm(name, type, converter, arg.value);
	}


	function inboundSignal(name, type, converter)
	{
		var initialValue = inbound(name, type, converter);

		if (!NS)
		{
			NS = Elm.Native.Signal.make(localRuntime);
		}
		var signal = NS.input('inbound-port-' + name, initialValue);

		function send(jsValue)
		{
			var elmValue = jsToElm(name, type, converter, jsValue);
			setTimeout(function() {
				localRuntime.notify(signal.id, elmValue);
			}, 0);
		}

		localRuntime.ports[name] = { send: send };

		return signal;
	}


	function jsToElm(name, type, converter, value)
	{
		try
		{
			return converter(value);
		}
		catch(e)
		{
			throw new Error(
				"Port Error:\n" +
				"Regarding the port named '" + name + "' with type:\n\n" +
				"    " + type.split('\n').join('\n        ') + "\n\n" +
				"You just sent the value:\n\n" +
				"    " + JSON.stringify(value) + "\n\n" +
				"but it cannot be converted to the necessary type.\n" +
				e.message
			);
		}
	}


	// OUTBOUND

	function outbound(name, converter, elmValue)
	{
		localRuntime.ports[name] = converter(elmValue);
	}


	function outboundSignal(name, converter, signal)
	{
		var subscribers = [];

		function subscribe(handler)
		{
			subscribers.push(handler);
		}
		function unsubscribe(handler)
		{
			subscribers.pop(subscribers.indexOf(handler));
		}

		function notify(elmValue)
		{
			var jsValue = converter(elmValue);
			var len = subscribers.length;
			for (var i = 0; i < len; ++i)
			{
				subscribers[i](jsValue);
			}
		}

		if (!NS)
		{
			NS = Elm.Native.Signal.make(localRuntime);
		}
		NS.output('outbound-port-' + name, notify, signal);

		localRuntime.ports[name] = {
			subscribe: subscribe,
			unsubscribe: unsubscribe
		};

		return signal;
	}


	return localRuntime.Native.Port.values = {
		inbound: inbound,
		outbound: outbound,
		inboundSignal: inboundSignal,
		outboundSignal: outboundSignal
	};
};


if (!Elm.fullscreen) {

	(function() {
		'use strict';

		var Display = {
			FULLSCREEN: 0,
			COMPONENT: 1,
			NONE: 2
		};

		Elm.fullscreen = function(module, args)
		{
			var container = document.createElement('div');
			document.body.appendChild(container);
			return init(Display.FULLSCREEN, container, module, args || {});
		};

		Elm.embed = function(module, container, args)
		{
			var tag = container.tagName;
			if (tag !== 'DIV')
			{
				throw new Error('Elm.node must be given a DIV, not a ' + tag + '.');
			}
			return init(Display.COMPONENT, container, module, args || {});
		};

		Elm.worker = function(module, args)
		{
			return init(Display.NONE, {}, module, args || {});
		};

		function init(display, container, module, args, moduleToReplace)
		{
			// defining state needed for an instance of the Elm RTS
			var inputs = [];

			/* OFFSET
			 * Elm's time traveling debugger lets you pause time. This means
			 * "now" may be shifted a bit into the past. By wrapping Date.now()
			 * we can manage this.
			 */
			var timer = {
				programStart: Date.now(),
				now: function()
				{
					return Date.now();
				}
			};

			var updateInProgress = false;
			function notify(id, v)
			{
				if (updateInProgress)
				{
					throw new Error(
						'The notify function has been called synchronously!\n' +
						'This can lead to frames being dropped.\n' +
						'Definitely report this to <https://github.com/elm-lang/Elm/issues>\n');
				}
				updateInProgress = true;
				var timestep = timer.now();
				for (var i = inputs.length; i--; )
				{
					inputs[i].notify(timestep, id, v);
				}
				updateInProgress = false;
			}
			function setTimeout(func, delay)
			{
				return window.setTimeout(func, delay);
			}

			var listeners = [];
			function addListener(relevantInputs, domNode, eventName, func)
			{
				domNode.addEventListener(eventName, func);
				var listener = {
					relevantInputs: relevantInputs,
					domNode: domNode,
					eventName: eventName,
					func: func
				};
				listeners.push(listener);
			}

			var argsTracker = {};
			for (var name in args)
			{
				argsTracker[name] = {
					value: args[name],
					used: false
				};
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
				argsTracker: argsTracker,
				ports: {},

				isFullscreen: function() { return display === Display.FULLSCREEN; },
				isEmbed: function() { return display === Display.COMPONENT; },
				isWorker: function() { return display === Display.NONE; }
			};

			function swap(newModule)
			{
				removeListeners(listeners);
				var div = document.createElement('div');
				var newElm = init(display, div, newModule, args, elm);
				inputs = [];
				// elm.swap = newElm.swap;
				return newElm;
			}

			function dispose()
			{
				removeListeners(listeners);
				inputs = [];
			}

			var Module = {};
			try
			{
				Module = module.make(elm);
				checkInputs(elm);
			}
			catch (error)
			{
				if (typeof container.appendChild == 'undefined')
				{
					console.log(error.message);
				}
				else
				{
					container.appendChild(errorNode(error.message));
				}
				throw error;
			}

			if (display !== Display.NONE)
			{
				var graphicsNode = initGraphics(elm, Module);
			}

			var rootNode = { kids: inputs };
			trimDeadNodes(rootNode);
			inputs = rootNode.kids;
			filterListeners(inputs, listeners);

			addReceivers(elm.ports);

			if (typeof moduleToReplace !== 'undefined')
			{
				hotSwap(moduleToReplace, elm);

				// rerender scene if graphics are enabled.
				if (typeof graphicsNode !== 'undefined')
				{
					graphicsNode.notify(0, true, 0);
				}
			}

			return {
				swap: swap,
				ports: elm.ports,
				dispose: dispose
			};
		};

		function checkInputs(elm)
		{
			var argsTracker = elm.argsTracker;
			for (var name in argsTracker)
			{
				if (!argsTracker[name].used)
				{
					throw new Error(
						"Port Error:\nYou provided an argument named '" + name +
						"' but there is no corresponding port!\n\n" +
						"Maybe add a port '" + name + "' to your Elm module?\n" +
						"Maybe remove the '" + name + "' argument from your initialization code in JS?"
					);
				}
			}
		}

		function errorNode(message)
		{
			var code = document.createElement('code');

			var lines = message.split('\n');
			code.appendChild(document.createTextNode(lines[0]));
			code.appendChild(document.createElement('br'));
			code.appendChild(document.createElement('br'));
			for (var i = 1; i < lines.length; ++i)
			{
				code.appendChild(document.createTextNode('\u00A0 \u00A0 ' + lines[i].replace(/  /g, '\u00A0 ')));
				code.appendChild(document.createElement('br'));
			}
			code.appendChild(document.createElement('br'));
			code.appendChild(document.createTextNode("Open the developer console for more details."));
			return code;
		}


		//// FILTER SIGNALS ////

		// TODO: move this code into the signal module and create a function
		// Signal.initializeGraph that actually instantiates everything.

		function filterListeners(inputs, listeners)
		{
			loop:
			for (var i = listeners.length; i--; )
			{
				var listener = listeners[i];
				for (var j = inputs.length; j--; )
				{
					if (listener.relevantInputs.indexOf(inputs[j].id) >= 0)
					{
						continue loop;
					}
				}
				listener.domNode.removeEventListener(listener.eventName, listener.func);
			}
		}

		function removeListeners(listeners)
		{
			for (var i = listeners.length; i--; )
			{
				var listener = listeners[i];
				listener.domNode.removeEventListener(listener.eventName, listener.func);
			}
		}

		// add receivers for built-in ports if they are defined
		function addReceivers(ports)
		{
			if ('title' in ports)
			{
				if (typeof ports.title === 'string')
				{
					document.title = ports.title;
				}
				else
				{
					ports.title.subscribe(function(v) { document.title = v; });
				}
			}
			if ('redirect' in ports)
			{
				ports.redirect.subscribe(function(v) {
					if (v.length > 0)
					{
						window.location = v;
					}
				});
			}
		}


		// returns a boolean representing whether the node is alive or not.
		function trimDeadNodes(node)
		{
			if (node.isOutput)
			{
				return true;
			}

			var liveKids = [];
			for (var i = node.kids.length; i--; )
			{
				var kid = node.kids[i];
				if (trimDeadNodes(kid))
				{
					liveKids.push(kid);
				}
			}
			node.kids = liveKids;

			return liveKids.length > 0;
		}


		////  RENDERING  ////

		function initGraphics(elm, Module)
		{
			if (!('main' in Module))
			{
				throw new Error("'main' is missing! What do I display?!");
			}

			var signalGraph = Module.main;

			// make sure the signal graph is actually a signal & extract the visual model
			if (!('notify' in signalGraph))
			{
				signalGraph = Elm.Signal.make(elm).constant(signalGraph);
			}
			var initialScene = signalGraph.value;

			// Figure out what the render functions should be
			var render;
			var update;
			if (initialScene.props)
			{
				var Element = Elm.Native.Graphics.Element.make(elm);
				render = Element.render;
				update = Element.updateAndReplace;
			}
			else
			{
				var VirtualDom = Elm.Native.VirtualDom.make(elm);
				render = VirtualDom.render;
				update = VirtualDom.updateAndReplace;
			}

			// Add the initialScene to the DOM
			var container = elm.node;
			var node = render(initialScene);
			while (container.firstChild)
			{
				container.removeChild(container.firstChild);
			}
			container.appendChild(node);

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

			function domUpdate(newScene)
			{
				scheduledScene = newScene;

				switch (state)
				{
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

			function drawCallback()
			{
				switch (state)
				{
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

			function draw()
			{
				update(elm.node.firstChild, savedScene, scheduledScene);
				if (elm.Native.Window)
				{
					elm.Native.Window.values.resizeIfNeeded();
				}
				savedScene = scheduledScene;
			}

			var renderer = Elm.Native.Signal.make(elm).output('main', domUpdate, signalGraph);

			// must check for resize after 'renderer' is created so
			// that changes show up.
			if (elm.Native.Window)
			{
				elm.Native.Window.values.resizeIfNeeded();
			}

			return renderer;
		}

		//// HOT SWAPPING ////

		// Returns boolean indicating if the swap was successful.
		// Requires that the two signal graphs have exactly the same
		// structure.
		function hotSwap(from, to)
		{
			function similar(nodeOld,nodeNew)
			{
				if (nodeOld.id !== nodeNew.id)
				{
					return false;
				}
				if (nodeOld.isOutput)
				{
					return nodeNew.isOutput;
				}
				return nodeOld.kids.length === nodeNew.kids.length;
			}
			function swap(nodeOld,nodeNew)
			{
				nodeNew.value = nodeOld.value;
				return true;
			}
			var canSwap = depthFirstTraversals(similar, from.inputs, to.inputs);
			if (canSwap)
			{
				depthFirstTraversals(swap, from.inputs, to.inputs);
			}
			from.node.parentNode.replaceChild(to.node, from.node);

			return canSwap;
		}

		// Returns false if the node operation f ever fails.
		function depthFirstTraversals(f, queueOld, queueNew)
		{
			if (queueOld.length !== queueNew.length)
			{
				return false;
			}
			queueOld = queueOld.slice(0);
			queueNew = queueNew.slice(0);

			var seen = [];
			while (queueOld.length > 0 && queueNew.length > 0)
			{
				var nodeOld = queueOld.pop();
				var nodeNew = queueNew.pop();
				if (seen.indexOf(nodeOld.id) < 0)
				{
					if (!f(nodeOld, nodeNew))
					{
						return false;
					}
					queueOld = queueOld.concat(nodeOld.kids || []);
					queueNew = queueNew.concat(nodeNew.kids || []);
					seen.push(nodeOld.id);
				}
			}
			return true;
		}
	}());

	function F2(fun)
	{
		function wrapper(a) { return function(b) { return fun(a,b) } }
		wrapper.arity = 2;
		wrapper.func = fun;
		return wrapper;
	}

	function F3(fun)
	{
		function wrapper(a) {
			return function(b) { return function(c) { return fun(a,b,c) }}
		}
		wrapper.arity = 3;
		wrapper.func = fun;
		return wrapper;
	}

	function F4(fun)
	{
		function wrapper(a) { return function(b) { return function(c) {
			return function(d) { return fun(a,b,c,d) }}}
		}
		wrapper.arity = 4;
		wrapper.func = fun;
		return wrapper;
	}

	function F5(fun)
	{
		function wrapper(a) { return function(b) { return function(c) {
			return function(d) { return function(e) { return fun(a,b,c,d,e) }}}}
		}
		wrapper.arity = 5;
		wrapper.func = fun;
		return wrapper;
	}

	function F6(fun)
	{
		function wrapper(a) { return function(b) { return function(c) {
			return function(d) { return function(e) { return function(f) {
			return fun(a,b,c,d,e,f) }}}}}
		}
		wrapper.arity = 6;
		wrapper.func = fun;
		return wrapper;
	}

	function F7(fun)
	{
		function wrapper(a) { return function(b) { return function(c) {
			return function(d) { return function(e) { return function(f) {
			return function(g) { return fun(a,b,c,d,e,f,g) }}}}}}
		}
		wrapper.arity = 7;
		wrapper.func = fun;
		return wrapper;
	}

	function F8(fun)
	{
		function wrapper(a) { return function(b) { return function(c) {
			return function(d) { return function(e) { return function(f) {
			return function(g) { return function(h) {
			return fun(a,b,c,d,e,f,g,h)}}}}}}}
		}
		wrapper.arity = 8;
		wrapper.func = fun;
		return wrapper;
	}

	function F9(fun)
	{
		function wrapper(a) { return function(b) { return function(c) {
			return function(d) { return function(e) { return function(f) {
			return function(g) { return function(h) { return function(i) {
			return fun(a,b,c,d,e,f,g,h,i) }}}}}}}}
		}
		wrapper.arity = 9;
		wrapper.func = fun;
		return wrapper;
	}

	function A2(fun,a,b)
	{
		return fun.arity === 2
			? fun.func(a,b)
			: fun(a)(b);
	}
	function A3(fun,a,b,c)
	{
		return fun.arity === 3
			? fun.func(a,b,c)
			: fun(a)(b)(c);
	}
	function A4(fun,a,b,c,d)
	{
		return fun.arity === 4
			? fun.func(a,b,c,d)
			: fun(a)(b)(c)(d);
	}
	function A5(fun,a,b,c,d,e)
	{
		return fun.arity === 5
			? fun.func(a,b,c,d,e)
			: fun(a)(b)(c)(d)(e);
	}
	function A6(fun,a,b,c,d,e,f)
	{
		return fun.arity === 6
			? fun.func(a,b,c,d,e,f)
			: fun(a)(b)(c)(d)(e)(f);
	}
	function A7(fun,a,b,c,d,e,f,g)
	{
		return fun.arity === 7
			? fun.func(a,b,c,d,e,f,g)
			: fun(a)(b)(c)(d)(e)(f)(g);
	}
	function A8(fun,a,b,c,d,e,f,g,h)
	{
		return fun.arity === 8
			? fun.func(a,b,c,d,e,f,g,h)
			: fun(a)(b)(c)(d)(e)(f)(g)(h);
	}
	function A9(fun,a,b,c,d,e,f,g,h,i)
	{
		return fun.arity === 9
			? fun.func(a,b,c,d,e,f,g,h,i)
			: fun(a)(b)(c)(d)(e)(f)(g)(h)(i);
	}
}

Elm.Native.Show = {};
Elm.Native.Show.make = function(localRuntime) {
	localRuntime.Native = localRuntime.Native || {};
	localRuntime.Native.Show = localRuntime.Native.Show || {};
	if (localRuntime.Native.Show.values)
	{
		return localRuntime.Native.Show.values;
	}

	var _Array;
	var Dict;
	var List;
	var Utils = Elm.Native.Utils.make(localRuntime);

	var toString = function(v)
	{
		var type = typeof v;
		if (type === "function")
		{
			var name = v.func ? v.func.name : v.name;
			return '<function' + (name === '' ? '' : ': ') + name + '>';
		}
		else if (type === "boolean")
		{
			return v ? "True" : "False";
		}
		else if (type === "number")
		{
			return v + "";
		}
		else if ((v instanceof String) && v.isChar)
		{
			return "'" + addSlashes(v, true) + "'";
		}
		else if (type === "string")
		{
			return '"' + addSlashes(v, false) + '"';
		}
		else if (type === "object" && '_' in v && probablyPublic(v))
		{
			var output = [];
			for (var k in v._)
			{
				for (var i = v._[k].length; i--; )
				{
					output.push(k + " = " + toString(v._[k][i]));
				}
			}
			for (var k in v)
			{
				if (k === '_') continue;
				output.push(k + " = " + toString(v[k]));
			}
			if (output.length === 0)
			{
				return "{}";
			}
			return "{ " + output.join(", ") + " }";
		}
		else if (type === "object" && 'ctor' in v)
		{
			if (v.ctor.substring(0,6) === "_Tuple")
			{
				var output = [];
				for (var k in v)
				{
					if (k === 'ctor') continue;
					output.push(toString(v[k]));
				}
				return "(" + output.join(",") + ")";
			}
			else if (v.ctor === "_Array")
			{
				if (!_Array)
				{
					_Array = Elm.Array.make(localRuntime);
				}
				var list = _Array.toList(v);
				return "Array.fromList " + toString(list);
			}
			else if (v.ctor === "::")
			{
				var output = '[' + toString(v._0);
				v = v._1;
				while (v.ctor === "::")
				{
					output += "," + toString(v._0);
					v = v._1;
				}
				return output + ']';
			}
			else if (v.ctor === "[]")
			{
				return "[]";
			}
			else if (v.ctor === "RBNode" || v.ctor === "RBEmpty")
			{
				if (!Dict)
				{
					Dict = Elm.Dict.make(localRuntime);
				}
				if (!List)
				{
					List = Elm.List.make(localRuntime);
				}
				var list = Dict.toList(v);
				var name = "Dict";
				if (list.ctor === "::" && list._0._1.ctor === "_Tuple0")
				{
					name = "Set";
					list = A2(List.map, function(x){return x._0}, list);
				}
				return name + ".fromList " + toString(list);
			}
			else if (v.ctor.slice(0,5) === "Text:")
			{
				return '<text>'
			}
			else
			{
				var output = "";
				for (var i in v)
				{
					if (i === 'ctor') continue;
					var str = toString(v[i]);
					var parenless = str[0] === '{' || str[0] === '<' || str.indexOf(' ') < 0;
					output += ' ' + (parenless ? str : '(' + str + ')');
				}
				return v.ctor + output;
			}
		}
		if (type === 'object' && 'notify' in v && 'id' in v)
		{
			return '<Signal>';
		}
		return "<internal structure>";
	};

	function addSlashes(str, isChar)
	{
		var s = str.replace(/\\/g, '\\\\')
				  .replace(/\n/g, '\\n')
				  .replace(/\t/g, '\\t')
				  .replace(/\r/g, '\\r')
				  .replace(/\v/g, '\\v')
				  .replace(/\0/g, '\\0');
		if (isChar)
		{
			return s.replace(/\'/g, "\\'")
		}
		else
		{
			return s.replace(/\"/g, '\\"');
		}
	}

	function probablyPublic(v)
	{
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

	return localRuntime.Native.Show.values = {
		toString: toString
	};
};

Elm.Native.Signal = {};
Elm.Native.Signal.make = function(localRuntime) {

	localRuntime.Native = localRuntime.Native || {};
	localRuntime.Native.Signal = localRuntime.Native.Signal || {};
	if (localRuntime.Native.Signal.values)
	{
		return localRuntime.Native.Signal.values;
	}


	var Task = Elm.Native.Task.make(localRuntime);
	var Utils = Elm.Native.Utils.make(localRuntime);


	function broadcastToKids(node, timestamp, update)
	{
		var kids = node.kids;
		for (var i = kids.length; i--; )
		{
			kids[i].notify(timestamp, update, node.id);
		}
	}


	// INPUT

	function input(name, base)
	{
		var node = {
			id: Utils.guid(),
			name: 'input-' + name,
			value: base,
			parents: [],
			kids: []
		};

		node.notify = function(timestamp, targetId, value) {
			var update = targetId === node.id;
			if (update)
			{
				node.value = value;
			}
			broadcastToKids(node, timestamp, update);
			return update;
		};

		localRuntime.inputs.push(node);

		return node;
	}

	function constant(value)
	{
		return input('constant', value);
	}


	// MAILBOX

	function mailbox(base)
	{
		var signal = input('mailbox', base);

		function send(value) {
			return Task.asyncFunction(function(callback) {
				localRuntime.setTimeout(function() {
					localRuntime.notify(signal.id, value);
				}, 0);
				callback(Task.succeed(Utils.Tuple0));
			});
		}

		return {
			_: {},
			signal: signal,
			address: {
				ctor: 'Address',
				_0: send
			}
		};
	}

	function sendMessage(message)
	{
		Task.perform(message._0);
	}


	// OUTPUT

	function output(name, handler, parent)
	{
		var node = {
			id: Utils.guid(),
			name: 'output-' + name,
			parents: [parent],
			isOutput: true
		};

		node.notify = function(timestamp, parentUpdate, parentID)
		{
			if (parentUpdate)
			{
				handler(parent.value);
			}
		};

		parent.kids.push(node);

		return node;
	}


	// MAP

	function mapMany(refreshValue, args)
	{
		var node = {
			id: Utils.guid(),
			name: 'map' + args.length,
			value: refreshValue(),
			parents: args,
			kids: []
		};

		var numberOfParents = args.length;
		var count = 0;
		var update = false;

		node.notify = function(timestamp, parentUpdate, parentID)
		{
			++count;

			update = update || parentUpdate;

			if (count === numberOfParents)
			{
				if (update)
				{
					node.value = refreshValue();
				}
				broadcastToKids(node, timestamp, update);
				update = false;
				count = 0;
			}
		};

		for (var i = numberOfParents; i--; )
		{
			args[i].kids.push(node);
		}

		return node;
	}


	function map(func, a)
	{
		function refreshValue()
		{
			return func(a.value);
		}
		return mapMany(refreshValue, [a]);
	}


	function map2(func, a, b)
	{
		function refreshValue()
		{
			return A2( func, a.value, b.value );
		}
		return mapMany(refreshValue, [a,b]);
	}


	function map3(func, a, b, c)
	{
		function refreshValue()
		{
			return A3( func, a.value, b.value, c.value );
		}
		return mapMany(refreshValue, [a,b,c]);
	}


	function map4(func, a, b, c, d)
	{
		function refreshValue()
		{
			return A4( func, a.value, b.value, c.value, d.value );
		}
		return mapMany(refreshValue, [a,b,c,d]);
	}


	function map5(func, a, b, c, d, e)
	{
		function refreshValue()
		{
			return A5( func, a.value, b.value, c.value, d.value, e.value );
		}
		return mapMany(refreshValue, [a,b,c,d,e]);
	}



	// FOLD

	function foldp(update, state, signal)
	{
		var node = {
			id: Utils.guid(),
			name: 'foldp',
			parents: [signal],
			kids: [],
			value: state
		};

		node.notify = function(timestamp, parentUpdate, parentID)
		{
			if (parentUpdate)
			{
				node.value = A2( update, signal.value, node.value );
			}
			broadcastToKids(node, timestamp, parentUpdate);
		};

		signal.kids.push(node);

		return node;
	}


	// TIME

	function timestamp(signal)
	{
		var node = {
			id: Utils.guid(),
			name: 'timestamp',
			value: Utils.Tuple2(localRuntime.timer.programStart, signal.value),
			parents: [signal],
			kids: []
		};

		node.notify = function(timestamp, parentUpdate, parentID)
		{
			if (parentUpdate)
			{
				node.value = Utils.Tuple2(timestamp, signal.value);
			}
			broadcastToKids(node, timestamp, parentUpdate);
		};

		signal.kids.push(node);

		return node;
	}


	function delay(time, signal)
	{
		var delayed = input('delay-input-' + time, signal.value);

		function handler(value)
		{
			setTimeout(function() {
				localRuntime.notify(delayed.id, value);
			}, time);
		}

		output('delay-output-' + time, handler, signal);

		return delayed;
	}


	// MERGING

	function genericMerge(tieBreaker, leftStream, rightStream)
	{
		var node = {
			id: Utils.guid(),
			name: 'merge',
			value: A2(tieBreaker, leftStream.value, rightStream.value),
			parents: [leftStream, rightStream],
			kids: []
		};

		var left = { touched: false, update: false, value: null };
		var right = { touched: false, update: false, value: null };

		node.notify = function(timestamp, parentUpdate, parentID)
		{
			if (parentID === leftStream.id)
			{
				left.touched = true;
				left.update = parentUpdate;
				left.value = leftStream.value;
			}
			if (parentID === rightStream.id)
			{
				right.touched = true;
				right.update = parentUpdate;
				right.value = rightStream.value;
			}

			if (left.touched && right.touched)
			{
				var update = false;
				if (left.update && right.update)
				{
					node.value = A2(tieBreaker, left.value, right.value);
					update = true;
				}
				else if (left.update)
				{
					node.value = left.value;
					update = true;
				}
				else if (right.update)
				{
					node.value = right.value;
					update = true;
				}
				left.touched = false;
				right.touched = false;

				broadcastToKids(node, timestamp, update);
			}
		};

		leftStream.kids.push(node);
		rightStream.kids.push(node);

		return node;
	}


	// FILTERING

	function filterMap(toMaybe, base, signal)
	{
		var maybe = toMaybe(signal.value);
		var node = {
			id: Utils.guid(),
			name: 'filterMap',
			value: maybe.ctor === 'Nothing' ? base : maybe._0,
			parents: [signal],
			kids: []
		};

		node.notify = function(timestamp, parentUpdate, parentID)
		{
			var update = false;
			if (parentUpdate)
			{
				var maybe = toMaybe(signal.value);
				if (maybe.ctor === 'Just')
				{
					update = true;
					node.value = maybe._0;
				}
			}
			broadcastToKids(node, timestamp, update);
		};

		signal.kids.push(node);

		return node;
	}


	// SAMPLING

	function sampleOn(ticker, signal)
	{
		var node = {
			id: Utils.guid(),
			name: 'sampleOn',
			value: signal.value,
			parents: [ticker, signal],
			kids: []
		};

		var signalTouch = false;
		var tickerTouch = false;
		var tickerUpdate = false;

		node.notify = function(timestamp, parentUpdate, parentID)
		{
			if (parentID === ticker.id)
			{
				tickerTouch = true;
				tickerUpdate = parentUpdate;
			}
			if (parentID === signal.id)
			{
				signalTouch = true;
			}

			if (tickerTouch && signalTouch)
			{
				if (tickerUpdate)
				{
					node.value = signal.value;
				}
				tickerTouch = false;
				signalTouch = false;

				broadcastToKids(node, timestamp, tickerUpdate);
			}
		};

		ticker.kids.push(node);
		signal.kids.push(node);

		return node;
	}


	// DROP REPEATS

	function dropRepeats(signal)
	{
		var node = {
			id: Utils.guid(),
			name: 'dropRepeats',
			value: signal.value,
			parents: [signal],
			kids: []
		};

		node.notify = function(timestamp, parentUpdate, parentID)
		{
			var update = false;
			if (parentUpdate && !Utils.eq(node.value, signal.value))
			{
				node.value = signal.value;
				update = true;
			}
			broadcastToKids(node, timestamp, update);
		};

		signal.kids.push(node);

		return node;
	}


	return localRuntime.Native.Signal.values = {
		input: input,
		constant: constant,
		mailbox: mailbox,
		sendMessage: sendMessage,
		output: output,
		map: F2(map),
		map2: F3(map2),
		map3: F4(map3),
		map4: F5(map4),
		map5: F6(map5),
		foldp: F3(foldp),
		genericMerge: F3(genericMerge),
		filterMap: F3(filterMap),
		sampleOn: F2(sampleOn),
		dropRepeats: dropRepeats,
		timestamp: timestamp,
		delay: F2(delay)
	};
};

Elm.Native.String = {};
Elm.Native.String.make = function(localRuntime) {

	localRuntime.Native = localRuntime.Native || {};
	localRuntime.Native.String = localRuntime.Native.String || {};
	if (localRuntime.Native.String.values)
	{
		return localRuntime.Native.String.values;
	}
	if ('values' in Elm.Native.String)
	{
		return localRuntime.Native.String.values = Elm.Native.String.values;
	}


	var Char = Elm.Char.make(localRuntime);
	var List = Elm.Native.List.make(localRuntime);
	var Maybe = Elm.Maybe.make(localRuntime);
	var Result = Elm.Result.make(localRuntime);
	var Utils = Elm.Native.Utils.make(localRuntime);

	function isEmpty(str)
	{
		return str.length === 0;
	}
	function cons(chr,str)
	{
		return chr + str;
	}
	function uncons(str)
	{
		var hd;
		return (hd = str[0])
			? Maybe.Just(Utils.Tuple2(Utils.chr(hd), str.slice(1)))
			: Maybe.Nothing;
	}
	function append(a,b)
	{
		return a + b;
	}
	function concat(strs)
	{
		return List.toArray(strs).join('');
	}
	function length(str)
	{
		return str.length;
	}
	function map(f,str)
	{
		var out = str.split('');
		for (var i = out.length; i--; )
		{
			out[i] = f(Utils.chr(out[i]));
		}
		return out.join('');
	}
	function filter(pred,str)
	{
		return str.split('').map(Utils.chr).filter(pred).join('');
	}
	function reverse(str)
	{
		return str.split('').reverse().join('');
	}
	function foldl(f,b,str)
	{
		var len = str.length;
		for (var i = 0; i < len; ++i)
		{
			b = A2(f, Utils.chr(str[i]), b);
		}
		return b;
	}
	function foldr(f,b,str)
	{
		for (var i = str.length; i--; )
		{
			b = A2(f, Utils.chr(str[i]), b);
		}
		return b;
	}

	function split(sep, str)
	{
		return List.fromArray(str.split(sep));
	}
	function join(sep, strs)
	{
		return List.toArray(strs).join(sep);
	}
	function repeat(n, str)
	{
		var result = '';
		while (n > 0)
		{
			if (n & 1)
			{
				result += str;
			}
			n >>= 1, str += str;
		}
		return result;
	}

	function slice(start, end, str)
	{
		return str.slice(start,end);
	}
	function left(n, str)
	{
		return n < 1 ? "" : str.slice(0,n);
	}
	function right(n, str)
	{
		return n < 1 ? "" : str.slice(-n);
	}
	function dropLeft(n, str)
	{
		return n < 1 ? str : str.slice(n);
	}
	function dropRight(n, str)
	{
		return n < 1 ? str : str.slice(0,-n);
	}

	function pad(n,chr,str)
	{
		var half = (n - str.length) / 2;
		return repeat(Math.ceil(half),chr) + str + repeat(half|0,chr);
	}
	function padRight(n,chr,str)
	{
		return str + repeat(n - str.length, chr);
	}
	function padLeft(n,chr,str)
	{
		return repeat(n - str.length, chr) + str;
	}

	function trim(str)
	{
		return str.trim();
	}
	function trimLeft(str)
	{
		return str.trimLeft();
	}
	function trimRight(str)
	{
		return str.trimRight();
	}

	function words(str)
	{
		return List.fromArray(str.trim().split(/\s+/g));
	}
	function lines(str)
	{
		return List.fromArray(str.split(/\r\n|\r|\n/g));
	}

	function toUpper(str)
	{
		return str.toUpperCase();
	}
	function toLower(str)
	{
		return str.toLowerCase();
	}

	function any(pred, str)
	{
		for (var i = str.length; i--; )
		{
			if (pred(Utils.chr(str[i])))
			{
				return true;
			}
		}
		return false;
	}
	function all(pred, str)
	{
		for (var i = str.length; i--; )
		{
			if (!pred(Utils.chr(str[i])))
			{
				return false;
			}
		}
		return true;
	}

	function contains(sub, str)
	{
		return str.indexOf(sub) > -1;
	}
	function startsWith(sub, str)
	{
		return str.indexOf(sub) === 0;
	}
	function endsWith(sub, str)
	{
		return str.length >= sub.length &&
			str.lastIndexOf(sub) === str.length - sub.length;
	}
	function indexes(sub, str)
	{
		var subLen = sub.length;
		var i = 0;
		var is = [];
		while ((i = str.indexOf(sub, i)) > -1)
		{
			is.push(i);
			i = i + subLen;
		}
		return List.fromArray(is);
	}

	function toInt(s)
	{
		var len = s.length;
		if (len === 0)
		{
			return Result.Err("could not convert string '" + s + "' to an Int" );
		}
		var start = 0;
		if (s[0] == '-')
		{
			if (len === 1)
			{
				return Result.Err("could not convert string '" + s + "' to an Int" );
			}
			start = 1;
		}
		for (var i = start; i < len; ++i)
		{
			if (!Char.isDigit(s[i]))
			{
				return Result.Err("could not convert string '" + s + "' to an Int" );
			}
		}
		return Result.Ok(parseInt(s, 10));
	}

	function toFloat(s)
	{
		var len = s.length;
		if (len === 0)
		{
			return Result.Err("could not convert string '" + s + "' to a Float" );
		}
		var start = 0;
		if (s[0] == '-')
		{
			if (len === 1)
			{
				return Result.Err("could not convert string '" + s + "' to a Float" );
			}
			start = 1;
		}
		var dotCount = 0;
		for (var i = start; i < len; ++i)
		{
			if (Char.isDigit(s[i]))
			{
				continue;
			}
			if (s[i] === '.')
			{
				dotCount += 1;
				if (dotCount <= 1)
				{
					continue;
				}
			}
			return Result.Err("could not convert string '" + s + "' to a Float" );
		}
		return Result.Ok(parseFloat(s));
	}

	function toList(str)
	{
		return List.fromArray(str.split('').map(Utils.chr));
	}
	function fromList(chars)
	{
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

Elm.Native.Task = {};
Elm.Native.Task.make = function(localRuntime) {

	localRuntime.Native = localRuntime.Native || {};
	localRuntime.Native.Task = localRuntime.Native.Task || {};
	if (localRuntime.Native.Task.values)
	{
		return localRuntime.Native.Task.values;
	}

	var Result = Elm.Result.make(localRuntime);
	var Signal;
	var Utils = Elm.Native.Utils.make(localRuntime);


	// CONSTRUCTORS

	function succeed(value)
	{
		return {
			tag: 'Succeed',
			value: value
		};
	}

	function fail(error)
	{
		return {
			tag: 'Fail',
			value: error
		};
	}

	function asyncFunction(func)
	{
		return {
			tag: 'Async',
			asyncFunction: func
		};
	}

	function andThen(task, callback)
	{
		return {
			tag: 'AndThen',
			task: task,
			callback: callback
		};
	}

	function catch_(task, callback)
	{
		return {
			tag: 'Catch',
			task: task,
			callback: callback
		};
	}


	// RUNNER

	function perform(task) {
		runTask({ task: task }, function() {});
	}

	function performSignal(name, signal)
	{
		var workQueue = [];

		function onComplete()
		{
			workQueue.shift();

			setTimeout(function() {
				if (workQueue.length > 0)
				{
					runTask(workQueue[0], onComplete);
				}
			}, 0);
		}

		function register(task)
		{
			var root = { task: task };
			workQueue.push(root);
			if (workQueue.length === 1)
			{
				runTask(root, onComplete);
			}
		}

		if (!Signal)
		{
			Signal = Elm.Native.Signal.make(localRuntime);
		}
		Signal.output('perform-tasks-' + name, register, signal);

		register(signal.value);

		return signal;
	}

	function mark(status, task)
	{
		return { status: status, task: task };
	}

	function runTask(root, onComplete)
	{
		var result = mark('runnable', root.task);
		while (result.status === 'runnable')
		{
			result = stepTask(onComplete, root, result.task);
		}

		if (result.status === 'done')
		{
			root.task = result.task;
			onComplete();
		}

		if (result.status === 'blocked')
		{
			root.task = result.task;
		}
	}

	function stepTask(onComplete, root, task)
	{
		var tag = task.tag;

		if (tag === 'Succeed' || tag === 'Fail')
		{
			return mark('done', task);
		}

		if (tag === 'Async')
		{
			var placeHolder = {};
			var couldBeSync = true;
			var wasSync = false;

			task.asyncFunction(function(result) {
				placeHolder.tag = result.tag;
				placeHolder.value = result.value;
				if (couldBeSync)
				{
					wasSync = true;
				}
				else
				{
					runTask(root, onComplete);
				}
			});
			couldBeSync = false;
			return mark(wasSync ? 'done' : 'blocked', placeHolder);
		}

		if (tag === 'AndThen' || tag === 'Catch')
		{
			var result = mark('runnable', task.task);
			while (result.status === 'runnable')
			{
				result = stepTask(onComplete, root, result.task);
			}

			if (result.status === 'done')
			{
				var activeTask = result.task;
				var activeTag = activeTask.tag;

				var succeedChain = activeTag === 'Succeed' && tag === 'AndThen';
				var failChain = activeTag === 'Fail' && tag === 'Catch';

				return (succeedChain || failChain)
					? mark('runnable', task.callback(activeTask.value))
					: mark('runnable', activeTask);
			}
			if (result.status === 'blocked')
			{
				return mark('blocked', {
					tag: tag,
					task: result.task,
					callback: task.callback
				});
			}
		}
	}


	// THREADS

	function sleep(time) {
		return asyncFunction(function(callback) {
			setTimeout(function() {
				callback(succeed(Utils.Tuple0));
			}, time);
		});
	}

	function spawn(task) {
		return asyncFunction(function(callback) {
			var id = setTimeout(function() {
				perform(task);
			}, 0);
			callback(succeed(id));
		});
	}


	return localRuntime.Native.Task.values = {
		succeed: succeed,
		fail: fail,
		asyncFunction: asyncFunction,
		andThen: F2(andThen),
		catch_: F2(catch_),
		perform: perform,
		performSignal: performSignal,
		spawn: spawn,
		sleep: sleep
	};
};

Elm.Native.Text = {};
Elm.Native.Text.make = function(localRuntime) {
	localRuntime.Native = localRuntime.Native || {};
	localRuntime.Native.Text = localRuntime.Native.Text || {};
	if (localRuntime.Native.Text.values)
	{
		return localRuntime.Native.Text.values;
	}

	var toCss = Elm.Native.Color.make(localRuntime).toCss;
	var List = Elm.Native.List.make(localRuntime);


	// CONSTRUCTORS

	function fromString(str)
	{
		return {
			ctor: 'Text:Text',
			_0: str
		};
	}

	function append(a, b)
	{
		return {
			ctor: 'Text:Append',
			_0: a,
			_1: b
		};
	}

	function addMeta(field, value, text)
	{
		var newProps = {};
		var newText = {
			ctor: 'Text:Meta',
			_0: newProps,
			_1: text
		};

		if (text.ctor === 'Text:Meta')
		{
			newText._1 = text._1;
			var props = text._0;
			for (var i = metaKeys.length; i--; )
			{
				var key = metaKeys[i];
				var val = props[key];
				if (val)
				{
					newProps[key] = val;
				}
			}
		}
		newProps[field] = value;
		return newText;
	}

	var metaKeys = [
		'font-size',
		'font-family',
		'font-style',
		'font-weight',
		'href',
		'text-decoration',
		'color'
	];


	// conversions from Elm values to CSS

	function toTypefaces(list)
	{
		var typefaces = List.toArray(list);
		for (var i = typefaces.length; i--; )
		{
			var typeface = typefaces[i];
			if (typeface.indexOf(' ') > -1)
			{
				typefaces[i] = "'" + typeface + "'";
			}
		}
		return typefaces.join(',');
	}

	function toLine(line)
	{
		var ctor = line.ctor;
		return ctor === 'Under'
			? 'underline'
			: ctor === 'Over'
				? 'overline'
				: 'line-through';
	}

	// setting styles of Text

	function style(style, text)
	{
		var newText = addMeta('color', toCss(style.color), text);
		var props = newText._0;

		if (style.typeface.ctor !== '[]')
		{
			props['font-family'] = toTypefaces(style.typeface);
		}
		if (style.height.ctor !== "Nothing")
		{
			props['font-size'] = style.height._0 + 'px';
		}
		if (style.bold)
		{
			props['font-weight'] = 'bold';
		}
		if (style.italic)
		{
			props['font-style'] = 'italic';
		}
		if (style.line.ctor !== 'Nothing')
		{
			props['text-decoration'] = toLine(style.line._0);
		}
		return newText;
	}

	function height(px, text)
	{
		return addMeta('font-size', px + 'px', text);
	}

	function typeface(names, text)
	{
		return addMeta('font-family', toTypefaces(names), text);
	}

	function monospace(text)
	{
		return addMeta('font-family', 'monospace', text);
	}

	function italic(text)
	{
		return addMeta('font-style', 'italic', text);
	}

	function bold(text)
	{
		return addMeta('font-weight', 'bold', text);
	}

	function link(href, text)
	{
		return addMeta('href', href, text);
	}

	function line(line, text)
	{
		return addMeta('text-decoration', toLine(line), text);
	}

	function color(color, text)
	{
		return addMeta('color', toCss(color), text);;
	}


	// RENDER

	function renderHtml(text)
	{
		var tag = text.ctor;
		if (tag === 'Text:Append')
		{
			return renderHtml(text._0) + renderHtml(text._1);
		}
		if (tag === 'Text:Text')
		{
			return properEscape(text._0);
		}
		if (tag === 'Text:Meta')
		{
			return renderMeta(text._0, renderHtml(text._1));
		}
	}

	function renderMeta(metas, string)
	{
		var href = metas['href'];
		if (href)
		{
			string = '<a href="' + href + '">' + string + '</a>';
		}
		var styles = '';
		for (var key in metas)
		{
			if (key === 'href')
			{
				continue;
			}
			styles += key + ':' + metas[key] + ';';
		}
		if (styles)
		{
			string = '<span style="' + styles + '">' + string + '</span>';
		}
		return string;
	}

	function properEscape(str)
	{
		if (str.length == 0)
		{
			return str;
		}
		str = str //.replace(/&/g,  "&#38;")
			.replace(/"/g,  '&#34;')
			.replace(/'/g,  "&#39;")
			.replace(/</g,  "&#60;")
			.replace(/>/g,  "&#62;");
		var arr = str.split('\n');
		for (var i = arr.length; i--; )
		{
			arr[i] = makeSpaces(arr[i]);
		}
		return arr.join('<br/>');
	}

	function makeSpaces(s)
	{
		if (s.length == 0)
		{
			return s;
		}
		var arr = s.split('');
		if (arr[0] == ' ')
		{
			arr[0] = "&nbsp;"
		}
		for (var i = arr.length; --i; )
		{
			if (arr[i][0] == ' ' && arr[i-1] == ' ')
			{
				arr[i-1] = arr[i-1] + arr[i];
				arr[i] = '';
			}
		}
		for (var i = arr.length; i--; )
		{
			if (arr[i].length > 1 && arr[i][0] == ' ')
			{
				var spaces = arr[i].split('');
				for (var j = spaces.length - 2; j >= 0; j -= 2)
				{
					spaces[j] = '&nbsp;';
				}
				arr[i] = spaces.join('');
			}
		}
		arr = arr.join('');
		if (arr[arr.length-1] === " ")
		{
			return arr.slice(0,-1) + '&nbsp;';
		}
		return arr;
	}


	return localRuntime.Native.Text.values = {
		fromString: fromString,
		append: F2(append),

		height: F2(height),
		italic: italic,
		bold: bold,
		line: F2(line),
		monospace: monospace,
		typeface: F2(typeface),
		color: F2(color),
		link: F2(link),
		style: F2(style),

		toTypefaces: toTypefaces,
		toLine: toLine,
		renderHtml: renderHtml
	};
};

Elm.Native.Time = {};
Elm.Native.Time.make = function(localRuntime)
{

	localRuntime.Native = localRuntime.Native || {};
	localRuntime.Native.Time = localRuntime.Native.Time || {};
	if (localRuntime.Native.Time.values)
	{
		return localRuntime.Native.Time.values;
	}

	var NS = Elm.Native.Signal.make(localRuntime);
	var Maybe = Elm.Maybe.make(localRuntime);


	// FRAMES PER SECOND

	function fpsWhen(desiredFPS, isOn)
	{
		var msPerFrame = 1000 / desiredFPS;
		var ticker = NS.input('fps-' + desiredFPS, null);

		function notifyTicker()
		{
			localRuntime.notify(ticker.id, null);
		}

		function firstArg(x, y)
		{
			return x;
		}

		// input fires either when isOn changes, or when ticker fires.
		// Its value is a tuple with the current timestamp, and the state of isOn
		var input = NS.timestamp(A3(NS.map2, F2(firstArg), NS.dropRepeats(isOn), ticker));

		var initialState = {
			isOn: false,
			time: localRuntime.timer.programStart,
			delta: 0
		};

		var timeoutId;

		function update(input,state)
		{
			var currentTime = input._0;
			var isOn = input._1;
			var wasOn = state.isOn;
			var previousTime = state.time;

			if (isOn)
			{
				timeoutId = localRuntime.setTimeout(notifyTicker, msPerFrame);
			}
			else if (wasOn)
			{
				clearTimeout(timeoutId);
			}

			return {
				isOn: isOn,
				time: currentTime,
				delta: (isOn && !wasOn) ? 0 : currentTime - previousTime
			};
		}

		return A2(
			NS.map,
			function(state) { return state.delta; },
			A3(NS.foldp, F2(update), update(input.value,initialState), input)
		);
	}


	// EVERY

	function every(t)
	{
		var ticker = NS.input('every-' + t, null);
		function tellTime()
		{
			localRuntime.notify(ticker.id, null);
		}
		var clock = A2( NS.map, fst, NS.timestamp(ticker) );
		setInterval(tellTime, t);
		return clock;
	}


	function fst(pair)
	{
		return pair._0;
	}


	function read(s)
	{
		var t = Date.parse(s);
		return isNaN(t) ? Maybe.Nothing : Maybe.Just(t);
	}

	return localRuntime.Native.Time.values = {
		fpsWhen: F2(fpsWhen),
		every: every,
		toDate: function(t) { return new window.Date(t); },
		read: read
	};

};

Elm.Native.Transform2D = {};
Elm.Native.Transform2D.make = function(localRuntime) {

	localRuntime.Native = localRuntime.Native || {};
	localRuntime.Native.Transform2D = localRuntime.Native.Transform2D || {};
	if (localRuntime.Native.Transform2D.values)
	{
		return localRuntime.Native.Transform2D.values;
	}

	var A;
	if (typeof Float32Array === 'undefined')
	{
		A = function(arr)
		{
			this.length = arr.length;
			this[0] = arr[0];
			this[1] = arr[1];
			this[2] = arr[2];
			this[3] = arr[3];
			this[4] = arr[4];
			this[5] = arr[5];
		};
	}
	else
	{
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
	function matrix(m11, m12, m21, m22, dx, dy)
	{
		return new A([m11, m12, dx, m21, m22, dy]);
	}

	function rotation(t)
	{
		var c = Math.cos(t);
		var s = Math.sin(t);
		return new A([c, -s, 0, s, c, 0]);
	}

	function rotate(t,m)
	{
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
	function multiply(m, n)
	{
		var m11 = m[0], m12 = m[1], m21 = m[3], m22 = m[4], mdx = m[2], mdy = m[5];
		var n11 = n[0], n12 = n[1], n21 = n[3], n22 = n[4], ndx = n[2], ndy = n[5];
		return new A([m11*n11 + m12*n21,
					  m11*n12 + m12*n22,
					  m11*ndx + m12*ndy + mdx,
					  m21*n11 + m22*n21,
					  m21*n12 + m22*n22,
					  m21*ndx + m22*ndy + mdy]);
	}

	return localRuntime.Native.Transform2D.values = {
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
	if (localRuntime.Native.Utils.values)
	{
		return localRuntime.Native.Utils.values;
	}

	function eq(l,r)
	{
		var stack = [{'x': l, 'y': r}]
		while (stack.length > 0)
		{
			var front = stack.pop();
			var x = front.x;
			var y = front.y;
			if (x === y)
			{
				continue;
			}
			if (typeof x === "object")
			{
				var c = 0;
				for (var i in x)
				{
					++c;
					if (i in y)
					{
						if (i !== 'ctor')
						{
							stack.push({ 'x': x[i], 'y': y[i] });
						}
					}
					else
					{
						return false;
					}
				}
				if ('ctor' in x)
				{
					stack.push({'x': x.ctor, 'y': y.ctor});
				}
				if (c !== Object.keys(y).length)
				{
					return false;
				}
			}
			else if (typeof x === 'function')
			{
				throw new Error('Equality error: general function equality is ' +
								'undecidable, and therefore, unsupported');
			}
			else
			{
				return false;
			}
		}
		return true;
	}

	// code in Generate/JavaScript.hs depends on the particular
	// integer values assigned to LT, EQ, and GT
	var LT = -1, EQ = 0, GT = 1, ord = ['LT','EQ','GT'];

	function compare(x,y)
	{
		return {
			ctor: ord[cmp(x,y)+1]
		};
	}

	function cmp(x,y) {
		var ord;
		if (typeof x !== 'object')
		{
			return x === y ? EQ : x < y ? LT : GT;
		}
		else if (x.isChar)
		{
			var a = x.toString();
			var b = y.toString();
			return a === b
				? EQ
				: a < b
					? LT
					: GT;
		}
		else if (x.ctor === "::" || x.ctor === "[]")
		{
			while (true)
			{
				if (x.ctor === "[]" && y.ctor === "[]")
				{
					return EQ;
				}
				if (x.ctor !== y.ctor)
				{
					return x.ctor === '[]' ? LT : GT;
				}
				ord = cmp(x._0, y._0);
				if (ord !== EQ)
				{
					return ord;
				}
				x = x._1;
				y = y._1;
			}
		}
		else if (x.ctor.slice(0,6) === '_Tuple')
		{
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
		else
		{
			throw new Error('Comparison error: comparison is only defined on ints, ' +
							'floats, times, chars, strings, lists of comparable values, ' +
							'and tuples of comparable values.');
		}
	}


	var Tuple0 = {
		ctor: "_Tuple0"
	};

	function Tuple2(x,y)
	{
		return {
			ctor: "_Tuple2",
			_0: x,
			_1: y
		};
	}

	function chr(c)
	{
		var x = new String(c);
		x.isChar = true;
		return x;
	}

	function txt(str)
	{
		var t = new String(str);
		t.text = true;
		return t;
	}

	var count = 0;
	function guid(_)
	{
		return count++
	}

	function copy(oldRecord)
	{
		var newRecord = {};
		for (var key in oldRecord)
		{
			var value = key === '_'
				? copy(oldRecord._)
				: oldRecord[key];
			newRecord[key] = value;
		}
		return newRecord;
	}

	function remove(key, oldRecord)
	{
		var record = copy(oldRecord);
		if (key in record._)
		{
			record[key] = record._[key][0];
			record._[key] = record._[key].slice(1);
			if (record._[key].length === 0)
			{
				delete record._[key];
			}
		}
		else
		{
			delete record[key];
		}
		return record;
	}

	function replace(keyValuePairs, oldRecord)
	{
		var record = copy(oldRecord);
		for (var i = keyValuePairs.length; i--; )
		{
			var pair = keyValuePairs[i];
			record[pair[0]] = pair[1];
		}
		return record;
	}

	function insert(key, value, oldRecord)
	{
		var newRecord = copy(oldRecord);
		if (key in newRecord)
		{
			var values = newRecord._[key];
			var copiedValues = values ? values.slice(0) : [];
			newRecord._[key] = [newRecord[key]].concat(copiedValues);
		}
		newRecord[key] = value;
		return newRecord;
	}

	function getXY(e)
	{
		var posx = 0;
		var posy = 0;
		if (e.pageX || e.pageY)
		{
			posx = e.pageX;
			posy = e.pageY;
		}
		else if (e.clientX || e.clientY)
		{
			posx = e.clientX + document.body.scrollLeft + document.documentElement.scrollLeft;
			posy = e.clientY + document.body.scrollTop + document.documentElement.scrollTop;
		}

		if (localRuntime.isEmbed())
		{
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

	function Cons(hd,tl)
	{
		return {
			ctor: "::",
			_0: hd,
			_1: tl
		};
	}

	function append(xs,ys)
	{
		// append Strings
		if (typeof xs === "string")
		{
			return xs + ys;
		}

		// append Text
		if (xs.ctor.slice(0,5) === 'Text:')
		{
			return {
				ctor: 'Text:Append',
				_0: xs,
				_1: ys
			};
		}



		// append Lists
		if (xs.ctor === '[]')
		{
			return ys;
		}
		var root = Cons(xs._0, Nil);
		var curr = root;
		xs = xs._1;
		while (xs.ctor !== '[]')
		{
			curr._1 = Cons(xs._0, Nil);
			xs = xs._1;
			curr = curr._1;
		}
		curr._1 = ys;
		return root;
	}

	//// RUNTIME ERRORS ////

	function indent(lines)
	{
		return '\n' + lines.join('\n');
	}

	function badCase(moduleName, span)
	{
		var msg = indent([
			'Non-exhaustive pattern match in case-expression.',
			'Make sure your patterns cover every case!'
		]);
		throw new Error('Runtime error in module ' + moduleName + ' (' + span + ')' + msg);
	}

	function badIf(moduleName, span)
	{
		var msg = indent([
			'Non-exhaustive pattern match in multi-way-if expression.',
			'It is best to use \'otherwise\' as the last branch of multi-way-if.'
		]);
		throw new Error('Runtime error in module ' + moduleName + ' (' + span + ')' + msg);
	}


	function badPort(expected, received)
	{
		var msg = indent([
			'Expecting ' + expected + ' but was given ',
			JSON.stringify(received)
		]);
		throw new Error('Runtime error when sending values through a port.' + msg);
	}


	return localRuntime.Native.Utils.values = {
		eq: eq,
		cmp: cmp,
		compare: F2(compare),
		Tuple0: Tuple0,
		Tuple2: Tuple2,
		chr: chr,
		txt: txt,
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

(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var createElement = require("./vdom/create-element.js")

module.exports = createElement

},{"./vdom/create-element.js":6}],2:[function(require,module,exports){
(function (global){
var topLevel = typeof global !== 'undefined' ? global :
    typeof window !== 'undefined' ? window : {}
var minDoc = require('min-document');

if (typeof document !== 'undefined') {
    module.exports = document;
} else {
    var doccy = topLevel['__GLOBAL_DOCUMENT_CACHE@4'];

    if (!doccy) {
        doccy = topLevel['__GLOBAL_DOCUMENT_CACHE@4'] = minDoc;
    }

    module.exports = doccy;
}

}).call(this,typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"min-document":24}],3:[function(require,module,exports){
"use strict";

module.exports = function isObject(x) {
	return typeof x === "object" && x !== null;
};

},{}],4:[function(require,module,exports){
var nativeIsArray = Array.isArray
var toString = Object.prototype.toString

module.exports = nativeIsArray || isArray

function isArray(obj) {
    return toString.call(obj) === "[object Array]"
}

},{}],5:[function(require,module,exports){
var isObject = require("is-object")
var isHook = require("../vnode/is-vhook.js")

module.exports = applyProperties

function applyProperties(node, props, previous) {
    for (var propName in props) {
        var propValue = props[propName]

        if (propValue === undefined) {
            removeProperty(node, propName, propValue, previous);
        } else if (isHook(propValue)) {
            removeProperty(node, propName, propValue, previous)
            if (propValue.hook) {
                propValue.hook(node,
                    propName,
                    previous ? previous[propName] : undefined)
            }
        } else {
            if (isObject(propValue)) {
                patchObject(node, props, previous, propName, propValue);
            } else {
                node[propName] = propValue
            }
        }
    }
}

function removeProperty(node, propName, propValue, previous) {
    if (previous) {
        var previousValue = previous[propName]

        if (!isHook(previousValue)) {
            if (propName === "attributes") {
                for (var attrName in previousValue) {
                    node.removeAttribute(attrName)
                }
            } else if (propName === "style") {
                for (var i in previousValue) {
                    node.style[i] = ""
                }
            } else if (typeof previousValue === "string") {
                node[propName] = ""
            } else {
                node[propName] = null
            }
        } else if (previousValue.unhook) {
            previousValue.unhook(node, propName, propValue)
        }
    }
}

function patchObject(node, props, previous, propName, propValue) {
    var previousValue = previous ? previous[propName] : undefined

    // Set attributes
    if (propName === "attributes") {
        for (var attrName in propValue) {
            var attrValue = propValue[attrName]

            if (attrValue === undefined) {
                node.removeAttribute(attrName)
            } else {
                node.setAttribute(attrName, attrValue)
            }
        }

        return
    }

    if(previousValue && isObject(previousValue) &&
        getPrototype(previousValue) !== getPrototype(propValue)) {
        node[propName] = propValue
        return
    }

    if (!isObject(node[propName])) {
        node[propName] = {}
    }

    var replacer = propName === "style" ? "" : undefined

    for (var k in propValue) {
        var value = propValue[k]
        node[propName][k] = (value === undefined) ? replacer : value
    }
}

function getPrototype(value) {
    if (Object.getPrototypeOf) {
        return Object.getPrototypeOf(value)
    } else if (value.__proto__) {
        return value.__proto__
    } else if (value.constructor) {
        return value.constructor.prototype
    }
}

},{"../vnode/is-vhook.js":13,"is-object":3}],6:[function(require,module,exports){
var document = require("global/document")

var applyProperties = require("./apply-properties")

var isVNode = require("../vnode/is-vnode.js")
var isVText = require("../vnode/is-vtext.js")
var isWidget = require("../vnode/is-widget.js")
var handleThunk = require("../vnode/handle-thunk.js")

module.exports = createElement

function createElement(vnode, opts) {
    var doc = opts ? opts.document || document : document
    var warn = opts ? opts.warn : null

    vnode = handleThunk(vnode).a

    if (isWidget(vnode)) {
        return vnode.init()
    } else if (isVText(vnode)) {
        return doc.createTextNode(vnode.text)
    } else if (!isVNode(vnode)) {
        if (warn) {
            warn("Item is not a valid virtual dom node", vnode)
        }
        return null
    }

    var node = (vnode.namespace === null) ?
        doc.createElement(vnode.tagName) :
        doc.createElementNS(vnode.namespace, vnode.tagName)

    var props = vnode.properties
    applyProperties(node, props)

    var children = vnode.children

    for (var i = 0; i < children.length; i++) {
        var childNode = createElement(children[i], opts)
        if (childNode) {
            node.appendChild(childNode)
        }
    }

    return node
}

},{"../vnode/handle-thunk.js":11,"../vnode/is-vnode.js":14,"../vnode/is-vtext.js":15,"../vnode/is-widget.js":16,"./apply-properties":5,"global/document":2}],7:[function(require,module,exports){
// Maps a virtual DOM tree onto a real DOM tree in an efficient manner.
// We don't want to read all of the DOM nodes in the tree so we use
// the in-order tree indexing to eliminate recursion down certain branches.
// We only recurse into a DOM node if we know that it contains a child of
// interest.

var noChild = {}

module.exports = domIndex

function domIndex(rootNode, tree, indices, nodes) {
    if (!indices || indices.length === 0) {
        return {}
    } else {
        indices.sort(ascending)
        return recurse(rootNode, tree, indices, nodes, 0)
    }
}

function recurse(rootNode, tree, indices, nodes, rootIndex) {
    nodes = nodes || {}


    if (rootNode) {
        if (indexInRange(indices, rootIndex, rootIndex)) {
            nodes[rootIndex] = rootNode
        }

        var vChildren = tree.children

        if (vChildren) {

            var childNodes = rootNode.childNodes

            for (var i = 0; i < tree.children.length; i++) {
                rootIndex += 1

                var vChild = vChildren[i] || noChild
                var nextIndex = rootIndex + (vChild.count || 0)

                // skip recursion down the tree if there are no nodes down here
                if (indexInRange(indices, rootIndex, nextIndex)) {
                    recurse(childNodes[i], vChild, indices, nodes, rootIndex)
                }

                rootIndex = nextIndex
            }
        }
    }

    return nodes
}

// Binary search for an index in the interval [left, right]
function indexInRange(indices, left, right) {
    if (indices.length === 0) {
        return false
    }

    var minIndex = 0
    var maxIndex = indices.length - 1
    var currentIndex
    var currentItem

    while (minIndex <= maxIndex) {
        currentIndex = ((maxIndex + minIndex) / 2) >> 0
        currentItem = indices[currentIndex]

        if (minIndex === maxIndex) {
            return currentItem >= left && currentItem <= right
        } else if (currentItem < left) {
            minIndex = currentIndex + 1
        } else  if (currentItem > right) {
            maxIndex = currentIndex - 1
        } else {
            return true
        }
    }

    return false;
}

function ascending(a, b) {
    return a > b ? 1 : -1
}

},{}],8:[function(require,module,exports){
var applyProperties = require("./apply-properties")

var isWidget = require("../vnode/is-widget.js")
var VPatch = require("../vnode/vpatch.js")

var render = require("./create-element")
var updateWidget = require("./update-widget")

module.exports = applyPatch

function applyPatch(vpatch, domNode, renderOptions) {
    var type = vpatch.type
    var vNode = vpatch.vNode
    var patch = vpatch.patch

    switch (type) {
        case VPatch.REMOVE:
            return removeNode(domNode, vNode)
        case VPatch.INSERT:
            return insertNode(domNode, patch, renderOptions)
        case VPatch.VTEXT:
            return stringPatch(domNode, vNode, patch, renderOptions)
        case VPatch.WIDGET:
            return widgetPatch(domNode, vNode, patch, renderOptions)
        case VPatch.VNODE:
            return vNodePatch(domNode, vNode, patch, renderOptions)
        case VPatch.ORDER:
            reorderChildren(domNode, patch)
            return domNode
        case VPatch.PROPS:
            applyProperties(domNode, patch, vNode.properties)
            return domNode
        case VPatch.THUNK:
            return replaceRoot(domNode,
                renderOptions.patch(domNode, patch, renderOptions))
        default:
            return domNode
    }
}

function removeNode(domNode, vNode) {
    var parentNode = domNode.parentNode

    if (parentNode) {
        parentNode.removeChild(domNode)
    }

    destroyWidget(domNode, vNode);

    return null
}

function insertNode(parentNode, vNode, renderOptions) {
    var newNode = render(vNode, renderOptions)

    if (parentNode) {
        parentNode.appendChild(newNode)
    }

    return parentNode
}

function stringPatch(domNode, leftVNode, vText, renderOptions) {
    var newNode

    if (domNode.nodeType === 3) {
        domNode.replaceData(0, domNode.length, vText.text)
        newNode = domNode
    } else {
        var parentNode = domNode.parentNode
        newNode = render(vText, renderOptions)

        if (parentNode && newNode !== domNode) {
            parentNode.replaceChild(newNode, domNode)
        }
    }

    return newNode
}

function widgetPatch(domNode, leftVNode, widget, renderOptions) {
    var updating = updateWidget(leftVNode, widget)
    var newNode

    if (updating) {
        newNode = widget.update(leftVNode, domNode) || domNode
    } else {
        newNode = render(widget, renderOptions)
    }

    var parentNode = domNode.parentNode

    if (parentNode && newNode !== domNode) {
        parentNode.replaceChild(newNode, domNode)
    }

    if (!updating) {
        destroyWidget(domNode, leftVNode)
    }

    return newNode
}

function vNodePatch(domNode, leftVNode, vNode, renderOptions) {
    var parentNode = domNode.parentNode
    var newNode = render(vNode, renderOptions)

    if (parentNode && newNode !== domNode) {
        parentNode.replaceChild(newNode, domNode)
    }

    return newNode
}

function destroyWidget(domNode, w) {
    if (typeof w.destroy === "function" && isWidget(w)) {
        w.destroy(domNode)
    }
}

function reorderChildren(domNode, moves) {
    var childNodes = domNode.childNodes
    var keyMap = {}
    var node
    var remove
    var insert

    for (var i = 0; i < moves.removes.length; i++) {
        remove = moves.removes[i]
        node = childNodes[remove.from]
        if (remove.key) {
            keyMap[remove.key] = node
        }
        domNode.removeChild(node)
    }

    var length = childNodes.length
    for (var j = 0; j < moves.inserts.length; j++) {
        insert = moves.inserts[j]
        node = keyMap[insert.key]
        // this is the weirdest bug i've ever seen in webkit
        domNode.insertBefore(node, insert.to >= length++ ? null : childNodes[insert.to])
    }
}

function replaceRoot(oldRoot, newRoot) {
    if (oldRoot && newRoot && oldRoot !== newRoot && oldRoot.parentNode) {
        oldRoot.parentNode.replaceChild(newRoot, oldRoot)
    }

    return newRoot;
}

},{"../vnode/is-widget.js":16,"../vnode/vpatch.js":19,"./apply-properties":5,"./create-element":6,"./update-widget":10}],9:[function(require,module,exports){
var document = require("global/document")
var isArray = require("x-is-array")

var domIndex = require("./dom-index")
var patchOp = require("./patch-op")
module.exports = patch

function patch(rootNode, patches) {
    return patchRecursive(rootNode, patches)
}

function patchRecursive(rootNode, patches, renderOptions) {
    var indices = patchIndices(patches)

    if (indices.length === 0) {
        return rootNode
    }

    var index = domIndex(rootNode, patches.a, indices)
    var ownerDocument = rootNode.ownerDocument

    if (!renderOptions) {
        renderOptions = { patch: patchRecursive }
        if (ownerDocument !== document) {
            renderOptions.document = ownerDocument
        }
    }

    for (var i = 0; i < indices.length; i++) {
        var nodeIndex = indices[i]
        rootNode = applyPatch(rootNode,
            index[nodeIndex],
            patches[nodeIndex],
            renderOptions)
    }

    return rootNode
}

function applyPatch(rootNode, domNode, patchList, renderOptions) {
    if (!domNode) {
        return rootNode
    }

    var newNode

    if (isArray(patchList)) {
        for (var i = 0; i < patchList.length; i++) {
            newNode = patchOp(patchList[i], domNode, renderOptions)

            if (domNode === rootNode) {
                rootNode = newNode
            }
        }
    } else {
        newNode = patchOp(patchList, domNode, renderOptions)

        if (domNode === rootNode) {
            rootNode = newNode
        }
    }

    return rootNode
}

function patchIndices(patches) {
    var indices = []

    for (var key in patches) {
        if (key !== "a") {
            indices.push(Number(key))
        }
    }

    return indices
}

},{"./dom-index":7,"./patch-op":8,"global/document":2,"x-is-array":4}],10:[function(require,module,exports){
var isWidget = require("../vnode/is-widget.js")

module.exports = updateWidget

function updateWidget(a, b) {
    if (isWidget(a) && isWidget(b)) {
        if ("name" in a && "name" in b) {
            return a.id === b.id
        } else {
            return a.init === b.init
        }
    }

    return false
}

},{"../vnode/is-widget.js":16}],11:[function(require,module,exports){
var isVNode = require("./is-vnode")
var isVText = require("./is-vtext")
var isWidget = require("./is-widget")
var isThunk = require("./is-thunk")

module.exports = handleThunk

function handleThunk(a, b) {
    var renderedA = a
    var renderedB = b

    if (isThunk(b)) {
        renderedB = renderThunk(b, a)
    }

    if (isThunk(a)) {
        renderedA = renderThunk(a, null)
    }

    return {
        a: renderedA,
        b: renderedB
    }
}

function renderThunk(thunk, previous) {
    var renderedThunk = thunk.vnode

    if (!renderedThunk) {
        renderedThunk = thunk.vnode = thunk.render(previous)
    }

    if (!(isVNode(renderedThunk) ||
            isVText(renderedThunk) ||
            isWidget(renderedThunk))) {
        throw new Error("thunk did not return a valid node");
    }

    return renderedThunk
}

},{"./is-thunk":12,"./is-vnode":14,"./is-vtext":15,"./is-widget":16}],12:[function(require,module,exports){
module.exports = isThunk

function isThunk(t) {
    return t && t.type === "Thunk"
}

},{}],13:[function(require,module,exports){
module.exports = isHook

function isHook(hook) {
    return hook &&
      (typeof hook.hook === "function" && !hook.hasOwnProperty("hook") ||
       typeof hook.unhook === "function" && !hook.hasOwnProperty("unhook"))
}

},{}],14:[function(require,module,exports){
var version = require("./version")

module.exports = isVirtualNode

function isVirtualNode(x) {
    return x && x.type === "VirtualNode" && x.version === version
}

},{"./version":17}],15:[function(require,module,exports){
var version = require("./version")

module.exports = isVirtualText

function isVirtualText(x) {
    return x && x.type === "VirtualText" && x.version === version
}

},{"./version":17}],16:[function(require,module,exports){
module.exports = isWidget

function isWidget(w) {
    return w && w.type === "Widget"
}

},{}],17:[function(require,module,exports){
module.exports = "2"

},{}],18:[function(require,module,exports){
var version = require("./version")
var isVNode = require("./is-vnode")
var isWidget = require("./is-widget")
var isThunk = require("./is-thunk")
var isVHook = require("./is-vhook")

module.exports = VirtualNode

var noProperties = {}
var noChildren = []

function VirtualNode(tagName, properties, children, key, namespace) {
    this.tagName = tagName
    this.properties = properties || noProperties
    this.children = children || noChildren
    this.key = key != null ? String(key) : undefined
    this.namespace = (typeof namespace === "string") ? namespace : null

    var count = (children && children.length) || 0
    var descendants = 0
    var hasWidgets = false
    var hasThunks = false
    var descendantHooks = false
    var hooks

    for (var propName in properties) {
        if (properties.hasOwnProperty(propName)) {
            var property = properties[propName]
            if (isVHook(property) && property.unhook) {
                if (!hooks) {
                    hooks = {}
                }

                hooks[propName] = property
            }
        }
    }

    for (var i = 0; i < count; i++) {
        var child = children[i]
        if (isVNode(child)) {
            descendants += child.count || 0

            if (!hasWidgets && child.hasWidgets) {
                hasWidgets = true
            }

            if (!hasThunks && child.hasThunks) {
                hasThunks = true
            }

            if (!descendantHooks && (child.hooks || child.descendantHooks)) {
                descendantHooks = true
            }
        } else if (!hasWidgets && isWidget(child)) {
            if (typeof child.destroy === "function") {
                hasWidgets = true
            }
        } else if (!hasThunks && isThunk(child)) {
            hasThunks = true;
        }
    }

    this.count = count + descendants
    this.hasWidgets = hasWidgets
    this.hasThunks = hasThunks
    this.hooks = hooks
    this.descendantHooks = descendantHooks
}

VirtualNode.prototype.version = version
VirtualNode.prototype.type = "VirtualNode"

},{"./is-thunk":12,"./is-vhook":13,"./is-vnode":14,"./is-widget":16,"./version":17}],19:[function(require,module,exports){
var version = require("./version")

VirtualPatch.NONE = 0
VirtualPatch.VTEXT = 1
VirtualPatch.VNODE = 2
VirtualPatch.WIDGET = 3
VirtualPatch.PROPS = 4
VirtualPatch.ORDER = 5
VirtualPatch.INSERT = 6
VirtualPatch.REMOVE = 7
VirtualPatch.THUNK = 8

module.exports = VirtualPatch

function VirtualPatch(type, vNode, patch) {
    this.type = Number(type)
    this.vNode = vNode
    this.patch = patch
}

VirtualPatch.prototype.version = version
VirtualPatch.prototype.type = "VirtualPatch"

},{"./version":17}],20:[function(require,module,exports){
var version = require("./version")

module.exports = VirtualText

function VirtualText(text) {
    this.text = String(text)
}

VirtualText.prototype.version = version
VirtualText.prototype.type = "VirtualText"

},{"./version":17}],21:[function(require,module,exports){
var isObject = require("is-object")
var isHook = require("../vnode/is-vhook")

module.exports = diffProps

function diffProps(a, b) {
    var diff

    for (var aKey in a) {
        if (!(aKey in b)) {
            diff = diff || {}
            diff[aKey] = undefined
        }

        var aValue = a[aKey]
        var bValue = b[aKey]

        if (aValue === bValue) {
            continue
        } else if (isObject(aValue) && isObject(bValue)) {
            if (getPrototype(bValue) !== getPrototype(aValue)) {
                diff = diff || {}
                diff[aKey] = bValue
            } else if (isHook(bValue)) {
                 diff = diff || {}
                 diff[aKey] = bValue
            } else {
                var objectDiff = diffProps(aValue, bValue)
                if (objectDiff) {
                    diff = diff || {}
                    diff[aKey] = objectDiff
                }
            }
        } else {
            diff = diff || {}
            diff[aKey] = bValue
        }
    }

    for (var bKey in b) {
        if (!(bKey in a)) {
            diff = diff || {}
            diff[bKey] = b[bKey]
        }
    }

    return diff
}

function getPrototype(value) {
  if (Object.getPrototypeOf) {
    return Object.getPrototypeOf(value)
  } else if (value.__proto__) {
    return value.__proto__
  } else if (value.constructor) {
    return value.constructor.prototype
  }
}

},{"../vnode/is-vhook":13,"is-object":3}],22:[function(require,module,exports){
var isArray = require("x-is-array")

var VPatch = require("../vnode/vpatch")
var isVNode = require("../vnode/is-vnode")
var isVText = require("../vnode/is-vtext")
var isWidget = require("../vnode/is-widget")
var isThunk = require("../vnode/is-thunk")
var handleThunk = require("../vnode/handle-thunk")

var diffProps = require("./diff-props")

module.exports = diff

function diff(a, b) {
    var patch = { a: a }
    walk(a, b, patch, 0)
    return patch
}

function walk(a, b, patch, index) {
    if (a === b) {
        return
    }

    var apply = patch[index]
    var applyClear = false

    if (isThunk(a) || isThunk(b)) {
        thunks(a, b, patch, index)
    } else if (b == null) {

        // If a is a widget we will add a remove patch for it
        // Otherwise any child widgets/hooks must be destroyed.
        // This prevents adding two remove patches for a widget.
        if (!isWidget(a)) {
            clearState(a, patch, index)
            apply = patch[index]
        }

        apply = appendPatch(apply, new VPatch(VPatch.REMOVE, a, b))
    } else if (isVNode(b)) {
        if (isVNode(a)) {
            if (a.tagName === b.tagName &&
                a.namespace === b.namespace &&
                a.key === b.key) {
                var propsPatch = diffProps(a.properties, b.properties)
                if (propsPatch) {
                    apply = appendPatch(apply,
                        new VPatch(VPatch.PROPS, a, propsPatch))
                }
                apply = diffChildren(a, b, patch, apply, index)
            } else {
                apply = appendPatch(apply, new VPatch(VPatch.VNODE, a, b))
                applyClear = true
            }
        } else {
            apply = appendPatch(apply, new VPatch(VPatch.VNODE, a, b))
            applyClear = true
        }
    } else if (isVText(b)) {
        if (!isVText(a)) {
            apply = appendPatch(apply, new VPatch(VPatch.VTEXT, a, b))
            applyClear = true
        } else if (a.text !== b.text) {
            apply = appendPatch(apply, new VPatch(VPatch.VTEXT, a, b))
        }
    } else if (isWidget(b)) {
        if (!isWidget(a)) {
            applyClear = true
        }

        apply = appendPatch(apply, new VPatch(VPatch.WIDGET, a, b))
    }

    if (apply) {
        patch[index] = apply
    }

    if (applyClear) {
        clearState(a, patch, index)
    }
}

function diffChildren(a, b, patch, apply, index) {
    var aChildren = a.children
    var orderedSet = reorder(aChildren, b.children)
    var bChildren = orderedSet.children

    var aLen = aChildren.length
    var bLen = bChildren.length
    var len = aLen > bLen ? aLen : bLen

    for (var i = 0; i < len; i++) {
        var leftNode = aChildren[i]
        var rightNode = bChildren[i]
        index += 1

        if (!leftNode) {
            if (rightNode) {
                // Excess nodes in b need to be added
                apply = appendPatch(apply,
                    new VPatch(VPatch.INSERT, null, rightNode))
            }
        } else {
            walk(leftNode, rightNode, patch, index)
        }

        if (isVNode(leftNode) && leftNode.count) {
            index += leftNode.count
        }
    }

    if (orderedSet.moves) {
        // Reorder nodes last
        apply = appendPatch(apply, new VPatch(
            VPatch.ORDER,
            a,
            orderedSet.moves
        ))
    }

    return apply
}

function clearState(vNode, patch, index) {
    // TODO: Make this a single walk, not two
    unhook(vNode, patch, index)
    destroyWidgets(vNode, patch, index)
}

// Patch records for all destroyed widgets must be added because we need
// a DOM node reference for the destroy function
function destroyWidgets(vNode, patch, index) {
    if (isWidget(vNode)) {
        if (typeof vNode.destroy === "function") {
            patch[index] = appendPatch(
                patch[index],
                new VPatch(VPatch.REMOVE, vNode, null)
            )
        }
    } else if (isVNode(vNode) && (vNode.hasWidgets || vNode.hasThunks)) {
        var children = vNode.children
        var len = children.length
        for (var i = 0; i < len; i++) {
            var child = children[i]
            index += 1

            destroyWidgets(child, patch, index)

            if (isVNode(child) && child.count) {
                index += child.count
            }
        }
    } else if (isThunk(vNode)) {
        thunks(vNode, null, patch, index)
    }
}

// Create a sub-patch for thunks
function thunks(a, b, patch, index) {
    var nodes = handleThunk(a, b)
    var thunkPatch = diff(nodes.a, nodes.b)
    if (hasPatches(thunkPatch)) {
        patch[index] = new VPatch(VPatch.THUNK, null, thunkPatch)
    }
}

function hasPatches(patch) {
    for (var index in patch) {
        if (index !== "a") {
            return true
        }
    }

    return false
}

// Execute hooks when two nodes are identical
function unhook(vNode, patch, index) {
    if (isVNode(vNode)) {
        if (vNode.hooks) {
            patch[index] = appendPatch(
                patch[index],
                new VPatch(
                    VPatch.PROPS,
                    vNode,
                    undefinedKeys(vNode.hooks)
                )
            )
        }

        if (vNode.descendantHooks || vNode.hasThunks) {
            var children = vNode.children
            var len = children.length
            for (var i = 0; i < len; i++) {
                var child = children[i]
                index += 1

                unhook(child, patch, index)

                if (isVNode(child) && child.count) {
                    index += child.count
                }
            }
        }
    } else if (isThunk(vNode)) {
        thunks(vNode, null, patch, index)
    }
}

function undefinedKeys(obj) {
    var result = {}

    for (var key in obj) {
        result[key] = undefined
    }

    return result
}

// List diff, naive left to right reordering
function reorder(aChildren, bChildren) {
    // O(M) time, O(M) memory
    var bChildIndex = keyIndex(bChildren)
    var bKeys = bChildIndex.keys
    var bFree = bChildIndex.free

    if (bFree.length === bChildren.length) {
        return {
            children: bChildren,
            moves: null
        }
    }

    // O(N) time, O(N) memory
    var aChildIndex = keyIndex(aChildren)
    var aKeys = aChildIndex.keys
    var aFree = aChildIndex.free

    if (aFree.length === aChildren.length) {
        return {
            children: bChildren,
            moves: null
        }
    }

    // O(MAX(N, M)) memory
    var newChildren = []

    var freeIndex = 0
    var freeCount = bFree.length
    var deletedItems = 0

    // Iterate through a and match a node in b
    // O(N) time,
    for (var i = 0 ; i < aChildren.length; i++) {
        var aItem = aChildren[i]
        var itemIndex

        if (aItem.key) {
            if (bKeys.hasOwnProperty(aItem.key)) {
                // Match up the old keys
                itemIndex = bKeys[aItem.key]
                newChildren.push(bChildren[itemIndex])

            } else {
                // Remove old keyed items
                itemIndex = i - deletedItems++
                newChildren.push(null)
            }
        } else {
            // Match the item in a with the next free item in b
            if (freeIndex < freeCount) {
                itemIndex = bFree[freeIndex++]
                newChildren.push(bChildren[itemIndex])
            } else {
                // There are no free items in b to match with
                // the free items in a, so the extra free nodes
                // are deleted.
                itemIndex = i - deletedItems++
                newChildren.push(null)
            }
        }
    }

    var lastFreeIndex = freeIndex >= bFree.length ?
        bChildren.length :
        bFree[freeIndex]

    // Iterate through b and append any new keys
    // O(M) time
    for (var j = 0; j < bChildren.length; j++) {
        var newItem = bChildren[j]

        if (newItem.key) {
            if (!aKeys.hasOwnProperty(newItem.key)) {
                // Add any new keyed items
                // We are adding new items to the end and then sorting them
                // in place. In future we should insert new items in place.
                newChildren.push(newItem)
            }
        } else if (j >= lastFreeIndex) {
            // Add any leftover non-keyed items
            newChildren.push(newItem)
        }
    }

    var simulate = newChildren.slice()
    var simulateIndex = 0
    var removes = []
    var inserts = []
    var simulateItem

    for (var k = 0; k < bChildren.length;) {
        var wantedItem = bChildren[k]
        simulateItem = simulate[simulateIndex]

        // remove items
        while (simulateItem === null && simulate.length) {
            removes.push(remove(simulate, simulateIndex, null))
            simulateItem = simulate[simulateIndex]
        }

        if (!simulateItem || simulateItem.key !== wantedItem.key) {
            // if we need a key in this position...
            if (wantedItem.key) {
                if (simulateItem && simulateItem.key) {
                    // if an insert doesn't put this key in place, it needs to move
                    if (bKeys[simulateItem.key] !== k + 1) {
                        removes.push(remove(simulate, simulateIndex, simulateItem.key))
                        simulateItem = simulate[simulateIndex]
                        // if the remove didn't put the wanted item in place, we need to insert it
                        if (!simulateItem || simulateItem.key !== wantedItem.key) {
                            inserts.push({key: wantedItem.key, to: k})
                        }
                        // items are matching, so skip ahead
                        else {
                            simulateIndex++
                        }
                    }
                    else {
                        inserts.push({key: wantedItem.key, to: k})
                    }
                }
                else {
                    inserts.push({key: wantedItem.key, to: k})
                }
                k++
            }
            // a key in simulate has no matching wanted key, remove it
            else if (simulateItem && simulateItem.key) {
                removes.push(remove(simulate, simulateIndex, simulateItem.key))
            }
        }
        else {
            simulateIndex++
            k++
        }
    }

    // remove all the remaining nodes from simulate
    while(simulateIndex < simulate.length) {
        simulateItem = simulate[simulateIndex]
        removes.push(remove(simulate, simulateIndex, simulateItem && simulateItem.key))
    }

    // If the only moves we have are deletes then we can just
    // let the delete patch remove these items.
    if (removes.length === deletedItems && !inserts.length) {
        return {
            children: newChildren,
            moves: null
        }
    }

    return {
        children: newChildren,
        moves: {
            removes: removes,
            inserts: inserts
        }
    }
}

function remove(arr, index, key) {
    arr.splice(index, 1)

    return {
        from: index,
        key: key
    }
}

function keyIndex(children) {
    var keys = {}
    var free = []
    var length = children.length

    for (var i = 0; i < length; i++) {
        var child = children[i]

        if (child.key) {
            keys[child.key] = i
        } else {
            free.push(i)
        }
    }

    return {
        keys: keys,     // A hash of key name to index
        free: free,     // An array of unkeyed item indices
    }
}

function appendPatch(apply, patch) {
    if (apply) {
        if (isArray(apply)) {
            apply.push(patch)
        } else {
            apply = [apply, patch]
        }

        return apply
    } else {
        return patch
    }
}

},{"../vnode/handle-thunk":11,"../vnode/is-thunk":12,"../vnode/is-vnode":14,"../vnode/is-vtext":15,"../vnode/is-widget":16,"../vnode/vpatch":19,"./diff-props":21,"x-is-array":4}],23:[function(require,module,exports){
var VNode = require('virtual-dom/vnode/vnode');
var VText = require('virtual-dom/vnode/vtext');
var diff = require('virtual-dom/vtree/diff');
var patch = require('virtual-dom/vdom/patch');
var createElement = require('virtual-dom/create-element');
var isHook = require("virtual-dom/vnode/is-vhook");


Elm.Native.VirtualDom = {};
Elm.Native.VirtualDom.make = function(elm)
{
	elm.Native = elm.Native || {};
	elm.Native.VirtualDom = elm.Native.VirtualDom || {};
	if (elm.Native.VirtualDom.values)
	{
		return elm.Native.VirtualDom.values;
	}

	var Element = Elm.Native.Graphics.Element.make(elm);
	var Json = Elm.Native.Json.make(elm);
	var List = Elm.Native.List.make(elm);
	var Signal = Elm.Native.Signal.make(elm);
	var Utils = Elm.Native.Utils.make(elm);

	var ATTRIBUTE_KEY = 'UniqueNameThatOthersAreVeryUnlikelyToUse';

	function listToProperties(list)
	{
		var object = {};
		while (list.ctor !== '[]')
		{
			var entry = list._0;
			if (entry.key === ATTRIBUTE_KEY)
			{
				object.attributes = object.attributes || {};
				object.attributes[entry.value.attrKey] = entry.value.attrValue;
			}
			else
			{
				object[entry.key] = entry.value;
			}
			list = list._1;
		}
		return object;
	}

	function node(name)
	{
		return F2(function(propertyList, contents) {
			return makeNode(name, propertyList, contents);
		});
	}

	function makeNode(name, propertyList, contents)
	{
		var props = listToProperties(propertyList);

		var key, namespace;
		// support keys
		if (props.key !== undefined)
		{
			key = props.key;
			props.key = undefined;
		}

		// support namespace
		if (props.namespace !== undefined)
		{
			namespace = props.namespace;
			props.namespace = undefined;
		}

		// ensure that setting text of an input does not move the cursor
		var useSoftSet =
			name === 'input'
			&& props.value !== undefined
			&& !isHook(props.value);

		if (useSoftSet)
		{
			props.value = SoftSetHook(props.value);
		}

		return new VNode(name, props, List.toArray(contents), key, namespace);
	}

	function property(key, value)
	{
		return {
			key: key,
			value: value
		};
	}

	function attribute(key, value)
	{
		return {
			key: ATTRIBUTE_KEY,
			value: {
				attrKey: key,
				attrValue: value
			}
		};
	}

	function on(name, options, decoder, createMessage)
	{
		function eventHandler(event)
		{
			var value = A2(Json.runDecoderValue, decoder, event);
			if (value.ctor === 'Ok')
			{
				if (options.stopPropagation)
				{
					event.stopPropagation();
				}
				if (options.preventDefault)
				{
					event.preventDefault();
				}
				Signal.sendMessage(createMessage(value._0));
			}
		}
		return property('on' + name, eventHandler);
	}

	function SoftSetHook(value)
	{
		if (!(this instanceof SoftSetHook))
		{
			return new SoftSetHook(value);
		}

		this.value = value;
	}

	SoftSetHook.prototype.hook = function (node, propertyName)
	{
		if (node[propertyName] !== this.value)
		{
			node[propertyName] = this.value;
		}
	};

	function text(string)
	{
		return new VText(string);
	}

	function ElementWidget(element)
	{
		this.element = element;
	}

	ElementWidget.prototype.type = "Widget";

	ElementWidget.prototype.init = function init()
	{
		return Element.render(this.element);
	};

	ElementWidget.prototype.update = function update(previous, node)
	{
		return Element.update(node, previous.element, this.element);
	};

	function fromElement(element)
	{
		return new ElementWidget(element);
	}

	function toElement(width, height, html)
	{
		return A3(Element.newElement, width, height, {
			ctor: 'Custom',
			type: 'evancz/elm-html',
			render: render,
			update: update,
			model: html
		});
	}

	function render(model)
	{
		var element = Element.createNode('div');
		element.appendChild(createElement(model));
		return element;
	}

	function update(node, oldModel, newModel)
	{
		updateAndReplace(node.firstChild, oldModel, newModel);
		return node;
	}

	function updateAndReplace(node, oldModel, newModel)
	{
		var patches = diff(oldModel, newModel);
		var newNode = patch(node, patches);
		return newNode;
	}

	function lazyRef(fn, a)
	{
		function thunk()
		{
			return fn(a);
		}
		return new Thunk(fn, [a], thunk);
	}

	function lazyRef2(fn, a, b)
	{
		function thunk()
		{
			return A2(fn, a, b);
		}
		return new Thunk(fn, [a,b], thunk);
	}

	function lazyRef3(fn, a, b, c)
	{
		function thunk()
		{
			return A3(fn, a, b, c);
		}
		return new Thunk(fn, [a,b,c], thunk);
	}

	function Thunk(fn, args, thunk)
	{
		this.fn = fn;
		this.args = args;
		this.vnode = null;
		this.key = undefined;
		this.thunk = thunk;
	}

	Thunk.prototype.type = "Thunk";
	Thunk.prototype.update = updateThunk;
	Thunk.prototype.render = renderThunk;

	function shouldUpdate(current, previous)
	{
		if (current.fn !== previous.fn)
		{
			return true;
		}

		// if it's the same function, we know the number of args must match
		var cargs = current.args;
		var pargs = previous.args;

		for (var i = cargs.length; i--; )
		{
			if (cargs[i] !== pargs[i])
			{
				return true;
			}
		}

		return false;
	}

	function updateThunk(previous, domNode)
	{
		if (!shouldUpdate(this, previous))
		{
			this.vnode = previous.vnode;
			return;
		}

		if (!this.vnode)
		{
			this.vnode = this.thunk();
		}

		var patches = diff(previous.vnode, this.vnode);
		patch(domNode, patches);
	}

	function renderThunk()
	{
		return this.thunk();
	}

	return Elm.Native.VirtualDom.values = {
		node: node,
		text: text,
		on: F4(on),

		property: F2(property),
		attribute: F2(attribute),

		lazy: F2(lazyRef),
		lazy2: F3(lazyRef2),
		lazy3: F4(lazyRef3),

		toElement: F3(toElement),
		fromElement: fromElement,

		render: createElement,
		updateAndReplace: updateAndReplace
	};
};

},{"virtual-dom/create-element":1,"virtual-dom/vdom/patch":9,"virtual-dom/vnode/is-vhook":13,"virtual-dom/vnode/vnode":18,"virtual-dom/vnode/vtext":20,"virtual-dom/vtree/diff":22}],24:[function(require,module,exports){

},{}]},{},[23]);

Elm.Native = Elm.Native || {};
Elm.Native.Window = {};
Elm.Native.Window.make = function(localRuntime) {

	localRuntime.Native = localRuntime.Native || {};
	localRuntime.Native.Window = localRuntime.Native.Window || {};
	if (localRuntime.Native.Window.values)
	{
		return localRuntime.Native.Window.values;
	}

	var NS = Elm.Native.Signal.make(localRuntime);
	var Tuple2 = Elm.Native.Utils.make(localRuntime).Tuple2;


	function getWidth()
	{
		return localRuntime.node.clientWidth;
	}


	function getHeight()
	{
		if (localRuntime.isFullscreen())
		{
			return window.innerHeight;
		}
		return localRuntime.node.clientHeight;
	}


	var dimensions = NS.input('Window.dimensions', Tuple2(getWidth(), getHeight()));


	function resizeIfNeeded()
	{
		// Do not trigger event if the dimensions have not changed.
		// This should be most of the time.
		var w = getWidth();
		var h = getHeight();
		if (dimensions.value._0 === w && dimensions.value._1 === h)
		{
			return;
		}

		setTimeout(function () {
			// Check again to see if the dimensions have changed.
			// It is conceivable that the dimensions have changed
			// again while some other event was being processed.
			var w = getWidth();
			var h = getHeight();
			if (dimensions.value._0 === w && dimensions.value._1 === h)
			{
				return;
			}
			localRuntime.notify(dimensions.id, Tuple2(w,h));
		}, 0);
	}


	localRuntime.addListener([dimensions.id], window, 'resize', resizeIfNeeded);


	return localRuntime.Native.Window.values = {
		dimensions: dimensions,
		resizeIfNeeded: resizeIfNeeded
	};
};

Elm.Outputs = Elm.Outputs || {};
Elm.Outputs.make = function (_elm) {
   "use strict";
   _elm.Outputs = _elm.Outputs || {};
   if (_elm.Outputs.values)
   return _elm.Outputs.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   $moduleName = "Outputs",
   $Basics = Elm.Basics.make(_elm),
   $Game = Elm.Game.make(_elm),
   $Inputs = Elm.Inputs.make(_elm),
   $List = Elm.List.make(_elm),
   $Maybe = Elm.Maybe.make(_elm),
   $Result = Elm.Result.make(_elm),
   $Signal = Elm.Signal.make(_elm),
   $State = Elm.State.make(_elm);
   var getActiveRaceCourse = function (appState) {
      return function () {
         var _v0 = appState.screen;
         switch (_v0.ctor)
         {case "Play":
            return $Maybe.Just(_v0._0.id);}
         return $Maybe.Nothing;
      }();
   };
   var makePlayerOutput = F2(function (keyboardInput,
   gameState) {
      return {_: {}
             ,input: A2($Maybe.withDefault,
             $Inputs.emptyKeyboardInput,
             keyboardInput)
             ,localTime: gameState.localTime
             ,state: $Game.asOpponentState(gameState.playerState)};
   });
   var extractPlayerOutput = F2(function (appState,
   appInput) {
      return A2($Maybe.map,
      makePlayerOutput(A2($Maybe.map,
      function (_) {
         return _.keyboardInput;
      },
      appInput.gameInput)),
      appState.gameState);
   });
   var PlayerOutput = F3(function (a,
   b,
   c) {
      return {_: {}
             ,input: b
             ,localTime: c
             ,state: a};
   });
   _elm.Outputs.values = {_op: _op
                         ,PlayerOutput: PlayerOutput
                         ,extractPlayerOutput: extractPlayerOutput
                         ,makePlayerOutput: makePlayerOutput
                         ,getActiveRaceCourse: getActiveRaceCourse};
   return _elm.Outputs.values;
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
   $moduleName = "Render.All",
   $Basics = Elm.Basics.make(_elm),
   $Game = Elm.Game.make(_elm),
   $Graphics$Element = Elm.Graphics.Element.make(_elm),
   $Layout = Elm.Layout.make(_elm),
   $List = Elm.List.make(_elm),
   $Maybe = Elm.Maybe.make(_elm),
   $Render$Controls = Elm.Render.Controls.make(_elm),
   $Render$Course = Elm.Render.Course.make(_elm),
   $Render$Dashboard = Elm.Render.Dashboard.make(_elm),
   $Render$Players = Elm.Render.Players.make(_elm),
   $Result = Elm.Result.make(_elm),
   $Signal = Elm.Signal.make(_elm);
   var renderGame = F2(function (_v0,
   gameState) {
      return function () {
         switch (_v0.ctor)
         {case "_Tuple2":
            return function () {
                 var controlsForm = A2($Render$Controls.renderControls,
                 gameState,
                 {ctor: "_Tuple2"
                 ,_0: _v0._0
                 ,_1: _v0._1});
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
         "between lines 28 and 39");
      }();
   });
   _elm.Render.All.values = {_op: _op
                            ,renderGame: renderGame};
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
   $moduleName = "Render.Controls",
   $Basics = Elm.Basics.make(_elm),
   $Core = Elm.Core.make(_elm),
   $Game = Elm.Game.make(_elm),
   $Geo = Elm.Geo.make(_elm),
   $Graphics$Collage = Elm.Graphics.Collage.make(_elm),
   $Graphics$Element = Elm.Graphics.Element.make(_elm),
   $List = Elm.List.make(_elm),
   $Maybe = Elm.Maybe.make(_elm),
   $Render$Utils = Elm.Render.Utils.make(_elm),
   $Result = Elm.Result.make(_elm),
   $Signal = Elm.Signal.make(_elm);
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
      return $Graphics$Collage.toForm($Graphics$Element.centered($Render$Utils.baseText(A2($Basics._op["++"],
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
                 "between lines 32 and 58");
              }();}
         _U.badCase($moduleName,
         "between lines 32 and 58");
      }();
   });
   var renderControls = F2(function (_v8,
   intDims) {
      return function () {
         return function () {
            var dims = $Geo.floatify(intDims);
            var downwindHint = _U.eq(_v8.playerState.nextGate,
            $Maybe.Just($Game.DownwindGate)) ? A4(renderGateHint,
            _v8.course.downwind,
            dims,
            _v8.center,
            _v8.now) : $Maybe.Nothing;
            var upwindHint = _U.eq(_v8.playerState.nextGate,
            $Maybe.Just($Game.UpwindGate)) ? A4(renderGateHint,
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
   $moduleName = "Render.Course",
   $Basics = Elm.Basics.make(_elm),
   $Color = Elm.Color.make(_elm),
   $Game = Elm.Game.make(_elm),
   $Graphics$Collage = Elm.Graphics.Collage.make(_elm),
   $List = Elm.List.make(_elm),
   $Maybe = Elm.Maybe.make(_elm),
   $Render$Gates = Elm.Render.Gates.make(_elm),
   $Render$Utils = Elm.Render.Utils.make(_elm),
   $Result = Elm.Result.make(_elm),
   $Signal = Elm.Signal.make(_elm);
   var renderIslands = function (course) {
      return function () {
         var renderIsland = function (_v0) {
            return function () {
               return $Graphics$Collage.move(_v0.location)($Graphics$Collage.filled($Render$Utils.colors.sand)($Graphics$Collage.circle(_v0.radius)));
            }();
         };
         return $Graphics$Collage.group(A2($List.map,
         renderIsland,
         course.islands));
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
   var renderLaylines = F3(function (wind,
   course,
   playerState) {
      return function () {
         var _v2 = playerState.nextGate;
         switch (_v2.ctor)
         {case "Just":
            switch (_v2._0.ctor)
              {case "DownwindGate":
                 return A4($Render$Gates.renderGateLaylines,
                   playerState.downwindVmg,
                   wind.origin,
                   course.area,
                   course.downwind);
                 case "UpwindGate":
                 return A4($Render$Gates.renderGateLaylines,
                   playerState.upwindVmg,
                   wind.origin,
                   course.area,
                   course.upwind);}
              break;}
         return $Render$Utils.emptyForm;
      }();
   });
   var renderUpwind = F3(function (playerState,
   course,
   now) {
      return function () {
         var isNext = _U.eq(playerState.nextGate,
         $Maybe.Just($Game.UpwindGate));
         return A4($Render$Gates.renderGate,
         course.upwind,
         now,
         isNext,
         $Render$Gates.Upwind);
      }();
   });
   var renderDownwind = F4(function (playerState,
   course,
   now,
   started) {
      return function () {
         var isNext = _U.eq(playerState.nextGate,
         $Maybe.Just($Game.DownwindGate));
         var isLastGate = _U.eq($List.length(playerState.crossedGates),
         course.laps * 2);
         var isFirstGate = $List.isEmpty(playerState.crossedGates);
         return isFirstGate ? A3($Render$Gates.renderStartLine,
         course.downwind,
         started,
         now) : isLastGate ? A2($Render$Gates.renderFinishLine,
         course.downwind,
         now) : A4($Render$Gates.renderGate,
         course.downwind,
         now,
         isNext,
         $Render$Gates.Downwind);
      }();
   });
   var renderCourse = function (_v4) {
      return function () {
         return function () {
            var forms = _L.fromArray([renderBounds(_v4.course.area)
                                     ,A3(renderLaylines,
                                     _v4.wind,
                                     _v4.course,
                                     _v4.playerState)
                                     ,renderIslands(_v4.course)
                                     ,A4(renderDownwind,
                                     _v4.playerState,
                                     _v4.course,
                                     _v4.now,
                                     $Game.isStarted(_v4))
                                     ,A3(renderUpwind,
                                     _v4.playerState,
                                     _v4.course,
                                     _v4.now)
                                     ,renderGusts(_v4.wind)]);
            return $Graphics$Collage.group(forms);
         }();
      }();
   };
   _elm.Render.Course.values = {_op: _op
                               ,renderDownwind: renderDownwind
                               ,renderUpwind: renderUpwind
                               ,renderLaylines: renderLaylines
                               ,renderBounds: renderBounds
                               ,renderGust: renderGust
                               ,renderGusts: renderGusts
                               ,renderIslands: renderIslands
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
   $moduleName = "Render.Dashboard",
   $Basics = Elm.Basics.make(_elm),
   $Color = Elm.Color.make(_elm),
   $Core = Elm.Core.make(_elm),
   $Game = Elm.Game.make(_elm),
   $Graphics$Collage = Elm.Graphics.Collage.make(_elm),
   $Graphics$Element = Elm.Graphics.Element.make(_elm),
   $Layout = Elm.Layout.make(_elm),
   $List = Elm.List.make(_elm),
   $Maybe = Elm.Maybe.make(_elm),
   $Render$Utils = Elm.Render.Utils.make(_elm),
   $Result = Elm.Result.make(_elm),
   $Signal = Elm.Signal.make(_elm),
   $String = Elm.String.make(_elm),
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
                                                ,_1: 0 - barHeight / 2 - 10})($Graphics$Collage.toForm($Graphics$Element.centered($Render$Utils.baseText("VMG"))));
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
                                             ,_1: -50})($Graphics$Collage.toForm($Graphics$Element.centered($Render$Utils.baseText("WIND"))));
         var windSpeedText = $Graphics$Collage.toForm($Graphics$Element.centered($Render$Utils.baseText(A2($Basics._op["++"],
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
                                                     ,_1: r + 25})($Graphics$Collage.toForm($Graphics$Element.centered($Render$Utils.baseText(A2($Basics._op["++"],
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
   var topRightElements = function (_v2) {
      return function () {
         return _L.fromArray([getWindWheel(_v2.wind)
                             ,getVmgBar(_v2.playerState)]);
      }();
   };
   var getTimeTrialFinishingStatus = F2(function (_v4,
   _v5) {
      return function () {
         return function () {
            return function () {
               var _v8 = A2($Game.findPlayerGhost,
               _v4.playerState.player.id,
               _v4.ghosts);
               switch (_v8.ctor)
               {case "Just":
                  return function () {
                       var newTimeMaybe = $List.head(_v5.crossedGates);
                       var previousTimeMaybe = $List.head(_v8._0.gates);
                       return function () {
                          var _v10 = {ctor: "_Tuple2"
                                     ,_0: previousTimeMaybe
                                     ,_1: newTimeMaybe};
                          switch (_v10.ctor)
                          {case "_Tuple2":
                             switch (_v10._0.ctor)
                               {case "Just":
                                  switch (_v10._1.ctor)
                                    {case "Just":
                                       return _U.cmp(_v10._1._0,
                                         _v10._0._0) < 0 ? A2($Basics._op["++"],
                                         $Basics.toString(_v10._1._0 - _v10._0._0),
                                         "ms\nnew best time!") : A2($Basics._op["++"],
                                         "+",
                                         A2($Basics._op["++"],
                                         $Basics.toString(_v10._1._0 - _v10._0._0),
                                         "ms\ntry again?"));}
                                    break;}
                               break;}
                          return "";
                       }();
                    }();
                  case "Nothing":
                  return function () {
                       var _v15 = _v5.player.handle;
                       switch (_v15.ctor)
                       {case "Just":
                          return "you did it!";
                          case "Nothing":
                          return "please create an account to save your run";}
                       _U.badCase($moduleName,
                       "between lines 171 and 173");
                    }();}
               _U.badCase($moduleName,
               "between lines 157 and 173");
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
   var getFinishingStatus = function (_v17) {
      return function () {
         return function () {
            var _v19 = _v17.playerState.nextGate;
            switch (_v19.ctor)
            {case "Just":
               switch (_v19._0.ctor)
                 {case "StartLine":
                    return "go!";}
                 break;
               case "Nothing":
               return "finished";}
            return A2(getGatesCount,
            _v17.course,
            _v17.playerState);
         }();
      }();
   };
   var getSubStatus = function (_v21) {
      return function () {
         return function () {
            var s = function () {
               var _v23 = _v21.startTime;
               switch (_v23.ctor)
               {case "Just":
                  return _U.cmp(_v23._0,
                    _v21.now) > 0 ? "be ready" : getFinishingStatus(_v21);
                  case "Nothing":
                  return $Render$Utils.startCountdownMessage;}
               _U.badCase($moduleName,
               "between lines 130 and 137");
            }();
            return $Graphics$Element.centered($Render$Utils.baseText(s));
         }();
      }();
   };
   var getTimer = function (_v25) {
      return function () {
         return function () {
            var _v27 = _v25.startTime;
            switch (_v27.ctor)
            {case "Just":
               return function () {
                    var timer = $Core.isNothing(_v25.playerState.nextGate) ? A2($Maybe.withDefault,
                    0,
                    $List.head(_v25.playerState.crossedGates)) : _v27._0 - _v25.now;
                    return A2($Render$Utils.formatTimer,
                    timer,
                    $Core.isNothing(_v25.playerState.nextGate));
                 }();
               case "Nothing":
               return "start pending";}
            _U.badCase($moduleName,
            "between lines 112 and 122");
         }();
      }();
   };
   var getMainStatus = function (_v29) {
      return function () {
         return function () {
            var s = getTimer(_v29);
            var op = $Game.isStarted(_v29) ? 0.5 : 1;
            return $Graphics$Element.opacity(op)($Graphics$Element.centered($Render$Utils.bigText(s)));
         }();
      }();
   };
   var topCenterElements = function (gameState) {
      return _L.fromArray([getMainStatus(gameState)
                          ,getSubStatus(gameState)]);
   };
   var getHelp = function (gameState) {
      return $Graphics$Element.opacity(0.8)($Graphics$Element.leftAligned($Render$Utils.baseText($Render$Utils.helpMessage)));
   };
   var buildBoardLine = function (_v31) {
      return function () {
         return function () {
            var deltaText = $Maybe.withDefault("-")(A2($Maybe.map,
            function (d) {
               return A2($Basics._op["++"],
               "+",
               $Basics.toString(d / 1000));
            },
            _v31.delta));
            var handleText = $Render$Utils.fixedLength(12)(A2($Maybe.withDefault,
            "Anonymous",
            _v31.handle));
            var positionText = $Maybe.withDefault("  ")(A2($Maybe.map,
            function (p) {
               return A2($Basics._op["++"],
               $Basics.toString(p),
               ".");
            },
            _v31.position));
            return $Graphics$Element.leftAligned($Render$Utils.baseText(A2($String.join,
            " ",
            _L.fromArray([positionText
                         ,handleText
                         ,deltaText]))));
         }();
      }();
   };
   var getPlayerEntry = function (player) {
      return function () {
         var line = {_: {}
                    ,delta: $Maybe.Nothing
                    ,handle: player.handle
                    ,id: player.id
                    ,position: $Maybe.Nothing};
         return buildBoardLine(line);
      }();
   };
   var getPlayerEntries = function (_v33) {
      return function () {
         return function () {
            var players = A2($List._op["::"],
            _v33.playerState.player,
            A2($List.map,
            function (_) {
               return _.player;
            },
            _v33.opponents));
            return $Graphics$Element.flow($Graphics$Element.down)(A2($List.map,
            getPlayerEntry,
            players));
         }();
      }();
   };
   var getLeaderboardLine = F3(function (leaderTally,
   position,
   tally) {
      return function () {
         var delta = _U.eq($List.length(tally.gates),
         $List.length(leaderTally.gates)) ? function () {
            var _v35 = {ctor: "_Tuple2"
                       ,_0: $List.head(tally.gates)
                       ,_1: $List.head(leaderTally.gates)};
            switch (_v35.ctor)
            {case "_Tuple2":
               switch (_v35._0.ctor)
                 {case "Just":
                    switch (_v35._1.ctor)
                      {case "Just":
                         return $Maybe.Just(_v35._0._0 - _v35._1._0);}
                      break;}
                 break;}
            return $Maybe.Nothing;
         }() : $Maybe.Nothing;
         var line = {_: {}
                    ,delta: delta
                    ,handle: tally.playerHandle
                    ,id: tally.playerId
                    ,position: $Maybe.Just(position + 1)};
         return buildBoardLine(line);
      }();
   });
   var getLeaderboard = function (_v40) {
      return function () {
         return function () {
            var showLeader = function (leader) {
               return $Graphics$Element.flow($Graphics$Element.down)(A2($List.indexedMap,
               getLeaderboardLine(leader),
               _v40.leaderboard));
            };
            return $Maybe.withDefault($Graphics$Element.empty)(A2($Maybe.map,
            showLeader,
            $List.head(_v40.leaderboard)));
         }();
      }();
   };
   var getBoard = function (gameState) {
      return $List.isEmpty(gameState.leaderboard) ? getPlayerEntries(gameState) : getLeaderboard(gameState);
   };
   var topLeftElements = function (gameState) {
      return _L.fromArray([getBoard(gameState)
                          ,getHelp(gameState)]);
   };
   var buildDashboard = F2(function (gameState,
   _v42) {
      return function () {
         switch (_v42.ctor)
         {case "_Tuple2": return {_: {}
                                 ,bottomCenter: _L.fromArray([])
                                 ,topCenter: topCenterElements(gameState)
                                 ,topLeft: topLeftElements(gameState)
                                 ,topRight: topRightElements(gameState)};}
         _U.badCase($moduleName,
         "between lines 239 and 243");
      }();
   });
   var BoardLine = F4(function (a,
   b,
   c,
   d) {
      return {_: {}
             ,delta: d
             ,handle: b
             ,id: a
             ,position: c};
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
                                  ,getPlayerEntry: getPlayerEntry
                                  ,getPlayerEntries: getPlayerEntries
                                  ,getLeaderboardLine: getLeaderboardLine
                                  ,getLeaderboard: getLeaderboard
                                  ,getBoard: getBoard
                                  ,getHelp: getHelp
                                  ,getMainStatus: getMainStatus
                                  ,getTimer: getTimer
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
Elm.Render.Gates = Elm.Render.Gates || {};
Elm.Render.Gates.make = function (_elm) {
   "use strict";
   _elm.Render = _elm.Render || {};
   _elm.Render.Gates = _elm.Render.Gates || {};
   if (_elm.Render.Gates.values)
   return _elm.Render.Gates.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   $moduleName = "Render.Gates",
   $Basics = Elm.Basics.make(_elm),
   $Color = Elm.Color.make(_elm),
   $Core = Elm.Core.make(_elm),
   $Game = Elm.Game.make(_elm),
   $Geo = Elm.Geo.make(_elm),
   $Graphics$Collage = Elm.Graphics.Collage.make(_elm),
   $List = Elm.List.make(_elm),
   $Maybe = Elm.Maybe.make(_elm),
   $Render$Utils = Elm.Render.Utils.make(_elm),
   $Result = Elm.Result.make(_elm),
   $Signal = Elm.Signal.make(_elm),
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
               "on line 180, column 24 to 61");
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
   var renderGateMark = function (position) {
      return function () {
         var outer = $Graphics$Collage.outlined($Graphics$Collage.solid($Color.white))($Graphics$Collage.circle($Game.markRadius));
         var inner = $Graphics$Collage.filled($Render$Utils.colors.orange)($Graphics$Collage.circle($Game.markRadius));
         return $Graphics$Collage.move(position)($Graphics$Collage.group(_L.fromArray([inner
                                                                                      ,outer])));
      }();
   };
   var renderGateMarks = function (gate) {
      return function () {
         var $ = $Game.getGateMarks(gate),
         left = $._0,
         right = $._1;
         return $Graphics$Collage.group(A2($List.map,
         renderGateMark,
         _L.fromArray([left,right])));
      }();
   };
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
   var renderStraightArrow = F2(function (bottomUp,
   timer) {
      return function () {
         var arrowY = A2($Core.floatMod,
         timer * 2.0e-2,
         30);
         var way = bottomUp ? 1 : -1;
         var l = $Game.markRadius;
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
         var lineLength = $Game.markRadius * 4;
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
   var renderStartLine = F3(function (gate,
   started,
   timer) {
      return function () {
         var helper = started ? $Graphics$Collage.move({ctor: "_Tuple2"
                                                       ,_0: 0
                                                       ,_1: gate.y - $Game.markRadius * 3})(A2(renderStraightArrow,
         true,
         timer)) : $Render$Utils.emptyForm;
         var marks = renderGateMarks(gate);
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
   var renderFinishLine = F2(function (gate,
   timer) {
      return function () {
         var marks = renderGateMarks(gate);
         var a = gateLineOpacity(timer);
         var line = $Graphics$Collage.alpha(a)(A2(renderGateLine,
         gate,
         nextLineStyle));
         var helper = $Graphics$Collage.alpha(a * 0.5)($Graphics$Collage.move({ctor: "_Tuple2"
                                                                              ,_0: 0
                                                                              ,_1: gate.y + $Game.markRadius * 3})(A2(renderStraightArrow,
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
   var renderAroundArrow = F3(function (headAngle,
   clockwise,
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
         var r = $Game.markRadius * 4;
         var arc = $Graphics$Collage.traced(arrowLineStyle)($Graphics$Collage.path(A4(arcShape,
         r,
         headAngle + currentSlidingAngle,
         arcAngle,
         way)));
         var arrow = $Graphics$Collage.move($Basics.fromPolar({ctor: "_Tuple2"
                                                              ,_0: r
                                                              ,_1: arrowRad}))($Graphics$Collage.rotate(arrowRad - $Basics.pi / 2)($Graphics$Collage.traced(arrowLineStyle)($Graphics$Collage.path(arrowTip($Game.markRadius)))));
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
   var renderGateHelpers = F3(function (gate,
   gateLoc,
   timer) {
      return function () {
         var $ = function () {
            switch (gateLoc.ctor)
            {case "Downwind":
               return {ctor: "_Tuple2"
                      ,_0: aroundLeftDownwind(timer)
                      ,_1: aroundRightDownwind(timer)};
               case "Upwind":
               return {ctor: "_Tuple2"
                      ,_0: aroundLeftUpwind(timer)
                      ,_1: aroundRightUpwind(timer)};}
            _U.badCase($moduleName,
            "between lines 126 and 129");
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
   var renderGate = F4(function (gate,
   timer,
   isNext,
   gateType) {
      return function () {
         var helpers = isNext ? A3(renderGateHelpers,
         gate,
         gateType,
         timer) : $Render$Utils.emptyForm;
         var marks = renderGateMarks(gate);
         var a = gateLineOpacity(timer);
         var line = isNext ? $Graphics$Collage.alpha(a)(A2(renderGateLine,
         gate,
         nextLineStyle)) : $Render$Utils.emptyForm;
         return $Graphics$Collage.group(_L.fromArray([line
                                                     ,marks
                                                     ,helpers]));
      }();
   });
   var Downwind = {ctor: "Downwind"};
   var Upwind = {ctor: "Upwind"};
   _elm.Render.Gates.values = {_op: _op
                              ,Upwind: Upwind
                              ,Downwind: Downwind
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
                              ,renderGateHelpers: renderGateHelpers
                              ,renderStartLine: renderStartLine
                              ,renderGate: renderGate
                              ,renderFinishLine: renderFinishLine
                              ,renderGateLaylines: renderGateLaylines};
   return _elm.Render.Gates.values;
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
   $Result = Elm.Result.make(_elm),
   $Signal = Elm.Signal.make(_elm),
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
            ,_1: -25}))($Graphics$Collage.toForm($Graphics$Element.centered($Render$Utils.baseText(A2($Maybe.withDefault,
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
   var renderWindShadow = function (_v2) {
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
                                 ,_0: $Game.windShadowLength
                                 ,_1: $Core.toRadians(_v2.shadowDirection + a)}));
            },
            arcAngles);
            return $Graphics$Collage.alpha(0.1)($Graphics$Collage.filled($Color.white)($Graphics$Collage.path(A2($List._op["::"],
            _v2.position,
            endPoints))));
         }();
      }();
   };
   var renderOpponent = function (_v4) {
      return function () {
         return function () {
            var name = $Graphics$Collage.alpha(0.3)($Graphics$Collage.move(A2($Geo.add,
            _v4.state.position,
            {ctor: "_Tuple2"
            ,_0: 0
            ,_1: -25}))($Graphics$Collage.toForm($Graphics$Element.centered($Render$Utils.baseText(A2($Maybe.withDefault,
            "Anonymous",
            _v4.player.handle))))));
            var shadow = renderWindShadow(_v4.state);
            var hull = $Graphics$Collage.alpha(0.5)($Graphics$Collage.move(_v4.state.position)(A2(rotateHull,
            _v4.state.heading,
            baseHull)));
            return $Graphics$Collage.group(_L.fromArray([shadow
                                                        ,hull
                                                        ,name]));
         }();
      }();
   };
   var renderOpponents = F2(function (course,
   opponents) {
      return $Graphics$Collage.group(A2($List.map,
      renderOpponent,
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
         var renderSegment = function (_v6) {
            return function () {
               switch (_v6.ctor)
               {case "_Tuple2":
                  switch (_v6._1.ctor)
                    {case "_Tuple2":
                       return $Graphics$Collage.alpha(opacityForIndex(_v6._0))($Graphics$Collage.traced(style)(A2($Graphics$Collage.segment,
                         _v6._1._0,
                         _v6._1._1)));}
                    break;}
               _U.badCase($moduleName,
               "on line 80, column 31 to 86");
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
         $Maybe.withDefault(_L.fromArray([]))($List.tail(wake))));
         return $Graphics$Collage.group(A2($List.map,
         renderSegment,
         pairs));
      }();
   };
   var renderEqualityLine = F2(function (_v12,
   windOrigin) {
      return function () {
         switch (_v12.ctor)
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
         "between lines 66 and 70");
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
                                                                                                   ,_1: windOriginRadians + $Basics.pi}))($Graphics$Collage.toForm($Graphics$Element.centered((_U.eq(player.controlMode,
         $Game.FixedAngle) ? $Text.line($Text.Under) : $Basics.identity)($Render$Utils.baseText(A2($Basics._op["++"],
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
   var renderPlayer = F2(function (displayWindShadow,
   state) {
      return function () {
         var wake = renderWake(state.trail);
         var eqLine = A2(renderEqualityLine,
         state.position,
         state.windOrigin);
         var vmgSign = renderVmgSign(state);
         var angles = renderPlayerAngles(state);
         var windShadow = displayWindShadow ? renderWindShadow($Game.asOpponentState(state)) : $Render$Utils.emptyForm;
         var hull = A2(rotateHull,
         state.heading,
         baseHull);
         var movingPart = $Graphics$Collage.move(state.position)($Graphics$Collage.group(_L.fromArray([angles
                                                                                                      ,vmgSign
                                                                                                      ,eqLine
                                                                                                      ,hull])));
         return $Graphics$Collage.group(_L.fromArray([wake
                                                     ,windShadow
                                                     ,movingPart]));
      }();
   });
   var renderPlayers = function (_v16) {
      return function () {
         return function () {
            var mainPlayer = A2(renderPlayer,
            true,
            _v16.playerState);
            var forms = _L.fromArray([A2(renderOpponents,
                                     _v16.course,
                                     _v16.opponents)
                                     ,renderGhosts(_v16.ghosts)
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
   $moduleName = "Render.Utils",
   $Basics = Elm.Basics.make(_elm),
   $Color = Elm.Color.make(_elm),
   $Game = Elm.Game.make(_elm),
   $Graphics$Collage = Elm.Graphics.Collage.make(_elm),
   $Graphics$Element = Elm.Graphics.Element.make(_elm),
   $List = Elm.List.make(_elm),
   $Maybe = Elm.Maybe.make(_elm),
   $Result = Elm.Result.make(_elm),
   $Signal = Elm.Signal.make(_elm),
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
            var _v2 = _v0.startTime;
            switch (_v2.ctor)
            {case "Just":
               return _U.cmp(_v0.now,
                 _v2._0) < 0 ? A2(formatTimer,
                 _v2._0 - _v0.now,
                 false) : "Started";
               case "Nothing":
               return A2($Basics._op["++"],
                 "(",
                 A2($Basics._op["++"],
                 $Basics.toString(1 + $List.length(_v0.opponents)),
                 ") Waiting..."));}
            _U.badCase($moduleName,
            "between lines 71 and 78");
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
   var startCountdownMessage = "press C to start countdown (30s)";
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
         "between lines 164 and 166");
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
         "between lines 126 and 128");
      }();
   });
   var Ok = function (a) {
      return {ctor: "Ok",_0: a};
   };
   var map = F2(function (func,
   ra) {
      return function () {
         switch (ra.ctor)
         {case "Err": return Err(ra._0);
            case "Ok":
            return Ok(func(ra._0));}
         _U.badCase($moduleName,
         "between lines 41 and 43");
      }();
   });
   var map2 = F3(function (func,
   ra,
   rb) {
      return function () {
         var _v9 = {ctor: "_Tuple2"
                   ,_0: ra
                   ,_1: rb};
         switch (_v9.ctor)
         {case "_Tuple2":
            switch (_v9._0.ctor)
              {case "Err":
                 return Err(_v9._0._0);
                 case "Ok": switch (_v9._1.ctor)
                   {case "Ok": return Ok(A2(func,
                        _v9._0._0,
                        _v9._1._0));}
                   break;}
              switch (_v9._1.ctor)
              {case "Err":
                 return Err(_v9._1._0);}
              break;}
         _U.badCase($moduleName,
         "between lines 55 and 58");
      }();
   });
   var map3 = F4(function (func,
   ra,
   rb,
   rc) {
      return function () {
         var _v16 = {ctor: "_Tuple3"
                    ,_0: ra
                    ,_1: rb
                    ,_2: rc};
         switch (_v16.ctor)
         {case "_Tuple3":
            switch (_v16._0.ctor)
              {case "Err":
                 return Err(_v16._0._0);
                 case "Ok": switch (_v16._1.ctor)
                   {case "Ok":
                      switch (_v16._2.ctor)
                        {case "Ok": return Ok(A3(func,
                             _v16._0._0,
                             _v16._1._0,
                             _v16._2._0));}
                        break;}
                   break;}
              switch (_v16._1.ctor)
              {case "Err":
                 return Err(_v16._1._0);}
              switch (_v16._2.ctor)
              {case "Err":
                 return Err(_v16._2._0);}
              break;}
         _U.badCase($moduleName,
         "between lines 63 and 67");
      }();
   });
   var map4 = F5(function (func,
   ra,
   rb,
   rc,
   rd) {
      return function () {
         var _v26 = {ctor: "_Tuple4"
                    ,_0: ra
                    ,_1: rb
                    ,_2: rc
                    ,_3: rd};
         switch (_v26.ctor)
         {case "_Tuple4":
            switch (_v26._0.ctor)
              {case "Err":
                 return Err(_v26._0._0);
                 case "Ok": switch (_v26._1.ctor)
                   {case "Ok":
                      switch (_v26._2.ctor)
                        {case "Ok":
                           switch (_v26._3.ctor)
                             {case "Ok": return Ok(A4(func,
                                  _v26._0._0,
                                  _v26._1._0,
                                  _v26._2._0,
                                  _v26._3._0));}
                             break;}
                        break;}
                   break;}
              switch (_v26._1.ctor)
              {case "Err":
                 return Err(_v26._1._0);}
              switch (_v26._2.ctor)
              {case "Err":
                 return Err(_v26._2._0);}
              switch (_v26._3.ctor)
              {case "Err":
                 return Err(_v26._3._0);}
              break;}
         _U.badCase($moduleName,
         "between lines 72 and 77");
      }();
   });
   var map5 = F6(function (func,
   ra,
   rb,
   rc,
   rd,
   re) {
      return function () {
         var _v39 = {ctor: "_Tuple5"
                    ,_0: ra
                    ,_1: rb
                    ,_2: rc
                    ,_3: rd
                    ,_4: re};
         switch (_v39.ctor)
         {case "_Tuple5":
            switch (_v39._0.ctor)
              {case "Err":
                 return Err(_v39._0._0);
                 case "Ok": switch (_v39._1.ctor)
                   {case "Ok":
                      switch (_v39._2.ctor)
                        {case "Ok":
                           switch (_v39._3.ctor)
                             {case "Ok":
                                switch (_v39._4.ctor)
                                  {case "Ok": return Ok(A5(func,
                                       _v39._0._0,
                                       _v39._1._0,
                                       _v39._2._0,
                                       _v39._3._0,
                                       _v39._4._0));}
                                  break;}
                             break;}
                        break;}
                   break;}
              switch (_v39._1.ctor)
              {case "Err":
                 return Err(_v39._1._0);}
              switch (_v39._2.ctor)
              {case "Err":
                 return Err(_v39._2._0);}
              switch (_v39._3.ctor)
              {case "Err":
                 return Err(_v39._3._0);}
              switch (_v39._4.ctor)
              {case "Err":
                 return Err(_v39._4._0);}
              break;}
         _U.badCase($moduleName,
         "between lines 82 and 88");
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
         "between lines 148 and 150");
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
         "between lines 180 and 182");
      }();
   });
   _elm.Result.values = {_op: _op
                        ,map: map
                        ,map2: map2
                        ,map3: map3
                        ,map4: map4
                        ,map5: map5
                        ,andThen: andThen
                        ,toMaybe: toMaybe
                        ,fromMaybe: fromMaybe
                        ,formatError: formatError
                        ,Ok: Ok
                        ,Err: Err};
   return _elm.Result.values;
};
Elm.Set = Elm.Set || {};
Elm.Set.make = function (_elm) {
   "use strict";
   _elm.Set = _elm.Set || {};
   if (_elm.Set.values)
   return _elm.Set.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   $moduleName = "Set",
   $Dict = Elm.Dict.make(_elm),
   $List = Elm.List.make(_elm);
   var partition = F2(function (p,
   set) {
      return A2($Dict.partition,
      F2(function (k,_v0) {
         return function () {
            return p(k);
         }();
      }),
      set);
   });
   var filter = F2(function (p,
   set) {
      return A2($Dict.filter,
      F2(function (k,_v2) {
         return function () {
            return p(k);
         }();
      }),
      set);
   });
   var foldr = F3(function (f,
   b,
   s) {
      return A3($Dict.foldr,
      F3(function (k,_v4,b) {
         return function () {
            return A2(f,k,b);
         }();
      }),
      b,
      s);
   });
   var foldl = F3(function (f,
   b,
   s) {
      return A3($Dict.foldl,
      F3(function (k,_v6,b) {
         return function () {
            return A2(f,k,b);
         }();
      }),
      b,
      s);
   });
   var toList = $Dict.keys;
   var diff = $Dict.diff;
   var intersect = $Dict.intersect;
   var union = $Dict.union;
   var member = $Dict.member;
   var isEmpty = $Dict.isEmpty;
   var remove = $Dict.remove;
   var insert = function (k) {
      return A2($Dict.insert,
      k,
      {ctor: "_Tuple0"});
   };
   var singleton = function (k) {
      return A2($Dict.singleton,
      k,
      {ctor: "_Tuple0"});
   };
   var empty = $Dict.empty;
   var fromList = function (xs) {
      return A3($List.foldl,
      insert,
      empty,
      xs);
   };
   var map = F2(function (f,s) {
      return fromList(A2($List.map,
      f,
      toList(s)));
   });
   _elm.Set.values = {_op: _op
                     ,empty: empty
                     ,singleton: singleton
                     ,insert: insert
                     ,remove: remove
                     ,isEmpty: isEmpty
                     ,member: member
                     ,foldl: foldl
                     ,foldr: foldr
                     ,map: map
                     ,filter: filter
                     ,partition: partition
                     ,union: union
                     ,intersect: intersect
                     ,diff: diff
                     ,toList: toList
                     ,fromList: fromList};
   return _elm.Set.values;
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
   $moduleName = "Signal",
   $Basics = Elm.Basics.make(_elm),
   $Debug = Elm.Debug.make(_elm),
   $List = Elm.List.make(_elm),
   $Maybe = Elm.Maybe.make(_elm),
   $Native$Signal = Elm.Native.Signal.make(_elm),
   $Task = Elm.Task.make(_elm);
   var send = F2(function (_v0,
   value) {
      return function () {
         switch (_v0.ctor)
         {case "Address":
            return A2($Task.onError,
              _v0._0(value),
              function (_v3) {
                 return function () {
                    return $Task.succeed({ctor: "_Tuple0"});
                 }();
              });}
         _U.badCase($moduleName,
         "between lines 370 and 371");
      }();
   });
   var Message = function (a) {
      return {ctor: "Message"
             ,_0: a};
   };
   var message = F2(function (_v5,
   value) {
      return function () {
         switch (_v5.ctor)
         {case "Address":
            return Message(_v5._0(value));}
         _U.badCase($moduleName,
         "on line 352, column 5 to 24");
      }();
   });
   var mailbox = $Native$Signal.mailbox;
   var Address = function (a) {
      return {ctor: "Address"
             ,_0: a};
   };
   var forwardTo = F2(function (_v8,
   f) {
      return function () {
         switch (_v8.ctor)
         {case "Address":
            return Address(function (x) {
                 return _v8._0(f(x));
              });}
         _U.badCase($moduleName,
         "on line 339, column 5 to 29");
      }();
   });
   var Mailbox = F2(function (a,
   b) {
      return {_: {}
             ,address: a
             ,signal: b};
   });
   var sampleOn = $Native$Signal.sampleOn;
   var dropRepeats = $Native$Signal.dropRepeats;
   var filterMap = $Native$Signal.filterMap;
   var filter = F3(function (isOk,
   base,
   signal) {
      return A3(filterMap,
      function (value) {
         return isOk(value) ? $Maybe.Just(value) : $Maybe.Nothing;
      },
      base,
      signal);
   });
   var merge = F2(function (left,
   right) {
      return A3($Native$Signal.genericMerge,
      $Basics.always,
      left,
      right);
   });
   var mergeMany = function (signalList) {
      return function () {
         var _v11 = $List.reverse(signalList);
         switch (_v11.ctor)
         {case "::":
            return A3($List.foldl,
              merge,
              _v11._0,
              _v11._1);
            case "[]":
            return $Debug.crash("mergeMany was given an empty list!");}
         _U.badCase($moduleName,
         "between lines 177 and 182");
      }();
   };
   var foldp = $Native$Signal.foldp;
   var map5 = $Native$Signal.map5;
   var map4 = $Native$Signal.map4;
   var map3 = $Native$Signal.map3;
   var map2 = $Native$Signal.map2;
   _op["~"] = F2(function (funcs,
   args) {
      return A3(map2,
      F2(function (f,v) {
         return f(v);
      }),
      funcs,
      args);
   });
   var map = $Native$Signal.map;
   _op["<~"] = map;
   var constant = $Native$Signal.constant;
   var Signal = {ctor: "Signal"};
   _elm.Signal.values = {_op: _op
                        ,merge: merge
                        ,mergeMany: mergeMany
                        ,map: map
                        ,map2: map2
                        ,map3: map3
                        ,map4: map4
                        ,map5: map5
                        ,constant: constant
                        ,dropRepeats: dropRepeats
                        ,filter: filter
                        ,filterMap: filterMap
                        ,sampleOn: sampleOn
                        ,foldp: foldp
                        ,mailbox: mailbox
                        ,send: send
                        ,message: message
                        ,forwardTo: forwardTo
                        ,Mailbox: Mailbox};
   return _elm.Signal.values;
};
Elm.State = Elm.State || {};
Elm.State.make = function (_elm) {
   "use strict";
   _elm.State = _elm.State || {};
   if (_elm.State.values)
   return _elm.State.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   $moduleName = "State",
   $Basics = Elm.Basics.make(_elm),
   $Forms$Model = Elm.Forms.Model.make(_elm),
   $Game = Elm.Game.make(_elm),
   $List = Elm.List.make(_elm),
   $Maybe = Elm.Maybe.make(_elm),
   $Result = Elm.Result.make(_elm),
   $Signal = Elm.Signal.make(_elm);
   var initialForms = function (player) {
      return {_: {}
             ,login: {_: {}
                     ,email: ""
                     ,error: false
                     ,password: ""}
             ,setHandle: {_: {}
                         ,handle: A2($Maybe.withDefault,
                         "",
                         player.handle)}};
   };
   var RaceCourse = F5(function (a,
   b,
   c,
   d,
   e) {
      return {_: {}
             ,countdown: d
             ,course: c
             ,id: a
             ,slug: b
             ,startCycle: e};
   });
   var RaceCourseStatus = F2(function (a,
   b) {
      return {_: {}
             ,opponents: b
             ,raceCourse: a};
   });
   var AppState = F5(function (a,
   b,
   c,
   d,
   e) {
      return {_: {}
             ,courses: c
             ,forms: d
             ,gameState: e
             ,player: b
             ,screen: a};
   });
   var Play = function (a) {
      return {ctor: "Play",_0: a};
   };
   var Show = function (a) {
      return {ctor: "Show",_0: a};
   };
   var Home = {ctor: "Home"};
   var initialAppState = function (player) {
      return {_: {}
             ,courses: _L.fromArray([])
             ,forms: initialForms(player)
             ,gameState: $Maybe.Nothing
             ,player: player
             ,screen: Home};
   };
   _elm.State.values = {_op: _op
                       ,Home: Home
                       ,Show: Show
                       ,Play: Play
                       ,AppState: AppState
                       ,RaceCourseStatus: RaceCourseStatus
                       ,RaceCourse: RaceCourse
                       ,initialAppState: initialAppState
                       ,initialForms: initialForms};
   return _elm.State.values;
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
   $moduleName = "Steps",
   $Basics = Elm.Basics.make(_elm),
   $Core = Elm.Core.make(_elm),
   $Forms$Update = Elm.Forms.Update.make(_elm),
   $Game = Elm.Game.make(_elm),
   $Geo = Elm.Geo.make(_elm),
   $Inputs = Elm.Inputs.make(_elm),
   $List = Elm.List.make(_elm),
   $Maybe = Elm.Maybe.make(_elm),
   $Result = Elm.Result.make(_elm),
   $Signal = Elm.Signal.make(_elm),
   $State = Elm.State.make(_elm),
   $Steps$GateCrossing = Elm.Steps.GateCrossing.make(_elm),
   $Steps$Moving = Elm.Steps.Moving.make(_elm),
   $Steps$Turning = Elm.Steps.Turning.make(_elm),
   $Steps$Vmg = Elm.Steps.Vmg.make(_elm),
   $Steps$Wind = Elm.Steps.Wind.make(_elm);
   var runEscapeStep = F2(function (doEscape,
   playerState) {
      return function () {
         var crossedGates = doEscape ? _L.fromArray([]) : playerState.crossedGates;
         return _U.replace([["crossedGates"
                            ,crossedGates]],
         playerState);
      }();
   });
   var playerTimeStep = F2(function (elapsed,
   state) {
      return _U.replace([["time"
                         ,state.time + elapsed]],
      state);
   });
   var playerStep = F3(function (keyboardInput,
   elapsed,
   gameState) {
      return function () {
         var playerState = runEscapeStep(keyboardInput.escapeRun)(playerTimeStep(elapsed)(A2($Steps$GateCrossing.gateCrossingStep,
         gameState.playerState,
         gameState)(A2($Steps$Moving.movingStep,
         elapsed,
         gameState.course)($Steps$Vmg.vmgStep($Steps$Wind.windStep(gameState)(A3($Steps$Turning.turningStep,
         elapsed,
         keyboardInput,
         gameState.playerState)))))));
         return _U.replace([["playerState"
                            ,playerState]],
         gameState);
      }();
   });
   var moveOpponentState = F2(function (state,
   delta) {
      return function () {
         var position = A4($Geo.movePoint,
         state.position,
         delta,
         state.velocity,
         state.heading);
         return _U.replace([["position"
                            ,position]],
         state);
      }();
   });
   var updateOpponent = F3(function (previousMaybe,
   delta,
   opponent) {
      return function () {
         switch (previousMaybe.ctor)
         {case "Just":
            return _U.eq(previousMaybe._0.state.time,
              opponent.state.time) ? _U.replace([["state"
                                                 ,A2(moveOpponentState,
                                                 opponent.state,
                                                 delta)]],
              opponent) : opponent;
            case "Nothing":
            return opponent;}
         _U.badCase($moduleName,
         "between lines 91 and 98");
      }();
   });
   var updateOpponents = F3(function (previousOpponents,
   delta,
   newOpponents) {
      return function () {
         var findPrevious = function (o) {
            return A2($Core.find,
            function (po) {
               return _U.eq(po.player.id,
               o.player.id);
            },
            previousOpponents);
         };
         return A2($List.map,
         function (o) {
            return A3(updateOpponent,
            findPrevious(o),
            delta,
            o);
         },
         newOpponents);
      }();
   });
   var raceInputStep = F3(function (raceInput,
   _v2,
   _v3) {
      return function () {
         return function () {
            return function () {
               var wind = raceInput.wind;
               var $ = raceInput,
               serverNow = $.serverNow,
               startTime = $.startTime,
               opponents = $.opponents,
               ghosts = $.ghosts,
               leaderboard = $.leaderboard,
               initial = $.initial,
               clientTime = $.clientTime;
               var stalled = _U.eq(serverNow,
               _v3.serverNow);
               var roundTripDelay = stalled ? _v3.roundTripDelay : _v2.time - clientTime;
               var now = _v3.live ? _v3.now + _v2.delta : serverNow;
               var newPlayerState = _U.replace([["time"
                                                ,now]],
               _v3.playerState);
               var updatedOpponents = A3(updateOpponents,
               _v3.opponents,
               _v2.delta,
               opponents);
               return _U.replace([["opponents"
                                  ,updatedOpponents]
                                 ,["ghosts",ghosts]
                                 ,["wind",wind]
                                 ,["leaderboard",leaderboard]
                                 ,["serverNow",serverNow]
                                 ,["now",now]
                                 ,["playerState",newPlayerState]
                                 ,["startTime",startTime]
                                 ,["live",$Basics.not(initial)]
                                 ,["localTime",_v2.time]
                                 ,["roundTripDelay"
                                  ,roundTripDelay]],
               _v3);
            }();
         }();
      }();
   });
   var centerStep = function (gameState) {
      return function () {
         var newCenter = gameState.playerState.position;
         return _U.replace([["center"
                            ,newCenter]],
         gameState);
      }();
   };
   var gameStep = F2(function (_v6,
   gameState) {
      return function () {
         return centerStep(A2(playerStep,
         _v6.keyboardInput,
         _v6.clock.delta)(A3(raceInputStep,
         _v6.raceInput,
         _v6.clock,
         gameState)));
      }();
   });
   var actionStep = F2(function (action,
   appState) {
      return function () {
         switch (action.ctor)
         {case "FormAction":
            return _U.replace([["forms"
                               ,A2($Forms$Update.updateForms,
                               action._0,
                               appState.forms)]],
              appState);
            case "LiveUpdate":
            return _U.replace([["courses"
                               ,action._0.raceCourses]],
              appState);
            case "Navigate":
            return _U.replace([["screen"
                               ,action._0]],
              appState);
            case "PlayerUpdate":
            return _U.replace([["player"
                               ,action._0]],
              appState);}
         return appState;
      }();
   });
   var initGameState = F3(function (clock,
   appState,
   raceCourse) {
      return A3($Game.defaultGame,
      clock.time,
      raceCourse.course,
      appState.player);
   });
   var mainStep = F2(function (appInput,
   appState) {
      return function () {
         var newAppState = A2(actionStep,
         appInput.action,
         appState);
         var newGameState = function () {
            var _v13 = newAppState.screen;
            switch (_v13.ctor)
            {case "Play":
               return function () {
                    var gameState = A2($Maybe.withDefault,
                    A3(initGameState,
                    appInput.clock,
                    newAppState,
                    _v13._0),
                    appState.gameState);
                    return function () {
                       var _v15 = appInput.gameInput;
                       switch (_v15.ctor)
                       {case "Just":
                          return $Maybe.Just(A2(gameStep,
                            _v15._0,
                            gameState));
                          case "Nothing":
                          return $Maybe.Just(_U.replace([["now"
                                                         ,appInput.clock.time]],
                            gameState));}
                       _U.badCase($moduleName,
                       "between lines 31 and 36");
                    }();
                 }();}
            return $Maybe.Nothing;
         }();
         return _U.replace([["gameState"
                            ,newGameState]],
         newAppState);
      }();
   });
   _elm.Steps.values = {_op: _op
                       ,mainStep: mainStep
                       ,initGameState: initGameState
                       ,actionStep: actionStep
                       ,gameStep: gameStep
                       ,centerStep: centerStep
                       ,moveOpponentState: moveOpponentState
                       ,updateOpponent: updateOpponent
                       ,updateOpponents: updateOpponents
                       ,raceInputStep: raceInputStep
                       ,playerTimeStep: playerTimeStep
                       ,runEscapeStep: runEscapeStep
                       ,playerStep: playerStep};
   return _elm.Steps.values;
};
Elm.Steps = Elm.Steps || {};
Elm.Steps.GateCrossing = Elm.Steps.GateCrossing || {};
Elm.Steps.GateCrossing.make = function (_elm) {
   "use strict";
   _elm.Steps = _elm.Steps || {};
   _elm.Steps.GateCrossing = _elm.Steps.GateCrossing || {};
   if (_elm.Steps.GateCrossing.values)
   return _elm.Steps.GateCrossing.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   $moduleName = "Steps.GateCrossing",
   $Basics = Elm.Basics.make(_elm),
   $Game = Elm.Game.make(_elm),
   $Geo = Elm.Geo.make(_elm),
   $List = Elm.List.make(_elm),
   $Maybe = Elm.Maybe.make(_elm),
   $Result = Elm.Result.make(_elm),
   $Signal = Elm.Signal.make(_elm);
   var gateCrossedInX = F2(function (gate,
   _v0) {
      return function () {
         switch (_v0.ctor)
         {case "_Tuple2":
            switch (_v0._0.ctor)
              {case "_Tuple2":
                 switch (_v0._1.ctor)
                   {case "_Tuple2":
                      return function () {
                           var a = (_v0._0._1 - _v0._1._1) / (_v0._0._0 - _v0._1._0);
                           var b = _v0._0._1 - a * _v0._0._0;
                           var xGate = (gate.y - b) / a;
                           return _U.cmp($Basics.abs(xGate),
                           gate.width / 2) < 1;
                        }();}
                   break;}
              break;}
         _U.badCase($moduleName,
         "between lines 56 and 60");
      }();
   });
   var gateCrossedFromNorth = F2(function (gate,
   _v8) {
      return function () {
         switch (_v8.ctor)
         {case "_Tuple2":
            return _U.cmp($Basics.snd(_v8._0),
              gate.y) > 0 && (_U.cmp($Basics.snd(_v8._1),
              gate.y) < 1 && A2(gateCrossedInX,
              gate,
              {ctor: "_Tuple2"
              ,_0: _v8._0
              ,_1: _v8._1}));}
         _U.badCase($moduleName,
         "on line 64, column 4 to 71");
      }();
   });
   var gateCrossedFromSouth = F2(function (gate,
   _v12) {
      return function () {
         switch (_v12.ctor)
         {case "_Tuple2":
            return _U.cmp($Basics.snd(_v12._0),
              gate.y) < 0 && (_U.cmp($Basics.snd(_v12._1),
              gate.y) > -1 && A2(gateCrossedInX,
              gate,
              {ctor: "_Tuple2"
              ,_0: _v12._0
              ,_1: _v12._1}));}
         _U.badCase($moduleName,
         "on line 68, column 4 to 71");
      }();
   });
   var getNextGate = F2(function (course,
   crossedGates) {
      return _U.eq(crossedGates,
      course.laps * 2 + 1) ? $Maybe.Nothing : _U.eq(crossedGates,
      0) ? $Maybe.Just($Game.StartLine) : _U.eq(A2($Basics._op["%"],
      crossedGates,
      2),
      0) ? $Maybe.Just($Game.DownwindGate) : $Maybe.Just($Game.UpwindGate);
   });
   var gateCrossingStep = F3(function (previousState,
   _v16,
   _v17) {
      return function () {
         return function () {
            return function () {
               var t = $Game.raceTime(_v16);
               var started = $Game.isStarted(_v16);
               var step = {ctor: "_Tuple2"
                          ,_0: previousState.position
                          ,_1: _v17.position};
               var newCrossedGates = function () {
                  var _v20 = A2(getNextGate,
                  _v16.course,
                  $List.length(_v17.crossedGates));
                  switch (_v20.ctor)
                  {case "Just":
                     switch (_v20._0.ctor)
                       {case "DownwindGate":
                          return A2(gateCrossedFromNorth,
                            _v16.course.downwind,
                            step) ? A2($List._op["::"],
                            t,
                            _v17.crossedGates) : A2(gateCrossedFromNorth,
                            _v16.course.upwind,
                            step) ? $Maybe.withDefault(_L.fromArray([]))($List.tail(_v17.crossedGates)) : _v17.crossedGates;
                          case "StartLine":
                          return started && A2(gateCrossedFromSouth,
                            _v16.course.downwind,
                            step) ? A2($List._op["::"],
                            t,
                            _v17.crossedGates) : _v17.crossedGates;
                          case "UpwindGate":
                          return A2(gateCrossedFromSouth,
                            _v16.course.upwind,
                            step) ? A2($List._op["::"],
                            t,
                            _v17.crossedGates) : A2(gateCrossedFromSouth,
                            _v16.course.downwind,
                            step) ? $Maybe.withDefault(_L.fromArray([]))($List.tail(_v17.crossedGates)) : _v17.crossedGates;}
                       break;
                     case "Nothing":
                     return _v17.crossedGates;}
                  _U.badCase($moduleName,
                  "between lines 18 and 37");
               }();
               var nextGate = A2(getNextGate,
               _v16.course,
               $List.length(newCrossedGates));
               return _U.replace([["crossedGates"
                                  ,newCrossedGates]
                                 ,["nextGate",nextGate]],
               _v17);
            }();
         }();
      }();
   });
   _elm.Steps.GateCrossing.values = {_op: _op
                                    ,gateCrossingStep: gateCrossingStep
                                    ,getNextGate: getNextGate
                                    ,gateCrossedInX: gateCrossedInX
                                    ,gateCrossedFromNorth: gateCrossedFromNorth
                                    ,gateCrossedFromSouth: gateCrossedFromSouth};
   return _elm.Steps.GateCrossing.values;
};
Elm.Steps = Elm.Steps || {};
Elm.Steps.Moving = Elm.Steps.Moving || {};
Elm.Steps.Moving.make = function (_elm) {
   "use strict";
   _elm.Steps = _elm.Steps || {};
   _elm.Steps.Moving = _elm.Steps.Moving || {};
   if (_elm.Steps.Moving.values)
   return _elm.Steps.Moving.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   $moduleName = "Steps.Moving",
   $Basics = Elm.Basics.make(_elm),
   $Core = Elm.Core.make(_elm),
   $Game = Elm.Game.make(_elm),
   $Geo = Elm.Geo.make(_elm),
   $List = Elm.List.make(_elm),
   $Maybe = Elm.Maybe.make(_elm),
   $Result = Elm.Result.make(_elm),
   $Signal = Elm.Signal.make(_elm),
   $Steps$Util = Elm.Steps.Util.make(_elm);
   var isGrounded = F2(function (p,
   course) {
      return function () {
         var outOfBounds = $Basics.not(A2($Geo.inBox,
         p,
         $Game.areaBox(course.area)));
         var halfBoatWidth = $Game.boatWidth / 2;
         var onIsland = A2($Core.exists,
         function (i) {
            return _U.cmp(A2($Geo.distance,
            i.location,
            p),
            i.radius + halfBoatWidth) < 1;
         },
         course.islands);
         var $ = $Game.getGateMarks(course.upwind),
         ul = $._0,
         ur = $._1;
         var $ = $Game.getGateMarks(course.downwind),
         dl = $._0,
         dr = $._1;
         var marks = _L.fromArray([dl
                                  ,dr
                                  ,ul
                                  ,ur]);
         var stuckOnMark = A2($Core.exists,
         function (m) {
            return _U.cmp(A2($Geo.distance,
            p,
            m),
            $Game.markRadius + halfBoatWidth) < 1;
         },
         marks);
         return stuckOnMark || (outOfBounds || onIsland);
      }();
   });
   var maxAccel = 3.0e-2;
   var withInertia = F3(function (elapsed,
   previousVelocity,
   targetVelocity) {
      return function () {
         var velocityDelta = targetVelocity - previousVelocity;
         var accel = velocityDelta / elapsed;
         var realAccel = _U.cmp(accel,
         0) > 0 ? A2($Basics.min,
         accel,
         maxAccel) : A2($Basics.max,
         accel,
         0 - maxAccel);
         return previousVelocity + realAccel * elapsed;
      }();
   });
   var movingStep = F3(function (elapsed,
   course,
   state) {
      return _U.eq(elapsed,
      0) ? state : function () {
         var baseSpeed = A2($Steps$Util.polarSpeed,
         state.windSpeed,
         state.windAngle);
         var nextVelocity = A3(withInertia,
         elapsed,
         state.velocity,
         baseSpeed);
         var nextPosition = A4($Geo.movePoint,
         state.position,
         elapsed,
         nextVelocity,
         state.heading);
         var grounded = A2(isGrounded,
         nextPosition,
         course);
         var position = grounded ? state.position : nextPosition;
         var trail = A2($List.take,
         20,
         A2($List._op["::"],
         position,
         state.trail));
         var velocity = grounded ? 0 : nextVelocity;
         return _U.replace([["isGrounded"
                            ,grounded]
                           ,["velocity",velocity]
                           ,["position",position]
                           ,["trail",trail]],
         state);
      }();
   });
   _elm.Steps.Moving.values = {_op: _op
                              ,maxAccel: maxAccel
                              ,movingStep: movingStep
                              ,withInertia: withInertia
                              ,isGrounded: isGrounded};
   return _elm.Steps.Moving.values;
};
Elm.Steps = Elm.Steps || {};
Elm.Steps.Turning = Elm.Steps.Turning || {};
Elm.Steps.Turning.make = function (_elm) {
   "use strict";
   _elm.Steps = _elm.Steps || {};
   _elm.Steps.Turning = _elm.Steps.Turning || {};
   if (_elm.Steps.Turning.values)
   return _elm.Steps.Turning.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   $moduleName = "Steps.Turning",
   $Basics = Elm.Basics.make(_elm),
   $Game = Elm.Game.make(_elm),
   $Geo = Elm.Geo.make(_elm),
   $Inputs = Elm.Inputs.make(_elm),
   $List = Elm.List.make(_elm),
   $Maybe = Elm.Maybe.make(_elm),
   $Result = Elm.Result.make(_elm),
   $Signal = Elm.Signal.make(_elm);
   var autoVmgTarget = F2(function (state,
   input) {
      return $Basics.not($List.isEmpty(state.crossedGates)) && (state.isTurning && ($Basics.not($Inputs.manualTurn(input)) && _U.cmp($Basics.abs($Game.deltaToVmg(state)),
      $Basics.toFloat(state.player.vmgMagnet)) < 0)) ? $Maybe.Just($Game.windAngleOnVmg(state)) : $Maybe.Nothing;
   });
   var getTackTarget = F3(function (state,
   input,
   targetReached) {
      return $Inputs.manualTurn(input) ? $Maybe.Nothing : function () {
         var _v0 = state.tackTarget;
         switch (_v0.ctor)
         {case "Just":
            return targetReached ? $Maybe.Nothing : state.tackTarget;
            case "Nothing":
            return input.tack ? $Maybe.Just(0 - state.windAngle) : A2(autoVmgTarget,
              state,
              input);}
         _U.badCase($moduleName,
         "between lines 59 and 65");
      }();
   });
   var tackTargetReached = function (state) {
      return $Maybe.withDefault(false)(A2($Maybe.map,
      function (target) {
         return _U.cmp($Basics.abs(A2($Geo.angleDelta,
         state.windAngle,
         target)),
         1) < 0;
      },
      state.tackTarget));
   };
   var fast = 0.1;
   var autoTack = 8.0e-2;
   var slow = 3.0e-2;
   var getTurn = F4(function (tackTarget,
   state,
   input,
   elapsed) {
      return $Inputs.manualTurn(input) ? $Basics.toFloat(input.arrows.x) * elapsed * (input.subtleTurn ? slow : fast) : function () {
         switch (tackTarget.ctor)
         {case "Just":
            return function () {
                 var targetDelta = A2($Geo.angleDelta,
                 tackTarget._0,
                 state.windAngle);
                 var turn = elapsed * autoTack;
                 return _U.cmp($Basics.abs(targetDelta),
                 $Basics.abs(turn)) < 0 ? targetDelta : _U.cmp(targetDelta,
                 0) < 0 ? 0 - turn : turn;
              }();
            case "Nothing":
            return function () {
                 var _v4 = state.controlMode;
                 switch (_v4.ctor)
                 {case "FixedAngle":
                    return $Geo.ensure360(state.windOrigin + state.windAngle - state.heading);
                    case "FixedHeading": return 0;}
                 _U.badCase($moduleName,
                 "between lines 98 and 104");
              }();}
         _U.badCase($moduleName,
         "between lines 84 and 104");
      }();
   });
   var turningStep = F3(function (elapsed,
   input,
   state) {
      return function () {
         var targetReached = tackTargetReached(state);
         var tackTarget = A3(getTackTarget,
         state,
         input,
         targetReached);
         var turn = A4(getTurn,
         tackTarget,
         state,
         input,
         elapsed);
         var heading = $Geo.ensure360(state.heading + turn);
         var windAngle = A2($Geo.angleDelta,
         heading,
         state.windOrigin);
         var lock = input.lock || _U.cmp(input.arrows.y,
         0) > 0;
         var newControlMode = $Inputs.manualTurn(input) ? $Game.FixedHeading : lock || targetReached ? $Game.FixedAngle : state.controlMode;
         return _U.replace([["heading"
                            ,heading]
                           ,["windAngle",windAngle]
                           ,["isTurning"
                            ,$Inputs.isTurning(input)]
                           ,["tackTarget",tackTarget]
                           ,["controlMode"
                            ,newControlMode]],
         state);
      }();
   });
   _elm.Steps.Turning.values = {_op: _op
                               ,slow: slow
                               ,autoTack: autoTack
                               ,fast: fast
                               ,turningStep: turningStep
                               ,tackTargetReached: tackTargetReached
                               ,getTackTarget: getTackTarget
                               ,autoVmgTarget: autoVmgTarget
                               ,getTurn: getTurn};
   return _elm.Steps.Turning.values;
};
Elm.Steps = Elm.Steps || {};
Elm.Steps.Util = Elm.Steps.Util || {};
Elm.Steps.Util.make = function (_elm) {
   "use strict";
   _elm.Steps = _elm.Steps || {};
   _elm.Steps.Util = _elm.Steps.Util || {};
   if (_elm.Steps.Util.values)
   return _elm.Steps.Util.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   $moduleName = "Steps.Util",
   $Basics = Elm.Basics.make(_elm),
   $List = Elm.List.make(_elm),
   $Maybe = Elm.Maybe.make(_elm),
   $Result = Elm.Result.make(_elm),
   $Signal = Elm.Signal.make(_elm);
   var polarSpeed = F2(function (windSpeed,
   windAngle) {
      return function () {
         var x2 = $Basics.abs(windAngle);
         var x1 = windSpeed;
         var y = -2.067174789 * Math.pow(10,
         -3) * Math.pow(x1,
         3) - 1.868941044 * Math.pow(10,
         -4) * Math.pow(x1,
         2) * x2 - 1.03401471 * Math.pow(10,
         -4) * x1 * Math.pow(x2,
         2) - 1.86799863 * Math.pow(10,
         -5) * Math.pow(x2,
         3) + 7.376288713 * Math.pow(10,
         -2) * Math.pow(x1,
         2) + 3.19606466 * Math.pow(10,
         -2) * x1 * x2 + 2.939457021 * Math.pow(10,
         -3) * Math.pow(x2,
         2) - 8.575945237 * Math.pow(10,
         -1) * x1 + 9.427801906 * Math.pow(10,
         -5) * x2 + 4.342327445;
         return y * 2;
      }();
   });
   var knFactor = 1.852;
   var mpsToKn = function (mps) {
      return mps / knFactor / 1000 * 3600;
   };
   var knToMps = function (knot) {
      return knot * knFactor * 1000 / 3600;
   };
   _elm.Steps.Util.values = {_op: _op
                            ,knFactor: knFactor
                            ,mpsToKn: mpsToKn
                            ,knToMps: knToMps
                            ,polarSpeed: polarSpeed};
   return _elm.Steps.Util.values;
};
Elm.Steps = Elm.Steps || {};
Elm.Steps.Vmg = Elm.Steps.Vmg || {};
Elm.Steps.Vmg.make = function (_elm) {
   "use strict";
   _elm.Steps = _elm.Steps || {};
   _elm.Steps.Vmg = _elm.Steps.Vmg || {};
   if (_elm.Steps.Vmg.values)
   return _elm.Steps.Vmg.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   $moduleName = "Steps.Vmg",
   $Basics = Elm.Basics.make(_elm),
   $Core = Elm.Core.make(_elm),
   $Game = Elm.Game.make(_elm),
   $List = Elm.List.make(_elm),
   $Maybe = Elm.Maybe.make(_elm),
   $Result = Elm.Result.make(_elm),
   $Signal = Elm.Signal.make(_elm),
   $Steps$Util = Elm.Steps.Util.make(_elm);
   var getVmgValue = F2(function (windAngle,
   boatSpeed) {
      return $Basics.abs($Basics.sin($Core.toRadians(windAngle)) * boatSpeed);
   });
   var makeVmg = F2(function (windSpeed,
   windAngle) {
      return function () {
         var boatSpeed = A2($Steps$Util.polarSpeed,
         windSpeed,
         windAngle);
         var value = A2(getVmgValue,
         windAngle,
         boatSpeed);
         return {_: {}
                ,angle: windAngle
                ,speed: windSpeed
                ,value: value};
      }();
   });
   var findVmgInInterval = F3(function (windSpeed,
   minAngle,
   maxAngle) {
      return function () {
         var vmgs = A2($List.map,
         makeVmg(windSpeed),
         A2($Core.floatRange,
         minAngle,
         maxAngle));
         var bestMaybe = $List.head($List.reverse(A2($List.sortBy,
         function (_) {
            return _.value;
         },
         vmgs)));
         return A2($Maybe.withDefault,
         $Game.defaultVmg,
         bestMaybe);
      }();
   });
   var getUpwindVmg = function (windSpeed) {
      return A3(findVmgInInterval,
      windSpeed,
      40,
      60);
   };
   var getDownwindVmg = function (windSpeed) {
      return A3(findVmgInInterval,
      windSpeed,
      130,
      150);
   };
   var vmgStep = function (state) {
      return function () {
         var downwindVmg = getDownwindVmg(state.windSpeed);
         var upwindVmg = getUpwindVmg(state.windSpeed);
         var vmgValue = A2(getVmgValue,
         state.windAngle,
         state.velocity);
         return _U.replace([["vmgValue"
                            ,vmgValue]
                           ,["upwindVmg",upwindVmg]
                           ,["downwindVmg",downwindVmg]],
         state);
      }();
   };
   _elm.Steps.Vmg.values = {_op: _op
                           ,vmgStep: vmgStep
                           ,makeVmg: makeVmg
                           ,getVmgValue: getVmgValue
                           ,getUpwindVmg: getUpwindVmg
                           ,getDownwindVmg: getDownwindVmg
                           ,findVmgInInterval: findVmgInInterval};
   return _elm.Steps.Vmg.values;
};
Elm.Steps = Elm.Steps || {};
Elm.Steps.Wind = Elm.Steps.Wind || {};
Elm.Steps.Wind.make = function (_elm) {
   "use strict";
   _elm.Steps = _elm.Steps || {};
   _elm.Steps.Wind = _elm.Steps.Wind || {};
   if (_elm.Steps.Wind.values)
   return _elm.Steps.Wind.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   $moduleName = "Steps.Wind",
   $Basics = Elm.Basics.make(_elm),
   $Game = Elm.Game.make(_elm),
   $Geo = Elm.Geo.make(_elm),
   $List = Elm.List.make(_elm),
   $Maybe = Elm.Maybe.make(_elm),
   $Result = Elm.Result.make(_elm),
   $Signal = Elm.Signal.make(_elm);
   var gustEffect = F3(function (state,
   wind,
   gust) {
      return function () {
         var speedEffect = gust.speed;
         var originEffect = A2($Geo.angleDelta,
         gust.angle,
         wind.origin);
         var d = A2($Geo.distance,
         state.position,
         gust.position);
         var fromEdge = gust.radius - d;
         var factor = A2($Basics.min,
         fromEdge / (gust.radius * 0.2),
         1);
         return {_: {}
                ,factor: factor
                ,origin: originEffect
                ,speed: speedEffect};
      }();
   });
   var shadowArc = 30;
   var windShadowSector = function (_v0) {
      return function () {
         return {ctor: "_Tuple2"
                ,_0: $Geo.ensure360(_v0.shadowDirection - shadowArc / 2)
                ,_1: $Geo.ensure360(_v0.shadowDirection + shadowArc / 2)};
      }();
   };
   var isShadowedBy = F2(function (state,
   opponent) {
      return _U.cmp(A2($Geo.distance,
      opponent.state.position,
      state.position),
      $Game.windShadowLength) < 1 && function () {
         var $ = windShadowSector(opponent.state),
         min = $._0,
         max = $._1;
         var angle = A2($Geo.angleBetween,
         opponent.state.position,
         state.position);
         return A3($Geo.inSector,
         min,
         max,
         angle);
      }();
   });
   var shadowImpact = -5;
   var windStep = F2(function (_v2,
   state) {
      return function () {
         return function () {
            var windShadow = $List.sum($List.map(function (_v4) {
               return function () {
                  return shadowImpact;
               }();
            })(A2($List.filter,
            isShadowedBy(state),
            _v2.opponents)));
            var gustsOnPlayer = A2($List.filter,
            function (g) {
               return _U.cmp(A2($Geo.distance,
               state.position,
               g.position),
               g.radius) < 0;
            },
            _v2.wind.gusts);
            var gustsEffects = A2($List.map,
            A2(gustEffect,state,_v2.wind),
            gustsOnPlayer);
            var origin = $List.isEmpty(gustsEffects) ? _v2.wind.origin : function () {
               var totalEffect = $List.sum(A2($List.map,
               function (g) {
                  return g.origin * g.factor;
               },
               gustsEffects));
               return $Geo.ensure360(_v2.wind.origin + totalEffect);
            }();
            var speed = _v2.wind.speed + $List.sum(A2($List.map,
            function (g) {
               return g.speed * g.factor;
            },
            gustsEffects)) + windShadow;
            var shadowDirection = $Geo.ensure360(state.windOrigin + 180 + state.windAngle / 3);
            return _U.replace([["windOrigin"
                               ,origin]
                              ,["windSpeed",speed]
                              ,["shadowDirection"
                               ,shadowDirection]],
            state);
         }();
      }();
   });
   var GustEffect = F3(function (a,
   b,
   c) {
      return {_: {}
             ,factor: c
             ,origin: a
             ,speed: b};
   });
   _elm.Steps.Wind.values = {_op: _op
                            ,GustEffect: GustEffect
                            ,shadowImpact: shadowImpact
                            ,shadowArc: shadowArc
                            ,windStep: windStep
                            ,gustEffect: gustEffect
                            ,isShadowedBy: isShadowedBy
                            ,windShadowSector: windShadowSector};
   return _elm.Steps.Wind.values;
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
                        ,length: length
                        ,reverse: reverse
                        ,repeat: repeat
                        ,cons: cons
                        ,uncons: uncons
                        ,fromChar: fromChar
                        ,append: append
                        ,concat: concat
                        ,split: split
                        ,join: join
                        ,words: words
                        ,lines: lines
                        ,slice: slice
                        ,left: left
                        ,right: right
                        ,dropLeft: dropLeft
                        ,dropRight: dropRight
                        ,contains: contains
                        ,startsWith: startsWith
                        ,endsWith: endsWith
                        ,indexes: indexes
                        ,indices: indices
                        ,toInt: toInt
                        ,toFloat: toFloat
                        ,toList: toList
                        ,fromList: fromList
                        ,toUpper: toUpper
                        ,toLower: toLower
                        ,pad: pad
                        ,padLeft: padLeft
                        ,padRight: padRight
                        ,trim: trim
                        ,trimLeft: trimLeft
                        ,trimRight: trimRight
                        ,map: map
                        ,filter: filter
                        ,foldl: foldl
                        ,foldr: foldr
                        ,any: any
                        ,all: all};
   return _elm.String.values;
};
Elm.Task = Elm.Task || {};
Elm.Task.make = function (_elm) {
   "use strict";
   _elm.Task = _elm.Task || {};
   if (_elm.Task.values)
   return _elm.Task.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   $moduleName = "Task",
   $List = Elm.List.make(_elm),
   $Maybe = Elm.Maybe.make(_elm),
   $Native$Task = Elm.Native.Task.make(_elm),
   $Result = Elm.Result.make(_elm);
   var sleep = $Native$Task.sleep;
   var spawn = $Native$Task.spawn;
   var ThreadID = function (a) {
      return {ctor: "ThreadID"
             ,_0: a};
   };
   var onError = $Native$Task.catch_;
   var andThen = $Native$Task.andThen;
   var fail = $Native$Task.fail;
   var mapError = F2(function (f,
   promise) {
      return A2(onError,
      promise,
      function (err) {
         return fail(f(err));
      });
   });
   var succeed = $Native$Task.succeed;
   var map = F2(function (func,
   promiseA) {
      return A2(andThen,
      promiseA,
      function (a) {
         return succeed(func(a));
      });
   });
   var map2 = F3(function (func,
   promiseA,
   promiseB) {
      return A2(andThen,
      promiseA,
      function (a) {
         return A2(andThen,
         promiseB,
         function (b) {
            return succeed(A2(func,a,b));
         });
      });
   });
   var map3 = F4(function (func,
   promiseA,
   promiseB,
   promiseC) {
      return A2(andThen,
      promiseA,
      function (a) {
         return A2(andThen,
         promiseB,
         function (b) {
            return A2(andThen,
            promiseC,
            function (c) {
               return succeed(A3(func,
               a,
               b,
               c));
            });
         });
      });
   });
   var map4 = F5(function (func,
   promiseA,
   promiseB,
   promiseC,
   promiseD) {
      return A2(andThen,
      promiseA,
      function (a) {
         return A2(andThen,
         promiseB,
         function (b) {
            return A2(andThen,
            promiseC,
            function (c) {
               return A2(andThen,
               promiseD,
               function (d) {
                  return succeed(A4(func,
                  a,
                  b,
                  c,
                  d));
               });
            });
         });
      });
   });
   var map5 = F6(function (func,
   promiseA,
   promiseB,
   promiseC,
   promiseD,
   promiseE) {
      return A2(andThen,
      promiseA,
      function (a) {
         return A2(andThen,
         promiseB,
         function (b) {
            return A2(andThen,
            promiseC,
            function (c) {
               return A2(andThen,
               promiseD,
               function (d) {
                  return A2(andThen,
                  promiseE,
                  function (e) {
                     return succeed(A5(func,
                     a,
                     b,
                     c,
                     d,
                     e));
                  });
               });
            });
         });
      });
   });
   var andMap = F2(function (promiseFunc,
   promiseValue) {
      return A2(andThen,
      promiseFunc,
      function (func) {
         return A2(andThen,
         promiseValue,
         function (value) {
            return succeed(func(value));
         });
      });
   });
   var sequence = function (promises) {
      return function () {
         switch (promises.ctor)
         {case "::": return A3(map2,
              F2(function (x,y) {
                 return A2($List._op["::"],
                 x,
                 y);
              }),
              promises._0,
              sequence(promises._1));
            case "[]":
            return succeed(_L.fromArray([]));}
         _U.badCase($moduleName,
         "between lines 101 and 106");
      }();
   };
   var toMaybe = function (task) {
      return A2(onError,
      A2(map,$Maybe.Just,task),
      function (_v3) {
         return function () {
            return succeed($Maybe.Nothing);
         }();
      });
   };
   var fromMaybe = F2(function ($default,
   maybe) {
      return function () {
         switch (maybe.ctor)
         {case "Just":
            return succeed(maybe._0);
            case "Nothing":
            return fail($default);}
         _U.badCase($moduleName,
         "between lines 139 and 141");
      }();
   });
   var toResult = function (task) {
      return A2(onError,
      A2(map,$Result.Ok,task),
      function (msg) {
         return succeed($Result.Err(msg));
      });
   };
   var fromResult = function (result) {
      return function () {
         switch (result.ctor)
         {case "Err":
            return fail(result._0);
            case "Ok":
            return succeed(result._0);}
         _U.badCase($moduleName,
         "between lines 151 and 153");
      }();
   };
   var Task = {ctor: "Task"};
   _elm.Task.values = {_op: _op
                      ,succeed: succeed
                      ,fail: fail
                      ,map: map
                      ,map2: map2
                      ,map3: map3
                      ,map4: map4
                      ,map5: map5
                      ,andMap: andMap
                      ,sequence: sequence
                      ,andThen: andThen
                      ,onError: onError
                      ,mapError: mapError
                      ,toMaybe: toMaybe
                      ,fromMaybe: fromMaybe
                      ,toResult: toResult
                      ,fromResult: fromResult
                      ,spawn: spawn
                      ,sleep: sleep};
   return _elm.Task.values;
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
   $moduleName = "Text",
   $Color = Elm.Color.make(_elm),
   $List = Elm.List.make(_elm),
   $Maybe = Elm.Maybe.make(_elm),
   $Native$Text = Elm.Native.Text.make(_elm);
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
                      ,fromString: fromString
                      ,empty: empty
                      ,append: append
                      ,concat: concat
                      ,join: join
                      ,link: link
                      ,style: style
                      ,defaultStyle: defaultStyle
                      ,typeface: typeface
                      ,monospace: monospace
                      ,height: height
                      ,color: color
                      ,bold: bold
                      ,italic: italic
                      ,line: line
                      ,Style: Style
                      ,Under: Under
                      ,Over: Over
                      ,Through: Through};
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
   $moduleName = "Time",
   $Basics = Elm.Basics.make(_elm),
   $Native$Signal = Elm.Native.Signal.make(_elm),
   $Native$Time = Elm.Native.Time.make(_elm),
   $Signal = Elm.Signal.make(_elm);
   var delay = $Native$Signal.delay;
   var since = F2(function (time,
   signal) {
      return function () {
         var stop = A2($Signal.map,
         $Basics.always(-1),
         A2(delay,time,signal));
         var start = A2($Signal.map,
         $Basics.always(1),
         signal);
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
   var timestamp = $Native$Signal.timestamp;
   var every = $Native$Time.every;
   var fpsWhen = $Native$Time.fpsWhen;
   var fps = function (targetFrames) {
      return A2(fpsWhen,
      targetFrames,
      $Signal.constant(true));
   };
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
                      ,timestamp: timestamp
                      ,delay: delay
                      ,since: since};
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
Elm.Views = Elm.Views || {};
Elm.Views.Home = Elm.Views.Home || {};
Elm.Views.Home.make = function (_elm) {
   "use strict";
   _elm.Views = _elm.Views || {};
   _elm.Views.Home = _elm.Views.Home || {};
   if (_elm.Views.Home.values)
   return _elm.Views.Home.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   $moduleName = "Views.Home",
   $Basics = Elm.Basics.make(_elm),
   $Forms$Model = Elm.Forms.Model.make(_elm),
   $Forms$Update = Elm.Forms.Update.make(_elm),
   $Game = Elm.Game.make(_elm),
   $Html = Elm.Html.make(_elm),
   $Html$Attributes = Elm.Html.Attributes.make(_elm),
   $Html$Events = Elm.Html.Events.make(_elm),
   $List = Elm.List.make(_elm),
   $Maybe = Elm.Maybe.make(_elm),
   $Messages = Elm.Messages.make(_elm),
   $Result = Elm.Result.make(_elm),
   $Signal = Elm.Signal.make(_elm),
   $State = Elm.State.make(_elm),
   $Views$Utils = Elm.Views.Utils.make(_elm);
   var opponentItem = function (_v0) {
      return function () {
         return A2($Html.li,
         _L.fromArray([$Html$Attributes.$class("opponent")]),
         _L.fromArray([$Views$Utils.playerWithAvatar(_v0.player)]));
      }();
   };
   var opponentsList = function (opponents) {
      return A2($Html.ul,
      _L.fromArray([$Html$Attributes.$class("race-course-opponents")]),
      A2($List.map,
      opponentItem,
      opponents));
   };
   var raceCourseStatusBlock = F2(function (t,
   _v2) {
      return function () {
         return A2($Html.div,
         _L.fromArray([$Html$Attributes.$class("col-md-4")]),
         _L.fromArray([A2($Html.div,
         _L.fromArray([$Html$Attributes.$class("race-course-status")]),
         _L.fromArray([A2($Html.a,
                      _L.fromArray([$Html$Attributes.$class("show")
                                   ,$Html$Attributes.style(_L.fromArray([{ctor: "_Tuple2"
                                                                         ,_0: "background-image"
                                                                         ,_1: A2($Basics._op["++"],
                                                                         "url(/assets/images/trials-",
                                                                         A2($Basics._op["++"],
                                                                         _v2.raceCourse.slug,
                                                                         ".png)"))}]))
                                   ,$Views$Utils.onClickGoTo($State.Show(_v2))]),
                      _L.fromArray([A2($Html.span,
                                   _L.fromArray([$Html$Attributes.$class("name")]),
                                   _L.fromArray([$Html.text(A2($Views$Utils.raceCourseName,
                                   t,
                                   _v2.raceCourse))]))
                                   ,A2($Html.div,
                                   _L.fromArray([$Html$Attributes.$class("description")]),
                                   _L.fromArray([$Html.text(t(A2($Basics._op["++"],
                                   "generators.",
                                   A2($Basics._op["++"],
                                   _v2.raceCourse.slug,
                                   ".description"))))]))]))
                      ,opponentsList(_v2.opponents)]))]));
      }();
   });
   var raceCourses = F2(function (t,
   state) {
      return A2($Html.div,
      _L.fromArray([$Html$Attributes.$class("container")]),
      _L.fromArray([A2($Html.div,
      _L.fromArray([$Html$Attributes.$class("row")]),
      A2($List.map,
      raceCourseStatusBlock(t),
      state.courses))]));
   });
   var loginBlock = function (form) {
      return $Views$Utils.row(_L.fromArray([$Views$Utils.col4(_L.fromArray([A2($Html.div,
                                                                           _L.fromArray([$Html$Attributes.$class("form-group")]),
                                                                           _L.fromArray([$Views$Utils.textInput(_L.fromArray([$Html$Attributes.placeholder("Email")
                                                                                                                             ,$Html$Attributes.value(form.email)
                                                                                                                             ,$Views$Utils.onInputFormUpdate(function (s) {
                                                                                                                                return $Forms$Model.UpdateLoginForm(function (f) {
                                                                                                                                   return _U.replace([["email"
                                                                                                                                                      ,s]],
                                                                                                                                   f);
                                                                                                                                });
                                                                                                                             })]))]))
                                                                           ,A2($Html.div,
                                                                           _L.fromArray([$Html$Attributes.$class("form-group")]),
                                                                           _L.fromArray([$Views$Utils.passwordInput(_L.fromArray([$Html$Attributes.placeholder("Password")
                                                                                                                                 ,$Html$Attributes.value(form.password)
                                                                                                                                 ,$Views$Utils.onInputFormUpdate(function (s) {
                                                                                                                                    return $Forms$Model.UpdateLoginForm(function (f) {
                                                                                                                                       return _U.replace([["password"
                                                                                                                                                          ,s]],
                                                                                                                                       f);
                                                                                                                                    });
                                                                                                                                 })]))]))
                                                                           ,A2($Html.div,
                                                                           _L.fromArray([]),
                                                                           _L.fromArray([A2($Html.button,
                                                                           _L.fromArray([$Html$Attributes.$class("btn btn-primary")
                                                                                        ,A2($Html$Events.onClick,
                                                                                        $Forms$Update.submitMailbox.address,
                                                                                        $Forms$Model.SubmitLogin(form))]),
                                                                           _L.fromArray([$Html.text("Submit")]))]))]))]));
   };
   var setHandleBlock = function (form) {
      return $Views$Utils.row(_L.fromArray([$Views$Utils.col4(_L.fromArray([A2($Html.div,
      _L.fromArray([$Html$Attributes.$class("input-group")]),
      _L.fromArray([$Views$Utils.textInput(_L.fromArray([$Html$Attributes.placeholder("Nickname?")
                                                        ,$Html$Attributes.value(form.handle)
                                                        ,$Views$Utils.onInputFormUpdate(function (s) {
                                                           return $Forms$Model.UpdateSetHandleForm(function (f) {
                                                              return _U.replace([["handle"
                                                                                 ,s]],
                                                              f);
                                                           });
                                                        })
                                                        ,A2($Views$Utils.onEnter,
                                                        $Forms$Update.submitMailbox.address,
                                                        $Forms$Model.SubmitSetHandle(form))]))
                   ,A2($Html.span,
                   _L.fromArray([$Html$Attributes.$class("input-group-btn")]),
                   _L.fromArray([A2($Html.button,
                   _L.fromArray([$Html$Attributes.$class("btn btn-primary")
                                ,A2($Html$Events.onClick,
                                $Forms$Update.submitMailbox.address,
                                $Forms$Model.SubmitSetHandle(form))]),
                   _L.fromArray([$Html.text("submit")]))]))]))]))]));
   };
   var welcomeForms = F2(function (player,
   forms) {
      return player.guest ? _L.fromArray([setHandleBlock(forms.setHandle)
                                         ,loginBlock(forms.login)]) : _L.fromArray([]);
   });
   var welcome = F2(function (t,
   _v4) {
      return function () {
         return $Views$Utils.titleWrapper(A2($List.append,
         _L.fromArray([A2($Html.h1,
         _L.fromArray([]),
         _L.fromArray([$Html.text(A2($Basics._op["++"],
         "Welcome, ",
         A2($Maybe.withDefault,
         "Anonymous",
         _v4.player.handle)))]))]),
         A2(welcomeForms,
         _v4.player,
         _v4.forms)));
      }();
   });
   var view = F2(function (t,
   state) {
      return A2($Html.div,
      _L.fromArray([$Html$Attributes.$class("home")]),
      _L.fromArray([A2(welcome,
                   t,
                   state)
                   ,A2(raceCourses,t,state)]));
   });
   _elm.Views.Home.values = {_op: _op
                            ,view: view
                            ,welcome: welcome
                            ,welcomeForms: welcomeForms
                            ,setHandleBlock: setHandleBlock
                            ,loginBlock: loginBlock
                            ,raceCourses: raceCourses
                            ,raceCourseStatusBlock: raceCourseStatusBlock
                            ,opponentsList: opponentsList
                            ,opponentItem: opponentItem};
   return _elm.Views.Home.values;
};
Elm.Views = Elm.Views || {};
Elm.Views.Main = Elm.Views.Main || {};
Elm.Views.Main.make = function (_elm) {
   "use strict";
   _elm.Views = _elm.Views || {};
   _elm.Views.Main = _elm.Views.Main || {};
   if (_elm.Views.Main.values)
   return _elm.Views.Main.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   $moduleName = "Views.Main",
   $Basics = Elm.Basics.make(_elm),
   $Graphics$Element = Elm.Graphics.Element.make(_elm),
   $Html = Elm.Html.make(_elm),
   $Html$Attributes = Elm.Html.Attributes.make(_elm),
   $List = Elm.List.make(_elm),
   $Maybe = Elm.Maybe.make(_elm),
   $Messages = Elm.Messages.make(_elm),
   $Render$All = Elm.Render.All.make(_elm),
   $Result = Elm.Result.make(_elm),
   $Signal = Elm.Signal.make(_elm),
   $State = Elm.State.make(_elm),
   $Views$Home = Elm.Views.Home.make(_elm),
   $Views$ShowRaceCourse = Elm.Views.ShowRaceCourse.make(_elm),
   $Views$TopBar = Elm.Views.TopBar.make(_elm);
   var gameView = F3(function (_v0,
   t,
   appState) {
      return function () {
         switch (_v0.ctor)
         {case "_Tuple2":
            return $Html.fromElement(function () {
                 var _v4 = appState.gameState;
                 switch (_v4.ctor)
                 {case "Just":
                    return A2($Render$All.renderGame,
                      {ctor: "_Tuple2"
                      ,_0: _v0._0
                      ,_1: _v0._1 - $Views$TopBar.height},
                      _v4._0);
                    case "Nothing":
                    return $Graphics$Element.empty;}
                 _U.badCase($moduleName,
                 "between lines 43 and 48");
              }());}
         _U.badCase($moduleName,
         "between lines 43 and 48");
      }();
   });
   var layout = F3(function (t,
   appState,
   view) {
      return A2($Html.div,
      _L.fromArray([$Html$Attributes.$class("global-wrapper")]),
      _L.fromArray([A2($Views$TopBar.view,
                   t,
                   appState)
                   ,A2(view,t,appState)]));
   });
   var mainView = F3(function (t,
   _v6,
   appState) {
      return function () {
         switch (_v6.ctor)
         {case "_Tuple2":
            return function () {
                 var _v10 = appState.screen;
                 switch (_v10.ctor)
                 {case "Home": return A3(layout,
                      t,
                      appState,
                      $Views$Home.view);
                    case "Play": return A3(layout,
                      t,
                      appState,
                      gameView({ctor: "_Tuple2"
                               ,_0: _v6._0
                               ,_1: _v6._1}));
                    case "Show": return A3(layout,
                      t,
                      appState,
                      $Views$ShowRaceCourse.view(_v10._0));}
                 _U.badCase($moduleName,
                 "between lines 22 and 31");
              }();}
         _U.badCase($moduleName,
         "between lines 22 and 31");
      }();
   });
   _elm.Views.Main.values = {_op: _op
                            ,mainView: mainView
                            ,layout: layout
                            ,gameView: gameView};
   return _elm.Views.Main.values;
};
Elm.Views = Elm.Views || {};
Elm.Views.ShowRaceCourse = Elm.Views.ShowRaceCourse || {};
Elm.Views.ShowRaceCourse.make = function (_elm) {
   "use strict";
   _elm.Views = _elm.Views || {};
   _elm.Views.ShowRaceCourse = _elm.Views.ShowRaceCourse || {};
   if (_elm.Views.ShowRaceCourse.values)
   return _elm.Views.ShowRaceCourse.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   $moduleName = "Views.ShowRaceCourse",
   $Basics = Elm.Basics.make(_elm),
   $Html = Elm.Html.make(_elm),
   $Html$Attributes = Elm.Html.Attributes.make(_elm),
   $List = Elm.List.make(_elm),
   $Maybe = Elm.Maybe.make(_elm),
   $Messages = Elm.Messages.make(_elm),
   $Result = Elm.Result.make(_elm),
   $Signal = Elm.Signal.make(_elm),
   $State = Elm.State.make(_elm),
   $Views$Utils = Elm.Views.Utils.make(_elm);
   var joinButton = F2(function (raceCourse,
   t) {
      return A2($Html.a,
      _L.fromArray([$Html$Attributes.$class("btn btn-warning btn-warning join-race-course")
                   ,$Views$Utils.onClickGoTo($State.Play(raceCourse))]),
      _L.fromArray([$Html.text("Join")]));
   });
   var view = F3(function (_v0,
   t,
   appState) {
      return function () {
         return A2($Html.div,
         _L.fromArray([$Html$Attributes.$class("show-race-course")]),
         _L.fromArray([$Views$Utils.titleWrapper(_L.fromArray([A2($Html.h1,
                                                              _L.fromArray([]),
                                                              _L.fromArray([$Html.text(A2($Views$Utils.raceCourseName,
                                                              t,
                                                              _v0.raceCourse))]))
                                                              ,A2(joinButton,
                                                              _v0.raceCourse,
                                                              t)]))]));
      }();
   });
   _elm.Views.ShowRaceCourse.values = {_op: _op
                                      ,view: view
                                      ,joinButton: joinButton};
   return _elm.Views.ShowRaceCourse.values;
};
Elm.Views = Elm.Views || {};
Elm.Views.TopBar = Elm.Views.TopBar || {};
Elm.Views.TopBar.make = function (_elm) {
   "use strict";
   _elm.Views = _elm.Views || {};
   _elm.Views.TopBar = _elm.Views.TopBar || {};
   if (_elm.Views.TopBar.values)
   return _elm.Views.TopBar.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   $moduleName = "Views.TopBar",
   $Basics = Elm.Basics.make(_elm),
   $Forms$Model = Elm.Forms.Model.make(_elm),
   $Forms$Update = Elm.Forms.Update.make(_elm),
   $Game = Elm.Game.make(_elm),
   $Html = Elm.Html.make(_elm),
   $Html$Attributes = Elm.Html.Attributes.make(_elm),
   $Html$Events = Elm.Html.Events.make(_elm),
   $List = Elm.List.make(_elm),
   $Maybe = Elm.Maybe.make(_elm),
   $Messages = Elm.Messages.make(_elm),
   $Result = Elm.Result.make(_elm),
   $Signal = Elm.Signal.make(_elm),
   $State = Elm.State.make(_elm),
   $Views$Utils = Elm.Views.Utils.make(_elm);
   var userMenu = function (player) {
      return A2($Html.ul,
      _L.fromArray([$Html$Attributes.$class("nav navbar-nav navbar-right nav-user")]),
      _L.fromArray([A2($Html.li,
                   _L.fromArray([]),
                   _L.fromArray([A2($Html.a,
                   _L.fromArray([]),
                   _L.fromArray([A2($Html.img,
                                _L.fromArray([$Html$Attributes.src($Views$Utils.avatarUrl(player))
                                             ,$Html$Attributes.$class("avatar avatar-user")]),
                                _L.fromArray([]))
                                ,$Html.text("Profile")]))]))
                   ,A2($Html.li,
                   _L.fromArray([]),
                   _L.fromArray([A2($Html.a,
                   _L.fromArray([A2($Html$Events.onClick,
                   $Forms$Update.submitMailbox.address,
                   $Forms$Model.SubmitLogout)]),
                   _L.fromArray([$Html.text("Logout")]))]))]));
   };
   var guestMenu = A2($Html.ul,
   _L.fromArray([$Html$Attributes.$class("nav navbar-nav navbar-right nav-user")]),
   _L.fromArray([A2($Html.li,
                _L.fromArray([]),
                _L.fromArray([A2($Html.a,
                _L.fromArray([]),
                _L.fromArray([$Html.text("Login")]))]))
                ,A2($Html.li,
                _L.fromArray([]),
                _L.fromArray([A2($Html.a,
                _L.fromArray([]),
                _L.fromArray([$Html.text("Register")]))]))]));
   var playerMenu = function (player) {
      return player.guest ? guestMenu : userMenu(player);
   };
   var logo = A2($Html.div,
   _L.fromArray([$Html$Attributes.$class("navbar-header")]),
   _L.fromArray([A2($Html.a,
   _L.fromArray([$Html$Attributes.$class("navbar-brand")
                ,$Views$Utils.onClickGoTo($State.Home)]),
   _L.fromArray([A2($Html.img,
   _L.fromArray([$Html$Attributes.src("/assets/images/logo-header-2.png")
                ,$Html$Attributes.$class("logo")]),
   _L.fromArray([]))]))]));
   var view = F2(function (t,
   appState) {
      return A2($Html.nav,
      _L.fromArray([$Html$Attributes.$class("navbar")]),
      _L.fromArray([A2($Html.div,
      _L.fromArray([$Html$Attributes.$class("container")]),
      _L.fromArray([logo
                   ,playerMenu(appState.player)]))]));
   });
   var logoWidth = 160;
   var height = 50;
   _elm.Views.TopBar.values = {_op: _op
                              ,height: height
                              ,logoWidth: logoWidth
                              ,view: view
                              ,logo: logo
                              ,playerMenu: playerMenu
                              ,guestMenu: guestMenu
                              ,userMenu: userMenu};
   return _elm.Views.TopBar.values;
};
Elm.Views = Elm.Views || {};
Elm.Views.Utils = Elm.Views.Utils || {};
Elm.Views.Utils.make = function (_elm) {
   "use strict";
   _elm.Views = _elm.Views || {};
   _elm.Views.Utils = _elm.Views.Utils || {};
   if (_elm.Views.Utils.values)
   return _elm.Views.Utils.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   $moduleName = "Views.Utils",
   $Basics = Elm.Basics.make(_elm),
   $Forms$Model = Elm.Forms.Model.make(_elm),
   $Game = Elm.Game.make(_elm),
   $Html = Elm.Html.make(_elm),
   $Html$Attributes = Elm.Html.Attributes.make(_elm),
   $Html$Events = Elm.Html.Events.make(_elm),
   $Inputs = Elm.Inputs.make(_elm),
   $Json$Decode = Elm.Json.Decode.make(_elm),
   $List = Elm.List.make(_elm),
   $Maybe = Elm.Maybe.make(_elm),
   $Messages = Elm.Messages.make(_elm),
   $Result = Elm.Result.make(_elm),
   $Signal = Elm.Signal.make(_elm),
   $State = Elm.State.make(_elm);
   var raceCourseName = F2(function (t,
   _v0) {
      return function () {
         return t(A2($Basics._op["++"],
         "generators.",
         A2($Basics._op["++"],
         _v0.slug,
         ".name")));
      }();
   });
   var avatarUrl = function (p) {
      return function () {
         var _v2 = p.avatarId;
         switch (_v2.ctor)
         {case "Just":
            return A2($Basics._op["++"],
              "/avatars/",
              _v2._0);
            case "Nothing":
            return p.user ? "/assets/images/avatar-user.png" : "/assets/images/avatar-guest.png";}
         _U.badCase($moduleName,
         "between lines 84 and 86");
      }();
   };
   var playerWithAvatar = function (player) {
      return function () {
         var handle = A2($Maybe.withDefault,
         "",
         player.handle);
         var handleSpan = A2($Html.span,
         _L.fromArray([$Html$Attributes.$class("handle")]),
         _L.fromArray([$Html.text(A2($Maybe.withDefault,
         "Anonymous",
         player.handle))]));
         var avatarImg = A2($Html.img,
         _L.fromArray([$Html$Attributes.src(avatarUrl(player))
                      ,$Html$Attributes.$class("avatar")
                      ,$Html$Attributes.width(19)
                      ,$Html$Attributes.height(19)]),
         _L.fromArray([]));
         return player.guest ? A2($Html.span,
         _L.fromArray([$Html$Attributes.$class("player-avatar")]),
         _L.fromArray([avatarImg
                      ,$Html.text(" ")
                      ,handleSpan])) : A2($Html.a,
         _L.fromArray([$Html$Attributes.href(A2($Basics._op["++"],
                      "/players/",
                      handle))
                      ,$Html$Attributes.target("_blank")
                      ,$Html$Attributes.$class("player-avatar")]),
         _L.fromArray([avatarImg
                      ,$Html.text(" ")
                      ,handleSpan]));
      }();
   };
   var blockWrapper = F2(function (wrapperClass,
   content) {
      return A2($Html.div,
      _L.fromArray([$Html$Attributes.$class(wrapperClass)]),
      _L.fromArray([A2($Html.div,
      _L.fromArray([$Html$Attributes.$class("container")]),
      content)]));
   });
   var lightWrapper = function (content) {
      return A2(blockWrapper,
      "light-wrapper",
      content);
   };
   var titleWrapper = function (content) {
      return A2(blockWrapper,
      "title-wrapper",
      content);
   };
   var passwordInput = function (attributes) {
      return A2($Html.input,
      A2($List.append,
      _L.fromArray([$Html$Attributes.type$("password")
                   ,$Html$Attributes.$class("form-control")]),
      attributes),
      _L.fromArray([]));
   };
   var textInput = function (attributes) {
      return A2($Html.input,
      A2($List.append,
      _L.fromArray([$Html$Attributes.type$("text")
                   ,$Html$Attributes.$class("form-control")]),
      attributes),
      _L.fromArray([]));
   };
   var col = F2(function (w,
   content) {
      return function () {
         var ws = $Basics.toString(w);
         return A2($Html.div,
         _L.fromArray([$Html$Attributes.$class(A2($Basics._op["++"],
         "col-lg-",
         A2($Basics._op["++"],
         ws,
         A2($Basics._op["++"],
         " col-lg-offset-",
         ws))))]),
         content);
      }();
   });
   var col4 = col(4);
   var row = function (content) {
      return A2($Html.div,
      _L.fromArray([$Html$Attributes.$class("row")]),
      content);
   };
   var is13 = function (code) {
      return _U.eq(code,
      13) ? $Result.Ok({ctor: "_Tuple0"}) : $Result.Err("not the right key code");
   };
   var onEnter = F2(function (address,
   value) {
      return A3($Html$Events.on,
      "keydown",
      A2($Json$Decode.customDecoder,
      $Html$Events.keyCode,
      is13),
      function (_v4) {
         return function () {
            return A2($Signal.message,
            address,
            value);
         }();
      });
   });
   var onInput = F2(function (address,
   contentToValue) {
      return A3($Html$Events.on,
      "input",
      $Html$Events.targetValue,
      function (str) {
         return A2($Signal.message,
         address,
         contentToValue(str));
      });
   });
   var onInputFormUpdate = function (updater) {
      return A2(onInput,
      $Inputs.actionsMailbox.address,
      function ($) {
         return $Inputs.FormAction(updater($));
      });
   };
   var onClickGoTo = function (screen) {
      return A2($Html$Events.onClick,
      $Inputs.actionsMailbox.address,
      $Inputs.Navigate(screen));
   };
   _elm.Views.Utils.values = {_op: _op
                             ,onClickGoTo: onClickGoTo
                             ,onInputFormUpdate: onInputFormUpdate
                             ,onInput: onInput
                             ,onEnter: onEnter
                             ,is13: is13
                             ,row: row
                             ,col4: col4
                             ,col: col
                             ,textInput: textInput
                             ,passwordInput: passwordInput
                             ,titleWrapper: titleWrapper
                             ,lightWrapper: lightWrapper
                             ,blockWrapper: blockWrapper
                             ,playerWithAvatar: playerWithAvatar
                             ,avatarUrl: avatarUrl
                             ,raceCourseName: raceCourseName};
   return _elm.Views.Utils.values;
};
Elm.VirtualDom = Elm.VirtualDom || {};
Elm.VirtualDom.make = function (_elm) {
   "use strict";
   _elm.VirtualDom = _elm.VirtualDom || {};
   if (_elm.VirtualDom.values)
   return _elm.VirtualDom.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   $moduleName = "VirtualDom",
   $Basics = Elm.Basics.make(_elm),
   $Graphics$Element = Elm.Graphics.Element.make(_elm),
   $Json$Decode = Elm.Json.Decode.make(_elm),
   $List = Elm.List.make(_elm),
   $Maybe = Elm.Maybe.make(_elm),
   $Native$VirtualDom = Elm.Native.VirtualDom.make(_elm),
   $Result = Elm.Result.make(_elm),
   $Signal = Elm.Signal.make(_elm);
   var lazy3 = $Native$VirtualDom.lazy3;
   var lazy2 = $Native$VirtualDom.lazy2;
   var lazy = $Native$VirtualDom.lazy;
   var defaultOptions = {_: {}
                        ,preventDefault: false
                        ,stopPropagation: false};
   var Options = F2(function (a,
   b) {
      return {_: {}
             ,preventDefault: b
             ,stopPropagation: a};
   });
   var onWithOptions = $Native$VirtualDom.on;
   var on = F3(function (eventName,
   decoder,
   toMessage) {
      return A4($Native$VirtualDom.on,
      eventName,
      defaultOptions,
      decoder,
      toMessage);
   });
   var attribute = $Native$VirtualDom.attribute;
   var property = $Native$VirtualDom.property;
   var Property = {ctor: "Property"};
   var fromElement = $Native$VirtualDom.fromElement;
   var toElement = $Native$VirtualDom.toElement;
   var text = $Native$VirtualDom.text;
   var node = $Native$VirtualDom.node;
   var Node = {ctor: "Node"};
   _elm.VirtualDom.values = {_op: _op
                            ,text: text
                            ,node: node
                            ,toElement: toElement
                            ,fromElement: fromElement
                            ,property: property
                            ,attribute: attribute
                            ,on: on
                            ,onWithOptions: onWithOptions
                            ,defaultOptions: defaultOptions
                            ,lazy: lazy
                            ,lazy2: lazy2
                            ,lazy3: lazy3
                            ,Options: Options};
   return _elm.VirtualDom.values;
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
   $moduleName = "Window",
   $Basics = Elm.Basics.make(_elm),
   $Native$Window = Elm.Native.Window.make(_elm),
   $Signal = Elm.Signal.make(_elm);
   var dimensions = $Native$Window.dimensions;
   var width = A2($Signal.map,
   $Basics.fst,
   dimensions);
   var height = A2($Signal.map,
   $Basics.snd,
   dimensions);
   _elm.Window.values = {_op: _op
                        ,dimensions: dimensions
                        ,width: width
                        ,height: height};
   return _elm.Window.values;
};
