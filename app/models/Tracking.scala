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

object Tracking {

  val redis = RedisClient()(Akka.system)
  val ns = "runs:"

  type Track = Map[Long, Seq[Geo.Point]]

  implicit val geoPointFormatter = new ByteStringFormatter[Geo.Point] {
    def serialize(data: Geo.Point): ByteString = {
      ByteString(data._1 + "|" + data._2)
    }

    def deserialize(bs: ByteString): Geo.Point = {
      val r = bs.utf8String.split('|').toList
      (r(0).toDouble, r(1).toDouble)
    }
  }

  def pushPoint(runId: BSONObjectID, second: Long, point: Geo.Point): Future[MultiBulk] = {
    val t = redis.transaction()
    t.sadd(ns + runId.stringify, second)
    t.lpush(ns + runId.stringify + ":" + second, point)
    t.exec()
  }

  def getPoints(runId: BSONObjectID): Future[Track] = {
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
