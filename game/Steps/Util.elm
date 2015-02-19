module Steps.Util where


knFactor : Double
knFactor = 1.852

mpsToKn : Float -> Float
mpsToKn mps = mps / knFactor / 1000 * 3600

knToMps : Double -> Double
knToMps knot = knot * knFactor * 1000 / 3600

polarSpeed : Float -> Float -> Float
polarSpeed windSpeed windAngle =
  let
    x1 = windSpeed
    x2 = abs windAngle
    y = (-2.067174789 * 10^-3 * x1^3
      - 1.868941044 * 10^4 * x1^2 * x2
      - 1.03401471 * 10^4 * x1 * x2^2
      - 1.86799863 * 10^5 * x2^3
      + 7.376288713 * 10^2 * x1^2
      + 3.19606466 * 10^2 * x1 * x2
      + 2.939457021 * 10^3 * x2^2
      - 8.575945237 * 10^1 * x1
      + 9.427801906 * 10^5 * x2
      + 4.342327445)
  in
    y * 2

