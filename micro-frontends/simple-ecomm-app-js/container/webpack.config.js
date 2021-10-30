const HtmlWebpackPlugin = require('html-webpack-plugin')
const ModuleWebpackPlugin = require('webpack/lib/container/ModuleFederationPlugin')
module.exports = {
    mode: 'development',
    devServer: {
        port: 5556
    },
    plugins: [
        new HtmlWebpackPlugin({
            template:'./public/index.html'
        }),
        new ModuleWebpackPlugin({
            name: 'container',
            remotes: {
                products: 'products@http://localhost:5555/remoteEntry.js',
                cart: 'cart@http://localhost:5554/remoteEntry.js'
            },
        })
    ]
}