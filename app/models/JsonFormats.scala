package models

import org.joda.time.DateTime
import play.api.data.validation.ValidationError
import play.api.libs.functional.syntax._
import play.api.libs.json._
import scala.util.{Try, Success, Failure}

import models.Geo._
import tools.JsonFormats._


object JsonFormats {

  def readsValueError(expectedClass: String, value: String) =
    JsError(Seq(JsPath() -> Seq(ValidationError(s"Expected $expectedClass value, got: " + value.toString))))

  implicit val controlModeFormat: Format[ControlMode] = new Format[ControlMode] {
    override def reads(json: JsValue): JsResult[ControlMode] = json match {
      case JsString("FixedAngle") => JsSuccess(FixedAngle)
      case JsString("FixedHeading") => JsSuccess(FixedHeading)
      case _ @ v => readsValueError("ControlMode", v.toString())
    }
    override def writes(o: ControlMode): JsValue = JsString(o match {
      case FixedAngle => "FixedAngle"
      case FixedHeading => "FixedHeading"
    })
  }

  implicit val gridKeyFormat: Format[(Int, Int)] = tuple2Format[Int, Int]

  implicit val orientationFormat = new Format[Orientation] {
    override def reads(json: JsValue): JsResult[Orientation] = json match {
      case JsString("N") => JsSuccess(North)
      case JsString("S") => JsSuccess(South)
      case JsString("E") => JsSuccess(East)
      case JsString("W") => JsSuccess(West)
      case _ @ v => readsValueError("Orientation", v.toString())
    }
    override def writes(o: Orientation): JsValue = JsString(
      o match {
        case North => "N"
        case South => "S"
        case East => "E"
        case West => "W"
      })
  }

  implicit val raceAreaFormat: Format[RaceArea] = Json.format[RaceArea]
  implicit val gustSpecFormat: Format[GustDef] = Json.format[GustDef]
  implicit val gustGeneratorFormat: Format[GustGenerator] = Json.format[GustGenerator]
  implicit val windGeneratorFormat: Format[WindGenerator] = Json.format[WindGenerator]
  implicit val gateFormat: Format[Gate] = Json.format[Gate]
  implicit val courseFormat: Format[Course] = Json.format[Course]

  implicit val userReads: Reads[User] = Json.reads[User]
  implicit val userWrites: Writes[User] = Writes { (u: User) =>
    Json.obj(
      "id" -> u.id,
      "user" -> true,
      "guest" -> false,
      "handle" -> u.handle,
      "status" -> u.status,
      "avatarId" -> u.gravatarHash,
      "vmgMagnet" -> u.vmgMagnet
    )
  }
  implicit val userFormat: Format[User] = Format(userReads, userWrites)

  val fullUserWrites: Writes[User] = Writes { (u: User) =>
    Json.obj(
      "id" -> u.id,
      "email" -> u.email,
      "handle" -> u.handle,
      "status" -> u.status,
      "avatarId" -> JsNull,
      "vmgMagnet" -> u.vmgMagnet,
      "creationTime" -> u.creationTime
    )
  }
  val fullUserFormat: Format[User] = Format(Json.reads[User], fullUserWrites)
  val fullUserSeqFormat: Format[Seq[User]] = Format(Reads.seq(fullUserFormat), Writes.seq(fullUserFormat))

  implicit val guestReads: Reads[Guest] = Json.reads[Guest]
  implicit val guestWrites: Writes[Guest] = Writes { (g: Guest) =>
    Json.obj(
      "id" -> g.id,
      "user" -> false,
      "guest" -> true,
      "handle" -> g.handle,
      "status" -> JsNull,
      "avatarId" -> JsNull,
      "vmgMagnet" -> g.vmgMagnet
    )
  }
  implicit val guestFormat: Format[Guest] = Format(guestReads, guestWrites)

  implicit val playerFormat: Format[Player] = new Format[Player] {
    override def writes(p: Player): JsValue = p match {
      case u: User => userFormat.writes(u)
      case g: Guest => guestFormat.writes(g)
    }
    override def reads(json: JsValue): JsResult[Player] = json match {
      case o: JsObject if (o \ "handle").asOpt[String].isDefined => userFormat.reads(o)
      case o: JsObject => guestFormat.reads(o)
      case _ @ v => readsValueError("Player", v.toString())
    }
  }

