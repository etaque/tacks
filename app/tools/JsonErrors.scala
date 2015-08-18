package tools

import play.api.libs.json._
import play.api.libs.concurrent.Execution.Implicits._
import play.api.data.validation._
import play.api.i18n.{Messages, Lang}
import play.api.data.validation.ValidationError


/**
* Formats JSON validation errors to a readable and exploitable JSON.
*/
object JsonErrors {

  def format(error: JsError)(implicit lang: Lang): JsObject = {
    format(error.errors)
  }

  def format(errors: Seq[(JsPath, Seq[ValidationError])])(implicit lang: Lang): JsObject = {
    val result = errors.map { case (path, validationErrors) =>
      val field = path.toJsonString.drop("obj.".size)
      val translatedErrors = validationErrors.map(e => Messages(e.message, e.args: _*))
      field -> translatedErrors
    }.toMap

    Json.toJson(result).as[JsObject]
  }

  def one(path: String, msgKey: String)(implicit lang: Lang): JsObject = {
    Json.obj(path -> Json.arr(Messages(msgKey)))
  }

  // To use when a read is failing to provide a custom error message
  def customErrorReader[T](field: JsPath, error: String)(implicit lang: Lang): Reads[T] = {
    Reads(_ =>
      JsError(field, ValidationError(Messages(error)))
    )
  }

  // def passwordCheckError(f: String) = Reads[String](_ => JsError(__ \ f, "Le mot de passe et la confirmation doivent être identiques"))
}
