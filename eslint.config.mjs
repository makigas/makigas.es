import js from "@eslint/js";
import globals from "globals";
import eslintPluginPrettierRecommended from "eslint-plugin-prettier/recommended";

export default [
  {
    files: ["**/*.js"],
    languageOptions: {
      ecmaVersion: 2022,
      sourceType: "module",
      globals: {
        ...globals.browser,
        ...globals.node,
      },
    },
  },
  js.configs.recommended,
  eslintPluginPrettierRecommended,
];
