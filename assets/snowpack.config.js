// Snowpack Configuration File
// See all supported options: https://www.snowpack.dev/reference/configuration

/** @type {import("snowpack").SnowpackUserConfig } */
module.exports = {
  mount: {
    css: { url: '/css' },
    js: { url: '/js' },
    public: { url: '/', static: true },
  },
  plugins: [
    '@snowpack/plugin-typescript',
  ],
  packageOptions: {
    /* ... */
  },
  devOptions: {
    /* ... */
  },
  buildOptions: {
    out: '../priv/static/',
  },
};