  implicit val opponentStateFormat: Format[OpponentState] = (
    (__ \ 'time).format(timestampFormat) and
      (__ \ 'position).format[Point] and
      (__ \ 'heading).format[Double] and
      (__ \ 'velocity).format[Double] and
      (__ \ 'windAngle).format[Double] and
      (__ \ 'windOrigin).format[Double] and
      (__ \ 'shadowDirection).format[Double] and
      (__ \ 'crossedGates).format(timestampSeqFormat)
  )(OpponentState.apply _, unlift(OpponentState.unapply _))

  implicit val opponentFormat: Format[Opponent] = Json.format[Opponent]

  implicit val vmgFormat: Format[Vmg] = Json.format[Vmg]
  implicit val arrowsFormat: Format[Arrows] = Json.format[Arrows]
  implicit val keyboardInputFormat: Format[KeyboardInput] = Json.format[KeyboardInput]

  implicit val playerInputFormat: Format[PlayerInput] = (
    (__ \ 'state).format[OpponentState] and
      (__ \ 'localTime).format(timestampFormat)
  )(PlayerInput.apply _, unlift(PlayerInput.unapply _))

  implicit val playerTallyFormat: Format[PlayerTally] = Json.format[PlayerTally]

  implicit val ghostStateFormat: Format[GhostState] = Json.format[GhostState]
    // (
    // (__ \ 'position).format[Point] and
    //   (__ \ 'heading).format[Double] and
    //   (__ \ 'id).format[BSONObjectID] and
    //   (__ \ 'handle).format[Option[String]] and
    //   (__ \ 'gates).format[Seq[Long]]
    // )(Ghost.apply _, unlift(Ghost.unapply _))

  implicit val optionGateFormat = Format.optionWithNull[Gate]

  implicit val playerStateFormat: Format[PlayerState] = (
    (__ \ 'player).format[Player] and
      (__ \ 'time).format[Float] and
      (__ \ 'position).format[Point] and
      (__ \ 'isGrounded).format[Boolean] and
      (__ \ 'isTurning).format[Boolean] and
      (__ \ 'heading).format[Double] and
      (__ \ 'velocity).format[Double] and
      (__ \ 'vmgValue).format[Double] and
      (__ \ 'windAngle).format[Double] and
      (__ \ 'windOrigin).format[Double] and
      (__ \ 'windSpeed).format[Double] and
      (__ \ 'upwindVmg).format[Vmg] and
      (__ \ 'downwindVmg).format[Vmg] and
      (__ \ 'shadowDirection).format[Double] and
      (__ \ 'trail).format[Seq[Point]] and
      (__ \ 'controlMode).format[ControlMode] and
      (__ \ 'tackTarget).format[Option[Double]] and
      (__ \ 'crossedGates).format[Seq[Long]] and
      (__ \ 'nextGate).format[Option[Gate]]
    )(PlayerState.apply _, unlift(PlayerState.unapply _))

  implicit val optionDateTimeFormat = Format.optionWithNull[DateTime]

  implicit val raceUpdateFormat: Format[RaceUpdate] = (
      (__ \ 'serverTime).format[DateTime] and
      (__ \ 'startTime).format[Option[DateTime]] and
      (__ \ 'wind).format[Wind] and
      (__ \ 'opponents).format[Seq[Opponent]] and
      (__ \ 'ghosts).format[Seq[GhostState]] and
      (__ \ 'tallies).format[Seq[PlayerTally]] and
      (__ \ 'isMaster).format[Boolean] and
      (__ \ 'initial).format[Boolean] and
      (__ \ 'clientTime).format[Float]
    )(RaceUpdate.apply _, unlift(RaceUpdate.unapply _))

  implicit val trackStatusFormat: Format[TrackStatus.Value] = enumFormat(TrackStatus)

  implicit val raceFormat: Format[Race] = Json.format[Race]

  implicit val trackFormat: Format[Track] = Json.format[Track]
  implicit val runFormat: Format[Run] = Json.format[Run]
  implicit val runRankingFormat: Format[RunRanking] = Json.format[RunRanking]
  implicit val raceReportFormat: Format[RaceReport] = Json.format[RaceReport]
  implicit val playerRankingFormat: Format[PlayerRanking] = Json.format[PlayerRanking]
  implicit val pathPointFormat: Format[PathPoint] = Json.format[PathPoint]
  implicit val pathSliceFormat: Format[(Long, Seq[PathPoint])] = tuple2Format[Long, Seq[PathPoint]]

  implicit val trackMetaFormat: Format[TrackMeta] = Json.format[TrackMeta]
  implicit val liveTrackFormat: Format[LiveTrack] = Json.format[LiveTrack]

  implicit val messageFormat: Format[Message] = Json.format[Message]

}
