# [Tacks](http://www.playtacks.com)

A sailing race simulator, multiplayer & real-time, in you browser.

Server app is powered by Scala 2.11 with Play 2.3, Slick 3, Akka for websockets orchestrations and uses PostgreSQL for database. No classes except actors, code is written in a functional style. 

Game client is an [Elm](http://elm-lang.org/) app, an statically-typed functional language that compiles to Javascript.

## Architecture

Server area:

- Players sync
- Race management

Done withing Akka actors, communicating with the client through Websockets and JSON API. No rendering from the server.

Client area:

- Single Page App
- Game rendering (SVG)
- Game logic (input handling, player moves, etc)


## How to install

Server (Play app): 

- download and install [Typesafe Activator](https://typesafe.com/activator)
- start app with `activator run`

Client (Elm app with JS boot and SASS stylesheets):

- `cd client`
- `npm install`
- `npm start`
