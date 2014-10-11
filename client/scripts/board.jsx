/**
 * @jsx React.DOM
 */

var React      = require('react');
var _          = require('lodash');
var BoardLine  = require('./boardLine');

var Board = React.createClass({

  render: function() {
    var items = _.map(this.props.status.openRaces, status => {
      return (<BoardLine key={status.race._id} raceStatus={status} now={this.props.status.now}/>)
    }, this);

    if (_.isEmpty(items)) {
      return <div/>;
    } else {
      return (
        <div className="races-board">
          <table>
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
