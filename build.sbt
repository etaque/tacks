name := "tacks"

val timestamp = new java.text.SimpleDateFormat("yyyyMMdd-HHmm").format(new java.util.Date)

version := s"$timestamp"

resolvers += "Sonatype Snapshots" at "https://oss.sonatype.org/content/repositories/snapshots/"

resolvers += "Kaliber Internal Repository" at "https://jars.kaliber.io/artifactory/libs-release-local"

lazy val root = (project in file(".")).enablePlugins(PlayScala)

libraryDependencies ++= Seq(
  ws,
  "com.typesafe.play" %% "play-slick" % "1.1.1",
  "com.typesafe.play" %% "play-slick-evolutions" % "1.1.1",
  "com.github.tminglei" %% "slick-pg" % "0.11.2",
  "com.github.tminglei" %% "slick-pg_joda-time" % "0.11.2",
  "com.github.tminglei" %% "slick-pg_play-json" % "0.11.2",
  "org.mindrot" % "jbcrypt" % "0.3m",
  "io.prismic" %% "scala-kit" % "1.2.13",
  "com.sksamuel.scrimage" %% "scrimage-core" % "1.4.2",
  "net.kaliber" %% "play-s3" % "7.0.2",
  "org.scalacheck" %% "scalacheck" % "1.12.1" % "test",
  "org.scalatest" %% "scalatest" % "2.2.2" % "test"
)

play.PlayScala.projectSettings

scalacOptions += "-feature"

offline := true
