package views

object Helpers {

  def round3(n: Double): Double = math.round(n * 1000) * 0.001

  def timer(t: Long): String = {
    val c = math.ceil(t / 1000).toInt
    val m = math.floor(c / 60).toInt
    val s = "%02d".format(c % 60)
    val ms = "%03d".format(t % 1000)
    s"$m:$s.$ms"
  }

  def timeDelta(t: Long): String = {
    val s = t / 1000
    val ms = "%03d".format(t % 1000)
    s"+ $s.$ms"
  }

}
