package models

import org.scalatest.FunSuite

class CourseTest extends FunSuite {

  val raceArea = RaceArea((800, 700), (-800, -300))

  test("genX") {
    assert(raceArea.genX(0, 100) === -700)
    assert(raceArea.genX(1400, 100) === 700)
    assert(raceArea.genX(3000, 100) === 700)
    assert(raceArea.genX(200, 0) === -600)
  }

}
