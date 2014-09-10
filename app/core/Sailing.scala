package core

import scala.math.{pow,abs}

object Sailing {

  val knFactor = 1.852

  def mpsToKn(mps: Double): Double = mps / knFactor / 1000 * 3600
  def knToMps(knot: Double): Double = knot * knFactor * 1000 / 3600

  /**
   * polynomial regression of AC72 polar
   * see http://noticeboard.americascup.com/wp-content/uploads/actv/LV13/AC72polar.130714.txt
   * and http://www.xuru.org/rt/MPR.asp
   * @param windSpeed in knots
   * @param windAngle in degrees
   * @return boat speed in m/s
   */
  def ac72Speed(windSpeed: Double, windAngle: Double): Double = {
    val x1 = windSpeed
    val x2 = abs(windAngle)
    val y = (-2.067174789 * pow(10, -3) * pow(x1, 3)
          - 1.868941044 * pow(10, -4) * pow(x1, 2) * x2
          - 1.03401471 * pow(10, -4) * x1 * pow(x2, 2)
          - 1.86799863 * pow(10, -5) * pow(x2, 3)
          + 7.376288713 * pow(10, -2) * pow(x1, 2)
          + 3.19606466 * pow(10, -2) * x1 * x2
          + 2.939457021 * pow(10, -3) * pow(x2, 2)
          - 8.575945237 * pow(10, -1) * x1
          + 9.427801906 * pow(10, -5) * x2
          + 4.342327445)
    y * 2
  }

}
