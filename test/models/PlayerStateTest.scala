package models

import org.scalatest.FunSuite
import org.scalatest.prop.PropertyChecks
import org.scalacheck.Gen

class PlayerStateTest extends FunSuite with PropertyChecks {

  val player = Guest()
  val baseState = PlayerState.initial(player).copy(
    upwindVmg = Vmg(45, 0, 0),
    downwindVmg = Vmg(150, 0, 0),
    windOrigin = 5
  )

  test("headingOnVmg") {
    assert(baseState.copy(heading = 0).closestVmgAngle == 45)
    assert(baseState.copy(heading = 0).closestVmgAngle == 45)
  }

//  val windOrigins = for(n <- Gen.choose[Double](0, 360)) yield n
//  val headings = for(n <- Gen.choose[Double](0, 360)) yield n
//
//  forAll((windOrigins, "windOrigin"), (headings, "heading")) { (windOrigin: Double, heading: Double) =>
//
//    val state = baseState.copy(windOrigin = windOrigin, heading = heading, windAngle = Geo.angleDelta(heading, windOrigin))
//
//    assert(state.headingOnVmg)
//    val x = raceArea.genX(seed, margin)
//    assert(x >= raceArea.left + margin)
//    assert(x <= raceArea.right - margin)
//  }
}
