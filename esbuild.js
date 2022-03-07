const { sassPlugin } = require('esbuild-sass-plugin');

require('esbuild').build({
    entryPoints: [
      "app/javascript/packs/app.js",
      "app/javascript/packs/six.js",
      "app/javascript/packs/vendor.js",
    ],
    bundle: true,
    sourcemap: true,
    outdir: "app/assets/builds",
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
