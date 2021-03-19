import React from "react";
import {
  BrowserRouter,
  Route, Switch
} from "react-router-dom";
import Home from "./pages/home";



function Routes() {
  return (
    <BrowserRouter>
      <Switch>
        <Route path="/">
          <Home />
        </Route>
      </Switch>
    </BrowserRouter>
  );
}

function App() {
  return (
    <>
      <Routes />
    </>
  );
}

export default App;
