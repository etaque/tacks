/**
 * @jsx React.DOM
 */

var React  = require('react');
var _      = require('lodash');
var moment = require('moment');
var util   = require('./util');


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

  getStartText: function(millis) {
    if (millis) {
      if (millis > 0) return util.timer(millis);
      else return "started since " + util.timer(Math.abs(millis));
    } else {
      return "to be started";
    }
  },

  render: function() {
    var s = this.props.raceStatus;
    var h = moment(s.race.creationTime).format("HH:mm");
    var players = this.getPlayerNames(s.playerStates, s.master);
    var millis = s.startTime ? (s.startTime - this.props.now) : null;

    return (
      <tr>
        <td>{h} by {s.master.name}</td>
        <td>{players}</td>
        <td>{this.getStartText(millis)}</td>
        <td><a href={"/race/" + s.race._id} target="blank">Join</a></td>
      </tr>);
  }

});

module.exports = BoardLine;
