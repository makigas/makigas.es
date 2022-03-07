const { sassPlugin } = require('esbuild-sass-plugin');

require('esbuild').build({
    entryPoints: [
      "app/javascript/packs/app.js",
      "app/javascript/packs/six.js",
      "app/javascript/packs/vendor.js",
    ],
    bundle: true,
    sourcemap: true,
    watch: process.argv.indexOf('--watch') > -1 || process.argv.indexOf('-w') > -1,
    logLevel: 'info',
    outdir: "app/assets/builds",
    target: ['firefox57'],
    platform: 'browser',
    loader: {
      '.png': 'file',
      '.svg': 'file',
      '.woff': 'file',
      '.woff2': 'file',
      '.eot': 'file',
      '.ttf': 'file',
    },
    plugins: [sassPlugin()]
});
