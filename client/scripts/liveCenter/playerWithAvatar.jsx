/**
 * @jsx React.DOM
 */

var React = require('react');
var Messages = require('../messages');

var PlayerWithAvatar = React.createClass({

  getAvatarUrl: function(player) {
    if (player.avatarId) {
      return "/avatars/" + player.avatarId;
    } else if (player.guest) {
      return "/assets/images/avatar-guest.png";
    } else {
      return "/assets/images/avatar-user.png";
    }
  },

  render: function() {
    var p = this.props.player;
    var avatarUrl = this.getAvatarUrl(p);

    var img = <img src={ avatarUrl } className="avatar" width="19" height="19" />;
    var handle = <span className="handle">{ p.handle || Messages("anonymous") }</span>;

    if (this.props.withLink && p.user) {
      return (
        <a href={"/players/" + p.handle} className="player-avatar">
          { img }
          { " " }
          { handle }
        </a>
      );
    } else {
      return (
        <span className="player-avatar">
          { img }
          { " " }
          { handle }
        </span>
      );
    }
  }

});

module.exports = PlayerWithAvatar;
