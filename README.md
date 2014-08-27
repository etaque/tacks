Shiftmaster
===========

A sailing race simulator, multiplayer & realtime, using modern web stack and browser technologies.

Server is a Play 2.3 app. Client (game) is an Elm app (compiled to Javascript).

How to install
--------------

 - download and install [Typesafe Activator](https://typesafe.com/activator)
 - start app with `activator run`

Development
-----------

You will need to install [Elm platform](http://elm-lang.org/) to modify the client. Once you get `elm` command working, 
run `elm --only-js --make Main.elm && cp build/Main.js ../public/javascripts/game.js` in `game/` directory 
after each `*.elm` file update
