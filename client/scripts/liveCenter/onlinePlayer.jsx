/**
 * @jsx React.DOM
 */

var React = require('react');
var PlayerWithAvatar = require('./playerWithAvatar');
var Messages = require('../messages');

var OnlinePlayer = React.createClass({

  render: function() {
    var p = this.props.player;
    var status = p.status ? (<span className="status">{p.status}</span>) : "";
    var hoverTitle = p.user ? Messages("liveCenter.user") : Messages("liveCenter.guest");

    return (
      <li title={ hoverTitle }>
        <PlayerWithAvatar player={ p } withLink={ true } />
        {status}
      </li>
    );
  }

});

module.exports = OnlinePlayer;
