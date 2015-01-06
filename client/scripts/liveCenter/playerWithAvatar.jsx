/**
 * @jsx React.DOM
 */

var React = require('react');
var Messages = require('../messages');

var PlayerWithAvatar = React.createClass({

  render: function() {
    var p = this.props.player;
    var avatarUrl = p.avatarId ? ("/avatars/" + p.avatarId) : "/assets/images/default-avatar.png";

    var img = <img src={ avatarUrl } className="avatar" width="19" height="19" />;
    var handle = <span className="handle">{ p.handle || Messages("anonymous") }</span>;

    if (this.props.withLink && p.handle) {
      return (
        <a href={"/players/" + p.handle} className="user-avatar">
          { img }
          { handle }
        </a>
      );
    } else {
      return (
        <span className="user-avatar">
          { img }
          { handle }
        </span>
      );
    }
  }

});

module.exports = PlayerWithAvatar;
