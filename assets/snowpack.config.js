// Snowpack Configuration File
// See all supported options: https://www.snowpack.dev/reference/configuration

/** @type {import("snowpack").SnowpackUserConfig } */
module.exports = {
  mount: {
    js: { url: '/js' },
    css: { url: '/css' },
    static: { url: '/', static: true, resolve: false },
  },
  plugins: [
    '@snowpack/plugin-react-refresh', // keep react state after HMR reload
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
