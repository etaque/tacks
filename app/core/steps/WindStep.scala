package core.steps

import models.{Wind, Geo, Gust, PlayerState}

object WindStep {

  val shadowImpact = -5 // knots
  val shadowArc = 30 // degrees

  def run(wind: Wind, shadowLength: Double, opponents: Seq[PlayerState])(state: PlayerState): PlayerState = {

    val gustsOnPlayer = wind.gusts.filter(g => Geo.distanceBetween(state.position, g.position) < g.radius)
    val gustsEffects = gustsOnPlayer.map(gustEffect(state, wind))
    val windShadow = windShadowEffects(state, shadowLength, opponents)

    val origin =
      if (gustsEffects.isEmpty) wind.origin
      else Geo.ensure360(wind.origin + gustsEffects.map(_._1).sum / gustsEffects.size)

    val speed = wind.speed + gustsEffects.map(_._2).sum + windShadow

    state.copy(windOrigin = origin, windSpeed = speed)
  }

  def gustEffect(state: PlayerState, wind: Wind)(gust: Gust): (Double, Double) = {
    val d = Geo.distanceBetween(state.position, gust.position)
    val fromEdge = gust.radius - d
    val factor = Math.min(fromEdge / (gust.radius * 0.2), 1)

    val originEffect = Geo.angleDelta(gust.angle, wind.origin) * factor
    val speedEffect = gust.speed * factor

    (originEffect, speedEffect)
  }

  def windShadowEffects(state: PlayerState, shadowLength: Double, opponents: Seq[PlayerState]): Double = {
    opponents.filter(o => Geo.distanceBetween(o.position, state.position) <= shadowLength).filter { o =>
      val angle = Geo.angleBetween(state.position, o.position)
      val (min, max) = windShadowSector(o)
      angle >= min && angle <= max
    }.map( _ => shadowImpact).sum
  }

  def windShadowSector(state: PlayerState): (Double, Double) = {
    val d = Geo.ensure360(state.windOrigin + 180 + (state.windAngle / 3))
    (d - shadowArc/2, d + shadowArc/2)
  }
}
