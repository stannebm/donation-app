// This file is the main entry point of phoenix

// I am not sure whether it it still needed in SPA context
// import "phoenix_html"

import React from 'react';
import ReactDOM from 'react-dom';
import App from './App.jsx';


ReactDOM.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
  document.getElementById('root'),
);

// Hot Module Replacement (HMR) - Remove this snippet to remove HMR.
// Learn more: https://www.snowpack.dev/concepts/hot-module-replacement
if (import.meta.hot) {
  import.meta.hot.accept();
}
