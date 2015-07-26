/**
 * @jsx React.DOM
 */

"use strict";

var React         = require('react');
var $             = require('jquery');
var _             = require('lodash');
var RaceCourseBoard = require('./liveCenter/raceCourseBoard');
var Board         = require('./liveCenter/board');
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
        <RaceCourseBoard raceCourses={ st.raceCourses } />
      </div>
    );
  }

});

module.exports = LiveCenter;
