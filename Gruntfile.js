module.exports = function(grunt) {
    grunt.initConfig({
        pkg: grunt.file.readJSON('src/package.json'),
        nodewebkit: {
            options: {
                // build_dir: './dist',
                build_dir: '/home/caribou/Documents/Builds/node',
                // specifiy what to build
                mac: false,
                win: false,
                linux32: true,
                linux64: false
            },
            src: './src/**/*'
        },
        // exec: {
          // cmd: 'D:\\node-webkit-v0.10.0-win-ia32\\myproject\\dist\\releases\\nw-demo\\win\\nw-demo\\nw-demo.exe'
          // cmd: 'D:\\node-webkit-v0.10.0-win-ia32\\myproject\\dist\\releases\\nw-demo\\win\\nw-demo\\nw-demo.exe'
        // }
    });

    // grunt.loadNpmTasks('grunt-exec');
    grunt.loadNpmTasks('grunt-node-webkit-builder');
    // grunt.registerTask('default', ['nodewebkit', 'exec']);
    grunt.registerTask('default', ['nodewebkit']);

};