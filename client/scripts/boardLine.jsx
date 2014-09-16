/**
 * @jsx React.DOM
 */

var React  = require('react');
var Router = require('react-router');
var _      = require('lodash');
var moment = require('moment');

var Link = Router.Link;

var BoardLine = React.createClass({

  getPlayerNames: function(playerStates, master) {
    return _.map(playerStates, ps => {
      var id = ps[0],
          p = ps[1];
      return p.player.name + (id === master.id ? "*" : "");
    }).join(" vs ");
  },

  getSecondsFromStart: function(startTime, now) {
    return startTime ? Math.ceil((startTime - now) / 1000) : null;
  },

  getStartText: function(seconds) {
    if (seconds) {
      if (seconds > 0) return "start in " + seconds + "s!";
      else return "started since " + Math.abs(seconds) + "s";
    } else {
      return "to be started";
    }
  },

  render: function() {
    var s = this.props.raceStatus;
    var h = moment(s.race.creationTime).format("HH:mm");
    var players = this.getPlayerNames(s.playerStates, s.master);
    var seconds = this.getSecondsFromStart(s.startTime, this.props.now)

    return (
      <li>
        <Link to="playRace" params={{id: s.race._id}}>
          {h} : {players} / {this.getStartText(seconds)}
        </Link>
      </li>);
  }

});

module.exports = BoardLine;
