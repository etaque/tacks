/**
 * @jsx React.DOM
 */

"use strict";

var React         = require('react');
var $             = require('jquery');
var _             = require('lodash');
var Board         = require('./liveCenter/board');
var OnlinePlayer  = require('./liveCenter/onlinePlayer');
var Messages      = require('./messages');
var routes        = require('./routes');
var util          = require('./util');

var LiveCenter = React.createClass({

  getInitialState: function() {
    return {
      racesStatus: {},
      loadingNewRace: false,
      showWebSocketAlert: !window.WebSocket,
      generator: null
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
    var currentGenerator = this.state.generator;
    $.ajax(routes.Api.racesStatus()).done(function(racesStatus) {
      var waiting = _.filter(racesStatus.openRaces, function(rs) { return !rs.race.startTime }).length;
      if (waiting > 0) {
        document.title = "(" + waiting + ") Play Tacks";
      } else {
        document.title = "Play Tacks"
      }
      var generator = currentGenerator || racesStatus.generators[0];
      this.setState({ racesStatus: racesStatus, loadingNewRace: false, generator: generator });
    }.bind(this));
  },

  createRace: function(e) {
    e.preventDefault();
    if (this.state.loadingNewRace) return;

    this.setState({ loadingNewRace: true}, function(newState) {
      util.post(routes.Api.createRace(this.state.generator)).done(function(race) {
        setTimeout(function() {
          this.setState({ loadingNewRace: false});
        }.bind(this), 1000);
      }.bind(this));
    }.bind(this));
  },

  setGenerator: function(e) {
    e.preventDefault();
    this.setState({
      generator: $(e.target).val()
    });
  },

  generatorOptions: function(generators) {
    return _.map(generators, function(c) {
      return <option value={ c } key={c}>{ Messages("generators." + c + ".name") }</option>;
    });
  },

  onlineUsers: function(players) {
    return _(players)
      .filter('handle')
      .sortBy('id')
      .map(function(player) {
        return <OnlinePlayer key={player.id} player={player}/>;
      })
      .value();
  },

  onlineGuests: function(players) {
    var c = _.reject(players, 'handle').length;
    return c > 1 ? Messages("home.onlineGuestsMany", c) : Messages("home.onlineGuestsOne");
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
    var btnClassName = "btn btn-primary btn-block btn-new-race " + (this.state.loadingNewRace ? "loading" : "");
    return (
      <div className="live-center">
        {this.webSocketAlert(this.state.showWebSocketAlert)}

        <div className="row">
          <div className="col-md-9">
            <h3>{Messages("home.openRaces")}</h3>
            <Board status={st} />
            <div className="row row-new-race">
              <div className="col-md-4 form-group">
                <select className="form-control" onChange={ this.setGenerator } value={ this.state.generator }>
                  { this.generatorOptions(st.generators) }
                </select>
              </div>
              <div className="col-md-8 form-group">
                <a href="" onClick={ this.createRace } className={ btnClassName }>
                  { Messages("home.newRace") }
                </a>
              </div>
            </div>
          </div>
          <div className="col-md-3">
            <h3>{Messages("home.onlinePlayers")}</h3>
            <ul className="online-users list-unstyled">{this.onlineUsers(st.onlinePlayers)}</ul>
            <div className="online-guests">{this.onlineGuests(st.onlinePlayers)}</div>
          </div>
        </div>
      </div>
    );
  }

});

module.exports = LiveCenter;
