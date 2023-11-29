const mix = require("laravel-mix");
require("laravel-mix-versionhash");

const fs = require("fs");
const tailwindcss = require("tailwindcss");

mix.setPublicPath("./");
mix.disableNotifications();

mix.browserSync({
  port: 3005,
  proxy: "https://dev.vietnix.vn/",
  injectChanges: false,
  ui: false,
  open: false,
  files: [
    "./UI/Admin/**/*.css",
    "./UI/Admin/**/*.js",
    "./UI/Client/**/*.css",
    "./UI/Client/**/*.js",
    {
      match: [
        "./UI/**/*.tpl"
      ],
      fn: function (event, file) {
        var result = "//___zzzzzz___";
        fs.writeFile("./UI/Client/assets/scss/trigger.scss", result, "utf8", function (
          err
        ) {
          if (err) return console.log(err);
        });
      },
    },
  ],
});

// admin
mix.js("UI/Admin/assets/js/app.js", "UI/Public/js/admin.js");
mix.sass("UI/Admin/assets/scss/index.scss", "UI/Public/css/admin.css").options({
  processCssUrls: false,
  postCss: [tailwindcss("./tailwind.config.js")],
});


// client
mix.js("UI/Client/assets/js/client.js", "UI/Public/js/client.js");
mix.sass("UI/Client/assets/scss/client.scss", "UI/Public/css/client.css").options({
  processCssUrls: false,
  postCss: [tailwindcss("./tailwind.config.js")],
});

if (mix.inProduction()) {
  mix.versionHash();
  mix.sourceMaps();
}
