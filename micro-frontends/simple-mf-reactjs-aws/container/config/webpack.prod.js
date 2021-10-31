const { merge } = require('webpack-merge');

const ModuleFederationPlugin = require('webpack/lib/container/ModuleFederationPlugin')
const commonConfig = require('./webpack.default.js')
const packageDependencies = require('../package.json');

const domain = process.env.PROD_DOMAIN;

const prodConfig = {
    mode: 'production',
    output: {
        filename: '[name].[contenthash].js',
        publicPath: '/container/latest/'
    },
    plugins: [
        new ModuleFederationPlugin({
            name: 'container',
            remotes: {
                home: `home@${domain}/home/latest/remoteEntry.js`,
                auth: `auth@${domain}/auth/latest/remoteEntry.js`
            },
            shared: packageDependencies.dependencies
        })
    ]
}

module.exports = merge(commonConfig, prodConfig)