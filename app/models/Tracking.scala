package models

import akka.util.ByteString
import play.api.Play.current
import play.api.libs.concurrent.Akka
import play.api.libs.concurrent.Execution.Implicits._
import reactivemongo.bson.BSONObjectID
import redis.protocol.MultiBulk
import redis.{ByteStringFormatter, RedisClient}

import scala.concurrent.Future
import scala.util.Try

case class TrackStep(
  ms: Int,
  position: Geo.Point,
  heading: Double
)

object Tracking {

  val redis = RedisClient()(Akka.system)
  val ns = "runs:"

  type Track = Map[Long, Seq[TrackStep]]

  implicit val geoPointFormatter = new ByteStringFormatter[TrackStep] {
    def serialize(data: TrackStep): ByteString = {
      ByteString(data.ms + "|" + data.position._1 + "|" + data.position._2 + "|" + data.heading)
    }

    def deserialize(bs: ByteString): TrackStep = {
      val r = bs.utf8String.split('|').toList
      TrackStep(r(0).toInt, (r(1).toDouble, r(2).toDouble), r(3).toDouble)
    }
  }

  def pushStep(runId: BSONObjectID, second: Long, step: TrackStep): Future[MultiBulk] = {
    val t = redis.transaction()
    t.sadd(ns + runId.stringify, second)
    t.rpush(ns + runId.stringify + ":" + second, step)
    t.exec()
  }

  def getTrack(runId: BSONObjectID): Future[Track] = {
    for {
      seconds <- redis.smembers[String](ns + runId.stringify)
      pointsBySecond <- Future.sequence(seconds.flatMap { s =>
        Try(s.toLong).toOption.map { l =>
          redis.lrange(ns + runId.stringify + ":" + s, 0, -1).map { points => (l, points)}
        }
      })
    }
    yield pointsBySecond.toMap
  }
}
