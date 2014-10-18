name := "tacks"

version := "1.0-SNAPSHOT"

resolvers += "Sonatype Snapshots" at "https://oss.sonatype.org/content/repositories/snapshots/"

lazy val root = (project in file(".")).enablePlugins(PlayScala)

scalaVersion := "2.11.1"

libraryDependencies ++= Seq(
  "org.reactivemongo" %% "play2-reactivemongo" % "0.10.5.0.akka23",
  "org.mindrot" % "jbcrypt" % "0.3m",
  "org.julienrf" %% "play-jsmessages" % "1.6.2",
  cache,
  ws
)

play.PlayScala.projectSettings

TwirlKeys.templateImports ++= Seq(
  "org.joda.time.DateTime"
)

scalacOptions += "-feature"
