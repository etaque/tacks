TACKS
=====

A sailing race simulator, multiplayer & realtime, using web stack and modern browser technologies (websockets).

Server app is powered by Scala 2.11 with Play 2.3, Akka and uses MongoDB for database. No classes except actors, code is written in a functional style. 

Game client is an [Elm](http://elm-lang.org/) app, an statically-typed FRP language that compiles to Javascript.

Architecture
------------

Server responsabilities:

- Players sync
- Race management

Done withing Akka actors, communicating through Websockets and JSON API with the client (no rendering).

Client responsabilities:

- Single Page App
- Game rendering (SVG)
- Game logic (input handling, player moves, etc)


How to install
--------------

Server (Play app): 

- download and install [Typesafe Activator](https://typesafe.com/activator)
- start app with `activator run`

Client (Elm app with JS boot and SASS stylesheets):

- `cd client`
- `npm install`
- `npm start`
