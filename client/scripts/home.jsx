/**
 * @jsx React.DOM
 */

var React      = require('react');
var BaconMixin = require('react-bacon').BaconMixin;
var Router     = require('react-router');
var $          = require('jquery');
var _          = require('lodash');
var Board      = require('./board');
var Api        = require('./api');
var util       = require('./util');

var Home = React.createClass({
  mixins: [BaconMixin],

  getInitialState: function() {
    return {
      userName: null,
      racesStatus: []
    };
  },

  componentWillMount: function() {
    this.plug(this.props.userName.changes(), 'userName');
    this.setState({ userName: this.props.userName.get() });
  },

  componentDidMount: function() {
    this.loadStatus()
    var intervalId = setInterval(this.loadStatus, 1000);
    this.setState({ intervalId: intervalId });
  },

  componentWillUnmount: function() {
    clearInterval(this.state.intervalId);
  },

  loadStatus: function() {
    $.ajax(Api.racesStatus()).done(function(racesStatus) {
      this.setState({ racesStatus: racesStatus });
    }.bind(this));
  },

  changeName: function(e) {
    e.preventDefault();
    var newName = window.prompt("New name?", this.state.userName);

    util.post(Api.setName(), { name: newName }).done(function(res) {
      this.props.userName.set(newName);
    }.bind(this));
  },

  createRace: function(e) {
    e.preventDefault();
    util.post(Api.createRace()).done(function(race) {
      Router.transitionTo("playRace", { id: race._id});
    });
  },

  render: function() {
    return (
      <div className="home">
        <p>
          Hello {this.state.userName}!{" "}
          <a href="" className="change-name" onClick={this.changeName}>change name</a>
        </p>

        <p><a href="" onClick={this.createRace} className="btn-new-race">Create new race</a></p>

        <Board status={this.state.racesStatus} />

        <p>&nbsp;</p>
        <p>--</p>
        <p>Tacks is a realtime multiplayer sailboat racing game, in your browser. Being in its early stage, it's a bit rough. You'll need Chrome browser on a recent computer.</p>
        <p>Tacks is open source: <a href="https://github.com/etaque/tacks">Github repository</a>. Also, you can follow me (<a href="https://twitter.com/etaque">@etaque</a>) on Twitter.</p>
      </div>
    );
  }

});

module.exports = Home;