package models

import org.scalatest.FunSuite
import org.scalatest.prop.PropertyChecks
import org.scalacheck.Gen

class CourseTest extends FunSuite with PropertyChecks {

  val raceArea = RaceArea((800, 700), (-800, -300))

  val xMargins = for(n <- Gen.choose[Double](0, raceArea.width / 3)) yield n
  val yMargins = for(n <- Gen.choose[Double](0, raceArea.height / 3)) yield n
  val seeds = for(n <- Gen.choose[Double](0, 1000000)) yield n

  forAll((xMargins, "margin"), (seeds, "seed")) { (margin: Double, seed: Double) =>
    val x = raceArea.genX(seed, margin)
    assert(x >= raceArea.left + margin)
    assert(x <= raceArea.right - margin)
  }
  
  forAll((yMargins, "margin"), (seeds, "seed")) { (margin: Double, seed: Double) =>
    val y = raceArea.genY(seed, margin)
    assert(y >= raceArea.left + margin)
    assert(y <= raceArea.right - margin)
  }

}
