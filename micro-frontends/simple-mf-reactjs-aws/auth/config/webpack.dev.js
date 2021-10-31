const { merge } = require('webpack-merge');

const HtmlWebpackPlugin = require('html-webpack-plugin')
const ModuleFederationPlugin = require('webpack/lib/container/ModuleFederationPlugin')
const commonConfig = require('./webpack.default.js')

const devConfig = {
    mode: 'development',
    output: { 
        publicPath: "http://localhost:8079/"
    },       
    devServer: {
        port: 8079,
        historyApiFallback: {
            index: 'http://localhost:8079/index.html'
        }
    },
    plugins: [
        new HtmlWebpackPlugin({
            template: './public/index.html'
        }),
        new ModuleFederationPlugin({
            name: 'auth',
            filename: 'remoteEntry.js',
            exposes: {
                './AuthApp': './src/bootstrap'
            },
            shared: ['react', 'react-dom']
        }),
    ]
}

module.exports = merge(commonConfig, devConfig)