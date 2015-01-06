/**
 * @jsx React.DOM
 */

var React     = require('react');
var _         = require('lodash');
var BoardLine = require('./boardLine');
var Messages  = require('../messages');

var Board = React.createClass({

  render: function() {
    var items = _.map(this.props.status.openRaces, status => {
      return (<BoardLine key={status.race._id} raceStatus={status} now={this.props.status.now}/>)
    }, this);

    if (_.isEmpty(items)) {
      return <div className="empty-board">{Messages('liveCenter.emptyBoard')}</div>;
    } else {
      return (
        <table className="table-open-races">
          <thead>
            <tr>
              <th className="generator">{Messages('liveCenter.generator')}</th>
              <th>{Messages('liveCenter.master')}</th>
              <th>{Messages('liveCenter.opponents')}</th>
              <th>{Messages('liveCenter.countdown')}</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            {items}
          </tbody>
        </table>
      );
    }
  }

});

module.exports = Board;
