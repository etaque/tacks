/**
 * @jsx React.DOM
 */

var React        = require('react');
var _            = require('lodash');
var FinishedRace = require('./finishedRace');

var FinishedRaces = React.createClass({

  render: function() {
    var items = _.map(this.props.races, race => {
      return (<FinishedRace race={race} />)
    }, this);

    if (_.isEmpty(items)) {
      return <div/>;
    } else {
      return (
        <div className="finished-races">
          <h3>Recent races</h3>
          {items}
        </div>
      );
    }
  }

});

module.exports = FinishedRaces;