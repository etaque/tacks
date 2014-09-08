package models

import models.Geo._
import play.api.libs.json.{Json, Format}


case class Spell(
  kind: String,
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
    position = course.randomPoint,
    radius = 5,
    spell = Spell(
      kind = nextInt(2) match {
        case 0 => "PoleInversion"
        case _ => "Fog"
      },
      duration = 10))

  implicit val spellFormat: Format[Spell] = Json.format[Spell]
  implicit val buoyFormat: Format[Buoy] = Json.format[Buoy]
}
