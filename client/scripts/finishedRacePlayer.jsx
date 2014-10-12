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
      (this.props.finished ?
        "+ " + Math.round(this.props.fromFirst / 10) / 100 + "\"":
        "DNF");
    return (
      <tr>
        <td>{this.props.position}. {this.props.handle || "Anonymous"}</td>
        <td className="time">{dt}</td>
      </tr>
      );
  }

});

module.exports = FinishedRacePlayer;