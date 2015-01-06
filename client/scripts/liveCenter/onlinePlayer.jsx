/**
 * @jsx React.DOM
 */

var React = require('react');
var PlayerWithAvatar = require('./playerWithAvatar');

var OnlinePlayer = React.createClass({

  render: function() {
    var p = this.props.player;
    var status = p.status ? (<span className="status">{p.status}</span>) : "";
    return (
      <li>
        <PlayerWithAvatar player={ p } withLink={ true } />
        {status}
      </li>
    );
  }

});

module.exports = OnlinePlayer;
