/**
 * @jsx React.DOM
 */

var React      = require('react');
var _          = require('lodash');
var BaconMixin = require('react-bacon').BaconMixin;
var BoardLine  = require('./boardLine');

var Board = React.createClass({

  render: function() {
    var items = _.map(this.props.status.races, status => {
      return (<BoardLine key={status.race._id} raceStatus={status} now={this.props.status.now}/>)
    }, this);

    if (_.isEmpty(items)) {
      return <div/>;
    } else {
      return (
        <div className="races-board">
          <table>
            <caption>Open races</caption>
            <thead>
              <tr>
                <th>Creation</th>
                <th>Opponents</th>
                <th>Start</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              {items}
            </tbody>
          </table>
        </div>
      );
    }
  }

});

module.exports = Board;
