package models

import models.Geo._
import org.joda.time.DateTime
import play.api.data.validation.ValidationError
import play.api.libs.functional.syntax._
import play.api.libs.json._
import reactivemongo.bson.BSONObjectID
import tools.JsonFormats._

object JsonFormats {

  def readsValueError(expectedClass: String, value: String) =
    JsError(Seq(JsPath() -> Seq(ValidationError(s"Expected $expectedClass value, got: " + value.toString))))

  implicit val tutorialStepFormat: Format[Tutorial.Step] = new Format[Tutorial.Step] {
    override def reads(json: JsValue): JsResult[Tutorial.Step] = json match {
      case JsString(s) => Tutorial.steps.find(_.toString == s).map(JsSuccess(_))
        .getOrElse(readsValueError("Tutorial.Step", s))
      case _ @ v => readsValueError("Tutorial.Step", v.toString())
    }
    override def writes(o: Tutorial.Step): JsValue = JsString(o.toString)
  }

  implicit val gateLocationFormat: Format[GateLocation] = new Format[GateLocation] {
    override def reads(json: JsValue): JsResult[GateLocation] = json match {
      case JsString("StartLine") => JsSuccess(StartLine)
      case JsString("DownwindGate") => JsSuccess(DownwindGate)
      case JsString("UpwindGate") => JsSuccess(UpwindGate)
      case _ @ v => readsValueError("GateLocation", v.toString())
    }
    override def writes(o: GateLocation): JsValue = JsString(o match {
      case StartLine => "StartLine"
      case DownwindGate => "DownwindGate"
      case UpwindGate => "UpwindGate"
    })
  }

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

  implicit val raceAreaFormat: Format[RaceArea] = Json.format[RaceArea]
  implicit val gustSpecFormat: Format[GustDef] = Json.format[GustDef]
  implicit val gustGeneratorFormat: Format[GustGenerator] = Json.format[GustGenerator]
  implicit val windGeneratorFormat: Format[WindGenerator] = Json.format[WindGenerator]
  implicit val gateFormat: Format[Gate] = Json.format[Gate]
  implicit val islandFormat: Format[Island] = Json.format[Island]
  implicit val courseFormat: Format[Course] = Json.format[Course]

  implicit val userReads: Reads[User] = Json.reads[User]
  implicit val userWrites: Writes[User] = Writes {
    (u: User) => Json.obj("id" -> u.id, "user" -> true, "handle" -> u.handle, "status" -> u.status, "avatarId" -> u.avatarId)
  }
  implicit val userFormat: Format[User] = Format(userReads, userWrites)

  implicit val guestReads: Reads[Guest] = Json.reads[Guest]
  implicit val guestWrites: Writes[Guest] = Writes {
    (g: Guest) => Json.obj("id" -> g.id, "guest" -> true, "handle" -> g.handle, "status" -> JsNull)
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

  implicit val vmgFormat: Format[Vmg] = Json.format[Vmg]
  implicit val arrowsFormat: Format[Arrows] = Json.format[Arrows]
  implicit val playerInputFormat: Format[PlayerInput] = Json.format[PlayerInput]
  implicit val playerUpdateFormat: Format[PlayerUpdate] = Json.format[PlayerUpdate]

  implicit val watcherInputFormat: Format[WatcherInput] = Json.format[WatcherInput]

  implicit val tutorialInputFormat: Format[TutorialInput] = Json.format[TutorialInput]

  implicit val playerTallyFormat: Format[PlayerTally] = (
    (__ \ 'playerId).format[BSONObjectID] and
      (__ \ 'playerHandle).format[Option[String]] and
      (__ \ 'gates).format[Seq[Long]]
    )(PlayerTally.apply, unlift(PlayerTally.unapply))

  implicit val ghostStateFormat: Format[GhostState] = (
    (__ \ 'position).format[Point] and
      (__ \ 'heading).format[Double] and
      (__ \ 'id).format[BSONObjectID] and
      (__ \ 'handle).format[Option[String]] and
      (__ \ 'gates).format[Seq[Long]]
    )(GhostState.apply, unlift(GhostState.unapply))

  implicit val playerStateFormat: Format[PlayerState] = (
    (__ \ 'player).format[Player] and
      (__ \ 'time).format[Long] and
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
      (__ \ 'nextGate).format[Option[GateLocation]]
    )(PlayerState.apply, unlift(PlayerState.unapply))

  implicit val raceUpdateFormat: Format[RaceUpdate] = (
    (__ \ 'playerId).format[String] and
      (__ \ 'now).format[DateTime] and
      (__ \ 'startTime).format[Option[DateTime]] and
      (__ \ 'course).format[Option[Course]] and
      (__ \ 'playerState).format[Option[PlayerState]] and
      (__ \ 'wind).format[Wind] and
      (__ \ 'opponents).format[Seq[PlayerState]] and
      (__ \ 'ghosts).format[Seq[GhostState]] and
      (__ \ 'leaderboard).format[Seq[PlayerTally]] and
      (__ \ 'isMaster).format[Boolean] and
      (__ \ 'langCode).format[Option[String]] and
      (__ \ 'watching).format[Boolean] and
      (__ \ 'timeTrial).format[Boolean]
    )(RaceUpdate.apply, unlift(RaceUpdate.unapply))

  implicit val tutorialUpdateFormat: Format[TutorialUpdate] = (
    (__ \ 'now).format[Long] and
      (__ \ 'playerState).format[PlayerState] and
      (__ \ 'course).format[Option[Course]] and
      (__ \ 'step).format[Tutorial.Step] and
      (__ \ 'messages).format[Option[Seq[(String,String)]]]
    )(TutorialUpdate.apply, unlift(TutorialUpdate.unapply))

  implicit val raceFormat: Format[Race] = Json.format[Race]

  implicit val raceStatusFormat: Format[RaceStatus] = Json.format[RaceStatus]

  implicit val runFormat: Format[TimeTrialRun] = Json.format[TimeTrialRun]
  implicit val timeTrialFormat: Format[TimeTrial] = Json.format[TimeTrial]
  implicit val richRunFormat: Format[RichRun] = Json.format[RichRun]
}

