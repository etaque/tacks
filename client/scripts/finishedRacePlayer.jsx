/**
 * @jsx React.DOM
 */

var React  = require('react');
var _      = require('lodash');
var moment = require('moment');
var util   = require('./util');

var FinishedRacePlayer = React.createClass({

  render: function() {
    var dt = this.props.position == 1 ? util.timer(this.props.time) :
      (this.props.finished ? "+" + util.timer(this.props.fromFirst) : "DNF");
    return (
      <tr>
        <td>{this.props.position}. {this.props.player.name}</td>
        <td className="time">{dt}</td>
      </tr>
      );
  }

});

module.exports = FinishedRacePlayer;