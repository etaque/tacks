/**
 * @jsx React.DOM
 */

var React = require('react');

var Game = React.createClass({

  componentDidMount: function() {
    var ws = this.props.ws;

    var game = Elm.embed(Elm.Main, this.getDOMNode(), { raceInput: this.props.initialUpdate });

    ws.onmessage = function(event) {
      var data = JSON.parse(event.data);
      game.ports.raceInput.send(data);
    };

    ws.onopen = function() {
      game.ports.playerOutput.subscribe(function(state) {
        state.name = "test";
        ws.send(JSON.stringify(state))
      });
    };
  },

  shouldComponentUpdate: function(nextProps, nextState) {
    return false;
  },

  render: function() {
    return <div className="game" />;
  }

});

module.exports = Game;