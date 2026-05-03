import js from "@eslint/js";
import importPlugin from "eslint-plugin-import";
import vue from "eslint-plugin-vue";
import globals from "globals";

export default [
  {
    ignores: [
      "**/node_modules/**",
      "**/dist/**",
      "**/build/**",
      "*.min.js",
      "vite.config.js",
    ],
  },
  {
    languageOptions: {
      globals: globals.browser,
    },
  },
  js.configs.recommended,

  ...vue.configs["flat/recommended"],

  {
    plugins: {
      import: importPlugin,
    },

    rules: {
      "vue/multi-word-component-names": "off",
      "vue/html-indent": ["error", 2],
      "vue/max-attributes-per-line": [
        "warn",
        {
          singleline: 3,
          multiline: 1,
        },
      ],
      "vue/html-self-closing": [
        "error",
        {
          html: {
            void: "always",
            normal: "never",
            component: "always",
          },
        },
      ],
      "vue/attribute-hyphenation": ["error", "never"],
      "object-curly-spacing": ["error", "always"],

      "no-console": "warn",

      "import/order": [
        "error",
        {
          groups: [
            "builtin",
            "external",
            "internal",
            ["parent", "sibling", "index"],
          ],
          pathGroups: [
            {
              pattern: "@/helper/constants",
              group: "internal",
              position: "before",
            },
          ],
          pathGroupsExcludedImportTypes: ["builtin"],
          "newlines-between": "never",
          alphabetize: {
            order: "asc",
            caseInsensitive: true,
          },
        },
      ],
      "import/newline-after-import": "error",
    },
  },
];
