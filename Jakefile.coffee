# general purpose imports
fs = require("fs")
glob = require("glob").sync
union = require("lodash").union;
watch = require("node-watch")

# imports for building browserify bundle
browserifyInc  = require("browserify-incremental")
parcelify      = require("parcelify")
coffeeReactify = require("coffee-reactify")
source         = require('vinyl-source-stream')


# constants
BUILD_DIR = "www"
SOURCE_BUNDLE = BUILD_DIR + "/js/bundle_sources.js"
DEPS = union glob("src/**/*.cjsx"),
             glob("src/*/*.cjsx"),
             glob("src/**/*.scss"),
             glob("src/*.scss")
INTERMEDIATES = ".build_intermediates"



desc 'build the source and scss files'
task 'default', [SOURCE_BUNDLE], () ->
    return


# TODO set up some kind of mutex to prevent overlapping builds
desc 'rebuild the default task on source change'
task 'dev', ['default'], ()->
    collectedFiles = []
    buildTimer = undefined

    buildDefault = ->
        buildTimer = undefined
        process.stdout.write " => "
        jake.Task['forcebuild'].execute()

    requestBuild = (fname) ->
        if buildTimer?
            clearTimeout buildTimer
            process.stdout.write "\n"

        process.stdout.write "(\u0394 #{fname})"
        buildTimer = setTimeout buildDefault, 100

    console.log "watching 'src/' for changes.."

    watch "src", requestBuild



desc 'build the source in debug mode'
file SOURCE_BUNDLE, DEPS, () ->
    jake.Task['forcebuild'].execute()

desc 'this creates the intermediates directory'
directory INTERMEDIATES

desc 'forcefully build the task'
task 'forcebuild', [INTERMEDIATES], () ->
    console.log "building in debug mode"
    buildEngine = browserifyInc({
        cacheFile: INTERMEDIATES + "/browserifyinc"
        paths:["src"]
        extensions: ["cjsx"]
        debug: true
        transforms: [ "sass-css-stream" ]
        entries: ["./src/init.cjsx"]
    })

    # provide entry points for cjsx files
    buildEngine.transform(coffeeReactify)

    # have sassify create index.css separate from the main bundle file
    p = parcelify(
        buildEngine,
        {
            bundles:
                style: "www/css/index.css"
            maps: true
            appTransforms: [
                (file) ->
                    sassCssStream(file, { includePaths: ['src']})
            ]
        })

    # build and write the bundle
    writeStream = fs.createWriteStream(SOURCE_BUNDLE, {flags: 'a'})
        .on('finish', ()->
            console.log 'build finished')

    bundleReadStream = buildEngine.bundle()
    bundleReadStream.pipe(writeStream)




desc 'remove built files and intermediates'
task 'clean', () ->
    remove = (globstring) ->
        console.log globstring
        glob(globstring).forEach((path) ->
            console.log("    removing #{path}");
            fs.unlink(path, (err) ->
                if (err)
                    console.log "error deleting file", path, "\n", err
            )
        )

    remove(BUILD_DIR + "/js/*.js")
    remove(INTERMEDIATES + "/*")
