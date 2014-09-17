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
    if (_.isEmpty(playerStates)) {
      return "<empty>";
    } else {
      return _.map(playerStates, ps => {
        var id = ps[0],
            p = ps[1];
        return p.player.name;
      }).join(" vs ");
    }
  },

  getSecondsFromStart: function(startTime, now) {
    return startTime ? Math.ceil((startTime - now) / 1000) : null;
  },

  getStartText: function(seconds) {
    if (seconds) {
      if (seconds > 0) return "" + seconds + "\"";
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
      <tr>
        <td>{h} by {s.master.name}</td>
        <td>{players}</td>
        <td>{this.getStartText(seconds)}</td>
        <td><a href={"/race/" + s.race._id} target="blank">Join</a></td>
      </tr>);
  }

});

module.exports = BoardLine;
