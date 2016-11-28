package models

import java.util.UUID
import akka.actor.ActorRef
import org.joda.time.DateTime
import models._
import tools.Conf


case class TimeTrialState(
  track: Track,
  player: Player,
  paths: Map[PlayerId, RunPath.Slices],
  playersGhosts: Map[PlayerId, Map[RunId, GhostState]],
  ghostRuns: Map[RunId, (Run, RunPath.Slices)]
)
