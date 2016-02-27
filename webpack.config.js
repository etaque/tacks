module.exports = {
  entry: './client/src/index.js',

  output: {
    path: './public/javascripts',
    filename: 'bundle.js'
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
        test: /\.scss$/,
        loaders: ['style', 'css', 'sass']
      }
    ],

    noParse: /\.elm$/
  }
};
