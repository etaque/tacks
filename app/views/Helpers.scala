package views

object Helpers {

  def round3(n: Double): Double = math.round(n * 1000) * 0.001

  def timer(ms: Long): String = {
    val c = math.ceil(ms / 1000).toInt
    val m = math.floor(c / 60).toInt
    val s = c % 60
    if (m == 0) s"""$s\""""
    else s"""$m' $s\""""
  }

  def timeDelta(ms: Long): String = "+ " + "%1.3f".format(ms * 0.001) + "\""
}
