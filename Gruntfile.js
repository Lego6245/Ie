grunfs = require('fs');
grunt = require('grunt');
grunt.loadNpmTasks('grunt-coffeelint-cjsx');
grunt.loadNpmTasks('grunt-contrib-uglify');
grunt.loadNpmTasks('grunt-contrib-watch');
grunt.loadNpmTasks('grunt-sass');
grunt.loadNpmTasks('grunt-concurrent');
grunt.loadNpmTasks('grunt-browserify');
grunt.loadNpmTasks('grunt-exorcise');

// in order to maintain short compilation times in the final output, the
// source files are grouped into 2 bundles:
//   - bundle (for application behavior code)
//   - bundle_lib (for library files)

// coffeescript targets
coffeescript_targets = {
  "js/.compilation_intermediates/stores.coffeebundle.js":
    "js/stores/*.cjsx",
  "js/.compilation_intermediates/actions.coffeebundle.js":
    "js/actions/*.cjsx",
  "js/.compilation_intermediates/components.coffeebundle.js":
    "js/components/*.cjsx"
}

js_bundle_targets = [
  "js/.compilation_intermediates/init.js",
  "js/.compilation_intermediates/*.coffeebundle.js"
]

module.exports = function(grunt) {
  grunt.initConfig({
    coffeelint: {
      sources: {
        options: {
          configFile: 'coffeelint.json'
        },
        files: {
          src: ['js/*.cjsx', 'js/*/*.cjsx']
        }
      }
    },

    browserify: {
      lib: {
        files:{
          'js/.compilation_intermediates/bundle_lib.js':
            "js/lib.js"}},

      sources: {
        options: {
          browserifyOptions:{
            "transform": "coffee-reactify",
            "extension": "cjsx",
            "debug": true
          },
          keepAlive: true,
          watch: true
        },
        files:{
          'www/js/bundle_sources.js':
            "js/init.cjsx"}}
    },

    // excorcising (extracting the source map from) the bundle
    exorcise:{
      bundle_sources:{
        files: {
          "www/js/bundle_sources.js.map":
            ["www/js/bundle_sources.js"]
        }
      }
    },

    // uglifying (mangling and minifying) scripts
    uglify: {
      bundle_lib: {
        files: {'www/js/bundle_lib.min.js':
          'js/.compilation_intermediates/bundle_lib.js'},
      },

      bundle_sources: {
        options: {
          sourceMap: true,
          sourceMapIncludeSources: true,
          sourceMapIn: "www/js/bundle_sources.js.map"
        },
        files: {"www/js/bundle_sources.js":
          'www/js/bundle_sources.min.js'},
      }
    },

    sass: {
      options: {
        style: 'compressed',
        update: true
      },
      index: {
        files:{
          'www/css/index.css': 'css/index.scss'
        }
      }
    },

    concurrent: {
      precompile: [
        "precompile_lib",
        "precompile_styles"
      ],
      watch_working_sources: {
        options: {
          logConcurrentOutput: true,
        },
        tasks: [
          "browserify:sources",
          "watch:process_browserify_bundle",
          "watch:precompile_styles",
        ]
      }
    },

    // watch changes in init.cjsx and modules
    watch: {
      precompile_styles: {
        files: ["css/*.scss", 
                "css/components/*.scss", 
                "css/widgets/*.scss"],
        tasks: ["precompile_styles"]
      },
      process_browserify_bundle: {
        files: ["js/.compilation_intermediates/bundle_sources.js"],
        tasks: ["exorcise:bundle_sources"] //, "uglify:bundle_sources"]
      }
    }

  });


  grunt.registerTask(
    'precompile_lib',
    ['browserify:lib', 'uglify:bundle_lib']);

  grunt.registerTask('precompile_styles', ['sass:index']);

  grunt.registerTask('dev',
    ['concurrent:precompile', 'concurrent:watch_working_sources']);

  grunt.registerTask('lint', ['coffeelint:sources']);

  grunt.registerTask('default', ['concurrent:precompile']);

};
