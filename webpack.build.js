const webpack = require('webpack');
const ExtractTextPlugin = require('extract-text-webpack-plugin');

module.exports = {
  entry: './client/src/index.js',

  output: {
    path: './public/dist',
    filename: 'main.js'
  },

  resolve: {
    modulesDirectories: ['node_modules'],
    extensions: ['', '.js', '.elm']
  },

  module: {
    loaders: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        loader: 'babel',
        query: {
          presets: ['es2015']
        }
      },
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        loader: 'elm-webpack'
      },
      {
        test: /\.(css|scss)$/,
        loader: ExtractTextPlugin.extract('style-loader', [
          'css-loader',
          'sass-loader'
        ])
      }
    ],

    noParse: /\.elm$/
  },

  plugins: [
    // extract CSS into a separate file
    new ExtractTextPlugin('main.css', { allChunks: true }),

    // minify & mangle JS/CSS
    new webpack.optimize.UglifyJsPlugin({
      minimize: true,
      compressor: { warnings: false },
      mangle: true
    })
  ]
};
