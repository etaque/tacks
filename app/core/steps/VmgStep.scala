package core.steps

import core.Sailing
import models.{Geo, PlayerState}

object VmgStep {

  def run(state: PlayerState): PlayerState = {
    state.copy(
      upwindVmg = getUpwindVmg(state.windSpeed),
      downwindVmg = getDownwindVmg(state.windSpeed))
  }

  def vmgValue(windSpeed: Double, windAngle: Double): Double = {
    val inRads = Geo.angleToRadians(windAngle)
    val boatSpeed = Sailing.ac72Speed(windSpeed, windAngle)

    Math.abs(Math.sin(inRads) * boatSpeed)
  }

  def getUpwindVmg(windSpeed: Double): Double = findVmgInInterval(windSpeed, 40 to 60)
  def getDownwindVmg(windSpeed: Double): Double = findVmgInInterval(windSpeed, 130 to 180)

  def findVmgInInterval(windSpeed: Double, angles: Range): Double = {
    val vmgValues = angles.map(vmgValue(windSpeed, _))
    val pairs = angles.zip(vmgValues)

    pairs.sortBy(_._2).headOption.map(_._1.toDouble).getOrElse(0)
  }

}
