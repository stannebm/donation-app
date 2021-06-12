import { ChakraProvider } from "@chakra-ui/react";
import React from "react";
import { BrowserRouter, Route, Switch } from "react-router-dom";
import MassOffering from "./pages/mass-offering";
import Donation from "./pages/donation";
// import Login from "./pages/login";
import theme from "./theme";

function Routes() {
  return (
    <BrowserRouter>
      <Switch>
        <Route exact path="/">
          <MassOffering />
        </Route>

        <Route exact path="/donation">
          <Donation />
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
