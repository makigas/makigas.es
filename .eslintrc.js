module.exports = {
  env: {
    es6: true,
    node: true,
    browser: true,
  },
  parserOptions: {
    parser: "espree",
    sourceType: "module",
    ecmaVersion: 2022,
  },
  extends: ["eslint:recommended", "plugin:prettier/recommended"],
};
