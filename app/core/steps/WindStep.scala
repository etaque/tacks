package core.steps

import models.{Wind, Geo, Gust, PlayerState}

case class GustEffect(origin: Double, speed: Double, factor: Double)

object WindStep {

  val shadowImpact = -5 // knots
  val shadowArc = 30 // degrees

  def run(wind: Wind, shadowLength: Double, opponents: Seq[PlayerState])(state: PlayerState): PlayerState = {

    val shadowDirection = Geo.ensure360(state.windOrigin + 180 + (state.windAngle / 3))

    val gustsOnPlayer = wind.gusts.filter(g => Geo.distanceBetween(state.position, g.position) < g.radius)
    val gustsEffects = gustsOnPlayer.map(gustEffect(state, wind))
    val windShadow = opponents.filter(isShadowedBy(state, shadowLength)).map( _ => shadowImpact).sum

    val origin =
      if (gustsEffects.isEmpty) wind.origin
      else Geo.ensure360(wind.origin + gustsEffects.map(g => g.origin * g.factor).sum)

    val speed = wind.speed + gustsEffects.map(g => g.speed * g.factor).sum + windShadow

    state.copy(windOrigin = origin, windSpeed = speed, shadowDirection = shadowDirection)
  }

  def gustEffect(state: PlayerState, wind: Wind)(gust: Gust): GustEffect = {
    val d = Geo.distanceBetween(state.position, gust.position)
    val fromEdge = gust.radius - d
    val factor = Math.min(fromEdge / (gust.radius * 0.2), 1)

    val originEffect = Geo.angleDelta(gust.angle, wind.origin)
    val speedEffect = gust.speed

    GustEffect(originEffect, speedEffect, factor)
  }

  def isShadowedBy(player: PlayerState, shadowLength: Double)(opponent: PlayerState): Boolean = {
    Geo.distanceBetween(opponent.position, player.position) <= shadowLength && {
      val angle = Geo.angleBetween(player.position, opponent.position)
      val (min, max) = windShadowSector(opponent)
      Geo.inSector(min, max)(angle)
    }
  }

  def windShadowSector(state: PlayerState): (Double, Double) = {
    val d = state.windOrigin + 180 + (state.windAngle / 3)
    (Geo.ensure360(d - shadowArc/2), Geo.ensure360(d + shadowArc/2))
  }
}
