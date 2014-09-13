/**
 * @jsx React.DOM
 */

var React = require('react');
var $     = require('jquery');
var Api   = require('./api');
var Game  = require('./game');

var PlayRace = React.createClass({

  getInitialState: function() {
    return {
      race: null,
      initialUpdate: null,
      ws: null
    };
  },

  componentDidMount: function() {
    var raceId = this.props.params.id
    $.ajax(Api.getRace(raceId)).done(function(response) {
      var ws = new WebSocket(Api.playerSocket(raceId).webSocketURL());
      this.setState({
        race: response.race,
        initialUpdate: response.initialUpdate,
        ws: ws
      });
    }.bind(this));

  },

  render: function() {
    if(this.state.ws) {
      return (
        <Game ws={this.state.ws} initialUpdate={this.state.initialUpdate} />
        );
    } else {
      return <div className="loading-game">Loading game...</div>;
    }
  }

});

module.exports = PlayRace;