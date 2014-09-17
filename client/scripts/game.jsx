/**
 * @jsx React.DOM
 */

var React = require('react');
var util  = require('./util');

var Game = React.createClass({

  componentDidMount: function() {
    var ws = this.props.ws;

    var game = Elm.embed(Elm.Main, this.getDOMNode(), { raceInput: this.props.initialUpdate });

    var previousData = {};
    var started = false;

    ws.onmessage = function(event) {
      var data = JSON.parse(event.data);
      if (data.startTime) {
        if (data.now < data.startTime) {
          document.title = "Start in " + util.timer(data.startTime - data.now);
        } else {
          if (!started) {
            started = true;
            document.title = "Race started!"
          }
        }
      }
      game.ports.raceInput.send(data);
      previousData = data;
    };

    ws.onopen = function() {
      var portHandler = function(state) {
        ws.send(JSON.stringify(state))
      }
      this.setState({
        portHandler: portHandler,
        game: game
      }, function() {
        game.ports.playerOutput.subscribe(portHandler);
      });
    }.bind(this);
  },

  componentWillUnmount: function() {
    if (this.state.game) {
      this.state.game.ports.playerOutput.unsubscribe(this.state.portHandler);
    }
  },

  shouldComponentUpdate: function(nextProps, nextState) {
    return false;
  },

  render: function() {
    return <div className="game" />;
  }

});

module.exports = Game;