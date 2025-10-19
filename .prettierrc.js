module.exports = {
  printWidth: 120,
  trailingComma: 'all',
  overrides: [
    {
      files: '**/*.md',
      options: {
        printWidth: 72,
        proseWrap: 'always',
      },
    },
  ],
};
