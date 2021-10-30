const { merge } = require('webpack-merge');

const ModuleFederationPlugin = require('webpack/lib/container/ModuleFederationPlugin')
const commonConfig = require('./webpack.default.js')
const packageDependencies = require('../package.json');

const domain = process.env.PROD_DOMAIN;

const prodConfig = {
    mode: 'production',
    output: {
        filename: '[name].[contenthash].js'
    },
    plugins: [
        new ModuleFederationPlugin({
            name: 'container',
            remotes: {
                home: `home@${domain}/home/remoteEntry.js`
            },
            shared: packageDependencies.dependencies
        })
    ]
}

module.exports = merge(commonConfig, prodConfig)