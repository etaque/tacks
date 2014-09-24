/**
 * @jsx React.DOM
 */

var React              = require('react');
var _                  = require('lodash');
var moment             = require('moment');
var FinishedRacePlayer = require('./finishedRacePlayer')

var FinishedRace = React.createClass({

  render: function() {
    var r = this.props.race;
    var h = moment(r.startTime).format("dddd HH:mm");
    var bestTime = r.tally[0].gates[0];
    var gatesCount = r.tally[0].gates.length

    var players = _(r.tally)
      .map((entry, i) => {
        var fromFirst = entry.gates[0] - bestTime;
        var finished = entry.gates.length == gatesCount;
        var time = entry.gates[0] - r.startTime;
        return <FinishedRacePlayer key={entry.player._id} player={entry.player} position={i + 1}
                time={time} fromFirst={fromFirst} finished={finished} />;
      })
      .value();

    return <div className="finished-race">
      <h4>{h}</h4>
      <table><tbody>{players}</tbody></table></div>;
  }

});

module.exports = FinishedRace;