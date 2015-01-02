/**
 * @jsx React.DOM
 */

var React = require('react');

var OnlinePlayer = React.createClass({

  render: function() {
    var p = this.props.player;
    return (
      <li>
        <span className="handle">{p.handle}</span>
        <span className="status">{p.status}</span>
      </li>
    );
  }

});

module.exports = OnlinePlayer;
