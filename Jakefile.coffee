# general purpose imports
fs = require("fs")
glob = require("glob").sync
union = require("lodash").union;
watch = require("node-watch")

# imports for building browserify bundle
browserifyInc  = require("browserify-incremental")
sassify        = require("sassify")
coffeeReactify = require("coffee-reactify")
source         = require('vinyl-source-stream')


# constants
BUILD_DIR = "www"
SOURCE_BUNDLE = BUILD_DIR + "/js/bundle_sources.js"
STYLE_BUNDLE  = BUILD_DIR + "/css/index.css"
DEPS = union glob("js/**/*.cjsx"),
             glob("js/*/*.cjsx"),
             glob("css/**/*.scss"),
             glob("css/*.scss")
INTERMEDIATES = ".build_intermediates"



desc 'build the source and scss files'
task 'default', [SOURCE_BUNDLE], () ->
    return


# TODO set up some kind of mutex to prevent overlapping builds
desc 'rebuild the default task on source change'
task 'dev', ['default'], ()->
    buildDefault = (fname) ->
        if not buildLocked
            buildLocked = true
            process.stdout.write "(\u0394 #{fname}) => "
            jake.Task['force-build'].execute()

    console.log "watching 'js/' and 'css/' for changes.."

    watch "js", buildDefault
    watch "css", buildDefault



desc 'build the source in debug mode'
file SOURCE_BUNDLE, DEPS, () ->
    jake.Task['force-build'].execute()

desc 'forcefully build the task'
task 'force-build', () ->
    console.log "building in debug mode"
    buildEngine = browserifyInc({
        cacheFile: INTERMEDIATES,
        extensions: ["cjsx", "scss"],
        baseDir: "js/",
        paths:["../node_modules"]
    })

    # provide entry points for cjsx files
    buildEngine.transform(coffeeReactify)

    # have sassify create index.css separate from the core
    # browserify bundle
    buildEngine.transform(sassify, {
        "auto-inject": false,
        "write-path": "www/css/index.css",
        sourceMap: true
    })

    # add the entry point
    buildEngine.add './js/init.cjsx'

    # build and write the bundle
    writeStream = 
        fs.createWriteStream(SOURCE_BUNDLE, {flags: 'a'})
            .on('finish', ()->
                console.log 'build finished')

    bundleReadStream = buildEngine.bundle()
    bundleReadStream.pipe(writeStream)



desc 'remove built files and intermediates'
task 'clean', () ->
    remove = (globstring) ->
        glob(globstring).forEach((path) ->
            fs.unlink(path, (err) ->
                if (err)
                    console.log "error deleting file", path, "\n", err
            )
        )

    remove(BUILD_DIR + "/js/*.js")
    remove(BUILD_DIR + "/css/*.css")
    remove(INTERMEDIATES + "/*")
