/**
 * @jsx React.DOM
 */

var React         = require('react');
var $             = require('jquery');
var Bacon         = require('baconjs');
var bjq           = require('bacon.jquery');
var BaconMixin    = require('react-bacon').BaconMixin;
var _             = require('lodash');
var Board         = require('./board');
var OnlinePlayer  = require('./onlinePlayer');
var Api           = require('./api');
var Messages      = require('./messages');
var util          = require('./util');

var LiveCenter = React.createClass({
  mixins: [BaconMixin],

  getInitialState: function() {
    return {
      racesStatus: [],
      loadingNewRace: false,
      showWebSocketAlert: !window.WebSocket
    };
  },

  componentDidMount: function() {
    this.loadStatus();
    var intervalId = setInterval(this.loadStatus, 1000);
    this.setState({ intervalId: intervalId });
  },

  componentWillUnmount: function() {
    clearInterval(this.state.intervalId);
  },

  loadStatus: function() {
    $.ajax(Api.racesStatus()).done(function(racesStatus) {
      var waiting = _.filter(racesStatus.openRaces, (rs) => !rs.race.startTime).length;
      if (waiting > 0) {
        document.title = "(" + waiting + ") Play Tacks";
      } else {
        document.title = "Play Tacks"
      }
      this.setState({ racesStatus: racesStatus, loadingNewRace: false });
    }.bind(this));
  },

  createRace: function(e) {
    e.preventDefault();
    if (this.state.loadingNewRace) return;

    this.setState({ loadingNewRace: true}, function() {
      util.post(Api.createRace()).done(function(race) {
        setTimeout(function() {
          this.setState({ loadingNewRace: false});
        }.bind(this), 1000);
      }.bind(this));
    }.bind(this));
  },

  onlinePlayers: function(status) {
    return _.map(_.sortBy(status.onlinePlayers, 'id'), function(player) {
      return <OnlinePlayer key={player.id} player={player}/>;
    });
  },

  webSocketAlert: function(show) {
    if (show) {
      return (
        <div className="alert alert-danger">
        {Messages("home.noWebSocketSupport")}
        </div>
        );
    }
  },

  render: function() {
    var st = this.state.racesStatus;
    return (
      <div className="live-center">
        {this.webSocketAlert(this.state.showWebSocketAlert)}

        <h2>{Messages("home.openRaces")}</h2>
        <Board status={st} />
        <a href="" onClick={this.createRace} className={"btn btn-warning btn-block btn-lg btn-new-race" + (this.state.loadingNewRace ? "loading" : "")}>
          {Messages("home.newRace")}
        </a>

        <h2>{Messages("home.onlinePlayers")}</h2>
        <ul className="online-players list-unstyled">{this.onlinePlayers(st)}</ul>
      </div>
    );
  }

});

React.render(<LiveCenter/>, document.getElementById("liveCenter"));
