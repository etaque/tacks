/**
 * @jsx React.DOM
 */

var React    = require('react');
var _        = require('lodash');
var moment   = require('moment');
var util     = require('../util');
var Messages = require('../messages');
var PlayerWithAvatar = require('./playerWithAvatar');

var RaceCourse = React.createClass({

  getPlayers: function(playerStates) {
    if (playerStates.length == 0) {
      return <span className="empty">{ Messages("home.emptyRaceCourse") }</span>;
    } else {
      return _.map(playerStates, p => {
        return <PlayerWithAvatar player={p.player} withLink={ true } />;
      });
    }
  },

  render: function() {
    var s = this.props.status;
    var players = this.getPlayers(s.opponents);

    return (
      <div className="col-md-3">
        <div className="race-course">
          <a href={ "/course/" + s.raceCourse._id} target="_blank" className="name" title={ Messages("generators." + s.raceCourse.slug + ".description") }>
            { Messages("generators." + s.raceCourse.slug + ".name") }
          </a>
          <div className="players">{ players }</div>
        </div>
      </div>
    );
  }

});

module.exports = RaceCourse;
