package models

import models.Geo._
import play.api.data.validation.ValidationError
import play.api.libs.json._

sealed trait SpellKind
case object PoleInversion extends SpellKind
case object Fog extends SpellKind

case class Spell(
  kind: SpellKind,
  duration: Int // seconds
)

case class Buoy(
  position: Point,
  radius: Double,
  spell: Spell
)

object Buoy {
  import scala.util.Random._
  def spawn(course: Course) = Buoy(
    position = course.area.randomPoint,
    radius = 5,
    spell = Spell(
      kind = nextInt(2) match {
        case 0 => PoleInversion
        case _ => Fog
      },
      duration = 10))

  implicit val SpellKindFormat: Format[SpellKind] = new Format[SpellKind] {
    override def reads(json: JsValue): JsResult[SpellKind] = json match {
      case JsString("PoleInversion") => JsSuccess(PoleInversion)
      case JsString("Fog") => JsSuccess(Fog)
      case _ @ v => JsError(Seq(JsPath() -> Seq(ValidationError("Expected SpellKind value, got: " + v.toString))))
    }
    override def writes(o: SpellKind): JsValue = JsString(o match {
      case PoleInversion => "PoleInversion"
      case Fog => "Fog"
    })
  }

  implicit val spellFormat: Format[Spell] = Json.format[Spell]
  implicit val buoyFormat: Format[Buoy] = Json.format[Buoy]
}
