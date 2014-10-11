package views

object Helpers {

  def timer(ms: Long) = {
    val c = Math.ceil(ms / 1000)
    val m = Math.floor(c / 60)
    val s = c % 60
    if (m == 0) s"""$s\""""
    else s"""$m' $s\""""
  }

}
