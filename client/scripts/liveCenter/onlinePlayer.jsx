/**
 * @jsx React.DOM
 */

var React = require('react');

var OnlinePlayer = React.createClass({

  render: function() {
    var p = this.props.player;
    var avatarUrl = p.avatarId ? ("/avatars/" + p.avatarId) : "/assets/images/default-avatar.png";
    return (
      <li>
        <img src={ avatarUrl }/>
        <span className="handle">{p.handle}</span>
        <span className="status">{p.status}</span>
      </li>
    );
  }

});

module.exports = OnlinePlayer;
