/**
 * @jsx React.DOM
 */

var React = require('react');

var OnlinePlayer = React.createClass({

  userTag: function(user) {
    return (
      <a href={"/users/" + user.handle} className="player">
        {user.handle}
        <span className="status">{user.name}</span>
      </a>
    );
  },

  guestTag: function(guest) {
    return <span className="player">Anonymous</span>;
  },

  render: function() {
    var p = this.props.player;
    return (
      <li>{p.handle ? this.userTag(p) : this.guestTag(p)}</li>
    );
  }

});

module.exports = OnlinePlayer;