package core.steps

import core.Sailing
import models.{Vmg, Geo, PlayerState}

object VmgStep {

  def run(state: PlayerState): PlayerState = {
    state.copy(
      vmgValue = getVmgValue(state.windAngle, state.velocity),
      upwindVmg = getUpwindVmg(state.windSpeed),
      downwindVmg = getDownwindVmg(state.windSpeed))
  }

  def makeVmg(windSpeed: Double)(windAngle: Double): Vmg = {
    val boatSpeed = Sailing.ac72Speed(windSpeed, windAngle)
    Vmg(windAngle, boatSpeed, getVmgValue(windAngle, boatSpeed))
  }
  
  def getVmgValue(windAngle: Double, boatSpeed: Double): Double = {
    val inRads = Geo.angleToRadians(windAngle)
    Math.abs(Math.sin(inRads) * boatSpeed)
  }

  def getUpwindVmg(windSpeed: Double): Vmg = findVmgInInterval(windSpeed, 40 to 60)
  def getDownwindVmg(windSpeed: Double): Vmg = findVmgInInterval(windSpeed, 130 to 180)

  def findVmgInInterval(windSpeed: Double, angles: Range): Vmg = {
    val vmgValues = angles.map(makeVmg(windSpeed)(_))

    vmgValues.sortBy(_.value).reverse.headOption.getOrElse(Vmg(0, 0, 0))
  }

}
