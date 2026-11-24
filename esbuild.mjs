import * as esbuild from "esbuild";
import postcss from "esbuild-postcss";

const options = {
  entryPoints: ["app/javascript/packs/dashboard.js", "app/javascript/packs/six.js", "app/javascript/packs/seven.js"],
  bundle: true,
  logLevel: "info",
  outdir: "app/assets/builds",
  minify: process.env.NODE_ENV == "production",
  sourcemap: process.env.NODE_ENV != "production",
  target: ["es2020"],
  platform: "browser",
  loader: {
    ".jpg": "file",
    ".png": "file",
    ".svg": "file",
    ".woff": "file",
    ".woff2": "file",
    ".eot": "file",
    ".ttf": "file",
  },
  plugins: [postcss()],
};

if (process.argv.includes("--watch") || process.argv.includes("-w")) {
  const ctx = await esbuild.context(options);
  await ctx.watch();
} else {
  await esbuild.build(options);
}
