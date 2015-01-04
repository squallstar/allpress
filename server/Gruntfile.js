module.exports = function(grunt) {
  grunt.initConfig({
    concat: {
      website: {
        src: [
          'js/website/vendor/jquery.js',
          'js/website/app.js'
        ],
        dest: 'public/js/website.js',
      }
    },
    cssmin: {
      options: {
        banner: '/* 2015(C) Example.org */'
      },
      combine: {
        files: {
          'public/css/website.css': ['public/css/website.css']
        }
      }
    },
    sass: {
      dist: {
        files: {
          'public/css/website.css' : 'sass/website/index.scss'
        }
      }
    },
    uglify: {
      dist: {
        files: {
          'public/js/website.js': ['public/js/website.js']
        }
      }
    },
    watch: {
      sass: {
        files: ['sass/**/*.scss'],
        tasks: ['sass']
      },
      js: {
        files: ['js/**/*.js'],
        tasks: ['concat']
      }
    }
  });

  grunt.loadNpmTasks('grunt-sass');
  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadNpmTasks('grunt-contrib-cssmin');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-watch');

  grunt.registerTask('precompile', ['sass', 'concat', 'cssmin', 'uglify']);
  grunt.registerTask('default', ['sass', 'concat', 'watch']);
};