package core.steps

import models.{Wind, Geo, Gust, PlayerState}

object WindStep {

  def run(wind: Wind)(state: PlayerState): PlayerState = {

    val gustsOnPlayer = wind.gusts.filter(g => Geo.distanceBetween(state.position, g.position) < g.radius)
    val gustsEffects = gustsOnPlayer.map(gustEffect(state, wind))

    val origin =
      if (gustsEffects.isEmpty) wind.origin
      else Geo.ensure360(wind.origin + gustsEffects.map(_._1).sum / gustsEffects.size)

    val speed = wind.speed + gustsEffects.map(_._2).sum

    state.copy(windOrigin = origin, windSpeed = speed)
  }

  def gustEffect(state: PlayerState, wind: Wind)(gust: Gust): (Double, Double) = {
    val d = Geo.distanceBetween(state.position, gust.position)
    val fromEdge = gust.radius - d
    val factor = Math.min(fromEdge / (gust.radius * 0.2), 1)

    val originEffect = Geo.angleBetween(gust.angle, wind.origin) * factor
    val speedEffect = gust.speed * factor

    (originEffect, speedEffect)
  }
}
