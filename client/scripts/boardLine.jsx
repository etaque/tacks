/**
 * @jsx React.DOM
 */

var React    = require('react');
var _        = require('lodash');
var moment   = require('moment');
var util     = require('./util');
var Messages = require('./messages');


var BoardLine = React.createClass({

  getPlayerNames: function(playerStates, master) {
    if (_.isEmpty(playerStates)) {
      return "-";
    } else {
      return _.map(playerStates, p => {
        return p.player.handle || Messages("anonymous");
      }).join(" vs ");
    }
  },

  getStartText: function(millis) {
    if (millis) {
      if (millis > 0) return util.timer(millis);
      else return Messages("liveCenter.startedSince", util.timer(Math.abs(millis)));
    } else {
      return Messages("liveCenter.waiting");
    }
  },

  render: function() {
    var s = this.props.raceStatus;
    var h = moment(s.race.creationTime).format("HH:mm");
    var players = this.getPlayerNames(s.playerStates, s.master);
    var millis = s.startTime ? (s.startTime - this.props.now) : null;

    return (
      <tr>
        <td>{h} by {s.master.handle || Messages('anonymous')}</td>
        <td>{players}</td>
        <td>{this.getStartText(millis)}</td>
        <td>
          <a href={"/play/" + s.race._id} target="_blank" className="btn btn-xs btn-block btn-primary">{Messages('liveCenter.join')}</a>
          <a href={"/watch/" + s.race._id} target="_blank" className="btn btn-xs btn-block btn-default">{Messages('liveCenter.watch')}</a>
        </td>
      </tr>);
  }

});

module.exports = BoardLine;
