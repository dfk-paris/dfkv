const path = require('path')

module.exports = (env, argv) => {
  const mode = argv.mode || 'development'

  return {
    mode: mode,
    entry: {
      app: __dirname + '/src/app.js',
      demo: __dirname + '/src/demo.js',
      widgets: __dirname + '/src/widgets.js',
    },
    output: {
      path: __dirname + '/public',
      filename: '[name].js'
    },
    devtool: mode == 'development' ? 'eval-source-map' : false,
    devServer: {
      static: {
        directory: __dirname + '/public',
      },
      compress: true,
      port: 4000,
    },
    module: {
      rules: [
        {
          test: /\.riot$/,
          exclude: /node_modules/,
          use: [
            {
              loader: 'babel-loader',
              options: {
                presets: ['@babel/preset-env']
              },
            },{
              loader: '@riotjs/webpack-loader',
              options: {
                hot: true, // set it to true if you are using hmr
                // add here all the other @riotjs/compiler options riot.js.org/compiler
                // template: 'pug' for example
            }
          }]
        }, {
          test: /\.s[ac]ss$/i,
          use: [
            'style-loader',
            {
              loader: 'css-loader',
              options: {url: false}
            },
            'sass-loader',
          ]
        }, {
          test: /\.m?js$/,
          exclude: /node_modules/,
          use: {
            loader: 'babel-loader',
            options: {
              presets: ['@babel/preset-env']
            }
          }
        }
      ]
    }
  }
}
