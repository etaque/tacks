TACKS
=====

A sailing race simulator, multiplayer & realtime, using web stack and modern browser technologies (websockets).

Server app is powered by Scala 2.11 with Play 2.3, Akka and uses MongoDB for database. No classes except actors, code is written in a functional style. 

Game client is an [Elm](http://elm-lang.org/) app, an awesome statically-typed FRP language that compiles to Javascript. Welcome to the world of pureness!

How to install
--------------

Server (Play app): 

 - download and install [Typesafe Activator](https://typesafe.com/activator)
 - start app with `activator run`

LiveCenter client (React component):

 - `cd client`
 - `npm install`
 - `./node_modules/gulp/bin/gulp.js`

Development
-----------

Race rendering and player input logic is handled by Elm app. Players moving, sync and race management done on server in Akka actors.

You will have to install [Elm platform](https://github.com/elm-lang/elm-platform/blob/master/README.md#elm-platform) if you want to play with client code. It might take some time.

Once you get `elm` command working, cd to `game` then run `./genGame` after each `*.elm` file update.
