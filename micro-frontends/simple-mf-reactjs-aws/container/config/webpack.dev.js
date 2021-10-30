const { merge } = require('webpack-merge');

const commonConfig = require('./webpack.default.js')
const ModuleFederationPlugin = require('webpack/lib/container/ModuleFederationPlugin')

const devConfig = {
    mode: 'development',
    devServer: {
        port: 8081,
        historyApiFallback: {
            index: 'index.html'
        }
    },
    plugins: [
        new ModuleFederationPlugin({
            name: 'container',
            remotes: {
                home: 'home@http://localhost:8080/remoteEntry.js'
            },
            shared: ['react', 'react-dom']
        }),
    ]
}

module.exports = merge(commonConfig, devConfig)