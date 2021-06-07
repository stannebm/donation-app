import { ChakraProvider } from "@chakra-ui/react";
import React from "react";
import { BrowserRouter, Route, Switch } from "react-router-dom";
import Home from "./pages/home";
// import Login from "./pages/login";
import theme from "./theme";

function Routes() {
  return (
    <BrowserRouter>
      <Switch>
        <Route exact path="/">
          <Home />
        </Route>
        {/* <Route path="/admins/login"> */}
        {/*   <Login /> */}
        {/* </Route> */}
      </Switch>
    </BrowserRouter>
  );
}

function App() {
  return (
    <ChakraProvider theme={theme}>
      <Routes />
    </ChakraProvider>
  );
}

export default App;
