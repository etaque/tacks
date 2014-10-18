package views.bootstrap3

import play.api.data.Field
import play.api.i18n.Messages
import play.twirl.api.Html

object Helpers {
  def isRequired(field: Field) = field.constraints.map(_._1).contains("constraint.required")

  def errorMessage(formElement: Field) = Html(formElement.errors.map(e => Messages(e.message, e.args: _*)).mkString("<br>"))
}
