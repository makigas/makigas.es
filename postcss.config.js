module.exports = {
  syntax: require("postcss-scss"),
  plugins: [
    require("postcss-nested").default,
    require("postcss-import"),
    require("postcss-advanced-variables"),
  ],
};
