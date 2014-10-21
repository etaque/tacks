package models

import org.scalatest.FunSuite

class GeoTest extends FunSuite {
  test("inSector") {
    assert(Geo.inSector(10, 15)(12))
    assert(Geo.inSector(350, 15)(12))
    assert(Geo.inSector(350, 15)(355))
    assert(Geo.inSector(153, 183)(182))

    assert(!Geo.inSector(10, 15)(5))
    assert(!Geo.inSector(10, 15)(20))
    assert(!Geo.inSector(350, 15)(340))
    assert(!Geo.inSector(350, 15)(40))
  }
}
