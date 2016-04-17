package tools

import java.io.ByteArrayInputStream
import java.util.zip.{ GZIPInputStream, GZIPOutputStream }
import org.apache.commons.codec.binary.Base64
import org.apache.commons.io.IOUtils
import org.apache.commons.io.output.ByteArrayOutputStream
import scala.util.Try

object Gzip {
  // compresse
  def deflate(txt: String): Try[String] = Try {
    val arrOutputStream = new ByteArrayOutputStream()
    val zipOutputStream = new GZIPOutputStream(arrOutputStream)
    zipOutputStream.write(txt.getBytes)
    zipOutputStream.close()
    Base64.encodeBase64String(arrOutputStream.toByteArray)
  }

  // décompresse
  def inflate(deflatedTxt: String): Try[String] = Try {
    val bytes = Base64.decodeBase64(deflatedTxt)
    val zipInputStream = new GZIPInputStream(new ByteArrayInputStream(bytes))
    IOUtils.toString(zipInputStream)
  }
}
