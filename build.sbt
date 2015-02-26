name := "tacks"

version := "1.0-SNAPSHOT"

resolvers += "Sonatype Snapshots" at "https://oss.sonatype.org/content/repositories/snapshots/"

lazy val root = (project in file(".")).enablePlugins(PlayScala)

scalaVersion := "2.11.4"

libraryDependencies ++= Seq(
  "org.reactivemongo" %% "play2-reactivemongo" % "0.10.5.0.akka23",
  "org.mindrot" % "jbcrypt" % "0.3m",
  "org.julienrf" %% "play-jsmessages" % "1.6.2",
  "io.prismic" %% "scala-kit" % "1.2.13",
  "com.sksamuel.scrimage" %% "scrimage-core" % "1.4.2",
  "org.scalacheck" %% "scalacheck" % "1.12.1" % "test",
  "org.scalatest" %% "scalatest" % "2.2.2" % "test",
  cache,
  ws
)

play.PlayScala.projectSettings

TwirlKeys.templateImports ++= Seq(
  "org.joda.time.DateTime",
  "views.Helpers._",
  "tools.DateFormats._"
)

initialCommands in console := """implicit val app = new play.core.StaticApplication(new java.io.File("."))"""

scalacOptions += "-feature"
