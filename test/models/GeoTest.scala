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

  test("angleBetween") {
    assert(Geo.angleBetween((0, 0), (10, 0)).round == 90)
    assert(Geo.angleBetween((0, 0), (0, 10)).round == 0)

    assert(Geo.angleBetween((0, 0), (10, 10)).round == 45)
    assert(Geo.angleBetween((0, 0), (10, -10)).round == 135)
    assert(Geo.angleBetween((0, 0), (-10, -10)).round == 225)
    assert(Geo.angleBetween((0, 0), (-10, 10)).round == 315)
  }
}
