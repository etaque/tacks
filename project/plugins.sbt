resolvers += "Typesafe repository" at "http://repo.typesafe.com/typesafe/releases/"

dependencyOverrides += "org.scala-sbt" % "sbt" % "0.13.8"

addSbtPlugin("com.typesafe.play" % "sbt-plugin" % "2.4.6")

addSbtPlugin("com.typesafe.sbt" % "sbt-digest" % "1.0.0")
