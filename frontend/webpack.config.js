const dotenv = require('dotenv')
const webpack = require('webpack')
const HtmlWebpackPlugin = require('html-webpack-plugin')
const path = require('path')

module.exports = (env, argv) => {
  const mode = argv.mode || 'development'
  if (mode == 'production') {
    dotenv.config({path: '.env.production'})
  }
  dotenv.config({path: '.env'})
  const useSsl = (process.env.USE_SSL == 'true')

  return {
    mode: mode,
    entry: {
      app: __dirname + '/src/app.js',
      standalone: __dirname + '/src/standalone.js'
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
      hot: false,
      https: useSsl,
      headers: {
        'ACCESS-CONTROL-ALLOW-ORIGIN': 'https://dfk-paris.org'
      },
      client: {
        webSocketURL: `${process.env.STATIC_URL}/ws`,
      },
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
                // hot: true, // set it to true if you are using hmr
                // add here all the other @riotjs/compiler options riot.js.org/compiler
                // template: 'pug' for example
            }
          }]
        }, {
          test: /\.css$/i,
          use: [
            'style-loader',
            {
              loader: 'css-loader',
              options: {url: false}
            }
          ]
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
    },
    plugins: [
      new webpack.DefinePlugin({
        apiUrl: JSON.stringify(process.env.API_URL),
        staticUrl: JSON.stringify(process.env.STATIC_URL),
        iiifViewerUrl: JSON.stringify(process.env.IIIF_VIEWER_URL)
      }),
      new HtmlWebpackPlugin({
        template: 'frontend/src/index.ejs',
        filename: 'index.html',
        meta: {
          'viewport': 'width=device-width, initial-scale=1',
        },
        'hash': true,
        'chunks': ['standalone']
      })
    ]
  }
}
