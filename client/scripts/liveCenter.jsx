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
var FinishedRaces = require('./finishedRaces');
var OnlinePlayer  = require('./onlinePlayer');
var Api           = require('./api');
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
    return _.map(_.sortBy(status.onlinePlayers, 'handle'), function(player) {
      return <OnlinePlayer player={player}/>;
    });
  },

  webSocketAlert: function(show) {
    if (show) {
      return (
        <div className="alert alert-danger">
          Your browser doesn't support WebSocket technology. Please use a <a href="http://caniuse.com/#feat=websockets">compatible web browser</a> to enjoy Tacks.
        </div>
        );
    }
  },

  render: function() {
    var st = this.state.racesStatus;
    return (
      <div className="live-center">
        {this.webSocketAlert(this.state.showWebSocketAlert)}
        <div className="row">
          <div className="col-md-8">
            <h2>Open races</h2>
            <Board status={st} />
            <a href="" onClick={this.createRace} className={"btn btn-warning btn-block btn-lg btn-new-race" + (this.state.loadingNewRace ? "loading" : "")}>New race</a>
          </div>

          <div className="col-md-4">
            <h2>Online players</h2>
            <ul className="online-players list-unstyled">{this.onlinePlayers(st)}</ul>
          </div>
        </div>
      </div>
    );
  }

});

React.renderComponent(<LiveCenter/>, document.getElementById("liveCenter"));
