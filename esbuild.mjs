import * as esbuild from "esbuild";
import postcss from "esbuild-postcss";

const options = {
  entryPoints: ["app/javascript/packs/dashboard.js", "app/javascript/packs/six.js"],
  bundle: true,
  sourcemap: true,
  logLevel: "info",
  outdir: "app/assets/builds",
  target: ["es2020"],
  platform: "browser",
  loader: {
    ".png": "file",
    ".svg": "file",
    ".woff": "file",
    ".woff2": "file",
    ".eot": "file",
    ".ttf": "file",
  },
  plugins: [postcss()],
};

if (process.argv.indexOf("--watch") > -1 || process.argv.indexOf("-w") > -1) {
  const ctx = await esbuild.context(options);
  await ctx.watch();
} else {
  await esbuild.build(options);
}
