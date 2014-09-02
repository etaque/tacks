TACKS
=====

A sailing race simulator, multiplayer & realtime, using modern web stack and browser technologies.

Server is written in Scala 2.11 with Play 2.3, Akka and uses MongoDB for database. Client is an [Elm](http://elm-lang.org/) app (FRP language that compiles to Javascript).

How to install
--------------

 - download and install [Typesafe Activator](https://typesafe.com/activator)
 - start app with `activator run`

Development
-----------

Boat moving logic is done in Elm client. Players sync and race management done in server.

You will need to install [Elm platform](https://github.com/elm-lang/elm-platform/blob/master/README.md#elm-platform) to modify the client. Might take some time.

Once you get `elm` command working, run `elm --only-js --make Main.elm && cp build/Main.js ../public/javascripts/game.js` in `game/` directory after each `*.elm` file update.
