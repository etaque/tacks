name := "shiftmaster"

version := "1.0-SNAPSHOT"

resolvers += "Sonatype Snapshots" at "https://oss.sonatype.org/content/repositories/snapshots/"

lazy val root = (project in file(".")).enablePlugins(PlayScala)

scalaVersion := "2.11.1"

libraryDependencies ++= Seq(
  "org.reactivemongo" %% "play2-reactivemongo" % "0.10.5.akka23-SNAPSHOT",
  "org.mindrot" % "jbcrypt" % "0.3m",
  cache,
  ws
)

play.PlayScala.projectSettings

TwirlKeys.templateImports ++= Seq(
  "org.joda.time.DateTime"
)

scalacOptions += "-feature"
