ExtractTextPlugin = require('extract-text-webpack-plugin');
webpack = require('webpack');
path = require('path');

module.exports =
    # The standard entry point and output config
    entry: './src/init'
    output:
        path: 'www'
        filename: '[name].bundle.js'
        chunkFilename: '[id].chunk.js'
    resolve:
        extensions: ['', '.webpack.js', '.web.js', '.js', '.cjsx']
        modulesDirectories: ["src", "node_modules"]
    plugins: [ new webpack.HotModuleReplacementPlugin() ]
    devtool: ["source-map"]
    module:
        loaders: [
            {   
                test: /\.cjsx$/
                loader: 'coffee!cjsx'
            },
            # Optionally extract less files
            # or any other compile-to-css language
            {   
                test: /\.scss$/
                loader: ExtractTextPlugin.extract(
                    'style-loader',
                    'css-loader!sass-loader')
            }
        ]
    # Use the plugin to specify the resulting filename
    # (and add needed behavior to the compiler)
    plugins: [ new ExtractTextPlugin('[name].css') ]
