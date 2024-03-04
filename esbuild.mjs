import * as esbuild from "esbuild";
import postcss from "esbuild-postcss";
import Watcher from "watcher";

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

await esbuild.build(options);

if (process.argv.indexOf("--watch") > -1 || process.argv.indexOf("-w") > -1) {
  const watcher = new Watcher(["app/components", "app/views"], {
    recursive: true,
    ignoreInitial: true,
  });

  const ctx = await esbuild.context(options);
  console.log("Ready to trigger again");
  watcher.on("all", (e) => {
    ctx.rebuild();
  });
}
