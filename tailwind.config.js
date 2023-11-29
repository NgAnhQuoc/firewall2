const plugin = require("tailwindcss/plugin");

module.exports = {
  prefix: "vf-",
  mode: "jit",
  important: true,
  purge: true,

  darkMode: false,

  theme: {
    extend: {
      boxShadow: {
        card: "0px 4px 10px rgba(30, 70, 117, 0.05)",
      },
      borderRadius: {
        DEFAULT: "4px",
      },
      borderColor: {
        DEFAULT: "#EBEBF0",
      },
      colors: {
        primary: "#38A7FF",
        secondary: "#828282",
        gray: {
          1: "#333333",
          2: "#4F4F4F",
          3: "#828282",
          4: "#BDBDBD",
        },
      },
      flexGrow: {
        2: "2",
        3: "3",
      },
    },
  },

  content: [
    "./UI/**/*.tpl"
  ],

  plugins: [
    plugin(function ({ addUtilities }) {
      const newUtilities = {
        ".center": {
          display: "flex",
          "justify-content": "center",
          "align-items": "center",
        },
      };

      addUtilities(newUtilities);
    }),
  ],
};
