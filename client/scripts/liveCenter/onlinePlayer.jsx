/**
 * @jsx React.DOM
 */

var React = require('react');

var OnlinePlayer = React.createClass({

  render: function() {
    var p = this.props.player;
    var avatarUrl = p.avatarId ? ("/avatars/" + p.avatarId) : "/assets/images/default-avatar.png";
    var status = p.status ? (<span className="status">{p.status}</span>) : "";
    return (
      <li>
        <a href={"/players/" + p.handle}>
          <img src={ avatarUrl }/>
          <span className="handle">{p.handle}</span>
        </a>
        {status}
      </li>
    );
  }

});

module.exports = OnlinePlayer;
